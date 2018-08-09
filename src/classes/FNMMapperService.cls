/**
 * @description: used for creating a Loan through FnM file on Start a new Loan  
 * @author: Ravi
 * @date: 8/25/2017
 *
 * changelog:
 * 07/24/2018: Srini - removed NullPointerException for 
 * 08/08/2018: Sahitya - Authorised stated were hardcoded, fetching the states from Metadata table
 */

public class FNMMapperService {
    
    //private static Set<String> ALLOWED_STATES = new Set<String>{'California','Florida','Michigan','Washington','Wisconsin','Minnesota'};
        
        public static Loan_New__c createLoanFromFNMResponse(FNMResponse fnmResponse, Date applicationDate,String rateType,String loanMortgageAppliedFor) {
            try {
                Loan_New__c loan = saveLoan(fnmResponse.tenOhThree, applicationDate,rateType,loanMortgageAppliedFor);
                
                List<Client__c> clients = saveClients(loan, fnmResponse.tenOhThree);
                
                if (fnmResponse.tenOhThree.income.isEmpty()) {
                    loan.IsIncomeFilled_Flag__c = true;
                    loan.IsEmploymentFilled_Flag__c = true;
                }           
                else {
                    Boolean employmentFlag = false;
                    for (FNMResponse.Income incomeData : fnmResponse.tenOhThree.income) {
                        String incomeType = INCOME_TYPE_TO_FIELD_MAPPING.get(incomeData.typeOfIncomeCode);
                        if(incomeType == 'Employment income') {
                            employmentFlag = true;
                        }
                    }
                    if(employmentFlag) {
                        loan.IsEmploymentFilled_Flag__c = false;
                    }     
                }
                
                if (fnmResponse.tenOhThree.Assets.isEmpty() && fnmResponse.tenOhThree.lifeInsurance.isEmpty()) {
                    loan.IsAssetsFilled_Flag__c = true;
                }
                
                if (fnmResponse.tenOhThree.alimonyOrChildSupportOrJobRelatedExpenses.isEmpty() && fnmResponse.tenOhThree.liabilities.isEmpty() && fnmResponse.tenOhThree.realEstateOwned.isEmpty()) {
                    loan.IsLaibilitiesFilled_Flag__c = true;
                } 
                
                Update loan;
                
                List<Income_New__c> incomes = saveIncomes(loan, clients, fnmResponse.tenOhThree);
                List<Declaration__c> declarations = saveDeclarations(loan, clients, fnmResponse.tenOhThree);
                List<Liability__c> liabilities = saveLiabilities(loan, clients, fnmResponse.tenOhThree);
                GenericController.UpdateLiabilityFlag(loan.Id);
                List<Asset> assets = saveAssets(loan, clients, fnmResponse.tenOhThree);
                  GenericController.UpdateAssetFlag(loan.Id);
                List<Employment__c> employments = saveEmployments(loan, clients, fnmResponse.tenOhThree);
                
                return loan;
            } catch(Exception e) {
                System.debug(e);
                Exception_log.Create_Custom_Logs(e.getMessage(),'createLoanFromFNMResponse','FNMMapper','Date'+system.today());
                throw new AuraHandledException('Unknown Error occurred while importing the Fannie Mae file.');
            }
        }    
    
