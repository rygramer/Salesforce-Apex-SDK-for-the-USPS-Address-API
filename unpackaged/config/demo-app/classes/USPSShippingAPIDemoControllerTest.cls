@IsTest
public with sharing class USPSShippingAPIDemoControllerTest {
    
    @IsTest
    public static void verifyAddress(){
        Test.setMock(HttpCalloutMock.class, new USPSShippingAPIHttpMock());

        Test.startTest();
        USPSShippingAPIDemoController.Address response = USPSShippingAPIDemoController.verifyAddress('street', 'city', 'state', 'zip');
        Test.stopTest();

        system.assert(response.city == 'city', 'The response matches what was set in the HttpMock class.');
    }
}
