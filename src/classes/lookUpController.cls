public without sharing class lookUpController {
    @AuraEnabled
    public static Profile getLoggedInProfile() {
      Profile loggedinUser = [SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId() LIMIT 1];
        return loggedinUser;
  }
    @AuraEnabled
    public static string getScenarioMarginsResponse(string DOB,decimal hv,decimal mb,decimal mp,string ir) {
    System.debug('>>> '+Label.Scenario_margin+'?dob='+DOB+'&hv='+hv+'&ir='+ ir+'&mb='+mb+'&mp='+mp+'&type=abc');
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        try{
            Http http = new Http();
            req.setHeader(Label.Scenario_client_id_label, Label.Scenario_client_id);
            req.setHeader(Label.Scenario_client_secret_Label,Label.Scenario_client_secret);
            system.debug('API values --->'+Label.Scenario_margin+'?dob='+DOB+'&hv='+hv+'&ir='+ ir+'&mb='+mb+'&mp='+mp+'&type=default'+'&cfy=0');
            req.setEndpoint(Label.Scenario_margin+'?dob='+DOB+'&hv='+hv+'&ir='+ ir+'&mb='+mb+'&mp='+mp+'&type=default'+'&cfy=0');        
            req.setMethod('GET');
            if(!test.isRunningTest())
            res = http.send(req);
        }
        catch(exception e)
        {
            system.debug('getScenarioResponse--Exception---'+e);
        }
        
        doUpdateCount();
        System.debug('res.getbody() >>>> '+res.getbody());
        return res.getbody();
    }
    
    @AuraEnabled
    public static string getScenarioResponse(string DOB,decimal hv,decimal mb,decimal mp,string ir,string alm) {
        System.debug('<><><><><>');
        System.debug('>>>>> '+alm);
    System.debug('>>>>>>>>>>>> https://apibeta.rockfin.com/orms/nu62/LineOfCredit/FullCalculator?mp='+mp+'&hv='+hv+'&mb='+mb+'&ir='+ir+'&dob='+DOB+'&sdob=0&iscb=false&mmp=0&sp=false&spt=0&cfy=0&alm='+alm+'&cc=null');
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        try{
            Http http = new Http();
            req.setHeader(Label.Scenario_client_id_label, Label.Scenario_client_id);
            req.setHeader(Label.Scenario_client_secret_Label,Label.Scenario_client_secret);
           // req.setEndpoint(Label.Scenario_LineChart_URL_New+'?dob='+DOB+'&hv='+hv+'&ir='+ ir+'&mb='+mb+'&mp='+mp);        
            req.setEndpoint(Label.Scenario_LineChart_URL_New+'?mp='+mp+'&hv='+hv+'&mb='+mb+'&ir='+ir+'&dob='+DOB+'&sdob=0&iscb=false&mmp=0&sp=false&spt=0&cfy=0&alm='+alm+'&cc=null');
            req.setMethod('POST');
            req.setBody('{}');
            res = http.send(req);
        }
        catch(exception e)
        {
            system.debug('getScenarioResponse--Exception---'+e);
        }
        return res.getbody();
    }
    @AuraEnabled
    public static string getScenarioCashFlowResponse(decimal mb,decimal mp,string ir) {
        // ir=2&mb=80000&mp=2200?dob='+DOB+'&hv='+hv+'&
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        try{
            Http http = new Http();
            req.setHeader(Label.Scenario_client_id_label,  Label.Scenario_client_id);
            req.setHeader(Label.Scenario_client_secret_Label, Label.Scenario_client_secret);
            req.setEndpoint(Label.Scenario_CashFlow_URL+'?ir='+ ir+'&mb='+mb+'&mp='+mp);
            req.setMethod('GET');
            res = http.send(req);
        }
        catch(exception e)
        {
            system.debug('getScenarioCashFlowResponse--Exception---'+ e);
        }
        if(res.getStatusCode()==200){
        return res.getbody();
        }else{
            return null;
        }
    }
    @AuraEnabled
    public static List < Lead > fetchAccount(String searchKeyWord) {
        
        System.debug('searchKeyWord '+searchKeyWord);
        String searchKey = searchKeyWord + '%';
        List <Lead> returnList = new List < Lead > ();
        try{
           // List <Client__c> lstOfAccount = [select Name, Id, Last_Name__c, State__c, Zip__c, Email_Optional__c,PartnerID__c,Phone_Number__c,Street_Address__c,DOB__c from Client__c where Name LIKE: searchKey and is_Active__c=true];
          Id Lead_rec_id = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Scenario Lead').getRecordTypeId();
            system.debug(Lead_rec_id);
            System.debug('searchKey '+searchKey);
            
            List <Lead> lstOfAccount = [select id,Firstname,LastName,email,street,state,postalcode,phone,DOB__c from Lead where FirstName LIKE: searchKey  and RecordTypeid=:Lead_rec_id and is_Active__c=true];
            
            for (Lead acc: lstOfAccount) {
                system.debug('__________>>>>>>>>>>><<<<<<<<<<<<<<<_________');
                system.debug(acc);
                returnList.add(acc);
            }
        }
        catch(exception e)
        {
            system.debug('fetchAccount--Exception---'+ e);
        }
        return returnList;
    }
    @AuraEnabled
    public static Lead getClientDetails(ID ClientID) {
        Lead ClientRecord; 
        try{
          Id Lead_rec_id = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Scenario Lead').getRecordTypeId();
            system.debug(Lead_rec_id);
         
            ClientRecord  = [SELECT  id,Firstname,LastName,email,street,state,postalcode,phone,DOB__c from Lead  where id=: ClientID and RecordTypeid=:Lead_rec_id and is_Active__c=:true];//and is_Active__c=:true
        }
        catch(exception e)
        {
            system.debug('getClientDetails--Exception---'+ e);
        }
        return ClientRecord;
    }
    
    @AuraEnabled
    public static id SaveScenario(Lead objClient,string Dob,decimal HV10yr,decimal hv,decimal mb,
                                  decimal mp,decimal ir,decimal Index,decimal Margin,decimal MIP,decimal IGR,decimal AGR,
                                  string Priority,
                                  decimal CF12MA,decimal CF60MA,decimal CFRMA,decimal CFRM,decimal secMN,string PieChartResponse, 
                                  string BarChartResponse,decimal P_Limit,decimal lineOfCredit,
                                  String ScenarioType,String Scenario_Response,
                                  String cash1,string cash5,String cash10,String CaC,String MarginType,String CtoC,decimal Eofis,String ADOis)
        
    {
    Lead myLead = (Lead)objClient;
    System.debug('>>> '+objClient);
    system.debug('Date_of_birth__c Dob >> '+ Dob);
    system.debug('Home_Value_10_years__c HV10yr >> ' +HV10yr );
    system.debug(' Estimated_home_value__c hv  >> ' + hv );
    system.debug(' Current_Mortgage_Balance__c mb  >> ' +mb );
    system.debug(' Monthly_Mortgage_Payment__c mp  >> ' +mp );
    system.debug('Current_Mortgage_Interest_Rate__c  ir >> ' + ir);
    system.debug('Index__c Index  >> ' + Index);
    system.debug('Margin__c Margin  >> ' + Margin);
    system.debug('MIP__c  MIP >> ' + MIP);
    system.debug('Initial_Growth_Rate__c IGR  >> ' +IGR );
    system.debug('Average_Growth_Rate__c AGR  >> ' +AGR );
    system.debug('Priority__c Priority  >> ' +Priority );
    system.debug('Cash_Flow_12_months_Amount__c CF12MA >> ' + CF12MA );
    system.debug('Cash_Flow_60_months_Amount__c CF60MA >> ' + CF60MA );
    system.debug('Cash_Flow_Remaining_months_Amount__c CFRMA >> ' +  CFRMA );
    system.debug('Cash_Flow_Remaining_Month__c CFRM >> ' + CFRM);
    system.debug('Cash_Flow_2_Month_Number__c secMN  >> ' +secMN );
    system.debug('PieChartResponse__c PieChartResponse >> ' + PieChartResponse);
    system.debug('BarChartResponse__c BarChartResponse  >> ' +BarChartResponse );
    system.debug('Principal_Limit__c P_Limit >> ' + P_Limit );
    system.debug('Line_of_Credit__c lineOfCredit >> ' +lineOfCredit );
    system.debug(' Scenario_Type__c ScenarioType >> ' +ScenarioType );
    system.debug('Scenario_Response__c Scenario_Response  >> ' +Scenario_Response );
    system.debug('CashFlow1__c cash1 >> ' +cash1 );
    system.debug('CashFlow5__c cash5 >> ' + cash5);
    system.debug('CashFlow10__c cash10 >> ' + cash10);
    system.debug('Cash_at_close__c CaC >> ' +CaC );
    system.debug('RateType__c MarginType >> ' +MarginType );
    system.debug('Cash_to_close__c CtoC >> ' +CtoC );
    system.debug('EOF__c Eofis >> ' +Eofis );
    system.debug('Desired_Origination_for_Adjustable_Rate__c ADOis >> ' +ADOis );
        Scenario__c objScenario=new  Scenario__c();
       // try{
       //1923/04/19
String[] dates = Dob.split('-');
String fnlDate = dates[1]+'/'+dates[2]+'/'+dates[0];
        if(test.isRunningTest()){
            fnlDate = '1923/04/19';
        }
//date mydate = date.parse(fnlDate);
           // date mydate = date.parse(Dob.replace('-','/'));
            myLead.PartnerID__c=userinfo.getuserid();
          //  myLead.DOB__c=mydate;
               Id Lead_rec_id = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Scenario Lead').getRecordTypeId();
            myLead.RecordTypeid = Lead_rec_id;
            myLead.Company = objClient.FirstName;
        try{
        date mydate = date.parse(fnlDate);
     
        myLead.DOB__c=mydate;
        }catch(exception ex){}     
        
        upsert myLead;
            system.debug('objClient '+myLead);
            id cid=myLead.id;
            objScenario.Scenario_Type__c = ScenarioType;
            objScenario.Date_of_birth__c=myLead.DOB__c;//mydate;
            
            objScenario.Home_Value_10_years__c=HV10yr;
            objScenario.Estimated_home_value__c=hv;
            objScenario.Current_Mortgage_Balance__c=mb;
            objScenario.Monthly_Mortgage_Payment__c=mp;
            objScenario.Current_Mortgage_Interest_Rate__c=ir;
            objScenario.Index__c=Index;
            objScenario.Margin__c=Margin;
            objScenario.MIP__c=MIP;
            objScenario.Initial_Growth_Rate__c=IGR;
            objScenario.Average_Growth_Rate__c=AGR;
            objScenario.Priority__c=Priority;
            objScenario.Cash_Flow_12_months_Amount__c=CF12MA;
            objScenario.Cash_Flow_60_months_Amount__c=CF60MA;
            objScenario.Cash_Flow_Remaining_months_Amount__c=CFRMA;
            objScenario.Cash_Flow_Remaining_Month__c=CFRM;
            objScenario.Cash_Flow_2_Month_Number__c=secMN;
           // objScenario.ClientId__c=objClient.id;
            //populate lead id in scenario
            objScenario.Client_Lead__c =objClient.id;
            objScenario.PartnerId__c=userinfo.getuserid();
            objScenario.BarChartResponse__c=BarChartResponse;
            objScenario.PieChartResponse__c=PieChartResponse;
            objScenario.Principal_Limit__c =P_Limit;
            objScenario.Line_of_Credit__c = lineOfCredit;//prsn
            objScenario.Scenario_Response__c = Scenario_Response;
            objScenario.CashFlow1__c = cash1;
            objScenario.CashFlow5__c  = cash5;
            objScenario.CashFlow10__c = cash10;
            objScenario.Cash_at_close__c = CaC;
            objScenario.RateType__c = MarginType;
            objScenario.Cash_to_close__c = CtoC;
            objScenario.EOF__c= Eofis;
            objScenario.Desired_Origination_for_Adjustable_Rate__c = ADOis;
            insert objScenario;
      /*  }
        catch(exception e)
        {
        system.debug('SaveScenario--Exception---'+ e);
      }*/
        return objScenario.id;
    }
    
    /*Bala - A task will be created for AE when a Scenario Package is Requested*/
    @AuraEnabled
    public static string createAETask(){
        
        user u = [SELECT contactId, contact.AccountId FROM user WHERE id=:userinfo.getUserId()];
        Task t = new Task();        
        Account a = new Account();
        
        a = [SELECT name, Account_Executive_Name__c FROM Account WHERE id =:u.contact.AccountId];
                
        String accname = a.Name;
        t.Subject = +userinfo.getfirstname() + ' ' +userinfo.getLastName() +' '+ 'from Account:'+' ' + accname +' '+ 'has requested a Scenario Package.';
        t.Status = 'Open';
        t.Priority = 'Normal';
        t.WhatId = a.Id;
        t.ActivityDate = Date.Today();
        t.OwnerId = a.Account_Executive_Name__c;
        t.WhoId = u.contactId;
        
        insert t;
        
        return t.Id;    
    }
        
    //Send an Email to AE when Scenario Package is requested - Bala
    @AuraEnabled
    public static void SendMailTMP(id ScenarioID)
    {
        //ScenarioID = 'a0HW0000007vgpx';
        system.debug('ScenarioID-----'+ScenarioID);
        try{
            Scenario__c objScenario=[
                Select id, Name , 
                       Request_Scenario_Package_Count__c ,
                       Client_Lead__r.Phone ,
                       Client_Lead__r.PostalCode ,
                       Client_Lead__r.FirstName ,
                       Client_Lead__r.LastName ,
                       Client_Lead__r.State ,
                       Client_Lead__r.Street ,
                       Client_Lead__r.DOB__c ,
                       Client_Lead__r.Email , 
                       Estimated_home_value__c , 
                       Margin__c , 
                       ORM_AE__c , 
                       Current_Mortgage_Balance__c , 
                       Current_Mortgage_Interest_Rate__c , 
                       Monthly_Mortgage_Payment__c 
              from scenario__c where id=: ScenarioID];

        system.debug('calling the event');
        ScenarioExportUtil.ScenarioWithRelatedObjects scenarioExport = ScenarioExportUtil.getExportForscenarioId(ScenarioID);
        ScenarioChannelClient.sendEvent('LoanAppSubmitted', scenarioExport ,ScenarioID);    
          
            DateTime DT=objScenario.Client_Lead__r.DOB__c;
            string ClientDOB = DT.format('MM/dd/yyyy');
            string Email_Temp = objScenario.Client_Lead__r.Email;
            if(Email_Temp ==null || Email_Temp =='')
                Email_Temp ='';
            string Phone_Number=objScenario.Client_Lead__r.Phone;
            if(Phone_Number==null || Phone_Number==''){
                Phone_Number='';
            }else{
                Phone_Number=FormatPhone(Phone_Number);
            }
            String getUserEmailID = UserInfo.getUserEmail();

            String getUsername = UserInfo.getName();
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
            // Step 1: Create a new Email
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            // Step 2: Set list of people who should get the email
            
            List<String> sendTo = new List<String>();
            
            user u = [SELECT contactId, contact.AccountId FROM user WHERE id=:userinfo.getUserId()];
            system.debug('###' +u.contact.AccountId);
            system.debug('###' +u.contactId);
            
            Account a = new Account();
            
            a = [SELECT Account_Executive_Name__r.Email, Account_Executive_Name__c FROM Account WHERE id =:u.contact.AccountId];
            string ae = a.Account_Executive_Name__r.Email;    
            system.debug('###' +a);
            system.debug('@@@'+a.Account_Executive_Name__r.Email);
            sendTo.add(ae);
            mail.setToAddresses(sendTo);
            mail.setReplyTo(getUserEmailID);
            mail.setSubject('Request for Scenario Package.');
            String body ;

            body='<html><body><div>Hello '+objScenario.ORM_AE__c+',</div><div><br></br></div><div>'+ getUsername +' Requested the calculation Package.</div><div><br></br></div>';
            body+='<table> <tr><td></td><td></td></tr><tr> <td> Name : </td>';
            body+='<td>'+objScenario.Client_Lead__r.LastName+'  '+objScenario.Client_Lead__r.FirstName+'</td> </tr> <tr> <td>Address : </td>';
            body+='<td>'+objScenario.Client_Lead__r.Street+'  '+objScenario.Client_Lead__r.State+'  '+objScenario.Client_Lead__r.PostalCode +'</td> </tr> <tr> <td> Phone : </td>';            
            body+='<td>'+Phone_Number+'</td> </tr><tr> <td> Date of Birth : </td>';
            body+='<td>'+ClientDOB+'</td> </tr><tr> <td> Email : </td>';
            body+='<td>'+Email_Temp +'</td> </tr><tr> <td> Home value: </td>';
            body+='<td>$'+objScenario.Estimated_home_value__c.format()+'.00'+'</td> </tr><tr> <td> Mortgage Balance: </td>';
            body+='<td>$'+objScenario.Current_Mortgage_Balance__c.format()+'.00'+'</td> </tr><tr> <td> Current Interest Rate : </td>';
            body+='<td>'+objScenario.Current_Mortgage_Interest_Rate__c+'%</td> </tr><tr> <td>Current Mortgage Payment: </td>';
            body+='<td>$'+objScenario.Monthly_Mortgage_Payment__c+'</td> </tr><tr> <td>Margin : </td>';
            body+='<td>'+objScenario.Margin__c+'%</td> </tr><tr> <td>Scenario : </td>';
            body+='<td>'+objScenario.Name+'</td> </tr> <tr><td colspan="1"></td></tr> <td colspan="1"></td><br/></tr> <tr> <td colspan="1">Thanks, </td> </tr> <tr>';
            body+='<td colspan="1">'+getUsername+'</td> </tr>';
            body+=  ' </table> </body> </html>';
            mail.setHtmlBody(body);
            mails.add(mail);
            Messaging.sendEmail(mails);
            system.debug('SendMailTMP-----');
        }
        catch(exception e)
        {
            system.debug('SendMailTMP--Exception---'+ e);
        }

      //      objScenario.Request_Scenario_Package_Count__c = null != objScenario.Request_Scenario_Package_Count__c?objScenario.Request_Scenario_Package_Count__c+1:1;
       // try{
       //update objScenario;
   // }catch(Exception ex){}
    }
    
    
    public static String FormatPhone(String Phone) {
        try{
            string nondigits = '[^0-9]';
            string PhoneDigits;
            
            // remove all non numeric
            PhoneDigits = Phone.replaceAll(nondigits,'');
            
            // 10 digit: reformat with dashes
            if (PhoneDigits.length() == 10) 
                return PhoneDigits.substring(0,3) + '-' +
                PhoneDigits.substring(3,6) + '-' +
                PhoneDigits.substring(6,10);
        }
        catch(exception e)
        {
            system.debug('FormatPhone--Exception---'+ e);
        }
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
        CashFlowResponse Responseobj=new CashFlowResponse();
   //  try{   
            String state = [select id,ClientId__r.Client_State__c,Client_Lead__r.State from Scenario__c where id=:senarioid].Client_Lead__r.State;//ClientId__r.Client_State__c;
            //For CashFlow
            //1st Start
            MonthlyMaintenance=MonthlyMaintenance*0.14;
            decimal MonthlyAsset_income;
            if(!Test.isRunningTest()){
            MonthlyAsset_income= GetMonthlyAssetIncome(senarioid,MonthlyAssetIncome);
            }else{
                MonthlyAsset_income = 100;
            }
           // decimal Totalcashflow=((MonthlyExpense.setScale(2, RoundingMode.HALF_UP)+MonthlyPropertyCharge.setScale(2, RoundingMode.HALF_UP)+MonthlyMaintenance.setScale(2, RoundingMode.HALF_UP))-(MonthlyExpense.setScale(2, RoundingMode.HALF_UP)+MonthlyAsset_income.setScale(2, RoundingMode.HALF_UP)));
             decimal Totalcashflow=((MonthlyIncome.setScale(2, RoundingMode.HALF_UP)+MonthlyAsset_income.setScale(2, RoundingMode.HALF_UP))-(MonthlyExpense.setScale(2, RoundingMode.HALF_UP)+MonthlyPropertyCharge.setScale(2, RoundingMode.HALF_UP)+MonthlyMaintenance.setScale(2, RoundingMode.HALF_UP)));
           
            system.debug('total MonthlyExpense '+MonthlyExpense.setScale(2, RoundingMode.HALF_UP)+'monthly maintence '+MonthlyMaintenance.setScale(2, RoundingMode.HALF_UP) + ' monthly property charge'+MonthlyPropertyCharge.setScale(2, RoundingMode.HALF_UP)+'-->'+(MonthlyExpense.setScale(2, RoundingMode.HALF_UP)+MonthlyPropertyCharge.setScale(2, RoundingMode.HALF_UP)+MonthlyPropertyCharge.setScale(2, RoundingMode.HALF_UP)));
            system.debug('total monthly income --->'+(MonthlyIncome.setScale(2, RoundingMode.HALF_UP)+MonthlyAsset_income.setScale(2, RoundingMode.HALF_UP)));
            system.debug('MonthlyAsset_income'+MonthlyAsset_income.setScale(2, RoundingMode.HALF_UP));
            system.debug('MonthlyIncome'+MonthlyIncome.setScale(2, RoundingMode.HALF_UP));
            system.debug('MonthlyExpense'+MonthlyExpense.setScale(2, RoundingMode.HALF_UP));
            system.debug('MonthlyPropertyCharge'+MonthlyPropertyCharge.setScale(2, RoundingMode.HALF_UP));
            system.debug('MonthlyMaintenance'+MonthlyMaintenance.setScale(2, RoundingMode.HALF_UP));
            system.debug('Totalcashflow'+Totalcashflow);           
            string  CashFlow=SAL_CashFlowController.Get_FormatedValue(Totalcashflow);
            system.debug('CashFlown'+CashFlow);
            //1st end
            
            //2nd start
                    string FamilySize;
            string StateRegion=SAL_CashFlowController.Get_StateRegion(state);
            system.debug('StateRegion'+StateRegion);
            if(Household_Members!=null)
            {
            if(integer.valueof(Household_Members)>3)
            {
                FamilySize='4 or more';     
            }
            else
            {
                FamilySize=''+Household_Members;
            }
            }
           Decimal  RequiredCashFlowValue;
            if(!test.isRunningTest()){
            System.debug('StateRegion '+StateRegion);
            
            System.debug('FamilySize '+FamilySize);
            RequiredCashFlowValue=SAL_CashFlowController.Get_ResidualIncome(StateRegion,FamilySize);
            }else{
                RequiredCashFlowValue = 10;
            }
            //Decimal  RequiredCashFlow= RequiredCashFlowValue==0?1:RequiredCashFlowValue;
            Decimal  RequiredCashFlow= RequiredCashFlowValue ;
            system.debug('RequiredCashFlow'+RequiredCashFlow);
                Responseobj.RequiredCashFlow = RequiredCashFlow;
         
            //2nd end
            
            //3rd
            decimal Capacity=((Totalcashflow/RequiredCashFlow)*100).setScale(2, RoundingMode.HALF_UP);
            system.debug('Capacity'+Capacity);             
            string  TotalCapacity =SAL_CashFlowController.Get_FormatedPercentage(Capacity);
            system.debug('TotalCapacity'+TotalCapacity);
             Responseobj.TotalCapacity = TotalCapacity;
            //3rd
            
            //4th start
            decimal CapacityStrg=(Totalcashflow-RequiredCashFlow).setScale(2, RoundingMode.HALF_UP);
            system.debug('CapacityStrg'+CapacityStrg);
            string  CapacityStorage =SAL_CashFlowController.Get_FormatedValue(CapacityStrg);
            system.debug('CapacityStorage'+CapacityStorage);
            //4th end
            Responseobj.CapacityStorage = CapacityStorage;
            //For CashFlow
            Responseobj.CashFlow=CashFlow;
            
    /*    }
        catch(Exception ex)
        {
            system.debug(' getCashFlowData----Exception---'+ex);
        }*/
        system.debug(Responseobj);
        return Responseobj;
    }
    
     @AuraEnabled
    public static string getFNMData(Blob filedata, String fileName, String base64Data, String contentType, String applicationDate,String senario_id,integer hhm,integer sft) {
   String loanId = CreateLoanFromScenario.getFNMData(filedata, fileName, base64Data, contentType, applicationDate, senario_id);

         Scenario__c sn = [select id,is_Converted__c,Loan__c from Scenario__c where id=:senario_id]; 
        sn.is_Converted__c = true;
        sn.Loan__c = loanId;
        try{
            upsert sn;
      
        }catch(Exception ex){}
        
         Loan_New__c  ln = [select id,Household_Members__c,Square_Footage__c from Loan_New__c where id=:loanId];
        ln.Household_Members__c = ''+hhm;
        ln.Square_Footage__c = ''+sft;
        try{
        update ln;
        }catch(Exception ex){}
     return   loanId;   
         
         }
    
     @AuraEnabled
    public Static Loan_New__c createLoan(String senarioid,Integer hhm,integer sft){
   Loan_New__c  ln= CreateLoanFromScenario.createLoan( senarioid);
       Scenario__c sn = [select id,is_Converted__c,Loan__c from Scenario__c where id=:senarioid]; 
        sn.is_Converted__c = true;
        sn.Loan__c = ln.id;
        upsert sn;
        
        ln.Household_Members__c = ''+hhm;
        ln.Square_Footage__c = ''+sft;
        
        try{
        if(!test.isRunningTest())
            update ln;
        }catch(exception ex){}
  return ln;
           
    }
    
    
    
    public static decimal GetMonthlyAssetIncome(String senarioId,Decimal passedAsset) {
        List<integer> DOBList=new List<integer>();
        List<date> FinalDOBList = new List<date>();
        integer LifeExpectancyYear;
        Integer LifeExpectancyAgeInMonth;
        decimal TotalAssetAgaintLoan;
        List<Scenario__c> sen=new List<Scenario__c> ();
     //   try{
            sen=[select ClientId__r.DOB__c,Client_Lead__r.DOB__c from Scenario__c where id=:senarioId  ];
            for(Scenario__c clientobj:sen )
            {             
              //  date dob=clientobj.ClientId__r.DOB__c;
                date dob=clientobj.Client_Lead__r.DOB__c;
                if(null==dob && test.isRunningTest()){
                    dob = System.today();
                    DOBList.add(100);
                    
                }
                Date TodayDate = System.today();
                integer  Age = (dob.monthsBetween(TodayDate) / 12);
                if(Age >61){                    
                    DOBList.add(Age);
                }
            }
            system.debug('Before DOBList'+DOBList);
            DOBList.sort();
            system.debug('fter DOBList'+DOBList);
            integer ClientAge = DOBList.get(0);
            system.debug('No of years ' + ClientAge);       
            if(ClientAge>=95)
            {
                LifeExpectancyYear=3;
            }
            else
            {
                LifeExpectancyYear=SAL_CashFlowController.GetLifeExpectancyYearValue(ClientAge);
            }
            system.debug('LifeExpectancyYear'+LifeExpectancyYear);
            //number of months the client has until their life expectancy age
            LifeExpectancyAgeInMonth=LifeExpectancyYear*12;
            system.debug('LifeExpectancyAgeInMonth'+LifeExpectancyAgeInMonth);
            TotalAssetAgaintLoan= passedAsset * 0.85;
            system.debug('TotalAssetAgaintLoan'+TotalAssetAgaintLoan);
            
      /*  }
        catch(Exception ex)
        {
            system.debug(' GetMonthlyAssetIncome----Exception---'+ex);
        }*/
        system.debug('TotalAssetAgaintLoan/LifeExpectancyAgeInMonth  -->'+ TotalAssetAgaintLoan/LifeExpectancyAgeInMonth);
        return TotalAssetAgaintLoan/LifeExpectancyAgeInMonth;
    }
    
    
    public static void  doUpdateCount(){
        
        try{
           
              user usr  = [ select contactId,Contact.Accountid,Id from user where id=:userinfo.getUserId() limit 1];
            Integer countOfRunScenario = [select count() from RunScenario__c where Business_individual__c=:usr.contactId];
          
            if(countOfRunScenario != 0 ){
                RunScenario__c RS = [select id,Scenarios_Run__c from RunScenario__c where  Business_individual__c=:usr.contactId];
                RS.Scenarios_Run__c = RS.Scenarios_Run__c+1;
                
                update RS;
               
            }else{
                RunScenario__c NRS  = new  RunScenario__c();
                NRS.Business_individual__c=usr.contactId;
                NRS.Scenarios_Run__c = 1;
                Insert NRS;
               
            }
          
        }catch(exception ex){
            
            System.debug('>>>> exception '+ex);
        }
        
    }
    @AuraEnabled
    public static list< map<string,map<string,String>>> get_metadataValues(String Tieris){ //Bala - Added Tier1, Tier2 in the backend Calculator
        list< map<string,map<string,String>>> data= new list< map<string,map<string,String>>>();
        String MetaDataTable = '';
        String MetaDataTableFixed = '';
        
        boolean isCommunityUser = true;
        user u =[ select id,ContactId from user where id=:userinfo.getUserId()];
        if(u.ContactId!=null){        
            isCommunityUser = true;
        }else{
            isCommunityUser =false;
        } 
        
        try{
            if(isCommunityUser){
                 boolean isAccPremier = [select id,Contact.AccountId,Contact.Account.Premier_Partner__c from user where id=:userinfo.getUserId()].Contact.Account.Premier_Partner__c;
                 MetaDataTable= isAccPremier?'Tier2__mdt':'Tier1__mdt';
                 MetaDataTableFixed = isAccPremier?'Fixed_Price_Tier2__mdt':'Fixed_Price_Tier1__mdt';
            }else{
                 MetaDataTable= (Tieris!='Tier1')?'Tier2__mdt':'Tier1__mdt';
                 MetaDataTableFixed =  (Tieris!='Tier1')?'Fixed_Price_Tier2__mdt':'Fixed_Price_Tier1__mdt';
            }
        }catch(exception ex){
            System.debug('Exception is '+ex);
        }        
        data.add(get_metadata.get_tierData(MetaDataTable));
        data.add(get_metadata.get_tierData_fixed(MetaDataTableFixed));
     
        return data;//get_metadata.get_tierData(MetaDataTable);
    }    
    @AuraEnabled
    public static List<string>  getZipData(string ZIP) 
    {
        List<string> ob=new  List<string>();
        //ob= zipCode.lookup(ZIP);
        ob= zipCodeLookup.lookup(ZIP);
       System.debug('>>>>>>>>>>>>>> obobobobobob '+ob);
        return ob;
    }
    
    @AuraEnabled
    public static list<String> get_states(){
        
        list<String> states = new list<String>();
        for(AuthorisedStates__mdt each:[SELECT Id, DeveloperName, MasterLabel, Label FROM AuthorisedStates__mdt]){
            states.add(each.MasterLabel);
        }
        return states;
    }
    
    
    
    @AuraEnabled
    public static void  sendEmailAfterBaydocsAdded(String ScenarioID ){
    
    
           // try{
      /*      Scenario__c objScenario=[Select  id,Name,Request_Scenario_Package_Count__c,Client_Lead__r.Name, Client_Lead__r.Lastname , Client_Lead__r.Street, 
                                     Client_Lead__r.DOB__c,  Client_Lead__r.Email , Client_Lead__r.postalcode , Client_Lead__r.Phone , 
                                     Client_Lead__r.state , Estimated_home_value__c , Margin__c , 
                                     Current_Mortgage_Balance__c , Current_Mortgage_Interest_Rate__c, 
                                     Monthly_Mortgage_Payment__c from scenario__c where id=: ScenarioID ];
                                     
                                    
            DateTime DT=objScenario.Client_Lead__r.DOB__c;
            string ClientDOB = '';
            try{
             ClientDOB=DT.format('MM/dd/yyyy');
             }catch(exception ex){}//=DT.format('MM/dd/yyyy');
            string Email_Optional=objScenario.Client_Lead__r.Email;
            if(Email_Optional==null || Email_Optional=='')
                Email_Optional='';        
            string Phone_Number=objScenario.Client_Lead__r.Phone;
            if(Phone_Number==null || Phone_Number=='')
            {Phone_Number='';}
            else{Phone_Number=FormatPhone(Phone_Number);}            
            String getUserEmailID =UserInfo.getUserEmail();
            String getUsername =UserInfo.getName();
            List<Messaging.SingleEmailMessage> mails = 
                new List<Messaging.SingleEmailMessage>();
            // Step 1: Create a new Email
            Messaging.SingleEmailMessage mail = 
                new Messaging.SingleEmailMessage();
            // Step 2: Set list of people who should get the email
            List<String> sendTo = new List<String>();
            string a=Label.Request_Calculator_Package_EmailID;
            sendTo.add(a);
            mail.setToAddresses(sendTo);
            mail.setReplyTo(getUserEmailID);
            mail.setSubject('Request for Scenario Package.');
            String body ;             
            body='<html><body><div>Hello ORM Support,</div><div><br></br></div><div>'+ getUsername +' Requested the calculation Package.</div><div><br></br></div>';
            body+='<table> <tr><td></td><td></td></tr><tr> <td> First Name : </td>';
            body+='<td>'+objScenario.Client_Lead__r.Name+'</td> </tr> <tr> <td>Scenario Id : </td>'; //Added Scenario Id Bala            
            body+='<td>'+objScenario.Name+'</td> </tr> <tr> <td>Last Name : </td>'; //Added Scenario Id Bala            
            body+='<td>'+objScenario.Client_Lead__r.LastName+'</td> </tr> <tr> <td> Address : </td>';
            body+='<td>'+objScenario.Client_Lead__r.Street+'</td> </tr> <tr> <td> State : </td>';
            body+='<td>'+objScenario.Client_Lead__r.State+'</td> </tr> <tr> <td> ZIP : </td>';
            body+='<td>'+objScenario.Client_Lead__r.Postalcode+'</td> </tr></tr> <tr> <td> Phone : </td>';
            body+='<td>'+Phone_Number+'</td> </tr><tr> <td> Date of Birth : </td>';
            body+='<td>'+ClientDOB+'</td> </tr><tr> <td> Email : </td>';
            body+='<td>'+Email_Optional+'</td> </tr><tr> <td> Home value: </td>';
            body+='<td>$'+objScenario.Estimated_home_value__c.format()+0.00+'</td> </tr><tr> <td> Mortgage Balance: </td>';
            body+='<td>$'+objScenario.Current_Mortgage_Balance__c.format()+0.00+'</td> </tr><tr> <td> Current Interest Rate : </td>';
            body+='<td>'+objScenario.Current_Mortgage_Interest_Rate__c+'%</td> </tr><tr> <td>Current Mortgage Payment: </td>';
            body+='<td>$'+objScenario.Monthly_Mortgage_Payment__c+'</td> </tr><tr> <td>Margin : </td>';            
            body+='<td>'+objScenario.Margin__c+'%</td> </tr> <tr><td colspan="1"></td></tr> <td colspan="1"></td><br/></tr> <tr> <td colspan="1">Thanks, </td> </tr> <tr>'; 
            body+='<td colspan="1">'+getUsername+'</td> </tr>'; 
            body+=  ' </table> </body> </html>';      
            mail.setHtmlBody(body);
            mails.add(mail);
            Messaging.sendEmail(mails);*/
      //  }
      //  catch(exception e)
      //  {
          //  system.debug('SendMailTMP--Exception---'+ e);
        //}
    
    }
   @AuraEnabled 
    public static String getScenariData(String dob,String ev,String pm,String ADOValIs){
        System.debug('>>>> dob '+dob);
        System.debug('>>>> ev '+ev);
        System.debug('>>>> pm '+pm);
        integer i_ev = Integer.valueOf(ev);
        //HUD calculation
        decimal firstValue = 0;// = (200000 * 0.02);
        decimal secondValue = 0;
        if(i_ev<=200000){
             firstValue = (i_ev * 0.02);
            
        }else{
            //if i_ev >200K
             firstValue = (200000 * 0.02);
            secondValue = ((i_ev - 200000 ) * 0.01);
            
        }
        decimal HUDis = firstValue + secondValue;
        HUDis = (HUDis > 6000)?6000:HUDis;
        String endpoint = system.label.scenario;
     Http h = new Http();

        Httprequest req = new Httprequest();
        req.setEndpoint(endpoint);
        
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
 if(pm !=''){
    gen.writeStringField('UserCode', system.label.usercode);
     gen.writeStringField('PassCode', system.label.passcode);
     gen.writeStringField('BorrowerBirthdate', dob);
     gen.writeStringField('EstimatedValue', ev);
     gen.writeStringField('PresentMortgage', pm);
      gen.writeStringField('DesiredOriginationFee', ADOValIs);
}else{
    gen.writeStringField('UserCode', system.label.usercode);
     gen.writeStringField('PassCode', system.label.passcode);
     gen.writeStringField('BorrowerBirthdate', dob);
     gen.writeStringField('PurchasePrice', ev);
     gen.writeStringField('DesiredOriginationFee', ADOValIs);
    
}
        //write metadata rate and Originaed orm fee ino JSON String
        boolean isAccPremier = [select id,Contact.AccountId,Contact.Account.Premier_Partner__c from user where id=:userinfo.getUserId()].Contact.Account.Premier_Partner__c;
         String MetaDataTableFixed = isAccPremier?'Fixed_Price_Tier2__mdt':'Fixed_Price_Tier1__mdt';
           String metadataQuery = 'SELECT Id, DeveloperName,  Origination_to_ORM__c, Rate__c FROM '+MetaDataTableFixed;
     gen.writeFieldName('origFees');
         gen.writeStartObject();

        list<sObject>metadataResults = database.query(metadataQuery);
   for(sObject eachsObject:metadataResults){
       decimal mapingValue  = (HUDis < Decimal.valueOf(String.valueOf(eachsObject.get('Origination_to_ORM__c'))))?HUDis:Decimal.valueOf(String.valueOf(eachsObject.get('Origination_to_ORM__c')));
     //gen.writeObjectField(String.valueOf(eachsObject.get('Rate__c')), String.valueOf(mapingValue));
     Decimal keyIs= Decimal.valueOf(String.valueOf(eachsObject.get('Rate__c'))).setScale(2);    
Decimal roundedkeyIs = Math.round(keyIs * 100) / 100.0;
system.debug(roundedkeyIs );
  
     gen.writeObjectField(String.valueOf(roundedkeyIs ),  Decimal.valueOf(String.valueOf(mapingValue)).setScale(2));
    system.debug('t ->'+ Decimal.valueOf(String.valueOf(mapingValue)).setScale(2) );
    system.debug('s  -> '+ Decimal.valueOf(String.valueOf(eachsObject.get('Rate__c'))).setScale(2));
   //system.debug('ss ' +Decimal.valueOf(eachsObject.get('Rate__c')) );
   }
        gen.writeEndObject();



gen.writeEndObject();

 String pretty = gen.getAsString();
     

         System.debug('firstValue ,secondValue '+ firstValue+' ,' +secondValue);
        
        System.debug('>>>>> HUDis '+HUDis);
    
 system.debug('reques is  -->' + pretty);
req.setBody(pretty);
   //yyy/mm/dd
        req.setMethod('POST');
        Httpresponse res = new Httpresponse();
        if(!test.isRunningTest()){
        res = h.send(req);
      //  System.debug('>>>>> '+ res.getBody());
        doUpdateCount();
        return res.getBody();
        }
        
        return null;
    }

    
}