public with sharing abstract class USPSAddressRequest {
    protected String firmName = '';
    protected String address1 = '';
    protected String address2 = '';
    protected String city = '';
    protected String state = '';
    protected String urbanization = '';
    protected String zip5 = '';
    protected String zip4 = '';

    public abstract Dom.XmlNode writeXML(Dom.XmlNode xmlAddress);
    public abstract String getName();
}
