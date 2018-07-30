trigger ClientToDeclarationTrigger on Client__c (After insert) {

    for(Client__c  c:trigger.new) {
        
        Declaration__c  Declaration = new Declaration__c ();
         Declaration.Name=c.Name+'_Declarartion'; 
        Declaration.Outstanding_Judgments__c = 'No'; 
        Declaration.Lawsuit__c = 'No';
        Declaration.Delinquent__c = 'No';            
        Declaration.Delinquent_FHA_VA_Case__c = '';
        Declaration.Delinquent_Reason__c = '';
        Declaration.CashtoClose__c = 'No';
        Declaration.CashtoClose_Borrowed_Money__c = 'No';
        Declaration.Endorser__c = 'No';
        Declaration.US_Citizen__c = 'Yes'; 
        Declaration.Primary_Residence__c = 'Yes'; 
        Declaration.Bankruptcy__c = 'No'; 
        Declaration.Bankruptcy_Reason__c = '';
        Declaration.ReverseMortgage__c = 'No';
        Declaration.Delinquent_Date_of_the_Debt__c = date.today();
        Declaration.ReverseMortgage_finproduct__c = '';
        Declaration.FHA_Insured_Loan__c = 'No'; 
        Declaration.Ethnicity__c = 'Hispanic or Latino' ;
        Declaration.Race__c = 'American Indian or Alaska Native' ;
        Declaration.Sex__c = 'Male'; 
        Declaration.DeclarationLoan__c = c.LoanId__c;
        Declaration.DeclarationClient__c = c.Id;
        insert Declaration;
        system.debug('income data'+ Declaration);
    }
}