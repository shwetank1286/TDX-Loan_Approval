public with sharing class LoanRequestController {
    @AuraEnabled
    public static void createLoanRequest(String userQuery, String loanType) {
        // Validate input
        if (String.isBlank(userQuery) || String.isBlank(loanType)) {
            throw new AuraHandledException('User query and loan type are required.');
        }

        Loan_Request__c loan = new Loan_Request__c();
        loan.User_Query__c = userQuery;
        loan.Loan_Type__c = loanType;

        // Simple intent detection logic
        String query = userQuery.toLowerCase();
        if (query.contains('apply') || query.contains('need') || query.contains('loan')) {
            loan.Detected_Intent__c = 'Apply_Loan';
        } else if (query.contains('rate') || query.contains('interest')) {
            loan.Detected_Intent__c = 'Interest_Info';
        } else if (query.contains('status')) {
            loan.Detected_Intent__c = 'Status_Check';
        } else {
            loan.Detected_Intent__c = 'Unknown';
        }

        // Set interest rate based on loan type
        if (loanType == 'Home') loan.Interest_Rate__c = 7.5;
        else if (loanType == 'Car') loan.Interest_Rate__c = 9.0;
        else if (loanType == 'Personal') loan.Interest_Rate__c = 11.5;
        else if (loanType == 'Education') loan.Interest_Rate__c = 8.0;

        loan.Case_Status__c = 'New';
        loan.Approval_Status__c = 'Pending';

        insert loan;
    }

    @AuraEnabled
    public static Id createLoanRequestWithDetails(String loanType, Decimal amount, String userQuery, Decimal interestRate, String applicantName, String applicantEmail) {
        Loan_Request__c newLoan = new Loan_Request__c();
        newLoan.Loan_Type__c = loanType;
        newLoan.Amount_Requested__c = amount;
        newLoan.Interest_Rate__c = interestRate;
        newLoan.User_Query__c = userQuery;
        newLoan.Applicant_Name__c = applicantName;
        newLoan.Applicant_Email__c = applicantEmail;
        newLoan.Approval_Status__c = 'Pending';
        
        insert newLoan;
        return newLoan.Id;
    }

}