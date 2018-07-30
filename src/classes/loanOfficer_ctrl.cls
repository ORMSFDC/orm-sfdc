public without sharing  class loanOfficer_ctrl {
    public user u {get;set;}
    public contact con{get;set;}

    public loanOfficer_ctrl (){
     u = [select id,contactid, contact.Account.Name,Contact.Phone,contact.Account.Company_NMLS_ID__c,email from user where id=:userinfo.getuserid() ];
   try{
    con = [select Account.Name ,Account.Company_NMLS_ID__c,Account.Logo__c from contact where id =: u.contactid];
    
    }catch(Exception ex){}
    }
}