public with sharing class LoanHistoryController {
    @AuraEnabled(cacheable=true)
    public static List<Loan_Request__c> getUserLoanHistory() {
        return [
            SELECT Id, Name, Loan_Type__c, Amount_Requested__c, Approval_Status__c, CreatedDate
            FROM Loan_Request__c
            WHERE CreatedById = :UserInfo.getUserId()
            ORDER BY CreatedDate DESC
        ];
    }
}