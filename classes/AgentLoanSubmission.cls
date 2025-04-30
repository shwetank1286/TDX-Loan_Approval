public with sharing class AgentLoanSubmission {

    public class LoanRequestInput {
        @InvocableVariable(required=true)
        public String user_name;

        @InvocableVariable(required=true)
        public String user_email;

        @InvocableVariable(required=true)
        public String loan_type;

        @InvocableVariable(required=true)
        public Decimal loan_amount;

        @InvocableVariable(required=true)
        public Decimal interest_rate;

        @InvocableVariable
        public String loan_reason;
    }

    public class LoanRequestOutput {
        @InvocableVariable
        public String loanId;

        @InvocableVariable
        public String status;
    }

    @InvocableMethod(label='Create Loan Request for AgentForce')
    public static List<LoanRequestOutput> createLoan(List<LoanRequestInput> inputs) {
        List<LoanRequestOutput> results = new List<LoanRequestOutput>();

        for (LoanRequestInput input : inputs) {
            Loan_Request__c loan = new Loan_Request__c(
                Applicant_Name__c = input.user_name,
                Applicant_Email__c = input.user_email,
                Loan_Type__c = input.loan_type,
                Amount_Requested__c = input.loan_amount,
                Interest_Rate__c = input.interest_rate,
                User_Query__c = input.loan_reason,
                Approval_Status__c = 'Pending',
                Case_Status__c = 'New'
            );

            insert loan;

            LoanRequestOutput result = new LoanRequestOutput();
            result.loanId = loan.Id;
            result.status = 'Submitted';
            results.add(result);
        }

        return results;
    }
}