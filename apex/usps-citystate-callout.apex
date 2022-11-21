USPSRequest address = new USPSCityStateLookupRequest()
.setZip5('94105');

USPSResponse response = new USPSAddressAPIService().send(address);

Assert.areEqual('SAN FRANCISCO', response.city, '🌉');