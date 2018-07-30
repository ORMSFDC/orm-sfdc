/**
* @name           LoggerTest
* @description    Tests for Logger
* @author         Mike Gill
* @createddate    29th December 2017
* @description    Custom Logging Framework
*/
@isTest (SeeAllData=False)
public class LoggerTest {

    static testMethod void testLogger() {

            Test.startTest();

            //test push method
            Logger.push('testLead','Lead');

            try{
                insert new Lead();
            }
            catch (System.DmlException ex) {
                
                Logger.debugException(ex);
                System.assertEquals(StatusCode.REQUIRED_FIELD_MISSING, ex.getDmlType(0));
          
            }
            //test pop method
            Logger.pop();
            Test.stopTest();

    }

    static testMethod void testLogger_Debug() {

        Test.startTest();

        //test push method
        Logger.push('testLead','Lead');

        try{

            Lead l =  new Lead();
            l.FirstName = 'Test';
            l.LastName = 'Test';
            l.Company = 'Test';
            Logger.debug('Test');
            insert l;
        }
        catch (System.DmlException ex) {

            Logger.debugException(ex);
            System.assertEquals(StatusCode.REQUIRED_FIELD_MISSING, ex.getDmlType(0));

        }
        //test pop method
        Logger.pop();
        Test.stopTest();

    }


}