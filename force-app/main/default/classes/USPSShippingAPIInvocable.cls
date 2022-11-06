public with sharing class USPSShippingAPIInvocable {
    @InvocableMethod(
        label = 'Verify Shipping Addresses using USPS API'
        description = 'Leverage the power of the USPS Shipping API to verify Shipping Addresses.'
        category = 'USPS'
        iconName = 'slds:standard:address'
    )
    public static List<Output> send(List<Input> inputs){
        List<USPSVerifyAddressRequest> requests = new List<USPSVerifyAddressRequest>();
        for(Input input : inputs){
            if(input.request != null) requests.add(input.request.buildVerifyRequest());
            if(input.requests != null) requests.addAll(USPSRequestAuraEnabled.buildVerifyRequests(input.requests));
        }

        List<USPSResponseAuraEnabled> responses = USPSResponseAuraEnabled.buildAuraEnabledResponses(new USPSShippingAPIService().setReturnAllData().send(requests));

        List<Output> outputs = new List<Output>();
        for(Input input : inputs){
            Output output = new Output();
            if(input.request != null){
                output.response = responses.remove(0);
            }
            if(input.requests != null){
                output.responses = new List<USPSResponseAuraEnabled>();
                for(integer i = 1; i <= output.responses.size(); i++){
                    output.responses.add(responses.remove(0));
                }
            }
            outputs.add(output);
        }
        
        return outputs;
    }

    public class Input{
        @InvocableVariable(
            label = 'Single Address to Verify'
        )
        public USPSRequestAuraEnabled request;

        @InvocableVariable(
            label = 'Multiple Addresses to Verify'
        )
        public List<USPSRequestAuraEnabled> requests;
    }

    public class Output{
        @InvocableVariable(
            label = 'Verified Single Address'
        )
        public USPSResponseAuraEnabled response;

        @InvocableVariable(
            label = 'Verified Multiple Addresses'
        )
        public List<USPSResponseAuraEnabled> responses;
    }
}
