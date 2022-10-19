@isTest
public with sharing class USPSShippingAPIHttpMock implements HttpCalloutMock{
    
    public HttpResponse respond(HttpRequest request){
        HttpResponse response = new HttpResponse();
        response.setBody('');
        return response;
    }
}
