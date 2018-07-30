public with sharing class zipCode {
    
    
    public class ziptasticReturn {
       // @AuraEnabled public string country{ get;set; }
        @AuraEnabled public string state{ get;set; }
        @AuraEnabled public string city{ get;set; }
    }
    
    public class zipCodeException extends Exception {}
    
    // Called on keyup of lightning component to look up the zip code via REST API
    // Returns null if no data found against the input zip.
    @AuraEnabled
    //public static ziptasticReturn lookup(string zipValue)
    public static List<string> lookup(string zipValue)
    {
        string resp;
        ziptasticReturn zipInfo;
        
        string endpoint ='http://ziptasticapi.com/'; //
       // string endpoint ='https://www.usps.com/business/web-tools-apis/address-information-api.htm#_Toc487629505';
        endpoint = endpoint + zipValue;
        system.debug(LoggingLevel.Error,'zipCode.cls: calling endpoint='+endpoint);
        
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setMethod('GET');
        req.setEndpoint(endpoint);
        
        //try {
            res = http.send(req);
            //if (res.getStatusCode() != 200) {
            //    throw new zipCodeException(res.getStatus());
            //}
        //} catch (zipCodeException e) {
          //  system.debug(LoggingLevel.Error, 'Error HTTP response code = '+res.getStatusCode()+'; calling '+endpoint );
          //  return null;
       //}
        system.debug('RESULT----------------' +res.getBody());
        resp = res.getBody();
        system.debug('RESPONSE -----' + resp);
        JSONParser parser = JSON.createParser(resp);
        parser.nextToken(); 
        
        // This convenient method reads the JSON stream into a class in one go
        zipInfo = (ziptasticReturn) parser.readValueAs(ziptasticReturn.class); 
        string scode=zipInfo.state;
        zipInfo.state=  zipDictionary.returnState(sCode);
        List<string> det=new List<string>();
        det.add(zipInfo.state);
        
        //converting city value to sentence case
        string city=zipInfo.city;
        String res0 = city.substring(0, 1);
        string res1= city.substring(1, city.length());
        string citi=res0.toUpperCase()+res1.toLowerCase();
        zipInfo.city=citi;
        
        det.add(zipInfo.city);
        //return zipInfo;
        return det;
    }
}