public with sharing class USPSAddressAPIDemoController {
    
    @AuraEnabled
    public static USPSResponseAuraEnabled validateAddress(String street, String city, String state, String zip){
        USPSRequest address = new USPSAddressValidateRequest()
        .setAddress2(street)
        .setCity(city)
        .setState(state)
        .setZip5(zip);

        return new USPSResponseAuraEnabled(new USPSAddressAPIService().setReturnAllData().send(address));
    }
}
