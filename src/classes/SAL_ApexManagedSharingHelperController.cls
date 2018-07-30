public class SAL_ApexManagedSharingHelperController {    
    public Static Void ShareRecord(String ShareObjectName,ID ParentId,Id UserOrGroupId,String RowCause)
    {
        try{
            Schema.SObjectType testShareType = Schema.getGlobalDescribe().get(ShareObjectName);
            SObject testShare = testShareType.newSObject();
            testShare.put('ParentId', ParentId);
            testShare.put('UserOrGroupId', UserOrGroupId);
            testShare.put('AccessLevel', 'Edit');
            testShare.put('RowCause', RowCause);
            insert testShare;
        }
        catch(exception ex){
            Exception_log.Create_Custom_Logs(ex.getMessage(),'SAL_ApexManagedSharingHelperController','SharedRecord:'+ShareObjectName,'Date'+System.today());
        }
    }
    public static void  DeleteSharedLoan(List<string> IDs,String ShareObjectName,String RowCause) 
    {
        try{
            Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(ShareObjectName);
            if (sObjectType != null)
            {
                string AccessLevelVal='All';
                String listType = 'List<' + sObjectType + '>';
                List<SObject> AllSharesLoan = (List<SObject>)Type.forName(listType).newInstance();
                String query = 'SELECT Id,UserOrGroupId,AccessLevel FROM '+ShareObjectName+
                    ' where ParentId in:IDs and AccessLevel!=:AccessLevelVal and Rowcause=:RowCause';
                AllSharesLoan= Database.query(query);   
                List<SObject> SharesLoanforDelete = (List<SObject>)Type.forName(listType).newInstance();
                if(AllSharesLoan.size()>0 && AllSharesLoan!=null)
                {
                    for(integer i=0;i<AllSharesLoan.size();i++)
                    {
                        Schema.SObjectType testShareType = Schema.getGlobalDescribe().get(ShareObjectName);
                        SObject testShare = testShareType.newSObject();
                        testShare.put('Id',  (String) AllSharesLoan[i].get('Id')); 
                        SharesLoanforDelete.add(testShare);
                    }
                    Delete SharesLoanforDelete;
                }
            }
        }
        catch(Exception ex)
        {
            Exception_log.Create_Custom_Logs(ex.getMessage(),'ShareLoan Exception','DeleteSharedLoan','if Else Part');
        }
    }
    public static void UpdateLoanChildRecordOwner(ID RecordID,Id OwnerID,String ObjectName)
    {       
        try
        { 
            Schema.SObjectType sobjecttype = Schema.getGlobalDescribe().get(ObjectName);
            SObject sobjct = sobjecttype.newSObject();
            sobjct.put('Id', RecordID);
            sobjct.put('OwnerId', OwnerID);
            update sobjct;
        }
        Catch(Exception ex)
        {
            Exception_log.Log_exception(ex,'UpdateOwnerWhileSharing','updateOwner');
        }
    }
    public static void InsertRecordsForSharing(Id LoanID, Id loanOfficer,string RowCause)
    {
        try
        {
            List<string> lstChildObjects = loanChildObjectsList();            
            Map<string, string> mapChildList = loanChildObjectsMap(); 
            Map<string, string> mapshareObjectList = loanChildShareObjectsMap();
            for(string str : lstChildObjects)
            {
                String relatedFieldName = mapChildList.get(str); 
                string fieldname = 'Id'; 
                String query = 'SELECT '+fieldName+' FROM '+str+' WHERE ' + relatedFieldName + ' =:LoanID';
                List<sObject> objlst = Database.query(query);                
                if(objlst != null && objlst.size() > 0)
                {
                    for(integer i=0;i<objlst.size();i++)
                    { 
                        string shareObjectName = mapshareObjectList.get(str);
                        if(shareObjectName!=null)
                        {
                            ShareRecord(shareObjectName, (String)objlst[i].get('Id'),loanOfficer,RowCause);
                        }
                    }   
                }
            }
        }
        Catch(Exception ex)
        {
            Exception_log.Log_exception(ex,'UpdateOwnerWhileSharing','insertRecordsForSharing');
        }
    }
    public Static Boolean IsloanCreatedByLoanProcessor(ID LoanID)
    {
        return [select IsLoanCreatedByLoanProcessor__c from Loan_New__c where Id=:LoanID].IsLoanCreatedByLoanProcessor__c;
    }
    public static boolean  IsCurrentUserIsLoanProcessor()
    {
        Boolean IsCurrentUserIsLoanProcessor=false;
        try
        {
            ID profileId=UserInfo.getProfileId();
            if(profileId !=null)
            {
                string ProfileName=[SELECT Name FROM Profile where id= :profileId].Name;
                if(ProfileName=='Portal Loan Processor' || ProfileName=='Portal Loan Processors' )
                {
                    IsCurrentUserIsLoanProcessor=true;
                }
            }
         }
        catch(Exception ex)
        {
            Exception_log.Create_Custom_Logs(ex.getMessage(),'SAL_ApexManagedSharingHelperController','IsLoanCreatedByLoanProcessor','Exception');
        }
        return IsCurrentUserIsLoanProcessor;
    }
    public static List<string> ObjectListforChangeOwner()
    {
        List<string> lstChildObjects = new List<string>();
        //lstChildObjects.add('Loan_New__c'); 
        lstChildObjects.add('Client__c'); 
        lstChildObjects.add('Non_Borrowing_Resident__c');
        lstChildObjects.add('Employment__c');
        lstChildObjects.add('Income_New__c');
        lstChildObjects.add('Asset');
        lstChildObjects.add('Liability__c'); 
        lstChildObjects.add('Declaration__c'); 
        return lstChildObjects;
    }  
    public static List<string> loanChildObjectsList()
    {
        List<string> lstChildObjects = new List<string>();
        lstChildObjects.add('Loan_New__c'); 
        lstChildObjects.add('Client__c'); 
        lstChildObjects.add('Non_Borrowing_Resident__c');
        lstChildObjects.add('Employment__c');
        lstChildObjects.add('Income_New__c');
        lstChildObjects.add('Liability__c'); 
        lstChildObjects.add('Declaration__c'); 
        lstChildObjects.add('Asset');
        return lstChildObjects;
    }
    public static  Map<string, string> loanChildShareObjectsMap()
    {
        Map<string, string> mapChildList = new Map<string, string>();
        mapChildList.put('Loan_New__c', 'Loan_New__share');  
        mapChildList.put('Client__c', 'Client__share');   
        mapChildList.put('Non_Borrowing_Resident__c', 'Non_Borrowing_Resident__share'); 
        mapChildList.put('Employment__c', 'Employment__share');   
        mapChildList.put('Income_New__c', 'Income_New__share'); 
        mapChildList.put('Liability__c', 'Liability__share'); 
        mapChildList.put('Declaration__c', 'Declaration__share'); 
        return mapChildList;
    }
    public static  Map<string, string> loanChildObjectsMap()
    {
        Map<string, string> mapChildList = new Map<string, string>(); 
        mapChildList.put('Loan_New__c', 'Id');   
        mapChildList.put('Client__c', 'LoanId__c');   
        mapChildList.put('Non_Borrowing_Resident__c', 'Loan_Id__c'); 
        mapChildList.put('Employment__c', 'RelatedLoan__c');   
        mapChildList.put('Income_New__c', 'Related_Loan__c');             
        mapChildList.put('Liability__c', 'RelatedLoan__c'); 
        mapChildList.put('Declaration__c', 'DeclarationLoan__c'); 
        mapChildList.put('Asset', 'RelatedLoan__c'); 
        return mapChildList;
    }
    
    
}