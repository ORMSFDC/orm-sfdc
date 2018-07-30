@isTest
global class MockHttpCashFlowResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        String ir='ir';
        decimal mb=1.0;
        decimal mp=2.0;
        
        //string url='https://apibeta.rockfin.com/orms/nu62/CashFlow?ir='+ ir+'&mb='+mb+'&mp='+mp;  
        string url = Label.Scenario_CashFlow_URL+'?ir='+ ir+'&mb='+mb+'&mp='+mp;
        System.assertEquals(url, req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"mb","mp","ir","200","Ok"}');
        return res;
    }
    
}