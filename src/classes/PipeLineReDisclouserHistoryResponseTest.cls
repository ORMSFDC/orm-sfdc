@isTest
public with sharing class PipeLineReDisclouserHistoryResponseTest {
    
    @isTest
    public static void PipeLineReDisclouserMethodResponseTest()
    {
        PipeLineReDisclouserHistoryResponse pipeLineHistoryRes = new PipeLineReDisclouserHistoryResponse();
        pipeLineHistoryRes.CurrentDisclouserDate = '01/01/1990';
        pipeLineHistoryRes.oldDisclouserDate = '01/01/1991';
        pipeLineHistoryRes.DisclouserReason = 'Disclouser';
        pipeLineHistoryRes.ReasonChangeDate = '01/01/1993';
        
        System.assertEquals(pipeLineHistoryRes.DisclouserReason, 'Disclouser');
    }
    
}