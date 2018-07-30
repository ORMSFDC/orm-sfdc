/**
 * @description Apex Tests for LoanSharingHandler
 * @author Mike Gill
 * @date 28th June 2018
 *
 * @todo implement test constants
 *
 */
@isTest(SeeAllData=false)
private class LoanSharingHandlerTest {

    private static String queryString = TestUtils.getAllFieldQueryString('Loan_New__c');

    @testSetup static void testSetupData(){


        Id profileId = TestUtils.getProfileId('System Administrator');
        Id userRoleId = TestUtils.getRoleId('System Administrator');


        User testUser = (User)TestFactory.createSObject(new User(   ProfileId = profileId,
                                                                    UserRoleId = userRoleId), 'TestFactory.UserDefaults');
        insert testUser;


        System.runAs(testUser){

            Map<String, Id> recTypeMap = TestUtils.getRecordTypes('Account');

            Account testAccount = (Account)TestFactory.createSObject(new Account (
                                                                    OwnerId = testUser.Id,
                                                                    RecordTypeId = recTypeMap.get('Partners')),
                                                                    'TestFactory.AccountDefaults');
            insert testAccount;

            Contact testContact = (Contact)TestFactory.createSObject(new Contact (
                                                                AccountId = testAccount.Id,
                                                                OwnerId = testUser.Id),
                                                                'TestFactory.ContactDefaults');

            insert testContact;
            System.assertEquals(testAccount.OwnerId, testUser.Id, 'Owner is not Test User');
            User testPortalUser = TestUtils.createPortalLoanProcessorUser(testContact.Id);
            insert testPortalUser;

            Loan_New__c testLoan = (Loan_New__c)TestFactory.createSObject(new Loan_New__c(
                    LoanCompleteFlag__c = false,
                    Originating_Loan_Officer__c = testPortalUser.Id,
                    Related_Individual__c = testContact.Id,
                    Related_Partner__c = testAccount.Id
            ), 'TestFactory.LoanDefaults');

            insert testLoan;



        }

    }

    @isTest static void testLoanInsert(){

        // Query Test Data from Test Setup
        List<User> partnerUsers = [SELECT Id, UserName, ContactId FROM User where LastName like 'Test Partner%' ];
        List<User> ormUsers = [SELECT Id, UserName, ContactId FROM User where LastName like 'Test ORM%' ];
        List<Account> partnerAcct = [SELECT Id, Name FROM Account];
        List<Contact> partnerContact = [SELECT Id, Name FROM Contact];
        List<Loan_New__c> loans = Database.query('SELECT ' + queryString + ' FROM Loan_New__c');

        // Validate Test Data is loaded into Test Method
        System.assertEquals(ormUsers.size(), 1);
        System.assertEquals(partnerUsers.size(), 1);
        System.assertEquals(partnerContact.size(), 1);
        System.assertEquals(partnerAcct.size(), 1);


        Loan_New__c testLoan = (Loan_New__c)TestFactory.createSObject(new Loan_New__c(
                LoanCompleteFlag__c = false,
                Originating_Loan_Officer__c = partnerUsers[0].Id,
                Related_Individual__c = partnerContact[0].Id,
                Related_Partner__c = partnerAcct[0].Id
        ), 'TestFactory.LoanDefaults');


        Test.startTest();

            insert testLoan;

        Test.stopTest();

        List<Loan_New__c> queryInsertedLoan = Database.query('SELECT ' + queryString + ' FROM Loan_New__c');

        System.debug('loanStatus='+queryInsertedLoan[0].LoanStatus__c);




    }

    @isTest static void testLoanUpdate(){

        // Query Test Data from Test Setup
        List<User> partnerUsers = [SELECT Id, UserName, ContactId FROM User where LastName like 'Test Partner%' ];
        List<User> ormUsers = [SELECT Id, UserName, ContactId FROM User where LastName like 'Test ORM%' ];
        List<Account> partnerAcct = [SELECT Id, Name FROM Account];
        List<Contact> partnerContact = [SELECT Id, Name FROM Contact];
        List<Loan_New__c> loans = Database.query('SELECT ' + queryString + ' FROM Loan_New__c');

        // Validate Test Data is loaded into Test Method
        System.assertEquals(ormUsers.size(), 1);
        System.assertEquals(partnerUsers.size(), 1);
        System.assertEquals(partnerContact.size(), 1);
        System.assertEquals(partnerAcct.size(), 1);


        Loan_New__c testLoan = (Loan_New__c)TestFactory.createSObject(new Loan_New__c(
                LoanCompleteFlag__c = false,
                Originating_Loan_Officer__c = partnerUsers[0].Id,
                Related_Individual__c = partnerContact[0].Id,
                Related_Partner__c = partnerAcct[0].Id
        ), 'TestFactory.LoanDefaults');


        insert testLoan;

        Test.startTest();

        Loan_New__c l = new Loan_New__c (Id = testLoan.Id, LoanStatus__c = 'Proposal', LoanCompleteFlag__c = true, IsLoanCreatedByLoanProcessor__c = true);
        update l;

        Test.stopTest();

        List<Loan_New__c> queryInsertedLoan = Database.query('SELECT ' + queryString + ' FROM Loan_New__c');

        System.debug('loanStatus='+queryInsertedLoan[0].LoanStatus__c);
        System.debug('LoanCompleteFlag__c='+queryInsertedLoan[0].LoanCompleteFlag__c);




    }

