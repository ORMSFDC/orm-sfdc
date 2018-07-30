@isTest
public with sharing class GetProcessThumlnailURLTest {
  @isTest static void  getProcessThumlnailURLTest(){   
      Process_Videos__c proc = new Process_Videos__c();
         proc.ProcessVideoHeader__c = 'Salesforce Video';
         proc.ProcessVideoURL__c = 'https://www.youtube.com/embed/ue80QwXMRHg';
         insert proc;
  } 
}