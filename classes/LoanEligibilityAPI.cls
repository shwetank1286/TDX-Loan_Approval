@RestResource(urlMapping='/loan/eligibility')
global with sharing class LoanEligibilityAPI {

    @HttpPost
    global static LoanEligibilityResponse checkEligibility() {
        RestRequest req = RestContext.request;
        String requestBody = req.requestBody.toString();
        
        // Parse JSON
        Map<String, Object> input = (Map<String, Object>) JSON.deserializeUntyped(requestBody);
        Decimal income = Decimal.valueOf(String.valueOf(input.get('income')));
        Decimal amount = Decimal.valueOf(String.valueOf(input.get('loan_amount')));

        Boolean eligible = (income >= 30000 && amount <= income * 20);

        // Prepare Response
        LoanEligibilityResponse response = new LoanEligibilityResponse();
        response.eligible = eligible;
        response.maxEligibleAmount = income * 20;

        return response;
    }

    global class LoanEligibilityResponse {
        public Boolean eligible;
        public Decimal maxEligibleAmount;
    }
}