public with sharing class USPSShippingAPIDemoController {
    
    @AuraEnabled
    public static Address verifyAddress(String street, String city, String state, String zip){
        USPSRequest address = new USPSVerifyAddressRequest()
        .setAddress2(street)
        .setCity(city)
        .setState(state)
        .setZip5(zip);

        USPSResponse response = new USPSShippingAPIService().send(address);

        return new Address(response);
    }

    public class Address{
        @AuraEnabled
        public String street;

        @AuraEnabled
        public String city;

        @AuraEnabled
        public String state;

        @AuraEnabled
        public String zip;

        public Address(USPSResponse response){
            this.street = response.street;
            this.city = response.city;
            this.state = response.state;
            this.zip = response.zip;
        }
    }
}
