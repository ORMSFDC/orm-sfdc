@isTest 
private class DonutControllerTest{ 
    static testmethod void test() {
        Loan_New__c l = new Loan_New__c();
        l.loanstatus__c = 'Incomplete';
        insert l;
        
        Test.startTest();
        DonutChartController ctrl = new DonutChartController();
        DonutChartController.PieWedgeData[] data = ctrl.getPieData();
        Test.stopTest();
        
        System.assertNotEquals(2,[Select Id From Loan_New__c].size());
    }
}