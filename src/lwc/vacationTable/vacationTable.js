import { LightningElement, track } from 'lwc';
import getRequestTypes from '@salesforce/apex/vacationTableController.getRequestTypes';
//import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class VacationTable extends LightningElement {
//    _title = 'Sample Title';
//    message = 'Sample Message';
//    variant = 'error';
//
//    showNotification() {
//        const evt = new ShowToastEvent({
//            title: this._title,
//            message: this.message,
//            variant: this.variant,
//        });
//        this.dispatchEvent(evt);
//    }

    @track isModalOpened = false;
    manager = '';
    requestTypes = [];

    connectedCallback(){
        getRequestTypes()
            .then(res => {
                this.requestTypes = res;
            })
            .catch(err => {
                console.log(err)
            })
    }

    //New request button
    openModal(){
        this.isModalOpened = true;
    }

    //Either cross or close button in the modal window
    closeModal(){
        this.isModalOpened = false;
    }

    //
    createRequest(){
        alert("Saved");
        this.closeModal();
    }

    handleRequestType(){
        //No implementation
    }
}