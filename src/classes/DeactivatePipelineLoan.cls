/**
* @description DeactivatePipelineLoan Batch Job
* @author Ravi (GalaxE)
* @date 2/24/2018
* @changlog 
* Bala 6/26/2018 - Change Loanstatus from "Waiting for Full package" to "withdrawn" 
                    if the Loan is in "Waiting for Full package" status for 31 days. Portal Notes, Emails and Tasks will be created. 
* QDA/MG 02/07/2018 - Refactor/review by Mike due to Async conflicts
* Bala 5/3/2019 - Added previous modified date instead of last modified, due to daily uploads from RV. added PB to update Previous Modified Date
*/

global class DeactivatePipelineLoan implements Database.Batchable<sObject>{
    
    public static string STR_GENTAL_REMINDER = 'This loan will be withdrawn in 10 days because the application has not yet been returned.';
    public static string STR_FINAL_REMINDER = 'This loan will be withdrawn in 1 day. If you would like to reactivate this loan after tomorrow, please contact your Account Executive.';

    global Database.QueryLocator start(Database.batchableContext BC) {

        Logger.push('start','DeactivatePipelineLoan'); 
        String query = 'SELECT Id, LoanStatus__c, IsActiveFlag__c, LastModifiedDate, Previous_Modified_Date__c,'
        + '(select id, Name, createdDate from loanstatus__r where name = \'Waiting for Full Package\' order by createdDate desc  limit 1)' 
        + 'FROM Loan_New__c where IsActiveFlag__c = true and Extend_Application_Time__c != true ' 
        + ' and LoanStatus__c = \'Waiting for Full Package\' order by LastModifiedDate ';
        Logger.pop();
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Loan_New__c> scope){
       Logger.push('execute','DeactivatePipelineLoan'); 
       
       List<Loan_New__c> loanUpdates =new List<Loan_New__c>();
       List<Note__c> noteInserts=new List<Note__c>();

       for ( Loan_New__c l : scope){
            
            dateTime systemDate = System.now();
            date todayDate = date.newinstance(systemDate.year(), systemDate.month(), systemDate.day()); 
            datetime lDate;
            
            if(l.Previous_Modified_Date__c != null){
                LDate = l.Previous_Modified_Date__c;
            }
            else{
               LDate = todayDate;
            }

            Date mDate = date.newinstance(lDate.year(), lDate.month(), lDate.day());
            Integer numberDaysDue = mDate.daysBetween(todayDate);
                    
            if(numberDaysDue==20){
                Note__c note = createNote(l.Id, 'Gentle Reminder', STR_GENTAL_REMINDER);
                noteInserts.add(note);
            }
            else if(numberDaysDue==30){
                Note__c note = createNote(l.Id, 'Final Reminder', STR_FINAL_REMINDER);
                noteInserts.add(note);
        
            }
            else if(numberDaysDue==31){
                Loan_New__c loan = new Loan_New__c( Id = l.Id, IsActiveFlag__c = false, LoanStatus__c = 'File Closed for Incompleteness');
                loanUpdates.add(loan);                    
            }  
        }
    
        // Update Loan records    
        try { if (loanUpdates.size()>0){ update loanUpdates; } } 
        catch (Exception ex){ Logger.debugException(ex); }    

        // Insert Notes records
        try { if (noteInserts.size()>0){ insert noteInserts; } } 
        catch (Exception ex){ Logger.debugException(ex); }
        
        Logger.pop();
    } 

    global void finish(Database.BatchableContext BC){
        Logger.push('finish','DeactivatePipelineLoan');
        Logger.pop();
    }

    /**
    * @description Return an instance of a note object for insertion
    * @param loanId - Salesforce record Id
    * @parma strTitle - Note title
    * @param strNote - Note body
    * @returns Note__c sObject instance
    */
    public static Note__c createNote(Id loanId, String strTitle, String strNote ){
        
        Note__c n = new Note__c();
        n.Body__c = strNote;
        n.Loan_Id__c = loanId;
        n.Name = strTitle;
        n.Confirm_to_Show_Notes_in_Portal__c = true;
        return n;
    }
    
}
