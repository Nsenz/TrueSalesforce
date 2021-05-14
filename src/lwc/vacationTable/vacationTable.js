import { LightningElement, track } from 'lwc';
import getRequestTypes from '@salesforce/apex/vacationTableController.getRequestTypes';
import getManager from '@salesforce/apex/vacationTableController.getManager';
import validateFields from '@salesforce/apex/vacationTableController.validateFields'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class VacationTable extends LightningElement {
    @track isModalOpened = false;

    //On mount
    manager = '';
    requestTypes = [];

    //onChange
    selectedType = null;
    selectedStartDate = null;
    selectedEndDate = null;

    connectedCallback(){
        getRequestTypes()
            .then(res => {
                res.forEach(entry => {
                    this.requestTypes.push({
                        label: entry,
                        value: entry
                    });
                });
            })
            .catch(err => {
                console.log(err)
            });
        getManager()
            .then(res => {
                this.manager = res;
            })
            .catch(err => {
                console.log(err)
            });
    }

    sendToast(title, message, variant){
        const evt = new ShowToastEvent({
                    title,
                    message,
                    variant,
                });
        this.dispatchEvent(evt);
    }

    checkManager(){
        if(this.manager) return true;
        this.sendToast('Error', 'Current user has no manager', 'error');
        return false;
    }

    //New request button
    openModal(){
        this.isModalOpened = true;
        this.checkManager();
    }

    //Either cross or close button in the modal window
    closeModal(){
        this.isModalOpened = false;
    }

    validateFieldsClient(){
         const isInputCorrect = [...this.template.querySelectorAll('lightning-input'),
                ...this.template.querySelectorAll('lightning-combobox')]
                .reduce((valid, inputField) => {
                    inputField.reportValidity();
                    return valid && inputField.checkValidity();
                }, true);

         if(!isInputCorrect){
                this.sendToast('Validation Error', 'Some of the fields are not valid', 'error');
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
            this.sendToast('Validation Error', 'Some of the values are not valid', 'error');
            return false;
        }
        return true;
    }

    createRequest(component, event){
        if(!this.validateFieldsClient()) return;
        if(this.checkManager()){
            this.validateFieldsServer().then(res=>{
                if(!res) return;
                this.closeModal();
                // New record logic
                return;
            }).catch(err=>{
                console.log(err);
            })
        }
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
}