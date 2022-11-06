import { LightningElement } from 'lwc';
import verifyAddress from '@salesforce/apex/USPSShippingAPIDemoController.verifyAddress';

export default class UspsShippingAPIDemo extends LightningElement {
    street;
    city;
    state;
    zip;

    verifiedAddress;
    error;

    isLoading;

    get verified(){
        return this.verifiedAddress || this.error;
    }

    get icon(){
        if(this.error) return "utility:error";
        return "utility:success";
    }

    handleChange(event){
        this.nullifyReturns();
        this.street = event.target.street;
        this.city = event.target.city;
        this.state = event.target.province;
        this.zip = event.target.postalCode;
    }

    handleClick(){
        this.isLoading = true;
        this.nullifyReturns();
        verifyAddress({street: this.street, city: this.city, state: this.state, zip: this.zip})
            .then(verifiedAddress => {
                if(verifiedAddress.error){
                    this.error = verifiedAddress.error;
                } else {
                    this.verifiedAddress = verifiedAddress;

                    this.jsonVerifiedAddress = JSON.stringify(verifiedAddress,null,'\t');

                    for(var key in verifiedAddress){
                        console.log(key);
                        console.log(verifiedAddress[key]);
                    }
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
        this.verifiedAddress = null;
        this.error = null;
    }
}