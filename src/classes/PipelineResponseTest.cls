@isTest
public with sharing class PipelineResponseTest {
    
    
    @isTest
    public static void PipelineResponseMethodTest()
    {
    
    PipelineResponse objPipeLine = new PipelineResponse();
        objPipeLine.Loanid='00300000003T2PGAA0';
        objPipeLine.LoanNumber='123';
        objPipeLine.FullName='john albert';
        objPipeLine.LoanStatus='active';
        objPipeLine.LoanDate='01/01/2017';
                    
 System.assertEquals(objPipeLine.FullName, 'john albert');
    }
     
}