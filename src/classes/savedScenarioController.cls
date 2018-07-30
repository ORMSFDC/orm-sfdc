/**
 * @description: used to fetch run scenario values and generate saved scenario results along with PieGraph 
 * @author: Ravi
 * @date: 9/13/2017
 *
 * changelog:
 * 07/19/2018: Sahitya - added new fields for Helo PieGraph(Other_Estimated_Closing_Costs__c,Origination_to_orm__c)
 */
public class savedScenarioController {
    
     public class AccWrap{
        @AuraEnabled
        public list<scenario__c> Acc{get;set;}
        @AuraEnabled
        public integer Count{get;set;}
        
        public AccWrap(list<scenario__c> Acc,integer Count){
            this.Acc = Acc;
            this.Count = Count;
        }
   
    }
 @AuraEnabled
    public static List < Lead > fetchAccount(String searchKeyWord) {
       return  lookUpController.fetchAccount(searchKeyWord);
      }
    
           @AuraEnabled
    public static AccWrap getScenarioList(String ClientID,String sort_Column,String sortorder ) {
         List < scenario__c > Scenariolist=new List < scenario__c >();
        try{
       
        Scenariolist=[select Id,is_Converted__c,Margin__c,Date_of_birth__c,Client_Lead__r.Street,Client_Lead__r.Phone,Client_Lead__r.FirstName,
                      Client_Lead__r.LastName,Monthly_Mortgage_Payment__c,Current_Mortgage_Balance__c,Current_Mortgage_Interest_Rate__c,
                      Estimated_home_value__c,CreatedDate,RateType__c,Other_Estimated_Closing_Costs__c,Origination_to_orm__c
                      from scenario__c  order by CreatedDate desc limit 10];            
        }
        catch(exception ex ){
            system.debug('--------------------getScenarioList------------------'+ex);
            Exception_log.Log_exception(ex,'savedScenarioController','getScenarioList');
        }
        //system.debug(Scenariolist);
       return  new AccWrap(Scenariolist,[select count() from scenario__c]);
      }
    
