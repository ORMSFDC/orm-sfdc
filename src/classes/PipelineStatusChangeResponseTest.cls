@isTest
public class PipelineStatusChangeResponseTest {
 @isTest
    public static void PipelineStatusChangeResponseTestMethod()
    {
    
    PipeLineStatusChangeResponse objPipeLineSummary = new PipeLineStatusChangeResponse();
                objPipeLineSummary.LoanCurrentStatus ='Current';     
       		objPipeLineSummary.LoanPrevioustatus ='Previuos';
        objPipeLineSummary.LoanStatusChangeDate ='01/01/1991';
       
            System.assertEquals(objPipeLineSummary.LoanCurrentStatus, 'Current');
    }

}