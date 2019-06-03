public class PartnerHomeAfterLoginController{
    @AuraEnabled
    public static integer getMessage() {
        integer msg;
        
        String profileID = UserInfo.getProfileId();
        String userProfile = [SELECT Name FROM Profile WHERE Id = : profileID LIMIT 1].Name;
        if(userProfile == Label.Prospective_Partner_User_Label)
        {
            msg= getContactId(Userinfo.getUserId());
        }
        else{
            msg=0;
        }
        
        return msg;
    }
    @AuraEnabled
    public static integer getContactId(String userId) {  
        integer ReturnMsg;
        dateTime SystemDate = System.now();
        date TodayDate=date.newinstance(SystemDate.year(), SystemDate.month(), SystemDate.day());
        List<Contact> ObjConId = new List<Contact>();         
        String contactId_user  = [Select contactId from User where id =: userId].contactId;
        Integer numberDaysDue;
        Id RecortypeId_old = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Individual Leads').getRecordTypeId();
        Id RecortypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Potential Partner Portal User').getRecordTypeId();
        ObjConId  = [Select id from Contact where id = : contactId_user and (RecordTypeId =: RecortypeId or  RecordTypeId =: RecortypeId_old)];
        if(!ObjConId.isempty())
        {
            Datetime FirstLoginDate=[select LoginTime  from LoginHistory where UserId=:userId order by LoginTime asc limit 1 ].LoginTime;
            Date CreatedDate = date.newinstance(FirstLoginDate.year(), FirstLoginDate.month(), FirstLoginDate.day());
            date Expiredate= CreatedDate.addDays(7);
            numberDaysDue = TodayDate.daysBetween(Expiredate);
            
            ReturnMsg = numberDaysDue;
        }
        else{
            ReturnMsg = 0;
        }
        
        return ReturnMsg;
    }
    
    @AuraEnabled
    public static List<HomePageContent__c> getHomeContents( ) {
        List<HomePageContent__c> lenderslink = 
            [SELECT Id, Name, DetailText__c from  HomePageContent__c where IsActive__c = true
             order by LastModifiedDate desc];        
        return lenderslink;
    }    
    @AuraEnabled
    public static List<Lender__c> getLender( ) {
        List<Lender__c> lenders = 
            [SELECT Id, Name, LenderNumber__c from Lender__c 
             order by LastModifiedDate desc];
        return lenders;
    }    
    @AuraEnabled
    public static List<LenderLink__c> getLenderLinks( ) {
        List<LenderLink__c> lenderslink =new  List<LenderLink__c>();
        id UserAccountID=[select AccountID from user where id=: Userinfo.getUserId()].AccountID;
        if(UserAccountID!=null){
            ID QLMSAccountExecutiveID =[select QLMS_Account_Executive__c from Account
                                        where id=:UserAccountID].QLMS_Account_Executive__c;
            if(QLMSAccountExecutiveID!=null){
                lenderslink=getLenderLinksWithAEData();
            }
            else{
                lenderslink = getLenderLinksData();
            }            
        }
        else
        {
            lenderslink = getLenderLinksData();            
        }
        
        return lenderslink;
    }
    public static List<LenderLink__c> getLenderLinksData() {       
        List<LenderLink__c> lenderslink = 
            [SELECT Id, Name, URL__c from  LenderLink__c where IsActive__c = true 
             and Visible_if_QLMS_AE_Assigned_to_Partner__c=false
             order by Link_sequence__c asc];
        return lenderslink;
    }
    public static List<LenderLink__c> getLenderLinksWithAEData() {       
        List<LenderLink__c> lenderslink = 
            [SELECT Id, Name, URL__c from  LenderLink__c where IsActive__c = true   
             order by Link_sequence__c asc];
        return lenderslink;
    }

    @AuraEnabled
    public static String getAEInfo(String phone) {        
      user u =[SELECT contact.Account.ORM_Phone__c FROM user WHERE  id=:userinfo.getUserId()];
      String aePhone;
      String p = u.contact.Account.ORM_Phone__c;
       if(p == null){
           aePhone = '(888) 980-2898';
       }else{
           aePhone = p;
       }      
    return aePhone; 
    }
}