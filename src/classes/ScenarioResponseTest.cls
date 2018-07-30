@isTest
public with sharing class ScenarioResponseTest {
    
    
    @isTest
    public static void ScenarioResponseMethodTest()
    {
    
    ScenarioResponse objScenario = new ScenarioResponse();
        
       
        objScenario.modelType ='test';     
       		objScenario.modelType ='test';
        objScenario.annualLiborChangeDate ='01/01/2017';
        objScenario.annualMIP =100.00;
        objScenario.lendersMargin =100.00;
        objScenario.growthRateInitial =100.00;
        objScenario.growthRateAverage10yr =100.00;
        objScenario.growthRateAverage20yr =100.00;
        objScenario.apr =100.00;
        objScenario.annualLibor =100.00;
        //objScenario.priority.add('LOC And CashFlow');
        List<string> prioritylist = new List<string>();
        {
            prioritylist.add('LOC And CashFlow');
            objScenario.priority=prioritylist;
        }
            System.assertEquals(objScenario.modelType, 'test');
    }
     
}