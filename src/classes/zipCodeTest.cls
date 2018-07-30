@isTest
public with sharing class zipCodeTest {
    @isTest static void lookupTest()
    {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseZIP());
    	List<string> Result = zipCode.lookup('12345');
    }

}