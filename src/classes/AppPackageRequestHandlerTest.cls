/**
 * @description Apex Tests for AppPackageRequestHandler
 * @author Mike Gill
 * @date 15th August 2018
 *
 */
@isTest(SeeAllData=false)
private class AppPackageRequestHandlerTest {

    @TestSetup static void testSetupData() {
        // Create common test data for use in all test methods
        // @TestSetup initializes test data for each method

        // create test user for runAs
        Id profileId = TestUtils.getProfileId('System Administrator');
        Id userRoleId = TestUtils.getRoleId('System Administrator');
        User testUser = (User) TestFactory.createSObject(new User(ProfileId = profileId,
                UserRoleId = userRoleId), 'TestFactory.UserDefaults');
        Database.insert(testUser);
        // runAs to avoid mixed DML errors
        System.runAs(testUser) {
            // create Account for Loan
            Map<String, Id> recTypeMap = TestUtils.getRecordTypes('Account');
            Account testAccount = (Account) TestFactory.createSObject(new Account(
                    OwnerId = testUser.Id,
                    RecordTypeId = recTypeMap.get('Partners')),
                    'TestFactory.AccountDefaults');
            Database.insert(testAccount);
            // create Contact for Loan
            Contact testContact = (Contact) TestFactory.createSObject(new Contact(
                    AccountId = testAccount.Id,
                    OwnerId = testUser.Id),
                    'TestFactory.ContactDefaults');
            Database.insert(testContact);
            System.assertEquals(testAccount.OwnerId, testUser.Id, 'Owner is not Test User');
            // create portal User
            User testPortalUser = TestUtils.createPortalLoanProcessorUser(testContact.Id);
            Database.insert(testPortalUser);
            // create test Loan
            Loan_New__c testLoan = (Loan_New__c) TestFactory.createSObject(new Loan_New__c(
                    LoanCompleteFlag__c = false,
                    Originating_Loan_Officer__c = testPortalUser.Id,
                    Related_Individual__c = testContact.Id,
                    Related_Partner__c = testAccount.Id,
                    TitleFeeEstimateResponse__c = testTitleFeeResponse,
                    Rate_Type__c = 'ARM'
            ), 'TestFactory.LoanDefaults');
            Database.insert (testLoan);
            // create test Client for Loan
            Client__c testClient = (Client__c) TestFactory.createSObject(new Client__c(
                    LoanId__c = testLoan.Id,
                    First_Name__c = 'Test',
                    Last_Name__c = 'Client',
                    is_Active__c = TRUE,
                    Non_Borrowing_Spouse_Name__c = 'Test Me'
            ));
            Database.insert (testClient);
            // create test Non_Borrowing_Resident__c for Loan
            Non_Borrowing_Resident__c testNonBorrowingResident = (Non_Borrowing_Resident__c) TestFactory.createSObject(new Non_Borrowing_Resident__c(
                    Loan_Id__c = testLoan.Id,
                    Client_Id__c = testClient.Id,
                    IsActiveNBR__c = TRUE,
                    Non_Borrowing_Resident_Name__c = 'Test Me',
                    Date_of_Birth__c = Date.today().addYears(-62)
            ));
            Database.insert (testNonBorrowingResident);
            // create test Income_New__c for Loan
            Income_New__c testIncome = (Income_New__c) TestFactory.createSObject(new Income_New__c(
                    Related_Loan__c = testLoan.Id,
                    Income_Value__c = 100000.00,
                    IsActive__c = TRUE,
                    RelatedClient__c = testClient.Id,
                    Income_Source__c = 'Under Mattress'
            ));
            Database.insert (testIncome);
            // create test Asset for Loan
            Asset testAsset = (Asset) TestFactory.createSObject(new Asset(
                    RelatedLoan__c = testLoan.Id,
                    IsActive__c = TRUE,
                    RelatedClient__c = testClient.Id,
                    Name = 'Test Asset',
                    Category__c = 'Others'
            ));
            Database.insert (testAsset);
            // create test Liability__c for Loan
            Liability__c testLiability = (Liability__c) TestFactory.createSObject(new Liability__c(
                    RelatedLoan__c = testLoan.Id,
                    RelatedClient__c = testClient.Id,
                    IsActive__c = TRUE,
                    Liability_Type__c = 'Divorce',
                    Type__c = 'Revolving',
                    Liability_Category__c = 'Alimony'
            ));
            Database.insert (testLiability);
            // create test Declaration__c for Loan
            Declaration__c testDeclaration = (Declaration__c) TestFactory.createSObject(new Declaration__c(
                    DeclarationLoan__c = testLoan.Id,
                    DeclarationClient__c = testClient.Id
            ));
            Database.insert (testDeclaration);
            // create test Employment__c for Loan
            Employment__c testEmployment = (Employment__c) TestFactory.createSObject(new Employment__c(
                    RelatedLoan__c = testLoan.Id,
                    Client_id__c = testClient.Id
            ));
            Database.insert (testEmployment);
            // setup EnglishChannelConfig__c custom settings (required by EnglishChannelClient)
            EnglishChannelConfig__c eccSetting = new EnglishChannelConfig__c(
                    ApiGatewayEndpoint__c = 'https://test.org',
                    ApiGatewayEndpoint1__c = 'https://test.org'
            );
            Database.insert(eccSetting);
        }
    }

