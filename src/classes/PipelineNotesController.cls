public class PipelineNotesController {
    
    @AuraEnabled
    public static void insNotes(String note, String title, String Loan_Id) {
        try{
            map<id,profile>ProfileIdandName  = new map<id,profile>();
            ProfileIdandName = new map<id,Profile>([select id,Name from Profile]);
            Loan_New__c L = [Select Id, Name from  Loan_New__c where Id =: Loan_Id];
            Note__c N = new Note__c();
            N.Loan_Id__c = L.Id;
           n.Confirm_to_Show_Notes_in_Portal__c=true;
            N.Name=title;
           N.Body__C = note;
            N.User_Name__c = Userinfo.getName();
            N.User_Profile__c  =ProfileIdandName.get(Userinfo.getProfileId()).Name;
            insert N;
        }
        catch(exception e)
        {
            system.debug('insNotes--Exception---'+e);
        }
        
    }
    
    @AuraEnabled
    public static List<PipelineNotesResponse> fetchNotes(String Loan_Id) {
        
        System.debug('>>>>>> fetching the notes ');
        List<Note__c> fetchNotesList=new List<Note__c>() ; 
         List<PipelineNotesResponse> objRes=new List<PipelineNotesResponse> ();
            Loan_New__c L=new Loan_New__c();
         List<String>OwnerIdList=new List<string>();
        List<User>ObjUser=new List<User>();
        List<String>ProfileIdList=new List<string>();
        List<profile>ObjProfile=new List<profile>();
        try{
             L = [Select Id, Name from  Loan_New__c where Id = :Loan_Id];
             
            fetchNotesList = [Select Id,User_Name__c,User_Profile__c, Name,LastModifiedDate,ownerid,Body__c from Note__c where Loan_Id__c =: L.Id and  Confirm_to_Show_Notes_in_Portal__c=true order by LastModifiedDate desc ];
        System.debug('<><><><>< '+fetchNotesList.size());   
        for(Note__c atchmnt: fetchNotesList)
            {
                string Ownrid=atchmnt.ownerid;
                OwnerIdList.add(Ownrid);
            }
            ObjUser=[SELECT Name,ProfileId from user where id IN:(OwnerIdList) ];
        System.debug('ObjUser ObjUser '+ObjUser.size());
              for(User atchmnt: ObjUser)
            {
                string profileid=atchmnt.ProfileId;
                ProfileIdList.add(profileid);
            }
            ObjProfile=[SELECT Name from profile where id IN:(ProfileIdList) ];
            for(Note__c lc:fetchNotesList)            
            {
                
                                 system.debug(lc.ownerid);
                  PipelineNotesResponse obj1=new PipelineNotesResponse();
                obj1.Id=lc.Id;
                 obj1.Title=lc.Name;
                 obj1.Body=lc.Body__c;
                 datetime dt=lc.LastModifiedDate;   
                string dtformat=dt.format('MM/dd/yyyy HH:mm a', 'America/New_York');
                 obj1.LastModifiedDate=dtformat;
              // user objuser=[SELECT Name,ProfileId from user where id=:lc.ownerid LIMIT 1];
               //profile objpro=[SELECT Name from profile where id=:objuser.ProfileId LIMIT 1];
                 obj1.owner=lc.User_Name__c;
                obj1.ownerType=lc.User_Profile__c;
               //system.debug(objuser);
                objRes.add(obj1);
                
                /*system.debug(lc.ownerid);
                  PipelineNotesResponse obj1=new PipelineNotesResponse();
                obj1.Id=lc.Id;
                 obj1.Title=lc.Name;
                 obj1.Body=lc.Body__c;
                 datetime dt=lc.LastModifiedDate;   
                string dtformat=dt.format('MM/dd/yyyy HH:mm a', 'America/New_York');
                 obj1.LastModifiedDate=dtformat;
              // user objuser=[SELECT Name,ProfileId from user where id=:lc.ownerid LIMIT 1];
              // profile objpro=[SELECT Name from profile where id=:objuser.ProfileId LIMIT 1];
                obj1.owner=lc.User_Name__c;
                obj1.ownerType=lc.User_Profile__c;
               //system.debug(objuser);
                objRes.add(obj1);*/
            }
       }
        catch(exception e)
        {
            system.debug('fetchNotes--Exception---'+e);
        }
        return objRes;            
    }
}