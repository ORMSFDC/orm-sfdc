@isTest
public with sharing class zipCodeLookupTest {
    @isTest static void lookupTest()
    {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseZIP());
        string aa=zipCodeLookup.XMLValue('12945');
        List<string> Result = zipCodeLookup.lookup('12345');
        string aaa=zipCodeLookup.XMLValue1('12345');
        string UID=zipCodeLookup.Uid();
    }
    
}