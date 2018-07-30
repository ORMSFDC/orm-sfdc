@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        string DOB=date.today().format();
        decimal hv=1.0;
        String ir='ir';
        decimal mb=2.0;
        decimal mp=3.0;
        //string url='https://apibeta.rockfin.com/orms/nu62/LineOfCredit/PartialCalculator?dob='+DOB+'\'&hv='+hv+'\'&ir='+ ir+'\'&mb='+mb+'\'&mp='+mp;        
        //string url='https://apibeta.rockfin.com/orms/nu62/LineOfCredit/PartialCalculator?dob='+DOB+'&hv='+hv+'&ir='+ ir+'&mb='+mb+'&mp='+mp;        
        string url= Label.Scenario_LineChart_URL+'?dob='+DOB+'&hv='+hv+'&ir='+ ir+'&mb='+mb+'&mp='+mp;
       // System.assertEquals(url, req.getEndpoint());
        
        //System.assertEquals('https://apibeta.rockfin.com//orms//nu62//LineOfCredit//PartialCalculator?dob='+DOB+'\'&hv='+hv+'\'&ir='+ ir+'\'&mb='+mb+'\'&mp='+mp', req.getEndpoint());
    //    System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        //res.setBody('{"foo":"bar"}');
        res.setBody('{"04/05/1745","hv","mb","mp","ir","200","Ok"}');
        //res.setStatusCode(200);
        //res.setStatus('Ok');
        return res;
    }
    
}