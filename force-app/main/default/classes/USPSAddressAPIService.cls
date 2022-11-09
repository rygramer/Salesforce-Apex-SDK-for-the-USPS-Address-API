public with sharing class USPSAddressAPIService {
    private final Map<String,String> CLASS_MAPPING = new Map<String,String>{
        'USPSAddressValidateRequest' => 'USPSAddressAPIService.Validate',
        'USPSZipCodeLookupRequest' => 'USPSAddressAPIService.ZipCodeLookup',
        'USPSCityStateLookupRequest' => 'USPSAddressAPIService.CityStateLookup'
    };

    private String revision = '0';

    @TestVisible
    private static Map<String,USPS_Address_API_Setting__mdt> settings = USPS_Address_API_Setting__mdt.getAll();

    public USPSAddressAPIService setReturnAllData(){
        this.revision = '1';
        return this;
    }

    public USPSResponse send(USPSRequest request){
        return this.send(new List<USPSRequest>{request}).get(0);
    }

    public List<USPSResponse> send(List<USPSRequest> requests){
        USPSAddressAPI api = (USPSAddressAPI)Type.forName(CLASS_MAPPING.get(requests.get(0).getName())).newInstance();
        api.setRequests(requests);
        api.setRevision(this.revision);
        return api.send();
    }

    private abstract class USPSAddressAPI{
        protected final String USERID{
            get{
                USERID = settings.get('USPS_Username')?.Value__c;
                if(USERID == null) throw new USPSAddressAPIException('Your USPS Username must be configured. Navigate to the USPS Address API Setting Custom Metadata object. Open the USPS_Username record (if this record doesn\'t exist, create it). Complete the Value field with your USPS Username.');
                return USERID;
            }
            private set;
        }
        
        protected List<USPSRequest> allRequests;
        protected List<USPSRequest> currentRequests;
        protected Dom.Document requestXML;
        protected List<USPSResponse> responses = new List<USPSResponse>();
        protected Dom.Document responseXML;
        
        protected Integer batchLimit = 5;
        protected String url = 'https://secure.shippingapis.com/ShippingAPI.dll';
        protected String endPoint;
        protected String rootTag;
        protected String parentTag;

        protected String revision;

        public USPSAddressAPI setRequests(List<USPSRequest> allRequests){
            this.allRequests = allRequests;
            return this;
        }

        public USPSAddressAPI setRevision(String revision){
            this.revision = revision;
            return this;
        }
        
        public List<USPSResponse> send(){
            Map<Integer,List<USPSRequest>> batchedRequests = this.batchRequests();

            for(Integer batchIteration : batchedRequests.keySet()){
                this.currentRequests = batchedRequests.get(batchIteration);

                this.writeXML();
                String xml = EncodingUtil.urlEncode(this.requestXML.toXmlString(), 'UTF-8');

                HttpRequest req = new HttpRequest();
                req.setEndpoint(this.url + this.endPoint + xml);
                req.setMethod('GET');

                HttpResponse response = new HTTP().send(req);
                this.responseXML = response.getBodyDocument();

                this.readXML();
            }
            
            return this.responses;
        }

        private Map<Integer,List<USPSRequest>> batchRequests(){
            Map<Integer,List<USPSRequest>> batchedRequests = new Map<Integer,List<USPSRequest>>();
    
            Integer batchIteration = 0;
            Integer loopCounter = 1;
            for(USPSRequest request : this.allRequests){
                if(batchedRequests.get(batchIteration) == null) batchedRequests.put(batchIteration,new List<USPSRequest>());
    
                batchedRequests.get(batchIteration).add(request);
    
                loopCounter++;
    
                if(loopCounter == this.batchLimit){
                    batchIteration++;
                    loopCounter = 1;
                } 
            }
    
            return batchedRequests;
        }

        private abstract USPSAddressAPI writeXML();

        private USPSAddressAPI processChildNodes(Dom.XmlNode parent, String tagName){
            Integer counter = 0;
            for(USPSRequest request : this.currentRequests){
                Dom.XmlNode xml = parent.addChildElement(tagName, null, null);
                xml.setAttribute('ID', String.valueOf(counter));

                request.writeXML(xml);

                counter++;
            }
            return this;
        }

        private USPSAddressAPI readXML(){
            Dom.XmlNode root = this.responseXML.getRootElement();

            if(root.getName() == 'Error') throw new USPSAddressAPIException(root.getChildElement('Description', null).getText());

            for(Dom.XmlNode child : root.getChildElements()){
                this.responses.add(new USPSResponse(child.getChildElements()));
            }

            return this;
        }
    }

    public class Validate extends USPSAddressAPI{
        public Validate(){
            this.endPoint = '?API=Verify&XML=';
            this.rootTag = 'AddressValidateRequest';
            this.parentTag = 'Address';
        }

        private override USPSAddressAPI writeXML(){
            this.requestXML = new Dom.Document();
        
            Dom.XmlNode root = this.requestXML.createRootElement(this.rootTag, null, null);
            root.setAttribute('USERID', this.USERID);
            root.addChildElement('Revision', null, null).addTextNode(this.revision);

            this.processChildNodes(root, this.parentTag);

            return this;
        }
    }

    public class ZipCodeLookup extends USPSAddressAPI{
        public ZipCodeLookup(){
            this.endPoint = '?API=ZipCodeLookup&XML=';
            this.rootTag = 'ZipCodeLookupRequest';
            this.parentTag = 'Address';
        }

        private override USPSAddressAPI writeXML(){
            this.requestXML = new Dom.Document();
        
            Dom.XmlNode root = this.requestXML.createRootElement(this.rootTag, null, null);
            root.setAttribute('USERID', this.USERID);

            this.processChildNodes(root, this.parentTag);

            return this;
        }
    }

    public class CityStateLookup extends USPSAddressAPI{
        public CityStateLookup(){
            this.endPoint = '?API=CityStateLookup&XML=';
            this.rootTag = 'CityStateLookupRequest';
            this.parentTag = 'ZipCode';
        }

        private override USPSAddressAPI writeXML(){
            this.requestXML = new Dom.Document();
        
            Dom.XmlNode root = this.requestXML.createRootElement(this.rootTag, null, null);
            root.setAttribute('USERID', this.USERID);

            this.processChildNodes(root, this.parentTag);

            return this;
        }
    }

    public class USPSAddressAPIException extends Exception{}
}