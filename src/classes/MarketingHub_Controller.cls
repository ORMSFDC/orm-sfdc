/**
 * @description MarketingHub Controller, used to generate a link to connect to marketing hub with logged in user creds
 * @author Sahitya
 * @date 30th May 2019
 */
public without sharing class MarketingHub_Controller{    

    @AuraEnabled
    public static String getLoggedInUserInfo(String Link) {
        user loggedinUser = [SELECT id, username, firstname, lastname, email FROM user WHERE id = :userinfo.getUserId()];        
      
        String uname = loggedinUser.username;
        String fname = loggedinUser.firstname;
        String lname = loggedinUser.lastname;
        String email = loggedinUser.email;
        String url = Label.MarketingHub;
        String pwd = 'MarketingHub123';
        String finalLink = url +'username=' +uname+ '&password=' +pwd+ '&name1=' +fname+ '&name2=' +lname+ '&email=' +email ;
        return finalLink; 
    }

    /*enable this method to generate different password for each login to marketing hub
    public static string generatePassword(String password){
        Integer len = 10;
        Blob blobKey = crypto.generateAesKey(128);
        String key = EncodingUtil.convertToHex(blobKey);
        String pwd = key.substring(0,len);
        return pwd;
    }
    */
}