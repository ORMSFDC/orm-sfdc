/**
 * @description: used for scenario results, pricing metadata, baydocs req n resp, creating leads from scenario  
 * @author: Ravi
 * @date: 7/28/2017
 *
 * changelog:
 * 07/19/2018: Sahitya - added new fields for saving scenarios, added Helo metadata
 * 08/03/2018: Mike Gill - Debugging SendMailTMP--Exception---System.NullPointerException: Attempt to de-reference a null object
 * 09/20/2018: Sahitya -SFDC - 289 Added 3rd Tier for Portal and Backend Calculator
 * 09/26/2018: Sahitya -SFDC - 275 Divided Authorised states into two metadata tables based on product type
 * 11/01/2018: Sahitya -SFDC - 566 capture Print button count
 * 11/05/2018: Sahitya -SFDC - 567 SaNL from Run Capacity Qualifier
 * 11/21/2018: Sahitya -SFDC - 584 Production Support - Scenario Package DOB 
 * 11/29/2018: Sahitya -SFDC - 396
 */
public without sharing class lookUpController {
    @AuraEnabled
    public static Profile getLoggedInProfile() {
        Profile loggedinUser = [SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId() LIMIT 1];
        return loggedinUser;
    }
    @AuraEnabled
    public static string getScenarioMarginsResponse(string DOB, decimal hv, decimal mb, decimal mp, string ir) {
        System.debug('>>> ' + Label.Scenario_margin + '?dob=' + DOB + '&hv=' + hv + '&ir=' + ir + '&mb=' + mb + '&mp=' + mp + '&type=abc');
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        try {
            Http http = new Http();
            req.setHeader(Label.Scenario_client_id_label, Label.Scenario_client_id);
            req.setHeader(Label.Scenario_client_secret_Label, Label.Scenario_client_secret);
            system.debug('API values --->' + Label.Scenario_margin + '?dob=' + DOB + '&hv=' + hv + '&ir=' + ir + '&mb=' + mb + '&mp=' + mp + '&type=default' + '&cfy=0');
            req.setEndpoint(Label.Scenario_margin + '?dob=' + DOB + '&hv=' + hv + '&ir=' + ir + '&mb=' + mb + '&mp=' + mp + '&type=default' + '&cfy=0');
            req.setMethod('GET');
            if (!test.isRunningTest())
                res = http.send(req);
        } catch (exception e) {
            system.debug('getScenarioResponse--Exception---' + e);
        }

        doUpdateCount();
        System.debug('res.getbody() >>>> ' + res.getbody());
        return res.getbody();
    }

    @AuraEnabled
    public static string getScenarioResponse(string DOB, decimal hv, decimal mb, decimal mp, string ir, string alm) {
        System.debug('<><><><><>');
        System.debug('>>>>> ' + alm);
        System.debug('>>>>>>>>>>>> https://apibeta.rockfin.com/orms/nu62/LineOfCredit/FullCalculator?mp=' + mp + '&hv=' + hv + '&mb=' + mb + '&ir=' + ir + '&dob=' + DOB + '&sdob=0&iscb=false&mmp=0&sp=false&spt=0&cfy=0&alm=' + alm + '&cc=null');
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        try {
            Http http = new Http();
            req.setHeader(Label.Scenario_client_id_label, Label.Scenario_client_id);
            req.setHeader(Label.Scenario_client_secret_Label, Label.Scenario_client_secret);
            // req.setEndpoint(Label.Scenario_LineChart_URL_New+'?dob='+DOB+'&hv='+hv+'&ir='+ ir+'&mb='+mb+'&mp='+mp);        
            req.setEndpoint(Label.Scenario_LineChart_URL_New + '?mp=' + mp + '&hv=' + hv + '&mb=' + mb + '&ir=' + ir + '&dob=' + DOB + '&sdob=0&iscb=false&mmp=0&sp=false&spt=0&cfy=0&alm=' + alm + '&cc=null');
            req.setMethod('POST');
            req.setBody('{}');
            res = http.send(req);
        } catch (exception e) {
            system.debug('getScenarioResponse--Exception---' + e);
        }
        return res.getbody();
    }
    @AuraEnabled
    public static string getScenarioCashFlowResponse(decimal mb, decimal mp, string ir) {
        // ir=2&mb=80000&mp=2200?dob='+DOB+'&hv='+hv+'&
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        try {
            Http http = new Http();
            req.setHeader(Label.Scenario_client_id_label, Label.Scenario_client_id);
            req.setHeader(Label.Scenario_client_secret_Label, Label.Scenario_client_secret);
            req.setEndpoint(Label.Scenario_CashFlow_URL + '?ir=' + ir + '&mb=' + mb + '&mp=' + mp);
            req.setMethod('GET');
            res = http.send(req);
        } catch (exception e) {
            system.debug('getScenarioCashFlowResponse--Exception---' + e);
        }
        if (res.getStatusCode() == 200) {
            return res.getbody();
        } else {
            return null;
        }
    }
    @AuraEnabled
    public static List < Lead > fetchAccount(String searchKeyWord) {

        System.debug('searchKeyWord ' + searchKeyWord);
        String searchKey = searchKeyWord + '%';
        List <Lead> returnList = new List < Lead > ();
        try {
            // List <Client__c> lstOfAccount = [select Name, Id, Last_Name__c, State__c, Zip__c, Email_Optional__c,PartnerID__c,Phone_Number__c,Street_Address__c,DOB__c from Client__c where Name LIKE: searchKey and is_Active__c=true];
            Id Lead_rec_id = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Scenario Lead').getRecordTypeId();
            system.debug(Lead_rec_id);
            System.debug('searchKey ' + searchKey);

            List <Lead> lstOfAccount = [select id,Firstname,LastName,email,street,state,postalcode,phone,DOB__c from Lead where FirstName LIKE:searchKey and RecordTypeid = :Lead_rec_id and is_Active__c = true];

            for (Lead acc : lstOfAccount) {
                system.debug('__________>>>>>>>>>>><<<<<<<<<<<<<<<_________');
                system.debug(acc);
                returnList.add(acc);
            }
        } catch (exception e) {
            system.debug('fetchAccount--Exception---' + e);
        }
        return returnList;
    }
    @AuraEnabled
    public static Lead getClientDetails(ID ClientID) {
        Lead ClientRecord;
        try {
            Id Lead_rec_id = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Scenario Lead').getRecordTypeId();
            system.debug(Lead_rec_id);

            ClientRecord = [SELECT id,Firstname,LastName,email,street,state,postalcode,phone,DOB__c from Lead where id = :ClientID and RecordTypeid = :Lead_rec_id and is_Active__c = :true];//and is_Active__c=:true
        } catch (exception e) {
            system.debug('getClientDetails--Exception---' + e);
        }
        return ClientRecord;
    }

    @AuraEnabled
    public static id SaveScenario(Lead objClient, string Dob, decimal HV10yr, decimal hv, decimal mb,
            decimal mp, decimal ir, decimal Index, decimal Margin, decimal MIP, decimal IGR, decimal AGR,
            string Priority,
            decimal CF12MA, decimal CF60MA, decimal CFRMA, decimal CFRM, decimal secMN, string PieChartResponse,
            string BarChartResponse, decimal P_Limit, decimal lineOfCredit,
            String ScenarioType, String Scenario_Response,
            String cash1, string cash5, String cash10, String CaC, String MarginType, String CtoC, decimal Eofis, Scenario__c sce)
    {
        Logger.push('SaveScenario', 'lookUpController');
        Lead myLead = (Lead) objClient;
        System.debug('>>> ' + objClient);
        Scenario__c objScenario = new Scenario__c();
        String[] dates = Dob.split('-');
        String fnlDate = dates[1] + '/' + dates[2] + '/' + dates[0];
        if (test.isRunningTest()) {
            fnlDate = '1923/04/19';
        }
        myLead.PartnerID__c = userinfo.getuserid();
        Id Lead_rec_id = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Scenario Lead').getRecordTypeId();
        myLead.RecordTypeid = Lead_rec_id;
        myLead.Company = objClient.FirstName;
        try {
            date mydate = date.parse(fnlDate);

            myLead.DOB__c = mydate;
        } catch (exception ex) {
        }

        upsert myLead;
        system.debug('objClient ' + myLead);
        id cid = myLead.id;
        objScenario.Scenario_Type__c = ScenarioType;
        objScenario.Date_of_birth__c = myLead.DOB__c;
        objScenario.Home_Value_10_years__c = HV10yr;
        objScenario.Estimated_home_value__c = hv;
        objScenario.Current_Mortgage_Balance__c = mb;
        objScenario.Monthly_Mortgage_Payment__c = mp;
        objScenario.Current_Mortgage_Interest_Rate__c = ir;
        objScenario.Index__c = Index;
        objScenario.Margin__c = Margin;
        objScenario.MIP__c = MIP;
        objScenario.Initial_Growth_Rate__c = IGR;
        objScenario.Average_Growth_Rate__c = AGR;
        objScenario.Priority__c = Priority;
        objScenario.Cash_Flow_12_months_Amount__c = CF12MA;
        objScenario.Cash_Flow_60_months_Amount__c = CF60MA;
        objScenario.Cash_Flow_Remaining_months_Amount__c = CFRMA;
        objScenario.Cash_Flow_Remaining_Month__c = CFRM;
        objScenario.Cash_Flow_2_Month_Number__c = secMN;
        // objScenario.ClientId__c=objClient.id;
        //populate lead id in scenario
        objScenario.Client_Lead__c = objClient.id;
        objScenario.PartnerId__c = userinfo.getuserid();
        objScenario.BarChartResponse__c = BarChartResponse;
        objScenario.PieChartResponse__c = PieChartResponse;
        objScenario.Principal_Limit__c = P_Limit;
        objScenario.Line_of_Credit__c = lineOfCredit;//prsn
        objScenario.Scenario_Response__c = Scenario_Response;
        objScenario.CashFlow1__c = cash1;
        objScenario.CashFlow5__c = cash5;
        objScenario.CashFlow10__c = cash10;
        objScenario.Cash_at_close__c = CaC;
        objScenario.RateType__c = MarginType;
        objScenario.Cash_to_close__c = CtoC;
        objScenario.EOF__c = Eofis;
        //objScenario.Desired_Origination_for_Adjustable_Rate__c = ADOis;
        //New saved scenario fields - Bala
        objScenario.Desired_Origination_for_Adjustable_Rate__c = sce.Desired_Origination_for_Adjustable_Rate__c ;
        objScenario.Utilization__c = sce.Utilization__c ;//Decimal.valueOf(utilizationIs);
        objScenario.Unpaid_Principal_Balance__c = sce.Unpaid_Principal_Balance__c;
        objScenario.Total_Compensation__c = sce.Total_Compensation__c;
        objScenario.Amount_Available__c = sce.Amount_Available__c;
        objScenario.Funds_Needed_to_Close__c = sce.Funds_Needed_to_Close__c;
        objScenario.Other_Estimated_Closing_Costs__c = sce.Other_Estimated_Closing_Costs__c;
        objScenario.Funds_to_Close__c = sce.Funds_to_Close__c;
        objScenario.Age__c = sce.Age__c;
        objScenario.Origination_to_orm__c = sce.Origination_to_orm__c;
        objScenario.HeloMargin__c = sce.HeloMargin__c;
        //End fields Bala 
        insert objScenario;
        Logger.Pop();
        return objScenario.id;
    }

    /*SFDC-396*/
    @AuraEnabled
    public static string createAETask(id ScenarioID) {
        Logger.push('createAETask', 'lookUpController');
        Scenario__c objScenario = [
                SELECT id, Name
                FROM Scenario__c
                WHERE id = :ScenarioID
        ];
        user u = [SELECT contactId, contact.AccountId FROM user WHERE id = :userinfo.getUserId()];
        Task t = new Task();
        Account a = new Account();
        a = [SELECT name, Account_Executive_Name__c FROM Account WHERE id = :u.contact.AccountId];
        String accname = a.Name;
        t.Subject = +userinfo.getfirstname() + ' ' + userinfo.getLastName() + ' ' + 'from Account:' + ' ' + accname + ' ' + 'has requested a Scenario Package.';
        t.Status = 'Open';
        t.Priority = 'Normal';
        t.WhatId = a.Id;
        t.ActivityDate = Date.Today();
        t.OwnerId = a.Account_Executive_Name__c;
        t.WhoId = u.contactId;
        t.description = 'Scenario Url :'+Label.Scenario_link+objScenario.Id + '/view';
        insert t;
        Logger.pop();
        return t.Id;
    }

    //Send an Email to AE when Scenario Package is requested - Bala
    /**
     * *** KEY METHOD *****
     * @description Send Email To AE (But actually does more than just this. It performs callout to BayDocs and
     * saves Attachment
     * @param ScenarioID
     */
    @AuraEnabled
    public static void SendMailTMP(id ScenarioID) {
        Logger.push('SendMailTMP', 'lookUpController');

        Scenario__c objScenario = [
                SELECT id, Name,
                        Request_Scenario_Package_Count__c,
                        Client_Lead__r.Phone,
                        Client_Lead__r.PostalCode,
                        Client_Lead__r.FirstName,
                        Client_Lead__r.LastName,
                        Client_Lead__r.State,
                        Client_Lead__r.Street,
                        Client_Lead__r.DOB__c,
                        Client_Lead__r.Email,
                        Estimated_home_value__c,
                        Margin__c,
                        ORM_AE__c,
                        Current_Mortgage_Balance__c,
                        Current_Mortgage_Interest_Rate__c,
                        Monthly_Mortgage_Payment__c,
                        PartnerId__r.ContactId,
                        PartnerId__r.Contact.AccountId,
                        PartnerId__r.Contact.Account.Account_Executive_Name__r.Email,
                        PartnerId__r.Contact.Account.Account_Executive_Name__r.Username,
                        PartnerId__r.FirstName
                FROM Scenario__c
                WHERE id = :ScenarioID
        ];

        ScenarioExportUtil.ScenarioWithRelatedObjects scenarioExport = ScenarioExportUtil.getExportForscenarioId(ScenarioID);
        ScenarioChannelClient.sendEvent('LoanAppSubmitted', scenarioExport, ScenarioID);
        string scenName = objScenario.Name;
        string Link ='<a href='+Label.Scenario_link+ScenarioID+Label.account_link2+'>'+scenName+'</a>';   
        DateTime DT1 = objScenario.Client_Lead__r.DOB__c;
        DateTime DT = DT1.addDays(1);//SFDC-584
        string ClientDOB = DT.format('MM/dd/yyyy');
        string Email_Temp = objScenario.Client_Lead__r.Email;
        if (Email_Temp == null || Email_Temp == '')
            Email_Temp = '';
        string Phone_Number = objScenario.Client_Lead__r.Phone;
        if (Phone_Number == null || Phone_Number == '') {
            Phone_Number = '';
        } else {
            Phone_Number = FormatPhone(Phone_Number);
        }

        // Send Scenario Package to AE
        if (objScenario!=null && objScenario.PartnerId__r.Contact.Account.Account_Executive_Name__r.Email != null){

            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            List<String> sendTo = new List<String>();

            // Start Send Email to AE
            String getUserEmailID = objScenario.PartnerId__r.Contact.Account.Account_Executive_Name__r.Email;
            String getUsername = objScenario.PartnerId__r.Contact.Account.Account_Executive_Name__r.Username;
            sendTo.add(objScenario.PartnerId__r.Contact.Account.Account_Executive_Name__r.Email);
            mail.setToAddresses(sendTo);
            mail.setReplyTo(getUserEmailID);
            mail.setSubject('Request for Scenario Package.');
            String body;

            body = '<html><body><div>Hello ' + objScenario.ORM_AE__c + ',</div><div><br></br></div><div>' + objScenario.PartnerId__r.FirstName + ' Requested the calculation Package.</div><div><br></br></div>';
            body += '<table> <tr><td></td><td></td></tr><tr> <td> Name : </td>';
            body += '<td>' + objScenario.Client_Lead__r.LastName + '  ' + objScenario.Client_Lead__r.FirstName + '</td> </tr> <tr> <td>Address : </td>';
            body += '<td>' + objScenario.Client_Lead__r.Street + '  ' + objScenario.Client_Lead__r.State + '  ' + objScenario.Client_Lead__r.PostalCode + '</td> </tr> <tr> <td> Phone : </td>';
            body += '<td>' + Phone_Number + '</td> </tr><tr> <td> Date of Birth : </td>';
            body += '<td>' + ClientDOB + '</td> </tr><tr> <td> Email : </td>';
            body += '<td>' + Email_Temp + '</td> </tr><tr> <td> Home value: </td>';
            body += '<td>$' + objScenario.Estimated_home_value__c.format() +'.00'+ '</td> </tr><tr> <td> Mortgage Balance: </td>';
            body += '<td>$' + objScenario.Current_Mortgage_Balance__c.format() +'.00'+ '</td> </tr><tr> <td> Current Interest Rate : </td>';
            body += '<td>' + objScenario.Current_Mortgage_Interest_Rate__c + '%</td> </tr><tr> <td>Current Mortgage Payment: </td>';
            body += '<td>$' + objScenario.Monthly_Mortgage_Payment__c + '</td> </tr><tr> <td>Margin : </td>';
            body += '<td>' + objScenario.Margin__c + '%</td> </tr><tr> <td>Scenario : </td>';
            body += '<td>' + Link + '</td> </tr> <tr><td colspan="1"></td></tr> <td colspan="1"></td><br/></tr> <tr> <td colspan="1">Thanks, </td> </tr> <tr>';
            body += '<td colspan="1">' + getUsername + '</td> </tr>';
            body += ' </table> </body> </html>';
            mail.setHtmlBody(body);
            mails.add(mail);
            Messaging.sendEmail(mails);
        }
        Logger.pop();
    }

    /**
     * @description FormatPhone
     * @param Phone string
     * @return String
     * @todo Move into shared/common util class
     */
    public static String FormatPhone(String Phone) {
        Logger.push('FormatPhone','lookupController');
        try {
            string nondigits = '[^0-9]';
            string PhoneDigits;

            // remove all non numeric
            PhoneDigits = Phone.replaceAll(nondigits, '');

            // 10 digit: reformat with dashes
            if (PhoneDigits.length() == 10)
                return PhoneDigits.substring(0, 3) + '-' +
                        PhoneDigits.substring(3, 6) + '-' +
                        PhoneDigits.substring(6, 10);
        } catch (exception e) {
            Logger.debugException(e);
        }
        Logger.pop();
        return(Phone);
    }

    @AuraEnabled
    public static CashFlowResponse getCashFlowData(decimal MonthlyAssetIncome,
            decimal MonthlyIncome,
            decimal MonthlyExpense,
            decimal MonthlyPropertyCharge,
            decimal MonthlyMaintenance,
            String senarioid,
            integer Household_Members) {
        CashFlowResponse Responseobj = new CashFlowResponse();        
        String state = [select id,ClientId__r.Client_State__c,Client_Lead__r.State from Scenario__c where id = :senarioid].Client_Lead__r.State;//ClientId__r.Client_State__c;
        //For CashFlow
        //1st Start
        MonthlyMaintenance = MonthlyMaintenance * 0.14;
        decimal MonthlyAsset_income;
        if (!Test.isRunningTest()) {
            MonthlyAsset_income = GetMonthlyAssetIncome(senarioid, MonthlyAssetIncome);
        } else {
            MonthlyAsset_income = 100;
        }        
        decimal Totalcashflow = ((MonthlyIncome.setScale(2, RoundingMode.HALF_UP) + MonthlyAsset_income.setScale(2, RoundingMode.HALF_UP)) - (MonthlyExpense.setScale(2, RoundingMode.HALF_UP) + MonthlyPropertyCharge.setScale(2, RoundingMode.HALF_UP) + MonthlyMaintenance.setScale(2, RoundingMode.HALF_UP)));

        system.debug('total MonthlyExpense ' + MonthlyExpense.setScale(2, RoundingMode.HALF_UP) + 'monthly maintence ' + MonthlyMaintenance.setScale(2, RoundingMode.HALF_UP) + ' monthly property charge' + MonthlyPropertyCharge.setScale(2, RoundingMode.HALF_UP) + '-->' + (MonthlyExpense.setScale(2, RoundingMode.HALF_UP) + MonthlyPropertyCharge.setScale(2, RoundingMode.HALF_UP) + MonthlyPropertyCharge.setScale(2, RoundingMode.HALF_UP)));
        system.debug('total monthly income --->' + (MonthlyIncome.setScale(2, RoundingMode.HALF_UP) + MonthlyAsset_income.setScale(2, RoundingMode.HALF_UP)));
        system.debug('MonthlyAsset_income' + MonthlyAsset_income.setScale(2, RoundingMode.HALF_UP));
        system.debug('MonthlyIncome' + MonthlyIncome.setScale(2, RoundingMode.HALF_UP));
        system.debug('MonthlyExpense' + MonthlyExpense.setScale(2, RoundingMode.HALF_UP));
        system.debug('MonthlyPropertyCharge' + MonthlyPropertyCharge.setScale(2, RoundingMode.HALF_UP));
        system.debug('MonthlyMaintenance' + MonthlyMaintenance.setScale(2, RoundingMode.HALF_UP));
        system.debug('Totalcashflow' + Totalcashflow);
        string CashFlow = SAL_CashFlowController.Get_FormatedValue(Totalcashflow);
        system.debug('CashFlown' + CashFlow);
        //1st end

        //2nd start
        string FamilySize;
        string StateRegion = SAL_CashFlowController.Get_StateRegion(state);
        system.debug('StateRegion' + StateRegion);
        if (Household_Members != null) {
            if (integer.valueof(Household_Members) > 3) {
                FamilySize = '4 or more';
            } else {
                FamilySize = '' + Household_Members;
            }
        }
        Decimal RequiredCashFlowValue;
        if (!test.isRunningTest()) {
            System.debug('StateRegion ' + StateRegion);

            System.debug('FamilySize ' + FamilySize);
            RequiredCashFlowValue = SAL_CashFlowController.Get_ResidualIncome(StateRegion, FamilySize);
        } else {
            RequiredCashFlowValue = 10;
        }
        //Decimal  RequiredCashFlow= RequiredCashFlowValue==0?1:RequiredCashFlowValue;
        Decimal RequiredCashFlow = RequiredCashFlowValue ;
        system.debug('RequiredCashFlow' + RequiredCashFlow);
        Responseobj.RequiredCashFlow = RequiredCashFlow;
        //2nd end

        //3rd
        decimal Capacity = ((Totalcashflow / RequiredCashFlow) * 100).setScale(2, RoundingMode.HALF_UP);
        system.debug('Capacity' + Capacity);
        string TotalCapacity = SAL_CashFlowController.Get_FormatedPercentage(Capacity);
        system.debug('TotalCapacity' + TotalCapacity);
        Responseobj.TotalCapacity = TotalCapacity;
        //3rd

        //4th start
        decimal CapacityStrg = (Totalcashflow - RequiredCashFlow).setScale(2, RoundingMode.HALF_UP);
        system.debug('CapacityStrg' + CapacityStrg);
        string CapacityStorage = SAL_CashFlowController.Get_FormatedValue(CapacityStrg);
        system.debug('CapacityStorage' + CapacityStorage);
        //4th end
        Responseobj.CapacityStorage = CapacityStorage;
        //For CashFlow
        Responseobj.CashFlow = CashFlow;
        system.debug(Responseobj);
        return Responseobj;
    }

    @AuraEnabled
    public static string getFNMData(Blob filedata, String fileName, String base64Data, String contentType, String applicationDate, String senario_id, integer hhm, integer sft) {
        String loanId = CreateLoanFromScenario.getFNMData(filedata, fileName, base64Data, contentType, applicationDate, senario_id);

        Scenario__c sn = [select id,is_Converted__c,Loan__c from Scenario__c where id = :senario_id];
        sn.is_Converted__c = true;
        sn.Loan__c = loanId;
        try {
            upsert sn;
        } catch (Exception ex) {
        }
        Loan_New__c ln = [select id,Household_Members__c,Square_Footage__c from Loan_New__c where id = :loanId];
        ln.Household_Members__c = '' + hhm;
        ln.Square_Footage__c = '' + sft;
        try {
            update ln;
        } catch (Exception ex) {
        }
        return loanId;
    }

    //SFDC - 567
    @AuraEnabled
    public Static Loan_New__c createLoan(String senarioid, Integer hhm, integer sft) {
        Logger.push('createLoan','lookupController');
        Loan_New__c ln = CreateLoanFromScenario.createLoan(senarioid);
        Scenario__c sn = [select id,is_Converted__c,Loan__c from Scenario__c where id = :senarioid];
        sn.is_Converted__c = true;
        sn.Loan__c = ln.id;
        upsert sn;
        ln.Household_Members__c = '' + hhm;
        ln.Square_Footage__c = '' + sft;

        try {
            if (!test.isRunningTest())
                update ln;
        } catch (exception ex) {
        }
        Logger.pop();
        return ln;        
    }

    //SFDC-566
    @AuraEnabled
    public static integer getPrintCount(Integer countval, String scenarioID){
       Scenario__c sn = [select id,Print_Count__c from Scenario__c where id = :scenarioID];
       sn.Print_Count__c = Integer.valueOf(countval);
       upsert sn;
       return null;
    }
    
    @AuraEnabled
    public static integer getcapacityCount(Integer runcounterval, String scenarioID){
       Scenario__c sn = [select id,Run_Capacity_Count__c from Scenario__c where id = :scenarioID];
       sn.Run_Capacity_Count__c = Integer.valueOf(runcounterval);
       upsert sn;
       return null;
    }
    
    public static decimal GetMonthlyAssetIncome(String senarioId, Decimal passedAsset) {
        Logger.push('GetMonthlyAssetIncome','lookupController');
        List<integer> DOBList = new List<integer>();
        List<date> FinalDOBList = new List<date>();
        integer LifeExpectancyYear;
        Integer LifeExpectancyAgeInMonth;
        decimal TotalAssetAgaintLoan;
        List<Scenario__c> sen = new List<Scenario__c> ();
        
        sen = [select ClientId__r.DOB__c,Client_Lead__r.DOB__c from Scenario__c where id = :senarioId];
        for (Scenario__c clientobj : sen) {
            //  date dob=clientobj.ClientId__r.DOB__c;
            date dob = clientobj.Client_Lead__r.DOB__c;
            if (null == dob && test.isRunningTest()) {
                dob = System.today();
                DOBList.add(100);
            }
            Date TodayDate = System.today();
            integer Age = (dob.monthsBetween(TodayDate) / 12);
            if (Age > 61) {
                DOBList.add(Age);
            }
        }
        system.debug('Before DOBList' + DOBList);
        DOBList.sort();
        system.debug('fter DOBList' + DOBList);
        integer ClientAge = DOBList.get(0);
        system.debug('No of years ' + ClientAge);
        if (ClientAge >= 95) {
            LifeExpectancyYear = 3;
        } else {
            LifeExpectancyYear = SAL_CashFlowController.GetLifeExpectancyYearValue(ClientAge);
        }
        system.debug('LifeExpectancyYear' + LifeExpectancyYear);
        //number of months the client has until their life expectancy age
        LifeExpectancyAgeInMonth = LifeExpectancyYear * 12;
        system.debug('LifeExpectancyAgeInMonth' + LifeExpectancyAgeInMonth);
        TotalAssetAgaintLoan = passedAsset * 0.85;
        system.debug('TotalAssetAgaintLoan' + TotalAssetAgaintLoan);
        system.debug('TotalAssetAgaintLoan/LifeExpectancyAgeInMonth  -->' + TotalAssetAgaintLoan / LifeExpectancyAgeInMonth);
        Logger.pop();
        return TotalAssetAgaintLoan / LifeExpectancyAgeInMonth;
    }
    public static void doUpdateCount() {
        try {
            user usr = [select contactId,Contact.Accountid,Id from user where id = :userinfo.getUserId() limit 1];
            Integer countOfRunScenario = [select count() from RunScenario__c where Business_individual__c = :usr.contactId];
            if (countOfRunScenario != 0) {
                RunScenario__c RS = [select id,Scenarios_Run__c from RunScenario__c where Business_individual__c = :usr.contactId];
                RS.Scenarios_Run__c = RS.Scenarios_Run__c + 1;
                update RS;
            } else {
                RunScenario__c NRS = new RunScenario__c();
                NRS.Business_individual__c = usr.contactId;
                NRS.Scenarios_Run__c = 1;
                Insert NRS;
            }
        } catch (exception ex) {System.debug('>>>> exception ' + ex);}
    }

    @AuraEnabled
    public static list< map<string, map<string, String>>> get_metadataValues(String Tieris) { 
        //Bala - Added Tier1, Tier2 in the backend Calculator, added Helo metadata
        Logger.push('get_metadataValues','lookupController');
        list< map<string, map<string, String>>> data = new list< map<string, map<string, String>>>();
        String MetaDataTable = '';
        String MetaDataTableFixed = '';
        String MetaDataTableHelo = '';

        boolean isCommunityUser = true;
        user u = [select id,ContactId from user where id = :userinfo.getUserId()];
        if (u.ContactId != null) {
            isCommunityUser = true;
        } else {
            isCommunityUser = false;
        }

        //try{
        if (isCommunityUser) {
            //Start SFDC - 289
            String partnerType = [select id,Contact.AccountId,Contact.Account.Partner_Type__c from user where id=:userinfo.getUserId()].Contact.Account.Partner_Type__c;
            if(partnerType == 'Non Premier'){
                MetaDataTable = 'Tier1__mdt';
                MetaDataTableFixed = 'Fixed_Price_Tier1__mdt';
                MetaDataTableHelo = 'Proprietary_Tier_1__mdt';
            }
            else if(partnerType == 'Premier'){
                MetaDataTable = 'Tier2__mdt';
                MetaDataTableFixed = 'Fixed_Price_Tier2__mdt';
                MetaDataTableHelo = 'Proprietary_Tier_2__mdt';
            }
            else if(partnerType == 'Premier Plus'){
                MetaDataTable = 'Tier3__mdt';
                MetaDataTableFixed = 'Fixed_Price_Tier3__mdt';
                MetaDataTableHelo = 'Proprietary_Tier_3__mdt';
            }
        } else {
            //new 9/20 need to update tier 3 in the backend calc ToDo
            if(Tieris == 'Tier1'){
                MetaDataTable = 'Tier1__mdt';
                MetaDataTableFixed = 'Fixed_Price_Tier1__mdt';
                MetaDataTableHelo = 'Proprietary_Tier_1__mdt';
            }
            else if(Tieris == 'Tier2'){
                MetaDataTable = 'Tier2__mdt';
                MetaDataTableFixed = 'Fixed_Price_Tier2__mdt';
                MetaDataTableHelo = 'Proprietary_Tier_2__mdt';
            }
            else if(Tieris == 'Tier3'){
                MetaDataTable = 'Tier3__mdt';
                MetaDataTableFixed = 'Fixed_Price_Tier3__mdt';
                MetaDataTableHelo = 'Proprietary_Tier_3__mdt';
            }
        }//end SFDC - 289
        data.add(get_metadata.get_tierData(MetaDataTable));
        data.add(get_metadata.get_tierData_fixed(MetaDataTableFixed));
        system.debug('helo metadata ' + get_metadata.get_tierData_Helo(MetaDataTableHelo));
        data.add(get_metadata.get_tierData_Helo(MetaDataTableHelo));
        Logger.pop();
        return data;
    }

    @AuraEnabled
    public static List<string> getZipData(string ZIP) {
        List<string> ob = new List<string>();
        //ob= zipCode.lookup(ZIP);
        ob = zipCodeLookup.lookup(ZIP);
        System.debug('>>>>>>>>>>>>>> obobobobobob ' + ob);
        return ob;
    }

    //start SFDC - 275
    @AuraEnabled
    public static list<String> get_states() {
        list<String> states = new list<String>();
        for (AuthorisedStates__mdt each : [SELECT Id, DeveloperName, MasterLabel, Label FROM AuthorisedStates__mdt
                                           WHERE isActive__c=:true and isRefinance__c=:true]) {
            states.add(each.MasterLabel);
        }
        return states;
    }

    @AuraEnabled
    public static list<String> get_statesPur() {
        list<String> states = new list<String>();
        for (AuthorisedStates__mdt each : [SELECT Id, DeveloperName, MasterLabel, Label FROM AuthorisedStates__mdt 
                                           WHERE isActive__c=:true and isPurchase__c=:true]) {
            states.add(each.MasterLabel);
        }
        return states;
    }

    @AuraEnabled
    public static list<String> get_helostatesRefi() {
        system.debug('helo1');
        list<String> states = new list<String>();
        for (HeloState__mdt each : [SELECT MasterLabel FROM HeloState__mdt
                                    WHERE isActive__c=:true and isRefinance__c=:true]) {
            states.add(each.MasterLabel);
        }
        return states;
    }

    @AuraEnabled
    public static list<String> get_heloStatesPur() {
        system.debug('helo2');
        list<String> states = new list<String>();
        for (HeloState__mdt each : [SELECT MasterLabel FROM HeloState__mdt 
                                    WHERE isActive__c=:true and isPurchase__c=:true]) {
            states.add(each.MasterLabel);
        }
        return states;
    }
    //SFDC - 275 end

    @AuraEnabled
    public static void sendEmailAfterBaydocsAdded(String ScenarioID) { //@TODO need to remove this method
    }

    @AuraEnabled
    public static String getScenariData(String dob, String ev, String pm, String ADOValIs, String Tieris) { //SFDC - 289 added new string Tieris
        Logger.push('getScenariData','lookupController');
        System.debug('>>>> dob ' + dob);
        System.debug('>>>> ev ' + ev);
        System.debug('>>>> pm ' + pm);
        integer i_ev = Integer.valueOf(ev);
        //HUD calculation
        decimal firstValue = 0;// = (200000 * 0.02);
        decimal secondValue = 0;
        if (i_ev <= 200000) {
            firstValue = (i_ev * 0.02);

        } else {
            //if i_ev >200K
            firstValue = (200000 * 0.02);
            secondValue = ((i_ev - 200000) * 0.01);

        }
        decimal HUDis = firstValue + secondValue;
        HUDis = (HUDis > 6000) ? 6000 : HUDis;
        String endpoint = system.label.scenario;
        Http h = new Http();

        Httprequest req = new Httprequest();
        req.setEndpoint(endpoint);

        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        if (pm != '') {
            gen.writeStringField('UserCode', system.label.usercode);
            gen.writeStringField('PassCode', system.label.passcode);
            gen.writeStringField('BorrowerBirthdate', dob);
            gen.writeStringField('EstimatedValue', ev);
            gen.writeStringField('PresentMortgage', pm);
            gen.writeStringField('DesiredOriginationFee', ADOValIs);
        } else {
            gen.writeStringField('UserCode', system.label.usercode);
            gen.writeStringField('PassCode', system.label.passcode);
            gen.writeStringField('BorrowerBirthdate', dob);
            gen.writeStringField('PurchasePrice', ev);
            gen.writeStringField('DesiredOriginationFee', ADOValIs);
        }
        //write metadata rate and Originaed orm fee ino JSON String
        //Start SFDC - 289
        boolean isCommunityUser = true;
        user u = [select id,ContactId from user where id = :userinfo.getUserId()];
        if (u.ContactId != null) {
            isCommunityUser = true;
        } else {
            isCommunityUser = false;
        }
        String MetaDataTableFixed = '';
        if(isCommunityUser){
            String partnerType = [select id,Contact.AccountId,Contact.Account.Partner_Type__c from user where id=:userinfo.getUserId()].Contact.Account.Partner_Type__c;
            
            if(partnerType == 'Non Premier'){                
                MetaDataTableFixed = 'Fixed_Price_Tier1__mdt';                
            }
            else if(partnerType == 'Premier'){
                MetaDataTableFixed = 'Fixed_Price_Tier2__mdt';
            }
            else if(partnerType == 'Premier Plus'){
                MetaDataTableFixed = 'Fixed_Price_Tier3__mdt';
            }
        }
        else{
            if(Tieris == 'Tier1'){                
                MetaDataTableFixed = 'Fixed_Price_Tier1__mdt';
            }
            else if(Tieris == 'Tier2'){
                MetaDataTableFixed = 'Fixed_Price_Tier2__mdt';
            }
            else if(Tieris == 'Tier3'){
                MetaDataTableFixed = 'Fixed_Price_Tier3__mdt';
            }
        }
        //end SFDC - 289
        String metadataQuery = 'SELECT Id, DeveloperName,  Origination_to_ORM__c, Rate__c FROM ' + MetaDataTableFixed;
        gen.writeFieldName('origFees');
        gen.writeStartObject();

        list<sObject>metadataResults = database.query(metadataQuery);
        for (sObject eachsObject : metadataResults) {
            decimal mapingValue = (HUDis < Decimal.valueOf(String.valueOf(eachsObject.get('Origination_to_ORM__c')))) ? HUDis : Decimal.valueOf(String.valueOf(eachsObject.get('Origination_to_ORM__c')));            
            Decimal keyIs = Decimal.valueOf(String.valueOf(eachsObject.get('Rate__c'))).setScale(2);
            Decimal roundedkeyIs = Math.round(keyIs * 100) / 100.0;
            system.debug(roundedkeyIs);

            gen.writeObjectField(String.valueOf(roundedkeyIs), Decimal.valueOf(String.valueOf(mapingValue)).setScale(2));
            system.debug('t ->' + Decimal.valueOf(String.valueOf(mapingValue)).setScale(2));
            system.debug('s  -> ' + Decimal.valueOf(String.valueOf(eachsObject.get('Rate__c'))).setScale(2));
        }
        gen.writeEndObject();
        gen.writeEndObject();

        String pretty = gen.getAsString();
        System.debug('>>>>> HUDis ' + HUDis);
        system.debug('reques is  -->' + pretty);
        req.setBody(pretty);
        //yyy/mm/dd
        req.setMethod('POST');
        Httpresponse res = new Httpresponse();
        if (!test.isRunningTest()) {
            res = h.send(req);
            System.debug('>>>>> ' + res.getBody());
            doUpdateCount();
            return res.getBody();
        }
        Logger.pop();
        return null;
    }
}
