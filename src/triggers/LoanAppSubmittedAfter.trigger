trigger LoanAppSubmittedAfter on LoanAppSubmitted__e (after insert) {

    for(LoanAppSubmitted__e event : Trigger.new) {
        system.debug('trigger code');
        LoanExportUtil.LoanWithRelatedObjects_fnl loanExport = LoanExportUtil.getExportForLoanIdNew(event.LoanId__c);
        EnglishChannelClient.sendEvent('LoanAppSubmitted', loanExport,event.LoanId__c);
    }
}