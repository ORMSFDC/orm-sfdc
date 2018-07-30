/**
* @description Establishes a trigger framework for the Loan object.
* Extension of TriggerHandler.class (virtual class) methods occurs in TriggerHandlerLoan.class
* @author Mike Gill
* @date 19/6/2018
*
*/
trigger Loan_New on Loan_New__c (before insert,
                                    before update,
                                    before delete,
                                    after insert,
                                    after update,
                                    after delete,
                                    after undelete) {
    new TriggerHandlerLoan().run();

}