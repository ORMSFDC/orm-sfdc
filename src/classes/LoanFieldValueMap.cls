public class LoanFieldValueMap {
    
    @AuraEnabled
    public String FieldName{get;set;}
    @AuraEnabled
    public list<String> FieldValue{get;set;}
    
    public LoanFieldValueMap(string FieldName,list<string> FieldValue){
        this.FieldName = FieldName;
        this.FieldValue = FieldValue;
    }

}