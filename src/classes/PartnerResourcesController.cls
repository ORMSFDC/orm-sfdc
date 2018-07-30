global with sharing class PartnerResourcesController {
	
    //Start Class
    //Reversity Tab
    //YoutubeVideoListController
	@AuraEnabled
    public static List<YoutubeLinks__c> getYoutubeLinks( ) {
        List<YoutubeLinks__c> Links = 
        [SELECT Id, Name, Thumbnails_Image__c,YouTubeHeader__c,YoutubeURL__c from YoutubeLinks__c where IsActive__c=true
            	order by Video_sequence__c asc]; 
      
        return Links;
    }
    
    @AuraEnabled
    public static string getYoutubeLinkDetailById(id recid) {
            
	 string  linkDetail  =  [SELECT YoutubeURL__c from YoutubeLinks__c 
                                       where Id=:recid ].YoutubeURL__c;
        
        //system.debug(linkdetail);
        return linkDetail;
         
    }
    //ReversityContentController
     @AuraEnabled
    public static List<ReverseVideoContents__c> getReversityContents( ) {
        List<ReverseVideoContents__c> lenderslink = 
                [SELECT Id, Name, Details__c from  ReverseVideoContents__c	 where IsActive__c = true
            	order by LastModifiedDate desc];

      
        return lenderslink;
    }
    //Our Process Tab
    //ProcessVideosListController
   @AuraEnabled
    public static List<Process_Videos__c> getProcessVideoLinks( ) {
        List<Process_Videos__c> Links = 
        [SELECT Id, Name, ProcessVideoImage__c,ProcessVideoHeader__c,ProcessVideoURL__c from Process_Videos__c where IsActive__c=true
            	order by LastModifiedDate desc];
      
        return Links;
    }
  
    @AuraEnabled
    public static string getProcessVideoLinksById(id recid) {
            
	 string  linkDetail  =  [SELECT ProcessVideoURL__c from Process_Videos__c 
                                       where Id=:recid ].ProcessVideoURL__c;
        
        return linkDetail;
         
    }
    //ProcessContentController
    @AuraEnabled
    public static List<ProcessContents__c> getProcessContents( ) {
        List<ProcessContents__c> lenderslink = 
                [SELECT Id, Name, Details__c from  ProcessContents__c	 where IsActive__c = true
            	order by LastModifiedDate desc];

      
        return lenderslink;
    }
    //Forms Tab
    //ResourceFormsController
    @AuraEnabled
    public static List<ResourceForms__c> getResourceForms( ) {
        List<ResourceForms__c> lenderslink = 
                [SELECT Id, Name, DetailText__c from  ResourceForms__c where IsActive__c = true
            	order by Resource_Form_Sequence__c asc];

      
        return lenderslink;
    }
    //FAQ Tab
    //FAQController
    @AuraEnabled
    public Static List<FAQ__c> getFAQContents( ) {
        List<FAQ__c> FAQs = 
                [SELECT Id, Name, FAQ_Detail__c from  FAQ__c where IsActive__c = true
                order by FAQ_Sequence__c asc];
            return FAQs;
    }
    //ContactUs Tab
    //ContactUSController
    @AuraEnabled
    public static List<Contact_Us__c> getContacts( ) {
        List<Contact_Us__c> Contacts = 
                [SELECT Id, Name, Contact_Detail__c from  Contact_Us__c where Is_Active__c = true
            	order by Contact_Us_Sequence__c asc];

      
        return Contacts;

    }
    
    /*@AuraEnabled
    public static List<Contact_Us_Right__c> getContactsRight( ) {
        List<Contact_Us_Right__c> ContactsR = 
                [SELECT Id, Name, Contact_Detail__c from  Contact_Us_Right__c where IsActive__c = true
            	order by Contact_Us_Sequence__c asc];

      
        return ContactsR;

    }*/
    //End Class

}