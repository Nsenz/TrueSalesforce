import { LightningElement, track } from 'lwc';
import getRequestTypes from '@salesforce/apex/utilController.getRequestTypes';
import getStatusTypes from '@salesforce/apex/utilController.getStatusTypes'
import getRequests from '@salesforce/apex/vacationTableController.getRequests';
import updateStatus from '@salesforce/apex/vacationTableController.updateStatus';
import removeRequest from '@salesforce/apex/vacationTableController.removeRequest';
import meQuery from '@salesforce/apex/utilController.meQuery'
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const COLOR_MAPPER = {

}

export default class VacationTable extends LightningElement {
    @track isFiltered = false;
    @track requests = [];

    //onMount
    me = null;
    requestTypes = [];
    tableInfoBadges = [];
    REQUEST_STATUS = [];

    mapColors(status){
        switch(status){
            case this.REQUEST_STATUS.NEW:
                return 'background: #c2f2f1';
            case this.REQUEST_STATUS.SUBMITTED:
                return 'background: #faf9d2';
            case this.REQUEST_STATUS.APPROVED:
                return 'background: #d7fad2';
            default:
                return 'background: white';
        }
    }

    markRequests(requests){
        requests.forEach(request => {
            if(request.Owner.Id == this.me
                && request.Status__c == this.REQUEST_STATUS.NEW) request.isOwner = true;
            else request.isOwner = false;

            if(request.Manager__r.Id == this.me
                && request.Status__c == this.REQUEST_STATUS.SUBMITTED) request.isManager = true;
            else request.isManager = false;

            request.color = this.mapColors(request.Status__c);
        });
    }

    async fetchRequests(){
        let requests = await getRequests();
        this.markRequests(requests);
        if(this.isFiltered) requests = requests.filter(req => req.Owner.Id === this.me);
        this.requests = requests;
    }

    async connectedCallback(){
        this.me = await meQuery();
        const status = await getStatusTypes();
        status.forEach(entry => {
            this.REQUEST_STATUS[entry.toUpperCase()] = entry;
            this.tableInfoBadges.push({
                name: entry,
                color: this.mapColors(entry)
            });
        });
        const types = await getRequestTypes();
        types.forEach(type => {
            this.requestTypes.push({
                label: type,
                value: type
            })
        });
        await this.fetchRequests();
        setInterval(async ()=>{
            await this.fetchRequests();
        }, 1000);
    }

    openModal(){
        const modalWindow = this.template.querySelector('c-modal');
        modalWindow.openModal();
        modalWindow.checkManager();
    }

    changeFiltered(){
        this.isFiltered = !this.isFiltered;
    }

    async removeRecord(event){
        const id = event.target.dataset.id;
        const isSuccessful = await removeRequest({
            'id': id
        });
        if(isSuccessful) this.requests = this.requests.filter((item) => item.Id != id);
        else{
            const evt = new ShowToastEvent({
                title: 'Error',
                message: 'An error when deleting a record',
                variant: 'error',
            });
            this.dispatchEvent(evt);
        }
    }

    async submitRecord(event){
        const id = event.target.dataset.id;
        await updateStatus({
            'id': id,
            'status': this.REQUEST_STATUS.SUBMITTED
        });
    }

    async approveRecord(event){
         const id = event.target.dataset.id;
         await updateStatus({
              'id': id,
              'status': this.REQUEST_STATUS.APPROVED
         });
    }
}