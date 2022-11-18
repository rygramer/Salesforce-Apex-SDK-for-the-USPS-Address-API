USPSRequest address = new USPSAddressValidateRequest()
.setAddress2('415 Mission St')
.setCity('San Francisco')
.setZip5('94105');

USPSResponse response = new USPSAddressAPIService().setReturnAllData().send(address);

Assert.areEqual('94105-2533', response.zip, 'Well, hello Zip+4.');