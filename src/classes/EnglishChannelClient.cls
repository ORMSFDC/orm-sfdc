/**
 * @description EnglishChannelClient - Orchestrate Callout to Baydocs for App Package Requests
 * @author GalaxE (Original Author)
 * @date 13th June 2018 (Updated by Mike)
 *
 * @changelog MG SFDC-226 Updates to support not saving Attachment back into SFDC
 *
 * @todo    MG Code review & tidy - In progress (02/08/2018)
 *          MG Compare and Merge with other DevSandbox before deploying to Partial/Prod
 */
global class EnglishChannelClient {

    /**
     * @description Invoke future call for sending payload to Baydocs
     *
     * @param eventName
     * @param eventPayload
     * @param loanId Salesforce Id of the Loan
     */
    public static void sendEvent(String eventName, Object eventPayload, String loanId) {
        Logger.push('sendEvent', 'EnglishChannelClient');

        String body = JSON.serialize(new Event(eventName, eventPayload));

        try {
            send(JSON.serialize(eventPayload), loanId);
        } catch (Exception ex) {
            Logger.debugException(ex);
        }
        Logger.pop();
    }

    /**
     * @description Async future callout to Baydocs
     *
     * @param body
     * @param loanId
     */
    @future(callout=true)
    private static void send(String body, String loanId) {
        Logger.push('send', 'EnglishChannelClient');

        HttpRequest request = new HttpRequest();

        if (body != null) Logger.debug(body); // This is the JSON Log

        request.setEndpoint(EnglishChannelConfig__c.getOrgDefaults().ApiGatewayEndpoint__c); // @TODO MG Add null check
        Logger.debug('request setEndpoint '+ EnglishChannelConfig__c.getOrgDefaults().ApiGatewayEndpoint__c); // @TODO MG Move into CMT
        request.setMethod('POST');
        request.setBody(body);
        request.setTimeout(120000);

        Http http = new Http();
        HttpResponse response;
        if (!test.isRunningTest()) {

            response = http.send(request);// = http.send(request);
        }
        //Logger.debug('Response=' + response);


        
        String xmlstring = '';//response.getBody();

        if (!Test.isRunningTest()) {
            xmlstring = response.getBody();
        }
        else {
            // @TODO move into correct mocking framework
            xmlstring = '<?xml version="1.0" encoding="UTF-8"?> <response> <status>success</status> <OrderNumber>7082227</OrderNumber> <PdfStatus>OK</PdfStatus> <PdfCreateTimeInSecs></PdfCreateTimeInSecs> <LoanNumber>1</LoanNumber> <Files> <File BayDocsOrderNumber="7082227" PackageType="1" FormatType="PDF" NoDocTriggered="0" PackageFound="1"> <Document xmlns:dt="urn:schemas-microsoft-com:datatypes" dt:dt="bin.base64">asda</Document> </File> <File BayDocsOrderNumber="7082227" PackageType="421" FormatType="PDF" NoDocTriggered="0" PackageFound="1"> <Document xmlns:dt="urn:schemas-microsoft-com:datatypes" dt:dt="bin.base64">sfsdfdsf</Document> </File> </Files> </response>';

        }


        //Logger.debug('response.getBody() '+ response.getBody().substring(0, 131000));
		//saveAppPackageToLoan(loanId, xmlstring); // SFDC-226 Not required to be saved back into SFDC
        Logger.pop(); // Popping further up stack

      

    }

	/**
	*  Surplus to Requirements for now
	 * @description New method saveAppPackageToLoan (chunk down original method, could require further splitting out...)
	 * @param  loanId Salesforce record Id
	 * @param  xmlstring xml response from Baydocs containing base64 attachment
	 */
    private static void saveAppPackageToLoan(Id loanId, String xmlstring){
        Logger.push('saveAppPackageToLoan','EnglishChannelClient');
        /**
            @TODO Pending review by Mike
            @TODO Lift and shift into separate method
        */

        /*
        list< String> outxmlstring = new list< String>();
        string OrdNumber = '0';
        DOM.Document xmlDOC = new DOM.Document();
        xmlDOC.load(xmlstring);
        DOM.XMLNode rootElement = xmlDOC.getRootElement();
        //outxmlstring=String.valueof(xmlDOC.getRootElement().getName());
        for (DOM.XMLNode xmlnodeobj : xmlDOC.getRootElement().getChildElements()) {
            //   System.debug( xmlnodeobj.getName() );
            if (xmlnodeobj.getName() == 'OrderNumber') {
                OrdNumber = xmlnodeobj.getText();
            }
            if (xmlnodeobj.getName() == 'files') {

                //System.debug()
                for (DOM.XMLNode xmlnodeobjinner : xmlnodeobj.getChildElements()) {
                    if (xmlnodeobjinner.getName() == 'file') {
                        for (DOM.XMLNode Newxmlnodeobjinner : xmlnodeobjinner.getChildElements()) {
                            if (Newxmlnodeobjinner.getName() == 'document') {
                                //outxmlstring = Newxmlnodeobjinner.getText();

                                //      System.debug('outxmlstring '+outxmlstring);
                                outxmlstring.add(Newxmlnodeobjinner.getText());
                            }

                        }
                    } 

                }

            }
        }

		// @TODO MG/QDA combine into single query and save, possibly move into new method
        Loan_new__c ln = [select name,createdby.email,createdby.name,BayDocsOrderNumber__c from Loan_New__c where id = :loanId];
        
        try {
            ln.BayDocsOrderNumber__c = OrdNumber;

            // update ln; // @TODO MG/QDA commented out for dev testing
        } catch (exception ex) {
			Logger.debugException(ex);
        }

		List<Attachment> Atts = new List<Attachment>(); // empty list for new attachments

        if (!outxmlstring.isEmpty()) {

            
            
            // Add App Package PDF
			string base64Data = outxmlstring[0];//EncodingUtil.urlDecode(''+soapNS.getChildElement('File','').getChildElement('Document',''), 'UTF-8');
            Attachment a = new Attachment();
            a.parentId = loanId;
            a.Body = EncodingUtil.base64Decode(base64Data);
            a.Name = ln.name + '_' + System.now() + '_AppPackage.pdf';
            Atts.add(a);

            // Add Lender Package PDF 
            if (outxmlstring.size() == 2) {
			string base64Datanew = outxmlstring[1];//EncodingUtil.urlDecode(''+soapNS.getChildElement('File','').getChildElement('Document',''), 'UTF-8');
			Attachment a1 = new Attachment();
			a1.parentId = loanId;
			a1.Body = EncodingUtil.base64Decode(base64Datanew);
			a1.Name = ln.name + '_' + System.now() + '_LenderPackage.pdf';
			Atts.add(a1);
            }

			
        }

		try{
			Logger.debug('Saving Attachments ' + Atts.size());
			insert Atts;	
			} 
		catch (Exception ex){
			Logger.debugException(ex);
		}
            

        
        // @TODO MG/QDA need to combine with update on lin 126
        Loan_New__c lnstatus = [select loanstatus__c from loan_new__c where id = :loanId];
        lnstatus.LoanStatus__c = 'Waiting for Full Package';
        //update lnstatus; // @TODO MG/QDA commented out for dev testing
        */
        Logger.pop();


    }

    global class Event {
        public String eventName { get; set; }
        public Object eventPayload { get; set; }

        public Event(String eventName, Object eventPayload) {
            this.eventName = eventName;
            this.eventPayload = eventPayload;
        }
    }
}