/* 
Author *** prsn***
*/
public without sharing class PdfSavedScenarioController {
    
    public String scenarioID {get;set;}
    public user u {get;set;}
    public contact con{get;set;}
    public Scenario__c scenario {get;set;}
    public Integer age{get;set;}
    public Decimal finalEOF{get;set;}
    public Decimal cashAtClose{get;set;}
    public Decimal fundsNeedToClose{get;set;}
    public Decimal equityReserves{get;set;}
    public Decimal financingFees{get;set;}
    public Decimal firstAmount{get;set;}
    public boolean isTraditional {get;set;}
    public string RateTypeis {get;set;}
    
    public boolean isOld{get;set;}
    
    public PdfSavedScenarioController() {
    RateTypeis  = 'Margin';
        isTraditional  = true;
        isOld = false;
        scenarioID =ApexPages.currentPage().getParameters().get('id');
        
        u = [select id,contactid, contact.Account.Name,Contact.Phone,contact.Account.Company_NMLS_ID__c,email from user where id=:UserInfo.getUserId()];
        
        List<Contact> contactList = [select Account.Name, Account.Company_NMLS_ID__c, Account.Logo__c, Account.Main_Phone__c from contact where id =: u.contactid];
        if(contactList.size() > 0 && contactList != Null) {
            con = contactList[0];
        }
        List<Scenario__c> scenarioList = [Select Id,Estimated_home_value__c,
                                          MIP__c,
                                          PieChartResponse__c,
                                          Initial_Growth_Rate__c,
                                          Date_of_birth__c,
                                          BarChartResponse__c, 
                                          Current_Mortgage_Balance__c,
                                          Home_Value_10_years__c,
                                          Monthly_Mortgage_Payment__c,
                                          Margin__c,
                                          Principal_Limit__c,
                                          Index__c,
                                          Line_of_Credit__c,
                                          Cash_Flow_Remaining_months_Amount__c,
                                          Cash_Flow_12_months_Amount__c,
                                          Cash_Flow_60_months_Amount__c,
                                          Cash_at_close__c,CashFlow1__c,CashFlow10__c,
                                          CashFlow5__c,Scenario_Type__c,RateType__c
                                          ,EOF__c
                                          From Scenario__c Where Id =: scenarioID];
        
        if(scenarioList != Null && scenarioList.size()>0) {
   //         try{
            scenario = scenarioList[0];
            
            if(scenario.Estimated_home_value__c<=200000) {
             finalEOF = scenario.Estimated_home_value__c *0.02;
              }
            else { 
            finalEOF = (200000 *0.02) + ((scenario.Estimated_home_value__c-200000)*0.01);
             }  
             
            
            if(finalEOF<2500)       { 
            finalEOF = 2500;
             }
            else if (finalEOF>6000) {     finalEOF = 6000; 
            
            }
            
            if(null != scenario.EOF__c ){    finalEOF =    scenario.EOF__c;
            }
            
            if(scenario.Date_of_birth__c != Null)  
            age                           = System.today().year() - scenario.Date_of_birth__c.year(); 
            if(null != scenario.PieChartResponse__c){
            isOld = true;
            Map<String,Object> jsonMap    = (Map<String,Object>)JSON.deserializeUntyped(scenario.PieChartResponse__c);
            
            cashAtClose                   = (Decimal)jsonMap.get('maxCash');
            fundsNeedToClose              = (Decimal)jsonMap.get('cashToClose');
            }else{
            cashAtClose                   = Decimal.valueOf(scenario.Cash_at_close__c);  fundsNeedToClose              = Decimal.valueOf(scenario.Cash_at_close__c);
               //hecm
                if(scenario.Scenario_Type__c=='FHA Traditional HECM'){  isTraditional  = true;
                }else{
                    isTraditional  = false;
                }
                
                if(scenario.RateType__c == 'Adjust'){    RateTypeis ='Margin';
                }else{
                    RateTypeis = 'Rate';
                }
            }
            equityReserves                = scenario.Estimated_home_value__c;
            financingFees                 =  finalEOF+2500;
           if(null != scenario.PieChartResponse__c) {
            firstAmount                   = ((scenario.Principal_Limit__c-scenario.Current_Mortgage_Balance__c-scenario.MIP__c-financingFees).setScale(2, RoundingMode.HALF_UP));
            }else{
            firstAmount                   =decimal.valueOf(scenario.Cash_at_close__c);
            }
            if((equityReserves -(scenario.MIP__c + scenario.Line_of_Credit__c + financingFees + cashAtClose+scenario.Current_Mortgage_Balance__c )) < 0 ) { equityReserves = 0.00; } 
            else { equityReserves = (equityReserves -(scenario.MIP__c + scenario.Line_of_Credit__c + financingFees + cashAtClose+scenario.Current_Mortgage_Balance__c )); } 
            
     //       }catch(exception ex) {
       //         System.debug('Exception'+ex);
         //   } 
        }
    }
    
}