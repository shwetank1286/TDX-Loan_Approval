import { LightningElement, track } from 'lwc';
import createLoanRequestWithDetails from '@salesforce/apex/LoanRequestController.createLoanRequestWithDetails';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class LoanRequestForm extends LightningElement {
    @track loanType = '';
    @track amount = '';
    @track interestRate = '';
    @track userQuery = '';
    @track applicantName = '';
    @track applicantEmail = '';

    @track recordId;
    @track success = false;
    @track error;

    loanOptions = [
        { label: 'Home', value: 'Home' },
        { label: 'Car', value: 'Car' },
        { label: 'Personal', value: 'Personal' },
        { label: 'Education', value: 'Education' }
    ];

    handleLoanType(event) {
        this.loanType = event.detail.value;
    }

    handleAmount(event) {
        this.amount = event.target.value;
    }

    handleRate(event) {
        this.interestRate = event.target.value;
    }

    handleQuery(event) {
        this.userQuery = event.target.value;
    }

    handleName(event) {
        this.applicantName = event.target.value;
    }
    
    handleEmail(event) {
        this.applicantEmail = event.target.value;
    }
    

    handleSubmit() {
        // Validate input before making the Apex call
        if (!this.loanType || !this.amount || !this.interestRate || !this.userQuery) {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error',
                    message: 'All fields are required.',
                    variant: 'error'
                })
            );
            return;
        }

        // Call Apex method
        createLoanRequestWithDetails({
            loanType: this.loanType,
            amount: parseFloat(this.amount),
            userQuery: this.userQuery,
            interestRate: parseFloat(this.interestRate),
            applicantName: this.applicantName,
            applicantEmail: this.applicantEmail
        })
            .then(result => {
                this.recordId = result;
                this.success = true;
                this.error = undefined;

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Your loan is now under approval and submitted successfully! ID: ' + result,
                        variant: 'success'
                    })
                );

                // Clear form after success
                this.applicantName = '';
                this.applicantEmail = '';
                this.loanType = '';
                this.amount = '';
                this.interestRate = '';
                this.userQuery = '';
            })
            .catch(error => {
                console.error('Error submitting loan request:', error);

                let message = 'An unexpected error occurred.';
                if (error && error.body) {
                    if (Array.isArray(error.body)) {
                        message = error.body.map(e => e.message).join(', ');
                    } else if (error.body.message) {
                        message = error.body.message;
                    }
                }

                this.error = message;
                this.success = false;

                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Submission Failed',
                        message: message,
                        variant: 'error'
                    })
                );
            });
    }
}