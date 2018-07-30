public with sharing class PortalUserActiveStatusController {
    
    // an instance variable for the standard controller
    private ApexPages.StandardController controller {get; set;}
    
    public String selectedSId {get; set;}
    // the variable being set 
    public boolean IsActive{get; set;}
    
    // initialize the controller
    public PortalUserActiveStatusController (ApexPages.StandardController controller) {
        
        selectedSId = ApexPages.currentPage().getParameters().get('id'); 
        IsActive=getUserActiveStatus(selectedSId);   
        
    }
    public static boolean getUserActiveStatus(string ContactID){
        boolean IsActive=false;
        List<user> Usr=new List<user>();
        Usr=[select IsActive,isportalenabled from user where contactId=:ContactID order by createddate desc limit 1];
        if(!Usr.isEmpty())
        {
            if(Usr[0].isportalenabled==true)
            {
            IsActive=Usr[0].IsActive;
            }
            else{IsActive=false;}
        }
        system.debug(IsActive);
        return IsActive;
        
    }
    
    
}