public class CreateLoanFromScenario {
    
    
    @AuraEnabled
    public static void updateSenario(String senarioid,String loanId){
        
        
        Scenario__c se = [select id,ClientId__r.Email_Optional__c,ClientId__c,ClientId__r.State__c,ClientId__r.Street_Address__c,ClientId__r.DOB__c,
                          ClientId__r.Name,ClientId__r.Last_Name__c,ClientId__r.Phone_Number__c,
                          is_Converted__c,Loan__c,Date_of_birth__c,Estimated_home_value__c,Margin__c from Scenario__c where id=:senarioid];
        
        se.is_Converted__c = true;
        //   se.Loan__c = loanId ;
        
        update se;
        
    }
    
    @AuraEnabled
    public static string getFNMData(Blob filedata, String fileName, String base64Data, String contentType, String applicationDate,String senario_id) {
        
        Scenario__c se = [select id,Client_Lead__r.Postalcode,Client_Lead__r.email,Client_Lead__c,Client_Lead__r.State,Client_Lead__r.street,Client_Lead__r.DOB__c,
                          Client_Lead__r.FirstName,Client_Lead__r.Lastname,Client_Lead__r.Phone,Client_Lead__r.city,
                          is_Converted__c,Loan__c,Date_of_birth__c,Estimated_home_value__c,Margin__c from Scenario__c where id=:senario_id];
        
        
        
        
        id loanid;
        try{
            Loan_New__c loan = new Loan_New__c();
            if(!test.isRunningTest()){
                // try{
                // Call fannie mae parser and map response details to loan object
                FNMResponse fnmResponse = FNMParseService.parseFNM(filedata);
                //Code Modified by Dev4 for ORMSFDC-1471
                loan = FNMMapperService.createLoanFromFNMResponse(fnmResponse, Date.valueOf(applicationDate),'ARM','FHA Traditional HECM');
                //Code ended by Dev4 for ORMSFDC-1471
                loanid = loan.id;
                
            }
            if(loan.Subject_Property_Address__c ==null || loan.Subject_Property_Address__c ==''){ 
             loan.Subject_Property_Address__c = se.Client_Lead__r.Street;
                                                                                                 
                                                                                                }
            
            if(loan.Subject_Property_City__c ==null || loan.Subject_Property_City__c ==''){ 
        //    loan.Subject_Property_City__c = se.Client_Lead__c.City__c;
                                                                                           
                                                                                          }
            
            if(loan.Subject_Property_State__c ==null || loan.Subject_Property_State__c ==''){  
             loan.Subject_Property_State__c =se.Client_Lead__r.State;
                                                                                             
                                                                                            }
            
            if(loan.Subject_Property_Zip_Code__c ==null || loan.Subject_Property_Zip_Code__c ==''){    
            loan.Subject_Property_Zip_Code__c =se.Client_Lead__r.Postalcode;
                                                                                                   
                                                                                                  }
            loan.Margin__c = ''+se.Margin__c;
            try{   
                update loan;
            }catch(Exception ex){}
            se.is_Converted__c = true; se.Loan__c = loanid ;
            try{
                update se;
            }catch(exception ex){}
            try{
                System.debug('>>>>>> '+loanid);
                String LoanIDName = [select Name from Loan_New__c where id=: loanid].Name;
                
                
                //MailSend.SendMail2ORM(LoanIDName);
                //MailSend.SendMail2Partner(LoanIDName);
                LoanDateController.saveTheFile(loanid, fileName,  base64Data,  contentType);
            }
            catch(exception e)
            {
                system.debug('getFNMData--Exception---'+e);
            }
            
        }
        catch(exception e)
        {
            system.debug('getFNMData--Exception---'+e);
        }
        
        return loanid;
    }
    
    
    
    @AuraEnabled
    public Static Loan_New__c createLoan(String senarioid){
        
        Scenario__c se = [select id,BayDocsOrderNumber__c,Client_Lead__c,Client_Lead__r.Street,Client_Lead__r.Postalcode,Client_Lead__r.State,Client_Lead__r.Email,ClientId__c,Client_Lead__r.DOB__c,
                          Client_Lead__r.FirstName,Client_Lead__r.LastName,Client_Lead__r.Phone,Client_Lead__r.city,
                          is_Converted__c,Loan__c,Date_of_birth__c,Estimated_home_value__c,Margin__c from Scenario__c where id=:senarioid];
       
     //  try{
       Lead ld = [select id,status from lead where id=:se.Client_Lead__c]; 
       ld.status='Scenario Converted';
     
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(ld.id);
        
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);
        user u = [select id,contactid,Contact.AccountId from user where id=:userinfo.getuserid()];
        lc.setAccountId(u.contact.AccountId);
       // lc.setAccountId(u.contactid);
        
       // Database.LeadConvertResult lcr = Database.convertLead(lc);
        //System.assert(lcr.isSuccess());
     update ld;
      // }catch(Exception e){}
        Client__c cl = new client__c();
        cl.Name = se.Client_Lead__r.FirstName+ ' '+ se.Client_Lead__r.LastName;
        cl.Primary_Client_for_the_Loan__c = true;
        cl.DOB__c = se.Client_Lead__r.DOB__c;
        cl.First_Name__c = se.Client_Lead__r.FirstName;
        cl.Last_Name__c = se.Client_Lead__r.LastName;
        cl.Home_Phone__c = se.Client_Lead__r.Phone;
        cl.Email_Optional__c= se.Client_Lead__r.Email;
        //   cl.State__c = se.ClientId__r.Client_State__c;
        //   cl.Street_Address__c = se.ClientId__r.Street_Address__c;
        //   cl.Zip__c = se.ClientId__r.Zip__c;
        
        // if(null != se.ClientId__r.Email_Optional__c)
        // cl.Client_has_Email_Address__c = true;
        
        cl.Primary_Client_for_the_Loan__c = true;
        
        
        Loan_New__c newLoan = new Loan_New__c();
        newLoan.Estimate_of_Appraised_Value__c = se.Estimated_home_value__c;
        newLoan.Margin__c = String.valueOf(se.Margin__c);
        newLoan.Application_Date__c = System.today();        
        newLoan.Subject_Property_Address__c = se.Client_Lead__r.Street;
        newLoan.Subject_Property_City__c = se.Client_Lead__r.city;//se.ClientId__r.City__c;
        newLoan.Subject_Property_State__c =se.Client_Lead__r.State;
        newLoan.Subject_Property_Zip_Code__c =se.Client_Lead__r.Postalcode;
        newLoan.Related_Partner__c = [select Contact.AccountId from user Where id=:userinfo.getUserid()].Contact.AccountId;
        newLoan.Account_Number__c = '1234';
        newLoan.BayDocsOrderNumber__c = se.BayDocsOrderNumber__c;
        // try{
        insert newLoan;
        //}catch(Exception ex){}
        se.is_Converted__c = true;
        se.Loan__c = newLoan.id ;
        update se;
        cl.LoanId__c =  newLoan.Id;
        insert cl;
        SAL_ClientController.CreateDeclaration(cl,newLoan.Id);
        System.debug('>>>> newLoan.id '+newLoan.id);
        return [select id,name from Loan_New__c where id=:newLoan.id][0];
    } 
    
}