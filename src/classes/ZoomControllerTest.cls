@isTest
public with sharing class ZoomControllerTest {
    
     public static testMethod void sendMailTest() 
    {
        String UserName= UserInfo.getUserName();
            String Email = 'sasharma@galaxe.com';
            String MeetingID ='456789';
            string TopicName = 'ZoomTest';
       
        ZoomController.sendMail(UserName,Email,MeetingID,TopicName);
    }

}