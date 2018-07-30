/****
* Author :Ravi
********/

public class Opportunity_field_populator{
    
    
    
    public static void CreateOpportunityForLoan(List<Loan_new__c> newLoans){
        Contact Acc ;
        try{
            try{
            Acc  = [select firstname,lastname,AccountId,Account.name,Id from Contact where id=:[select ContactId from user where id=:Userinfo.getuserid()].ContactId]; 
            system.debug('Contact Value---  '+Acc);
            }catch(exception ex){
                
                Acc = new Contact();
                Acc.firstname = 'aasd';
                Acc.lastname = 'test';
            }
            list<Opportunity> RelatedOpportunities = new list<Opportunity>();
            
            for(Loan_new__c  eachloan:newLoans){
                system.debug('eachloan---  '+eachloan);
                Opportunity opp = new Opportunity();
                Opp.Accountid = Acc.AccountId  ;
                Opp.Name= Acc.firstname +' '+Acc.lastname;
                try{
                Opp.Estimated_Home_Value__c = eachloan.Estimate_of_Appraised_Value__c;
                     }catch(exception ex){}
                try{
                if(null!=eachloan.Margin__c){         Opp.Margin__c = Decimal.ValueOf(eachloan.Margin__c);
                }
                }catch(exception ex){}
                Opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Loan').getRecordTypeId();
                Opp.StageName = 'Proposal';
                Opp.Loan__c = eachloan.id;
                Opp.Application_Date__c = System.Today();
                // Opp.Probability = System.now().addDays(45);
                
                Opp.CloseDate=  System.Today().addDays(45);
                Opp.Related_Individual__c = userinfo.getUserId();
                
                RelatedOpportunities.add(Opp);
            }
            
            //    if(!RelatedOpportunities.isEmpty()){
            
            insert RelatedOpportunities;
            system.debug('RelatedOpportunities---  '+RelatedOpportunities);
        }catch(exception ex){
            system.debug('ex---  '+ex.getMessage());
        }
    }
    
    
    
    
    
    public static void update_opportunity(String loanID){
        
        try{list< Opportunity> opp = [select id,Name from opportunity where Loan__c=:loanID];
            Client__c   ClientRecord = [SELECT Id,  Last_Name__c, First_Name__c FROM Client__c where LoanId__c = :loanID and Primary_Client_for_the_Loan__c = true];
            
            list< Opportunity> updateList = new list<Opportunity>();
            for(Opportunity op:opp){
                op.name = ClientRecord.Last_Name__c+' '+ClientRecord.First_Name__c;  updateList.add(op);
            }
            if(!updateList.isEmpty()){ update updateList;
            }       
            
        }catch(Exception ex){}
    }
    
}