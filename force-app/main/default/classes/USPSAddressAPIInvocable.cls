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
                for(Integer i = 1; i <= input.requests.size(); i++){
                    output.responses.add(responses.remove(0));
                }
            }
            outputs.add(output);
        }
        
        return outputs;
    }

    public class Input{
        @InvocableVariable(
            label = '1. Single Address to Validate (Apex-Defined Variable of type USPSRequestAuraEnabled)'
            description = 'Input must be Apex-Defined Variable of type USPSRequestAuraEnabled'
        )
        public USPSRequestAuraEnabled request;

        @InvocableVariable(
            label = '2. Multiple Addresses to Validate (Apex-Defined Variabled of type USPSRequestAuraEnabled Collection)'
            description = 'Input must be Apex-Defined Variabled of type USPSRequestAuraEnabled Collection'
        )
        public List<USPSRequestAuraEnabled> requests;
    }

    public class Output{
        @InvocableVariable(
            label = 'Validated Single Address'
            description = 'Output will be Apex-Defined Variable of type USPSResponseAuraEnabled'
        )
        public USPSResponseAuraEnabled response;

        @InvocableVariable(
            label = 'Validated Multiple Addresses'
            description = 'Output will be Apex-Defined Variable of type USPSResponseAuraEnabled Collection'
        )
        public List<USPSResponseAuraEnabled> responses;
    }
}
