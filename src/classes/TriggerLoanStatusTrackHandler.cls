/** 
* @Description invoked from TriggerLoanStatusTrack trigger to share the Loan Objects and to update Business 
* partner fields in backend.
* @created 10/30/2017
* @author Prsn (GalaxE?)
* @changelog 
* - QDA/MG 07/03 Move original updatePartnerFields into LoanUpdataPartnerFieldsHandler 
*   for additional refactoring and control execution with legacy org technical debt
*/
public class TriggerLoanStatusTrackHandler { 
    public static void shareLoan(Map<Id,Loan_New__c> loanMap) {
        Logger.push('shareLoan', 'TriggerLoanStatusTrackHandler');
        Set<Id> branchIdSet = new Set<Id>();
        Set<Id> bussinessPartnerIdSet = new Set<Id>();
        
        List<Loan_New__share> loanShareList = new List<Loan_New__share>();
        List<Loan_New__c> loanList = [Select Id,Related_Individual__r.Related_Branch__c,Loan_Processor__c,Loan_Processor__r.isActive,Related_Individual__r.AccountId,IsLoanDetailsFilled_Flag__c, (Select Id,LoanId__c from Clients__r), (Select Id,DeclarationLoan__c From Declarations__r), (Select Id,RelatedLoan__c From Assets__r) From Loan_New__c Where Id in: loanMap.keySet()];
        system.debug('loanMap.keySet()  ---> '+ loanMap.keySet());
        system.debug('loanMap.keySet()  ---> '+ loanList);       
        List<Client__Share> clientShareList = new List<Client__Share>();
        List<Declaration__Share> declarationShareList = new List<Declaration__Share>();
        List<AssetShare> assetShareList = new List<AssetShare>();
        
        boolean loanProc=GenericController.IsLoanCreatedByLoanProcessor();
        
        for(Loan_New__c loan : loanList){
             //SAL_ApexManagedSharingHelperController.DeleteSharedLoan(loan.Id,'Loan_New__share','Origination_Loan_Officer__c');
             //SAL_ApexManagedSharingController.ShareLoanRecord123(loan.Id);
            branchIdSet.add(loan.Related_Individual__r.Related_Branch__c);
            bussinessPartnerIdSet.add(loan.Related_Individual__r.AccountId);        
            //sharing loan with loan processor
           /* if(loan.Loan_Processor__c != Null && loan.Loan_Processor__r.isActive && loanProc==false && loan.IsLoanDetailsFilled_Flag__c)
            {
                Loan_New__share loanShare = new Loan_New__share();
                loanShare.ParentId = loan.Id;
                loanShare.AccessLevel = 'Edit';
                loanShare.UserOrGroupId = loan.Loan_Processor__c;
                loanShare.RowCause = Schema.Loan_New__share.RowCause.Loan_Processor__c;
                loanShareList.add(loanShare);
                
                //sharing clients with loan processor
                if(loan.clients__r != Null && loan.clients__r.size() >0) {
                    for(client__c client : loan.clients__r) {
                        if(client.LoanId__c == loan.Id) {
                            client__share clientShare = new client__share();
                            clientShare.ParentId = client.Id;
                            clientShare.AccessLevel = 'Edit';
                            clientShare.UserOrGroupId = loan.Loan_Processor__c;
                            clientShare.RowCause = Schema.client__share.RowCause.LoanProcessor__c;
                            clientShareList.add(clientShare);
                        }
                    }
                }
                //sharing declarations with loan processor user
                if(loan.declarations__r != Null && loan.declarations__r.size() >0) {
                    for(declaration__c declaration : loan.declarations__r) {
                        if(declaration.DeclarationLoan__c == loan.Id) {
                            Declaration__Share declarationShare = new Declaration__Share();
                            declarationShare.ParentId = Declaration.Id;
                            declarationShare.AccessLevel = 'Edit';
                            declarationShare.UserOrGroupId = loan.Loan_Processor__c;
                            declarationShare.RowCause = Schema.Declaration__Share.RowCause.LoanProcessor__c;
                            declarationShareList.add(declarationShare);
                        }
                    }
                }
                //sharing assets with loan processor user
                if(loan.assets__r != Null && loan.assets__r.size() >0) {
                    for(Asset asset : loan.assets__r) {
                        if(asset.RelatedLoan__c == loan.Id) {
                            AssetShare assetShare = new AssetShare();
                            assetShare.AssetId = asset.Id;
                            assetShare.AssetAccessLevel = 'Edit';
                            assetShare.UserOrGroupId = loan.Loan_Processor__c;
                            assetShare.RowCause = Schema.assetShare.RowCause.Manual;
                            assetShareList.add(assetShare);
                        }
                    }
                }
            }*/
        }
        system.debug('branchIdSet   ---> '+branchIdSet);
        system.debug('bussinessPartnerIdSet  ---> '+bussinessPartnerIdSet);
        /*
        if(clientShareList != Null && clientShareList.size() > 0) {
            insert clientShareList;
        }
        
        if(declarationShareList != Null && declarationShareList.size() > 0) {
            insert declarationShareList;
        }
        
        if(assetShareList != Null && assetShareList.size() > 0) {
            insert assetShareList;
        }
       */
        List<Contact> bussinessIndividualList = [Select Id,Name,Related_Branch__c,Related_Branch__r.Name,AccountId From Contact Where Related_Branch__c in: branchIdSet OR AccountId in: bussinessPartnerIdSet]; 
        Map<Id,User> userMap = BackendHierarchyUtility.getPartnerUserMap();
        system.debug('BackendHierarchyUtility.getPartnerUserMap()   --->'+BackendHierarchyUtility.getPartnerUserMap());
        system.debug('bussinessIndividualList  ---> '+bussinessIndividualList);
        system.debug('userMap  ---> '+userMap);
        for(Loan_New__c loan : loanList) {
            for(Contact con : bussinessIndividualList) {
                if(loan.Related_Individual__r.Related_Branch__c == con.Related_Branch__c && userMap.containsKey(con.Id) && loan.Related_Individual__r.Related_Branch__c != Null) {
            system.debug('loan.Related_Individual__r.Related_Branch__c  ='+ con.Related_Branch__c+'userMap.containsKey(con.Id)   = '+ userMap.containsKey(con.Id)+'     loan.Related_Individual__r.Related_Branch__c  '+loan.Related_Individual__r.Related_Branch__c );
                    // loan owner related user
                    User user = userMap.get(loan.Related_Individual__c);
                    system.debug('user   ->  '+user);
                    // user's in same branch
                    User roleUser = userMap.get(con.Id);
                    system.debug('roleUser   ->  '+roleUser);
                    if(user.UserRole.Name.Contains('User') && !roleUser.UserRole.Name.Contains('User')) {
                        Loan_New__share loanShare = new Loan_New__share();
                        loanShare.ParentId = loan.Id;
                        loanShare.AccessLevel = 'Edit';
                        loanShare.UserOrGroupId = roleUser.Id;
                        if(roleUser.UserRole.Name.Contains('Manager')) {
                            loanShare.RowCause = Schema.Loan_New__share.RowCause.Manager__c;
                        } else if(roleUser.UserRole.Name.Contains('Executive')) {
                            loanShare.RowCause = Schema.Loan_New__share.RowCause.Executive__c;
                        }
                        loanShareList.add(loanShare);
                    }else {
                        if(user.UserRole.Name.Contains('Manager') && roleUser.UserRole.Name.Contains('Executive')) {
                            Loan_New__share loanShare = new Loan_New__share();
                            loanShare.ParentId = loan.Id;
                            loanShare.AccessLevel = 'Edit';
                            loanShare.UserOrGroupId = roleUser.Id;
                            loanShare.RowCause = Schema.Loan_New__share.RowCause.Executive__c;
                            loanShareList.add(loanShare);
                        }
                    }
                }else {
                    if(loan.Related_Individual__r.AccountId == con.AccountId && userMap.containsKey(con.Id)) {
                        User roleUser = userMap.get(con.Id);
                        if(roleUser.UserRole.Name.Contains('Executive')) {
                            Loan_New__share loanShare = new Loan_New__share();
                            loanShare.ParentId = loan.Id;
                            loanShare.AccessLevel = 'Edit';
                            loanShare.UserOrGroupId = roleUser.Id;
                            loanShare.RowCause = Schema.Loan_New__share.RowCause.Executive__c;
                            loanShareList.add(loanShare);
                        }
                    }
                }
            }
            
        }
        if(loanShareList != Null && loanShareList.size() > 0)  {
            insert loanShareList; 
        }

        Logger.pop();
        
    } 
    
