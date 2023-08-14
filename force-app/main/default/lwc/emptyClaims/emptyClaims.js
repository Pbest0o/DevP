import { LightningElement,wire } from 'lwc';
import emptyClaimsLabel from '@salesforce/label/c.emptyClaimsLabel';
import getClaims from '@salesforce/apex/CCEmptyClaimsController.getClaims';


export default class EmptyClaims extends LightningElement {

    label = emptyClaimsLabel;


    @wire(getClaims) 
    claims({ error, data }) {
        if (data) {
            this.template.querySelector('[data-my-id="emptyClaims"]').className='hide'; 
        } else if (error) {
            console.log(error);
        }
    }

}