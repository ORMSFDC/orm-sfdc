public with sharing class zipCodeLookup {
    public static List<string> lookup(String zipCode){
        List<string> det=new List<string>();
       
        try
        {
            String userID = Uid();
            String reqXML = '<CityStateLookupRequest USERID="'+userID+'"><ZipCode ID= "0"><Zip5>'+zipCode+'</Zip5></ZipCode></CityStateLookupRequest>';
            String endpoint = 'http://production.shippingapis.com/ShippingAPITest.dll?API=CityStateLookup&XML=';
            endpoint = endpoint+EncodingUtil.urlEncode(reqXML,'UTF-8');
            HttpRequest request=new HttpRequest();
            request.setEndPoint(endpoint);
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/xml');
            Http p=new Http();
            HttpResponse response=p.send(request);
            String resXML=response.getBody();
            Dom.Document docx = new Dom.Document();
            docx.load(resXML);
            Dom.XmlNode xroot = docx.getRootElement();
            String state = xroot.getChildElement('ZipCode', null).getChildElement('State', null).getText();
            String city = xroot.getChildElement('ZipCode', null).getChildElement('City', null).getText();
            
            //getting State name from dictionary
            string stateName=  zipDictionary.returnState(state);
            System.debug(stateName);
            
            det.add(stateName);
            
            //converting city value to sentence case
            String res0 = city.substring(0, 1);
            string res1= city.substring(1, city.length());
            string citi=res0.toUpperCase()+res1.toLowerCase();
            System.debug(citi);
            det.add(citi);   
        }
        catch(Exception ex)
        {
            //Exception_log.Log_exception(ex,'','','');
            
        }
        return det;        
    }
    public static string Uid()
    {
        return '985GALAX4898';
    }
    public static string XMLValue(string zipCode)
    {        
         string data;
        String userID = '985GALAX4898';
        String reqXML = '<CityStateLookupRequest USERID="'+userID+'"><ZipCode ID= "0"><Zip5>'+zipCode+'</Zip5></ZipCode></CityStateLookupRequest>';
        return  reqXML;
    }
     public static string XMLValue1(string zipCode)
    {     
         string data;
        String userID = '985GALAX4898';
        String reqXML = '<CityStateLookupRequest USERID="'+userID+'"><ZipCode ID= "0"><Zip5>'+zipCode+'</Zip5></ZipCode></CityStateLookupRequest>';
        return  reqXML;
    }
}