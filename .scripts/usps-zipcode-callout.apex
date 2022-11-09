USPSRequest address = new USPSZipCodeLookupRequest()
.setAddress2('415 Mission St')
.setCity('San Francisco')
.setZip5('94105');

List<USPSRequest> addresses = new List<USPSRequest>{address};

List<USPSResponse> responses = new USPSAddressAPIService().send(addresses);
system.debug(responses);
