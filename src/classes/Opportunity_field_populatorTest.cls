@isTest
public with sharing class Opportunity_field_populatorTest {
    
    
    @isTest
    public static void testmethod1()
    {
    Loan_New__c ln = new Loan_new__c();
    insert ln;
    opportunity opp = new Opportunity();
    opp.Name = 'test';
    opp.StageName = 'Closed';
    opp.CloseDate = system.today();
    
    insert opp;
    
    Opportunity_field_populator.CreateOpportunityForLoan([select id from Loan_new__c limit 1]);
    
    Opportunity_field_populator.update_opportunity('');
    }
    
    
    
    }