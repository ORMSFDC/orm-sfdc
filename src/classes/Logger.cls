/**
* @name           Logger
* @author         Mike Gill
* @createddate    19th October 2017
* @description    Custom Logging Framework
*
* @TODO           Record types
*
*/
public class Logger{

    public static Logging_Settings__c theSetting =
            Logging_Settings__c.getInstance();

    //This public class should be used for creating excpetions form logical faults in the application
    public class CustomException extends Exception{}

    public static final string DEBUGTYPE = 'Debug';
    public static final string EXCEPTIONTYPE = 'Exception';
    public static final string LOGRECTYPE = 'Log__c';
    public static final string STACKSTR = ' stack: ';
    public static string strApexMethod = 'n/a';
    public static string strApexClass = 'n/a';

    public class StackTrace{
        public integer level{get; private set;}
        private string function;
        private string objectName;

        public string getEntry(){
            return (objectName + ' : ' + function);
        }

        public StackTrace(integer level, string function, string objectName){
            this.level = level;
            this.function = function;
            this.objectName = objectName;
        }
    }

    static integer currentLevel = 0;
    static integer sequence = 0;
    static List<StackTrace> stack = new List<StackTrace>();
    static List<Log__c> debugList = new List<Log__c>();
    static List<Log__c> exceptionList = new List<Log__c>();

    static boolean debugLogEnabled = theSetting.Enable_Debug__c;
    static boolean exceptionLogEnabled = theSetting.Enable_Exceptions__c;

    static List<RecordType> recordTypes = [SELECT Id, Name from RecordType WHERE SobjectType =: LOGRECTYPE];

    static String idDebugRT;
    static String idExceptionRT;
    static string debugRTName = null;
    static string exceptionRTName = null; 

    /*
        @description    Push method which should be called at start of method
        @usage          Logger.push();
        @date           15th December 2017
        @author         Mike Gill (10K)
        @inputs         String function / method name & object Name / class name
        @returns        void

    */

    static public void push(string functionName, string objectName){
        strApexClass = objectName;
        strApexMethod = functionName;
        stack.add(new StackTrace(currentLevel, functionName, objectName));
        currentLevel++;

    }

    /*
        @description    Pop method which should be called at start of method
        @usage          Logger.push();
        @date           15th December 2017
        @author         Mike Gill
        @inputs         String function / method name & object Name / class name
        @returns        void

    */
    static public void pop(){
        if(currentLevel > 0){

            currentLevel--;
            if(stack.size() > 0){
                stack.remove(stack.size() -1);
            }
        }

        if(currentLevel==0){
            String debugListString = JSON.serialize(debugList);
            String exptListString = JSON.serialize(exceptionList);
            writeLogsToDatabase(exptListString, debugListString);
            debugList = new List<Log__c>();
            exceptionList = new List<Log__c>();
        }

    }

    /*
       @description    Write method used to write stack trace to log object
       @date           15th Decembe 2017
       @author         Mike Gill
       @inputs         String debug / String exception
       @returns        void

   */

    static private void writeLogsToDatabase(string exptListString,
            string debugListString){

        List<Log__c> debugListParsed = (List<Log__c>)
                JSON.deserialize(debugListString,  List<Log__c>.class);
        List<Log__c> exceptListParsed = (List<Log__c>)
                JSON.deserialize(exptListString,  List<Log__c>.class);

        //if debug custom setting is on
        if(debugLogEnabled){
            insert debugListParsed;
        }

        //if exception custom setting is on
        if(exceptionLogEnabled){
            insert exceptListParsed;
        }
    }




    static public void debug(string debugString){
        /*
        for (RecordType rt : recordTypes){

            if (rt.Name == debugRTName){

                idDebugRT = rt.Id;
            }
        }
        */

        // Insert New Log
        Log__c log = new Log__c(
                StackTrace__c = getStackTrace(),
                Limits__c = getLimits(),
                Message__c = debugString,
                LogType__c = DEBUGTYPE,
                ApexClass__c = strApexClass,
                ApexMethod__c = strApexMethod,
                User__c = Userinfo.getUserId(),
                Sequence__c = sequence);
        debugList.add(log);
        sequence++;
    }


    static public void debugException(Exception ex){
        /*
        for (RecordType rt: recordTypes){

            if (rt.Name == exceptionRTName){

                idExceptionRT = rt.Id;
            }
        }
        */
        string exceptionInfo = ex.getMessage() + STACKSTR + ex.getStackTraceString();
        Log__c log = new Log__c(
                StackTrace__c = getStackTrace(),
                Limits__c = getLimits(),
                Message__c = exceptionInfo,
                LogType__c = EXCEPTIONTYPE,
                ApexClass__c = strApexClass,
                ApexMethod__c = strApexMethod,
                User__c = Userinfo.getUserId(),
                ExceptionLine__c = ex.getLineNumber(),
                ExceptionType__c = ex.getTypeName(),
                Sequence__c = sequence);
        exceptionList.add(log);
        sequence++;

    }


    static public void debugException(string exStr){
        CustomException ex = new CustomException(exStr);
        debugException(ex);
    }


    static private string getLimits(){
        string limitstring = '';
        limitstring += 'Query Limits: '+ Limits.getQueries() + '/' + Limits.getLimitQueries() +'\n';
        limitstring += 'DML Rows Limits: '+Limits.getDMLRows()+'/' + Limits.getLimitDMLRows()+'\n';
        limitstring += 'Heap Size Limits: '+Limits.getHeapSize()+'/' +Limits.getLimitHeapSize()+'\n';
        limitstring += 'Query Return Limits: '+Limits.getQueryRows()+'/' + Limits.getLimitQueryRows()+'\n';
        limitstring += 'Aggregate Queries: '+Limits.getAggregateQueries()+'/' + Limits.getLimitAggregateQueries()+ '\n';
        limitstring += 'Callouts: '+Limits.getCallouts()+'/' +Limits.getLimitCallouts() + '\n';
        limitstring += 'CPU Time: '+Limits.getCpuTime()+'/' +Limits.getLimitCpuTime() + '\n';
        limitstring += 'DML Statements: '+Limits.getDMLStatements()+'/' +Limits.getLimitDMLStatements() + '\n';
        limitstring += 'Email Invocations: '+Limits.getEmailInvocations()+'/' +Limits.getLimitEmailInvocations() + '\n';
        limitstring += 'Future Calls: '+Limits.getFutureCalls()+'/' +Limits.getLimitFutureCalls() + '\n';
        limitstring += 'Query Locator Rows: '+Limits.getQueryLocatorRows() +'/'+Limits.getLimitQueryLocatorRows();

        return limitstring;

    }


    static private string getStackTrace(){

        string retVal ='';

        if (stack != null && stack.size() >0){
            String spaces='                                                                ';
            for (StackTrace se : stack)   {

                Integer endIndex = 3 * se.level;
                if (endIndex >= spaces.length())
                    endIndex = spaces.length()-1;
                retVal += spaces.substring(0,endIndex)+se.getEntry()+'\n';
            }
        }
        return retVal;
    }

}