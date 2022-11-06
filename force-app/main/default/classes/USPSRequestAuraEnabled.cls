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

    public USPSVerifyAddressRequest buildVerifyRequest(){
        USPSVerifyAddressRequest verify = new USPSVerifyAddressRequest()
        .setFirmName(firmName)
        .setAddress1(address1)
        .setAddress2(address2)
        .setCity(city)
        .setState(state)
        .setUrbanization(urbanization)
        .setZip5(zip5)
        .setZip4(zip4);
        return verify;
    }

    public static List<USPSVerifyAddressRequest> buildVerifyRequests(List<USPSRequestAuraEnabled> auraRequests){
        List<USPSVerifyAddressRequest> requests = new List<USPSVerifyAddressRequest>();
        for(USPSRequestAuraEnabled auraRequest : auraRequests){
            requests.add(auraRequest.buildVerifyRequest());
        }
        return requests;
    }
}
