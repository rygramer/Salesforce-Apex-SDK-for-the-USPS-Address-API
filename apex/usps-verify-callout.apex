USPSRequest address = new USPSAddressValidateRequest()
.setAddress2('415 Mission Street')
.setCity('San Francisco')
.setZip5('94105');

USPSResponse response = new USPSAddressAPIService().send(address);

Assert.areEqual('415 MISSION ST', response.street, 'C! A! P! S! CAPS CAPS CAPS!');