    private static Loan_New__c saveLoan(FNMResponse.tenOhThree tt, Date applicationDate,String rateType,String loanMortgageAppliedFor) {
        
        /*  Exception_log.Create_Custom_Logs('FNMMapper'+tt+': Purchase Price'+tt.DetailsOfTransaction
,'fmnmapper','saveLoan','by jyoti if part');*/
        
        //Code by Bala for - SFDC-244       
        List<String> allowStates = new List<String>();        
        for (AuthorisedStates__mdt each : [SELECT Label FROM AuthorisedStates__mdt]){            
            allowStates.add(each.Label);
        }  
        //End Code
        
        Loan_New__c loan = new Loan_New__c();
        
        // Setting related partner
        String userId = UserInfo.getUserId();
        User u = [select id, contactId from User where id = : userId];
        String contactId = u.contactId;
        Contact contact = [select id, AccountId from Contact where id = : contactId];
        loan.Related_Partner__c = contact.AccountId;
        loan.Related_Individual__c = contactId;
        
        loan.Application_Date__c = applicationDate;
        
        FNMResponse.PropertyInformation pi = tt.propertyInformation;
        FNMResponse.PropertyAddress pa = pi.PropertyAddress;
        loan.Subject_Property_Address__c = formatAddress(pa.streetAddress, pa.streetAddress2);
        loan.Subject_Property_City__c = pa.city;
        loan.Subject_Property_State__c = STATES.get(pa.state);
        //Exception_log.Create_Custom_Logs('Information'+pi +'Address  :'+pa,'fmnmapper','saveincome','by jyoti if part');
        
        //Code by Bala for - SFDC-244
        if (!allowStates.contains(loan.Subject_Property_State__c)) {
            //throw new AuraHandledException('This file is not valid to upload, because at this time One Reverse Mortgage is only accepting loans for subject properties within the state of California,Florida,Michigan,Washington,Wiscosin and Minnesota. Please call your account executive to review this loan.');
            throw new AuraHandledException('Loans cannot be originated in this state.');
        }
        
        loan.Subject_Property_Zip_Code__c = formatZip(pa.zipCode, pa.zipCodePlusFour);
        loan.Legal_Description_of_Property__c = pi.legalDescriptionPropertyText;
        
        // loan.Residence_Type__c = RESIDENCE_TYPES.get(tt.LoanPurpose.propertyWillBe);
        loan.No_of_Units__c = pi.numberOfUnits;
        loan.Year_Built__c = String.valueOf(tt.propertyInformation.yearBuilt);
        loan.Property_Held_as__c = ESTATE_HELD_IN.get(tt.LoanPurpose.estateHeldIn);
        
        List<String> titleNames = new List<String>();
        for(FNMResponse.TitleHolders titleHolder : tt.titleHolders) {
            titleNames.add(titleHolder.titleHolderName);
        }
        loan.Property_Title_is_Held_in_These_Names__c = String.join(titleNames, ',');
        
        loan.Purpose_of_Loan__c = PURPOSE_OF_LOAN.get(tt.LoanPurpose.purposeOfLoan);
        loan.This_application_was_taken_by__c = APPLICATION_TAKEN_BY.get(tt.LoanOriginator.applicationTakenBy);
        
        loan.Estimate_of_Appraised_Value__c = tt.FannieMaeTransmittalData.propertyAppraisedValue;
        
        //Code Modified by Dev4 for ORMSFDC-1471
        loan.Mortgage_Applied_for__c=loanMortgageAppliedFor;
        loan.Rate_Type__c=rateType;
        
        if(rateType=='ARM')
        {
            loan.Loan_Origination_Fee_Calculation__c='Calculate Maximum Fee';
            if(loanMortgageAppliedFor=='HECM for Purchase')
            {
                
                loan.Purpose_of_Loan__c=''; 
                loan.Selected_Loan_Payment_Plan__c='';
                loan.Estimate_of_Appraised_Value__c=0;
                loan.Loan_Origination_Fee__c=0;
                loan.Purchase_Price__c  =tt.detailsOfTransaction.purchasePrice;
                if(tt.detailsOfTransaction.purchasePrice!=null)
                {
                    loan.Loan_Origination_Fee__c=getCalculatedFee(tt.detailsOfTransaction.purchasePrice);
                }
                
            }
            else{
                
                decimal resultLoanOriginationFee= 0.0;
                decimal appraisedValue=loan.Estimate_of_Appraised_Value__c;                
                if(appraisedValue!=0 && appraisedValue!=null)
                {                    
                    resultLoanOriginationFee= getCalculatedFee(appraisedValue);
                    loan.Loan_Origination_Fee__c=resultLoanOriginationFee;
                }
                else
                {
                    loan.Loan_Origination_Fee__c=0;
                    
                }
            }
        }
        else if(rateType=='Fixed')
        {
            loan.Selected_Loan_Payment_Plan__c='Single Lump Sum (Fixed)';
            if(loanMortgageAppliedFor=='HECM for Purchase')
            {
                loan.Purpose_of_Loan__c=''; 
                loan.Selected_Loan_Payment_Plan__c='';
                loan.Estimate_of_Appraised_Value__c=0;
                loan.Purchase_Price__c  =tt.detailsOfTransaction.purchasePrice;         
                
            }
        }
        
        
        
        //Code Ended by Dev4 for ORMSFDC-1471
        loan.Hazard_Insurance__c = getHazardInsurance(tt.presentOrProposedHousingExpense);
        loan.Real_Estate_Taxes__c = getRealEstateTaxes(tt.presentOrProposedHousingExpense);
        
        //Code Modified by Dev4 for ORMSFDC-1402
        loan.HOA_Monthly_Dues__c=getHOADues(tt.presentOrProposedHousingExpense);
        
        List<FNMResponse.RealEstateOwned> lst=new  List<FNMResponse.RealEstateOwned>();
        lst= tt.realEstateOwned;
        if(!lst.isEmpty())
        {
            FNMResponse.RealEstateOwned obj=new FNMResponse.RealEstateOwned();
            obj=lst[0]; 
            loan.Present_Market_Value__c = obj.presentMarketValue;
            loan.Mortgage_and_Liens__c = obj.amountOfMortgagesAndLiens;           
            loan.Monthly_Mortgage_Payment__c = obj.mortgagePayments;            
            loan.Subject_Property_Type__c = PROPERTY_TYPES.get(obj.propertyType);
        }
        //Code Ended by Dev4 for ORMSFDC-1402
        
        //loan.Subject_Property_County__c='400';
        //loan.Subject_Property_County__c=tt.fhaAndVALoanData.propertyOfCounty;
        //Srini
        if (tt.fhaAndVALoanData != null ) {
            loan.Subject_Property_County__c=tt.fhaAndVALoanData.propertyOfCounty;
         }else {
            loan.Subject_Property_County__c='400';
        }
        //End Srini    
        loan.IsActiveFlag__c = true;
        //Modified By Nausad
        //Always False
        loan.Is_Loan_Created_Manually__c=false;
        loan.IsLoanFilled_Flag__c = false;
        //loan.IsClientFilled_Flag__c = false;
         if(loan.Id==null)
            {
            loan.IsLoanCreatedByLoanProcessor__c=GenericController.IsLoanCreatedByLoanProcessor();  
            }
        
        //Need Verify and make false
        loan.IsSubjectPropertyFilled_Flag__c = false;
        //Modified By Nausad
        insert loan;
        
        return loan;
    }
    private static List<Client__c> saveClients(Loan_New__c loan, FNMResponse.tenOhThree tt) {
        List<Client__c> clients = new List<Client__c> ();
        Client__c Primaryclient = new Client__c();  
        for (FNMResponse.ApplicantData applicant : tt.applicantData) {
            Client__c client = new Client__c();            
            client.LoanId__c = loan.Id;
            client.is_Active__c = true;
            client.Name=applicant.lastName+ ', '+applicant.firstName+' '+applicant.middleName;
            client.First_Name__c = applicant.firstName;
            client.Middle_Name__c = applicant.middleName;
            client.Last_Name__c = applicant.lastName;
            client.Email_Optional__c = cleanEmail(applicant.emailAddress);
            //if (String.isNotBlank(client.Email_Optional__c)) {
            //   client.Client_has_Email_Address__c = true;
            // }
            client.Social_Security_Number__c = applicant.ssn;
            client.Home_Phone__c = applicant.homePhone;
            client.DOB__c = toDate(applicant.dateOfBirth);
            client.Marital_Status__c = MARITAL_STATUSES.get(applicant.maritalStatus);
            
            // first client is primary
            client.Primary_Client_for_the_Loan__c = clients.size() == 0;
            
            //Setting checkboxes default to true - ORMSFDC-1227
            client.Check_if_Mailing_Address_is_similar_to_P__c = true;
            /* if(client.Primary_Client_for_the_Loan__c == true)
{
//client.Address_Same_As_SubjectProperty__c = true;
}
else
{
// client.Client_Address_Same_As_Primary_Client__c = true;
}*/
            //Setting checkboxes default to true - ORMSFDC-1227 ends    
            for (FNMResponse.ApplicantsAddress address : tt.applicantsAddress) {
                if (address.ssn == client.Social_Security_Number__c && address.addressType == 1) {
                    client.Street_Address__c = formatAddress(address.residenceAddress.streetAddress, address.residenceAddress.streetAddress2);
                    client.City__c = address.residenceAddress.city;
                    //client.State__c = STATES.get(address.residenceAddress.state);
                    //2/13/2018 dinesh
                    client.Client_State__c = STATES.get(address.residenceAddress.state);
                    client.Zip__c = formatZip(address.residenceAddress.zipCode, address.residenceAddress.zipCodePlusFour);
                    client.Number_of_years__c = address.yearsAtResidence;
                    client.Residence__c = RESIDENCES.get(address.residenceOwnership);
                    client.Address_Mailing__c = formatAddress(address.residenceAddress.streetAddress, address.residenceAddress.streetAddress2);
                    client.City_Mailing__c =  address.residenceAddress.city;
                    client.State_Mailing__c = STATES.get(address.residenceAddress.state);
                    client.Zip_Mailing__c =formatZip(address.residenceAddress.zipCode, address.residenceAddress.zipCodePlusFour);
                    if(client.Primary_Client_for_the_Loan__c == true)
                    {
                        Primaryclient.Street_Address__c= client.Street_Address__c ;
                        Primaryclient.City__c=client.City__c;
                        Primaryclient.Client_State__c=client.Client_State__c;
                        Primaryclient.Zip__c=client.Zip__c;
                        if(loan.Subject_Property_Address__c == client.Street_Address__c &&
                           loan.Subject_Property_City__c ==client.City__c &&
                           loan.Subject_Property_State__c == client.Client_State__c  &&
                           loan.Subject_Property_Zip_Code__c==client.Zip__c )
                        {
                            client.Address_Same_As_SubjectProperty__c = true;
                        }
                        
                    }
                    else{
                        if( Primaryclient.Street_Address__c== client.Street_Address__c   &&
                           Primaryclient.City__c==client.City__c  &&
                           Primaryclient.Client_State__c==client.Client_State__c  &&
                           Primaryclient.Zip__c==client.Zip__c )
                        {
                            client.Client_Address_Same_As_Primary_Client__c = true;
                        }
                        
                    }
                    
                }
                /*  if (address.ssn == client.Social_Security_Number__c && address.addressType == 2) {
client.Address_Mailing__c = formatAddress(address.residenceAddress.streetAddress, address.residenceAddress.streetAddress2);
client.City_Mailing__c = address.residenceAddress.city;
client.State_Mailing__c = STATES.get(address.residenceAddress.state);
client.Zip_Mailing__c = formatZip(address.residenceAddress.zipCode, address.residenceAddress.zipCodePlusFour);
if( 
client.Street_Address__c== client.Address_Mailing__c   &&
client.City__c==client.City_Mailing__c  &&
client.Client_State__c==client.State_Mailing__c  &&
client.Zip__c==client.Zip_Mailing__c )
{
client.Check_if_Mailing_Address_is_similar_to_P__c = true;
} 
}*/
            }
            
            system.debug('About to insert new client: ' + client);
            //Code for story-ORMSFDC-1512 by DEV2
            boolean isClientValidate=IsClientMandatorySatisfied(client);
            client.Is_Client_Validated__c=isClientValidate;
            //End
            insert client;
            
            
            clients.add(client);
            
        }
        
        system.debug('Created ' + clients.size() + ' new clients.');
        GenericController.UpdateClientFlag(loan.Id);
        return clients;
    }
    //Function used for story-ORMSFDC-1512 by DEV2
    Private static  boolean IsClientMandatorySatisfied(Client__c Client)
    {
        boolean isClientValidate=true;
        try{
            if(Client !=null)
            {
                if(Client.First_Name__c=='')
                {
                    isClientValidate=false;
                }
                else if(Client.Last_Name__c=='' )
                {
                    isClientValidate=false;
                }
                else if(Client.Home_Phone__c==null)
                {
                    isClientValidate=false;
                }
                else if(Client.DOB__c==null)
                {
                    isClientValidate=false;
                }
                else if(Client.Number_of_years__c==null)
                {
                    isClientValidate=false;
                }
                else if(Client.Social_Security_Number__c=='' )
                {
                    isClientValidate=false;
                }
                else if(Client.Street_Address__c=='' )
                {
                    isClientValidate=false;
                }
                else if(Client.City__c=='' )
                {
                    isClientValidate=false;
                }
                else if(Client.Client_State__c=='' )
                {
                    isClientValidate=false;
                }
                else if(Client.Zip__c=='')
                {
                    isClientValidate=false;
                }
                else if(Client.Address_Mailing__c=='' )
                {
                    isClientValidate=false;
                }
                else if(Client.City_Mailing__c=='' )
                {
                    isClientValidate=false;
                }
                else if(Client.State_Mailing__c=='' ||Client.State_Mailing__c==null)
                {
                    isClientValidate=false;
                }
                else if(Client.Zip_Mailing__c=='')
                {
                    isClientValidate=false;
                }
            }
            
        }  
        catch(exception ex){
            system.debug('bug'+ex.getMessage());
        }
        return isClientValidate;
    }
    
