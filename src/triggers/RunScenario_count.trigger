trigger RunScenario_count on RunScenario__c (after insert,after update) {
    
   if(![select id,Entity__r.DeveloperName ,Skip_Trigger_Execution__c from Trigger_Handler__mdt where Entity__r.DeveloperName ='RunScenario'].Skip_Trigger_Execution__c )
  { 

    if((trigger.isInsert && trigger.isAfter) || (trigger.isUpdate && trigger.isAfter)){
           user usr  = [ select contactId,Contact.Accountid,Id from user where id=:userinfo.getUserId() limit 1];
               Integer CountIs = 0;
        if(trigger.isUpdate){
            
            System.debug('update >>>>> '+(integer)trigger.new[0].Scenarios_Run__c );
        }
         CountIs = (integer)trigger.new[0].Scenarios_Run__c;
          if(CountIs !=0 && null != usr.contactId || test.isRunningTest()){
               decimal count_Is = 0 ;
            
              try{
                Account acc = [select id,   ORMS_Number_of_Scenarios_Run__c from account where id=:usr.Contact.AccountId]; // 20
               map<id,Contact > con = new map<id,Contact>([select id from contact where AccountId =: acc.id]); // 
               
               for(RunScenario__c  each :[select id ,Scenarios_Run__c from RunScenario__c   where Createdby.ContactId in :con.keyset()]){    count_Is+=each.Scenarios_Run__c;
               
               }
               acc.ORMS_Number_of_Scenarios_Run__c = count_Is;  update acc;  }catch(EXception ex){}
            }
    }
  }
}