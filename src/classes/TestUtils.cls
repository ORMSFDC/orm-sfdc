/**
 * @description Apex Tests for LoanSharingHandler
 * @author Mike Gill
 * @date 28th June 2018
 *
 * @todo implement test constants
 *
 */

@isTest(SeeAllData=false)
public class TestUtils {


    public static Map<String, Id> getRecordTypes(String sobjectType) {
        Map<String, Id> returnMap = new Map<String, Id>();

        for (RecordType rt : [SELECT Id, Name FROM RecordType WHERE SobjectType = :sobjectType]) {
            returnMap.put(rt.Name, rt.Id);
        }
        return returnMap;
    }

    public static User createPortalLoanProcessorUser(Id contactId){

        Id portalProfileId = [SELECT Id, Name, UserType From Profile where Name = 'Portal Loan Processor' LIMIT 1].Id;
        User testUser = (User)TestFactory.createSObject(new User( ProfileId = portalProfileId, ContactId = contactId), 'TestFactory.PartnerUserDefaults');
        return testUser;
    }

    public static Id getProfileId(String strName){
        Id profileId = [SELECT Id, Name, UserType FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;
        return profileId;
    }

    public static Id getRoleId(String strName){
        Id userRoleId = [SELECT Id, Name From UserRole WHERE Name = 'System Administrator' LIMIT 1].Id;
        return userRoleId;
    }

    public static String getAllFieldQueryString(String objectAPIName){

        String[] types = new String[]{objectAPIName};
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
        String queryString = '';

        for (Schema.DescribeSobjectResult res : results){

            Map<String, Schema.SObjectField> objfieldMap = res.sObjectType.getDescribe().fields.getMap();
            for(Schema.SObjectField Field : objfieldMap.Values())
            {
                Schema.DescribeFieldResult fieldResult = Field.getDescribe();
                queryString += fieldResult.getName() + ',';
            }

            queryString = queryString.substring(0, queryString.length()-1);

        }


        return queryString;

    }



}