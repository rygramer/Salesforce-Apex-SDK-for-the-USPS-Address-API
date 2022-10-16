public with sharing class USPSShippingAPIService {
    private List<USPSAddressRequest> uspsAddressRequests;
    public List<USPSAddressResponse> uspsAddressResponses = new List<USPSAddressResponse>();

    private final Map<String,String> CLASS_MAPPING = new Map<String,String>{
        'USPSVerifyAddressRequest' => 'USPSShippingAPIService.Verify',
        'USPSZipCodeLookupRequest' => 'USPSShippingAPIService.ZipCodeLookup',
        'USPSCityStateLookupRequest' => 'USPSShippingAPIService.CityStateLookup'
    };
    private Type apiClass;

    private String revision = '0';

    public USPSShippingAPIService(List<USPSAddressRequest> uspsAddressRequests){
        this.uspsAddressRequests = uspsAddressRequests;
        this.apiClass = Type.forName(CLASS_MAPPING.get(uspsAddressRequests[0].getName()));
    }

    public USPSShippingAPIService(USPSAddressRequest uspsAddress){
        this(new List<USPSAddressRequest>{uspsAddress});
    }

    public USPSShippingAPIService setReturnAllData(){
        this.revision = '1';
        return this;
    }

    public List<USPSAddressResponse> send(){
        Map<Integer,List<USPSAddressRequest>> batchedRequests = this.batchRequests();

        for(Integer batchIteration : batchedRequests.keySet()){
            USPSShippingAPI api = (USPSShippingAPI)apiClass.newInstance();
            api.setService(this);
            api.setBatch(batchedRequests.get(batchIteration));
            api.send();
        }
        
        return this.uspsAddressResponses;
    }

    private Map<Integer,List<USPSAddressRequest>> batchRequests(){
        Map<Integer,List<USPSAddressRequest>> batchedRequests = new Map<Integer,List<USPSAddressRequest>>();

        Integer batchIteration = 0;
        Integer loopCounter = 1;
        for(USPSAddressRequest uspsAddressRequest : uspsAddressRequests){
            if(batchedRequests.get(batchIteration) == null) batchedRequests.put(batchIteration,new List<USPSAddressRequest>());

            batchedRequests.get(batchIteration).add(uspsAddressRequest);

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
        private List<USPSAddressRequest> uspsAddressRequestBatch;
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

        public USPSShippingAPI setBatch(List<USPSAddressRequest> uspsAddressRequestBatch){
            this.uspsAddressRequestBatch = uspsAddressRequestBatch;
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
            for(USPSAddressRequest uspsAddress : this.uspsAddressRequestBatch){
                Dom.XmlNode xmlAddress = parentNode.addChildElement(tagName, null, null);
                xmlAddress.setAttribute('ID', String.valueOf(counter));

                uspsAddress.writeXML(xmlAddress);

                counter++;
            }
            return this;
        }

        private abstract USPSShippingAPI writeXML();

        private USPSShippingAPI readXML(){
            Dom.XmlNode responseRoot = this.responseXML.getRootElement();

            if(responseRoot.getName() == 'Error') throw new USPSShippingAPIException(responseRoot.getChildElement('Description', null).getText());

            for(Dom.XmlNode address : responseRoot.getChildElements()){
                this.service.uspsAddressResponses.add(new USPSAddressResponse(address.getChildElements()));
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
        
            Dom.XmlNode addressValidateRequest = this.requestXML.createRootElement(this.rootTag, null, null);
            addressValidateRequest.setAttribute('USERID', this.USERID);
            addressValidateRequest.addChildElement('Revision', null, null).addTextNode(this.service.revision);

            this.processChildNodes(addressValidateRequest, this.parentTag);

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
        
            Dom.XmlNode addressValidateRequest = this.requestXML.createRootElement(this.rootTag, null, null);
            addressValidateRequest.setAttribute('USERID', this.USERID);

            this.processChildNodes(addressValidateRequest, this.parentTag);

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
        
            Dom.XmlNode addressValidateRequest = this.requestXML.createRootElement(this.rootTag, null, null);
            addressValidateRequest.setAttribute('USERID', this.USERID);

            this.processChildNodes(addressValidateRequest, this.parentTag);

            return this;
        }
    }

    public class USPSShippingAPIException extends Exception{}
}
