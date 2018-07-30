/**
 * @description LoanStatusHandler
 * @author Mike Gill
 * @date 28th June 2018
 * @changelog 
 * 07/18/18 MG/QDA Add new Status Picklist field to aid Executive Reporting filtering SFDC-103
 * 07/27/18 MG/QDA BUG FIX - Add getLoanStatusMap method to map Loan Status values back to Label SFDC-222
 *
 */
public without sharing class LoanStatusHandler {


    public static void trackLoanStatus(Map<Id, Loan_New__c> newMap, Map<Id, Loan_New__c> oldMap ){
        Logger.push('TrackLoanStatus','LoanStatusHandler');

            List<LoanStatus__c> loanStatusRecords = new List<LoanStatus__c>();

			Map<String, String> valueLabelMap = getLoanStatusMap(); // Get Loan Status Map

            for (Loan_New__c l : newMap.values()){
                
                

                // Compare old/new to detect if loan status is changing
                if (l.LoanStatus__c != oldMap.get(l.Id).LoanStatus__c){
            
                    //Logger.debug('Loan Status has changed, tracking changes...');
                    LoanStatus__c loanStatusRecord = new LoanStatus__c();
                    loanStatusRecord.Name = valueLabelMap.get(l.LoanStatus__c); // Lookup Label from Map
                    loanStatusRecord.Status__c = valueLabelMap.get(l.LoanStatus__c); // Lookup Label from Map
                    loanStatusRecord.LoanId__c = l.Id;
                    loanStatusRecord.PreviousStatus__c=valueLabelMap.get(oldMap.get(l.Id).LoanStatus__c); // Lookup Label from Map
                    loanStatusRecords.add(loanStatusRecord);

                }

            }

            try{
                insert loanStatusRecords; // insert 
            } catch (Exception ex){
                Logger.debugException(ex);
            }

        Logger.pop();
    }

	/**
	 * @description Get Map of Loan Status API to Label
	 * @return Map of API to Label
	 */
    private static Map<String, String> getLoanStatusMap(){
		Logger.push('getLoanStatusMap','LoanStatusHandler');
		Schema.DescribeFieldResult fieldResult = Loan_New__c.LoanStatus__c.getDescribe();
        List<Schema.PicklistEntry> values = fieldResult.getPicklistValues();
        Map<String, String> valueLabelMap = new Map<String,String>();
        for( Schema.PicklistEntry v : values) {
            valueLabelMap.put(v.getValue(), v.getLabel());
        }

		Logger.pop();
		return valueLabelMap;

    }


}