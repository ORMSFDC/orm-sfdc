@isTest
public class SAL_ApexManagedSharingControllerTest {
    @isTest static void UpdateOwnerAfterLoanSubmitTest()
    {
         Id sAdmin=[select Id from Profile where Name=:'System Administrator' limit 1].Id;
        User Uid =[select Id from User where ProfileId !=:sAdmin and IsActive=true limit 1];
        
        Loan_New__c loan = new Loan_New__c(IsActiveFlag__c= true, IsLoanFilled_Flag__c=true,LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                               LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017'),
                                          IsLoanCreatedByLoanProcessor__c=true,IsLoanDetailsFilled_Flag__c=true);
            insert loan;
        Loan_New__c loanUpdated = new Loan_New__c(Id=loan.Id,IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                               LoanNumber__c = '56789',Appraisal_Received_Date__c=Date.parse('10/11/2017'),
                                                 LoanOfficer__c=Uid.id);
        loan.LoanNumber__c = '56789';
        update loanUpdated;
        Asset ObjAsset = new asset(Name = 'Drush', RelatedLoan__c = loan.Id,Category__c = 'Others', isActive__c = true, Name_of_Institution__c = 'DS');
            Insert ObjAsset;  
            string AssetId = ObjAsset.Id;
        	string loanId = loan.Id;
        SAL_ApexManagedSharingController.ShareLoanRecord(loan,loanUpdated);
        SAL_ApexManagedSharingController.DeleteSharedRecord(loan.Id,'Manual');
        SAL_ApexManagedSharingController.UpdateOwnerAfterLoanSubmit(loan.Id, loan, loanUpdated);
        List<String> getId = SAL_ApexManagedSharingController.GetIds(loanId, 'Loan_New__c');
        SAL_ApexManagedSharingController.ShareRecordAfterInsert(loan.Id, loan.Id, 'Loan_New__c','Loan_New__Share','Manual','Manual');
        SAL_ApexManagedSharingController.UpdateSharingWhenLoanOfficerCreateLoan(loan.Id, loan.Id, 'Loan_New__c','Loan_New__Share','Manual','Manual');
         SAL_ApexManagedSharingController.LoanCreatedByORMPartner(loan,loanUpdated);
    }
    @isTest static void UpdateOwnerAfterLoanSubmitTest1()
    {
        Loan_New__c loan = new Loan_New__c(IsActiveFlag__c= true,IsLoanFilled_Flag__c=true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                               LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017'),
                                          IsLoanCreatedByLoanProcessor__c=false,IsLoanDetailsFilled_Flag__c=true);
            insert loan;
        Loan_New__c loanUpdated = new Loan_New__c(Id=loan.Id,IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                               LoanNumber__c = '56789',Appraisal_Received_Date__c=Date.parse('10/11/2017'),
                                                 LoanOfficer__c=null);
        loan.LoanNumber__c = '56789';
        update loanUpdated;
        SAL_ApexManagedSharingController.ShareLoanRecord(loan,loanUpdated);
        SAL_ApexManagedSharingController.ShareRecordAfterInsert(loan.Id, loan.Id, 'Loan_New__c','Loan_New__Share','Manual','Manual');
    }
    @isTest static void UpdateOwnerAfterLoanSubmitTest2()
    {
        Id sAdmin=[select Id from Profile where Name=:'System Administrator' limit 1].Id;
        User Uid =[select Id from User where ProfileId !=:sAdmin and IsActive=true limit 1];
        
        Loan_New__c loan = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                               LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017'),
                                          IsLoanCreatedByLoanProcessor__c=false,IsLoanDetailsFilled_Flag__c=true);
            insert loan;
        
        Loan_New__c loanUpdated = new Loan_New__c(Id=loan.Id,LoanOfficer__c=Uid.id, ownerid=Uid.id);
      
        update loanUpdated;
          Employment__c objEmployment = new Employment__c(City__c = 'Ghaziabad',EmployerAddress__c = 'Delhi',
            EmployerName__c = 'ORMS',EmployerPhone__c = '7894561230',Months__c = 2,
            PositionTitle__c = 'Manager',RelatedLoan__c = loanUpdated.Id,
            State__c = 'California',Years__c = 2,IncomeValue__c = 0.00, Income_Type__c = 'Employment Income');
        Insert objEmployment;   
        system.runAs(Uid){
            
        
        SAL_ApexManagedSharingController.ShareLoanRecord(loan,loanUpdated);
        SAL_ApexManagedSharingController.UpdateSharingWhenLoanOfficerCreateLoan(objEmployment.Id, loan.Id, 'Loan_New__c','Loan_New__Share','Manual','Manual');
        SAL_ApexManagedSharingController.LoanCreatedByORMPartner(loan,loanUpdated);
            //code to increase test coverage
            List<string> child = SAL_ApexManagedSharingController.loanChildObjectsList();
        	List<string> child1 = SAL_ApexManagedSharingController.ObjectListforChangeOwner();        	
        	Map<string, string> loanChild = SAL_ApexManagedSharingController.loanChildShareObjectsMap();
        	Map<string, string> loanChild1 = SAL_ApexManagedSharingController.loanChildObjectsMap();
            //List<string> child2 = SAL_ApexManagedSharingController.loanChildObjectsList1();
        	List<string> child3 = SAL_ApexManagedSharingController.ObjectListforChangeOwner1();        	
        	/*Map<string, string> loanChild2 = SAL_ApexManagedSharingController.loanChildShareObjectsMap1();
        	Map<string, string> loanChild3 = SAL_ApexManagedSharingController.loanChildObjectsMap1();*/
        }}
}