USPSRequest address = new USPSZipCodeLookupRequest()
.setAddress2('415 Mission St')
.setCity('San Francisco')
.setZip5('94105');

USPSResponse response = new USPSAddressAPIService().send(address);

Assert.areEqual('94105-2533', response.zip, 'You\'ll probably find the Address Validation API more useful.');
