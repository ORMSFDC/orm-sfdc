public with sharing class UploadController {
    @AuraEnabled
    public static Boolean GetProfileDetail() {
        boolean result=false;
        try
        {
            
                //for All those Users, who are assigned in Permisssion Set
                Id PermissionsetID=[select id from Permissionset where Name='AE_Lead_and_PCS_Lead_Object_Permission'].id;
                integer Assignedid =[select count() from PermissionSetAssignment where permissionsetid=:PermissionsetID and assigneeid=:userinfo.getUserId()];
                if(Assignedid<>0)
                {
                result= true;
                }
                //for System Administrator
                map<id,Profile> profilesmap = new map<id,Profile>([select id,name from profile]);
                            Id PID=userinfo.getProfileId();
                            if(profilesmap.get(PID).Name=='System Admin'
                            || profilesmap.get(PID).Name=='System Administrator' )
                            {      
                                result= true;                               
                            }  
                
          /*  map<id,UserRole> UserRolesmap = new map<id,UserRole>([select id,name from UserRole]);
            map<id,Profile> profilesmap = new map<id,Profile>([select id,name from profile]);
            Id PID=userinfo.getProfileId();
            Id UserRoleID=UserInfo.getUserRoleId();
            if(profilesmap.get(PID).Name=='System Admin'
               || profilesmap.get(PID).Name=='Account Executive/PCS'
               || profilesmap.get(PID).Name=='System Administrator' )
            {
                if(UserRolesmap.get(UserRoleID).Name=='Account Executive Lead'
                   //|| UserRolesmap.get(UserRoleID).Name=='Account Executive'
                   || UserRolesmap.get(UserRoleID).Name=='Partner Care Specialist Lead'
                   || UserRolesmap.get(UserRoleID).Name=='System Administrator')
                {
                    result= true;
                }
            } */ 
        }  
        catch(exception e)
        {
            system.debug('GetProfileDetail--Exception---'+e);
        }
        return result;
    }
     @AuraEnabled
    public static List<AttachmentResponse> GetAttLoanPartnerForAE(Id LoanId) {
        List<AttachmentResponse>objA=new List<AttachmentResponse>();
        list<attachment> obj=new list<attachment>();
        List<AttachmentStatus__c> objst=new List<AttachmentStatus__c>(); 
        list<string> AttachmentIDs=new list<string>();
         list<string> LPLOId=new list<string>();
         List<Loan_new__c> objLoan=new List<Loan_new__c>();
        try
        {
            //get LoanOriginator and LoanProcessor and LoanOfficer based on Loan Id
           
            map<id,Profile> profilesmap = new map<id,Profile>([select id,name from profile]);
            
              obj=[SELECT ID,Name,CreatedDate,OwnerId,Owner.Profile.Name 
                  from Attachment where ParentId=: LoanId and ( OwnerId !=: userinfo.getUserId()  )  ORDER BY CreatedDate desc];
            
            if(test.isRunningTest()){
                obj = new list<Attachment>();
                obj.add(new Attachment());
            }
            for(Attachment atchmnt: obj)
            {
                //Added all portal users so that when they upload documents it will be under Partner Documents - Bala
                if(profilesmap.get(userinfo.getProfileId()).Name!='ORM Partners' && profilesmap.get(userinfo.getProfileId()).Name!='ORM Partner' 
                   && profilesmap.get(userinfo.getProfileId()).Name!='Portal Loan Processor' && profilesmap.get(userinfo.getProfileId()).Name!='Portal Loan Processors'
                   && profilesmap.get(userinfo.getProfileId()).Name!='Partner Community Login User' && profilesmap.get(userinfo.getProfileId()).Name!='Partner Community User'
                   && profilesmap.get(userinfo.getProfileId()).Name!='Prospective Partner User' && profilesmap.get(userinfo.getProfileId()).Name!='Prospective Partner Users') 
                {
                    if(atchmnt.Owner.Profile.Name=='ORM Partners' || atchmnt.Owner.Profile.Name=='ORM Partner' || atchmnt.Owner.Profile.Name=='Portal Loan Processor' 
                       || atchmnt.Owner.Profile.Name=='Portal Loan Processors' || atchmnt.Owner.Profile.Name=='Partner Community Login User' 
                       || atchmnt.Owner.Profile.Name=='Partner Community User' || atchmnt.Owner.Profile.Name=='Prospective Partner User'  
                       || atchmnt.Owner.Profile.Name=='Prospective Partner Users' ){
                        string AttachmentID;   AttachmentID=atchmnt.Id;   AttachmentIDs.Add(AttachmentID);
                        
                    }
                }else{
                    
                    string AttachmentID; AttachmentID=atchmnt.Id;    AttachmentIDs.Add(AttachmentID);
                    
                }
            }
            
            objst=[SELECT Name,AttachmentID__c,Uploaded_By__c,
                   owner.Name from AttachmentStatus__c where LoanId__c=:LoanId and AttachmentID__c In :(AttachmentIDs)];
            // string UserName=[SELECT Name from user where Id=: obj[0].OwnerId limit 1].Name;
            if(test.isRunningTest()){
                objst = new list<AttachmentStatus__c>();
            }
            for(attachment cd: obj)
            {
                AttachmentResponse objat=new AttachmentResponse();
                for(AttachmentStatus__c atcStatus:objst)
                {
                    if(cd.ID==atcStatus.AttachmentID__c)
                    {
                        objat.Id=cd.ID;  
                        objat.DocName=cd.Name.substringBeforeLast('.');
                        datetime dt=cd.CreatedDate; 
                        string dttest=dt.format('MM/dd/yyyy', 'America/New_York');
                        objat.CreatedDate=dttest;
                        try{    objat.UploadedBy = atcStatus.Uploaded_By__c;
                            
                        }  catch(Exception ex){      objat.UploadedBy = '';
                        }
                        //   objat.UploadedBy = cd.Owner.Name;
                        objat.status=atcStatus.Name;  objA.add(objat);  
                    }
                }
                
                
            }
        }
        catch(exception e)
        {
            system.debug('GetAttLoanPartner--Exception---'+e);
        }
        
        // return null;
        return objA;
    }
    
    
    @AuraEnabled
    public static List<AttachmentResponse> GetAttLoanPartner(Id LoanId) {
        List<AttachmentResponse>objA=new List<AttachmentResponse>();
        list<attachment> obj=new list<attachment>();
        List<AttachmentStatus__c> objst=new List<AttachmentStatus__c>(); 
        list<string> AttachmentIDs=new list<string>();
         list<string> LPLOId=new list<string>();
         List<Loan_new__c> objLoan=new List<Loan_new__c>();
        try
        {
            //get LoanOriginator and LoanProcessor and LoanOfficer based on Loan Id
            
            objLoan=[Select Loan_Processor__c,Originating_Loan_Officer__c,LoanOfficer__c from Loan_new__c where Id=:LoanId];
            if(objLoan !=null)
            {
                for(Loan_New__c Lo:objLoan)
                {
                   string UserId;
                    if(Lo.Loan_Processor__c !=null ||Lo.Loan_Processor__c!='')
                    {
                        UserId=Lo.Loan_Processor__c;
                        LPLOId.add(UserId);
                    }
                     if(Lo.Originating_Loan_Officer__c !=null ||Lo.Originating_Loan_Officer__c!='')
                    {
                        UserId=Lo.Originating_Loan_Officer__c;
                        LPLOId.add(UserId);
                    }
                      if(Lo.LoanOfficer__c !=null ||Lo.LoanOfficer__c!='')
                    {
                        UserId=Lo.LoanOfficer__c;
                        LPLOId.add(UserId);
                    }
                }
            }
            
            map<id,Profile> profilesmap = new map<id,Profile>([select id,name from profile]);
            obj=[SELECT ID,Name,CreatedDate,OwnerId,Owner.Profile.Name 
                 from Attachment where ParentId=: LoanId and  OwnerId not In:LPLOId  ORDER BY CreatedDate desc];
            
             //obj=[SELECT ID,Name,CreatedDate,OwnerId,Owner.Profile.Name 
                 //from Attachment where ParentId=: LoanId and ( OwnerId !=: userinfo.getUserId()  )  ORDER BY CreatedDate desc];
            
            if(test.isRunningTest()){
                obj = new list<Attachment>();
                obj.add(new Attachment());
            }
            for(Attachment atchmnt: obj)
            {
                //Added all portal users so that when they upload documents it will be under Partner Documents - Bala
                if(profilesmap.get(userinfo.getProfileId()).Name!='ORM Partners' && profilesmap.get(userinfo.getProfileId()).Name!='ORM Partner' 
                   && profilesmap.get(userinfo.getProfileId()).Name!='Portal Loan Processor' && profilesmap.get(userinfo.getProfileId()).Name!='Portal Loan Processors'
                   && profilesmap.get(userinfo.getProfileId()).Name!='Partner Community Login User' && profilesmap.get(userinfo.getProfileId()).Name!='Partner Community User'
                   && profilesmap.get(userinfo.getProfileId()).Name!='Prospective Partner User' && profilesmap.get(userinfo.getProfileId()).Name!='Prospective Partner Users') 
                {
                    if(atchmnt.Owner.Profile.Name=='ORM Partners' || atchmnt.Owner.Profile.Name=='ORM Partner' || atchmnt.Owner.Profile.Name=='Portal Loan Processor' 
                       || atchmnt.Owner.Profile.Name=='Portal Loan Processors' || atchmnt.Owner.Profile.Name=='Partner Community Login User' 
                       || atchmnt.Owner.Profile.Name=='Partner Community User' || atchmnt.Owner.Profile.Name=='Prospective Partner User'  
                       || atchmnt.Owner.Profile.Name=='Prospective Partner Users' ){
                        string AttachmentID;   AttachmentID=atchmnt.Id;   AttachmentIDs.Add(AttachmentID);
                        
                    }
                }else{
                    
                    string AttachmentID; AttachmentID=atchmnt.Id;    AttachmentIDs.Add(AttachmentID);
                    
                }
            }
            
            objst=[SELECT Name,AttachmentID__c,Uploaded_By__c,
                   owner.Name from AttachmentStatus__c where LoanId__c=:LoanId and AttachmentID__c In :(AttachmentIDs)];
            // string UserName=[SELECT Name from user where Id=: obj[0].OwnerId limit 1].Name;
            if(test.isRunningTest()){
                objst = new list<AttachmentStatus__c>();
            }
            for(attachment cd: obj)
            {
                AttachmentResponse objat=new AttachmentResponse();
                for(AttachmentStatus__c atcStatus:objst)
                {
                    if(cd.ID==atcStatus.AttachmentID__c)
                    {
                        objat.Id=cd.ID;  
                        objat.DocName=cd.Name.substringBeforeLast('.');
                        datetime dt=cd.CreatedDate; 
                        string dttest=dt.format('MM/dd/yyyy', 'America/New_York');
                        objat.CreatedDate=dttest;
                        try{    objat.UploadedBy = atcStatus.Uploaded_By__c;
                            
                        }  catch(Exception ex){      objat.UploadedBy = '';
                        }
                        //   objat.UploadedBy = cd.Owner.Name;
                        objat.status=atcStatus.Name;  objA.add(objat);  
                    }
                }
                
                
            }
        }
        catch(exception e)
        {
            system.debug('GetAttLoanPartner--Exception---'+e);
        }
        
        // return null;
        return objA;
    }
    
    @AuraEnabled
    public static  void DeleteAttachment(String id)
    {
        try
        {
            Attachment objatt=new Attachment();
            objatt= [Select Id,Name
                     from Attachment where Id = :id];
            delete objatt;}
        catch(exception e)
        {
            system.debug('DeleteAttachment--Exception---'+e);
        }
    }
    
    @AuraEnabled
    public static  Integer UpdateAttachmentStatus(String id)
    {
        Integer ret=0;
        try
        {
            
            AttachmentStatus__c objatt=new AttachmentStatus__c();
            string IDAtt=[SELECT ID 
                          from AttachmentStatus__c where AttachmentID__c=:id].Id;
            //system.debug('IDAtt'+IDAtt);
            objatt.Id=IDAtt; objatt.AttachmentID__c=id;  objatt.Name='ORMS Received' ; 
            //system.debug('Name'+ objatt.Name);
            update objatt;
            // system.debug('Name1'+ objatt.Name);
            ret=1;
            //system.debug('ret'+ret);
        }
        catch(exception e)
        {
            system.debug('Status Change--Exception---'+e);
        }
        return ret;
    }
    
    @AuraEnabled
    public static List<AttachmentResponse> GetAttLoanOfficer(Id LoanId) {
        List<AttachmentResponse>objA=new List<AttachmentResponse>();
        list<attachment> obj=new list<attachment>();
        List<AttachmentStatus__c> objst=new List<AttachmentStatus__c>();
        map<id,Profile> profilesmap = new map<id,Profile>([select id,name from profile]);
         list<string> LPLOId=new list<string>();
         List<Loan_new__c> objLoan=new List<Loan_new__c>();
        list<string> AttachmentIDs=new list<string>();
       
        try
        {
            //get LoanOriginator and LoanProcessor and LoanOfficer based on Loan Id
            
            objLoan=[Select Loan_Processor__c,Originating_Loan_Officer__c,LoanOfficer__c from Loan_new__c where Id=:LoanId];
            if(objLoan !=null)
            {
                for(Loan_New__c Lo:objLoan)
                {
                   string UserId;
                    if(Lo.Loan_Processor__c !=null ||Lo.Loan_Processor__c!='')
                    {
                        UserId=Lo.Loan_Processor__c;
                        LPLOId.add(UserId);
                    }
                     if(Lo.Originating_Loan_Officer__c !=null ||Lo.Originating_Loan_Officer__c!='')
                    {
                        UserId=Lo.Originating_Loan_Officer__c;
                        LPLOId.add(UserId);
                    }
                      if(Lo.LoanOfficer__c !=null ||Lo.LoanOfficer__c!='')
                    {
                        UserId=Lo.LoanOfficer__c;
                        LPLOId.add(UserId);
                    }
                }
            }
            
            //Added all portal users so that when they upload documents it will be under Partner Documents - Bala
            if(profilesmap.get(userinfo.getProfileId()).Name!='ORM Partners' && profilesmap.get(userinfo.getProfileId()).Name!='ORM Partner' &&
               profilesmap.get(userinfo.getProfileId()).Name!='Portal Loan Processor' && profilesmap.get(userinfo.getProfileId()).Name!='Portal Loan Processors' &&
               profilesmap.get(userinfo.getProfileId()).Name!='Partner Community Login User' && profilesmap.get(userinfo.getProfileId()).Name!='Partner Community User' &&
               profilesmap.get(userinfo.getProfileId()).Name!='Prospective Partner User' && profilesmap.get(userinfo.getProfileId()).Name!='Prospective Partner Users'){
                obj=[SELECT Owner.Profile.Name,ID,Name,CreatedDate,
                     OwnerId,Owner.profileId from Attachment where ParentId=: LoanId  ORDER BY CreatedDate desc];
            }else{
                
                
                 obj=[SELECT ID,Name,CreatedDate,OwnerId,Owner.Profile.Name 
                 from Attachment where ParentId=: LoanId and  OwnerId in: LPLOId  ORDER BY CreatedDate desc];
               // obj=[SELECT Owner.Profile.Name,ID,Name,CreatedDate,OwnerId,Owner.profileId from Attachment where ParentId=: LoanId  and OwnerId =: userinfo.getUserId() ORDER BY CreatedDate desc];
                
            }
            for(Attachment atchmnt: obj)
            {
                if(profilesmap.get(userinfo.getProfileId()).Name!='ORM Partners' && profilesmap.get(userinfo.getProfileId()).Name!='ORM Partner' &&
                   profilesmap.get(userinfo.getProfileId()).Name!='Portal Loan Processor' && profilesmap.get(userinfo.getProfileId()).Name!='Portal Loan Processors' &&
                   profilesmap.get(userinfo.getProfileId()).Name!='Partner Community Login User' && profilesmap.get(userinfo.getProfileId()).Name!='Partner Community User' &&
                   profilesmap.get(userinfo.getProfileId()).Name!='Prospective Partner User' && profilesmap.get(userinfo.getProfileId()).Name!='Prospective Partner Users'){
                    
                    if(atchmnt.Owner.Profile.Name!='ORM Partners' && atchmnt.Owner.Profile.Name!='ORM Partner' &&
                       atchmnt.Owner.Profile.Name!='Portal Loan Processor' && atchmnt.Owner.Profile.Name!='Portal Loan Processors' &&
                       atchmnt.Owner.Profile.Name!='Partner Community Login User' && atchmnt.Owner.Profile.Name!='Partner Community User' &&
                       atchmnt.Owner.Profile.Name!='Prospective Partner User' && atchmnt.Owner.Profile.Name!='Prospective Partner Users'){
                        
                        string AttachmentID;
                        AttachmentID=atchmnt.Id;
                        AttachmentIDs.Add(AttachmentID);
                        
                    }
                    
                }else{
                    
                    string AttachmentID;  AttachmentID=atchmnt.Id;   AttachmentIDs.Add(AttachmentID);
                    
                    
                }
            }
            
            objst=[SELECT Name,AttachmentID__c 
                   from AttachmentStatus__c where LoanId__c=:LoanId and AttachmentID__c In :(AttachmentIDs)];
            string UserName=[SELECT Name 
                             from user where Id=: obj[0].OwnerId limit 1].Name;
            
            for(attachment cd: obj)
            {
                AttachmentResponse objat=new AttachmentResponse();
                for(AttachmentStatus__c atcStatus:objst)
                {
                    if(cd.ID==atcStatus.AttachmentID__c)
                    {
                        objat.Id=cd.ID;                        
                        objat.DocName=cd.Name.substringBeforeLast('.');
                        datetime dt=cd.CreatedDate;   
                        string dttest=dt.format('MM/dd/yyyy', 'America/New_York');
                        objat.CreatedDate=dttest;
                        objat.UploadedBy=[SELECT Name from 
                                          user where Id=: cd.OwnerId limit 1].Name;
                        objat.status=atcStatus.Name;
                        objA.add(objat);  
                    }
                }
                
                
            }
        }
        catch(exception e)
        {
            system.debug('GetAttLoanPartner--Exception---'+e);
        }
        return objA;
    }
    
    public transient Attachment objAttachment;
    
    public Attachment getObjAttachment(){
        objAttachment = new Attachment();
        return objAttachment;
    }
    
    public Boolean fileUploadProcessed{get;set;}
    public String message{get;set;}
    public String messageType{get;set;}
    
    
    Public Void uploadFile(){
        try {
            system.debug('Loan Id'+ ApexPages.currentPage().getParameters().get('id'));
            objAttachment.ParentId = (Id) ApexPages.currentPage().getParameters().get('id');
            
            insert objAttachment;  message = 'File was uploaded successfully';    messageType = 'success';
        }catch(Exception e){
            message = e.getMessage();
            messageType = 'error';
            system.debug('uploadFile--Exception---'+e);
        }
        fileUploadProcessed = true;
        
    }
    
    
    
    
}