      @AuraEnabled
    public static AccWrap getScenario_nextPage(Integer pageNumber,String sort_Column,String sortorder){
        System.debug('pageNumber ===> '+pageNumber);
        integer pageNum = integer.valueOf(pageNumber);
        String  Query = 'select Id,is_Converted__c,Margin__c,Client_Lead__r.Email,Client_Lead__r.Phone,Client_Lead__r.Street,Date_of_birth__c,Client_Lead__r.FirstName,Client_Lead__r.LastName,Monthly_Mortgage_Payment__c,Current_Mortgage_Balance__c,Current_Mortgage_Interest_Rate__c,Estimated_home_value__c,Other_Estimated_Closing_Costs__c,Origination_to_orm__c,CreatedDate from scenario__c   ';
        Query+= ' order by '+sort_Column+' '+sortorder +' nulls last limit 10 offset '+pageNum;
   //     return [select id,Name from Account   limit 10 offset:pageNumber];
   //     //[select Id,is_Converted__c,Margin__c,Date_of_birth__c,Client_Lead__r.Street,Client_Lead__r.Phone,Client_Lead__r.FirstName,Client_Lead__r.LastName,Monthly_Mortgage_Payment__c,Current_Mortgage_Balance__c,Current_Mortgage_Interest_Rate__c,Estimated_home_value__c,CreatedDate
                //      from scenario__c  order by CreatedDate desc limit 10 offset:pageNum]
           return new AccWrap(database.query(Query),[select count() from scenario__c ]);

    }
      @AuraEnabled
    public static scenario__c  getScenarioData(String ScenarioID) {
      //prsn  
      scenario__c  Scenariodata=new scenario__c();
      system.debug('ScenarioID from getScenarioData --> '+ ScenarioID);
        try{
        Scenariodata=[select Id,RateType__c,is_Converted__c,Principal_Limit__c,
                      MIP__c,
                      Monthly_Mortgage_Payment__c,Current_Mortgage_Balance__c,Current_Mortgage_Interest_Rate__c,Estimated_home_value__c,Date_of_birth__c,
                      CreatedDate,piechartresponse__c,barchartresponse__c,Line_of_Credit__c,Index__c,Margin__c,Scenario_Type__c,CashFlow1__c,CashFlow10__c,
                      CashFlow5__c,Cash_at_close__c,Cash_to_close__c,EOF__c,Other_Estimated_Closing_Costs__c,Origination_to_orm__c
                      from scenario__c where id=:ScenarioID];
         }
        catch(exception ex ){
            system.debug('--------------------getScenarioData------------------'+ex);
            Exception_log.Log_exception(ex,'savedScenarioController','getScenarioData');
        }
       return  Scenariodata;
      }
     @AuraEnabled
    public static AccWrap getsearchScenarioList(String searchdata,String ClientID,integer pageNum,String sort_Column,String sortorder) {
         List < scenario__c > Scenariolist=new List < scenario__c >();
        System.debug('searchdata '+searchdata);
        search_content sdata= new search_content();
         sdata = (search_content)System.JSON.deserialize(searchdata, search_content.class);
        String Query = '';
        String baseQuery = '';
        try{
       //Query = 'select Id,ClientId__r.Email_Optional__c,ClientId__r.Phone_Number__c,ClientId__r.Street_Address__c,Date_of_birth__c,ClientId__r.Name,ClientId__r.Last_Name__c,Monthly_Mortgage_Payment__c,Current_Mortgage_Balance__c,Current_Mortgage_Interest_Rate__c,Estimated_home_value__c,CreatedDate from scenario__c  where ClientId__c=:ClientID and ';
       Query = 'select Id,is_Converted__c,Margin__c,Client_Lead__r.Email,Client_Lead__r.Phone,Client_Lead__r.Street,Date_of_birth__c,Client_Lead__r.FirstName,Client_Lead__r.LastName,Monthly_Mortgage_Payment__c,Current_Mortgage_Balance__c,Current_Mortgage_Interest_Rate__c,Estimated_home_value__c,Other_Estimated_Closing_Costs__c,Origination_to_orm__c,CreatedDate from scenario__c   ';
       
            if(sdata.FirstName!='' || sdata.LastName!='' || sdata.DOB!=null|| sdata.Email!='' || sdata.Phone!='' || sdata.Address!=''){
            Query+= ' where ';
            if(sdata.FirstName!=''){
                Query+= ' Client_Lead__r.FirstName = '+ '\''+sdata.FirstName+'\' and ';   
          }
            if(sdata.LastName!=''){
                Query+= ' Client_Lead__r.LastName = '+ '\''+sdata.LastName+'\' and ';   
          }
             if(sdata.Address!=''){     Query+= ' Client_Lead__r.Street = '+ '\''+sdata.Address+'\' and ';   
          }
              if(sdata.Phone!=''){
                Query+= '  Client_Lead__r.Phone = '+ '\''+sdata.Phone+'\' and ';   
          }
            
            if(sdata.DOB!=null){
                string dt = ''+sdata.DOB;
                
                Query+= '  Date_of_birth__c = '+dt.replace(' 00:00:00','')+' and ';   
          }
            
            if(sdata.Email !=''){
                
                Query+= ' Client_Lead__r.Email= '+ '\''+sdata.Email+'\' and ';
            }
            
            
            
        }
            Query = Query.removeEnd(' and ');
            baseQuery = Query;
            Query += ' order by '+sort_Column+' '+sortorder+' NULLS LAST limit 10 offset '+pageNum;
                        
                        //Query.removeEnd(' and ');

        }
        catch(exception ex ){
            system.debug('--------------------getScenarioList------------------'+ex);
            Exception_log.Log_exception(ex,'savedScenarioController','getsearchScenarioList');
        }
        system.debug('Query > '+Query);
         List < scenario__c > sce = database.query(Query);
       return  new AccWrap(sce,database.query(baseQuery).size());
      }
    
    
            @AuraEnabled
    public static search_content get_searchInstance(){
        
        return new search_content();
    }
    
    @AuraEnabled
    public static void SendMailTMP(id ScenarioID)
    {
        lookUpController.SendMailTMP(ScenarioID);
    }
    
    @AuraEnabled
    public static void Senariodelete(List<id> sel_sn){
    
        system.debug('parameter id value '+ sel_sn);
        scenario__c sn = [select id from scenario__c where id=:sel_sn limit 1];
        delete sn;
    }
}