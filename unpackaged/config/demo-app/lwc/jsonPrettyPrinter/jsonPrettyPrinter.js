import { LightningElement, api } from 'lwc';

export default class JsonPrettyPrinter extends LightningElement {
    @api jsonToPrettyPrint;
    @api toggleTitle;
    activeAccordionSectionName = '';
    
    handleToggleSection(){
        if(this.activeAccordionSectionName.length === 0){
            this.activeAccordionSectionName = '';
        } else {
            this.activeAccordionSectionName = 'json'
        }
    }
}