    private static List<Income_New__c> saveIncomes(Loan_New__c loan, List<Client__c> clients, FNMResponse.tenOhThree tt) {
        List<Income_New__c> incomes = new List<Income_New__c> ();
        for (Client__c client : clients) {
            
            // create new income object for this client
            //List<Income_New__c> clientIncomes = SAL_ClientController.CreateIncome(client, loan.Id);
            
            // search for incomes for this client
            for (FNMResponse.Income incomeData : tt.income) {
                if (incomeData.ssn == client.Social_Security_Number__c) {
                    String incomeType = INCOME_TYPE_TO_FIELD_MAPPING.get(incomeData.typeOfIncomeCode);
                    if(incomeType != 'Employment Income') {
                        
                        // Income_New__c income = findIncome(clientIncomes, incomeType);
                        if (incomeData.monthlyIncomeAmount != null) {
                            Income_New__c income = new Income_New__c();
                            income.Income_Types__c = incomeType;
                            //Code Added by Dev4 for ORMSFDC-1509
                            if(income.Income_Types__c=='Bonuses' || income.Income_Types__c=='Commissions' || income.Income_Types__c=='Overtime')
                            {
                                income.Income_Source__c = 'Employment';
                            }
                            else
                            {
                                income.Income_Source__c = '';
                            }
                            //Code ended by Dev4 for ORMSFDC-1509
                            income.Income_Value__c = incomeData.monthlyIncomeAmount;
                            income.Related_Loan__c = client.LoanId__c;
                            income.RelatedClient__c = client.Id;
                            income.isActive__c = true;
                            system.debug('About to insert new income object: ' + income);
                            //Code Added by Dev4 for ORMSFDC-1509 Modified by Nausad
                            if (incomeType == 'Social Security Income') {
                                if(  income.Income_Value__c != Null)
                                    income.Is_Income_Validated__c = true;
                                
                                
                            }
                            else{
                                if ((income.Income_Types__c != '' || income.Income_Types__c!=null) &&  
                                    (income.Income_Value__c != null || income.Income_Value__c!=0.0)
                                    && income.Income_Source__c!=''){
                                        income.Is_Income_Validated__c = true; 
                                        
                                    }
                                else
                                {
                                    income.Is_Income_Validated__c=false;
                                }
                            }
                            //Code ended by Dev4 for ORMSFDC-1509
                            
                            // if (incomeType == 'Social Security Income' && income.Income_Value__c != Null) {
                            //   income.Is_Income_Validated__c = true;
                            //}
                            insert income;
                            incomes.add(income);
                        }/* else {
income.Income_Value__c = incomeData.monthlyIncomeAmount;
system.debug('About to update income object: ' + income);
update income;
}*/
                    }  
                }
            }
            // incomes.addAll(clientIncomes);
        }
        //setting record level flag. 
        if(incomes.size() > 0 ) {
            loan.IsIncomeFilled_Flag__c = false;
        } else {
            loan.IsIncomeFilled_Flag__c = true;
        }
        update loan;
        
        system.debug('Created ' + incomes.size() + ' new incomes.');
        return incomes;
    }
    
    private static List<Declaration__c> saveDeclarations(Loan_New__c loan, List<Client__c> clients, FNMResponse.tenOhThree tt) {
        List<Declaration__c> declarations = new List<Declaration__c> ();
        for (Client__c client : clients) {
            
            // create new declaration object for this client
            Declaration__c declaration = SAL_ClientController.CreateDeclaration(client, loan.Id);
            
            // search for declarations for this client
            for (FNMResponse.Declarations declarationData : tt.declarations) {
                if (declarationData.ssn == client.Social_Security_Number__c) {
                    declaration.Outstanding_Judgments__c = booleanToYesNo(declarationData.outstandingJudgments);
                    declaration.Lawsuit__c = booleanToYesNo(declarationData.partyToLawsuit);
                    declaration.Endorser__c = booleanToYesNo(declarationData.coMakerOrEndorserOnNote);
                    declaration.US_Citizen__c = CITIZENSHIP.get(declarationData.citizenShip);
                    declaration.Bankruptcy__c = booleanToYesNo(declarationData.declaredBankruptcy);
                    //Code Added By Dev4 For Story 1600
                    if(declarationData.citizenShip!='')
                    {
                        if(declarationData.citizenShip=='01')
                        {
                            declaration.US_Citizen__c = CITIZENSHIP.get(declarationData.citizenShip);
                            declaration.Permanent_Resident__c='No';
                            
                        }
                        else if(declarationData.citizenShip=='03')
                        {
                            declaration.US_Citizen__c = CITIZENSHIP.get(declarationData.citizenShip);
                            declaration.Permanent_Resident__c='Yes';
                            
                        }
                        else if(declarationData.citizenShip=='05')
                        {
                            declaration.US_Citizen__c = CITIZENSHIP.get(declarationData.citizenShip);
                            declaration.Permanent_Resident__c='No';
                            
                        }
                        
                    }
                    if(declarationData.delinquencyOrDefault!=null)
                    {
                        declaration.Delinquent__c=booleanToYesNo(declarationData.delinquencyOrDefault);
                    }
                    if(declarationData.doYouIntendToOccupy!=null)
                    {
                        declaration.Primary_Residence__c=ISPROPERTY_OCCUPY.get(declarationData.doYouIntendToOccupy);
                    }
                    //Code ended By Dev4 For Story 1600
                }
            }
            
            for (FNMResponse.GovernmentMonitoringInfo govMonitoringData : tt.governmentMonitoringInfo) {
                if (govMonitoringData.ssn == client.Social_Security_Number__c) {
                    declaration.Ethnicity_New__c = ETHNICITY.get(govMonitoringData.ethnicity);
                    declaration.Sex_New__c = SEX.get(govMonitoringData.sex);
                }
            }
            
            declaration.Race__c = null;
            for (FNMResponse.Races r : tt.races) {
                if (r.ssn == client.Social_Security_Number__c) {
                    if (String.isNotBlank(declaration.Race__c)) {
                        declaration.Race__c += ';' + RACE.get(r.race);
                    } else {
                        declaration.Race__c = RACE.get(r.race);
                    }
                }
            }
            
            system.debug('About to insert new declaration object: ' + declaration);
            
            update declaration;
            declarations.add(declaration);
        }
        
        system.debug('Created ' + declarations.size() + ' new declarations.');
        return declarations;
    }
    
