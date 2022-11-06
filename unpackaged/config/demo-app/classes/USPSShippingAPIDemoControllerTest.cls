@IsTest
public with sharing class USPSShippingAPIDemoControllerTest {
    
    @IsTest
    public static void verifyAddress(){
        Test.setMock(HttpCalloutMock.class, new USPSShippingAPIHttpMock());

        instantiateSettings();

        Test.startTest();
        USPSResponseAuraEnabled response = USPSShippingAPIDemoController.verifyAddress('street', 'city', 'state', 'zip');
        Test.stopTest();

        system.assert(response.city == 'city', 'The response matches what was set in the HttpMock class.');
    }

    private static void instantiateSettings(){
        USPS_Shipping_API_Setting__mdt setting = new USPS_Shipping_API_Setting__mdt(
            DeveloperName = 'USPS_Username',
            Value__c = 'username'
        );
        USPSShippingAPIService.settings = new Map<String,USPS_Shipping_API_Setting__mdt>{
            setting.DeveloperName => setting
        };
    }
}
