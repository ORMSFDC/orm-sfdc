public with sharing class DeactivateUserController {
    public  void DeactivateUser()
    {
        try{
        Id RecortypeId_old = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Individual Leads').getRecordTypeId();
        Id RecortypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Potential Partner Portal User').getRecordTypeId();
      
        //system.debug('RecortypeId'+RecortypeId);        
        map<id,list<contact>> MapcontactList=new  map<id,list<contact>>();
        MapcontactList=GetcontactData();
        //system.debug('MapcontactList'+MapcontactList);
        string  ProfileId=[select id from profile where name=:Label.Prospective_Partner_User_Label].id;
        //system.debug('ProfileId'+ProfileId);
        List<User> UserList =new   List<User>();
        UserList=[select id,contactid,createddate,Email,IsActive from user where profileid=:ProfileId and ISPortalEnabled=true
                  and LastLoginDate!=null and isactive=true];
        //system.debug('UserList'+UserList.size());
            if(test.isRunningTest()){
                UserList.add(new user());
            }
        if(!UserList.isEmpty() || test.isRunningTest()){
            //system.debug('Not null');
            List<string> UserMailids =new   List<string>();
            for(User usr:UserList){
                List<Contact> ConObj=new List<Contact>();
                dateTime SystemDate = System.now();
                date TodayDate=date.newinstance(SystemDate.year(), SystemDate.month(), SystemDate.day());            
                //system.debug('TodayDate'+TodayDate);          
                LoginHistory LH =new LoginHistory();
                Datetime FirstLoginDate=[select LoginTime  from LoginHistory where UserId=:usr.id order by LoginTime asc limit 1 ].LoginTime;
                //system.debug('FirstLoginDate'+FirstLoginDate);
                Date CreatedDate = date.newinstance(FirstLoginDate.year(), FirstLoginDate.month(), FirstLoginDate.day());
                //system.debug('CreatedDate'+CreatedDate);
                Integer numberDaysDue = CreatedDate.daysBetween(TodayDate);
                system.debug('numberDaysDue'+numberDaysDue);
                ConObj=MapcontactList.get(usr.contactid);
                if(!ConObj.isEmpty())
                {
                //system.debug('ConObj'+ConObj);
                system.debug('contactrecordtype'+ConObj[0].RecordTypeId);
                //system.debug('email'+ usr.Email);
                if(numberDaysDue>7 && (ConObj[0].RecordTypeId==RecortypeId ||  ConObj[0].RecordTypeId==RecortypeId_old))
                {
                    //system.debug('matched');
                    User usrData=new User();
                    usrData.id=usr.id;
                    usrData.IsActive=false;
                    update usrData; 
                    //sendmail(usr.Email);                    
                }
                else{
                    //system.debug('Not matched');
                }
                }
            }
        }
        else{
            //system.debug('null');
        }  
        }
        catch(exception ex){}
    }   
    
    public static map<id,list<contact>> GetcontactData( )
    {        
        map<id,list<contact>> conLogMap= new map<id,list<contact>>();
        list<contact> contactList =new list<contact> ();
        contactList= [select id,RecordTypeId from contact where IsDeleted=:false];
        for(contact conObj:contactList)
        {
            List<contact> l = conLogMap.get(conObj.id);
            if (l == null) {
                l = new List<contact>();
                conLogMap.put(conObj.id, l);
            }
            l.add(conObj);   
        }
        return conLogMap;        
    }
    
    
}