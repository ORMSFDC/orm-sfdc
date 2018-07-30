public class ZoomController {
 @AuraEnabled
     /*public static  ZoomCreateMeetingResponse CreateMeeting(String UserName,String Email,string TopicNameDetails) 
     {
         string TopicName=TopicNameDetails;
         system.debug('ss'+TopicName);
            ZoomCreateMeetingResponse lst=new  ZoomCreateMeetingResponse();
    HttpRequest req = new HttpRequest();
    HttpResponse res = new HttpResponse();
    Http http = new Http();
    req.setEndpoint('https://api.zoom.us/v1/meeting/create');
    req.setMethod('POST');  
 req.setBody('api_key=LFHnYQqlT_OZWv8C47SPQw&api_secret=PllqRINEU3L8urOT44FP0k7FEjwgzpMipJnt&data_type=JSON&host_id=s81pk70gTjy5WNKGGHpluA&topic='+ TopicName +'&type=3&registration_type=1&option_audio=both&option_auto_record_type=local');
   
    try {
        res = http.send(req); 
       
         System.debug(res.toString());
    } catch(System.CalloutException e) {
        System.debug('Callout error: '+ e);
        System.debug(res.toString());
    }
   
      system.debug((ZoomCreateMeetingResponse)System.JSON.deserialize(res.getbody(), ZoomCreateMeetingResponse.class));
lst= (ZoomCreateMeetingResponse)System.JSON.deserialize(res.getbody(), ZoomCreateMeetingResponse.class);
         string MeetingID=lst.id;
                
          sendMail(UserName,Email,MeetingID,TopicName);
    return lst;
}*/
    public static void  sendMail(String UserName,String Email,String MeetingID,string TopicName)
    {
        string ZoomURL='https://zoom.us/j/'+MeetingID;
        String getUserEmailID =  UserInfo.getUserEmail();
         String getUsername =UserInfo.getName();
        List<Messaging.SingleEmailMessage> mails = 
  new List<Messaging.SingleEmailMessage>();
        // Step 1: Create a new Email
      Messaging.SingleEmailMessage mail = 
      new Messaging.SingleEmailMessage();
    
      // Step 2: Set list of people who should get the email
      List<String> sendTo = new List<String>();
      sendTo.add(Email);
      mail.setToAddresses(sendTo);
    
      // Step 3: Set who the email is sent from
      mail.setReplyTo(getUserEmailID);
      mail.setSenderDisplayName('Zoom Meeting Invitation');
    
   

      // Step 4. Set email contents - you can use variables!
      mail.setSubject('Zoom Meeting Invitation');
      String body ;
        body='<html><body style="margin: 0; padding: 0;"><table><tr><td><p>Hello ';
       body+=UserName+',</p><p>';
        body+=getUsername +' is inviting you to join a Zoom meeting.</p><p>Topic: ';
        body+=TopicName +'</p><p>Join from PC, Mac, iOS or Android: ';
        body+=ZoomURL +'</><p>Thanks,</p><p>';
        body+=getUsername +'</p></td> </tr> </table></body></html>';
      
      mail.setHtmlBody(body);
    
      // Step 5. Add your email to the master list
      mails.add(mail);

  
        Messaging.sendEmail(mails);
    }
  
  
}