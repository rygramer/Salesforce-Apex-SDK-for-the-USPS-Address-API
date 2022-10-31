public with sharing class USPSResponse {
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
    public String error{get; private set;}

    private final Map<String,String> FOOTNOTE_ENUMS = new Map<String,String>{
        'A' => 'The address was found to have a different 5-digit Zip Code than given in the submitted list. The correct Zip Code is shown in the output address.',
        'B' => 'The spelling of the city name and/or state abbreviation in the submitted address was found to be different than the standard spelling. The standard spelling of the city name and state abbreviation are shown in the output address.',
        'C' => 'The Zip Code in the submitted address could not be found because neither a valid city, state, nor valid 5-digit Zip Code was present. It is also recommended that the requestor check the submitted address for accuracy.',
        'D' => 'This is a record listed by the United State Postal Service on the national Zip+4 file as a non-deliverable location. It is recommended that the requestor verify the accuracy of the submitted address.',
        'E' => 'Multiple records were returned, but each shares the same 5-digit Zip Code.',
        'F' => 'The address, exactly as submitted, could not be found in the city, state, or Zip Code provided.',
        'G' => 'Information in the firm line was determined to be a part of the address. It was moved out of the firm line and incorporated into the address line.',
        'H' => 'Zip+4 information indicated this address is a building. The address as submitted does not contain an apartment/suite number.',
        'I' => 'More than one Zip+4 was found to satisfy the address as submitted. The submitted address did not contain sufficiently complete or correct data to determine a single Zip+4 Code.',
        'J' => 'The input contained two addresses.',
        'K' => 'CASS rule does not allow a match when the cardinal point of a directional changes more than 90%.',
        'L' => 'An address component was added, changed, or deleted in order to achieve a match.',
        'M' => 'The spelling of the street name was changed in order to achieve a match.',
        'N' => 'The delivery address was standardized.',
        'O' => 'More than one Zip+4 Code was found to satisfy the address as submitted. The lowest Zip+4 addon may be used to break the tie between the records.',
        'P' => 'The delivery address is matchable, but is known by another (preferred) name.',
        'Q' => 'Match to an address with a unique Zip Code.',
        'R' => 'The delivery address is matchable, but the EWS file indicates that an exact match will be available soon.',
        'S' => 'The secondary information does not match that on the national Zip+4 file. This secondary information, although present on the input address, was not valid in the range found on the national Zip+4 file.',
        'T' => 'The search resulted on a single response; however, the record matched was flagged as having magnet street syndrome.',
        'U' => 'The city or post office name in the submitted address is not recognized by the United States Postal Service as an official last line name (preferred city name) and is not acceptable as an alternate name.',
        'V' => 'The city and state in the submitted address could not be verified as corresponding to the given 5-digit Zip Code.',
        'W' => 'The input address record contains a delivery address other than a PO BOX, General Delivery, or Postmaster with a 5-digit Zip Code that is identified as a “small town default.” The United States Postal Service does not provide street delivery for this Zip Code. The United States Postal Service requires use of a PO BOX, General Delivery, or Postmaster for delivery within this Zip Code.',
        'X' => 'Default match inside a unique Zip Code.',
        'Y' => 'Match made to a record with a military Zip Code.',
        'Z' => 'The ZIPMOVE product shows which Zip+4 records have moved from one Zip Code to another.'
    };

    private final Map<String,String> DPVCONFIRMATION_ENUMS = new Map<String,String>{
        'Y' => 'Address was DPV confirmed for both primary and (if present) secondary numbers.',
        'D' => 'Address was DPV confirmed for the primary number only, and the secondary number information was missing.',
        'S' => 'Address was DPV confirmed for the primary number only, and the secondary number information was present by not confirmed.',
        'N' => 'Both primary and (if present) secondary number information failed to DPV confirm.'
    };

    private final Map<String,String> DPVFOOTNOTES_ENUMS = new Map<String,String>{
        'AA' => 'Input address matched to the ZIP+4 file.',
        'A1' => 'Input address not matched to the ZIP+4 file.',
        'BB' => 'Matched to DPV (all components).',
        'CC' => 'Secondary number not matched (present but invalid).',
        'N1' => 'High-rise address missing secondary number.',
        'M1' => 'Primary number missing.',
        'M3' => 'Primary number invalid.',
        'P1' => 'Input Address RR or HC Box number Missing.',
        'P3' => 'Input Address PO, RR, or HC Box number Invalid.',
        'F1' => 'Input Address Matched to a Military Address.',
        'G1' => 'Input Address Matched to a General Delivery Address.',
        'U1' => 'Input Address Matched to a Unique ZIP Code™.'
    };

    public USPSResponse(List<Dom.XmlNode> responseFields) {
        for(Dom.XmlNode responseField : responseFields){
            String field = responseField.getName();
            String value = responseField.getText();
            system.debug(field);
            system.debug('    ' + value);
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