    private static List<Liability__c> saveLiabilities(Loan_New__c loan, List<Client__c> clients, FNMResponse.tenOhThree tt) {
        List<Liability__c> liabilities = new List<Liability__c> ();
        
        // iterate over AlimonyOrChildSupportOrJobRelatedExpenses
        for (FNMResponse.AlimonyOrChildSupportOrJobRelatedExpenses expense : tt.alimonyOrChildSupportOrJobRelatedExpenses) {
            Liability__c liability = startLiability(loan, clients, expense.ssn);
            if (liability.RelatedClient__c == null) {
                System.debug('No client found for liability: ' + expense);
                continue;
            }
            
            liability.Type__c = 'Other';
            liability.Liability_Type__c = 'Other';
            
            if (expense.expenseTypeCode >= 0 && expense.expenseTypeCode <= 2) {
                liability.Liability_Category__c = 'Alimony';
                liability.Alimony_Type__c = EXPENSE_TYPE.get(expense.expenseTypeCode);
                liability.Payments_Owed_to__c = expense.alimonyOwedTo;
                liability.Amount__c = expense.monthlyPaymentAmount;
                
                if (liability.Amount__c != Null) {
                    liability.Is_Liability_Validated__c = true;
                }
            } else if (expense.expenseTypeCode >= 3 && expense.expenseTypeCode <= 4) {
                liability.Liability_Category__c = 'Job Expenses';
                liability.Job_Expense_Type__c = EXPENSE_TYPE.get(expense.expenseTypeCode);
                liability.Job_Related_Expenses__c = expense.monthlyPaymentAmount;
                
                if (liability.Job_Related_Expenses__c != Null) {
                    liability.Is_Liability_Validated__c = true;
                }
            }
            
            system.debug('About to insert new expense or alimony liability object: ' + liability);
            
            insert liability;
            liabilities.add(liability);
        }
        
        // iterate over liabilities
        for (FNMResponse.Liabilities fannieLiability : tt.liabilities) {
            Liability__c liability = startLiability(loan, clients, fannieLiability.ssn);
            if (liability.RelatedClient__c == null) {
                System.debug('No client found for liability: ' + fannieLiability);
                continue;
            }
            
            liability.Type__c = LIABILITY_TYPE.get(fannieLiability.liabilityType);
            
            // Ignoring mortgage loans since these are captured as Real Estate Schedule > Property
            if (liability.Type__c == 'Mortgage Loans') continue;
            
            liability.Liability_Category__c = 'Liability';
            liability.Liability_Type__c = liability.Type__c;
            liability.Name_of_Company__c = fannieLiability.creditorName;
            liability.Address__c = formatAddress(fannieLiability.creditorAddress.streetAddress, fannieLiability.creditorAddress.streetAddress2);
            liability.City__c = fannieLiability.creditorAddress.city;
            liability.State__c = STATES.get(fannieLiability.creditorAddress.state);
            liability.Zip__c = formatZip(fannieLiability.creditorAddress.zipCode, fannieLiability.creditorAddress.zipCodePlusFour);
            liability.Account_Number__c = fannieLiability.accountNumber;
            liability.Liability_Monthly_Payment__c = fannieLiability.monthlyPaymentAmount;
            //liability.Remaining_months__c = fannieLiability.monthsLeftToPay;
            liability.Liability_Unpaid_Balance__c = fannieLiability.unpaidBalance;
            liability.Liability_will_be_closed_by_paying__c = fannieLiability.liabilityWillBePaidByClosing;
            
            system.debug('About to insert new liability object: ' + liability);
            
            if (liability.Liability_Monthly_Payment__c != Null && liability.Liability_Unpaid_Balance__c != Null) {
                liability.Is_Liability_Validated__c = true;
            }
            insert liability;
            liabilities.add(liability);
        }
        
        // iterate over RealEstateOwned
        for (FNMResponse.RealEstateOwned reo : tt.realEstateOwned) {
            Liability__c liability = startLiability(loan, clients, reo.ssn);
            if (liability.RelatedClient__c == null) {
                System.debug('No client found for liability: ' + reo);
                continue;
            }
            
            liability.Type__c = 'Other';
            liability.Liability_Type__c = 'Other';
            liability.Liability_Category__c = 'Real Estate Schedule';
            liability.Present_Mortgage_Value__c = reo.presentMarketValue;
            liability.Mortgage_Liens__c = reo.amountOfMortgagesAndLiens;
            liability.Gross_Rental_Income__c = reo.grossRentalIncome;
            liability.Mortgage_Payments__c = reo.mortgagePayments;
            //liability.Insurance_Taxes_etc__c = reo.insuranceMaintenanceTaxesAndMisc;
            liability.Net_Rental_Income_RealEstate__c = reo.netRentalIncome;
            //liability.Property_Type__c = PROPERTY_TYPES.get(reo.propertyType);
            //Code Added By Dev4 For Story 1600
            liability.Property_Type__c = 'Property';
            //Code Ended By Dev4 For Story 1600
            liability.Property_Address__c = reo.propertyAddress.streetAddress;
            liability.Property_Address2__c = reo.propertyAddress.streetAddress2;
            liability.Property_City__c = reo.propertyAddress.city;
            liability.Property_States__c= STATES.get(reo.propertyAddress.state);
            liability.Property_ZIP__c = formatZip(reo.propertyAddress.zipCode, reo.propertyAddress.zipCodePlusFour);
            //code modified by dev5 for story 1593
            /*if (isSameAddress(tt.propertyInformation.PropertyAddress, reo.propertyAddress)) 
{
liability.Property_Status__c = 'Subject Property';
liability.Liability_will_be_closed_by_Paying_RES__c = true;
}

system.debug('About to insert new real estate owned liablity object: ' + liability);

if (liability.Property_Address__c != Null && liability.Property_City__c != Null && liability.Property_Status__c != Null) 
{
liability.Is_Liability_Validated__c = true;
}

insert liability;
liabilities.add(liability);*/
            if (isSameAddress(tt.propertyInformation.PropertyAddress, reo.propertyAddress)) 
            {
                liability.Property_Status__c = 'Subject Property';
                liability.Liability_will_be_closed_by_Paying_RES__c = true;
            }
            else
            {
                if (liability.Property_Address__c != '' && liability.Property_City__c != '' && liability.Property_Status__c != '' 
                    && liability.Year_Built__c != null && liability.County__c != '' && liability.Real_Estate_Taxes_Monthly__c !=null
                    && liability.Square_Footage__c != null && liability.Property_Held_as__c != '') 
                {
                    liability.Is_Liability_Validated__c = true;
                } 
                insert liability;
                liabilities.add(liability);
            }            
            
            //End of code change
        }
        
        system.debug('Created ' + liabilities.size() + ' new liabilities.');
        return liabilities;
    }
    
