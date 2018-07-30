public class LoanMenuController {
/*
 @AuraEnabled
public static Loan__c getValue(String id) {
     
    return [SELECT ClientIName__c,FinalCompleteFlag__c,CreditPullNew__c,CreditPullNewChild__c,CreditReissue__c,CreditReferenceNumber__c,CreditReferenceNumberConfirm__c,LoanDetailsTitleSource__c, LoanDetailsTitleCompany__c, LoanDetailsContact__c,LoanDetailsPayPartner__c,AssetsCompleteFlag__c, LoanCompleteFlag__c, SubjectCompleteFlag__c, IncomeCompleteFlag__c, LiabilitiesCompleteFlag__c , EmploymentCompleteFlag__c, ClientCompleteFlag__c, DecCompleteFlag__c ,ClientNBR__c, ClientNBS__c, ClientBorrowerName__c, ClientSSN__c, ClientDOB__c, ClientMaritalStatus__c, ClientMailingAddress1__c, ClientPresentAddressYears__c, ClientNBRName__c, ClientNBRPhone__c, ClientNBRDOB__c, ClientNBRRelationship__c, ClientNBSName__c, ClientNBSPhone__c, ClientNBSDOB__c, ClientNBSRelationship__c, ClientMailingAddress2__c, ClientCity__c, ClientState__c, ClientZip__c,SubjectPropertyAddress__c, SubjectPropertyDescription__c, SubjectPropertyResidenceType__c, SubjectPropertyYearBuilt__c, SubjectPropertyNoOfProperty__c, SubjectPropertyHeldAs__c, SubjectPropertyHeldNames__c,  SubjectPropertyRealEstateTax__c, SubjectPropertyHazardInsurance__c, SubjectPropertyHomeOwnerFee__c, SubjectCheckHeldAs__c, LiabilitiesAlimony__c, LiabilitiesJobRelated__c, LiabilitiesMortgage__c, LiabilitiesMortgagePayment__c, LiabilitiesTaxes__c, LiabilitiesCombinedMonthlyDebts__c,EmploymentAddress2__c, EmploymentCity__c, EmploymentState__c, EmploymentZip__c, EmploymentName__c, EmploymentAddress1__c, EmploymentSelfEmployed__c, EmploymentBusinessPhone__c, EmploymentStartDate__c, EmploymentEndDate__c,IncomeGrossMonthly__c, IncomeDescribeOther__c, IncomeMonthly__c, IncomeGrossRental__c, IncomeNetRental__c, DecOutstandingJudgement__c, DecPropertyForClose__c, DecLawsuit__c, DecDefaultFederalDebt__c, DecObligatedLoan__c, DecObligatedPayAlimony__c, DecDownPaymentBorrowed__c, DecUSCitizen__c, DecCoMaker__c, DecIntendToOccupy__c, DecBankrupt__c, DecReverseMortgage__c, DecFHAInsuranceLoan__c, DecEthenicity__c, DecRace__c, DecSex__c, Id, CreatedDate, AssetsTotalAssets__c, AssetsInstitutionName__c, AssetsInstitutionAddress__c, AssetsAccountNumber__c, AssetsMarketValue__c, AssetsPropertyAddress__c, AssetsPresentMarketValue__c, LoanMortgageAppliedFor__c, LoanPurpose__c, LoanOriginationFee__c, LoanApplicationTakenBy__c, LoanInterviewDate__c, LoanOriginatorCompanyName__c, LoanOriginatorPhone__c, LoanOriginatorCompanyAddress__c, LoanOriginatorIdentifier__c, LoanOriginatorCompanyIdentifier__c, LoanHouseHoldMembers__c, LoanChildrenbelow6__c, LoanPOA__c, LoanSquareFoot__c, LoanAlternateContactName__c, LoanAlternateContactAddress__c, LoanAlternateContactPhone__c, LoanEstimateAppraisedValue__c, LoanOriginatorName__c ,Name FROM Loan__c where Id  = :id limit 1];
         
}
    
     @AuraEnabled
public static ClientInfo__c getclientValue(String id) {
     
    return [SELECT Id, Name, Last_Name__c, Street_Address__c, State__c, Zip__c, Email_Optional__c, Phone_Number__c, DOB__c, City__c FROM ClientInfo__c where Id  = :id limit 1];
         
}
    
    @AuraEnabled
public static Loan__c setScreen(String id) {
     
    return [SELECT FinalCompleteFlag__c,AssetsCompleteFlag__c, LoanCompleteFlag__c, SubjectCompleteFlag__c, IncomeCompleteFlag__c, LiabilitiesCompleteFlag__c , EmploymentCompleteFlag__c, ClientCompleteFlag__c, DecCompleteFlag__c FROM Loan__c where Id  = :id limit 1];
         
}
    
     @AuraEnabled
    public static Loan__c saveLoan(Loan__c Loan,String id) {
        
         if (id == '') {
         Loan__c ln = Loan;
            upsert  Loan;
             system.debug('id is'+ ln.Id);
             return [SELECT ClientIName__c,FinalCompleteFlag__c,CreditPullNew__c,CreditPullNewChild__c,CreditReissue__c,CreditReferenceNumber__c,CreditReferenceNumberConfirm__c,LoanDetailsTitleSource__c, LoanDetailsTitleCompany__c, LoanDetailsContact__c,LoanDetailsPayPartner__c,AssetsCompleteFlag__c, LoanCompleteFlag__c, SubjectCompleteFlag__c, IncomeCompleteFlag__c, LiabilitiesCompleteFlag__c , EmploymentCompleteFlag__c, ClientCompleteFlag__c, DecCompleteFlag__c ,ClientNBR__c, ClientNBS__c, ClientBorrowerName__c, ClientSSN__c, ClientDOB__c, ClientMaritalStatus__c, ClientMailingAddress1__c, ClientPresentAddressYears__c, ClientNBRName__c, ClientNBRPhone__c, ClientNBRDOB__c, ClientNBRRelationship__c, ClientNBSName__c, ClientNBSPhone__c, ClientNBSDOB__c, ClientNBSRelationship__c, ClientMailingAddress2__c, ClientCity__c, ClientState__c, ClientZip__c,SubjectPropertyAddress__c, SubjectPropertyDescription__c, SubjectPropertyResidenceType__c, SubjectPropertyYearBuilt__c, SubjectPropertyNoOfProperty__c, SubjectPropertyHeldAs__c, SubjectPropertyHeldNames__c,  SubjectPropertyRealEstateTax__c, SubjectPropertyHazardInsurance__c, SubjectPropertyHomeOwnerFee__c, SubjectCheckHeldAs__c, LiabilitiesAlimony__c, LiabilitiesJobRelated__c, LiabilitiesMortgage__c, LiabilitiesMortgagePayment__c, LiabilitiesTaxes__c, LiabilitiesCombinedMonthlyDebts__c,EmploymentAddress2__c, EmploymentCity__c, EmploymentState__c, EmploymentZip__c, EmploymentName__c, EmploymentAddress1__c, EmploymentSelfEmployed__c, EmploymentBusinessPhone__c, EmploymentStartDate__c, EmploymentEndDate__c,IncomeGrossMonthly__c, IncomeDescribeOther__c, IncomeMonthly__c, IncomeGrossRental__c, IncomeNetRental__c, DecOutstandingJudgement__c, DecPropertyForClose__c, DecLawsuit__c, DecDefaultFederalDebt__c, DecObligatedLoan__c, DecObligatedPayAlimony__c, DecDownPaymentBorrowed__c, DecUSCitizen__c, DecCoMaker__c, DecIntendToOccupy__c, DecBankrupt__c, DecReverseMortgage__c, DecFHAInsuranceLoan__c, DecEthenicity__c, DecRace__c, DecSex__c, Id, CreatedDate, AssetsTotalAssets__c, AssetsInstitutionName__c, AssetsInstitutionAddress__c, AssetsAccountNumber__c, AssetsMarketValue__c, AssetsPropertyAddress__c, AssetsPresentMarketValue__c, LoanMortgageAppliedFor__c, LoanPurpose__c, LoanOriginationFee__c, LoanApplicationTakenBy__c, LoanInterviewDate__c, LoanOriginatorCompanyName__c, LoanOriginatorPhone__c, LoanOriginatorCompanyAddress__c, LoanOriginatorIdentifier__c, LoanOriginatorCompanyIdentifier__c, LoanHouseHoldMembers__c, LoanChildrenbelow6__c, LoanPOA__c, LoanSquareFoot__c, LoanAlternateContactName__c, LoanAlternateContactAddress__c, LoanAlternateContactPhone__c, LoanEstimateAppraisedValue__c, LoanOriginatorName__c ,Name FROM Loan__c where Id  = :ln.id limit 1];

           // return ln;
        }
        else 
        {
            Loan__c ln = Loan;
        ln.Id = id;
       System.debug(ln);
     
       upsert Loan;
      system.debug('aaaid is'+ ln.Id);
            return [SELECT ClientIName__c,FinalCompleteFlag__c,CreditPullNew__c,CreditPullNewChild__c,CreditReissue__c,CreditReferenceNumber__c,CreditReferenceNumberConfirm__c,LoanDetailsTitleSource__c, LoanDetailsTitleCompany__c, LoanDetailsContact__c,LoanDetailsPayPartner__c,AssetsCompleteFlag__c, LoanCompleteFlag__c, SubjectCompleteFlag__c, IncomeCompleteFlag__c, LiabilitiesCompleteFlag__c , EmploymentCompleteFlag__c, ClientCompleteFlag__c, DecCompleteFlag__c ,ClientNBR__c, ClientNBS__c, ClientBorrowerName__c, ClientSSN__c, ClientDOB__c, ClientMaritalStatus__c, ClientMailingAddress1__c, ClientPresentAddressYears__c, ClientNBRName__c, ClientNBRPhone__c, ClientNBRDOB__c, ClientNBRRelationship__c, ClientNBSName__c, ClientNBSPhone__c, ClientNBSDOB__c, ClientNBSRelationship__c, ClientMailingAddress2__c, ClientCity__c, ClientState__c, ClientZip__c,SubjectPropertyAddress__c, SubjectPropertyDescription__c, SubjectPropertyResidenceType__c, SubjectPropertyYearBuilt__c, SubjectPropertyNoOfProperty__c, SubjectPropertyHeldAs__c, SubjectPropertyHeldNames__c,  SubjectPropertyRealEstateTax__c, SubjectPropertyHazardInsurance__c, SubjectPropertyHomeOwnerFee__c, SubjectCheckHeldAs__c, LiabilitiesAlimony__c, LiabilitiesJobRelated__c, LiabilitiesMortgage__c, LiabilitiesMortgagePayment__c, LiabilitiesTaxes__c, LiabilitiesCombinedMonthlyDebts__c,EmploymentAddress2__c, EmploymentCity__c, EmploymentState__c, EmploymentZip__c, EmploymentName__c, EmploymentAddress1__c, EmploymentSelfEmployed__c, EmploymentBusinessPhone__c, EmploymentStartDate__c, EmploymentEndDate__c,IncomeGrossMonthly__c, IncomeDescribeOther__c, IncomeMonthly__c, IncomeGrossRental__c, IncomeNetRental__c, DecOutstandingJudgement__c, DecPropertyForClose__c, DecLawsuit__c, DecDefaultFederalDebt__c, DecObligatedLoan__c, DecObligatedPayAlimony__c, DecDownPaymentBorrowed__c, DecUSCitizen__c, DecCoMaker__c, DecIntendToOccupy__c, DecBankrupt__c, DecReverseMortgage__c, DecFHAInsuranceLoan__c, DecEthenicity__c, DecRace__c, DecSex__c, Id, CreatedDate, AssetsTotalAssets__c, AssetsInstitutionName__c, AssetsInstitutionAddress__c, AssetsAccountNumber__c, AssetsMarketValue__c, AssetsPropertyAddress__c, AssetsPresentMarketValue__c, LoanMortgageAppliedFor__c, LoanPurpose__c, LoanOriginationFee__c, LoanApplicationTakenBy__c, LoanInterviewDate__c, LoanOriginatorCompanyName__c, LoanOriginatorPhone__c, LoanOriginatorCompanyAddress__c, LoanOriginatorIdentifier__c, LoanOriginatorCompanyIdentifier__c, LoanHouseHoldMembers__c, LoanChildrenbelow6__c, LoanPOA__c, LoanSquareFoot__c, LoanAlternateContactName__c, LoanAlternateContactAddress__c, LoanAlternateContactPhone__c, LoanEstimateAppraisedValue__c, LoanOriginatorName__c ,Name FROM Loan__c where Id  = :ln.id limit 1];
        //return ln;
 
        }
          }
    
     @AuraEnabled
    public static List < ClientInfo__c > fetchAccount(String searchKeyWord) {
        String searchKey = searchKeyWord + '%';
        List <ClientInfo__c> returnList = new List < ClientInfo__c > ();
        List <ClientInfo__c> lstOfAccount = [select Name, Id, Last_Name__c, State__c, Zip__c, Email_Optional__c,
                                             PartnerID__c,Phone_Number__c,Street_Address__c,DOB__c  from ClientInfo__c where Name LIKE: searchKey];
       
        for (ClientInfo__c acc: lstOfAccount) {
            returnList.add(acc);
        }
        return returnList;
    }
    
    @AuraEnabled 
    public static void SaveClient(Loan__c Loan, ClientInfo__c objClient, String Loan_id, String client_id)
  
    {
        system.debug(Loan);
        system.debug(objClient);
        system.debug(Loan_id);
        system.debug(client_id);
        
        if (client_id == '' || client_id == null)
        {
         insert objClient;  
            system.debug('Client_Id is ' + objClient.Id);
        }
        else
        {
            objClient.Id = client_Id;
          upsert objClient;
            system.debug('client_id upsert ' + objClient.Id);
        }
         objClient.PartnerID__c=userinfo.getuserid();
        //objClient.DOB__c=mydate;
       
     id cid=objClient.id;
        
         if (Loan_id == '') {
         Loan__c ln = Loan;
             ln.ClientIName__c = objClient.Id;
            upsert  Loan;
           
        }
        else 
        {
            Loan__c ln = Loan;
        ln.Id = Loan_id;
            ln.ClientIName__c = objClient.Id;
       System.debug(ln.ClientIName__c);
     
       upsert Loan;
      
       
 
        }
     
       // user conobj= [select AccountId,ContactId from user where id =: userinfo.getuserid()];
     
      user conobj= [select AccountId,ContactId from user where id =: userinfo.getuserid()];
        system.debug('contact=='+conobj.AccountId);
       Account acc=[select Name from Account where id =:conobj.AccountId];
       system.debug('acc=='+acc.Name);
        Opportunity[] oppList = [select StageName from Opportunity where ownerid=: userinfo.getuserid() and 
                        ClientID__c =: cid and StageName not in ('Closed Lost','Closed Won')];
if (oppList.size()==0)  {
      Opportunity obj=new Opportunity();
       obj.name=objClient.Name+'_'+acc.Name;
       obj.AccountId=acc.Id;
       obj.LoanOfficerName__c=conobj.ContactId;
       obj.StageName='Proposal';
        obj.Status__c='New';
       obj.ClientID__c=objClient.id;
       //obj.ScenarioID__c=objScenario.id;
       obj.CloseDate=System.today();
       insert obj;
        }
             
    }
    */

}