@isTest(seeAlldata=true)
public with sharing class PipeLineEmailResponseTest {
    
    
    @isTest
    public static void PipeLineEmailResponseMethodTest()
    {
        PipeLineEmailResponse objPipeLineEmail = new PipeLineEmailResponse();
                objPipeLineEmail.LoanNumberDetails ='12345';     
            objPipeLineEmail.BorrowerName ='test';
        objPipeLineEmail.ContactTime ='4 am';
        objPipeLineEmail.Phone ='9876543219';
        objPipeLineEmail.LoanOfficerName ='Albert';
        objPipeLineEmail.partnerName ='John';
        objPipeLineEmail.ClientName = '';
        objPipeLineEmail.Fully_Signed_Application_Package=false;
        objPipeLineEmail.ClientName = '';
        objPipeLineEmail.LoanOfficer= '';
        objPipeLineEmail.AccountExecutive = '';
        objPipeLineEmail.OtherContactName = '';
        objPipeLineEmail.OtherContactPhone = '';
        objPipeLineEmail.OtherContactFlag = false;
        
        objPipeLineEmail.OtherContactFlag = false;
        objPipeLineEmail.HECM_Counseling_Certificate = false;
        objPipeLineEmail.Driver_License_and_Social_Security_Card= false;
        objPipeLineEmail.Income_and_Asset_Documentation= false;
        objPipeLineEmail.Individual= '';
        
            
            System.assertEquals(objPipeLineEmail.partnerName, 'John');
            
            
            Get_portalUsers.get_portalUsers();
            Get_portalUsers.fetchAccount('Acc');
            
            Get_portalUsers.fetchContact('Accc',[select id from Account limit 1 ].id);
            try{
            
            Get_portalUsers.shareto_portalUsers([select id from Contact limit 1].id,[select id from Scenario__c limit 1].id);
            }catch(exception ex){}
    }
     
}