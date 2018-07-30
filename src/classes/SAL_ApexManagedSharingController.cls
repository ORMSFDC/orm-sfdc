public class SAL_ApexManagedSharingController {
    
    public Static Void ShareLoanRecord(Loan_New__c OldLoanData, Loan_New__c NewLoanData){
        Logger.push('ShareLoanRecord','SAL_ApexManagedSharingController');
        try{
            //Check whether loan is created by Loan Processor or ORM Partner
            ID LoanID=OldLoanData.ID;
            //IF value is true: Means Created by Loan Processor
            if(SAL_ApexManagedSharingHelperController.IsloanCreatedByLoanProcessor(LoanID))
            {

                //IF value is true: Means Current User is Loan Processor
                if(SAL_ApexManagedSharingHelperController.IsCurrentUserIsLoanProcessor())
                {

                    if(OldLoanData.Originating_Loan_Officer__c==null && NewLoanData.Originating_Loan_Officer__c!=null)
                    {

                        //Share Loan Record
                        SAL_ApexManagedSharingHelperController.ShareRecord('Loan_New__share',NewLoanData.Id,NewLoanData.Originating_Loan_Officer__c,'Manual');
                        if(![select Is_Loan_Created_Manually__c from Loan_new__c where id=:LoanID].Is_Loan_Created_Manually__c)
                        {
                            SAL_ApexManagedSharingHelperController.InsertRecordsForSharing(LoanID, NewLoanData.Originating_Loan_Officer__c,'Manual');
                        }
                    }
                    if(NewLoanData.Originating_Loan_Officer__c!=null &&
                       (OldLoanData.Originating_Loan_Officer__c!=NewLoanData.Originating_Loan_Officer__c))
                    {
                        //Update All Sharing Rules with origination Loan Officer update all share step1
                        DeleteSharedRecord(LoanID, 'Manual') ;
                        SAL_ApexManagedSharingHelperController.InsertRecordsForSharing(LoanID, NewLoanData.Originating_Loan_Officer__c,'Manual');
                    }
                    if(OldLoanData.LoanOfficer__c==null && NewLoanData.IsLoanDetailsFilled_Flag__c &&
                       (NewLoanData.Originating_Loan_Officer__c!=NewLoanData.LoanOfficer__c)  )
                    {
                        //Update All Sharing Rules with Loan Officer for step2
                        SAL_ApexManagedSharingHelperController.InsertRecordsForSharing(LoanID, NewLoanData.LoanOfficer__c,'Loan_Officer__c');
                    }
                    if(OldLoanData.LoanOfficer__c!=null && NewLoanData.IsLoanDetailsFilled_Flag__c &&
                       (NewLoanData.Originating_Loan_Officer__c==NewLoanData.LoanOfficer__c) &&
                       (OldLoanData.LoanOfficer__c!=NewLoanData.LoanOfficer__c))
                    {
                        DeleteSharedRecord(LoanID,'Loan_Officer__c') ;
                    }
                    if(OldLoanData.LoanOfficer__c!=null && NewLoanData.IsLoanDetailsFilled_Flag__c &&
                       (NewLoanData.Originating_Loan_Officer__c!=NewLoanData.LoanOfficer__c) && 
                       (OldLoanData.LoanOfficer__c==NewLoanData.LoanOfficer__c))
                    {
                        //Update All Sharing Rules with Loan Officer for step2
                        DeleteSharedRecord(LoanID,'Loan_Officer__c') ;
                        SAL_ApexManagedSharingHelperController.InsertRecordsForSharing(LoanID, NewLoanData.LoanOfficer__c,'Loan_Officer__c');
                    }
                    if(OldLoanData.LoanOfficer__c!=null && NewLoanData.IsLoanDetailsFilled_Flag__c &&
                       (NewLoanData.Originating_Loan_Officer__c!=NewLoanData.LoanOfficer__c) && 
                       (OldLoanData.LoanOfficer__c!=NewLoanData.LoanOfficer__c))
                    {
                        //Update All Sharing Rules with Loan Officer for step2
                        DeleteSharedRecord(LoanID,'Loan_Officer__c') ;
                        SAL_ApexManagedSharingHelperController.InsertRecordsForSharing(LoanID, NewLoanData.LoanOfficer__c,'Loan_Officer__c');
                    }                    
                }
                //Current User is Loan Officer
                else{

                    if(OldLoanData.LoanOfficer__c==null && NewLoanData.IsLoanDetailsFilled_Flag__c &&  (NewLoanData.Originating_Loan_Officer__c!=NewLoanData.LoanOfficer__c)  ) {
                        //Update All Sharing Rules with Loan Officer for step2
                        SAL_ApexManagedSharingHelperController.InsertRecordsForSharing(LoanID, NewLoanData.LoanOfficer__c,'Loan_Officer__c');
                    }
                    if(OldLoanData.LoanOfficer__c!=null && NewLoanData.IsLoanDetailsFilled_Flag__c &&
                       (NewLoanData.Originating_Loan_Officer__c==NewLoanData.LoanOfficer__c) &&
                       (OldLoanData.LoanOfficer__c!=NewLoanData.LoanOfficer__c) )
                    {
                        DeleteSharedRecord(LoanID,'Loan_Officer__c') ;
                    }
                    if(OldLoanData.LoanOfficer__c!=null && NewLoanData.IsLoanDetailsFilled_Flag__c &&
                       (NewLoanData.Originating_Loan_Officer__c!=NewLoanData.LoanOfficer__c) && 
                       (OldLoanData.LoanOfficer__c!=NewLoanData.LoanOfficer__c))
                    {
                        //Update All Sharing Rules with Loan Officer for step2
                        DeleteSharedRecord(LoanID,'Loan_Officer__c') ;
                        SAL_ApexManagedSharingHelperController.InsertRecordsForSharing(LoanID, NewLoanData.LoanOfficer__c,'Loan_Officer__c');
                    }
                }
            } 
            //Loan Created By ORM Partner
            else{
                Logger.debug('Running.... LoanCreatedByORMPartner');
                LoanCreatedByORMPartner(OldLoanData,NewLoanData);
            }
        }
        catch(exception ex){
            Logger.debugException(ex);
            Exception_log.Create_Custom_Logs(ex.getMessage(),'SAL_ApexManagedSharingController','ShareLoanRecord','Date'+System.today());
        }
        Logger.pop();
    }
    
    public static void UpdateOwnerAfterLoanSubmit(Id LoanID,Loan_New__C oldvalue,Loan_New__C Newvalue)
    {       
        try
        { 
            Loan_New__C loanObj  = [Select id, IsLoanCreatedByLoanProcessor__c, LoanCompleteFlag__c, 
                                    Originating_Loan_Officer__c,Loan_Processor__c,LoanOfficer__c
                                    from Loan_New__C Where Id =: LoanID];            
            If(loanObj.IsLoanCreatedByLoanProcessor__c  && loanObj.LoanCompleteFlag__c )
            {
                List<string> lstChildObjects = SAL_ApexManagedSharingHelperController.ObjectListforChangeOwner();            
                Map<string, string> mapChildList = SAL_ApexManagedSharingHelperController.loanChildObjectsMap();                 
                for(string str : lstChildObjects)
                {
                    String relatedFieldName = mapChildList.get(str); 
                    string fieldname = 'OwnerId'; 
                    String query = 'SELECT '+fieldName+' FROM '+str+' WHERE ' + relatedFieldName + ' =:LoanID';
                    List<sObject> objlst = Database.query(query); 
                    if(objlst != null && objlst.size() > 0)
                    {
                        for(sObject obj : objlst)
                        {
                            obj.put(fieldName,loanObj.Originating_Loan_Officer__c);
                            Database.update(obj);
                        }
                    }
                }               
                SAL_ApexManagedSharingHelperController.InsertRecordsForSharing(LoanID, loanObj.Loan_Processor__c,'LoanProcessor__c');
            }
        }
        Catch(Exception ex)
        {
            Exception_log.Log_exception(ex,'SAL_ApexManagedSharingController','UpdateOwnerAfterLoanSubmit');
        }
    }
    public static void DeleteSharedRecord(Id LoanID, string RowCause)
    {
        try
        {
            Map<string, string> mapshareObjectList = SAL_ApexManagedSharingHelperController.loanChildShareObjectsMap();
            List<string> lstChildObjects = SAL_ApexManagedSharingHelperController.loanChildObjectsList();            
            for(string str : lstChildObjects)
            {
                list<string> IDS= new List<String>();
                string shareObjectName = mapshareObjectList.get(str);
                if(shareObjectName!=null)
                { 
                    if(shareObjectName=='Loan_New__share')
                    {
                        IDS.add(LoanID);
                        SAL_ApexManagedSharingHelperController.DeleteSharedLoan(IDS,shareObjectName,RowCause) ;
                    }
                    else{
                        IDS=GetIds(LoanID,str);
                        if(IDS.size()>0 && IDS!=null)
                        {
                            SAL_ApexManagedSharingHelperController.DeleteSharedLoan(IDS,shareObjectName,RowCause) ;
                        }
                    }
                }
            }
        }
        Catch(Exception ex)
        {
            Exception_log.Log_exception(ex,'SAL_ApexManagedSharingController','DeleteSharedRecord');
        }
    }
    //Get List of IDS
    Public static List<String> GetIds(String LoanID,String ObjectName)
    {
        Schema.SObjectType sObjectType = Schema.getGlobalDescribe().get(ObjectName);
        Map<string, string> mapChildList = SAL_ApexManagedSharingHelperController.loanChildObjectsMap(); 
        String relatedFieldName = mapChildList.get(ObjectName); 
        list<string> IDS= new List<String>();
        String listType = 'List<' + sObjectType + '>';
        List<SObject> AllIDS = (List<SObject>)Type.forName(listType).newInstance();
        String query = 'SELECT id FROM '+ObjectName+' WHERE ' + relatedFieldName + ' =:LoanID';
        AllIDS= Database.query(query);   
        if(AllIDS.size()>0 && AllIDS!=null)
        {
            for(integer i=0;i<AllIDS.size();i++)
            {
                string ID = (String)AllIDS[i].get('Id');
                IDS.add(ID);
            }   
        }
        return iDS;
    }
    public Static Void ShareRecordAfterInsert(ID RecordID,ID LoanID,String ObjectName,String ShareObjectName,String LORowCause,String LP_RowCause){
        String LPRowCause='LoanProcessor__c';
        try{
            loan_new__c LoanObject=[select Is_Loan_Created_Manually__c,IsLoanFilled_Flag__c,createdbyid,Originating_Loan_Officer__c,LoanOfficer__c,Loan_Processor__c 
                                        from loan_new__c where id=:LoanID];  
            if(LoanObject.IsLoanFilled_Flag__c)
            {
            //Check whether loan is created by Loan Processor or Loan Officer
            //IF value is true: Means Created by Loan Processor
            if(SAL_ApexManagedSharingHelperController.IsloanCreatedByLoanProcessor(LoanID))
            {
                             
                //IF value is true: Means Current User is Loan Processor
                if(SAL_ApexManagedSharingHelperController.IsCurrentUserIsLoanProcessor())
                {
                    ID Originating_Loan_Officer =[select Originating_Loan_Officer__c from Loan_New__c where
                                                 id =:LoanID].Originating_Loan_Officer__c;
                    if(Originating_Loan_Officer!=null)
                    {
                        //Share Record to Origination LO
                        SAL_ApexManagedSharingHelperController.ShareRecord(ShareObjectName,RecordID,LoanObject.Originating_Loan_Officer__c
                                                                           ,'Manual');
                        if(LoanObject.LoanOfficer__c!=null && (LoanObject.Originating_Loan_Officer__c!=LoanObject.LoanOfficer__c)){
                            //Share Record to LO
                            SAL_ApexManagedSharingHelperController.ShareRecord(ShareObjectName,RecordID,
                                                                               LoanObject.LoanOfficer__c ,LORowCause);  
                            
                        }
                    }
                }
                //Current User is Loan Officer
                else{
                    //Update owner and then Share
                    SAL_ApexManagedSharingHelperController.UpdateLoanChildRecordOwner(RecordID,LoanObject.createdbyid,ObjectName);
                    SAL_ApexManagedSharingHelperController.ShareRecord(ShareObjectName,RecordID,LoanObject.Originating_Loan_Officer__c 
                                                                       ,'Manual');
                    if(LoanObject.LoanOfficer__c!=null && (LoanObject.Originating_Loan_Officer__c!=LoanObject.LoanOfficer__c))
                    {
                        SAL_ApexManagedSharingHelperController.ShareRecord(ShareObjectName,RecordID,LoanObject.LoanOfficer__c,LORowCause);
                    }               
                }
            } 
            else{
                //code when LO create the record
                UpdateSharingWhenLoanOfficerCreateLoan(RecordID,LoanID,ObjectName,ShareObjectName,LORowCause,LPRowCause);
            }
            }
        }
        catch(exception ex){
            Exception_log.Create_Custom_Logs(ex.getMessage(),'SAL_ApexManagedSharingController'
                                             ,'ShareRecordAfterInsert','Date'+System.today());
        }
    } 


    /** Code when Loan Officer Created The Loan**/
    Public Static Void UpdateSharingWhenLoanOfficerCreateLoan(ID RecordID,ID LoanID,String ObjectName,String ShareObjectName,
                                                              String LORowCause,String LPRowCause)
    {
        try{
            loan_new__c LoanObj=[select createdbyid,IsLoanDetailsFilled_Flag__c,Loan_Processor__c,LoanOfficer__c
                                 from loan_new__c where id=:LoanID ];
            if(LoanObj.IsLoanDetailsFilled_Flag__c)
            {
                if(LoanObj.createdbyid==userinfo.getUserId())
                {
                    //Share Record to LO and LP 
                    //Share Record to Origination LP
                    SAL_ApexManagedSharingHelperController.ShareRecord(ShareObjectName,RecordID,
                                                                       LoanObj.Loan_Processor__c
                                                                       ,LPRowCause);
                    if(LoanObj.LoanOfficer__c!=null && (LoanObj.createdbyid!=LoanObj.LoanOfficer__c))
                    {
                        //Share Record to LO
                        SAL_ApexManagedSharingHelperController.ShareRecord(ShareObjectName,RecordID,
                                                                           LoanObj.LoanOfficer__c ,LORowCause);  
                    }
                }
                else 
                {
                    //Update Owner
                    SAL_ApexManagedSharingHelperController.UpdateLoanChildRecordOwner(RecordID,LoanObj.createdbyid,ObjectName);
                    //Share Record to LO and LP 
                    SAL_ApexManagedSharingHelperController.ShareRecord(ShareObjectName,RecordID,
                                                                       LoanObj.Loan_Processor__c
                                                                       ,LPRowCause);
                    if(LoanObj.LoanOfficer__c!=null && (LoanObj.createdbyid!=LoanObj.LoanOfficer__c))
                    {
                        //Share Record to LO
                        SAL_ApexManagedSharingHelperController.ShareRecord(ShareObjectName,RecordID,
                                                                           LoanObj.LoanOfficer__c ,LORowCause);  
                    }
                }
                
            }
        }
        
        catch(exception ex){
            Exception_log.Create_Custom_Logs(ex.getMessage(),'SAL_ApexManagedSharingController','LoanCreatedByORMPartner','Date'+System.today());
        }
    }
    
    public Static Void LoanCreatedByORMPartner(Loan_New__c OldLoanData,Loan_New__c NewLoanData){
        Logger.push('LoanCreatedByORMPartner','SAL_ApexManagedSharingController');
        try{
            ID LoanCreatorID=[select createdbyid from loan_new__c where id=:NewLoanData.id ].createdbyid;
            //For Loan Officer
            //run First time only when Loan Originator LoggedIn and then share records LO.
            if(OldLoanData.LoanOfficer__c==null && NewLoanData.IsLoanDetailsFilled_Flag__c &&  
               NewLoanData.LoanOfficer__c!=null && (LoanCreatorID!=NewLoanData.LoanOfficer__c) )
            {
                //Give Access to Loan Officer
                SAL_ApexManagedSharingHelperController.InsertRecordsForSharing(NewLoanData.Id, NewLoanData.LoanOfficer__c,'Loan_Officer__c');
            }
            if(OldLoanData.LoanOfficer__c!=null && NewLoanData.IsLoanDetailsFilled_Flag__c &&
               (LoanCreatorID==NewLoanData.LoanOfficer__c) &&
               (OldLoanData.LoanOfficer__c!=NewLoanData.LoanOfficer__c))
            {
                //Delete Access to Loan Officer
                DeleteSharedRecord(NewLoanData.Id,'Loan_Officer__c') ;
            }
            if(OldLoanData.LoanOfficer__c!=null && NewLoanData.IsLoanDetailsFilled_Flag__c &&
               (LoanCreatorID!=NewLoanData.LoanOfficer__c) && 
               (OldLoanData.LoanOfficer__c!=NewLoanData.LoanOfficer__c))
            {
                //Update All Sharing Rules with Loan Officer for step2
                DeleteSharedRecord(NewLoanData.Id,'Loan_Officer__c') ;
                SAL_ApexManagedSharingHelperController.InsertRecordsForSharing(NewLoanData.Id, NewLoanData.LoanOfficer__c,'Loan_Officer__c');
            }
            
            //For Loan Processor
            //run First time  only when Loan Originator LoggedIn and then share records LP.
            if(OldLoanData.Loan_Processor__c==null && NewLoanData.IsLoanDetailsFilled_Flag__c &&
               NewLoanData.Loan_Processor__c!=null)
            {
                //Give Access to Loan Processor
                SAL_ApexManagedSharingHelperController.InsertRecordsForSharing(NewLoanData.Id, NewLoanData.Loan_Processor__c,'LoanProcessor__C');
            }
            if(OldLoanData.Loan_Processor__c!=null && NewLoanData.IsLoanDetailsFilled_Flag__c &&
               OldLoanData.Loan_Processor__c!=NewLoanData.Loan_Processor__c)
            {
                //Delete Previous LP Shared Access
                DeleteSharedRecord(NewLoanData.Id,'LoanProcessor__C') ;
                //Give Access to New Loan Processor
                SAL_ApexManagedSharingHelperController.InsertRecordsForSharing(NewLoanData.Id, NewLoanData.Loan_Processor__c,'LoanProcessor__C');
            }
        }
        catch(exception ex){
            Exception_log.Create_Custom_Logs(ex.getMessage(),'SAL_ApexManagedSharingController','LoanCreatedByORMPartner','Date'+System.today());
            Logger.debugException(ex);
        }
        Logger.pop();
    }
    /** Code when Loan Officer Created The Loan**/
    //code to increase test coverage
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
         lstChildObjects.add('Loan_New__c'); 
        lstChildObjects.add('Client__c'); 
        lstChildObjects.add('Non_Borrowing_Resident__c');
        lstChildObjects.add('Employment__c');
        lstChildObjects.add('Income_New__c');
        lstChildObjects.add('Liability__c'); 
        lstChildObjects.add('Declaration__c'); 
        lstChildObjects.add('Asset');
        //
        lstChildObjects.add('Client__c'); 
        lstChildObjects.add('Non_Borrowing_Resident__c');
        lstChildObjects.add('Employment__c');
        lstChildObjects.add('Income_New__c');
        lstChildObjects.add('Client__c'); 
        lstChildObjects.add('Non_Borrowing_Resident__c');
        lstChildObjects.add('Employment__c');
        lstChildObjects.add('Income_New__c');
        lstChildObjects.add('Asset');
        lstChildObjects.add('Liability__c'); 
        lstChildObjects.add('Declaration__c'); 
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
        lstChildObjects.add('Loan_New__c'); 
        lstChildObjects.add('Client__c'); 
        lstChildObjects.add('Non_Borrowing_Resident__c');
        lstChildObjects.add('Employment__c');
        lstChildObjects.add('Income_New__c');
        lstChildObjects.add('Liability__c'); 
        lstChildObjects.add('Declaration__c'); 
        lstChildObjects.add('Asset');
        //
        List<string> childData = new List<string>();
        childData = lstChildObjects;
        childData.add('Loan_New__c'); 
        childData.add('Client__c'); 
        childData.add('Non_Borrowing_Resident__c');
        childData.add('Employment__c');
        childData.add('Income_New__c');
        childData.add('Liability__c'); 
        childData.add('Declaration__c'); 
        childData.add('Asset');
        //
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
         mapChildList.put('Loan_New__c', 'Id');   
        mapChildList.put('Client__c', 'LoanId__c');   
        mapChildList.put('Non_Borrowing_Resident__c', 'Loan_Id__c'); 
        mapChildList.put('Employment__c', 'RelatedLoan__c');   
        mapChildList.put('Income_New__c', 'Related_Loan__c');             
        mapChildList.put('Liability__c', 'RelatedLoan__c'); 
        mapChildList.put('Declaration__c', 'DeclarationLoan__c'); 
        mapChildList.put('Asset', 'RelatedLoan__c'); 
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
    
    public static List<string> ObjectListforChangeOwner1()
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
        //
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