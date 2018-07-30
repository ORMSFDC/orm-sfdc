@isTest(seeAlldata=true)
public with sharing class ContactFieldPopulatorTest {
    
    @isTest static void fetchClientsTest() {
    ContactFieldPopulator.CreateContactFromClient([select First_Name__c,Primary_Client_for_the_Loan__c,Last_Name__c,Street_Address__c,City__c,State__c,Zip__c,Email_Optional__c from Client__c where Primary_Client_for_the_Loan__c=true limit 1]);
    
    }
    
    
    }