USPSAddressRequest address1 = new USPSCityStateLookupRequest()
.setZip5('20818');

USPSAddressRequest address2 = new USPSCityStateLookupRequest().setZip5('20002');

USPSAddressRequest address3 = new USPSCityStateLookupRequest().setZip5('90210');

List<USPSAddressRequest> addresses = new List<USPSAddressRequest>{address1,address2,address3};

List<USPSAddressResponse> responses = new USPSShippingAPIService(addresses).send();
system.debug(responses);
