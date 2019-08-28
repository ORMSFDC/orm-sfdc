/**
* @description Update Helo product Index, Broker Comp, Originations to BayDocs
* @author Bala
* @date 8/30/2018
* @changlog 
* Bala 8/28/2019 - Added new libor rate for HELO ARM
*/
public with sharing class DailyProductRateUpdateCallout {
    @future(callout=true)
    public static void makeCallout(String productRateAsJson) {
        Daily_Product_Rate__c pr = (Daily_Product_Rate__c) JSON.deserialize(productRateAsJson, Daily_Product_Rate__c.class);

        system.debug('DailyProductRateUpdateCallout got Product_Rate_Type_c: ' + pr.Product_Rate_Type__c);

        system.debug('looking up BaydocsProductRateUpdate ExternalServiceRegistry__mdt entry');

        ExternalServiceRegistry__mdt[] esrEntries = [select NamedCredential__c, password__c,username__c from ExternalServiceRegistry__mdt where DeveloperName = 'BaydocsProductRateUpdate' limit 1];

        system.debug(esrEntries);

        if (esrEntries.size() != 1) {
            system.debug(LoggingLevel.ERROR, 'No ExternalServiceRegistry entry for BaydocsProductRateUpdate');
            return;
        }

        DateTime rateDateTime = DateTime.newInstance(pr.Rate_Date__c, Time.newInstance(0, 0, 0, 0));
        String rateDateS = rateDateTime.format('yyyy-MM-dd');

        JSONGenerator gen = JSON.createGenerator(true);
        String endpoint;

        HttpRequest request = new HttpRequest();
        if ('HELO-LIBOR' == pr.Product_Rate_Type__c) {
            String namedCredential = esrEntries[0].NamedCredential__c;

            endpoint = 'callout:' + namedCredential + '/app/lib/integration/OneReverse/HELO/UpdateLIBORswap/index.php';
            gen.writeStartObject();
            gen.writeStringField('UserCode', esrEntries[0].username__c);
            gen.writeStringField('PassCode', esrEntries[0].password__c);
            gen.writeStringField('DateFormat', 'Y-m-d');
            gen.writeStringField('RateDate', rateDateS);//'2018-08-01');
            gen.writeStringField('IndexValue', pr.Rate__c.toPlainString());
            gen.writeEndObject();
        } else if ('HELO-BrokerComp' == pr.Product_Rate_Type__c) {
            String namedCredential = esrEntries[0].NamedCredential__c;

            endpoint = 'callout:' + namedCredential + '/app/lib/integration/OneReverse/HELO/UpdateBrokerComp/index.php';
            gen.writeStartObject();
            gen.writeStringField('UserCode', esrEntries[0].username__c);
            gen.writeStringField('PassCode', esrEntries[0].password__c);
            gen.writeStringField('DateFormat', 'Y-m-d');
            gen.writeStringField('EffectiveDate', rateDateS);//'2018-08-01');
            gen.writeStringField('BrokerPrice', pr.Rate__c.toPlainString());
            gen.writeEndObject();
        } else if ('HELO-OrigFee' == pr.Product_Rate_Type__c) {
            String namedCredential = esrEntries[0].NamedCredential__c;
            endpoint = 'callout:' + namedCredential + '/app/lib/integration/OneReverse/HELO/UpdateOrigFee/index.php';
            gen.writeStartObject();
            gen.writeStringField('UserCode', esrEntries[0].username__c);
            gen.writeStringField('PassCode', esrEntries[0].password__c);
            gen.writeStringField('DateFormat', 'Y-m-d');
            gen.writeStringField('EffectiveDate', rateDateS);//'2018-08-01');
            gen.writeStringField('OrigFeeMargin1', pr.RateMargin1__c.toPlainString());
            gen.writeStringField('OrigFeeMargin2', pr.RateMargin2__c.toPlainString());
            gen.writeStringField('OrigFeeMargin3', pr.RateMargin3__c.toPlainString());
            gen.writeEndObject();
        } else if('HELO-ARM-INDEX' == pr.Product_Rate_Type__c){
            String namedCredential = esrEntries[0].NamedCredential__c;
            endpoint = 'callout:' + namedCredential + '/app/lib/integration/OneReverse/HELO/UpdateLIBORmonthly/index.php';
            gen.writeStartObject();
            gen.writeStringField('UserCode', esrEntries[0].username__c);
            gen.writeStringField('PassCode', esrEntries[0].password__c);
            gen.writeStringField('DateFormat', 'Y-m-d');
            gen.writeStringField('RateDate', rateDateS);//'2018-08-01');
            gen.writeStringField('IndexValue', pr.Rate__c.toPlainString());
            gen.writeEndObject();
        } else {
            system.debug(LoggingLevel.ERROR, 'Invalid daily product rate type type: ' + pr.Product_Rate_Type__c);
            return;
        }

        String jsonS = gen.getAsString();

        request.setEndPoint(endpoint);
        request.setMethod('POST');
        request.setBody(jsonS);

        system.debug('POSTing: ' + jsonS);
        HttpResponse res = new HTTP().send(request);

        if (200 != res.getStatusCode()) {
            system.debug(LoggingLevel.ERROR, 'ERROR calling baydocs to update product rate');
        } else {
            pr.Processed__c = DateTime.now();
            update pr;
        }

        system.debug(res.toString());
        system.debug(res.getBody());
    }
}