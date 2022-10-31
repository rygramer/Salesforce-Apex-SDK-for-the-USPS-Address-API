public with sharing class USPSShippingAPIDemoController {
    
    @AuraEnabled
    public static Address verifyAddress(String street, String city, String state, String zip){
        USPSRequest address = new USPSVerifyAddressRequest()
        .setAddress2(street)
        .setCity(city)
        .setState(state)
        .setZip5(zip);

        USPSResponse response = new USPSShippingAPIService().setReturnAllData().send(address);

        return new Address(response);
    }

    public class Address{
        @AuraEnabled public String firmName;
        @AuraEnabled public String address1;
        @AuraEnabled public String address2;
        @AuraEnabled public String street;
        @AuraEnabled public String address2Abbreviation;
        @AuraEnabled public String city;
        @AuraEnabled public String cityAbbreviation;
        @AuraEnabled public String state;
        @AuraEnabled public String urbanization;
        @AuraEnabled public String zip5;
        @AuraEnabled public String zip4;
        @AuraEnabled public String zip;
        @AuraEnabled public String deliveryPoint;
        @AuraEnabled public String returnText;
        @AuraEnabled public String carrierRoute;
        @AuraEnabled public String footnotes;
        @AuraEnabled public String dPVConfirmation;
        @AuraEnabled public String dPVCMRA;
        @AuraEnabled public String dPVFootnotes;
        @AuraEnabled public String business;
        @AuraEnabled public String centralDeliveryPoint;
        @AuraEnabled public String vacant;
        @AuraEnabled public String error;

        public Address(USPSResponse response){
            this.firmName = response.firmName;
            this.address1 = response.address1;
            this.address2 = response.address2;
            this.street = response.street;
            this.address2Abbreviation = response.address2Abbreviation;
            this.city = response.city;
            this.cityAbbreviation = response.cityAbbreviation;
            this.state = response.state;
            this.urbanization = response.urbanization;
            this.zip5 = response.zip5;
            this.zip4 = response.zip4;
            this.zip = response.zip;
            this.deliveryPoint = response.deliveryPoint;
            this.returnText = response.returnText;
            this.carrierRoute = response.carrierRoute;
            this.footnotes = response.footnotes;
            this.dPVConfirmation = response.dPVConfirmation;
            this.dPVCMRA = response.dPVCMRA;
            this.dPVFootnotes = response.dPVFootnotes;
            this.business = response.business;
            this.centralDeliveryPoint = response.centralDeliveryPoint;
            this.vacant = response.vacant;
            this.error = response.error;
        }
    }
}