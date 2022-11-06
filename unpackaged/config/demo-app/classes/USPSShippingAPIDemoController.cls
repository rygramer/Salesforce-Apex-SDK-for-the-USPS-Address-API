public with sharing class USPSShippingAPIDemoController {
    
    @AuraEnabled
    public static USPSResponseAuraEnabled verifyAddress(String street, String city, String state, String zip){
        USPSRequest address = new USPSVerifyAddressRequest()
        .setAddress2(street)
        .setCity(city)
        .setState(state)
        .setZip5(zip);

        return new USPSResponseAuraEnabled(new USPSShippingAPIService().setReturnAllData().send(address));
    }
}
