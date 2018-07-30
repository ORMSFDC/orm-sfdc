public class search_content{
    @AuraEnabled
    public String FirstName{get;set;}
    
    @AuraEnabled
    public Date DOB{get;set;}
    
    @AuraEnabled
    public String Email{get;set;}
    
    @AuraEnabled
    public String LastName{get;set;}
    
    @AuraEnabled
    public String Address{get;set;}
    
    @AuraEnabled
    public String Phone{get;set;}

    
    
    
    
    
    
    public search_content(){
    
     
    FirstName = '';
       
    Email = '';
    
    
    LastName = '';
    
    
    Address = '';
    
    
    Phone = '';
    DOB = null;
    
    }

}