    private static List<Asset> saveAssets(Loan_New__c loan, List<Client__c> clients, FNMResponse.tenOhThree tt) {
        List<Asset> assets = new List<Asset> ();
        
        // iterate over assets
        for (FNMResponse.Assets fannieAsset : tt.Assets) {
            Asset newAsset = startAsset(loan, clients, fannieAsset.ssn);
            if (newAsset.RelatedClient__c == null) {
                System.debug('No client found for asset: ' + fannieAsset);
                continue;
            }
            
            newAsset.Name = 'Asset'; // TODO What should the name be?
            newAsset.Name_of_Institution__c = fannieAsset.depositoryName;
            newAsset.Financial_Institution_Address__c = formatAddress(fannieAsset.depositoryAddress.streetAddress, fannieAsset.depositoryAddress.streetAddress2);
            newAsset.Financial_institution_City__c = fannieAsset.depositoryAddress.city;
            newAsset.Finanical_Institution_State__c = STATES.get(fannieAsset.depositoryAddress.state);
            newAsset.Financial_Institution_Zip_Code__c = formatZip(fannieAsset.depositoryAddress.zipCode, fannieAsset.depositoryAddress.zipCodePlusFour);
            newAsset.Category__c = ASSET_TYPE_CATEGORY.get(fannieAsset.assetType);
            newAsset.Source_Name__c=fannieAsset.depositoryName;
            if (newAsset.Category__c == 'Bank/Credit Union') {
                newAsset.Type_of_Account__c = ASSET_TYPE.get(fannieAsset.assetType);
                //newAsset.Name_of_Bank_S_L_Credit_Union__c = fannieAsset.depositoryName;
                newAsset.Account_Number__c = fannieAsset.accountNumber;
                newAsset.Cash_or_Market_Value__c = fannieAsset.cashOrMarketValue;
                
                if (newAsset.Source_Name__c != '' && newAsset.Cash_or_Market_Value__c != Null && newAsset.Type_of_Account__c != '') 
                {
                    newAsset.Is_Asset_Validated__c = true;
                } 
                
            } else if (newAsset.Category__c == 'Stock & Bonds') {
                newAsset.Type__c = ASSET_TYPE.get(fannieAsset.assetType);
                //newAsset.Company_Name_Number__c = fannieAsset.depositoryName;
                newAsset.Cash_or_Market_Value__c = fannieAsset.cashOrMarketValue;
                 if (newAsset.Source_Name__c != '' && newAsset.Cash_or_Market_Value__c != Null && newAsset.Type__c != '') 
                {
                    newAsset.Is_Asset_Validated__c = true;
                } 
                
            } else if (newAsset.Category__c == 'Retirement Fund') {
                newAsset.Vested_Interest_in_Retirement_Fund__c = fannieAsset.cashOrMarketValue;
                   if (newAsset.Source_Name__c != '' && newAsset.Vested_Interest_in_Retirement_Fund__c != Null) 
                {
                    newAsset.Is_Asset_Validated__c = true;
                } 
                
            } else if (newAsset.Category__c == 'Business') {
                newAsset.Net_Worth_of_Business_es_Owned__c = fannieAsset.cashOrMarketValue;
                   if (newAsset.Source_Name__c != '' && newAsset.Net_Worth_of_Business_es_Owned__c != Null) 
                {
                    newAsset.Is_Asset_Validated__c = true;
                } 
                
            } else if (newAsset.Category__c == 'Others') {
                newAsset.Other_Assets_Type__c = ASSET_TYPE.get(fannieAsset.assetType);
                newAsset.Other_Asset_Amount__c = fannieAsset.cashOrMarketValue;
                   if (newAsset.Source_Name__c != '' && newAsset.Other_Assets_Type__c  != '' &&  newAsset.Other_Asset_Amount__c  != Null) 
                {
                    newAsset.Is_Asset_Validated__c = true;
                } 
                //    Exception_log.Create_Custom_Logs('Asset :'+newAsset.Other_Assets_Type__c,'fmnmapper','saveAsset','by jyoti  part');
                
            }
            
            
            system.debug('About to insert new asset object: ' + newAsset);
            
            insert newAsset;
            assets.add(newAsset);
        }
        
        
        // iterate over lifeInsurance
        for (FNMResponse.LifeInsurance lifeInsurance : tt.lifeInsurance) {
            Asset newAsset = startAsset(loan, clients, lifeInsurance.ssn);
            if (newAsset.RelatedClient__c == null) {
                System.debug('No client found for LifeInsurance: ' + lifeInsurance);
                continue;
            }
            
            newAsset.Name = 'Asset'; // TODO What should the name be?
            newAsset.Category__c = 'Life Insurance';
            
            newAsset.Life_Insurance_Policy_Face_Value__c = lifeInsurance.lifeInsuranceFaceAmount;
            
                 if (newAsset.Source_Name__c != '' && newAsset.Life_Insurance_Policy_Face_Value__c  != Null) 
                {
                    newAsset.Is_Asset_Validated__c = true;
                } 
            system.debug('About to insert new asset object: ' + newAsset);
            
            insert newAsset;
            assets.add(newAsset);
        }
        
        system.debug('Created ' + assets.size() + ' new assets.');
        return assets;
    }
    
    private static List<Employment__c> saveEmployments(Loan_New__c loan, List<Client__c> clients, FNMResponse.tenOhThree tt) {
        List<Employment__c> employments = new List<Employment__c> ();
               
        // iterate over primary employer
        for (FNMResponse.PrimaryCurrentEmployers employer : tt.primaryCurrentEmployers) {
            
            Employment__c employment = startEmployment(loan, clients, employer.ssn);
            if (employment.Client_id__c == null) {
                System.debug('No client found for employer: ' + employer);
                continue;
            }
          
            //employment.SelfEmployment__c = booleanToYesNo(employer.selfEmployed);
            employment.EmployerName__c = employer.employerName;
            employment.PositionTitle__c = employer.position;
            employment.EmployerPhone__c = employer.businessPhone;
            employment.EmployerAddress__c = formatAddress(employer.employerAddress.streetAddress, employer.employerAddress.streetAddress2);
            employment.Zip__c = formatZip(employer.employerAddress.zipCode, employer.employerAddress.zipCodePlusFour);
            employment.State__c = STATES.get(employer.employerAddress.state);
            employment.City__c = employer.employerAddress.city;
            
            employment.is_Active__c = true;
            if (employer.yearsInLineOfWork != null) {
                employment.YearEmployedinProfession__c = String.valueOf(Math.min(employer.yearsInLineOfWork, 10));
            }
            employment.Years__c = employer.yearsOnJob;
            employment.Months__c = employer.monthsOnJob;
            
            employment.Income_Type__c = 'Employment Income';
            employment.IncomeValue__c = 0;
            
            for(FNMResponse.Income income : tt.Income) {
                String incomeType = INCOME_TYPE_TO_FIELD_MAPPING.get(income.typeOfIncomeCode);
                if(income.ssn == employer.ssn && incomeType == 'Employment Income' ) {
                    employment.IncomeValue__c = income.monthlyIncomeAmount;
                }
            }
            system.debug('About to insert new employment object: ' + employment);
            
            if(employment.IncomeValue__c != 0 && (employment.Years__c != Null && employment.Years__c != 0)) {
                employment.Is_Employment_Validated__c = true;
            }
            //Code Modified by Dev4 for ORMSFDC-1601
            if(!employer.selfEmployed)
            {
                employment.IncomeCategory__c='Standard';
            }
            //Code Ended by Dev4 for ORMSFDC-1601
            insert employment;
            employments.add(employment);
        }
        
        // iterate over previous employers
        for (FNMResponse.SecondOrPreviousEmployers employer : tt.secondOrPreviousEmployers) {
            Employment__c employment = startEmployment(loan, clients, employer.ssn);
            if (employment.Client_id__c == null) {
                System.debug('No client found for employer: ' + employer);
                continue;
            }
            
          
            if(employer.currentEmployment) {
                //employment.SelfEmployment__c = booleanToYesNo(employer.selfEmployed);
                employment.EmployerName__c = employer.employerName;
                employment.PositionTitle__c = employer.position;
                employment.EmployerPhone__c = employer.businessPhone;
                employment.EmployerAddress__c = formatAddress(employer.employerAddress.streetAddress, employer.employerAddress.streetAddress2);
                employment.Zip__c = formatZip(employer.employerAddress.zipCode, employer.employerAddress.zipCodePlusFour);
                employment.State__c = STATES.get(employer.employerAddress.state);
                employment.City__c = employer.employerAddress.city;
                
                employment.is_Active__c = true;
                //employment.CurrentPosition__c = booleanToYesNo(employer.currentEmployment);
                //employment.StartDate__c = toDate(employer.fromDate);
                //employment.EndDate__c = toDate(employer.toDate);
                employment.Primary_Employment__c = false;
                
                employment.Income_Type__c = 'Employment Income';
                employment.IncomeValue__c = employer.monthlyIncome;   
                
                system.debug('About to insert new Secondary Employment object: ' + employment);
                
                if(employment.IncomeValue__c != 0 && (employment.Years__c != Null && employment.Years__c != 0)) {
                    employment.Is_Employment_Validated__c = true;
                }                
                //Code Modified by Dev4 for ORMSFDC-1601
                if(!employer.selfEmployed)
                {
                    employment.IncomeCategory__c='Standard';
                }
                //Code Ended by Dev4 for ORMSFDC-1601
                insert employment;
                employments.add(employment);
            }
        }
        
        system.debug('Created ' + employments.size() + ' new employments.');
        return employments;
    }
    
