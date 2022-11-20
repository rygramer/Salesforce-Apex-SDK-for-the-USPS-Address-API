import { LightningElement } from 'lwc';
import validateAddress from '@salesforce/apex/USPSAddressAPIDemoController.validateAddress';

export default class USPSAddressAPIDemo extends LightningElement {
    addressToValidate = {
        address2: null,
        city: null,
        state: null,
        zip5: null
    }
    validatedAddress;
    jsonValidatedAddress;
    error;

    isLoading;

    get validated(){
        return this.validatedAddress || this.error;
    }

    get icon(){
        if(this.error) return "utility:error";
        return "utility:success";
    }

    handleChange(event){
        this.nullifyReturns();
        this.addressToValidate = {
            address2: event.target.street,
            city: event.target.city,
            state: event.target.province,
            zip5: event.target.postalCode,
        }
    }

    handleClick(){
        this.isLoading = true;
        this.nullifyReturns();
        validateAddress({addressToValidate: JSON.stringify(this.addressToValidate)})
            .then(validatedAddress => {
                if(validatedAddress.error){
                    this.error = validatedAddress.error;
                } else {
                    this.validatedAddress = validatedAddress;
                    this.jsonValidatedAddress = JSON.stringify(validatedAddress,null,'\t');
                }
            })
            .catch(error => {
                this.error = error.body.message;
            })
            .finally(() =>{
                this.isLoading = false;
            })
    }

    nullifyReturns(){
        this.validatedAddress = null;
        this.error = null;
    }
}