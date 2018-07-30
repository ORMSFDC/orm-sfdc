public class ScenarioResponceUtil{

    @AuraEnabled 
    public static String getScenariData(String dob,String ev,String pm){
        System.debug('>>>> dob '+dob);
        System.debug('>>>> ev '+ev);
        System.debug('>>>> pm '+pm);
     String endpoint = system.label.scenario;
     Http h = new Http();

        Httprequest req = new Httprequest();
        req.setEndpoint(endpoint);
        
        JSONGenerator gen = JSON.createGenerator(true);
gen.writeStartObject();
     gen.writeStringField('UserCode', system.label.usercode);
     gen.writeStringField('PassCode', system.label.passcode);
     gen.writeStringField('YoungestBorrowerAge', dob);
     gen.writeStringField('EstimatedValue', ev);
gen.writeStringField('PresentMortgage', pm);


gen.writeEndObject();

 String pretty = gen.getAsString();
 system.debug('pretty  --> '+ pretty);
req.setBody(pretty);
      //  req.setBody('{"UserCode" : "4726","PassCode" : "lR7i61T74c3h0746Q8S7zC2Nt1DF1m16","YoungestBorrowerAge" : "1947/08/08","EstimatedValue" : "200000","PresentMortgage" : "40000"}');
   //yyy/mm/dd
        req.setMethod('POST');
        Httpresponse res = new Httpresponse();
       if(!test.isRunningtest()){
        res = h.send(req);
        System.debug('>>>>> '+ res.getBody());
        }
        return res.getBody();
    }
}