    // Builds new Asset object using loanId, clientId for the given SSN, loan account partner id, and loan contact individual id.
    private static Asset startAsset(Loan_New__c loan, List<Client__c> clients, String ssn) {
        Asset asset = new Asset();
        asset.RelatedLoan__c = loan.Id;
        asset.RelatedClient__c = findClient(clients, ssn);
        asset.AccountId = loan.Related_Partner__c;
        asset.ContactId = loan.Related_Individual__c;
        asset.isActive__c = true;
        return asset;
    }
    
    // Builds new Employment object using loanId and clientId for the given SSN.
    private static Employment__c startEmployment(Loan_New__c loan, List<Client__c> clients, String ssn) {
        Employment__c employment = new Employment__c();
        employment.RelatedLoan__c = loan.Id;
        employment.Client_id__c = findClient(clients, ssn);
        employment.is_Active__c = true;
        return employment;
    }
    
    // Builds new Liability object using loanId, clientId for the given SSN, loan account partner id, and loan contact individual id.
    private static Liability__c startLiability(Loan_New__c loan, List<Client__c> clients, String ssn) {
        Liability__c liability = new Liability__c();
        liability.RelatedLoan__c = loan.Id;
        liability.RelatedClient__c = findClient(clients, ssn);
        liability.isActive__c = true;
        return liability;
    }
    
    // find client id matching the given ssn
    private static id findClient(List<Client__c> clients, String ssn) {
        for (Client__c client : clients) {
            if (ssn == client.Social_Security_Number__c) {
                return client.Id;
            }
        }
        return null;
    }
    
    // find income matching the given income type
    private static Income_New__c findIncome(List<Income_New__c> incomes, String incomeType) {
        for (Income_New__c income : incomes) {
            if (incomeType == income.Income_Types__c) {
                return income;
            }
        }
        return null;
    }
    
    // get hazard insurance expense
    private static Decimal getHazardInsurance(List<FNMResponse.PresentOrProposedHousingExpense> expenses) {
        for (FNMResponse.PresentOrProposedHousingExpense expense : expenses) {
            if ('01' == expense.housingPaymentTypeCode && '1' == expense.presentProposedIndicator) {
                return expense.monthlyHousingExpense;
            }
        }
        return null;
    }
    
    private static Decimal getHOADues(List<FNMResponse.PresentOrProposedHousingExpense> expenses) {
        
        if(!expenses.isEmpty())
        {
            for (FNMResponse.PresentOrProposedHousingExpense expense : expenses) {
                if ('06' == expense.housingPaymentTypeCode) {
                    return expense.monthlyHousingExpense;
                }
            }
        }
        return null;
    }
    
    //Code Added by Dev4 for ORMSFDC-1471
    private static Decimal getCalculatedFee(decimal amount) {
        decimal resultLoan=0.0;
        if(amount<=200000)
        {
            decimal loanfee = amount * 0.02;
            if(loanfee > 6000){
                resultLoan=6000;
                
            }else if(loanfee <=2500 ){
                
                resultLoan= 2500;
            } else{   
                decimal result =Math.round(loanfee);
                resultLoan= result;
                
            }
            return resultLoan;
        }
        else
        {
            decimal initialAmount = 200000;
            decimal remaining = amount - initialAmount;            
            decimal loanfeeonInitial = initialAmount * 0.02;
            decimal loanfeeonRemaining = remaining * 0.01;
            decimal totalLoanFee1 = loanfeeonInitial + loanfeeonRemaining;
            decimal totalLoanFee = Math.round(totalLoanFee1);
            if(totalLoanFee <=6000 && totalLoanFee >2500){
                
                resultLoan=  totalLoanFee;
            }else if(totalLoanFee < 2500){
                
                if(amount !=0 ){
                    
                    resultLoan=  2500;
                }else{
                    
                    resultLoan=  0;
                    
                }
            }else{
                if(amount !=0 ){
                    
                    resultLoan=  6000;
                }else{
                    
                    resultLoan=  0;
                    
                }
                
            }
            return resultLoan;
            
        }
    }
    //Code Ended by Dev4 for ORMSFDC-1471
    
    // get estate taxes expense
    private static Decimal getRealEstateTaxes(List<FNMResponse.PresentOrProposedHousingExpense> expenses) {
        for (FNMResponse.PresentOrProposedHousingExpense expense : expenses) {
            if ('14' == expense.housingPaymentTypeCode && '1' == expense.presentProposedIndicator) {
                return expense.monthlyHousingExpense;
            }
        }
        return null;
    }
    
    // convert boolean to Yes/No string representation
    private static String booleanToYesNo(Boolean bool) {
        if (bool != null && bool) {
            return 'Yes';
        }
        return 'No';
    }
    
    // convert datetime object to date
    private static Date toDate(Datetime dt) {
        if (dt == null) return null;
        return Date.parse(dt.format('MM/dd/yyyy', 'UTC'));
    }
    
    // format zip code with optional plus 4 digits
    private static String formatZip(String first5, String plus4) {
        if (String.isNotBlank(plus4)) {
            return first5 + '-' + plus4;
        }
        return first5;
    }
    
    // format address line
    private static String formatAddress(String line1, String line2) {
        if (String.isNotBlank(line2)) {
            return line1 + ' ' + line2;
        }
        return line1;
    }
    
    // parse fist and last name from fullname string
    private static String[] firstAndLast(String fullname) {
        String[] parts = fullname.split('(\\s)+');
        String first = parts[0];
        String last = '';
        if (parts.size() > 1) {
            last = parts[parts.size() - 1];
        }
        return new String[] { first, last };
            }
    
    // make sure email is in correct format
    private static String cleanEmail(String email) {
        if (String.isNotBlank(email)) {
            if(Pattern.matches('[a-zA-Z0-9._-]+\\@[a-zA-Z]+\\.[a-zA-Z]{2,4}', email)) {
                return email;
            }
            throw new AuraHandledException('Email format was invalid: ' + email);
        }
        return null;
    }
    
    // compare two property address
    private static boolean isSameAddress(FNMResponse.PropertyAddress pa1, FNMResponse.PropertyAddress pa2) {
        boolean sameAddress1 = pa1.streetAddress == pa2.streetAddress;
        boolean sameAddress2 = pa1.streetAddress2 == pa2.streetAddress2;
        boolean sameCity = pa1.city == pa2.city;
        boolean sameState = pa1.state == pa2.state;
        boolean sameZip = pa1.zipCode == pa2.zipCode;
        return sameAddress1 && sameAddress2 && sameCity && sameState && sameZip;
    }
    
    // fannie mae -> loan mappings go below this line
    // ------------------------------------------------------------------------------------------------------ 
    
    private static final Map<Integer, String> ADDRESS_TYPES = new Map<Integer, String> {
        0 => 'Former Residence',
            1 => 'Present Address',
            2 => 'Mailing Address'
            };
                
                private static final Map<Integer, String> MARITAL_STATUSES = new Map<Integer, String> {
                    0 => 'Married',
                        1 => 'Separated',
                        2 => 'Unmarried'
                        };
                            
                            private static final Map<Integer, String> RESIDENCES = new Map<Integer, String> {
                                0 => 'Rent Free',
                                    1 => 'Rent',
                                    2 => 'Own'
                                    };
                                        
                                        private static final Map<String, String> RESIDENCE_TYPES = new Map<String, String> {
                                            '1' => 'Primary', // Primary Residence
                                                '2' => 'Investment', // Secondary Residence
                                                'D' => 'Investment' // Investment Property
                                                };
                                                    
