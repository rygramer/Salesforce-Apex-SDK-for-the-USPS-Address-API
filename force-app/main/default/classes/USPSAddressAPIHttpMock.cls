@isTest
public with sharing class USPSAddressAPIHttpMock implements HttpCalloutMock{
    
    public HttpResponse respond(HttpRequest request){
        Dom.Document doc = new Dom.Document();
        Dom.XmlNode root = doc.createRootElement('MockedRoot', null, null);
        Dom.XmlNode address = root.addChildElement('Address', null, null);
        address.setAttribute('ID', '0');
        address.addChildElement('FirmName', null, null).addTextNode('FirmName');
        address.addChildElement('Address1', null, null).addTextNode('Address1');
        address.addChildElement('Address2', null, null).addTextNode('Address2');
        address.addChildElement('Address2Abbreviation', null, null).addTextNode('Address2Abbreviation');
        address.addChildElement('City', null, null).addTextNode('City');
        address.addChildElement('CityAbbreviation', null, null).addTextNode('CityAbbreviation');
        address.addChildElement('State', null, null).addTextNode('State');
        address.addChildElement('Urbanization', null, null).addTextNode('Urbanization');
        address.addChildElement('Zip5', null, null).addTextNode('Zip5');
        address.addChildElement('DeliveryPoint', null, null).addTextNode('DeliveryPoint');
        address.addChildElement('ReturnText', null, null).addTextNode('ReturnText');
        address.addChildElement('CarrierRoute', null, null).addTextNode('CarrierRoute');
        address.addChildElement('Footnotes', null, null).addTextNode('Footnotes');
        address.addChildElement('DPVConfirmation', null, null).addTextNode('DPVConfirmation');
        address.addChildElement('DPVCMRA', null, null).addTextNode('DPVCMRA');
        address.addChildElement('DPVFootnotes', null, null).addTextNode('DPVFootnotes');
        address.addChildElement('Business', null, null).addTextNode('Business');
        address.addChildElement('CentralDeliveryPoint', null, null).addTextNode('CentralDeliveryPoint');
        address.addChildElement('Vacant', null, null).addTextNode('Vacant');
        Dom.XmlNode error = address.addChildElement('Error', null, null);
        error.addChildElement('Description', null, null).addTextNode('error');
        HttpResponse response = new HttpResponse();
        response.setBody(doc.toXmlString());
        return response;
    }
}
