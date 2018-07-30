/***************
***Author:Ravi
*************/
public class get_metadata{


    public static map<string,map<String,String>> get_tierData(String fetchFrom){
    //craete a map which store map<margin,map<percentage,LOC>>()  data
    map<string,map<String,String>> metataDataFields = new map<string,map<String,String>>();
     IF(fetchFrom==NULL || fetchFrom==''){
     
     fetchFrom = 'Tier1__mdt';
     }
     list<string> metadatfields = 'X0_to_10__c,X10_to_20__c,X20_to_30__c,X30_to_40__c,X40_to_50__c,X50_to_60__c,X60_to_70__c,X70_to_80__c,X80_to_90__c,X90_to_100__c'.split(',');
     String metadataQuery = 'SELECT Id, DeveloperName, MasterLabel, Language, NamespacePrefix, Label, QualifiedApiName, Margin__c, X0_to_10__c, X10_to_20__c, X20_to_30__c, X30_to_40__c, X40_to_50__c, X50_to_60__c, X60_to_70__c, X70_to_80__c, X80_to_90__c, X90_to_100__c FROM '+fetchFrom;
     list<sObject>metadataResults = database.query(metadataQuery);
     System.debug(metadataResults);
     
     for(sObject eachsObject:metadataResults){
     map<String,String> percentage_and_Loc = new map<String,String>(); 
         for(Integer i=0;i<metadatfields.size();i++){
         
             percentage_and_Loc.put(String.valueOf((i+1)*10),String.valueOf(eachsObject.get(metadatfields[i])));
         }
         metataDataFields.put(String.valueOf(eachsObject.get('Margin__c')),percentage_and_Loc);
     
     }
        return metataDataFields;
    }
    
    

    public static map<string,map<String,String>> get_tierData_fixed(String fetchFrom){
    //craete a map which store map<margin,map<percentage,LOC>>()  data
    map<string,map<String,String>> metataDataFields = new map<string,map<String,String>>();
     IF(fetchFrom==NULL || fetchFrom==''){
     
     fetchFrom = 'Fixed_Price_Tier1__mdt';
     }
     list<string> metadatfields = 'Id, DeveloperName, MasterLabel, Language, NamespacePrefix, Label, QualifiedApiName, Credit_to_Borrower__c, Origination_to_ORM__c, Price__c, Rate__c'.split(',');
     String metadataQuery = 'SELECT Id, DeveloperName, MasterLabel, Language, NamespacePrefix, Label, QualifiedApiName, Credit_to_Borrower__c, Origination_to_ORM__c, Price__c, Rate__c FROM '+fetchFrom;
     list<sObject>metadataResults = database.query(metadataQuery);
     System.debug(metadataResults);
     map<String,String> percentage_and_Loc = new map<String,String>(); 
     map<String,String> percentage_and_LocNew = new map<String,String>(); 
     
     for(sObject eachsObject:metadataResults){
         
             percentage_and_Loc.put(String.valueOf(eachsObject.get('Rate__c')),String.valueOf(eachsObject.get('Price__c')));
     
     }
             metataDataFields.put('fixed',percentage_and_Loc);
             
                 for(sObject eachsObject:metadataResults){
         
             percentage_and_LocNew.put(String.valueOf(eachsObject.get('Rate__c')),String.valueOf(eachsObject.get('Origination_to_ORM__c')));
     
     }
             metataDataFields.put('fixed_orm',percentage_and_LocNew);
    
        return metataDataFields;
    }
}