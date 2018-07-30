@isTest
public with sharing class PipeLineDateResponseTest {
    
    @isTest
    public static void PipeLineDateMethodResponseTest()
    {
        PipeLineDateResponse pipeLineDateRes = new PipeLineDateResponse();
        pipeLineDateRes.CounselingDate = '01/01/1990';
        pipeLineDateRes.AppraisalOrderDate = '01/01/1991';
        pipeLineDateRes.FHACaseNaumberDate = '01/01/1992';
        pipeLineDateRes.AppraisalReceivedDate = '01/01/1993';
        //pipeLineDateRes.HOIEffectiveDate = '01/01/1994';
        //pipeLineDateRes.AppraisalSenttoClientDate = '01/01/1995';
        pipeLineDateRes.ApplicationDate = '01/01/1996';
        pipeLineDateRes.ClosingDate = '01/01/1997';
        pipeLineDateRes.ReDiscloserDate = '01/01/1998';
        pipeLineDateRes.NextTaxDueDate = '01/01/1999';
        pipeLineDateRes.ReDiscloserReason = 'for PipeLine Date';        
        pipeLineDateRes.ApplicationSignedDate = '01/01/2018'; //added by Bala
        pipeLineDateRes.TitleOrderedDate= '01/01/1999'; //added by Bala
        pipeLineDateRes.TitleReceivedDate= '01/01/1999';//added by Bala
        pipeLineDateRes.FloodOrderedDate= '01/01/1999'; //added by Bala
        pipeLineDateRes.FloodReceivedDate= '01/01/1999'; //added by Bala
        pipeLineDateRes.InsuranceBinderOrderedDate= '01/01/1999'; //added by Bala
        pipeLineDateRes.InsuranceBinderReceivedDate= '01/01/1999'; //added by Bala
        pipeLineDateRes.CoolingOffNoticeSignedDate= '01/01/2018'; //added by Bala
        pipeLineDateRes.LoanOriginationState= '01/01/1999'; //added by Bala
        pipeLineDateRes.AnticipatedClosingDate= '01/01/1999'; //added by Bala
        pipeLineDateRes.ScheduledClosingDate= '01/01/1999'; //added by Bala
        pipeLineDateRes.ActualFundingDate= '01/01/1999'; //added by Bala
        pipeLineDateRes.PayoffOrderDate= '01/01/1999'; //added by Bala
        pipeLineDateRes.CreditReportDate= '01/01/1999'; //added by Bala
        pipeLineDateRes.AppraisalScheduledDate= '01/01/1999'; //added by Bala
        pipeLineDateRes.AppraisalEffectiveDate= '01/01/1999'; //added by Bala
        
        System.assertEquals(pipeLineDateRes.ReDiscloserReason, 'for PipeLine Date');
    }
    
}