                                                    private static final Map<String, String> PURPOSE_OF_LOAN = new Map<String, String> {
                                                        '04' => 'Home Improvement',
                                                            '05' => 'Other',
                                                            '13' => 'Home Improvement',
                                                            '15' => 'Other',
                                                            '16' => 'Other',
                                                            'Additional Income' => 'Additional Income',
                                                            'Payment of Taxes' => 'Payment of Taxes',
                                                            'Payment of Insurance' => 'Payment of Insurance',
                                                            'Leisure, Medical' => 'Leisure, Medical',
                                                            'Extinguish Forward Mortgage' => 'Extinguish Forward Mortgage'
                                                            };
                                                                
                                                                private static final Map<Integer, String> APPLICATION_TAKEN_BY = new Map<Integer, String> {
                                                                    0 => 'Face to Face',
                                                                        1 => 'By the applicant and submitted by fax or mail',
                                                                        2 => 'Telephone Interview',
                                                                        3 => 'By the applicant and submitted via email or the Internet'
                                                                        };
                                                                            
                                                                            private static final Map<String, String> ESTATE_HELD_IN = new Map<String, String> {
                                                                                '1' => 'Fee Simple',
                                                                                    '2' => 'Leasehold'
                                                                                    };
                                                                                        
                                                                                        private static final Map<Integer, String> EXPENSE_TYPE = new Map<Integer, String> {
                                                                                            0 => 'Alimony',
                                                                                                1 => 'Child Support',
                                                                                                2 => 'Separation Maintenance',
                                                                                                3 => 'Job related Expense',
                                                                                                4 => 'Other expense'
                                                                                                };
                                                                                                    
                                                                                                    private static final Map<Integer, String> LIABILITY_TYPE = new Map<Integer, String> {
                                                                                                        0 => 'Installment',
                                                                                                            1 => 'Open 30 day Charge Accounts',
                                                                                                            2 => 'Revolving',
                                                                                                            3 => 'Home Equity Line of Credit',
                                                                                                            4 => 'Mortgage Loans',
                                                                                                            5 => 'Lease Payments',
                                                                                                            6 => 'Collections/Judgements/Liens',
                                                                                                            7 => 'Taxes',
                                                                                                            8 => 'Other'
                                                                                                            // 'Mechanic Lien', 'Property Taxes'
                                                                                                            };
                                                                                                                
                                                                                                                private static final Map<String, String> CITIZENSHIP = new Map<String, String> {
                                                                                                                    '01' => 'Yes',
                                                                                                                        '03' => 'No', // PermanentResidentAlien
                                                                                                                        '05' => 'No' // NonPermanentResidentAlien
                                                                                                                        };
                                                                                                                            
                                                                                                                            private static final Map<String, String> ETHNICITY = new Map<String, String> {
                                                                                                                                //changes made by Dhiresh
                                                                                                                                '1' => 'Not Hispanic or Latino',
                                                                                                                                    '2' => 'Do Not Disclose',
                                                                                                                                    '3' => 'Mexican',
                                                                                                                                    '4' => 'Puerto Rican',
                                                                                                                                    '5' => 'Cuban',
                                                                                                                                    '6' => 'Other'
                                                                                                                                    };
                                                                                                                                        
                                                                                                                                        private static final Map<Integer, String> SEX = new Map<Integer, String> {
                                                                                                                                            // Changes made by Dhiresh
                                                                                                                                            0 => 'Female',
                                                                                                                                                1 => 'Male',
                                                                                                                                                2 => 'Client did not provide this information'
                                                                                                                                                
                                                                                                                                                };
                                                                                                                                                    
                                                                                                                                                    private static final Map<String, String> RACE = new Map<String, String> {
                                                                                                                                                        // Changes made by Dhiresh
                                                                                                                                                        '1' => 'American Indian or Alaska Native',
                                                                                                                                                            '2' => 'Black or African American',
                                                                                                                                                            '3' => 'White',
                                                                                                                                                            '4' => 'Asian Indian',
                                                                                                                                                            '5' => 'Chinese',
                                                                                                                                                            '6' => 'Filipino',
                                                                                                                                                            '7' => 'Japanese',
                                                                                                                                                            '8' => 'Korean',
                                                                                                                                                            '9' => 'Vietnamese',
                                                                                                                                                            '10' => 'Do Not Disclose',
                                                                                                                                                            '11' => 'Other Asian',
                                                                                                                                                            '12' => 'Guamanian or Chamorro',
                                                                                                                                                            '13' => 'Native Hawaiian',
                                                                                                                                                            '14' => 'Samoan',
                                                                                                                                                            '15' => 'Other Pacific Islander'
                                                                                                                                                            
                                                                                                                                                            };
                                                                                                                                                                
                                                                                                                                                                private static final Map<String, String> PROPERTY_TYPES = new Map<String, String> {
                                                                                                                                                                    '14' => 'Single Family',
                                                                                                                                                                        '04' => 'Condominium',
                                                                                                                                                                        '16' => 'Townhouse',
                                                                                                                                                                        '13' => 'Co-operative',
                                                                                                                                                                        '15' => 'Two-to-four unit property',
                                                                                                                                                                        '18' => 'Multifamily (more than 4 units)',
                                                                                                                                                                        '08' => 'Manufactured/Mobile Home',
                                                                                                                                                                        '02' => 'Commercial – Non-Residential',
                                                                                                                                                                        'F1' => 'Mixed Use – Residential',
                                                                                                                                                                        '05' => 'Farm',
                                                                                                                                                                        '03' => 'Home and Business Combined',
                                                                                                                                                                        '07' => 'Land'
                                                                                                                                                                        };
                                                                                                                                                                            
                                                                                                                                                                            private static final Map<String, String> ASSET_TYPE_CATEGORY = new Map<String, String> {
                                                                                                                                                                                '03' => 'Bank/Credit Union',
                                                                                                                                                                                    'F1' => 'Others',
                                                                                                                                                                                    'SG' => 'Bank/Credit Union',
                                                                                                                                                                                    'F2' => 'Others',
                                                                                                                                                                                    '01' => 'Bank/Credit Union',
                                                                                                                                                                                    'F3' => 'Bank/Credit Union',
                                                                                                                                                                                    'F4' => 'Stock & Bonds',
                                                                                                                                                                                    '05' => 'Stock & Bonds',
                                                                                                                                                                                    '06' => 'Stock & Bonds',
                                                                                                                                                                                    'F5' => 'Others',
                                                                                                                                                                                    'F7' => 'Others',
                                                                                                                                                                                    '08' => 'Retirement Fund',
                                                                                                                                                                                    'F8' => 'Business',
                                                                                                                                                                                    '11' => 'Bank/Credit Union',
                                                                                                                                                                                    'M1' => 'Others',
                                                                                                                                                                                    'OL' => 'Others',
                                                                                                                                                                                    'NE' => 'Others',
                                                                                                                                                                                    'COH' => 'Bank/Credit Union',
                                                                                                                                                                                    'GE' => 'Stock & Bonds'
                                                                                                                                                                                    };
                                                                                                                                                                                        
                                                                                                                                                                                        private static final Map<String, String> ASSET_TYPE = new Map<String, String> {
                                                                                                                                                                                            '03' => 'Checking Account',
                                                                                                                                                                                                'F1' => 'Cash Deposit on Sales Contract',
                                                                                                                                                                                                'SG' => 'Savings Account',
                                                                                                                                                                                                'F2' => 'Gifts Not Deposited',
                                                                                                                                                                                                '01' => 'Certificate of Deposit/Time Deposit',
                                                                                                                                                                                                'F3' => 'Money Market Fund',
                                                                                                                                                                                                'F4' => 'Mutual Fund',
                                                                                                                                                                                                '05' => 'Stock',
                                                                                                                                                                                                '06' => 'Bond',
                                                                                                                                                                                                'F5' => 'Secured Borrower Funds not Deposited',
                                                                                                                                                                                                'F7' => 'Bridge Loan Not Deposited',
                                                                                                                                                                                                '08' => 'Retirement Fund',
                                                                                                                                                                                                'F8' => 'Net Worth of Business Owned',
                                                                                                                                                                                                '11' => 'Trust Account',
                                                                                                                                                                                                //Code Modified by Dev4 for ORMSFDC-1542
                                                                                                                                                                                                //'M1' => 'Non-Liquid Assets',
                                                                                                                                                                                                //'OL' => 'Liquid Assets',
                                                                                                                                                                                                //'NE' => 'Non-Liquid Assets',
                                                                                                                                                                                                'M1' => 'Other Non-Liquid Asset',
                                                                                                                                                                                                'OL' => 'Other Liquid Asset',
                                                                                                                                                                                                'NE' => 'Net Equity',
                                                                                                                                                                                                //Code Ended by Dev4 for ORMSFDC-1542
                                                                                                                                                                                                'COH' => 'Cash on Hand',
                                                                                                                                                                                                'GE' => 'Gift of Equity'
                                                                                                                                                                                                };
                                                                                                                                                                                                    
