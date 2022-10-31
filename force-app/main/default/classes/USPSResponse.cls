public with sharing class USPSResponse {
    public string error{get; private set;}
    public String firmName{get;private set;}
    public String address1{get;private set;}
    public String address2{get;private set;}
    public String street{
        get{
            if(this.address1 != null || this.address2 != null) street = '';
            if(this.address1 != null) street += this.address1;
            if(this.address1 != null && this.address2 != null) street += '\n';
            if(this.address2 != null) street += this.address2;
            return street;
        }
        private set;
    }
    public String address2Abbreviation{get;private set;}
    public String city{get;private set;}
    public String cityAbbreviation{get;private set;}
    public String state{get;private set;}
    public String urbanization{get;private set;}
    public String zip5{get;private set;}
    public String zip4{get;private set;}
    public String zip{
        get{
            if(this.zip5 != null || this.zip4 != null) zip = '';
            if(this.zip5 != null) zip += this.zip5;
            if(this.zip5 != null && this.zip4 != null) zip += '-';
            if(this.zip4 != null) zip += this.zip4;
            return zip;
        }
        private set;
    }
    public String deliveryPoint{get;private set;}
    public String returnText{get;private set;}
    public String carrierRoute{get;private set;}
    public String footnotes{get;private set;}
    public String dPVConfirmation{get;private set;}
    public String dPVCMRA{get;private set;}
    public String dPVFootnotes{get;private set;}
    public String business{get;private set;}
    public String centralDeliveryPoint{get;private set;}
    public String vacant{get;private set;}

    public USPSResponse(List<Dom.XmlNode> responseFields) {
        for(Dom.XmlNode responseField : responseFields){
            String field = responseField.getName();
            String value = responseField.getText();
            switch on field{
                when 'Error'{this.error = responseField.getChildElement('Description', null).getText();}
                when 'FirmName'{this.firmName = value;}
                when 'Address1'{this.address1 = value;}
                when 'Address2'{this.address2 = value;}
                when 'Address2Abbreviation'{this.address2Abbreviation = value;}
                when 'City'{this.city = value;}
                when 'CityAbbreviation'{this.cityAbbreviation = value;}
                when 'State'{this.state = value;}
                when 'Urbanization'{this.urbanization = value;}
                when 'Zip5'{this.zip5 = value;}
                when 'Zip4'{this.zip4 = value;}
                when 'DeliveryPoint'{this.deliveryPoint = value;}
                when 'ReturnText'{this.returnText = value;}
                when 'CarrierRoute'{this.carrierRoute = value;}
                when 'Footnotes'{this.footnotes = value;}
                when 'DPVConfirmation'{this.dPVConfirmation = value;}
                when 'DPVCMRA'{this.dPVCMRA = value;}
                when 'DPVFootnotes'{this.dPVFootnotes = value;}
                when 'Business'{this.business = value;}
                when 'CentralDeliveryPoint'{this.centralDeliveryPoint = value;}
                when 'Vacant'{this.vacant = value;}
            }
        }
    }
}
