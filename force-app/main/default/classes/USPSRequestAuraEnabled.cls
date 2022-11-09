public with sharing class USPSRequestAuraEnabled {
    @AuraEnabled public String firmName;
    @AuraEnabled public String address1;
    @AuraEnabled public String address2;
    @AuraEnabled public String city;
    @AuraEnabled public String state;
    @AuraEnabled public String urbanization;
    @AuraEnabled public String zip5;
    @AuraEnabled public String zip4;

    public USPSRequestAuraEnabled() {}

    public USPSAddressValidateRequest buildAddressValidateRequest(){
        USPSAddressValidateRequest Validate = new USPSAddressValidateRequest()
        .setFirmName(firmName)
        .setAddress1(address1)
        .setAddress2(address2)
        .setCity(city)
        .setState(state)
        .setUrbanization(urbanization)
        .setZip5(zip5)
        .setZip4(zip4);
        return Validate;
    }

    public static List<USPSAddressValidateRequest> buildAddressValidateRequests(List<USPSRequestAuraEnabled> auraRequests){
        List<USPSAddressValidateRequest> requests = new List<USPSAddressValidateRequest>();
        for(USPSRequestAuraEnabled auraRequest : auraRequests){
            requests.add(auraRequest.buildAddressValidateRequest());
        }
        return requests;
    }
}
