/**
 * @description AppPackageRequestHandler - Standalone Class / Invocable Method for Requesting App Packages
 * @author Mike Gill
 * @date 20th July 2018
 *
 */
public without sharing class AppPackageRequestHandler {

    @InvocableMethod(label='Request App Package')

    public static List<Id> requestAppPackage(List<Id> loanIds){

        Logger.push('requestAppPackage', 'AppPackageRequest');

        for (Loan_New__c l : [SELECT Id, Name FROM Loan_New__c where Id in: loanIds]){


            LoanExportUtil.LoanWithRelatedObjects_fnl loanExport = LoanExportUtil.getExportForLoanIdNew(l.Id);
            EnglishChannelClient.sendEvent('LoanAppSubmitted', loanExport, l.Id); // Can be turned off to reduce the stack

        }

        Logger.pop();
        return loanIds;

    }

}