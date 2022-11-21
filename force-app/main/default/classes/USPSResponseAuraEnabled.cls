public with sharing class USPSResponseAuraEnabled {
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
    @AuraEnabled public List<String> footnotesDetails;
    @AuraEnabled public String dPVConfirmation;
    @AuraEnabled public String dPVConfirmationDetails;
    @AuraEnabled public String dPVCMRA;
    @AuraEnabled public String dPVFootnotes;
    @AuraEnabled public List<String> dPVFootnotesDetails;
    @AuraEnabled public String business;
    @AuraEnabled public String centralDeliveryPoint;
    @AuraEnabled public String vacant;
    @AuraEnabled public String error;

    public USPSResponseAuraEnabled() {}

    public USPSResponseAuraEnabled(USPSResponse response){
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
        this.footnotesDetails = response.footnotesDetails;
        this.dPVConfirmation = response.dPVConfirmation;
        this.dPVConfirmationDetails = response.dPVConfirmationDetails;
        this.dPVCMRA = response.dPVCMRA;
        this.dPVFootnotes = response.dPVFootnotes;
        this.dPVFootnotesDetails = response.dPVFootnotesDetails;
        this.business = response.business;
        this.centralDeliveryPoint = response.centralDeliveryPoint;
        this.vacant = response.vacant;
        this.error = response.error;
    }

    public static List<USPSResponseAuraEnabled> buildAuraEnabledResponses(List<USPSResponse> responses){
        List<USPSResponseAuraEnabled> auraResponses = new List<USPSResponseAuraEnabled>();
        for(USPSResponse response : responses){
            auraResponses.add(
                new USPSResponseAuraEnabled(response)
            );
        }
        return auraResponses;
    }
}
