@isTest
public with sharing class PipeLineNotesResponseTest {
     @isTest
    public static void  PipeLineNotesResponseMethodTest()
    {
    
    PipelineNotesResponse objPipeLine = new PipelineNotesResponse();
        objPipeLine.Id='00300000003T2PGAA0';
        objPipeLine.Title='Test title';
        objPipeLine.Body='Test body';
        objPipeLine.owner='SF';
        objPipeLine.ownerType='Admin';
        objPipeLine.LastModifiedDate='01/01/2017';
                    
 	System.assertEquals(objPipeLine.ownerType, 'Admin');
    }

}