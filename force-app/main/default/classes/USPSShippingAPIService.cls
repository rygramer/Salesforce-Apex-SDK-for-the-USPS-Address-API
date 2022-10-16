public with sharing class USPSShippingAPIService {
    private List<USPSRequest> requests;
    public List<USPSResponse> responses = new List<USPSResponse>();

    private final Map<String,String> CLASS_MAPPING = new Map<String,String>{
        'USPSVerifyAddressRequest' => 'USPSShippingAPIService.Verify',
        'USPSZipCodeLookupRequest' => 'USPSShippingAPIService.ZipCodeLookup',
        'USPSCityStateLookupRequest' => 'USPSShippingAPIService.CityStateLookup'
    };
    private Type apiClass;

    private String revision = '0';

    public USPSShippingAPIService(List<USPSRequest> requests){
        this.requests = requests;
        this.apiClass = Type.forName(CLASS_MAPPING.get(requests.get(0).getName()));
    }

    public USPSShippingAPIService(USPSRequest request){
        this(new List<USPSRequest>{request});
    }

    public USPSShippingAPIService setReturnAllData(){
        this.revision = '1';
        return this;
    }

    public List<USPSResponse> send(){
        Map<Integer,List<USPSRequest>> batchedRequests = this.batchRequests();

        for(Integer batchIteration : batchedRequests.keySet()){
            USPSShippingAPI api = (USPSShippingAPI)apiClass.newInstance();
            api.setService(this);
            api.setBatch(batchedRequests.get(batchIteration));
            api.send();
        }
        
        return this.responses;
    }

    private Map<Integer,List<USPSRequest>> batchRequests(){
        Map<Integer,List<USPSRequest>> batchedRequests = new Map<Integer,List<USPSRequest>>();

        Integer batchIteration = 0;
        Integer loopCounter = 1;
        for(USPSRequest USPSRequest : requests){
            if(batchedRequests.get(batchIteration) == null) batchedRequests.put(batchIteration,new List<USPSRequest>());

            batchedRequests.get(batchIteration).add(USPSRequest);

            loopCounter++;

            if(loopCounter == 5){
                batchIteration++;
                loopCounter = 1;
            } 
        }

        return batchedRequests;
    }

    private abstract class USPSShippingAPI{
        private USPSShippingAPIService service;
        private List<USPSRequest> requestBatch;
        private Dom.Document requestXML;
        private Dom.Document responseXML;
        protected final String USERID = USPS_Shipping_API_Settings__c.getInstance().USPS_Username__c;
        
        private String endPoint;
        private String rootTag;
        private String parentTag;

        public USPSShippingAPI setService(USPSShippingAPIService service){
            this.service = service;
            return this;
        }

        public USPSShippingAPI setBatch(List<USPSRequest> requestBatch){
            this.requestBatch = requestBatch;
            return this;
        }
        
        public USPSShippingAPI send(){
            this.writeXML();
            String xml = EncodingUtil.urlEncode(this.requestXML.toXmlString(), 'UTF-8');

            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:USPS_Shipping_API/'+ this.endPoint + xml);
            req.setMethod('GET');

            HttpResponse res = new HTTP().send(req);
            this.responseXML = res.getBodyDocument();

            this.readXML();
            
            return this;
        }

        private USPSShippingAPI processChildNodes(Dom.XmlNode parentNode, String tagName){
            Integer counter = 0;
            for(USPSRequest uspsAddress : this.requestBatch){
                Dom.XmlNode xml = parentNode.addChildElement(tagName, null, null);
                xml.setAttribute('ID', String.valueOf(counter));

                uspsAddress.writeXML(xml);

                counter++;
            }
            return this;
        }

        private abstract USPSShippingAPI writeXML();

        private USPSShippingAPI readXML(){
            Dom.XmlNode responseRoot = this.responseXML.getRootElement();

            if(responseRoot.getName() == 'Error') throw new USPSShippingAPIException(responseRoot.getChildElement('Description', null).getText());

            for(Dom.XmlNode xml : responseRoot.getChildElements()){
                this.service.responses.add(new USPSResponse(xml.getChildElements()));
            }

            return this;
        }
    }

    public class Verify extends USPSShippingAPI{
        public Verify(){
            this.endPoint = '?API=Verify&XML=';
            this.rootTag = 'AddressValidateRequest';
            this.parentTag = 'Address';
        }

        private override USPSShippingAPI writeXML(){
            this.requestXML = new Dom.Document();
        
            Dom.XmlNode root = this.requestXML.createRootElement(this.rootTag, null, null);
            root.setAttribute('USERID', this.USERID);
            root.addChildElement('Revision', null, null).addTextNode(this.service.revision);

            this.processChildNodes(root, this.parentTag);

            return this;
        }
    }

    public class ZipCodeLookup extends USPSShippingAPI{
        public ZipCodeLookup(){
            this.endPoint = '?API=ZipCodeLookup&XML=';
            this.rootTag = 'ZipCodeLookupRequest';
            this.parentTag = 'Address';
        }

        private override USPSShippingAPI writeXML(){
            this.requestXML = new Dom.Document();
        
            Dom.XmlNode root = this.requestXML.createRootElement(this.rootTag, null, null);
            root.setAttribute('USERID', this.USERID);

            this.processChildNodes(root, this.parentTag);

            return this;
        }
    }

    public class CityStateLookup extends USPSShippingAPI{
        public CityStateLookup(){
            this.endPoint = '?API=CityStateLookup&XML=';
            this.rootTag = 'CityStateLookupRequest';
            this.parentTag = 'ZipCode';
        }

        private override USPSShippingAPI writeXML(){
            this.requestXML = new Dom.Document();
        
            Dom.XmlNode root = this.requestXML.createRootElement(this.rootTag, null, null);
            root.setAttribute('USERID', this.USERID);

            this.processChildNodes(root, this.parentTag);

            return this;
        }
    }

    public class USPSShippingAPIException extends Exception{}
}
