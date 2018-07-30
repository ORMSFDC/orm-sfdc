public class CreateNewPortalUser {
    //After Insert 
    public static void createUser(contact  cntactData) {
        UserLicense UserLcns=[SELECT Id,  TotalLicenses,  UsedLicenses  
                              FROM UserLicense where Status=:'Active' and (MasterLabel=:'Partner Community' or  MasterLabel =:'Partner Community Login')];
        // system.debug('UsedLicenses' + UserLcns.UsedLicenses);
        //system.debug('TotalLicenses' + UserLcns.TotalLicenses);
        string FirstName=cntactData.FirstName==null?'':+', '+cntactData.FirstName;
        string MiddleName=cntactData.MiddleName==null?'':+' '+cntactData.MiddleName;
        string Name=cntactData.LastName+ FirstName+MiddleName;
        // system.debug('cntactData.Name' + Name);
       if(UserLcns.UsedLicenses<UserLcns.TotalLicenses)
           //  if(UserLcns.UsedLicenses<6)x
        {
           Id RecortypeId_old = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Individual Leads').getRecordTypeId();
             Id RecortypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Potential Partner Portal User').getRecordTypeId();
          
            if((cntactData.RecordTypeId==RecortypeId ||  cntactData.RecordTypeId==RecortypeId_old))
            {
                createPortalUser(cntactData); 
            }
            else{
                // system.debug('ApprovedIndividual');
            }
        }
        else{
            //cntactData.addError('NO_LICENSE_AVAILABLE: There are no licenses available to create a portal login for.');
            String AccountName=GetAccountName(cntactData.accountid);
            MailToORMWhenNoLicense(Name,AccountName);
        }
        
    }
    //Get Account Name
    private static string GetAccountName(string  AccountID)
    {
        string AccountName=[select name from account where id=:AccountID].Name;
        return AccountName;
    } 
    //Create Prospective Partner User
    @Testvisible
    private static void createPortalUser(contact  cnt)
    {
        
        string  ProfileId=[select id from profile where name=:Label.Prospective_Partner_User_Label].id;
        string  UserRoleID=[select id from UserRole where name='Loan Officer'].id;
        User theUser = new User(
            Username = cnt.Username__c,
            ContactId = cnt.Id,
            ProfileId = ProfileId,
            Alias = 'ORMS_P',
            Email = cnt.Email,
            EmailEncodingKey = 'UTF-8',
            LastName = cnt.LastName,
            FirstNAme=cnt.FirstName,
            MiddleName=cnt.MiddleName,
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );
        Database.SaveResult srList = Database.insert(theUser, false);        
        // Iterate through each returned result
        Database.SaveResult sr = srList ;
        if (sr.isSuccess()) {
            // Operation was successful, so get the ID of the record that was processed
            //System.debug('Successfully inserted account. Account ID: ' + sr.getId());
        }
        else {
            // Operation failed, so get all errors                
            for(Database.Error err : sr.getErrors()) {
                //StatusCode  ErrorCode 
                if( StatusCode.DUPLICATE_USERNAME==err.getStatusCode())
                {
                    cnt.addError('DUPLICATE_USERNAME: The username you have entered is already in use in Salesforce.');                    
                }
                else
                {
                    string ErrorMsg=err.getMessage();
                    string ErrorCode=String.valueOf(err.getStatusCode());
                    MailtoORMOnOtherError(ErrorCode,ErrorMsg);
                }
                
            }
        }
    }    
    //Send mail to ORM Partner when License is not Available
    @Testvisible
    private static Void MailToORMWhenNoLicense(String ContactName,string AccountName)
    {
        List<Messaging.SingleEmailMessage> mails =new List<Messaging.SingleEmailMessage>();
        // Step 1: Create a new Email
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        // Step 2: Set list of people who should get the email
        List<String> sendTo = new List<String>();
        string UserEmailID= [select user_email_Id__c  from User where id=:userinfo.getUserId()].user_email_Id__c ;
        //string a=UserInfo.getUserEmail();
        string a=UserEmailID;
        sendTo.add(a);
        mail.setToAddresses(sendTo);
        mail.setReplyTo(a);
        mail.setSubject('User Creation Failed As License Not Available.');
        String body ;             
        body='<html><body><div>Dear '+ userinfo.getName() +',</div><div><br></br></div><div>There are no licenses available to create a portal login for the below user: </div>';
        
        body+='<div> Business Individual: '+ ContactName +' </div>';
        body+='<div> Business Partner: '+ AccountName +' </div><br></br>';
        body+='<div> Thank You, </div>'; 
        body+='<div> - The ORMS Support </div>'; 
        body+=  '</body> </html>';      
        mail.setHtmlBody(body);
        mails.add(mail);Messaging.sendEmail(mails);     
    }
    
    //Send mail to ORM Partner when Generic Error Comes
    @Testvisible
    private Static void MailtoORMOnOtherError(string Subject,string ErrorMsg)
    {
        List<Messaging.SingleEmailMessage> mails = 
            new List<Messaging.SingleEmailMessage>();
        // Step 1: Create a new Email
        Messaging.SingleEmailMessage mail = 
            new Messaging.SingleEmailMessage();
        // Step 2: Set list of people who should get the email
        List<String> sendTo = new List<String>();
        string UserEmailID= [select user_email_Id__c  from User where id=:userinfo.getUserId()].user_email_Id__c ;
        //string a=UserInfo.getUserEmail();
        string a=UserEmailID;
        sendTo.add(a);
        mail.setToAddresses(sendTo);
        mail.setReplyTo(a);
        mail.setSubject(Subject);
        String body ;             
        body='<html><body><div>Hello,</div><div><br></br></div><div>'+ErrorMsg+'</div><div><br></br></div>';
        body+='<div> Thank You, </div>'; 
        body+='<div> - The ORMS Support </div>'; 
        body+=  '</body> </html>';      
        mail.setHtmlBody(body);
        mails.add(mail);Messaging.sendEmail(mails);  
    }
    
    //After Update
    public static void ActiveUser(contact NewCnt){
        
        string  ProfileId=[select id from profile where name=:Label.Prospective_Partner_User_Label].id;
        list<user> Usr=new List<user>();
     //   Id RecortypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Approved Individuals').getRecordTypeId();
             Id RecortypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Partner Portal User').getRecordTypeId();
    
        if(NewCnt.RecordtypeId==RecortypeId) 
        {
            Usr=[select isactive,contactid,ProfileId from user where contactid=:NewCnt.Id and ISPortalEnabled=true order by createddate desc limit 1];
            if(!Usr.isEmpty() )
            { 
                // System.debug('Not empyt' );
                if(Usr[0].ProfileId==ProfileId)
                {
                    // System.debug('PPU Profiel Found' );
                    UpdateProfile(Usr[0].id);
                }
                else{
                    // System.debug('PPU Profiel Found Not' );
                }
                if(Usr[0].IsActive==false)
                {
                    //System.debug('Not Active' );
                    UpdateUser(Usr[0].id);
                }
                else{
                    // System.debug('Active' );
                }
            }
            else{
                //System.debug('empty');
            }            
        }
        else{
            //System.debug('Record Type Not MAtched');
        }
    }
    //Activate User for Portal Login
    @future
    @Testvisible
    private Static void UpdateUser(string UserID)
    {
        user UsrObj=new user();
        //UsrObj.Title__c
        UsrObj.id=UserID;
        UsrObj.IsActive=true;
        update UsrObj;
    }
    //Update Profile from PPU to ORM Partner
    @future
    @Testvisible
     private Static void UpdateProfile(string UserID)
    {
        string  ProfileId=[select id from profile where name=:Label.ORM_Partners].id;
        user UsrObj=new user();
        UsrObj.id=UserID;
        UsrObj.ProfileId=ProfileId;
        try{
          update UsrObj;
        }catch(exception ex){}
    }
   
    @AuraEnabled
    public static boolean IsUserActive(string ContactID) {  
        boolean IsActive;
        List<User> UsrLst = new List<User>();  
        boolean IsCheckboxChecked=[select Check_to_create_a_Prospective_User_Login__c from contact where id=: ContactID].Check_to_create_a_Prospective_User_Login__c;
       if(IsCheckboxChecked==true)
       {
           UsrLst = [Select contactId from user where ContactID =: ContactID];
        if(!UsrLst.isEmpty())
        {
            IsActive=true;
        }
        else{
            IsActive=false;
        }
       }
        else{
            
        }
        
        return IsActive;
    }
}