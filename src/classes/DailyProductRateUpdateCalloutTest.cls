/**
* @description test class for DailyProductRateUpdateCallout.cls, Test daily product rate update code that is typically called by DailyProductRate trigger
*
* @author Ryan Pendergast
* @date 8/27/2018
* changelog:
* 10/24/2018: Sahitya - added test data to increase code coverage dpr2, dpr3
*/

@IsTest
private class DailyProductRateUpdateCalloutTest {
    private class DailyProductRateUpdateCalloutTestGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint and method.
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"example":"test"}');
            res.setStatusCode(200);
            return res;
        }
    }

    @IsTest
    static void testCallout() {
        Test.setMock(HttpCalloutMock.class, new DailyProductRateUpdateCalloutTestGenerator());

        Id profileId = TestUtils.getProfileId('System Administrator');
        Id userRoleId = TestUtils.getRoleId('System Administrator');
        User testUser = (User) TestFactory.createSObject(new User(ProfileId = profileId, UserRoleId = userRoleId), 'TestFactory.UserDefaults');
        Database.insert(testUser);

        System.runAs(testUser) {
            Daily_Product_Rate__c dpr = new Daily_Product_Rate__c(
                    Product_Rate_Type__c = 'HELO-OrigFee',                    
                    Rate_Date__c = Date.newInstance(2018, 2, 17),
                    RateMargin1__c = 0.0,
                    RateMargin2__c = 0.0,
                    RateMargin3__c = 0.0
            );
            Daily_Product_Rate__c dpr2 = new Daily_Product_Rate__c(
                    Product_Rate_Type__c = 'HELO-LIBOR',
                    Rate__c = 0.01,
                    Rate_Date__c = Date.newInstance(2018, 2, 17)
            );
            Daily_Product_Rate__c dpr3 = new Daily_Product_Rate__c(
                    Product_Rate_Type__c = 'HELO-BrokerComp',
                    Rate__c = 101,
                    Rate_Date__c = Date.newInstance(2018, 2, 17)
            );
            Test.startTest();
            Database.insert(dpr); //the insert causes DailyProductRate trigger to fire, which inherently tests DailyProductRateUpdateCallout.makeCallout()
            Database.insert(dpr2);
            Database.insert(dpr3);
            Test.stopTest();
        }
    }
}
