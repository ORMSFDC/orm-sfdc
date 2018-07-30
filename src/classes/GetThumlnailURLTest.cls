@isTest
public with sharing class GetThumlnailURLTest {
  @isTest static void  getThumlnailURLTest(){   
      YoutubeLinks__c you = new YoutubeLinks__c();
         you.YouTubeHeader__c = 'Salesforce Link';
         you.YoutubeURL__c = 'https://www.youtube.com/embed/jej-UKzRjgU';
      	 you.IsActive__c = True;
      	 insert you;
  } 
}