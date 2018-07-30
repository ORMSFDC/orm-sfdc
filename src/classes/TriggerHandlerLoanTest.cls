/**
 * @description Apex Test TriggerHandlerLoanTest
 * @date 29th June 2018
 * @author Mike Gill
 */

@isTest
private class TriggerHandlerLoanTest {



    /***************************************************************************************************
	*						 Initialize Test Data
	*************************************************************************************************/

    private static Map<String, TriggerLoan__mdt> testTESmdtMap {
        get {
            return new Map<String, TriggerLoan__mdt>{
                    'trackLoanStatus' => ( TriggerLoan__mdt ) JSON.deserialize(
                            '{ "MasterLabel" : "trackLoanStatus", "Enable__c" : true }', TriggerLoan__mdt.class )
            };
        }
        private set;
    }




}