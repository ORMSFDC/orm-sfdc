//Test daily product rate update code that is typically called by DailyProductRate trigger
@IsTest
private class DailyProductRateUpdateCalloutTest {
    private class DailyProductRateUpdateCalloutTestGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
//        // Optionally, only send a mock response for a specific endpoint
//        // and method.
//        System.assertEquals('http://example.com/example/test', req.getEndpoint());
//        System.assertEquals('GET', req.getMethod());

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
                    Product_Rate_Type__c = 'HELO-LIBOR',
                    Rate__c = 3.01,
                    Rate_Date__c = Date.newInstance(2018, 2, 17)
            );
            Test.startTest();
            Database.insert(dpr); //the insert causes DailyProductRate trigger to fire, which inherently tests DailyProductRateUpdateCallout.makeCallout()
            Test.stopTest();
        }
    }
}