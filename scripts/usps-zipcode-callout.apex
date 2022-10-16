USPSRequest address1 = new USPSZipCodeLookupRequest()
.setAddress1('7904 Woodrow Place')
.setCity('Cabin John')
.setZip5('20818');

USPSRequest address2 = new USPSZipCodeLookupRequest()
.setAddress1('The White House')
.setAddress2('1600 Pennsylvania Ave')
.setCity('Washington')
.setState('DC');

USPSRequest address3 = new USPSZipCodeLookupRequest()
.setAddress1('5230 Tuckerman Lane')
.setAddress2('#0809')
.setCity('North Bethsda')
.setState('MD');

List<USPSRequest> addresses = new List<USPSRequest>{address1,address2,address3};

List<USPSResponse> responses = new USPSShippingAPIService(addresses).send();
system.debug(responses);
