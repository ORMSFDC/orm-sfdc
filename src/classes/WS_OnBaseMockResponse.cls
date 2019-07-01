/**
* @description: Mock response class for WS_OnBase
* @author Sahitya
* @date 6/28/2019
*
*/
@isTest
global class WS_OnBaseMockResponse implements HttpCalloutMock {

    private String mockBody = '{"example":"test"}';

    public WS_OnBaseMockResponse() {
    this.mockBody = '{ "id": "a1B2g0000000GjuEAE",    "success": true}';
        }
        
        public WS_OnBaseMockResponse(String mockBody) {
        this.mockBody = mockBody;
    }

    global HTTPResponse respond(HTTPRequest req) {
        
        String body = this.mockBody;

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(body);
        return res;
    }
}