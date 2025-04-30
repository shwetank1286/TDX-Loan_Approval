import { LightningElement, wire } from 'lwc';
import getUserLoanHistory from '@salesforce/apex/LoanHistoryController.getUserLoanHistory';

export default class LoanHistoryViewer extends LightningElement {
    loanRequests;
    error;

    columns = [
        { label: 'Loan Type', fieldName: 'Loan_Type__c' },
        { label: 'Amount', fieldName: 'Amount_Requested__c', type: 'currency' },
        { label: 'Status', fieldName: 'Approval_Status__c' },
        { label: 'Submitted On', fieldName: 'CreatedDate', type: 'date' }
    ];

    @wire(getUserLoanHistory)
    wiredLoans({ error, data }) {
        if (data) {
            this.loanRequests = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.loanRequests = undefined;
        }
    }
}