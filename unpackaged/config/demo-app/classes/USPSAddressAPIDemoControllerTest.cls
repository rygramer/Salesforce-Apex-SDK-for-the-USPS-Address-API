@IsTest
public with sharing class USPSAddressAPIDemoControllerTest {
    
    @IsTest
    public static void validateAddress(){
        Test.setMock(HttpCalloutMock.class, new USPSAddressAPIHttpMock());

        instantiateSettings();

        USPSRequestAuraEnabled request = new USPSRequestAuraEnabled();
        request.address2 = 'street';
        request.city = 'city';
        request.state = 'state';
        request.zip5 = 'zip';

        Test.startTest();
        USPSResponseAuraEnabled response = USPSAddressAPIDemoController.validateAddress(JSON.serialize(request));
        Test.stopTest();

        system.assert(response.city == 'city', 'The response matches what was set in the HttpMock class.');
    }

    private static void instantiateSettings(){
        USPS_Address_API_Setting__mdt setting = new USPS_Address_API_Setting__mdt(
            DeveloperName = 'USPS_Username',
            Value__c = 'username'
        );
        USPSAddressAPIService.settings = new Map<String,USPS_Address_API_Setting__mdt>{
            setting.DeveloperName => setting
        };
    }
}
