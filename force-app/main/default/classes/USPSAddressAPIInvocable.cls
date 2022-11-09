public with sharing class USPSAddressAPIInvocable {
    @InvocableMethod(
        label = 'Validate Addresses using the USPS Address API'
        description = 'Leverage the power of the USPS Address API to validate Addresses.'
        category = 'USPS'
        iconName = 'slds:standard:address'
    )
    public static List<Output> send(List<Input> inputs){
        List<USPSAddressValidateRequest> requests = new List<USPSAddressValidateRequest>();
        for(Input input : inputs){
            if(input.request != null) requests.add(input.request.buildAddressValidateRequest());
            if(input.requests != null) requests.addAll(USPSRequestAuraEnabled.buildAddressValidateRequests(input.requests));
        }

        List<USPSResponseAuraEnabled> responses = USPSResponseAuraEnabled.buildAuraEnabledResponses(new USPSAddressAPIService().setReturnAllData().send(requests));

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
            label = 'Single Address to Validate'
        )
        public USPSRequestAuraEnabled request;

        @InvocableVariable(
            label = 'Multiple Addresses to Validate'
        )
        public List<USPSRequestAuraEnabled> requests;
    }

    public class Output{
        @InvocableVariable(
            label = 'Validated Single Address'
        )
        public USPSResponseAuraEnabled response;

        @InvocableVariable(
            label = 'Validated Multiple Addresses'
        )
        public List<USPSResponseAuraEnabled> responses;
    }
}
