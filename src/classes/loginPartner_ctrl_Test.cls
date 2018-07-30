@isTest
public with sharing class loginPartner_ctrl_Test {

    @isTest static void createTaskTest()
    { 
    try{
        loginPartner_ctrl.create_task();
    }catch(Exception ex){}
    }
}