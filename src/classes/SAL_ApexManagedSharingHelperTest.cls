@isTest
public with sharing class SAL_ApexManagedSharingHelperTest {
    static testMethod void ShareRecordTest(){
                   
            Loan_New__c loan = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                               LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017'));
            insert loan;
            Id loanId=loan.Id;
        	string sLoanId = loan.Id;
        	List<string> lId = new List<string>();
        	lId.add(sLoanId);

            Test.startTest();
            SAL_ApexManagedSharingHelperController.ShareRecord('Loan_New__Share', loanId, UserInfo.getUserId(), 'Manual');
            SAL_ApexManagedSharingHelperController.DeleteSharedLoan(lId, 'Loan_New__Share', 'Manual');
            SAL_ApexManagedSharingHelperController.UpdateLoanChildRecordOwner(loanId,UserInfo.getUserId(),'Loan_New__Share');
            SAL_ApexManagedSharingHelperController.InsertRecordsForSharing(loanId, UserInfo.getUserId(), 'Manual');
            boolean a=  SAL_ApexManagedSharingHelperController.IsLoanCreatedByLoanProcessor(loanId);
            SAL_ApexManagedSharingHelperController.IsCurrentUserIsLoanProcessor();
            List<string> child = SAL_ApexManagedSharingHelperController.loanChildObjectsList();
        	List<string> child1 = SAL_ApexManagedSharingHelperController.ObjectListforChangeOwner();        	
        	Map<string, string> loanChild = SAL_ApexManagedSharingHelperController.loanChildShareObjectsMap();
        	Map<string, string> loanChild1 = SAL_ApexManagedSharingHelperController.loanChildObjectsMap();	
            Test.stopTest();
        
    }
    
}