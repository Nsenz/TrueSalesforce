import { LightningElement, api, track } from 'lwc';
import validateFields from '@salesforce/apex/utilController.validateFields';
import insertRequest from '@salesforce/apex/vacationTableController.insertRequest';
import getManager from '@salesforce/apex/utilController.getManager';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class Modal extends LightningElement {

    @track opened = false;
    @api types;

    //onMount
    manager = '';

    //onChange
    selectedType = null;
    selectedStartDate = null;
    selectedEndDate = null;

    async connectedCallback(){
        this.manager = await getManager();
    }

    handleRequestType(event){
        this.selectedType = event.target.value;
    }

    handleDateStart(event){
        this.selectedStartDate = event.target.value;
    }

    handleDateEnd(event){
        this.selectedEndDate = event.target.value;
    }

    @api
    openModal(){
        this.opened = true;
    }

    closeModal(){
        this.opened = false;
    }

    sendToast(title, message, variant){
        const evt = new ShowToastEvent({
            title,
            message,
            variant,
        });
        this.dispatchEvent(evt);
    }

    @api
    checkManager(){
        if(this.manager) return true;
        this.sendToast('Error', 'Current user has no manager', 'error'); //
        return false;
    }

    validateFieldsClient(){
         const isInputCorrect = [...this.template.querySelectorAll('lightning-input'),
            ...this.template.querySelectorAll('lightning-combobox')]
            .reduce((valid, inputField) => {
                inputField.reportValidity();
                return valid && inputField.checkValidity();
         }, true);

         if(!isInputCorrect){
             this.sendToast('Validation Error', 'Some of the fields are not valid', 'error'); //
             return false;
         }
         return true;
    }

    async validateFieldsServer(){
        const isValid = await validateFields({
            'requestType': this.selectedType,
            'startDate': this.selectedStartDate,
            'endDate': this.selectedEndDate
        });
        if(!isValid){
            this.sendToast('Validation Error', 'Some of the values are not valid', 'error'); //
            return false;
        }
        return true;
    }

    async createRequest(){
        if(!this.validateFieldsClient()) return;
        if(this.checkManager()){
            const isValid = await this.validateFieldsServer();
            if(!isValid) return;
            const createdRequest = await insertRequest({
                 'requestType': this.selectedType,
                 'startDate': this.selectedStartDate,
                 'endDate': this.selectedEndDate
            });
            if(createdRequest){
                this.closeModal();
                return;
            }
            this.sendToast('Validation Error', 'Error when creating a new request', 'error'); //
        }
    }
}