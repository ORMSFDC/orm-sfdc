/**
 * @description: SaNL Loan Main page, incomplete applications, 3.2 files and lender packages  
 * @author: Ravi
 * @date: 7/28/2017
 *
 * changelog:
 * 1/24/2019: Sahitya, changed the filedata fileType from Blob to String, and changed setBody
 */
public class FNMParseService {

    // Call fannie mae parsing service to convert fannie file into FNMResponse
    public static FNMResponse parseFNM(Blob filedata) {

        HttpRequest request = new HttpRequest();
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setEndpoint(Label.FannieParserEndpoint);
        request.setHeader('x-api-key', Label.FannieParserApiKey);
        request.setMethod('POST'); 
        request.setBodyasBlob(filedata);
        request.setTimeout(30000);

        Http http = new Http();
        HttpResponse response = http.send(request);
        
        System.debug('Reponse from server was: ' + response.getbody());
        
        return (FNMResponse) JSON.deserialize(response.getBody(), FNMResponse.class);
    }
}
