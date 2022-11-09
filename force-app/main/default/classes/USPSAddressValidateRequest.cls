public with sharing virtual class USPSAddressValidateRequest extends USPSRequest {
    public USPSAddressValidateRequest setFirmName(String firmName){
        if(firmName != null) this.firmName = firmName;
        return this;
    }

    public USPSAddressValidateRequest setAddress1(String address1){
        if(address1 != null) this.address1 = address1;
        return this;
    }

    public USPSAddressValidateRequest setAddress2(String address2){
        if(address2 != null) this.address2 = address2;
        return this;
    }

    public USPSAddressValidateRequest setCity(String city){
        if(city != null) this.city = city;
        return this;
    }

    public USPSAddressValidateRequest setState(String state){
        if(state != null) this.state = state;
        return this;
    }

    public USPSAddressValidateRequest setUrbanization(String urbanization){
        if(urbanization != null) this.urbanization = urbanization;
        return this;
    }

    public USPSAddressValidateRequest setZip5(String zip5){
        if(zip5 != null) this.zip5 = zip5;
        return this;
    }

    public USPSAddressValidateRequest setZip4(String zip4){
        if(zip4 != null) this.zip4 = zip4;
        return this;
    }

    public override Dom.XmlNode writeXML(Dom.XmlNode xmlAddress){
        xmlAddress.addChildElement('FirmName', null, null).addTextNode(this.firmName);
        xmlAddress.addChildElement('Address1', null, null).addTextNode(this.address1);
        xmlAddress.addChildElement('Address2', null, null).addTextNode(this.address2);
        xmlAddress.addChildElement('City', null, null).addTextNode(this.city);
        xmlAddress.addChildElement('State', null, null).addTextNode(this.state);
        xmlAddress.addChildElement('Urbanization', null, null).addTextNode(this.urbanization);
        xmlAddress.addChildElement('Zip5', null, null).addTextNode(this.zip5);
        xmlAddress.addChildElement('Zip4', null, null).addTextNode(this.zip4);
        return xmlAddress;
    }

    public override String getName(){
        return USPSAddressValidateRequest.class.getName();
    }
}
