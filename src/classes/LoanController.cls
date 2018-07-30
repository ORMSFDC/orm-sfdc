/** * File Name   : LoanController.cls
*     Description : 
*     Created     : 7/28/2017
*     Modified    : Prsn
*   * @author     : 
* */
public class LoanController {
    @AuraEnabled
    public static List<Loan_New__c> getName() {
        List<Loan_New__c> ListLoan = new List<Loan_New__c>();
        try{
            String User = UserInfo.getUserId();
            
            ListLoan =  [SELECT Name, LastModifiedDate, Client_Name__c FROM Loan_New__c where IsActiveFlag__c = true and LoanCompleteFlag__c= false
                         /*and OwnerId = :User and /-- prasen*/ order by lastmodifieddate desc];   
        }
        catch(exception e)
        {
            system.debug('getName--Exception---'+e);
        }
        return ListLoan;
    }
    
    @AuraEnabled
    public static  Integer getCount() {
        Integer GetIntCount;
        try{
            String User = UserInfo.getUserId();        
            GetIntCount =  [SELECT count() from Loan_New__c where LoanCompleteFlag__c= false and ISActiveFlag__c = true /*and OwnerId = :User*/];
        }
        catch(exception e)
        {
            system.debug('getCount--Exception---'+e);
        }
        return GetIntCount;
    }
    
    @AuraEnabled
    public static void deleteData(String id) {
        try{
            Loan_New__c L = [Select Id,Name from Loan_New__c where Id = :id];
            String Loan_Id = L.Id;
            
            if (Loan_Id == id)
            {
                L.IsActiveFlag__c = false;
                update L;
            }
            
        }
        catch(exception e)
        {
            system.debug('deleteData--Exception---'+e);
        }
    }
    
}