    // updating the backend fields in Bussiness Partner
    // method updatePartnerFields moved into LoanUpdatePartnerFieldsHandler
      // updating the backend fields in Bussiness Partner
    
    public static void updatePartnerFields(Map<Id,Loan_New__c> newLoanMap) {
        Logger.push('updatePartnerFields','TriggerLoanStatusTrackHandler');
        Map<Id,List<Loan_New__c>> accountLoanMap = new Map<Id,List<Loan_New__c>>();
        Set<Id> accountIdSet = new Set<Id>();
        
        for(Loan_New__c loan : newLoanMap.values()) {
            accountIdSet.add(loan.Related_Partner__c);
        }
        
        List<Loan_New__c> allLoanList = [Select Id, LoanStatus__c, LoanOfficer__c, CreatedDate, Related_Partner__c From Loan_New__c Where Related_Partner__c in: accountIdSet];
        
        for(Loan_New__c loan : allLoanList) {
            if(accountLoanMap.containsKey(loan.Related_Partner__c)) {
                accountLoanMap.get(loan.Related_Partner__c).add(loan);
            } else {
                accountLoanMap.put(loan.Related_Partner__c, new List<Loan_New__c> {loan});
            }
        }
        
        List<Account> accountList = new List<Account>();        
        for(Loan_New__c loan : newLoanMap.values()) {
            if(accountLoanMap.containsKey(loan.Related_Partner__c)) {
                List<Loan_New__c> accountLoanList = accountLoanMap.get(loan.Related_Partner__c);
                if(loan.Related_Partner__c != Null) {
                    Account relatedPartner = new Account();
                    relatedPartner.Id = loan.Related_Partner__c;
                    
                   
                    //ORMS Registrations should not capture the count if the Loan is in Sandbox status - Bala 
                    //Added new Loan status to ORMS registrations, ORMS Closed Loans and added new count ORMS Folders on Account - Bala
                    Integer ormsRegistrations = 0;
                    for(Loan_New__c loanReg : accountLoanList){
                        
                        if(loanReg.LoanStatus__c == 'Incomplete' || loanReg.LoanStatus__c == 'Proposal' || loanReg.LoanStatus__c == 'Waiting for Full Package'
                           || loanReg.LoanStatus__c == 'Application Package Received' || loanReg.LoanStatus__c == 'In Processing' || loanReg.LoanStatus__c == 'Conditionally Approved' 
                           || loanReg.LoanStatus__c == 'Underwriting Clear to Close' || loanReg.LoanStatus__c == 'Suspended' || loanReg.LoanStatus__c == 'Awaiting Closing' 
                           || loanReg.LoanStatus__c == 'Closed - Awaiting Funding' || loanReg.LoanStatus__c == 'Funded' || loanReg.LoanStatus__c == 'Denied'
                           || loanReg.LoanStatus__c == 'Withdrawn' || loanReg.LoanStatus__c == 'Cancelled/Denied' || loanReg.LoanStatus__c == 'Full Application Received - Incomplete'){
                               ormsRegistrations++;
                           }                    
                    }
                    relatedPartner.ORMS_Registrations__c = ormsRegistrations;                  
                    //relatedPartner.ORMS_Registrations__c = accountLoanList.size();
                    
                    Set<Id> loanOfficerIdSet = new Set<Id>();
                    DateTime latestLoanCreated;
                    Integer numberOfCloasedLoans = 0;
                    Integer numberOfFolders = 0;
                    
                    
                    for(Loan_New__c accLoan : accountLoanList) {
                        //if(accLoan.LoanStatus__c == 'Awaiting Closing' || accLoan.LoanStatus__c == 'Closed - Awaiting Funding' || accLoan.LoanStatus__c == 'Funded') {
                        if(accLoan.LoanStatus__c == 'Funded' || accLoan.LoanStatus__c == 'Closed - Awaiting Funding') {
                            numberOfCloasedLoans++;
                        }
                        if(accLoan.Loanstatus__c == 'In Processing' || accLoan.Loanstatus__c == 'Conditionally Approved' || accLoan.Loanstatus__c == 'Suspended'){
                            numberOfFolders++;
                        }
                        if(latestLoanCreated == Null) {
                            latestLoanCreated = accLoan.CreatedDate;  
                        }
                        if(latestLoanCreated != Null && latestLoanCreated < accLoan.CreatedDate) {
                            latestLoanCreated = accLoan.CreatedDate;
                        }
                        loanOfficerIdSet.add(accLoan.LoanOfficer__c);
                    }
                    relatedPartner.ORMS_Closed_Loans__c = numberOfCloasedLoans;
                    relatedPartner.ORMS_Folder_Loans__c = numberOfFolders;
                    relatedPartner.Number_of_loan_officers__c = loanOfficerIdSet.size();
                    relatedPartner.ORMS_Date_of_last_loan_registration__c =  Date.newInstance(latestLoanCreated.year(), latestLoanCreated.month(), latestLoanCreated.day());
                    accountList.add(relatedPartner);
                }
            }
        }
        Set<Account> accountSet = new Set<Account>(accountList);
        accountList.clear();
        accountList.addAll(accountSet);
        try{
            if(accountList.size() > 0) {
                Logger.debug('updatePartnerFields');
                update accountList;
            }       
        } catch(Exception ex) {
            System.debug('Exception Occurred'+ex);
            Logger.debugException(ex);
        }
        Logger.pop();
    }    
  
}