    /**
     * @description Test Invocable Method AppPackageRequestHandler
     */
    @isTest
    private static void testAppPackRequestHandler(){

        // Enable Logging
        Logging_Settings__c logSettings = new Logging_Settings__c(
                Enable_Debug__c = true,
                Enable_Exceptions__c = true
        );
        Database.insert(logSettings);

        List<Loan_New__c> testLoans = [SELECT Id, Name FROM Loan_New__c];

        Test.startTest();
        AppPackageRequestHandler.requestAppPackage( new List<Id>{testLoans[0].Id} );
        Test.stopTest();

        // Use logs to validate - EnglishChannelClient - Send to BayDocs request
        List<Log__c> testLogs = [SELECT Id, Sequence__c, ApexClass__c, ApexMethod__c, Message__c FROM Log__c order by Sequence__c];
        System.assertEquals(testLogs[0].ApexClass__c, 'LoanExportUtil');
        System.assertEquals(testLogs[1].ApexClass__c, 'EnglishChannelClient');
        System.assertEquals(testLogs[2].Message__c, 'request setEndpoint https://test.org');


    }

    /***************************************************************************************************
    *						 Static Test Data
    *************************************************************************************************/

    private static String testTitleFeeResponse {
        get {
            // create enough of a title fee response to be parsed by LoanExportUtil.cls
            // this contains just the minimum sections and tokens to make parsing happy
            Map<Object, Object> titleFeeResponseMap = new Map<Object, Object>{
                    'results' => 'nothing here interesting',
                    'meta' => 'nothing here either',
                    'summary' =>
                            new Map<Object, Object>{
                                    'sections' =>
                                            new Map<Object, Object>{
                                                    'Title Fees' => '900',
                                                    'Closing Fees' => '770',
                                                    'Recording Fees' => '671',
                                                    'Additional Charges and Available Endorsements' => '25'
                                            },
                                    'required' =>
                                            new List<Object>{
                                                    new Map<Object, Object>{
                                                            'FeeTypeName' => 'Mortgage Title Premium',
                                                            'HUDLine' => '1104',
                                                            'Price' => '$900.00',
                                                            'quoteStatus' => 'formulary'
                                                    },
                                                    new Map<Object, Object>{
                                                            'FeeTypeName' => 'Closing Full Escrow 1st Mortgage Fee',
                                                            'HUDLine' => '1102',
                                                            'Price' => '$650.00',
                                                            'quoteStatus' => 'formulary'
                                                    }
                                            }
                            }
            };
            return JSON.serializePretty(titleFeeResponseMap);
        }
        private set;
    }


}