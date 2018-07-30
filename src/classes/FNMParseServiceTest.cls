@isTest
public class FNMParseServiceTest {

    @isTest 
    public static void parseFNMTest() {
        Test.setMock(HttpCalloutMock.class, new FNMMockHttpResponse());
        FNMResponse fnmResponse = FNMParseService.parseFNM(Blob.valueof('not used in test'));

        System.assertEquals(true, fnmResponse.wasSuccessful);        
    }
}