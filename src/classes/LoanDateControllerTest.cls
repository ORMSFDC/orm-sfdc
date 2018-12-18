@isTest
public with sharing class LoanDateControllerTest {
    @isTest static void SaveLoanMethodTest(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Account Executive/PCS'];
        UserRole UR=[Select Id from UserRole where Name='Partner Care Specialist'];        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User user1 = new User(Alias = uniqueName.substring(18, 23),  email = uniqueName + '@test1' + orgId + '.org',
                              Username = uniqueName + '@test1' + orgId + '.org', 
                              EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id,userroleid=UR.ID, 
                              TimeZoneSidKey='America/Los_Angeles');
        insert user1;  
        system.runAs(user1)
        {
            Account portalAccount = new Account(
                Name='portalAccount',
                Cell__c='1236547410',                
                Assigned_PCS__c=user1.Id,  
                Main_Phone__c='5414147852',
                Company_NMLS_ID__c = '1234',
                Partner_Lead_Status__c='New');
            insert portalAccount;
            
            Contact contact = new Contact(
                LastName='LastName', 
                Title__c='Processor ', 
                Cell__c='1234569874', 
                Office_Phone__c='1234569874', 
                Individual_Lead_source__c='Other', 
                Email = 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;     
            
            Client__c clientInfo = new Client__c();
            clientInfo.Name = 'John';
            clientInfo.Last_Name__c = 'Smith';
            clientInfo.City__c = 'Black Water';
            clientInfo.Zip__c = '48075';
            clientInfo.DOB__c = Date.today();
            insert clientInfo;
            
            clientInfo.put('Name', 'JohnJohn');
            
            system.debug('client info ID = ' + clientInfo.Id);
            
            Loan_New__c objLoan = new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);        
            Insert objLoan;            
        }
    }
    
    @isTest static void getFNMDataTest() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Account Executive/PCS'];
        UserRole UR=[Select Id from UserRole where Name='Partner Care Specialist'];        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User user1 = new User(Alias = uniqueName.substring(18, 23),  email = uniqueName + '@test1' + orgId + '.org',
                              Username = uniqueName + '@test1' + orgId + '.org', 
                              EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id,userroleid=UR.ID, 
                              TimeZoneSidKey='America/Los_Angeles');
        insert user1;  
        system.runAs(user1)
        {          
            Account portalAccount = new Account(
                Name='portalAccount',
                Cell__c='1236547410',
                Assigned_PCS__c=user1.Id,
                Main_Phone__c='5414147852',
                Company_NMLS_ID__c = '1234',
                Partner_Lead_Status__c='New');
            insert portalAccount;
            Contact contact = new Contact(
                LastName='LastName', 
                Title__c='Processor ', 
                Cell__c='1234569874', 
                Office_Phone__c='1234569874', 
                Individual_Lead_source__c='Other', 
                Email = 'Sam@gmail.com',
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;  
            
            Loan_New__c LoanInsert = new Loan_New__c(
                IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);  
            
            Insert LoanInsert;
            string LoanId = LoanInsert.Id;
            
            Client__c ClientInsert = new Client__c(First_Name__c = 'Dhiresh', Last_Name__c  = 'Khare',City__c='Delhi', Zip__c = '12345',
                                                   LoanId__c =LoanInsert.Id);
            Insert ClientInsert;
            string ClientId = ClientInsert.Id;
            
            Blob FileData = Blob.valueOf('');
            Attachment ObjAttachment = new Attachment();
            objAttachment.Name='Dtest';
            objAttachment.Body = FileData;
            objAttachment.ParentId = LoanInsert.Id;
            objAttachment.contentType = 'Application/PDF';
            insert objAttachment;
            string Base64Data = 'test Base64Data';
            string applicationDate = Date.today().year() + '-' + Date.today().month() + '-' + Date.today().day();
            Test.startTest();
            String json = '{"tenOhThree":{"envelopeHeader":{"institutionID":"","institutionName":"","date":null,"envelopeControlNumber":"0"},"transactionHeader":{"transactionID":"T100099-002","transactionControlNumber":"1"},"transactionProcessingInfo":{"versionID":"1.00","identifierTypeCode":"01","identifier":"","importAction":1},"fileIdentification":[{"fileType":"1","fileVersionID":"3.20","exportVersionIndicator":"W"},{"fileType":"70","fileVersionID":"3.20","exportVersionIndicator":" "},{"fileType":"11","fileVersionID":"3.20","exportVersionIndicator":" "},{"fileType":"20","fileVersionID":"3.20","exportVersionIndicator":" "}],"topOfForm":{"incomeOrAssetsOfNonBorrower":true,"incomeOrAssetsOfSpouse":false},"mortgageTypeAndTerms":{"mortgageAppliedFor":"02","mortgageAppliedForOther":"","agencyCaseNumber":"","caseNumber":"","loanAmount":190000,"interestRate":3.25,"numOfMonths":360,"amortizationType":"05","amortizationTypeOther":"","armDescription":""},"propertyInformation":{"propertyAddress":{"streetAddress":"22041 Mimosa Ln","streetAddress2":"Appt 5","city":"Moreno Valley","zipCode":"32553","zipCodePlusFour":"1234","state":4,"country":null},"numberOfUnits":1,"legalDescriptionPropertyCode":"F1","legalDescriptionPropertyText":"See preliminary title.","yearBuilt":2003},"propertyAddressInformation":null,"loanPurpose":{"purposeOfLoan":"05","purposeOfLoanOther":"","propertyWillBe":"1","mannerTitleHeld":"To be determined in escrow","estateHeldIn":"1","leaseExpirationDate":null},"titleHolders":[{"titleHolderName":"Daniel D Tenorio"},{"titleHolderName":"Graciela Tenorio"}],"constructionOrRefinanceData":{"yearAcquired":2013,"originalCost":190260,"existingLiensAmount":176232,"presentValueOfLot":null,"costOfImprovements":null,"purposeOfRefinance":"11","describeImprovements":"","describeImprovementsStatus":2,"describeImprovementsCost":null},"downPayments":[],"applicantData":[{"applicantType":0,"ssn":"111222954","firstName":"Daniel","middleName":"D","lastName":"Tenorio","generation":"","homePhone":"9512048761","age":67,"yearsOfSchool":null,"maritalStatus":0,"dependents":2,"completedJointly":true,"crossReferenceNumber":"222111157","dateOfBirth":null,"emailAddress":"leo@email.com"},{"applicantType":1,"ssn":"222111157","firstName":"Graciela","middleName":"","lastName":"Tenorio","generation":"","homePhone":"9512048761","age":66,"yearsOfSchool":null,"maritalStatus":0,"dependents":null,"completedJointly":true,"crossReferenceNumber":"111222954","dateOfBirth":"1949-12-26T00:00:00","emailAddress":""}],"dependentsAge":[],"applicantsAddress":[{"ssn":"111222954","addressType":1,"residenceAddress":{"streetAddress":"22041 Mimosa Ln","streetAddress2":null,"city":"Moreno Valley","zipCode":"92553","zipCodePlusFour":"","state":4,"country":""},"residenceOwnership":2,"yearsAtResidence":7,"monthsAtResidence":0},{"ssn":"111222954","addressType":2,"residenceAddress":{"streetAddress":"300 S Garden St","streetAddress2":null,"city":"Lake City","zipCode":"55041","zipCodePlusFour":"","state":23,"country":""},"residenceOwnership":2,"yearsAtResidence":7,"monthsAtResidence":0},{"ssn":"222111157","addressType":1,"residenceAddress":{"streetAddress":"22041 Mimosa Ln","streetAddress2":null,"city":"Moreno Valley","zipCode":"92553","zipCodePlusFour":"","state":4,"country":""},"residenceOwnership":2,"yearsAtResidence":7,"monthsAtResidence":0}],"primaryCurrentEmployers":[{"ssn":"222111157","employerName":"Riverside Unified School Distc.","employerAddress":{"streetAddress":"3380 14th St","streetAddress2":null,"city":"Riverside","zipCode":"92501","zipCodePlusFour":"","state":4,"country":null},"selfEmployed":false,"yearsOnJob":25,"monthsOnJob":null,"yearsInLineOfWork":25,"position":"Noon Supervisor","businessPhone":"9517887135"},{"ssn":"9879879988","employerName":"Unmatched Employment","employerAddress":{"streetAddress":"3380 14th St","streetAddress2":null,"city":"Riverside","zipCode":"92501","zipCodePlusFour":"","state":4,"country":null},"selfEmployed":false,"yearsOnJob":25,"monthsOnJob":null,"yearsInLineOfWork":25,"position":"Noon Supervisor","businessPhone":"9517887135"}],"secondOrPreviousEmployers":[{"ssn":"111222954","employerName":"Dimond, Geyer and Co","employerAddress":{"streetAddress":"375 Fulton St","streetAddress2":null,"city":"Farmingdale","zipCode":"11735","zipCodePlusFour":"","state":32,"country":null},"selfEmployed":false,"currentEmployment":false,"fromDate":"1987-01-01T00:00:00","toDate":"2014-01-20T00:00:00","monthlyIncome":8300,"position":"Partner","businessPhone":"5162496940"},{"ssn":"999887777","employerName":"Dimond, Geyer and Co","employerAddress":{"streetAddress":"375 Fulton St","streetAddress2":null,"city":"Farmingdale","zipCode":"11735","zipCodePlusFour":"","state":32,"country":null},"selfEmployed":false,"currentEmployment":false,"fromDate":"1987-01-01T00:00:00","toDate":"2014-01-20T00:00:00","monthlyIncome":8300,"position":"Partner","businessPhone":"5162496940"}],"presentOrProposedHousingExpense":[{"ssn":"111222954","presentProposedIndicator":"1","housingPaymentTypeCode":"01","monthlyHousingExpense":62},{"ssn":"111222954","presentProposedIndicator":"1","housingPaymentTypeCode":"14","monthlyHousingExpense":325},{"ssn":"111222954","presentProposedIndicator":"2","housingPaymentTypeCode":"26","monthlyHousingExpense":854.18},{"ssn":"111222954","presentProposedIndicator":"2","housingPaymentTypeCode":"01","monthlyHousingExpense":62},{"ssn":"111222954","presentProposedIndicator":"2","housingPaymentTypeCode":"14","monthlyHousingExpense":325}],"income":[{"ssn":"111222954","typeOfIncomeCode":"41","monthlyIncomeAmount":2800},{"ssn":"111222954","typeOfIncomeCode":"42","monthlyIncomeAmount":1575},{"ssn":"222111157","typeOfIncomeCode":"42","monthlyIncomeAmount":680},{"ssn":"222111157","typeOfIncomeCode":"45","monthlyIncomeAmount":680}],"lifeInsurance":[{"ssn":"111222954","accountNumber":"789456","lifeInsuranceCashOrMarketValue":100000.0,"lifeInsuranceFaceAmount":200000.0},{"ssn":"999887777","accountNumber":"789456","lifeInsuranceCashOrMarketValue":100000.0,"lifeInsuranceFaceAmount":200000.0}],"assets":[{"ssn":"111222954","assetType":"03","depositoryName":"Schoolfirst CU","depositoryAddress":{"streetAddress":"","streetAddress2":null,"city":"","zipCode":"","zipCodePlusFour":"","state":0,"country":null},"accountNumber":"123","cashOrMarketValue":250,"numberOfStocksOrBondShares":null,"assetDescription":""},{"ssn":"111222954","assetType":"03","depositoryName":"Altura CU","depositoryAddress":{"streetAddress":"","streetAddress2":null,"city":"","zipCode":"","zipCodePlusFour":"","state":0,"country":null},"accountNumber":"123","cashOrMarketValue":3000,"numberOfStocksOrBondShares":null,"assetDescription":""},{"ssn":"111222954","assetType":"08","depositoryName":"","depositoryAddress":{"streetAddress":"","streetAddress2":null,"city":"","zipCode":"","zipCodePlusFour":"","state":0,"country":null},"accountNumber":"","cashOrMarketValue":78000,"numberOfStocksOrBondShares":null,"assetDescription":""},{"ssn":"111222954","assetType":"F4","depositoryName":"Awesome Mutual Fund Company","depositoryAddress":{"streetAddress":"","streetAddress2":null,"city":"","zipCode":"","zipCodePlusFour":"","state":0,"country":null},"accountNumber":"","cashOrMarketValue":120000,"numberOfStocksOrBondShares":null,"assetDescription":""},{"ssn":"111222954","assetType":"F8","depositoryName":"Lawn Business Company Name","depositoryAddress":{"streetAddress":"","streetAddress2":null,"city":"","zipCode":"","zipCodePlusFour":"","state":0,"country":null},"accountNumber":"","cashOrMarketValue":600000,"numberOfStocksOrBondShares":null,"assetDescription":""},{"ssn":"111222954","assetType":"NE","depositoryName":"Other Asset","depositoryAddress":{"streetAddress":"","streetAddress2":null,"city":"","zipCode":"","zipCodePlusFour":"","state":0,"country":null},"accountNumber":"","cashOrMarketValue":10000,"numberOfStocksOrBondShares":null,"assetDescription":""},{"ssn":"999887777","assetType":"03","depositoryName":"Altura CU","depositoryAddress":{"streetAddress":"","streetAddress2":null,"city":"","zipCode":"","zipCodePlusFour":"","state":0,"country":null},"accountNumber":"123","cashOrMarketValue":3000,"numberOfStocksOrBondShares":null,"assetDescription":""}],"automobiles":[],"alimonyOrChildSupportOrJobRelatedExpenses":[{"ssn":"111222954","expenseTypeCode":1,"monthlyPaymentAmount":55,"monthsLeftToPay":null,"alimonyOwedTo":"to the ex"},{"ssn":"111222954","expenseTypeCode":3,"monthlyPaymentAmount":65,"monthsLeftToPay":null},{"ssn":"999887777","expenseTypeCode":3,"monthlyPaymentAmount":65,"monthsLeftToPay":null}],"realEstateOwned":[{"ssn":"111222954","propertyAddress":{"streetAddress":"22041 Mimosa Ln","streetAddress2":"Appt 5","city":"Moreno Valley","zipCode":"32553","zipCodePlusFour":"1234","state":4,"country":null},"propertyDisposition":1,"propertyType":"14","presentMarketValue":300000,"amountOfMortgagesAndLiens":176232,"grossRentalIncome":null,"mortgagePayments":854,"insuranceMaintenanceTaxesAndMisc":608,"netRentalIncome":null,"isCurrentResidence":true,"isSubjectProperty":true,"reoAssetID":1},{"ssn":"111222954","propertyAddress":{"streetAddress":"3470 Franklin Ave","streetAddress2":null,"city":"Riverside","zipCode":"92507","zipCodePlusFour":"","state":4,"country":null},"propertyDisposition":1,"propertyType":"14","presentMarketValue":240000,"amountOfMortgagesAndLiens":186913,"grossRentalIncome":null,"mortgagePayments":1087,"insuranceMaintenanceTaxesAndMisc":null,"netRentalIncome":null,"isCurrentResidence":false,"isSubjectProperty":false,"reoAssetID":2},{"ssn":"999887777","propertyAddress":{"streetAddress":"22041 Mimosa Ln","streetAddress2":null,"city":"Moreno Valley","zipCode":"32553","zipCodePlusFour":"","state":4,"country":null},"propertyDisposition":1,"propertyType":"14","presentMarketValue":300000,"amountOfMortgagesAndLiens":176232,"grossRentalIncome":null,"mortgagePayments":854,"insuranceMaintenanceTaxesAndMisc":608,"netRentalIncome":null,"isCurrentResidence":true,"isSubjectProperty":true,"reoAssetID":1}],"aliases":[],"liabilities":[{"ssn":"111222954","liabilityType":4,"creditorName":"QUICKENLOANS","creditorAddress":{"streetAddress":"1050 WOODWARD AVENUE","streetAddress2":null,"city":"DETROIT","zipCode":"48226","zipCodePlusFour":"","state":22,"country":null},"accountNumber":"8673316102600","monthlyPaymentAmount":1087,"monthsLeftToPay":null,"unpaidBalance":186913,"liabilityWillBePaidByClosing":false,"reoAssetID":null,"isResubordinated":false,"isOmitted":false,"isSubjectProperty":null,"isRentalProperty":null},{"ssn":"111222954","liabilityType":4,"creditorName":"QUICKENLOANS","creditorAddress":{"streetAddress":"1050 WOODWARD AVENUE","streetAddress2":null,"city":"DETROIT","zipCode":"48226","zipCodePlusFour":"","state":22,"country":null},"accountNumber":"8673316101866","monthlyPaymentAmount":1462,"monthsLeftToPay":null,"unpaidBalance":176232,"liabilityWillBePaidByClosing":false,"reoAssetID":null,"isResubordinated":false,"isOmitted":false,"isSubjectProperty":null,"isRentalProperty":null},{"ssn":"111222954","liabilityType":0,"creditorName":"AM HONDA FIN","creditorAddress":{"streetAddress":"10801 WALKER ST STE 140","streetAddress2":null,"city":"CYPRESS","zipCode":"90630","zipCodePlusFour":"","state":4,"country":null},"accountNumber":"191142170","monthlyPaymentAmount":549,"monthsLeftToPay":null,"unpaidBalance":29381,"liabilityWillBePaidByClosing":false,"reoAssetID":null,"isResubordinated":false,"isOmitted":false,"isSubjectProperty":null,"isRentalProperty":null},{"ssn":"111222954","liabilityType":0,"creditorName":"SCHOOLSFIRST","creditorAddress":{"streetAddress":"2115 N BROADWAY","streetAddress2":null,"city":"SANTA ANA","zipCode":"92711","zipCodePlusFour":"","state":4,"country":null},"accountNumber":"10116700800","monthlyPaymentAmount":191,"monthsLeftToPay":null,"unpaidBalance":9263,"liabilityWillBePaidByClosing":false,"reoAssetID":null,"isResubordinated":false,"isOmitted":false,"isSubjectProperty":null,"isRentalProperty":null},{"ssn":"111222954","liabilityType":2,"creditorName":"SCHOOLSFIRST","creditorAddress":{"streetAddress":"PO BOX 11547","streetAddress2":null,"city":"SANTA ANA","zipCode":"92711","zipCodePlusFour":"","state":4,"country":null},"accountNumber":"524860XXXXXX9615","monthlyPaymentAmount":89,"monthsLeftToPay":null,"unpaidBalance":4422,"liabilityWillBePaidByClosing":false,"reoAssetID":null,"isResubordinated":false,"isOmitted":false,"isSubjectProperty":null,"isRentalProperty":null},{"ssn":"111222954","liabilityType":0,"creditorName":"SCHOOLSFIRST","creditorAddress":{"streetAddress":"2115 N BROADWAY","streetAddress2":null,"city":"SANTA ANA","zipCode":"92711","zipCodePlusFour":"","state":4,"country":null},"accountNumber":"7777050800","monthlyPaymentAmount":142,"monthsLeftToPay":null,"unpaidBalance":2792,"liabilityWillBePaidByClosing":false,"reoAssetID":null,"isResubordinated":false,"isOmitted":false,"isSubjectProperty":null,"isRentalProperty":null},{"ssn":"111222954","liabilityType":2,"creditorName":"SYNCB/P66","creditorAddress":{"streetAddress":"P.O BOX 965004","streetAddress2":null,"city":"ORLANDO","zipCode":"32896","zipCodePlusFour":"","state":9,"country":null},"accountNumber":"7076222201908229","monthlyPaymentAmount":32,"monthsLeftToPay":null,"unpaidBalance":1038,"liabilityWillBePaidByClosing":false,"reoAssetID":null,"isResubordinated":false,"isOmitted":false,"isSubjectProperty":null,"isRentalProperty":null},{"ssn":"111222954","liabilityType":2,"creditorName":"CAPITAL ONE","creditorAddress":{"streetAddress":"15000 CAPITAL ONE DR","streetAddress2":null,"city":"RICHMOND","zipCode":"23238","zipCodePlusFour":"","state":46,"country":null},"accountNumber":"517805XXXXXX9959","monthlyPaymentAmount":25,"monthsLeftToPay":null,"unpaidBalance":55,"liabilityWillBePaidByClosing":false,"reoAssetID":null,"isResubordinated":false,"isOmitted":false,"isSubjectProperty":null,"isRentalProperty":null},{"ssn":"999887777","liabilityType":4,"creditorName":"QUICKENLOANS","creditorAddress":{"streetAddress":"1050 WOODWARD AVENUE","streetAddress2":null,"city":"DETROIT","zipCode":"48226","zipCodePlusFour":"","state":22,"country":null},"accountNumber":"8673316102600","monthlyPaymentAmount":1087,"monthsLeftToPay":null,"unpaidBalance":186913,"liabilityWillBePaidByClosing":false,"reoAssetID":null,"isResubordinated":false,"isOmitted":false,"isSubjectProperty":null,"isRentalProperty":null}],"undrawnHELOCAndIPCs":[],"detailsOfTransaction":{"purchasePrice":null,"alterationsImprovementsRepairsCost":null,"landCost":null,"refinanceCost":null,"estimatedPrepaidItemsAmount":null,"estimatedClosingCosts":2500,"mortgageInsuranceFundingFee":500,"discountAmount":null,"subordinateFinancingAmount":null,"applicantsClosingCostsPaidBySeller":null,"mortgageInsuranceFundingFeeFinanced":6270},"otherCredits":[],"declarations":[{"ssn":"111222954","outstandingJudgments":false,"declaredBankruptcy":false,"forclosedOrDeedInLieu":false,"partyToLawsuit":true,"obligatedOnLoanForeclosed":false,"delinquencyOrDefault":false,"alimonyOrChildSupport":false,"partOfDownPaymentBorrowed":false,"coMakerOrEndorserOnNote":false,"citizenShip":"01","doYouIntendToOccupy":0,"haveYouHadAnOwnershipInterest":0,"whatTypeOfProperty":"1","howDoYouHoldTitle":"01"},{"ssn":"222111157","outstandingJudgments":null,"declaredBankruptcy":null,"forclosedOrDeedInLieu":null,"partyToLawsuit":null,"obligatedOnLoanForeclosed":null,"delinquencyOrDefault":null,"alimonyOrChildSupport":null,"partOfDownPaymentBorrowed":null,"coMakerOrEndorserOnNote":null,"citizenShip":"01","doYouIntendToOccupy":2,"haveYouHadAnOwnershipInterest":2,"whatTypeOfProperty":"","howDoYouHoldTitle":""}],"declarationExplanations":[],"acknowledgementAndAgreement":[{"ssn":"111222954","signatureDate":null},{"ssn":"222111157","signatureDate":null}],"governmentMonitoringInfo":[{"ssn":"111222954","clientWillNotFurnishedGovtMonitoring":false,"ethnicity":"1","sex":1},{"ssn":"222111157","clientWillNotFurnishedGovtMonitoring":false,"ethnicity":"1","sex":0}],"loanOriginator":{"applicationTakenBy":2,"loanOriginatorsName":"Michael Foster","interviewDate":"2016-10-04T00:00:00","loanOriginatorsPhoneNumber":"3133738064","loanOriginationCompanyName":"One Reverse Mortgage, LLC","loanOriginatorsAddress":{"streetAddress":"644 Woodward Ave.","streetAddress2":"","city":"Detroit","zipCode":"48226","zipCodePlusFour":"","state":22,"country":null}},"races":[{"ssn":"111222954","race":"5"},{"ssn":"111222954","race":"2"},{"ssn":"222111157","race":"5"}],"fannieMaeTransmittalData":{"sellerProvidedBelowMarketFunding":null,"ownerOfExistingMortgage":"F1","propertyAppraisedValue":300000,"buydownRate":null,"appraisedValueIndicator":"01","appraisalFieldworkOrdered":"","appraiserName":"","appraiserCompany":"","appraiserLicenseNumber":"","appraiserLicenseStateCode":""},"additionalDataSegments":[{"additionalDataSegmentType":0,"additionalDataSegmentValue":"276820"},{"additionalDataSegmentType":1,"additionalDataSegmentValue":"2052"},{"additionalDataSegmentType":2,"additionalDataSegmentValue":""},{"additionalDataSegmentType":0,"additionalDataSegmentValue":""}],"score":[],"loanCharacteristics":{"negativeAmortizationLimitPercent":null,"isBalloonRequired":false,"hasHomebuyerEducationCompletion":null,"maximumLifetimeRateIncrease":null,"paymentAdjustmentLifePercentCap":null,"paymentAdjustmentLifeAmountCap":null,"willEscrowBeWaived":false,"scheduledClosingDate":null,"scheduledFirstPaymentDate":null,"miCoveragePercent":null,"aprSpread":"","hoepa":false,"isPreApproved":false,"lienType":"1","loanDocumentationType":null,"subjectPropertyType":"01","projectClassification":"","miInsurer":""},"productIdentification":{"productDescription":"","productCode":"","productPlanNumber":""},"productCharacteristics":{"mortgageTerm":"360","assumableLoanIndicator":null,"paymentFrequencyCode":"","prepaymentPenaltyIndicator":null,"prepaymentRestrictedIndicator":null,"repaymentTypeCode":null},"arm":null,"paymentAdjustment":[],"rateAdjustment":[],"buydownData":null,"casefileIdentification":{"filler":""},"lenderData":{"fhaLenderIdentifier":"71970-00003","fhaSponsorIdentifier":"","sponsoredOriginatorEIN":"","filler":""},"fhaAndVALoanData":{"energyEfficientNewHome":null,"mortgageCreditCertificate":null,"sellerConcessions":null,"borrowerTotalClosingCostsFees":null,"borrowerTotalClosingCostsPoints":null,"sellerTotalClosingCostsFees":null,"sellerTotalClosingCostsPoints":null,"otherTotalClosingCostsFees":null,"otherTotalClosingCostsPoints":null,"typeOfRefinance":"","propertyOfCounty":""},"fhaLoanOnlyData":null,"vaLoanOnlyData":{"coBorrowerMarriedToPrimaryBorrower":true,"entitlementAmount":null,"monthlyMaintenance":null,"monthlyUtilities":null,"fundingFeePercent":""},"vaLoanOnlyExtraData":[{"ssn":"111222954","totalTax":null,"stateTax":null,"localIncomeTax":null,"socialSecurityTax":null,"totalNonTaxableIncomePrimary":null,"totalNonTaxableIncomeOther":null,"totalTaxableIncomePrimary":null,"totalTaxableIncomeOther":null},{"ssn":"222111157","totalTax":null,"stateTax":null,"localIncomeTax":null,"socialSecurityTax":null,"totalNonTaxableIncomePrimary":null,"totalNonTaxableIncomeOther":null,"totalTaxableIncomePrimary":null,"totalTaxableIncomeOther":null}],"creditData":[{"ssn":"111222954","caivrNumber":"","borrowerCreditRating":"","bankruptcyWithinLastThreeYears":"","forclosure":"","firstTimeHomebuyerCounsel":""},{"ssn":"222111157","caivrNumber":"","borrowerCreditRating":"","bankruptcyWithinLastThreeYears":"","forclosure":"","firstTimeHomebuyerCounsel":""}],"communityLendingLoanData":null,"transactionTrailer":{"transactionControlNumber":"1"},"envelopeTrailer":{"envelopeControlNumber":"0"}},"warnings":[],"errors":[],"fieldList":[],"wasInputSorted":false,"wasSuccessful":true,"applicationId":null}';
            Test.setMock(HttpCalloutMock.class, new FNMMockHttpResponse(json));
            try{
            LoandateController.getFNMData(objAttachment.Body, objAttachment.Name, Base64Data, objAttachment.contentType, applicationDate,'ARM','FHA Traditional HECM');
            }catch(exception ex){
                system.debug('exception'+ex);
            }
                Test.stopTest();
            
        }
    }
    
    @isTest static void saveTheFileTest() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Account Executive/PCS'];
        UserRole UR=[Select Id from UserRole where Name='Partner Care Specialist'];        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User user1 = new User(Alias = uniqueName.substring(18, 23),  email = uniqueName + '@test1' + orgId + '.org',
                              Username = uniqueName + '@test1' + orgId + '.org', 
                              EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id,userroleid=UR.ID, 
                              TimeZoneSidKey='America/Los_Angeles');
        insert user1;            
        system.runAs(user1)
        {
            Account portalAccount = new Account(
                Name='portalAccount',
                Cell__c='1236547410',
                Assigned_PCS__c=user1.Id,
                Main_Phone__c='5414147852',
                Company_NMLS_ID__c = '1234',
                Partner_Lead_Status__c='New');
            insert portalAccount;
            Contact contact = new Contact(
                LastName='LastName', 
                Title__c='Processor ', 
                Cell__c='1234569874', 
                Office_Phone__c='1234569874', 
                Email = 'Sam@gmail.com',
                Individual_Lead_source__c='Other', 
                Contact_NMLS__c = '12345',
                Source_Name__c='Michael',
                AccountId = portalAccount.Id);
            insert contact;        
            Client__c clientInfo = new Client__c();
            clientInfo.Name = 'John';
            clientInfo.Last_Name__c = 'Smith';
            clientInfo.City__c = 'Black Water';
            clientInfo.Zip__c = '48075';
            clientInfo.DOB__c = Date.today();
            insert clientInfo;
            Loan_New__c LC = new Loan_New__c(IsActiveFlag__c= true, LoanCompleteFlag__c= true,LoanStatus__c ='Funded',
                                             LoanNumber__c = '12345',Appraisal_Received_Date__c=Date.parse('10/11/2017')                                            
                                             ,Related_Individual__c = contact.Id, Related_Partner__c = portalAccount.Id);
            insert LC;                                     
            
            LoanDateController.saveTheFile(LC.id,'file name', 'VGVzdA==', 'pdf');
            LoanDateController.sendEmail('test','test');            
        }
    }

    public static Loan_New__c createLoan()
    {
        ClientInfo__c clientInfo = new ClientInfo__c();
        clientInfo.Name = 'John';
        clientInfo.Last_Name__c = 'Smith';
        clientInfo.Zip__c = '48075';
        clientInfo.DOB__c = Date.today();
        insert clientInfo;
        
        Loan_New__c LC1 = new Loan_New__c(Client_Name__c=clientInfo.Id);
        insert LC1;
        return LC1;
    }

    @isTest static void createTaskTest()
    { 
    try{
        LoanDateController.createAETask('test','test');
    }catch(Exception ex){}
    } 
}