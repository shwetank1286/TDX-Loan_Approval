trigger LoanRequestTrigger on Loan_Request__c (after insert) {
    List<Case> casesToCreate = new List<Case>();

    // Step 1: Prepare Case records based on Loan_Request__c
    for (Loan_Request__c loan : Trigger.New) {
        Case c = new Case();
        c.Subject = 'Loan Application - ' + loan.Loan_Type__c;
        c.Origin = 'Web';
        c.Status = 'New';
        c.Description = loan.User_Query__c;
        c.SuppliedName = loan.Applicant_Name__c;
        c.SuppliedEmail = loan.Applicant_Email__c;
        casesToCreate.add(c);
    }

    // Step 2: Insert Case records
    insert casesToCreate;

    // Step 3: Prepare Loan_Request__c records for update
    List<Loan_Request__c> loansToUpdate = new List<Loan_Request__c>();

    Integer index = 0;
    for (Loan_Request__c loan : Trigger.New) {
        Loan_Request__c loanUpdate = new Loan_Request__c(
            Id = loan.Id,
            Linked_Case__c = casesToCreate[index].Id
        );
        loansToUpdate.add(loanUpdate);
        index++;
    }

    // Step 4: Update Loan_Request__c records
    if (!loansToUpdate.isEmpty()) {
        update loansToUpdate;
    }
}