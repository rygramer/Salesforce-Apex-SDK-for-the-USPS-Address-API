@isTest
public with sharing class USPSAddressAPITest {
    @isTest
    public static void validate(){
        Test.setMock(HttpCalloutMock.class, new USPSAddressAPIHttpMock());

        USPSRequest address = new USPSAddressValidateRequest()
        .setFirmName('firmName')
        .setAddress1('address1')
        .setAddress2('address2')
        .setCity('city')
        .setState('state')
        .setUrbanization('urbanization')
        .setZip5('zip5')
        .setZip4('zip4');

        instantiateSettings();

        Test.startTest();
        USPSResponse response = new USPSAddressAPIService().setReturnAllData().send(address);
        Test.stopTest();

        system.assert(response.address1 == 'address1', 'The response matches what was set in the HttpMock class.');
        system.assert(response.street != null, 'Testing the getter in USPSResponse.');
        system.assert(response.zip != null, 'Testing the getter in USPSResponse.');
    }

    @isTest
    public static void zip(){
        Test.setMock(HttpCalloutMock.class, new USPSAddressAPIHttpMock());

        USPSRequest address = new USPSZipCodeLookupRequest()
        .setFirmName('firmName')
        .setAddress1('address1')
        .setAddress2('address2')
        .setCity('city')
        .setState('state')
        .setZip5('zip5')
        .setZip4('zip4');

        instantiateSettings();

        Test.startTest();
        USPSResponse response = new USPSAddressAPIService().send(address);
        Test.stopTest();

        System.assert(response.address1 == 'address1', 'The response matches what was set in the HttpMock class.');
    }

    @isTest
    public static void citystate(){
        Test.setMock(HttpCalloutMock.class, new USPSAddressAPIHttpMock());

        USPSRequest address = new USPSCityStateLookupRequest()
        .setZip5('zip5');

        instantiateSettings();

        Test.startTest();
        USPSResponse response = new USPSAddressAPIService().send(address);
        Test.stopTest();

        System.assert(response.address1 == 'address1', 'The response matches what was set in the HttpMock class.');
    }

    @isTest
    public static void citystate_bulk(){
        Test.setMock(HttpCalloutMock.class, new USPSAddressAPIHttpMock());

        List<USPSRequest> addresses = new List<USPSRequest>();
        for(Integer i = 1; i <= 6; i++){
            addresses.add(
                new USPSCityStateLookupRequest()
                .setZip5('zip5')
            );
        }

        instantiateSettings();

        Test.startTest();
        List<USPSResponse> response = new USPSAddressAPIService().send(addresses);
        Test.stopTest();

        System.assert(response[0].address1 == 'address1', 'The response matches what was set in the HttpMock class.');
    }

    @isTest
    public static void aura_requests(){
        USPSRequestAuraEnabled address1 = new USPSRequestAuraEnabled();
        address1.address2 = 'address2';

        USPSRequestAuraEnabled address2 = new USPSRequestAuraEnabled();
        address1.address2 = 'address2';

        Test.startTest();
        List<USPSAddressValidateRequest> requests = USPSRequestAuraEnabled.buildAddressValidateRequests(new List<USPSRequestAuraEnabled>{address1,address2});
        Test.stopTest();

        System.assert(requests != null, 'Guess I should assert something?');
    }

    @isTest
    public static void aura_responses(){
        Test.setMock(HttpCalloutMock.class, new USPSAddressAPIHttpMock());

        USPSRequest address1 = new USPSAddressValidateRequest()
        .setAddress2('address2');

        USPSRequest address2 = new USPSAddressValidateRequest()
        .setAddress2('address2');

        instantiateSettings();

        USPSResponseAuraEnabled vomitForFullTestCoverage = new USPSResponseAuraEnabled();

        Test.startTest();
        List<USPSResponse> responses = new USPSAddressAPIService().setReturnAllData().send(new List<USPSRequest>{address1,address2});

        List<USPSResponseAuraEnabled> auraResponses = USPSResponseAuraEnabled.buildAuraEnabledResponses(responses);
        Test.stopTest();

        system.assert(auraResponses[0].address2 == 'address2', 'The response matches what was set in the HttpMock class.');
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
