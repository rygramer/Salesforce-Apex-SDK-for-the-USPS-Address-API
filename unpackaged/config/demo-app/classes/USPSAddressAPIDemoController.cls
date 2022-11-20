public with sharing class USPSAddressAPIDemoController {
    @AuraEnabled
    public static USPSResponseAuraEnabled validateAddress(String addressToValidate){
        USPSRequestAuraEnabled address = (USPSRequestAuraEnabled) JSON.deserialize(addressToValidate, USPSRequestAuraEnabled.class);
        return new USPSResponseAuraEnabled(new USPSAddressAPIService().setReturnAllData().send(address.buildAddressValidateRequest()));
    }
}
