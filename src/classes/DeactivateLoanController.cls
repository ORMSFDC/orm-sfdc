global class DeactivateLoanController implements Database.Batchable<sObject>  {
    
     // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String query = 'SELECT Id, LoanStatus__c, IsActiveFlag__c, CreatedDate FROM Loan_New__c where IsActiveFlag__c=true and LoanStatus__c=\'Incomplete\' order by CreatedDate';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Loan_New__c> scope)
    {
    try{
        List<Loan_New__c> lstLoan=new List<Loan_New__c>();
        for ( Loan_New__c L : scope)
        {
              dateTime SystemDate = System.now();
                date TodayDate=date.newinstance(SystemDate.year(), SystemDate.month(), SystemDate.day()); 
            datetime LCreatedDate=L.CreatedDate;
             Date CreatedDate = date.newinstance(LCreatedDate.year(), LCreatedDate.month(), LCreatedDate.day());
             Integer numberDaysDue = CreatedDate.daysBetween(TodayDate);
              system.debug('numberDaysDue'+numberDaysDue);
            if(numberDaysDue>30)
            {
                L.IsActiveFlag__c=false;
                //L.Id=L.Id;
                lstLoan.add(L);
                 //recordsProcessed = recordsProcessed + 1;
            }
          
        }
        update lstLoan;
      }catch(Exception ex){
           Exception_log.Log_exception(ex,'DeactivateLoanController','execute');
      }  
    } 

    global void finish(Database.BatchableContext BC)

    {
			System.debug(recordsProcessed + ' records processed.');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
    }



}