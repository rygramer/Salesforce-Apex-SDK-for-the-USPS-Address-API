@isTest
public with sharing class USPSShippingAPITest {
    @isTest
    public static void verify(){
        Test.setMock(HttpCalloutMock.class, new USPSShippingAPIHttpMock());

        USPSRequest address = new USPSVerifyAddressRequest()
        .setFirmName('firmName')
        .setAddress1('address1')
        .setAddress2('address2')
        .setCity('city')
        .setState('state')
        .setUrbanization('urbanization')
        .setZip5('zip5')
        .setZip4('zip4');

        Test.startTest();
        USPSResponse response = new USPSShippingAPIService().setReturnAllData().send(address);
        Test.stopTest();

        system.assert(response.address1 == 'address1', 'The response matches what was set in the HttpMock class.');
        system.assert(response.street != null, 'Testing the getter in USPSResponse.');
        system.assert(response.zip != null, 'Testing the getter in USPSResponse.');
    }

    @isTest
    public static void zip(){
        Test.setMock(HttpCalloutMock.class, new USPSShippingAPIHttpMock());

        USPSRequest address = new USPSZipCodeLookupRequest()
        .setFirmName('firmName')
        .setAddress1('address1')
        .setAddress2('address2')
        .setCity('city')
        .setState('state')
        .setZip5('zip5')
        .setZip4('zip4');

        Test.startTest();
        USPSResponse response = new USPSShippingAPIService().send(address);
        Test.stopTest();

        System.assert(response.address1 == 'address1', 'The response matches what was set in the HttpMock class.');
    }

    @isTest
    public static void citystate(){
        Test.setMock(HttpCalloutMock.class, new USPSShippingAPIHttpMock());

        USPSRequest address = new USPSCityStateLookupRequest()
        .setZip5('zip5');

        Test.startTest();
        USPSResponse response = new USPSShippingAPIService().send(address);
        Test.stopTest();

        System.assert(response.address1 == 'address1', 'The response matches what was set in the HttpMock class.');
    }

    @isTest
    public static void citystate_bulk(){
        Test.setMock(HttpCalloutMock.class, new USPSShippingAPIHttpMock());

        List<USPSRequest> addresses = new List<USPSRequest>();
        for(Integer i = 1; i <= 6; i++){
            addresses.add(
                new USPSCityStateLookupRequest()
                .setZip5('zip5')
            );
        }

        Test.startTest();
        List<USPSResponse> response = new USPSShippingAPIService().send(addresses);
        Test.stopTest();

        System.assert(response[0].address1 == 'address1', 'The response matches what was set in the HttpMock class.');
    }
}
