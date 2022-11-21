USPSRequest address = new USPSZipCodeLookupRequest()
.setAddress2('415 Mission St')
.setCity('San Francisco')
.setZip5('94105');

USPSResponse response = new USPSAddressAPIService().send(address);

Assert.areEqual('2533', response.zip4, 'Well, hello Zip+4.');