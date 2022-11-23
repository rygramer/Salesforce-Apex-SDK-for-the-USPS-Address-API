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
        USPSAddressValidateRequest validate = new USPSAddressValidateRequest()
        .setFirmName(this.firmName)
        .setAddress1(this.address1)
        .setAddress2(this.address2)
        .setCity(this.city)
        .setState(this.state)
        .setUrbanization(this.urbanization)
        .setZip5(this.zip5)
        .setZip4(this.zip4);
        return validate;
    }

    public static List<USPSAddressValidateRequest> buildAddressValidateRequests(List<USPSRequestAuraEnabled> auraRequests){
        List<USPSAddressValidateRequest> requests = new List<USPSAddressValidateRequest>();
        for(USPSRequestAuraEnabled auraRequest : auraRequests){
            requests.add(auraRequest.buildAddressValidateRequest());
        }
        return requests;
    }
}
