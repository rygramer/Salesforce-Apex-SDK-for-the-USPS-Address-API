public with sharing class USPSCityStateLookupRequest extends USPSAddressRequest {
    public USPSCityStateLookupRequest setZip5(String zip5){
        if(zip5 != null) this.zip5 = zip5;
        return this;
    }

    public override Dom.XmlNode writeXML(Dom.XmlNode xmlAddress){
        xmlAddress.addChildElement('Zip5', null, null).addTextNode(this.zip5);
        return xmlAddress;
    }

    public override String getName(){
        return USPSCityStateLookupRequest.class.getName();
    }
}
