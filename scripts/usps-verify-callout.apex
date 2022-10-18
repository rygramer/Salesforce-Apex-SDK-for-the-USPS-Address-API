USPSRequest address = new USPSVerifyAddressRequest()
.setAddress2('415 Mission St')
.setCity('San Francisco')
.setZip5('94105');

List<USPSRequest> addresses = new List<USPSRequest>{address};

List<USPSResponse> responses = new USPSShippingAPIService().send(addresses);
system.debug('--------------> CALLOUT SIZE:' + limits.getCallouts());
system.debug('--------------> ADDRESS SIZE:' + addresses.size());
system.debug('--------------> RESPONSE SIZE:' + responses.size());
system.debug(responses);
