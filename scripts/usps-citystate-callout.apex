USPSRequest address1 = new USPSCityStateLookupRequest()
.setZip5('20818');

USPSRequest address2 = new USPSCityStateLookupRequest().setZip5('20002');

USPSRequest address3 = new USPSCityStateLookupRequest().setZip5('90210');

List<USPSRequest> addresses = new List<USPSRequest>{address1,address2,address3};

List<USPSResponse> responses = new USPSShippingAPIService(addresses).send();
system.debug(responses);
