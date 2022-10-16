USPSAddressRequest address1 = new USPSVerifyAddressRequest()
.setAddress1('7904 Woodrow Place')
.setCity('Cabin John')
.setZip5('20818');

USPSAddressRequest address2 = new USPSVerifyAddressRequest()
.setAddress1('The White House')
.setAddress2('1600 Pennsylvania Ave')
.setCity('Washington')
.setState('DC');

USPSAddressRequest address3 = new USPSVerifyAddressRequest()
.setAddress1('5230 Tuckerman Lane')
.setAddress2('#0809')
.setCity('North Bethsda')
.setState('MD');

List<USPSAddressRequest> addresses = new List<USPSAddressRequest>{address1,address2,address3};

List<USPSAddressResponse> responses = new USPSShippingAPIService(addresses).send();
system.debug('--------------> CALLOUT SIZE:' + limits.getCallouts());
system.debug('--------------> ADDRESS SIZE:' + addresses.size());
system.debug('--------------> RESPONSE SIZE:' + responses.size());
system.debug(responses);
