@isTest(seeAlldata=true)
public with sharing class ScenarioExportUtilTest {
      @isTest static void getScenarioListTest(){
       ScenarioExportUtil.getExportForscenarioId([select id from Scenario__c limit 1].id);
    //   ScenarioChannelClient.sendEvent('test',   ScenarioExportUtil.getExportForscenarioId([select id from Scenario__c limit 1].id),'');
      
      }
        
        
         @isTest static void getScenarioListTestNew(){
    //   ScenarioExportUtil.getExportForscenarioId([select id from Scenario__c limit 1].id);
      ScenarioChannelClient.sendEvent('test',   ScenarioExportUtil.getExportForscenarioId([select id from Scenario__c limit 1].id),[select id from Scenario__c  limit  1].id);
      
      }
      
      
    /*   @isTest
    public static void testExport1() {
      ScenarioPackageSubmitted__e  appSubmittedEvent = new ScenarioPackageSubmitted__e (ScenarioId__c=[select id from Scenario__c limit 1].id);
        Test.startTest();
         Database.SaveResult sr = EventBus.publish(appSubmittedEvent);
         
         Test.stopTest();
    }*/

}