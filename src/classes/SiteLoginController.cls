/**
* An apex page controller that exposes the site login functionality
*/
global with sharing class SiteLoginController {
    global String username {get; set;}
    global String password {get; set;}
    public  PartnerWithUsResponce objLead{get;set;}
    
    /* public Lead objLead { get;
set;} */
    global PageReference login() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        system.debug('url==='+startUrl);
        if(startUrl==null)
            startUrl='/s/?t=1504718991125';
        return Site.login(username, password, startUrl);
    }
    
    // dvdsvds 
    global SiteLoginController () {
        objLead=new PartnerWithUsResponce();
    }
    
    public void submit() {
        try {
            // Try to save a duplicate Lead
            Id RecortypeId_Lead = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Partner Lead').getRecordTypeId();
            Lead obj=new Lead();
            obj.FirstName=objLead.FirstName;
            obj.LastName=objLead.LastName;
            obj.Company=objLead.Company;
            obj.Phone=objLead.Phone;
            obj.Email=objLead.Email;
            obj.BillingState__c=objLead.BillingState;
            obj.Company_NMLS_ID__c=String.valueOf(objLead.Company_NMLS_ID);
            
            obj.Other_Source__c=objLead.Other_Source;
            obj.ORM_Account_Executive__c=objLead.ORM_Account_Executive;
            obj.LeadSource=objLead.LeadSource;
            obj.IsLeadCreatedFromPortal__c=true;
            obj.RecordTypeId=RecortypeId_Lead;
            // obj.LastName=objLead.lname;
            Database.SaveResult sr = Database.insert(obj, false); 
            if (!sr.isSuccess()) {
                // Insertion failed due to duplicate detected
                for(Database.Error duplicateError : sr.getErrors()){
                    Datacloud.DuplicateResult duplicateResult = 
                        ((Database.DuplicateError)duplicateError).getDuplicateResult();
                }
                id LeadID=[select ID from Lead where email=:obj.Email limit 1].Id;
                // If the duplicate rule is an alert rule, we can try to bypass it
                Database.DMLOptions dml = new Database.DMLOptions(); 
                dml.DuplicateRuleHeader.AllowSave = true;
                obj.Id=LeadID;
                Database.SaveResult sr2 = Database.update(obj, dml);
                /*if (sr2.isSuccess()) {
createTask(obj.Id);
}*/
            }
            createTask(obj.Id);
            SendEmail(Label.PartnerwithusEmail_JoshEvink,Label.PartnerwithusName_JoshEvink,obj.Id);
        } 
        catch(Exception e)
        {
            System.debug('-----Exception -----' + e);
            //Exception_log.Create_Custom_Logs(e.getMessage(),'site login','save Lead','by jyoti if part');
            
        }      
    }
    
    public static void createTask(string LeadID){
        try
        {
            Task t = new Task();            
            t.Subject = 'A new Partner with Us Form has been submitted.';
            t.ActivityDate = System.Today();
            t.WhoId = LeadID;
            t.Description  = 'Lead has been created';
            t.Priority = 'Normal';
            t.Status = 'Open';
            insert t;
            string TaskId=t.Id;
        }
        catch(Exception ex)
        {
            system.debug(' getDeclr----Exception---'+ex);
        }
    }       
    
    
    public static void SendEmail(string Email,string Name ,ID LeadID) {
        try
        {
            String AEName=Name;
            Lead Acct=[select lastmodifieddate,Name from Lead where id=:LeadID];
            system.debug('Acct'+Acct);
            Datetime myDT=Acct.LastModifiedDate;
            String myTime = myDT.format('h:mm a');
            String myDate = myDT.format('MM/dd/yyyy');            
            string Link= '<a href='+Label.CIC_Email_Url+LeadID+'>Link to Lead</a>';           
            EmailTemplate template = [SELECT Id, Name, Subject, HtmlValue, Body, Markup FROM EmailTemplate where 
                                      Name='PartnerWithUsEmail' ];
            system.debug('template'+template);
            List<Messaging.SingleEmailMessage> mails = 
                new List<Messaging.SingleEmailMessage>();
            // Step 1: Create a new Email
            Messaging.SingleEmailMessage mail = 
                new Messaging.SingleEmailMessage();
            List<String> sendTo = new List<String>();            
            sendTo.add(Email);
            mail.setToAddresses(sendTo);
            mail.setReplyTo(UserInfo.getUserEmail());          
            mail.setSubject('A new Partner with Us Form has been submitted.');
            String body =  template.HtmlValue ;    
            body = body.replace('#Date',myDate).replace('#Time',myTime).replace('#AEName',AEName).replace('#Link',Link);        
            mail.setHtmlBody(body);
            mails.add(mail);Messaging.sendEmail(mails);
            
        }
        catch(Exception ex)
        {
            system.debug(' getDeclr----Exception---'+ex);
        }
    }
    
    
    public static List<SelectOption> getPicklistValues(){ 
        string ObjectApi_name='Lead';
        string Field_name='LeadSource';
        List<SelectOption> options=new List<SelectOption>();
        
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        // 
        
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
            options.add(new SelectOption(a.getLabel(), a.getValue())); //add the value  to our final list
        }
        options.sort();
        List<SelectOption> Newoptions=new List<SelectOption>();
        Newoptions.add(new SelectOption('Choose One','Choose One'));
        for (SelectOption a : options) { //for all values in the picklist list
            Newoptions.add(new SelectOption(a.getLabel(), a.getValue())); //add the value  to our final list
        }
        
        return Newoptions;
    }
    public static List<SelectOption> getState(){ 
        List<SelectOption> options=new List<SelectOption>();
        List<String> obj=new List<String>();
        List<PartnerStates__mdt> stateList = [SELECT MasterLabel FROM PartnerStates__mdt ORDER BY MasterLabel ASC];
        stateList.sort();
        options.add(new SelectOption('Choose One','Choose One'));
        for (PartnerStates__mdt a : stateList) { //for all values in the picklist list
            options.add(new SelectOption(a.MasterLabel , a.MasterLabel )); //add the value  to our final list
        }
        return options;
    }
    
    public static List<SelectOption> getORMAccountExecutive(){
        List<SelectOption> options=new List<SelectOption>();
        List<User> UserList=new List<User>();
        List<UserRole> UserRoleList=new List<UserRole>();
        try
        {
            Profile pfle=new Profile();
            pfle=[SELECT Id,Name FROM Profile WHERE Name = 'Account Executive/PCS'];
            UserRoleList=[SELECT Id,Name FROM UserRole WHERE Name IN( 'Account Executive','Account Executive Lead')];
            set<Id> userroleid = new set<Id>();
            for(userrole r:UserRoleList)
            {
                userroleid.add(r.Id);
            }
            
            UserList = [SELECT Id,Name,Email FROM User WHERE ProfileId = :pfle.Id And (UserRoleId IN :userroleid) ORDER BY ProfileId ASC];
            UserList.sort();
            
            //Code Added/Changed by Dev4 for ORMSFDC-1432
            // UserList = [SELECT Id,Name FROM User WHERE ProfileId = :pfle.Id ORDER BY ProfileId ASC];
            options.add(new SelectOption('','Choose One'));
            for (User a : UserList) { //for all values in the picklist list
                options.add(new SelectOption( a.Name, a.Name)); //add the value  to our final list
            }
        }
        catch(Exception ex)
        {
            system.debug(' getDeclr----Exception---'+ex);
        }
        
        return options;
        
    }
    
    global with sharing class PartnerWithUsResponce {
        @auraenabled public string FirstName {get; set;}
        @auraenabled  public string LastName {get; set;}
        @auraenabled public string Company {get; set;}
        @auraenabled public string Phone{get;set;}
        @auraenabled  public string Email{get;set;}
        @auraenabled  public string BillingState{get;set;}
        @auraenabled  public integer Company_NMLS_ID{get;set;}
        @auraenabled  public string Other_Source{get;set;}
        @auraenabled public string ORM_Account_Executive{get;set;}
        @auraenabled  public string LeadSource{get;set;}
        
    }
}