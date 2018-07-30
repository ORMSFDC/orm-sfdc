@isTest
global class MockHttpResponseZIP  implements HttpCalloutMock{
    
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBodyasBlob(Blob.valueof('{"country":"US","state":"NY","city":"SCHENECTADY"}'));
        //res.setStatus('200');
        
        return res;
    }
}