                                                                                                                                                                                                    private static final Map<String, String> INCOME_TYPE_TO_FIELD_MAPPING = new Map<String, String> {
                                                                                                                                                                                                        'F1' => 'Millitary Base Pay',
                                                                                                                                                                                                            '07' => 'Millitary Rations Allowance',
                                                                                                                                                                                                            'F2' => 'Millitary Flight Pay',
                                                                                                                                                                                                            'F3' => 'Millitary Hazard Pay',
                                                                                                                                                                                                            '02' => 'Millitary Clothes Allowance',
                                                                                                                                                                                                            '04' => 'Millitary Quarters Allowance',
                                                                                                                                                                                                            '03' => 'Millitary Prop Pay',
                                                                                                                                                                                                            'F4' => 'Millitary Overseas Pay',
                                                                                                                                                                                                            'F5' => 'Millitary Combat Pay',
                                                                                                                                                                                                            'F6' => 'Millitary Variable Housing Allowance',
                                                                                                                                                                                                            'F7' => 'Alimony/Child Support Income',
                                                                                                                                                                                                            'F8' => 'Notes Receivable/Installment',
                                                                                                                                                                                                            '41' => 'Pension/Retirement Income',
                                                                                                                                                                                                            '42' => 'Social Security Income',
                                                                                                                                                                                                            '30' => 'Mortgage Differential',
                                                                                                                                                                                                            'F9' => 'Trust',
                                                                                                                                                                                                            'M1' => 'Unemployment/Public Assistance Income',
                                                                                                                                                                                                            'M2' => 'Automobile Expense Amount',
                                                                                                                                                                                                            'M3' => 'Foster Care',
                                                                                                                                                                                                            'M4' => 'VA Benefits (Non Educational)',
                                                                                                                                                                                                            '45' => 'Other Type Of Income',
                                                                                                                                                                                                            '20' => 'Employment Income',
                                                                                                                                                                                                            '17' => 'Dividend/Interest Income',
                                                                                                                                                                                                            '33' => 'Net Rental Income',
                                                                                                                                                                                                            'BI' => 'Boarder Income',
                                                                                                                                                                                                            'MC' => 'Mortgage Credit Certificate',
                                                                                                                                                                                                            'AU' => 'Accessory Unit Income',
                                                                                                                                                                                                            'NB' => 'Non-Borrower Household Income',
                                                                                                                                                                                                            'TC' => 'Non-Borrower Household Income',
                                                                                                                                                                                                            'S8' => 'Housing Choice Voucher (Sec 8)',
                                                                                                                                                                                                            'CG' => 'Capital Gains',
                                                                                                                                                                                                            'EA' => 'Employment Related Assets',
                                                                                                                                                                                                            'FI' => 'Foreign Income',
                                                                                                                                                                                                            'RP' => 'Royalty Payment',
                                                                                                                                                                                                            'SE' => 'Seasonal Income',
                                                                                                                                                                                                            'TI' => 'Tip Income',
                                                                                                                                                                                                            'SI' => 'Subject Property Net Cash Flow',
                                                                                                                                                                                                            '09' => 'Overtime',
                                                                                                                                                                                                            '08' => 'Bonuses',
                                                                                                                                                                                                            '10' => 'Commissions'
                                                                                                                                                                                                            };
                                                                                                                                                                                                                
                                                                                                                                                                                                                private static final Map<Integer, String> STATES = new Map<Integer, String> {
                                                                                                                                                                                                                    0 => 'Alabama',
                                                                                                                                                                                                                        1 => 'Alaska',
                                                                                                                                                                                                                        2 => 'Arizona',
                                                                                                                                                                                                                        3 => 'Arkansas',
                                                                                                                                                                                                                        4 => 'California',
                                                                                                                                                                                                                        5 => 'Colorado',
                                                                                                                                                                                                                        6 => 'Connecticut',
                                                                                                                                                                                                                        7 => 'Delaware',
                                                                                                                                                                                                                        8 => 'District of Columbia',
                                                                                                                                                                                                                        9 => 'Florida',
                                                                                                                                                                                                                        10 => 'Georgia',
                                                                                                                                                                                                                        11 => 'Hawaii',
                                                                                                                                                                                                                        12 => 'Idaho',
                                                                                                                                                                                                                        13 => 'Illinois',
                                                                                                                                                                                                                        14 => 'Indiana',
                                                                                                                                                                                                                        15 => 'Iowa',
                                                                                                                                                                                                                        16 => 'Kansas',
                                                                                                                                                                                                                        17 => 'Kentucky',
                                                                                                                                                                                                                        18 => 'Louisiana',
                                                                                                                                                                                                                        19 => 'Maine',
                                                                                                                                                                                                                        20 => 'Maryland',
                                                                                                                                                                                                                        21 => 'Massachusetts',
                                                                                                                                                                                                                        22 => 'Michigan',
                                                                                                                                                                                                                        23 => 'Minnesota',
                                                                                                                                                                                                                        24 => 'Mississippi',
                                                                                                                                                                                                                        25 => 'Missouri',
                                                                                                                                                                                                                        26 => 'Montana',
                                                                                                                                                                                                                        27 => 'Nebraska',
                                                                                                                                                                                                                        28 => 'Nevada',
                                                                                                                                                                                                                        29 => 'New Hampshire',
                                                                                                                                                                                                                        30 => 'New Jersey',
                                                                                                                                                                                                                        31 => 'New Mexico',
                                                                                                                                                                                                                        32 => 'New York',
                                                                                                                                                                                                                        33 => 'North Carolina',
                                                                                                                                                                                                                        34 => 'North Dakota',
                                                                                                                                                                                                                        35 => 'Ohio',
                                                                                                                                                                                                                        36 => 'Oklahoma',
                                                                                                                                                                                                                        37 => 'Oregon',
                                                                                                                                                                                                                        38 => 'Pennsylvania',
                                                                                                                                                                                                                        39 => 'Rhode Island',
                                                                                                                                                                                                                        40 => 'South Carolina',
                                                                                                                                                                                                                        41 => 'South Dakota',
                                                                                                                                                                                                                        42 => 'Tennessee',
                                                                                                                                                                                                                        43 => 'Texas',
                                                                                                                                                                                                                        44 => 'Utah',
                                                                                                                                                                                                                        45 => 'Vermont',
                                                                                                                                                                                                                        46 => 'Virginia',
                                                                                                                                                                                                                        47 => 'Washington',
                                                                                                                                                                                                                        48 => 'West Virginia',
                                                                                                                                                                                                                        49 => 'Wisconsin',
                                                                                                                                                                                                                        50 => 'Wyoming'
                                                                                                                                                                                                                        };
                                                                                                                                                                                                                            private static final Map<Integer, String> ISPROPERTY_OCCUPY = new Map<Integer, String> {
                                                                                                                                                                                                                                
                                                                                                                                                                                                                                0 => 'Yes',
                                                                                                                                                                                                                                    1 => 'No',
                                                                                                                                                                                                                                    2=>'No'
                                                                                                                                                                                                                                    };
                                                                                                                                                                                                                                        }