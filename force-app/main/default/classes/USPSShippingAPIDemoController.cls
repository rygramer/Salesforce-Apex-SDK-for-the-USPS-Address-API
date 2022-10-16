public with sharing class USPSShippingAPIDemoController {
    
    @AuraEnabled
    public static VerifiedAddress verifyAddress(String street, String city, String state, string zip){
        USPSAddressRequest address = new USPSVerifyAddressRequest()
        .setAddress2(street)
        .setCity(city)
        .setState(state)
        .setZip5(zip);

        List<USPSAddressResponse> responses = new USPSShippingAPIService(address).send();

        return new VerifiedAddress(responses.get(0));
    }

    public class VerifiedAddress{
        @AuraEnabled
        public String street;

        @AuraEnabled
        public String city;

        @AuraEnabled
        public String state;

        @AuraEnabled
        public String zip;

        public VerifiedAddress(USPSAddressResponse response){
            this.street = response.street;
            this.city = response.city;
            this.state = response.state;
            this.zip = response.zip;
        }
    }
}
