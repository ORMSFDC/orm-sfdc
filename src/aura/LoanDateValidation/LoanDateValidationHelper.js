({
    Loan_Obj1: function (component, event, helper, applicationDate) {
        debugger;
        var fileInput = component.find("file").getElement();
        var file = fileInput.files[0];

        var spinner = component.find("spinner");
        $A.util.toggleClass(spinner, "slds-hide");
        var data = component.get("v.filedata");

        var dd = document.getElementById('inputtxt').value;
        var action = component.get("c.getFNMData");
        //Code Modified by Dev4 for ORMSFDC-1471
        action.setParams({
            "filedata": dd,
            fileName: file.name,
            base64Data: encodeURIComponent(data),
            contentType: file.type,
            applicationDate: applicationDate
        });
        //Code Ended by Dev4 for ORMSFDC-1471
        action.setCallback(this, function (a) {
            debugger;
            var errors = action.getError();
            // alert(errors+''+a.getReturnValue());
            if (errors && errors[0]) {

                console.error("getFNMData error", errors);

                // display error in toast
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "mode": "sticky",
                    "title": "Upload Failed!",
                    "message": errors[0].message
                });
                toastEvent.fire();

                // hide loading spinner
                var spinner = component.find("spinner");
                $A.util.toggleClass(spinner, "slds-hide");

            } else {
                debugger;
                var Id = a.getReturnValue();


                //Code for redirect to Start a Loan Page

                var evt = $A.get("e.c:NavigatetoLoanMenu");
                //Code Modified by Dev4 for ORMSFDC-1471                
                //Code Ended by Dev4 for ORMSFDC-1471
                evt.setParams({ LoanId: Id });
                evt.fire();
            }
        });
        $A.enqueueAction(action);
    },

    showSpinner: function (component) {

        component.set("v.IsSpinner", true);
        var a = component.get("v.IsSpinner");
        // alert("in SS: " + a);

    },

    hideSpinner: function (component) {

        component.set("v.IsSpinner", false);
        var a = component.get("v.IsSpinner");
        //alert("in HS: " + a);

    },

    /*Loan_Obj : function(component, event, helper) {
        var spinner = component.find("spinner");
        
        $A.util.toggleClass(spinner, "slds-hide");
        var dd=document.getElementById('inputtxt').value;
        //alert(dd);
        var myObj='';
        var action = component.get("c.getFNMData");
        action.setParams({
            "filedata" : dd
        });
        action.setCallback(this, function(a) {
            //var state = a.getState();
            //if (state === "SUCCESS"){
            var jdata = a.getReturnValue();
            console.log(jdata);
            myObj=JSON.parse(jdata);
            //alert('testresult result:' + myObj);
            //}
            // else{
            //   alert('error')
            //}
            
            
            // alert('LoanPurpose'+ myObj.tenOhThree.loanPurpose.purposeOfLoan);
            var  AssetsTotalAssets = '';
            var  AssetsInstitutionName = myObj.tenOhThree.transactionHeader.transactionID;
            var  AssetsInstitutionName = '';
            var  AssetsInstitutionAddress = '';
            var  AssetsAccountNumber ='';
            var  AssetsMarketValue = '';
            var  AssetsPropertyAddress = '';
            var  AssetsPresentMarketValue = '';
            var  ClientBorrowerName = myObj.tenOhThree.applicantData[0].firstName +''+ myObj.tenOhThree.applicantData[0].middleName+''+myObj.tenOhThree.applicantData[0].lastName;
            var  ClientSSN = myObj.tenOhThree.applicantData[0].ssn;
            var  ClientDOB = myObj.tenOhThree.applicantData[0].dateOfBirth;
            var  ClientMaritalStatus =  '';
            var  ClientMailingAddress1 = '';
            var  ClientPresentAddressYears = myObj.tenOhThree.applicantsAddress[0].yearsAtResidence;
            var  ClientNBRName = '';
            var  ClientNBRPhone = '';
            var  ClientNBRDOB = '';
            var  ClientNBRRelationship = '';
            var  ClientNBSName = '';
            var  ClientNBSPhone = '';
            var  ClientNBSDOB = '';
            var  ClientNBSRelationship = '';
            var  EmploymentName = '';
            var  EmploymentAddress1 = '';
            var  EmploymentBusinessPhone =  myObj.tenOhThree.primaryCurrentEmployers[0].businessPhone;
            var  EmploymentStartDate = '';
            var  EmploymentEndDate = '';
            var  IncomeGrossMonthly = '';
            var  IncomeDescribeOther = '';
            var  IncomeMonthly = myObj.tenOhThree.income[0].typeOfIncomeCode;
            var  IncomeGrossRental = '';
            var  IncomeNetRental = '';
            var  LiabilitiesAlimony = '';
            var  LiabilitiesJobRelated = '';
            var  LiabilitiesMortgage = '';
            var  LiabilitiesMortgagePayment = '';
            var  LiabilitiesTaxes = '';
            var  LiabilitiesCombinedMonthlyDebts = '';
            var  SubjectPropertyAddress = myObj.tenOhThree.propertyInformation.propertyAddress.streetAddress;
            var  SubjectPropertyDescription = myObj.tenOhThree.propertyInformation.legalDescriptionPropertyText;
            var  SubjectPropertyResidenceType = '';
            var  SubjectPropertyNoOfProperty = myObj.tenOhThree.propertyInformation.numberOfUnits;
            var  SubjectPropertyYearBuilt = myObj.tenOhThree.propertyInformation.yearBuilt;
            var  SubjectPropertyHeldAs = '';
            var  SubjectPropertyHeldNames = '';
            var  SubjectPropertyRealEstateTax = '';
            var  SubjectPropertyHazardInsurance = '';
            var  SubjectPropertyHomeOwnerFee = '';
            var  Loan_Number = '';
            var  Loan_Status = '';
            var  LoanDetailsTitleSource = '';
            var  LoanDetailsTitleCompany = '';
            var  LoanDetailsContact = '';
            var  LoanDetailsPayPartner = '';
            var  CreditPullNew = '';
            var  CreditReissue = '';
            var  CreditPullNewChild = '';
            var  DecRace = '';
            var  CreditReferenceNumber = '';
            var  LoanMortgageAppliedFor = '';
            var  LoanPurpose = 'Medical';
            var  LoanOriginationFee = '';
            var  LoanApplicationTakenBy = '';
            var  LoanInterviewDate = myObj.tenOhThree.loanOriginator.interviewDate;
            var  LoanOriginatorName =  myObj.tenOhThree.loanOriginator.loanOriginatorsName;
            var  LoanOriginatorPhone =  myObj.tenOhThree.loanOriginator.loanOriginatorsPhoneNumber;
            var  LoanOriginatorCompanyName = myObj.tenOhThree.loanOriginator.loanOriginationCompanyName;
            var  LoanOriginatorCompanyAddress = '';
            var  LoanOriginatorIdentifier = '';
            var  LoanOriginatorCompanyIdentifier = '';
            var  LoanHouseHoldMembers = '';
            var  LoanChildrenbelow6 = '';
            var  LoanPOA = '';
            var  LoanSquareFoot = '';
            var  LoanAlternateContactName = '';
            var  LoanAlternateContactAddress = '';
            var  LoanAlternateContactPhone = '';
            var  LoanEstimateAppraisedValue = '';
            var  DecBankrupt = '';
            var  DecCoMaker = '';
            var  DecDefaultFederalDebt = '';
            var  DecDownPaymentBorrowed = '';
            var  DecEthenicity = '';
            var  DecFHAInsuranceLoan = '';
            var  DecIntendToOccupy = '';
            var  DecLawsuit = '';
            var  DecObligatedLoan = '';
            var  DecObligatedPayAlimony = '';
            var  DecOutstandingJudgement = '';
            var  DecPropertyForClose = '';
            var  DecReverseMortgage = '';
            var  DecSex = '';
            var  DecUSCitizen = '';
            var  EmploymentAddress2 = '';
            var  EmploymentCity = '';
            var  EmploymentState = '';
            var  EmploymentZip = '';
            var  EmploymentSelfEmployed = '';
            var  SubjectCheckHeldAs = '';
            var  ClientMailingAddress2 = '';
            var  ClientCity = '';
            var  ClientState = '';
            var  ClientZip = '';
            var  ClientNBR = '';
            var  ClientNBS = '';
            var  ClientIName = '';
            
            
            //component.set("v.newloan",loan);
            //alert('name'+AssetsInstitutionName);
            //component.set("v.newloan.AssetsTotalAssets__c",AssetsTotalAssets);
            component.set("v.newloan.AssetsInstitutionName__c",AssetsInstitutionName);
            component.set("v.newloan.AssetsInstitutionAddress__c",AssetsInstitutionAddress);
            component.set("v.newloan.AssetsAccountNumber__c",AssetsAccountNumber);
            component.set("v.newloan.AssetsMarketValue__c",AssetsMarketValue);
            component.set("v.newloan.AssetsPropertyAddress__c",AssetsPropertyAddress);
            component.set("v.newloan.AssetsPresentMarketValue__c",AssetsPresentMarketValue);
            component.set("v.newloan.LoanPurpose__c",'EFM');
            
            component.set("v.newloan.SubjectPropertyDescription__c",SubjectPropertyDescription);
            
            component.set("v.newloan.SubjectPropertyAddress__c",SubjectPropertyAddress);
            //component.set("v.newloan.LoanInterviewDate__c",LoanInterviewDate);
            component.set("v.newloan.LoanOriginatorName__c",LoanOriginatorName);
            component.set("v.newloan.LoanOriginatorPhone__c",LoanOriginatorPhone);
            component.set("v.newloan.LoanOriginatorCompanyName__c",LoanOriginatorCompanyName);
            component.set("v.newloan.ClientPresentAddressYears__c",ClientPresentAddressYears);
            //component.set("v.newloan.ClientDOB__c",ClientDOB);
            component.set("v.newloan.ClientSSN__c",ClientSSN);
            component.set("v.newloan.ClientBorrowerName__c",ClientBorrowerName);
            component.set("v.newloan.EmploymentBusinessPhone__c",EmploymentBusinessPhone);
            component.set("v.newloan.IncomeMonthly__c",IncomeMonthly);
            //component.set("v.newloan.SubjectPropertyNoOfProperty__c",SubjectPropertyNoOfProperty);
            //component.set("v.newloan.SubjectPropertyYearBuilt__c",SubjectPropertyYearBuilt);
            /*



component.set("v.newloan.ClientMaritalStatus__c",ClientMaritalStatus);
component.set("v.newloan.ClientMailingAddress1__c",ClientMailingAddress1);

component.set("v.newloan.ClientNBRName__c",ClientNBRName);
component.set("v.newloan.ClientNBRPhone__c",ClientNBRPhone);
component.set("v.newloan.ClientNBRDOB__c",ClientNBRDOB);
component.set("v.newloan.ClientNBRRelationship__c",ClientNBRRelationship);
component.set("v.newloan.ClientNBSName__c",ClientNBSName);
component.set("v.newloan.ClientNBSPhone__c",ClientNBSPhone);
component.set("v.newloan.ClientNBSDOB__c",ClientNBSDOB);
component.set("v.newloan.ClientNBSRelationship__c",ClientNBSRelationship);
component.set("v.newloan.EmploymentName__c",EmploymentName);
component.set("v.newloan.EmploymentAddress1__c",EmploymentAddress1);

component.set("v.newloan.EmploymentStartDate__c",EmploymentStartDate);
component.set("v.newloan.EmploymentEndDate__c",EmploymentEndDate);
component.set("v.newloan.IncomeGrossMonthly__c",IncomeGrossMonthly);
component.set("v.newloan.IncomeDescribeOther__c",IncomeDescribeOther);

component.set("v.newloan.IncomeGrossRental__c",IncomeGrossRental);
component.set("v.newloan.IncomeNetRental__c",IncomeNetRental);
component.set("v.newloan.LiabilitiesAlimony__c",LiabilitiesAlimony);
component.set("v.newloan.LiabilitiesJobRelated__c",LiabilitiesJobRelated);
component.set("v.newloan.LiabilitiesMortgage__c",LiabilitiesMortgage);
component.set("v.newloan.LiabilitiesMortgagePayment__c",LiabilitiesMortgagePayment);
component.set("v.newloan.LiabilitiesTaxes__c",LiabilitiesTaxes);
component.set("v.newloan.LiabilitiesCombinedMonthlyDebts__c",LiabilitiesCombinedMonthlyDebts);
component.set("v.newloan.SubjectPropertyResidenceType__c",SubjectPropertyResidenceType);

component.set("v.newloan.SubjectPropertyHeldAs__c",SubjectPropertyHeldAs);
component.set("v.newloan.SubjectPropertyHeldNames__c",SubjectPropertyHeldNames);
component.set("v.newloan.SubjectPropertyRealEstateTax__c",SubjectPropertyRealEstateTax);
component.set("v.newloan.SubjectPropertyHazardInsurance__c",SubjectPropertyHazardInsurance);
component.set("v.newloan.SubjectPropertyHomeOwnerFee__c",SubjectPropertyHomeOwnerFee);
component.set("v.newloan.Loan_Number__c",Loan_Number);
component.set("v.newloan.Loan_Status__c",Loan_Status);
component.set("v.newloan.LoanDetailsTitleSource__c",LoanDetailsTitleSource);
component.set("v.newloan.LoanDetailsTitleCompany__c",LoanDetailsTitleCompany);
component.set("v.newloan.LoanDetailsContact__c",LoanDetailsContact);
component.set("v.newloan.LoanDetailsPayPartner__c",LoanDetailsPayPartner);
component.set("v.newloan.CreditPullNew__c",CreditPullNew);
component.set("v.newloan.CreditReissue__c",CreditReissue);
component.set("v.newloan.CreditPullNewChild__c",CreditPullNewChild);
component.set("v.newloan.DecRace__c",DecRace);
component.set("v.newloan.CreditReferenceNumber__c",CreditReferenceNumber);
component.set("v.newloan.LoanMortgageAppliedFor__c",LoanMortgageAppliedFor);
component.set("v.newloan.LoanPurpose__c",LoanPurpose);
component.set("v.newloan.LoanOriginationFee__c",LoanOriginationFee);
component.set("v.newloan.LoanApplicationTakenBy__c",LoanApplicationTakenBy);
component.set("v.newloan.LoanOriginatorCompanyAddress__c",LoanOriginatorCompanyAddress);
component.set("v.newloan.LoanOriginatorIdentifier__c",LoanOriginatorIdentifier);
component.set("v.newloan.LoanOriginatorCompanyIdentifier__c",LoanOriginatorCompanyIdentifier);
component.set("v.newloan.LoanHouseHoldMembers__c",LoanHouseHoldMembers);
component.set("v.newloan.LoanChildrenbelow6__c",LoanChildrenbelow6);
component.set("v.newloan.LoanPOA__c",LoanPOA);
component.set("v.newloan.LoanSquareFoot__c",LoanSquareFoot);
component.set("v.newloan.LoanAlternateContactName__c",LoanAlternateContactName);
component.set("v.newloan.LoanAlternateContactAddress__c",LoanAlternateContactAddress);
component.set("v.newloan.LoanAlternateContactPhone__c",LoanAlternateContactPhone);
component.set("v.newloan.LoanEstimateAppraisedValue__c",LoanEstimateAppraisedValue);

component.set("v.newloan.DecBankrupt__c",DecBankrupt);
component.set("v.newloan.DecCoMaker__c",DecCoMaker);
component.set("v.newloan.DecDefaultFederalDebt__c",DecDefaultFederalDebt);
component.set("v.newloan.DecDownPaymentBorrowed__c",DecDownPaymentBorrowed);
component.set("v.newloan.DecEthenicity__c",DecEthenicity);
component.set("v.newloan.DecFHAInsuranceLoan__c",DecFHAInsuranceLoan);
component.set("v.newloan.DecIntendToOccupy__c",DecIntendToOccupy);
component.set("v.newloan.DecLawsuit__c",DecLawsuit);
component.set("v.newloan.DecObligatedLoan__c",DecObligatedLoan);
component.set("v.newloan.DecObligatedPayAlimony__c",DecObligatedPayAlimony);
component.set("v.newloan.DecOutstandingJudgement__c",DecOutstandingJudgement);
component.set("v.newloan.DecPropertyForClose__c",DecPropertyForClose);
component.set("v.newloan.DecReverseMortgage__c",DecReverseMortgage);
component.set("v.newloan.DecSex__c",DecSex);
component.set("v.newloan.DecUSCitizen__c",DecUSCitizen);
component.set("v.newloan.EmploymentAddress2__c",EmploymentAddress2);
component.set("v.newloan.EmploymentCity__c",EmploymentCity);
component.set("v.newloan.EmploymentState__c",EmploymentState);
component.set("v.newloan.EmploymentZip__c",EmploymentZip);
component.set("v.newloan.EmploymentSelfEmployed__c",EmploymentSelfEmployed);
component.set("v.newloan.SubjectCheckHeldAs__c",SubjectCheckHeldAs);
component.set("v.newloan.ClientMailingAddress2__c",ClientMailingAddress2);
component.set("v.newloan.ClientCity__c",ClientCity);
component.set("v.newloan.ClientState__c",ClientState);
component.set("v.newloan.ClientZip__c",ClientZip);
component.set("v.newloan.ClientNBR__c",ClientNBR);
component.set("v.newloan.ClientNBS__c",ClientNBS);
component.set("v.newloan.ClientIName__c",ClientIName);

            var a = component.get("v.newloan");
            
            var action = component.get("c.saveLoan");
            action.setParams({
                "Loan": a
            });
            action.setCallback(this, function(data) {
                var state = data.getState();
                var Id = data.getReturnValue();
                component.set("v.Id", Id);
                var x = component.get("v.Id");
                // alert("Return value is : " + x);  
                var evt = $A.get("e.c:NavigatetoLoanMenu");
                evt.setParams({LoanId:x})
                evt.fire();
                var spinner = component.find("spinner");
                
                $A.util.toggleClass(spinner, "slds-hide");
            });
            //alert(Id);
            $A.enqueueAction(action);
            
        });
        $A.enqueueAction(action);   
        
    },
    savedata : function(component, event, helper) {
        var dd=document.getElementById('inputtxt').value;
        //alert(dd);
        var myObj='';
        var action = component.get("c.getFNMData");
        action.setParams({
            "filedata" : dd
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            //if (state === "SUCCESS"){
            var jdata = a.getReturnValue();
            myObj=JSON.parse(jdata);
            //alert(myObj);
            // }
            //else{
            //   alert('error')
            //}
        });
        $A.enqueueAction(action);
    },*/


})