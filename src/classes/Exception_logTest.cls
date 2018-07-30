@isTest
public class Exception_logTest {

     @isTest
    public static void TestMethod1() {
    
    Account acc = new Account();
    try{
    insert acc;
    }catch(Exception ex){
        Exception_log.Log_exception(ex,'','');
        Exception_log.create_log('ex','ex');
    }
    
    }


}