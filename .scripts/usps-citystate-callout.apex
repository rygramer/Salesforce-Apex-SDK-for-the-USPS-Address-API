USPSRequest address = new USPSCityStateLookupRequest()
.setZip5('94105');

List<USPSRequest> addresses = new List<USPSRequest>{address};

List<USPSResponse> responses = new USPSAddressAPIService().send(addresses);
system.debug(responses);
