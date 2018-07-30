global class ScenarioChannelClient {
    
    public static void sendEvent(String eventName, Object eventPayload,String loanId) {
        String body = JSON.serialize(new Event(eventName, eventPayload));
        
        system.debug('>>>>>>>>>> JSON is <<<<<<<<<<<<<<');
        system.debug(JSON.serialize(eventPayload));
      //  system.debug(JSON.serialize(new Event(eventName, eventPayload)));
      try{
        send(JSON.serialize(eventPayload),loanId,userinfo.getuserEmail(),UserInfo.getName());
        }catch(Exception ex){}
    }

 //   @future(callout=true)
    private static void send(String body,String loanId,String userEmail,String userName) {
        System.debug('Sending event to english channel... '+body);
    //    string endPoint = 
        HttpRequest request = new HttpRequest();
        try{
        request.setEndpoint(EnglishChannelConfig__c.getOrgDefaults().ApiGatewayEndpoint1__c);
        }catch(Exception ex){}
        request.setMethod('POST');
        request.setBody(body);
        request.setTimeout(120000);
        
        Http http = new Http();
        HttpResponse response;
        if(!test.isRunningTest()){
         response = http.send(request);// = http.send(request);
       }
      String outxmlstring = '';
   String   xmlstring = '';//response.getBody();
if(!Test.isRunningTest()){
    xmlstring = response.getBody();// '<?xml version="1.0" encoding="UTF-8"?> <response> <status>success</status> <OrderNumber>7079586</OrderNumber> <PdfStatus>OK</PdfStatus> <PdfCreateTimeInSecs></PdfCreateTimeInSecs> <File BayDocsOrderNumber="7079586" PackageType="1" FormatType="PDF" NoDocTriggered="0" PackageFound="1"> <Document xmlns:dt="urn:schemas-microsoft-com:datatypes" dt:dt="bin.base64">ASDF</Document> <URL FormatType="PDF"></URL> </File> </response>';
system.debug('xmlstring  ->'+xmlstring);  
}else{
  xmlstring ='<?xml version="1.0" encoding="UTF-8"?> <response> <status>success</status> <OrderNumber>7079851</OrderNumber> <PdfStatus>OK</PdfStatus> <PdfCreateTimeInSecs></PdfCreateTimeInSecs> <File BayDocsOrderNumber="7079851" PackageType="430" FormatType="PDF" NoDocTriggered="0" PackageFound="1"> <Document xmlns:dt="urn:schemas-microsoft-com:datatypes" dt:dt="bin.base64">ASDF</Document> <URL FormatType="PDF"></URL> </File> </response>';
 }
  // system.debug('xmlstring1  ->'+xmlstring);  
string OrdNumber = '0';
   DOM.Document xmlDOC = new DOM.Document(); 
       xmlDOC.load(xmlstring); 
       DOM.XMLNode rootElement = xmlDOC.getRootElement();
//outxmlstring=String.valueof(xmlDOC.getRootElement().getName());

  for(DOM.XMLNode xmlnodeobj:xmlDOC.getRootElement().getChildElements()){
     System.debug( xmlnodeobj.getName() ); 
       if(xmlnodeobj.getName()=='OrderNumber')
      {
      OrdNumber = xmlnodeobj.getText();
      }
       if(xmlnodeobj.getName()=='File')
          {
             for(DOM.XMLNode xmlnodeobjinner:xmlnodeobj.getChildElements()){
                
                    if(xmlnodeobjinner.getName() =='Document'){
                    
                     //   System.debug(xmlnodeobjinner.getText());
                        outxmlstring = xmlnodeobjinner.getText();
                    }
                    
                }
          
          }
     }
           Scenario__c ln = [select name,BayDocsOrderNumber__c  from Scenario__c where id=:loanId];//BayDocsOrderNumber__c 
           try{
               ln.BayDocsOrderNumber__c = OrdNumber;
               
               update ln;
           }catch(exception ex){}
            Attachment a = new Attachment();
       string base64Data='';
       if(outxmlstring !=''){
       base64Data = outxmlstring;//EncodingUtil.urlDecode(''+soapNS.getChildElement('File','').getChildElement('Document',''), 'UTF-8');
           system.debug('scenario id  ---> '+ loanid);
         
            a.parentId = loanId;
            a.Body = EncodingUtil.base64Decode(base64Data);
            a.Name = ln.name+'_'+System.now()+'_ScenarioPackage.pdf';
           // a.ContentType = 'pdf';
            insert a;
           system.debug('attachment name --> '+a);
         }   
        System.debug('...done!');
             Scenario__c objScenario=[Select  id,Request_Scenario_Package_Count__c,Client_Lead__r.Name, Client_Lead__r.Lastname , Client_Lead__r.Street, 
                                     Client_Lead__r.DOB__c,  Client_Lead__r.Email , Client_Lead__r.postalcode , Client_Lead__r.Phone , 
                                     Client_Lead__r.state , Estimated_home_value__c , Margin__c , 
                                     Current_Mortgage_Balance__c , Current_Mortgage_Interest_Rate__c, 
                                     Monthly_Mortgage_Payment__c from scenario__c where id=: loanId];
    
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
            else{Phone_Number=lookUpController.FormatPhone(Phone_Number);}            
            String getUserEmailID =UserInfo.getUserEmail();
            String getUsername =UserInfo.getName();

///SENDING MAIL TO THIS 'Label.Request_Calculator_Package_EmailID;' without reply needed as per my knowledge

            // Step 2: Set list of people who should get the email
          List<String> sendTo = new List<String>();
          string a1=Label.Request_Calculator_Package_EmailID;
          sendTo.add(a1);
          //sendTo.add(getUserEmailID);
          system.debug('sendTo  --> '+sendTo);
          system.debug('get user email id   -->'+getUserEmailID);


            List<Messaging.SingleEmailMessage> mails = 
                new List<Messaging.SingleEmailMessage>();
            // Step 1: Create a new Email
            Messaging.SingleEmailMessage mail = 
                new Messaging.SingleEmailMessage();
            mail.setToAddresses(sendTo);
         //  mail.setReplyTo(getUserEmailID);
           system.debug('sender getUserEmailID   --> '+getUserEmailID);
            mail.setSubject('Request for Scenario Package.');
            String body1 ;             
            body1='<html><body><div>Hello ORM Support,</div><div><br></br></div><div>'+ getUsername +' Requested the calculation Package.</div><div><br></br></div>';
            body1+='<table> <tr><td></td><td></td></tr><tr> <td> First Name : </td>';
            body1+='<td>'+objScenario.Client_Lead__r.Name+'</td> </tr> <tr> <td>Last Name : </td>';
            body1+='<td>'+objScenario.Client_Lead__r.LastName+'</td> </tr> <tr> <td> Address : </td>';
            body1+='<td>'+objScenario.Client_Lead__r.Street+'</td> </tr> <tr> <td> State : </td>';
            body1+='<td>'+objScenario.Client_Lead__r.State+'</td> </tr> <tr> <td> ZIP : </td>';
            body1+='<td>'+objScenario.Client_Lead__r.Postalcode+'</td> </tr></tr> <tr> <td> Phone : </td>';
            body1+='<td>'+Phone_Number+'</td> </tr><tr> <td> Date of Birth : </td>';
            body1+='<td>'+ClientDOB+'</td> </tr><tr> <td> Email : </td>';
            body1+='<td>'+Email_Optional+'</td> </tr><tr> <td> Home value: </td>';
            body1+='<td>$'+objScenario.Estimated_home_value__c.format()+0.00+'</td> </tr><tr> <td> Mortgage Balance: </td>';
            body1+='<td>$'+objScenario.Current_Mortgage_Balance__c.format()+0.00+'</td> </tr><tr> <td> Current Interest Rate : </td>';
            body1+='<td>'+objScenario.Current_Mortgage_Interest_Rate__c+'%</td> </tr><tr> <td>Current Mortgage Payment: </td>';
            body1+='<td>$'+objScenario.Monthly_Mortgage_Payment__c+'</td> </tr><tr> <td>Margin : </td>';            
            body1+='<td>'+objScenario.Margin__c+'%</td> </tr> <tr><td colspan="1"></td></tr> <td colspan="1"></td><br/></tr> <tr> <td colspan="1">Thanks, </td> </tr> <tr>'; 
            body1+='<td colspan="1">'+getUsername+'</td> </tr>'; 
            body1+=  ' </table> </body> </html>';      
            mail.setHtmlBody(body1);
            mails.add(mail);
            
            List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
            
               Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
              efa.setFileName(a.Name);
              efa.setBody(EncodingUtil.base64Decode(base64Data));
              fileAttachments.add(efa);
              mail.setFileAttachments(fileAttachments);
            Messaging.sendEmail(mails);
            system.debug('mail sent sucessfully');

//dup
//SENDING THIS MAIL TO LOGGED IN USER WITH REPLAY ADDRESS FROM THIS LABEL Label.Request_Calculator_Package_EmailID;
           String getUserEmailID1 =UserInfo.getUserEmail();
            String getUsername1 =UserInfo.getName();
        DateTime cDT = system.Now();
        String localDate = cDT.format('dd-MM-yyyy ');
        String localTime = cDT.format('h:mm a');

            // Step 2: Set list of people who should get the email
          List<String> sendTo1 = new List<String>();
         // string a2=getUserEmailID1;
         string a2=getUserEmailID1 ;//'ravaddanki@galaxe.com';
          sendTo1.add(a2);
          //sendTo.add(getUserEmailID);
          system.debug('sendTo  --> '+sendTo);
          system.debug('get user email id   -->'+getUserEmailID);


            List<Messaging.SingleEmailMessage> mails1 = 
                new List<Messaging.SingleEmailMessage>();
            // Step 1: Create a new Email
            Messaging.SingleEmailMessage mail1 = 
                new Messaging.SingleEmailMessage();
            mail1.setToAddresses(sendTo1);
           mail1.setReplyTo(Label.Request_Calculator_Package_EmailID);
           system.debug('sender getUserEmailID   --> '+getUserEmailID);
            mail1.setSubject('Your Scenario Package for '+objScenario.Client_Lead__r.Name); 
            String body2 ;             
            body2='<html><body> <div>Hello '+ getUsername1+'</div><div><br></br></div><div> Please find the scenario package for '+objScenario.Client_Lead__r.Name+'</div> <div><br></br></div><div> This scenario package was requested on '+localDate+' at '+ localTime+'</div><div><br></br></div><div>If you have any questions, please reach out to your account executive.</div> <div><br></br></div></body> </html>';
         
system.debug('body2'+body2);
         //   body2 ='<div> <br></br></div>';
            /* body2+='<table> <tr><td></td><td></td></tr><tr> <td> First Name : </td>';
            body2+='<td>'+objScenario.Client_Lead__r.Name+'</td> </tr> <tr> <td>Last Name : </td>';
            body2+='<td>'+objScenario.Client_Lead__r.LastName+'</td> </tr> <tr> <td> Address : </td>';
            body2+='<td>'+objScenario.Client_Lead__r.Street+'</td> </tr> <tr> <td> State : </td>';
            body2+='<td>'+objScenario.Client_Lead__r.State+'</td> </tr> <tr> <td> ZIP : </td>';
            body2+='<td>'+objScenario.Client_Lead__r.Postalcode+'</td> </tr></tr> <tr> <td> Phone : </td>';
            body2+='<td>'+Phone_Number+'</td> </tr><tr> <td> Date of Birth : </td>';
            body2+='<td>'+ClientDOB+'</td> </tr><tr> <td> Email : </td>';
            body2+='<td>'+Email_Optional+'</td> </tr><tr> <td> Home value: </td>';
            body2+='<td>$'+objScenario.Estimated_home_value__c.format()+0.00+'</td> </tr><tr> <td> Mortgage Balance: </td>';
            body2+='<td>$'+objScenario.Current_Mortgage_Balance__c.format()+0.00+'</td> </tr><tr> <td> Current Interest Rate : </td>';
            body2+='<td>'+objScenario.Current_Mortgage_Interest_Rate__c+'%</td> </tr><tr> <td>Current Mortgage Payment: </td>';
            body2+='<td>$'+objScenario.Monthly_Mortgage_Payment__c+'</td> </tr><tr> <td>Margin : </td>';            
            body2+='<td>'+objScenario.Margin__c+'%</td> </tr> <tr><td colspan="1"></td></tr> <td colspan="1"></td><br/></tr> <tr> <td colspan="1">Thanks, </td> </tr> <tr>'; 
            body2+='<td colspan="1">'+getUsername+'</td> </tr>'; 
            body2+=  ' </table>
            body2=' </body> </html>';  */    
            mail1.setHtmlBody(body2);
            mails1.add(mail1);
            
            List<Messaging.Emailfileattachment> fileAttachments1 = new List<Messaging.Emailfileattachment>();
            
               Messaging.Emailfileattachment efa1 = new Messaging.Emailfileattachment();
              efa1.setFileName(a.Name);
              efa1.setBody(EncodingUtil.base64Decode(base64Data));
              fileAttachments1.add(efa1);
              mail1.setFileAttachments(fileAttachments1);
            Messaging.sendEmail(mails1);
            system.debug('mail sent sucessfully 1');

    }

    global class Event {
        public String eventName {get; set;}
        public Object eventPayload {get; set;}

        public Event(String eventName, Object eventPayload) {
            this.eventName = eventName;
            this.eventPayload = eventPayload;
        }
    }
}