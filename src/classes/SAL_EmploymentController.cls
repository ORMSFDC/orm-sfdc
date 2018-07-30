public class SAL_EmploymentController {
    
    @AuraEnabled
    public static List <Client__c> getclientValue(string LoanId) {
        return GenericController.getAllClientList(LoanId);
    }
    @AuraEnabled
    public static  void  SaveEmployment(Employment__c objEmp,string ClientId,string LoanId) 
    {
        try
        {
            objEmp.Client_id__c =ClientId;
            objEmp.is_Active__c = true;
            objEmp.RelatedLoan__c=LoanId;
        }
        catch(Exception ex)
        {
            system.debug(' SaveEmployment----Exception---'+ex);
        }
        upsert objEmp;
    }
    
    @AuraEnabled
    public static List <Employment__c> getEmployment(string ClientId) {
        List <Employment__c> objEmp =new List <Employment__c>(); 
        try
        {    
            objEmp = [SELECT Id, EmployerName__c, EmployerPhone__c, Zip__c, State__c, City__c, PositionTitle__c, EmployerAddress__c FROM Employment__c where is_Active__c = true and  Client_id__c=: ClientId];
        }
        catch(Exception ex)
        {
            system.debug(' getEmployment----Exception---'+ex);
        }
        return objEmp;
    }
    
    @AuraEnabled
    public static Employment__c  getEmploymentById(string RecordId) {
        Employment__c objEmp = new Employment__c(); 
        try
        {    
            objEmp = [SELECT Id, EmployerName__c, EmployerPhone__c, Zip__c, State__c, City__c, PositionTitle__c, EmployerAddress__c,YearEmployedinProfession__c,Years__c, Months__c FROM Employment__c  
                      where Id=: RecordId];
        }
        catch(Exception ex)
        {
            system.debug(' getEmploymentById----Exception---'+ex);
        }
        return objEmp;
    }
    
    @AuraEnabled
    public static  void DeleteEmployment(String RecordId)
    {
        Employment__c objEmpL = new Employment__c();
        String Emp_Id='';
        try
        {
            objEmpL = [Select Id,Name from Employment__c where Id =: RecordId];
            Emp_Id = objEmpL.Id;
        }
        catch(Exception ex)
        {
            system.debug(' DeleteEmployment----Exception---'+ex);
        }
        if (Emp_Id == RecordId)
        {
            objEmpL.is_Active__c = false;
            update objEmpL;
        }
    }
    
}