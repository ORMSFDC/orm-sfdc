/* Modified :Sahitya 2/5/19: added updated string JSON for testCreateLoanFromFNMResponse */
@isTest
private class FNMMapperServiceTest {
    
    @isTest static void testCreateLoanFromFNMResponse() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='ORM Partners'];
        QLMS_AE__c QLMSAE= new QLMS_AE__c();
        
        QLMSAE.Email__c='abc@glx.com';
        QLMSAE.isActive__c=true;
        QLMSAE.Office_Phone__c='9630266959';
        QLMSAE.Name='Nausad';
        insert QLMSAE;
        
        Account portalAccount = new Account(
            Name='portalAccount',
            Cell__c='1236547410',
            QLMS_Account_Executive__c=QLMSAE.ID,
            //Email__c='test@noemail.com',
            Main_Phone__c='5414147852',
            Partner_Lead_Status__c='New');
        insert portalAccount;
        
        Contact contact = new Contact(
            LastName='LastName', 
            Title__c='Processor ', 
            Cell__c='1234569874', 
            Office_Phone__c='1234569874', 
            Individual_Lead_source__c='Other', 
            Email = 'Sam@gmail.com',
            //How_did_you_hear_about_us__c='Twitter', 
            //Individual_lead_Status__c='New',
            Source_Name__c='Michael',
            AccountId = portalAccount.Id);
        insert contact;
        
        User u = new User(
            Alias='loandate', 
            Email='fnmmapperservicetest@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = p.Id, 
            CommunityNickname='fnmmapperservicetest',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='fnmmapperservicetest@testorg.com',
            ContactId = contact.Id);
        
        System.runAs(u) {
            Test.startTest();
            
            String json = '{"tenOhThree":{"envelopeHeader":{"institutionID":"","institutionName":"","date":null,"envelopeControlNumber":"0"},"transactionHeader":{"transactionID":"T100099-002","transactionControlNumber":"1"},"transactionProcessingInfo":{"versionID":"1.00","identifierTypeCode":"01","identifier":"","importAction":1},"fileIdentification":[{"fileType":"1","fileVersionID":"3.20","exportVersionIndicator":"W"},{"fileType":"70","fileVersionID":"3.20","exportVersionIndicator":" "},{"fileType":"11","fileVersionID":"3.20","exportVersionIndicator":" "},{"fileType":"20","fileVersionID":"3.20","exportVersionIndicator":" "}],"topOfForm":{"incomeOrAssetsOfNonBorrower":true,"incomeOrAssetsOfSpouse":false},"mortgageTypeAndTerms":{"mortgageAppliedFor":"02","mortgageAppliedForOther":"","agencyCaseNumber":"","caseNumber":"","loanAmount":190000,"interestRate":3.25,"numOfMonths":360,"amortizationType":"05","amortizationTypeOther":"","armDescription":""},"propertyInformation":{"propertyAddress":{"streetAddress":"22041 Mimosa Ln","streetAddress2":"Appt 5","city":"Moreno Valley","zipCode":"32553","zipCodePlusFour":"1234","state":4,"country":null},"numberOfUnits":1,"legalDescriptionPropertyCode":"F1","legalDescriptionPropertyText":"See preliminary title.","yearBuilt":2003},"propertyAddressInformation":null,"loanPurpose":{"purposeOfLoan":"05","purposeOfLoanOther":"","propertyWillBe":"1","mannerTitleHeld":"To be determined in escrow","estateHeldIn":"1","leaseExpirationDate":null},"titleHolders":[{"titleHolderName":"Daniel D Tenorio"},{"titleHolderName":"Graciela Tenorio"}],"constructionOrRefinanceData":{"yearAcquired":2013,"originalCost":190260,"existingLiensAmount":176232,"presentValueOfLot":null,"costOfImprovements":null,"purposeOfRefinance":"11","describeImprovements":"","describeImprovementsStatus":2,"describeImprovementsCost":null},"downPayments":[],"applicantData":[{"applicantType":0,"ssn":"111222954","firstName":"Daniel","middleName":"D","lastName":"Tenorio","generation":"","homePhone":"9512048761","age":67,"yearsOfSchool":null,"maritalStatus":0,"dependents":2,"completedJointly":true,"crossReferenceNumber":"222111157","dateOfBirth":null,"emailAddress":"leo@email.com"},{"applicantType":1,"ssn":"222111157","firstName":"Graciela","middleName":"","lastName":"Tenorio","generation":"","homePhone":"9512048761","age":66,"yearsOfSchool":null,"maritalStatus":0,"dependents":null,"completedJointly":true,"crossReferenceNumber":"111222954","dateOfBirth":"1949-12-26T00:00:00","emailAddress":""}],"dependentsAge":[],"applicantsAddress":[{"ssn":"111222954","addressType":1,"residenceAddress":{"streetAddress":"22041 Mimosa Ln","streetAddress2":null,"city":"Moreno Valley","zipCode":"92553","zipCodePlusFour":"","state":4,"country":""},"residenceOwnership":2,"yearsAtResidence":7,"monthsAtResidence":0},{"ssn":"111222954","addressType":2,"residenceAddress":{"streetAddress":"300 S Garden St","streetAddress2":null,"city":"Lake City","zipCode":"55041","zipCodePlusFour":"","state":23,"country":""},"residenceOwnership":2,"yearsAtResidence":7,"monthsAtResidence":0},{"ssn":"222111157","addressType":1,"residenceAddress":{"streetAddress":"22041 Mimosa Ln","streetAddress2":null,"city":"Moreno Valley","zipCode":"92553","zipCodePlusFour":"","state":4,"country":""},"residenceOwnership":2,"yearsAtResidence":7,"monthsAtResidence":0}],"primaryCurrentEmployers":[{"ssn":"222111157","employerName":"Riverside Unified School Distc.","employerAddress":{"streetAddress":"3380 14th St","streetAddress2":null,"city":"Riverside","zipCode":"92501","zipCodePlusFour":"","state":4,"country":null},"selfEmployed":false,"yearsOnJob":25,"monthsOnJob":null,"yearsInLineOfWork":25,"position":"Noon Supervisor","businessPhone":"9517887135"},{"ssn":"9879879988","employerName":"Unmatched Employment","employerAddress":{"streetAddress":"3380 14th St","streetAddress2":null,"city":"Riverside","zipCode":"92501","zipCodePlusFour":"","state":4,"country":null},"selfEmployed":false,"yearsOnJob":25,"monthsOnJob":null,"yearsInLineOfWork":25,"position":"Noon Supervisor","businessPhone":"9517887135"}],"secondOrPreviousEmployers":[{"ssn":"111222954","employerName":"Dimond, Geyer and Co","employerAddress":{"streetAddress":"375 Fulton St","streetAddress2":null,"city":"Farmingdale","zipCode":"11735","zipCodePlusFour":"","state":32,"country":null},"selfEmployed":false,"currentEmployment":false,"fromDate":"1987-01-01T00:00:00","toDate":"2014-01-20T00:00:00","monthlyIncome":8300,"position":"Partner","businessPhone":"5162496940"},{"ssn":"999887777","employerName":"Dimond, Geyer and Co","employerAddress":{"streetAddress":"375 Fulton St","streetAddress2":null,"city":"Farmingdale","zipCode":"11735","zipCodePlusFour":"","state":32,"country":null},"selfEmployed":false,"currentEmployment":false,"fromDate":"1987-01-01T00:00:00","toDate":"2014-01-20T00:00:00","monthlyIncome":8300,"position":"Partner","businessPhone":"5162496940"}],"presentOrProposedHousingExpense":[{"ssn":"111222954","presentProposedIndicator":"1","housingPaymentTypeCode":"01","monthlyHousingExpense":62},{"ssn":"111222954","presentProposedIndicator":"1","housingPaymentTypeCode":"14","monthlyHousingExpense":325},{"ssn":"111222954","presentProposedIndicator":"2","housingPaymentTypeCode":"26","monthlyHousingExpense":854.18},{"ssn":"111222954","presentProposedIndicator":"2","housingPaymentTypeCode":"01","monthlyHousingExpense":62},{"ssn":"111222954","presentProposedIndicator":"2","housingPaymentTypeCode":"14","monthlyHousingExpense":325}],"income":[{"ssn":"111222954","typeOfIncomeCode":"41","monthlyIncomeAmount":2800},{"ssn":"111222954","typeOfIncomeCode":"42","monthlyIncomeAmount":1575},{"ssn":"222111157","typeOfIncomeCode":"42","monthlyIncomeAmount":680},{"ssn":"222111157","typeOfIncomeCode":"45","monthlyIncomeAmount":680}],"lifeInsurance":[{"ssn":"111222954","accountNumber":"789456","lifeInsuranceCashOrMarketValue":100000.0,"lifeInsuranceFaceAmount":200000.0},{"ssn":"999887777","accountNumber":"789456","lifeInsuranceCashOrMarketValue":100000.0,"lifeInsuranceFaceAmount":200000.0}],"assets":[{"ssn":"111222954","assetType":"03","depositoryName":"Schoolfirst CU","depositoryAddress":{"streetAddress":"","streetAddress2":null,"city":"","zipCode":"","zipCodePlusFour":"","state":0,"country":null},"accountNumber":"123","cashOrMarketValue":250,"numberOfStocksOrBondShares":null,"assetDescription":""},{"ssn":"111222954","assetType":"03","depositoryName":"Altura CU","depositoryAddress":{"streetAddress":"","streetAddress2":null,"city":"","zipCode":"","zipCodePlusFour":"","state":0,"country":null},"accountNumber":"123","cashOrMarketValue":3000,"numberOfStocksOrBondShares":null,"assetDescription":""},{"ssn":"111222954","assetType":"08","depositoryName":"","depositoryAddress":{"streetAddress":"","streetAddress2":null,"city":"","zipCode":"","zipCodePlusFour":"","state":0,"country":null},"accountNumber":"","cashOrMarketValue":78000,"numberOfStocksOrBondShares":null,"assetDescription":""},{"ssn":"111222954","assetType":"F4","depositoryName":"Awesome Mutual Fund Company","depositoryAddress":{"streetAddress":"","streetAddress2":null,"city":"","zipCode":"","zipCodePlusFour":"","state":0,"country":null},"accountNumber":"","cashOrMarketValue":120000,"numberOfStocksOrBondShares":null,"assetDescription":""},{"ssn":"111222954","assetType":"F8","depositoryName":"Lawn Business Company Name","depositoryAddress":{"streetAddress":"","streetAddress2":null,"city":"","zipCode":"","zipCodePlusFour":"","state":0,"country":null},"accountNumber":"","cashOrMarketValue":600000,"numberOfStocksOrBondShares":null,"assetDescription":""},{"ssn":"111222954","assetType":"NE","depositoryName":"Other Asset","depositoryAddress":{"streetAddress":"","streetAddress2":null,"city":"","zipCode":"","zipCodePlusFour":"","state":0,"country":null},"accountNumber":"","cashOrMarketValue":10000,"numberOfStocksOrBondShares":null,"assetDescription":""},{"ssn":"999887777","assetType":"03","depositoryName":"Altura CU","depositoryAddress":{"streetAddress":"","streetAddress2":null,"city":"","zipCode":"","zipCodePlusFour":"","state":0,"country":null},"accountNumber":"123","cashOrMarketValue":3000,"numberOfStocksOrBondShares":null,"assetDescription":""}],"automobiles":[],"alimonyOrChildSupportOrJobRelatedExpenses":[{"ssn":"111222954","expenseTypeCode":1,"monthlyPaymentAmount":55,"monthsLeftToPay":null,"alimonyOwedTo":"to the ex"},{"ssn":"111222954","expenseTypeCode":3,"monthlyPaymentAmount":65,"monthsLeftToPay":null},{"ssn":"999887777","expenseTypeCode":3,"monthlyPaymentAmount":65,"monthsLeftToPay":null}],"realEstateOwned":[{"ssn":"111222954","propertyAddress":{"streetAddress":"22041 Mimosa Ln","streetAddress2":"Appt 5","city":"Moreno Valley","zipCode":"32553","zipCodePlusFour":"1234","state":4,"country":null},"propertyDisposition":1,"propertyType":"14","presentMarketValue":300000,"amountOfMortgagesAndLiens":176232,"grossRentalIncome":null,"mortgagePayments":854,"insuranceMaintenanceTaxesAndMisc":608,"netRentalIncome":null,"isCurrentResidence":true,"isSubjectProperty":true,"reoAssetID":1},{"ssn":"111222954","propertyAddress":{"streetAddress":"3470 Franklin Ave","streetAddress2":null,"city":"Riverside","zipCode":"92507","zipCodePlusFour":"","state":4,"country":null},"propertyDisposition":1,"propertyType":"14","presentMarketValue":240000,"amountOfMortgagesAndLiens":186913,"grossRentalIncome":null,"mortgagePayments":1087,"insuranceMaintenanceTaxesAndMisc":null,"netRentalIncome":null,"isCurrentResidence":false,"isSubjectProperty":false,"reoAssetID":2},{"ssn":"999887777","propertyAddress":{"streetAddress":"22041 Mimosa Ln","streetAddress2":null,"city":"Moreno Valley","zipCode":"32553","zipCodePlusFour":"","state":4,"country":null},"propertyDisposition":1,"propertyType":"14","presentMarketValue":300000,"amountOfMortgagesAndLiens":176232,"grossRentalIncome":null,"mortgagePayments":854,"insuranceMaintenanceTaxesAndMisc":608,"netRentalIncome":null,"isCurrentResidence":true,"isSubjectProperty":true,"reoAssetID":1}],"aliases":[],"liabilities":[{"ssn":"111222954","liabilityType":4,"creditorName":"QUICKENLOANS","creditorAddress":{"streetAddress":"1050 WOODWARD AVENUE","streetAddress2":null,"city":"DETROIT","zipCode":"48226","zipCodePlusFour":"","state":22,"country":null},"accountNumber":"8673316102600","monthlyPaymentAmount":1087,"monthsLeftToPay":null,"unpaidBalance":186913,"liabilityWillBePaidByClosing":false,"reoAssetID":null,"isResubordinated":false,"isOmitted":false,"isSubjectProperty":null,"isRentalProperty":null},{"ssn":"111222954","liabilityType":4,"creditorName":"QUICKENLOANS","creditorAddress":{"streetAddress":"1050 WOODWARD AVENUE","streetAddress2":null,"city":"DETROIT","zipCode":"48226","zipCodePlusFour":"","state":22,"country":null},"accountNumber":"8673316101866","monthlyPaymentAmount":1462,"monthsLeftToPay":null,"unpaidBalance":176232,"liabilityWillBePaidByClosing":false,"reoAssetID":null,"isResubordinated":false,"isOmitted":false,"isSubjectProperty":null,"isRentalProperty":null},{"ssn":"111222954","liabilityType":0,"creditorName":"AM HONDA FIN","creditorAddress":{"streetAddress":"10801 WALKER ST STE 140","streetAddress2":null,"city":"CYPRESS","zipCode":"90630","zipCodePlusFour":"","state":4,"country":null},"accountNumber":"191142170","monthlyPaymentAmount":549,"monthsLeftToPay":null,"unpaidBalance":29381,"liabilityWillBePaidByClosing":false,"reoAssetID":null,"isResubordinated":false,"isOmitted":false,"isSubjectProperty":null,"isRentalProperty":null},{"ssn":"111222954","liabilityType":0,"creditorName":"SCHOOLSFIRST","creditorAddress":{"streetAddress":"2115 N BROADWAY","streetAddress2":null,"city":"SANTA ANA","zipCode":"92711","zipCodePlusFour":"","state":4,"country":null},"accountNumber":"10116700800","monthlyPaymentAmount":191,"monthsLeftToPay":null,"unpaidBalance":9263,"liabilityWillBePaidByClosing":false,"reoAssetID":null,"isResubordinated":false,"isOmitted":false,"isSubjectProperty":null,"isRentalProperty":null},{"ssn":"111222954","liabilityType":2,"creditorName":"SCHOOLSFIRST","creditorAddress":{"streetAddress":"PO BOX 11547","streetAddress2":null,"city":"SANTA ANA","zipCode":"92711","zipCodePlusFour":"","state":4,"country":null},"accountNumber":"524860XXXXXX9615","monthlyPaymentAmount":89,"monthsLeftToPay":null,"unpaidBalance":4422,"liabilityWillBePaidByClosing":false,"reoAssetID":null,"isResubordinated":false,"isOmitted":false,"isSubjectProperty":null,"isRentalProperty":null},{"ssn":"111222954","liabilityType":0,"creditorName":"SCHOOLSFIRST","creditorAddress":{"streetAddress":"2115 N BROADWAY","streetAddress2":null,"city":"SANTA ANA","zipCode":"92711","zipCodePlusFour":"","state":4,"country":null},"accountNumber":"7777050800","monthlyPaymentAmount":142,"monthsLeftToPay":null,"unpaidBalance":2792,"liabilityWillBePaidByClosing":false,"reoAssetID":null,"isResubordinated":false,"isOmitted":false,"isSubjectProperty":null,"isRentalProperty":null},{"ssn":"111222954","liabilityType":2,"creditorName":"SYNCB/P66","creditorAddress":{"streetAddress":"P.O BOX 965004","streetAddress2":null,"city":"ORLANDO","zipCode":"32896","zipCodePlusFour":"","state":9,"country":null},"accountNumber":"7076222201908229","monthlyPaymentAmount":32,"monthsLeftToPay":null,"unpaidBalance":1038,"liabilityWillBePaidByClosing":false,"reoAssetID":null,"isResubordinated":false,"isOmitted":false,"isSubjectProperty":null,"isRentalProperty":null},{"ssn":"111222954","liabilityType":2,"creditorName":"CAPITAL ONE","creditorAddress":{"streetAddress":"15000 CAPITAL ONE DR","streetAddress2":null,"city":"RICHMOND","zipCode":"23238","zipCodePlusFour":"","state":46,"country":null},"accountNumber":"517805XXXXXX9959","monthlyPaymentAmount":25,"monthsLeftToPay":null,"unpaidBalance":55,"liabilityWillBePaidByClosing":false,"reoAssetID":null,"isResubordinated":false,"isOmitted":false,"isSubjectProperty":null,"isRentalProperty":null},{"ssn":"999887777","liabilityType":4,"creditorName":"QUICKENLOANS","creditorAddress":{"streetAddress":"1050 WOODWARD AVENUE","streetAddress2":null,"city":"DETROIT","zipCode":"48226","zipCodePlusFour":"","state":22,"country":null},"accountNumber":"8673316102600","monthlyPaymentAmount":1087,"monthsLeftToPay":null,"unpaidBalance":186913,"liabilityWillBePaidByClosing":false,"reoAssetID":null,"isResubordinated":false,"isOmitted":false,"isSubjectProperty":null,"isRentalProperty":null}],"undrawnHELOCAndIPCs":[],"detailsOfTransaction":{"purchasePrice":null,"alterationsImprovementsRepairsCost":null,"landCost":null,"refinanceCost":null,"estimatedPrepaidItemsAmount":null,"estimatedClosingCosts":2500,"mortgageInsuranceFundingFee":500,"discountAmount":null,"subordinateFinancingAmount":null,"applicantsClosingCostsPaidBySeller":null,"mortgageInsuranceFundingFeeFinanced":6270},"otherCredits":[],"declarations":[{"ssn":"111222954","outstandingJudgments":false,"declaredBankruptcy":false,"forclosedOrDeedInLieu":false,"partyToLawsuit":true,"obligatedOnLoanForeclosed":false,"delinquencyOrDefault":false,"alimonyOrChildSupport":false,"partOfDownPaymentBorrowed":false,"coMakerOrEndorserOnNote":false,"citizenShip":"01","doYouIntendToOccupy":0,"haveYouHadAnOwnershipInterest":0,"whatTypeOfProperty":"1","howDoYouHoldTitle":"01"},{"ssn":"222111157","outstandingJudgments":null,"declaredBankruptcy":null,"forclosedOrDeedInLieu":null,"partyToLawsuit":null,"obligatedOnLoanForeclosed":null,"delinquencyOrDefault":null,"alimonyOrChildSupport":null,"partOfDownPaymentBorrowed":null,"coMakerOrEndorserOnNote":null,"citizenShip":"01","doYouIntendToOccupy":2,"haveYouHadAnOwnershipInterest":2,"whatTypeOfProperty":"","howDoYouHoldTitle":""}],"declarationExplanations":[],"acknowledgementAndAgreement":[{"ssn":"111222954","signatureDate":null},{"ssn":"222111157","signatureDate":null}],"governmentMonitoringInfo":[{"ssn":"111222954","clientWillNotFurnishedGovtMonitoring":false,"ethnicity":"1","sex":1},{"ssn":"222111157","clientWillNotFurnishedGovtMonitoring":false,"ethnicity":"1","sex":0}],"loanOriginator":{"applicationTakenBy":2,"loanOriginatorsName":"Michael Foster","interviewDate":"2016-10-04T00:00:00","loanOriginatorsPhoneNumber":"3133738064","loanOriginationCompanyName":"One Reverse Mortgage, LLC","loanOriginatorsAddress":{"streetAddress":"644 Woodward Ave.","streetAddress2":"","city":"Detroit","zipCode":"48226","zipCodePlusFour":"","state":22,"country":null}},"races":[{"ssn":"111222954","race":"5"},{"ssn":"111222954","race":"2"},{"ssn":"222111157","race":"5"}],"fannieMaeTransmittalData":{"sellerProvidedBelowMarketFunding":null,"ownerOfExistingMortgage":"F1","propertyAppraisedValue":300000,"buydownRate":null,"appraisedValueIndicator":"01","appraisalFieldworkOrdered":"","appraiserName":"","appraiserCompany":"","appraiserLicenseNumber":"","appraiserLicenseStateCode":""},"additionalDataSegments":[{"additionalDataSegmentType":0,"additionalDataSegmentValue":"373432"},{"additionalDataSegmentType":1,"additionalDataSegmentValue":"213677"},{"additionalDataSegmentType":2,"additionalDataSegmentValue":""},{"additionalDataSegmentType":0,"additionalDataSegmentValue":""},{"additionalDataSegmentType":0,"additionalDataSegmentValue":"393344896:Male"},{"additionalDataSegmentType":0,"additionalDataSegmentValue":"393344896:Cuban"},{"additionalDataSegmentType":0,"additionalDataSegmentValue":"393344896:N"},{"additionalDataSegmentType":0,"additionalDataSegmentValue":"393344896:N"},{"additionalDataSegmentType":0,"additionalDataSegmentValue":"393344896:1:Asian"},{"additionalDataSegmentType":0,"additionalDataSegmentValue":"393344896:N"},{"additionalDataSegmentType":0,"additionalDataSegmentValue":"393344896:Telephone"}],"score":[],"loanCharacteristics":{"negativeAmortizationLimitPercent":null,"isBalloonRequired":false,"hasHomebuyerEducationCompletion":null,"maximumLifetimeRateIncrease":null,"paymentAdjustmentLifePercentCap":null,"paymentAdjustmentLifeAmountCap":null,"willEscrowBeWaived":false,"scheduledClosingDate":null,"scheduledFirstPaymentDate":null,"miCoveragePercent":null,"aprSpread":"","hoepa":false,"isPreApproved":false,"lienType":"1","loanDocumentationType":null,"subjectPropertyType":"01","projectClassification":"","miInsurer":""},"productIdentification":{"productDescription":"","productCode":"","productPlanNumber":""},"productCharacteristics":{"mortgageTerm":"360","assumableLoanIndicator":null,"paymentFrequencyCode":"","prepaymentPenaltyIndicator":null,"prepaymentRestrictedIndicator":null,"repaymentTypeCode":null},"arm":null,"paymentAdjustment":[],"rateAdjustment":[],"buydownData":null,"casefileIdentification":{"filler":""},"lenderData":{"fhaLenderIdentifier":"71970-00003","fhaSponsorIdentifier":"","sponsoredOriginatorEIN":"","filler":""},"fhaAndVALoanData":{"energyEfficientNewHome":null,"mortgageCreditCertificate":null,"sellerConcessions":null,"borrowerTotalClosingCostsFees":null,"borrowerTotalClosingCostsPoints":null,"sellerTotalClosingCostsFees":null,"sellerTotalClosingCostsPoints":null,"otherTotalClosingCostsFees":null,"otherTotalClosingCostsPoints":null,"typeOfRefinance":"","propertyOfCounty":""},"fhaLoanOnlyData":null,"vaLoanOnlyData":{"coBorrowerMarriedToPrimaryBorrower":true,"entitlementAmount":null,"monthlyMaintenance":null,"monthlyUtilities":null,"fundingFeePercent":""},"vaLoanOnlyExtraData":[{"ssn":"111222954","totalTax":null,"stateTax":null,"localIncomeTax":null,"socialSecurityTax":null,"totalNonTaxableIncomePrimary":null,"totalNonTaxableIncomeOther":null,"totalTaxableIncomePrimary":null,"totalTaxableIncomeOther":null},{"ssn":"222111157","totalTax":null,"stateTax":null,"localIncomeTax":null,"socialSecurityTax":null,"totalNonTaxableIncomePrimary":null,"totalNonTaxableIncomeOther":null,"totalTaxableIncomePrimary":null,"totalTaxableIncomeOther":null}],"creditData":[{"ssn":"111222954","caivrNumber":"","borrowerCreditRating":"","bankruptcyWithinLastThreeYears":"","forclosure":"","firstTimeHomebuyerCounsel":""},{"ssn":"222111157","caivrNumber":"","borrowerCreditRating":"","bankruptcyWithinLastThreeYears":"","forclosure":"","firstTimeHomebuyerCounsel":""}],"communityLendingLoanData":null,"transactionTrailer":{"transactionControlNumber":"1"},"envelopeTrailer":{"envelopeControlNumber":"0"}},"warnings":[],"errors":[],"fieldList":[],"wasInputSorted":false,"wasSuccessful":true,"applicationId":null}';
                Test.setMock(HttpCalloutMock.class, new FNMMockHttpResponse(json));
            FNMResponse fnmResponse = FNMParseService.parseFNM(Blob.valueOf(''));
            
            System.assert(fnmResponse.wasSuccessful);
            
            Loan_New__c loan = FNMMapperService.createLoanFromFNMResponse(fnmResponse, Date.today(),'ARM','FHA Traditional HECM');
            
            System.assert(loan != null);
            //System.assertEquals('Michael', loan.Loan_Originator_s_First_Name__c);
            //System.assertEquals('Foster', loan.Loan_Originator_s_Last_Name__c);
            System.assertEquals(62, loan.Hazard_Insurance__c);
            System.assertEquals(325, loan.Real_Estate_Taxes__c);
            
            //System.assertEquals(4, loan.Interview_Date__c.day());
            //System.assertEquals('644 Woodward Ave.', loan.Loan_Origination_Company_s_Address__c);
            //System.assertEquals('48226', loan.Loan_Origination_Company_s_Zip_Code__c);
            //System.assertEquals('Daniel D Tenorio,Graciela Tenorio', loan.Property_Title_is_Held_in_These_Names__c);
            
            Test.stopTest();
        }
    }
    
    @isTest static void testCreateLoanFromFNMResponseInvalidState() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Partner Community User'];
        QLMS_AE__c QLMSAE= new QLMS_AE__c();
        
        QLMSAE.Email__c='abc@glx.com';
        QLMSAE.isActive__c=true;
        QLMSAE.Office_Phone__c='9630266959';
        QLMSAE.Name='Nausad';
        insert QLMSAE;
        
        Account portalAccount = new Account(
            Name='portalAccount',
            Cell__c='1236547410',
            QLMS_Account_Executive__c=QLMSAE.ID,
            //Email__c='test@noemail.com',
            Main_Phone__c='5414147852',
            Partner_Lead_Status__c='New');
        insert portalAccount;
        
        Contact contact = new Contact(
            LastName='LastName', 
            Title__c='Processor ', 
            Cell__c='1234569874', 
            Office_Phone__c='1234569874', 
            Individual_Lead_source__c='Other', 
            Email = 'Sam@gmail.com',
            //How_did_you_hear_about_us__c='Twitter', 
            //Individual_lead_Status__c='New',
            Source_Name__c='Michael',
            AccountId = portalAccount.Id);
        insert contact;
        
        User u = new User(
            Alias='loandate', 
            Email='fnmmapperservicetest@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = p.Id, 
            CommunityNickname='fnmmapperservicetest',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='fnmmapperservicetest@testorg.com',
            ContactId = contact.Id);
        
        System.runAs(u) {
            Test.startTest();
            FNMResponse.DetailsOfTransaction obj =new FNMResponse.DetailsOfTransaction();   
            obj.purchasePrice =0.00;
            obj.alterationsImprovementsRepairsCost  =0.00;
            obj.landCost  =0.00;
            obj.refinanceCost  =0.00;
            obj.estimatedPrepaidItemsAmount =0.00;
            obj.estimatedClosingCosts =0.00;
            obj.mortgageInsuranceFundingFee =0.00;
            obj.discountAmount  =0.00;
            obj.subordinateFinancingAmount  =0.00;
            obj.applicantsClosingCostsPaidBySeller  =0.00;
            obj.mortgageInsuranceFundingFeeFinanced  =0.00;
    
            String json = '{"tenOhThree":{"envelopeHeader":{"institutionID":"","institutionName":"","date":null,"envelopeControlNumber":"0"},"transactionHeader":{"transactionID":"T100099-002","transactionControlNumber":"1"},"transactionProcessingInfo":{"versionID":"1.00","identifierTypeCode":"01","identifier":"","importAction":1},"fileIdentification":[{"fileType":"1","fileVersionID":"3.20","exportVersionIndicator":"W"},{"fileType":"70","fileVersionID":"3.20","exportVersionIndicator":" "},{"fileType":"11","fileVersionID":"3.20","exportVersionIndicator":" "}],"topOfForm":{"incomeOrAssetsOfNonBorrower":false,"incomeOrAssetsOfSpouse":true},"mortgageTypeAndTerms":{"mortgageAppliedFor":"01","mortgageAppliedForOther":"","agencyCaseNumber":"","caseNumber":"3333333","loanAmount":200000,"interestRate":3.625,"numOfMonths":360,"amortizationType":"01","amortizationTypeOther":"","armDescription":"10/1 ARM"},"propertyInformation":{"propertyAddress":{"streetAddress":"123 Sample Lane","streetAddress2":null,"city":"Bradfordsville","zipCode":"40009","zipCodePlusFour":"","state":5,"country":null},"numberOfUnits":1,"legalDescriptionPropertyCode":"F1","legalDescriptionPropertyText":"See preliminary title.","yearBuilt":1999},"propertyAddressInformation":null,"loanPurpose":{"purposeOfLoan":"05","purposeOfLoanOther":"","propertyWillBe":"1","mannerTitleHeld":"Single man","estateHeldIn":"1","leaseExpirationDate":null},"titleHolders":[{"titleHolderName":"Michigan Sample"}],"constructionOrRefinanceData":{"yearAcquired":2009,"originalCost":475000,"existingLiensAmount":200000,"presentValueOfLot":null,"costOfImprovements":null,"purposeOfRefinance":"13","describeImprovements":"","describeImprovementsStatus":2,"describeImprovementsCost":null},"downPayments":[],"applicantData":[{"applicantType":0,"ssn":"000000000","firstName":"KY","middleName":"","lastName":"Sample","generation":"","homePhone":"3133738000","age":46,"yearsOfSchool":null,"maritalStatus":0,"dependents":null,"completedJointly":true,"crossReferenceNumber":"","dateOfBirth":"1970-01-01T00:00:00","emailAddress":"amandahorvath@onereverse,com"}],"dependentsAge":[],"applicantsAddress":[{"ssn":"000000000","addressType":1,"residenceAddress":{"streetAddress":"123 Sample Lane","streetAddress2":null,"city":"Bradfordsville","zipCode":"40009","zipCodePlusFour":"","state":17,"country":""},"residenceOwnership":2,"yearsAtResidence":6,"monthsAtResidence":0}],"primaryCurrentEmployers":[{"ssn":"000000000","employerName":"Quicken Loans","employerAddress":{"streetAddress":"622 Woodward Ave.","streetAddress2":null,"city":"Detroit","zipCode":"48226","zipCodePlusFour":"","state":22,"country":null},"selfEmployed":false,"yearsOnJob":8,"monthsOnJob":2,"yearsInLineOfWork":8,"position":"Training Consultant","businessPhone":"3133738000"}],"secondOrPreviousEmployers":[],"presentOrProposedHousingExpense":[{"ssn":"000000000","presentProposedIndicator":"2","housingPaymentTypeCode":"26","monthlyHousingExpense":928.07},{"ssn":"000000000","presentProposedIndicator":"2","housingPaymentTypeCode":"02","monthlyHousingExpense":140.45}],"income":[{"ssn":"000000000","typeOfIncomeCode":"20","monthlyIncomeAmount":8333.33}],"lifeInsurance":[],"assets":[],"automobiles":[],"alimonyOrChildSupportOrJobRelatedExpenses":[],"realEstateOwned":[{"ssn":"000000000","propertyAddress":{"streetAddress":"123 Sample Lane","streetAddress2":null,"city":"Bradfordsville","zipCode":"40009","zipCodePlusFour":"","state":17,"country":null},"propertyDisposition":1,"propertyType":"14","presentMarketValue":null,"amountOfMortgagesAndLiens":200000,"grossRentalIncome":null,"mortgagePayments":null,"insuranceMaintenanceTaxesAndMisc":null,"netRentalIncome":null,"isCurrentResidence":true,"isSubjectProperty":true,"reoAssetID":1}],"aliases":[],"liabilities":[{"ssn":"000000000","liabilityType":4,"creditorName":"Quicken Loans","creditorAddress":{"streetAddress":"","streetAddress2":null,"city":"","zipCode":"","zipCodePlusFour":"","state":0,"country":null},"accountNumber":"","monthlyPaymentAmount":null,"monthsLeftToPay":null,"unpaidBalance":200000,"liabilityWillBePaidByClosing":true,"reoAssetID":1,"isResubordinated":false,"isOmitted":false,"isSubjectProperty":null,"isRentalProperty":null}],"undrawnHELOCAndIPCs":[],"detailsOfTransaction":{"purchasePrice":null,"alterationsImprovementsRepairsCost":null,"landCost":null,"refinanceCost":200000,"estimatedPrepaidItemsAmount":307.37,"estimatedClosingCosts":4671,"mortgageInsuranceFundingFee":3500,"discountAmount":null,"subordinateFinancingAmount":null,"applicantsClosingCostsPaidBySeller":null,"mortgageInsuranceFundingFeeFinanced":3500},"otherCredits":[],"declarations":[{"ssn":"000000000","outstandingJudgments":false,"declaredBankruptcy":false,"forclosedOrDeedInLieu":false,"partyToLawsuit":false,"obligatedOnLoanForeclosed":false,"delinquencyOrDefault":false,"alimonyOrChildSupport":false,"partOfDownPaymentBorrowed":false,"coMakerOrEndorserOnNote":false,"citizenShip":"01","doYouIntendToOccupy":0,"haveYouHadAnOwnershipInterest":1,"whatTypeOfProperty":"","howDoYouHoldTitle":""}],"declarationExplanations":[],"acknowledgementAndAgreement":[{"ssn":"000000000","signatureDate":null}],"governmentMonitoringInfo":[{"ssn":"000000000","clientWillNotFurnishedGovtMonitoring":false,"ethnicity":"2","sex":1}],"loanOriginator":{"applicationTakenBy":2,"loanOriginatorsName":"Alexander Dick","interviewDate":"2016-01-26T00:00:00","loanOriginatorsPhoneNumber":"8006558533","loanOriginationCompanyName":""},"races":[{"ssn":"000000000","race":"5"}],"fannieMaeTransmittalData":{"sellerProvidedBelowMarketFunding":null,"ownerOfExistingMortgage":"F1","propertyAppraisedValue":500000,"buydownRate":null,"appraisedValueIndicator":"","appraisalFieldworkOrdered":"","appraiserName":"","appraiserCompany":"","appraiserLicenseNumber":"","appraiserLicenseStateCode":""},"additionalDataSegments":[{"additionalDataSegmentType":0,"additionalDataSegmentValue":"20909"},{"additionalDataSegmentType":1,"additionalDataSegmentValue":""},{"additionalDataSegmentType":2,"additionalDataSegmentValue":""}],"score":[],"loanCharacteristics":{"negativeAmortizationLimitPercent":null,"isBalloonRequired":false,"hasHomebuyerEducationCompletion":null,"maximumLifetimeRateIncrease":null,"paymentAdjustmentLifePercentCap":null,"paymentAdjustmentLifeAmountCap":null,"willEscrowBeWaived":false,"scheduledClosingDate":null,"scheduledFirstPaymentDate":null,"miCoveragePercent":null,"aprSpread":"","hoepa":false,"isPreApproved":false,"lienType":"1","loanDocumentationType":null,"subjectPropertyType":"","projectClassification":"","miInsurer":""},"productIdentification":{"productDescription":"","productCode":"","productPlanNumber":""},"productCharacteristics":{"mortgageTerm":"360","assumableLoanIndicator":null,"paymentFrequencyCode":"","prepaymentPenaltyIndicator":null,"prepaymentRestrictedIndicator":null,"repaymentTypeCode":null},"arm":{"armIndexValue":1.375,"armIndexMargin":2.25,"armQualifyingRate":null,"indexType":"11"},"paymentAdjustment":[],"rateAdjustment":[],"buydownData":null,"casefileIdentification":null,"lenderData":null,"fhaAndVALoanData":null,"fhaLoanOnlyData":null,"vaLoanOnlyData":null,"vaLoanOnlyExtraData":[],"creditData":[],"communityLendingLoanData":null,"transactionTrailer":{"transactionControlNumber":"1"},"envelopeTrailer":{"envelopeControlNumber":"0"}},"warnings":[],"errors":[],"fieldList":[],"wasInputSorted":false,"wasSuccessful":true,"applicationId":null}';
            
            Test.setMock(HttpCalloutMock.class, new FNMMockHttpResponse(json));
            FNMResponse fnmResponse = FNMParseService.parseFNM(Blob.valueOf(''));
            
            System.assert(fnmResponse.wasSuccessful);
            boolean exceptionThrown = false;
            
            try {
                FNMMapperService.createLoanFromFNMResponse(fnmResponse, Date.today(),'ARM','FHA Traditional HECM');
            } catch (AuraHandledException e) {
                exceptionThrown = true;
            }
            
            System.assert(exceptionThrown);
            
            Test.stopTest();
        }
    }
    
    @isTest static void testCreateLoanFromFNMResponseInvalidEmail() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Partner Community User'];
        QLMS_AE__c QLMSAE= new QLMS_AE__c();
        
        QLMSAE.Email__c='abc@glx.com';
        QLMSAE.isActive__c=true;
        QLMSAE.Office_Phone__c='9630266959';
        QLMSAE.Name='Nausad';
        insert QLMSAE;
        
        Account portalAccount = new Account(
            Name='portalAccount', 
            QLMS_Account_Executive__c=QLMSAE.ID,
            Cell__c='1236547410',
            //Email__c='test@noemail.com',
            Main_Phone__c='5414147852',
            Partner_Lead_Status__c='New');
        insert portalAccount;
        
        Contact contact = new Contact(
            LastName='LastName', 
            Title__c='Processor ', 
            Cell__c='1234569874', 
            Office_Phone__c='1234569874', 
            Individual_Lead_source__c='Other', 
            Email = 'Sam@gmail.com',
            //How_did_you_hear_about_us__c='Twitter', 
            //Individual_lead_Status__c='New',
            Source_Name__c='Michael',
            AccountId = portalAccount.Id);
        insert contact;
        
        User u = new User(
            Alias='loandate', 
            Email='fnmmapperservicetest@testorg.com',
            EmailEncodingKey='UTF-8', 
            LastName='Testing', 
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', 
            ProfileId = p.Id, 
            CommunityNickname='fnmmapperservicetest',
            TimeZoneSidKey='America/Los_Angeles', 
            UserName='fnmmapperservicetest@testorg.com',
            ContactId = contact.Id);
        
        System.runAs(u) {
            Test.startTest();
            
            String json = '{"tenOhThree":{"envelopeHeader":{"institutionID":"","institutionName":"","date":null,"envelopeControlNumber":"0"},"transactionHeader":{"transactionID":"T100099-002","transactionControlNumber":"1"},"transactionProcessingInfo":{"versionID":"1.00","identifierTypeCode":"01","identifier":"","importAction":1},"fileIdentification":[{"fileType":"1","fileVersionID":"3.20","exportVersionIndicator":"W"},{"fileType":"70","fileVersionID":"3.20","exportVersionIndicator":" "},{"fileType":"11","fileVersionID":"3.20","exportVersionIndicator":" "}],"topOfForm":{"incomeOrAssetsOfNonBorrower":false,"incomeOrAssetsOfSpouse":true},"mortgageTypeAndTerms":{"mortgageAppliedFor":"01","mortgageAppliedForOther":"","agencyCaseNumber":"","caseNumber":"3333333","loanAmount":200000,"interestRate":3.625,"numOfMonths":360,"amortizationType":"01","amortizationTypeOther":"","armDescription":"10/1 ARM"},"propertyInformation":{"propertyAddress":{"streetAddress":"123 Sample Lane","streetAddress2":null,"city":"Bradfordsville","zipCode":"40009","zipCodePlusFour":"","state":4,"country":null},"numberOfUnits":1,"legalDescriptionPropertyCode":"F1","legalDescriptionPropertyText":"See preliminary title.","yearBuilt":1999},"propertyAddressInformation":null,"loanPurpose":{"purposeOfLoan":"05","purposeOfLoanOther":"","propertyWillBe":"1","mannerTitleHeld":"Single man","estateHeldIn":"1","leaseExpirationDate":null},"titleHolders":[{"titleHolderName":"Michigan Sample"}],"constructionOrRefinanceData":{"yearAcquired":2009,"originalCost":475000,"existingLiensAmount":200000,"presentValueOfLot":null,"costOfImprovements":null,"purposeOfRefinance":"13","describeImprovements":"","describeImprovementsStatus":2,"describeImprovementsCost":null},"downPayments":[],"applicantData":[{"applicantType":0,"ssn":"000000000","firstName":"KY","middleName":"","lastName":"Sample","generation":"","homePhone":"3133738000","age":46,"yearsOfSchool":null,"maritalStatus":0,"dependents":null,"completedJointly":true,"crossReferenceNumber":"","dateOfBirth":"1970-01-01T00:00:00","emailAddress":"amandahorvath@onereverse,com"}],"dependentsAge":[],"applicantsAddress":[{"ssn":"000000000","addressType":1,"residenceAddress":{"streetAddress":"123 Sample Lane","streetAddress2":null,"city":"Bradfordsville","zipCode":"40009","zipCodePlusFour":"","state":17,"country":""},"residenceOwnership":2,"yearsAtResidence":6,"monthsAtResidence":0}],"primaryCurrentEmployers":[{"ssn":"000000000","employerName":"Quicken Loans","employerAddress":{"streetAddress":"622 Woodward Ave.","streetAddress2":null,"city":"Detroit","zipCode":"48226","zipCodePlusFour":"","state":22,"country":null},"selfEmployed":false,"yearsOnJob":8,"monthsOnJob":2,"yearsInLineOfWork":8,"position":"Training Consultant","businessPhone":"3133738000"}],"secondOrPreviousEmployers":[],"presentOrProposedHousingExpense":[{"ssn":"000000000","presentProposedIndicator":"2","housingPaymentTypeCode":"26","monthlyHousingExpense":928.07},{"ssn":"000000000","presentProposedIndicator":"2","housingPaymentTypeCode":"02","monthlyHousingExpense":140.45}],"income":[{"ssn":"000000000","typeOfIncomeCode":"20","monthlyIncomeAmount":8333.33}],"lifeInsurance":[],"assets":[],"automobiles":[],"alimonyOrChildSupportOrJobRelatedExpenses":[],"realEstateOwned":[{"ssn":"000000000","propertyAddress":{"streetAddress":"123 Sample Lane","streetAddress2":null,"city":"Bradfordsville","zipCode":"40009","zipCodePlusFour":"","state":17,"country":null},"propertyDisposition":1,"propertyType":"14","presentMarketValue":null,"amountOfMortgagesAndLiens":200000,"grossRentalIncome":null,"mortgagePayments":null,"insuranceMaintenanceTaxesAndMisc":null,"netRentalIncome":null,"isCurrentResidence":true,"isSubjectProperty":true,"reoAssetID":1}],"aliases":[],"liabilities":[{"ssn":"000000000","liabilityType":4,"creditorName":"Quicken Loans","creditorAddress":{"streetAddress":"","streetAddress2":null,"city":"","zipCode":"","zipCodePlusFour":"","state":0,"country":null},"accountNumber":"","monthlyPaymentAmount":null,"monthsLeftToPay":null,"unpaidBalance":200000,"liabilityWillBePaidByClosing":true,"reoAssetID":1,"isResubordinated":false,"isOmitted":false,"isSubjectProperty":null,"isRentalProperty":null}],"undrawnHELOCAndIPCs":[],"detailsOfTransaction":{"purchasePrice":null,"alterationsImprovementsRepairsCost":null,"landCost":null,"refinanceCost":200000,"estimatedPrepaidItemsAmount":307.37,"estimatedClosingCosts":4671,"mortgageInsuranceFundingFee":3500,"discountAmount":null,"subordinateFinancingAmount":null,"applicantsClosingCostsPaidBySeller":null,"mortgageInsuranceFundingFeeFinanced":3500},"otherCredits":[],"declarations":[{"ssn":"000000000","outstandingJudgments":false,"declaredBankruptcy":false,"forclosedOrDeedInLieu":false,"partyToLawsuit":false,"obligatedOnLoanForeclosed":false,"delinquencyOrDefault":false,"alimonyOrChildSupport":false,"partOfDownPaymentBorrowed":false,"coMakerOrEndorserOnNote":false,"citizenShip":"01","doYouIntendToOccupy":0,"haveYouHadAnOwnershipInterest":1,"whatTypeOfProperty":"","howDoYouHoldTitle":""}],"declarationExplanations":[],"acknowledgementAndAgreement":[{"ssn":"000000000","signatureDate":null}],"governmentMonitoringInfo":[{"ssn":"000000000","clientWillNotFurnishedGovtMonitoring":false,"ethnicity":"2","sex":1}],"loanOriginator":{"applicationTakenBy":2,"loanOriginatorsName":"Alexander Dick","interviewDate":"2016-01-26T00:00:00","loanOriginatorsPhoneNumber":"8006558533","loanOriginationCompanyName":""},"races":[{"ssn":"000000000","race":"5"}],"fannieMaeTransmittalData":{"sellerProvidedBelowMarketFunding":null,"ownerOfExistingMortgage":"F1","propertyAppraisedValue":500000,"buydownRate":null,"appraisedValueIndicator":"","appraisalFieldworkOrdered":"","appraiserName":"","appraiserCompany":"","appraiserLicenseNumber":"","appraiserLicenseStateCode":""},"additionalDataSegments":[{"additionalDataSegmentType":0,"additionalDataSegmentValue":"20909"},{"additionalDataSegmentType":1,"additionalDataSegmentValue":""},{"additionalDataSegmentType":2,"additionalDataSegmentValue":""}],"score":[],"loanCharacteristics":{"negativeAmortizationLimitPercent":null,"isBalloonRequired":false,"hasHomebuyerEducationCompletion":null,"maximumLifetimeRateIncrease":null,"paymentAdjustmentLifePercentCap":null,"paymentAdjustmentLifeAmountCap":null,"willEscrowBeWaived":false,"scheduledClosingDate":null,"scheduledFirstPaymentDate":null,"miCoveragePercent":null,"aprSpread":"","hoepa":false,"isPreApproved":false,"lienType":"1","loanDocumentationType":null,"subjectPropertyType":"","projectClassification":"","miInsurer":""},"productIdentification":{"productDescription":"","productCode":"","productPlanNumber":""},"productCharacteristics":{"mortgageTerm":"360","assumableLoanIndicator":null,"paymentFrequencyCode":"","prepaymentPenaltyIndicator":null,"prepaymentRestrictedIndicator":null,"repaymentTypeCode":null},"arm":{"armIndexValue":1.375,"armIndexMargin":2.25,"armQualifyingRate":null,"indexType":"11"},"paymentAdjustment":[],"rateAdjustment":[],"buydownData":null,"casefileIdentification":null,"lenderData":null,"fhaAndVALoanData":null,"fhaLoanOnlyData":null,"vaLoanOnlyData":null,"vaLoanOnlyExtraData":[],"creditData":[],"communityLendingLoanData":null,"transactionTrailer":{"transactionControlNumber":"1"},"envelopeTrailer":{"envelopeControlNumber":"0"}},"warnings":[],"errors":[],"fieldList":[],"wasInputSorted":false,"wasSuccessful":true,"applicationId":null}';
            
            Test.setMock(HttpCalloutMock.class, new FNMMockHttpResponse(json));
            FNMResponse fnmResponse = FNMParseService.parseFNM(Blob.valueOf(''));
            
            System.assert(fnmResponse.wasSuccessful);
            boolean exceptionThrown = false;
            
            try {
                FNMMapperService.createLoanFromFNMResponse(fnmResponse, Date.today(),'ARM','FHA Traditional HECM');
            } catch (AuraHandledException e) {
                exceptionThrown = true;
            }
            
            System.assert(exceptionThrown);
            
            Test.stopTest();
        }
    }
    
}