    @isTest static void testLoanUpdateChangeOfOwnerAndStatus(){

        // Query Test Data from Test Setup
        List<User> partnerUsers = [SELECT Id, UserName, ContactId FROM User where LastName like 'Test Partner%' ];
        List<User> ormUsers = [SELECT Id, UserName, ContactId FROM User where LastName like 'Test ORM%' ];
        List<Account> partnerAcct = [SELECT Id, Name FROM Account];
        List<Contact> partnerContact = [SELECT Id, Name FROM Contact];
        List<Loan_New__c> loans = Database.query('SELECT ' + queryString + ' FROM Loan_New__c');

        // Validate Test Data is loaded into Test Method
        System.assertEquals(ormUsers.size(), 1);
        System.assertEquals(partnerUsers.size(), 1);
        System.assertEquals(partnerContact.size(), 1);
        System.assertEquals(partnerAcct.size(), 1);


        Loan_New__c testLoan = (Loan_New__c)TestFactory.createSObject(new Loan_New__c(
                LoanCompleteFlag__c = false,
                Originating_Loan_Officer__c = partnerUsers[0].Id,
                Related_Individual__c = partnerContact[0].Id,
                Related_Partner__c = partnerAcct[0].Id,
                OwnerId = partnerUsers[0].Id
        ), 'TestFactory.LoanDefaults');


        insert testLoan;

        Loan_New__c l = new Loan_New__c (Id = testLoan.Id, LoanStatus__c = 'Proposal', LoanCompleteFlag__c = true, IsLoanCreatedByLoanProcessor__c = true);
        update l;

        Test.startTest();

        Loan_New__c testLoanUpdate = new Loan_New__c (Id = testLoan.Id,
                                                                LoanStatus__c = 'Incomplete',
                                                                LoanCompleteFlag__c = false,
                                                                IsLoanCreatedByLoanProcessor__c = true);

        update testLoanUpdate;


        Test.stopTest();



        List<Loan_New__c> queryInsertedLoan = Database.query('SELECT ' + queryString + ' FROM Loan_New__c');

        System.debug('loanStatus='+queryInsertedLoan[0].LoanStatus__c);
        System.debug('LoanCompleteFlag__c='+queryInsertedLoan[0].LoanCompleteFlag__c);




    }
    @isTest static void testLoanUpdateLoanProcessorIsNotNull(){

        // Query Test Data from Test Setup
        List<User> partnerUsers = [SELECT Id, UserName, ContactId FROM User where LastName like 'Test Partner%' ];
        List<User> ormUsers = [SELECT Id, UserName, ContactId FROM User where LastName like 'Test ORM%' ];
        List<Account> partnerAcct = [SELECT Id, Name FROM Account];
        List<Contact> partnerContact = [SELECT Id, Name FROM Contact];
        List<Loan_New__c> loans = Database.query('SELECT ' + queryString + ' FROM Loan_New__c');

        // Validate Test Data is loaded into Test Method
        System.assertEquals(ormUsers.size(), 1);
        System.assertEquals(partnerUsers.size(), 1);
        System.assertEquals(partnerContact.size(), 1);
        System.assertEquals(partnerAcct.size(), 1);


        Loan_New__c testLoan = (Loan_New__c)TestFactory.createSObject(new Loan_New__c(
                LoanCompleteFlag__c = false,
                Originating_Loan_Officer__c = partnerUsers[0].Id,
                Related_Individual__c = partnerContact[0].Id,
                Related_Partner__c = partnerAcct[0].Id,
                OwnerId = partnerUsers[0].Id
        ), 'TestFactory.LoanDefaults');


        insert testLoan;

        Loan_New__c l = new Loan_New__c (Id = testLoan.Id, LoanStatus__c = 'Proposal', LoanCompleteFlag__c = true,
                IsLoanCreatedByLoanProcessor__c = true, Loan_Processor__c = partnerUsers[0].Id);


        Test.startTest();

        update l;


        Test.stopTest();

        List<Loan_New__c> queryInsertedLoan = Database.query('SELECT ' + queryString + ' FROM Loan_New__c');

        System.debug('loanStatus='+queryInsertedLoan[0].LoanStatus__c);
        System.debug('LoanCompleteFlag__c='+queryInsertedLoan[0].LoanCompleteFlag__c);




    }

}