public with sharing class USPSShippingAPIDemoController {
    
    @AuraEnabled
    public static VerifiedAddress verifyAddress(String street, String city, String state, string zip){
        USPSRequest address = new USPSVerifyAddressRequest()
        .setAddress2(street)
        .setCity(city)
        .setState(state)
        .setZip5(zip);

        USPSResponse response = new USPSShippingAPIService().send(address);

        return new VerifiedAddress(response);
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

        public VerifiedAddress(USPSResponse response){
            this.street = response.street;
            this.city = response.city;
            this.state = response.state;
            this.zip = response.zip;
        }
    }
}
