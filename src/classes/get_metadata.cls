/**
 * @description: fetch Pricing metadata and refer to these values in Lightning component  
 * @author: Ravi
 * @date: 1/17/2018
 *
 * changelog:
 * 07/17/2018: Sahitya - added method for fetching Helo metadata tables
 * 08/20/2018: Sahitya -SFDC - 250
 * 09/20/2018: Sahitya -SFDC - 289 - adding 3rd tier for Pricing
 */
public class get_metadata{    
    public static map<string,map<String,String>> get_tierData(String fetchFrom){
        Logger.push('get_tierData', 'get_metadata');
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
        Logger.pop();
        return metataDataFields;        
    }
    
    public static map<string,map<String,String>> get_tierData_fixed(String fetchFrom){
        Logger.push('get_tierData', 'get_metadata');
        //craete a map which store map<margin,map<percentage,LOC>>()  data
        map<string,map<String,String>> metataDataFields = new map<string,map<String,String>>();
        //SFDC - 289 start
        String partnerType = [select id,Contact.AccountId,Contact.Account.Partner_Type__c from user where id=:userinfo.getUserId()].Contact.Account.Partner_Type__c;
        
        IF((fetchFrom==NULL || fetchFrom=='') && partnerType == 'Non Premier'){
            fetchFrom = 'Fixed_Price_Tier1__mdt';
        }
        ELSE IF((fetchFrom==NULL || fetchFrom=='') && partnerType == 'Premier'){
            fetchFrom = 'Fixed_Price_Tier2__mdt';
        }
        ELSE IF((fetchFrom==NULL || fetchFrom=='') && partnerType == 'Premier Plus'){
            fetchFrom = 'Fixed_Price_Tier3__mdt';
        }    
        //SFDC - 289 end
        list<string> metadatfields = 'Id, DeveloperName, MasterLabel, Language, NamespacePrefix, Label, QualifiedApiName, Credit_to_Borrower__c, Origination_to_ORM__c, Price__c, Rate__c'.split(',');
        String metadataQuery = 'SELECT Id, DeveloperName, MasterLabel, Language, NamespacePrefix, Label, QualifiedApiName, Credit_to_Borrower__c, Origination_to_ORM__c, Price__c, Rate__c FROM '+fetchFrom;
        list<sObject>metadataResults = database.query(metadataQuery);
        System.debug(metadataResults);
        map<String,String> percentage_and_Loc = new map<String,String>(); 
        map<String,String> percentage_and_LocNew = new map<String,String>(); 
        map<String,String> fixed_rate = new map<String,String>(); //SFDC-250
        
        for(sObject eachsObject:metadataResults){
            percentage_and_Loc.put(String.valueOf(eachsObject.get('Rate__c')),String.valueOf(eachsObject.get('Price__c')));
        }
        metataDataFields.put('fixed',percentage_and_Loc);
        for(sObject eachsObject:metadataResults){
            percentage_and_LocNew.put(String.valueOf(eachsObject.get('Rate__c')),String.valueOf(eachsObject.get('Origination_to_ORM__c')));
        }
        metataDataFields.put('fixed_orm',percentage_and_LocNew);
        //SFDC-250
        for(sObject eachsObject:metadataResults){
            fixed_rate.put(String.valueOf(eachsObject.get('Rate__c')),String.valueOf(eachsObject.get('Rate__c')));
        }
        metataDataFields.put('fixed_rate_orm',fixed_rate);
        Logger.pop();
        return metataDataFields;
    }
    
    //Fetch Helo Tier data
    public static map<string,map<String,String>> get_tierData_Helo(String fetchFrom){
        Logger.push('get_tierData', 'get_metadata');
        system.debug('fetchFrom '+fetchFrom);
        //SFDC - 289 start
        String partnerType = [select id,Contact.AccountId,Contact.Account.Partner_Type__c from user where id=:userinfo.getUserId()].Contact.Account.Partner_Type__c;
        map<string,map<String,String>> metataDataFields = new map<string,map<String,String>>();
        
        IF((fetchFrom==NULL || fetchFrom=='') && partnerType == 'Non Premier'){
            fetchFrom = 'Proprietary_Tier_1__mdt';
        }
        ELSE IF((fetchFrom==NULL || fetchFrom=='') && partnerType == 'Premier'){
            fetchFrom = 'Proprietary_Tier_2__mdt';
        }
        ELSE IF((fetchFrom==NULL || fetchFrom=='') && partnerType == 'Premier Plus'){
            fetchFrom = 'Proprietary_Tier_3__mdt';
        }    
        //SFDC - 289 end
        fetchFrom = fetchFrom.replace(',','');               
        list<string> metadatfields = 'Id, DeveloperName, MasterLabel, Language, NamespacePrefix, Label, QualifiedApiName, Credit_to_Borrower__c, Origination_to_Partner__c, Price__c, Rate__c, Servicing_Fee__c'.split(',');
        String metadataQuery = 'SELECT Id, DeveloperName, MasterLabel, Language, NamespacePrefix, Label, QualifiedApiName, Credit_to_Borrower__c, Origination_to_Partner__c, Price__c, Rate__c, Servicing_Fee__c FROM '+fetchFrom;
        list<sObject>metadataResults = database.query(metadataQuery);
        System.debug('>>>metadataResults '+metadataResults);
        map<String,String> heloPrice = new map<String,String>(); 
        map<String,String> heloRate = new map<String,String>(); 
        map<String,String> heloOrigination = new map<String,String>(); 
        map<String,String> rateToServiceFee = new map<String,String>(); 
        
        for(sObject eachsObject:metadataResults){
            heloPrice.put(String.valueOf(eachsObject.get('Rate__c')),String.valueOf(eachsObject.get('Price__c')));
        }
        metataDataFields.put('Helo',heloPrice);
        
        for(sObject eachsObject:metadataResults){ 
            heloRate.put(String.valueOf(eachsObject.get('Rate__c')),String.valueOf(eachsObject.get('Rate__c')));        
        }
        metataDataFields.put('Helo_rate',heloRate);
        
        for(sObject eachsObject:metadataResults){
            heloOrigination.put(String.valueOf(eachsObject.get('Rate__c')),String.valueOf(eachsObject.get('Origination_to_Partner__c')));
        }
        metataDataFields.put('Helo_orm',heloOrigination);
        
        for(sObject eachsObject:metadataResults){
            rateToServiceFee.put(String.valueOf(eachsObject.get('Rate__c')),String.valueOf(eachsObject.get('Servicing_Fee__c')));
        }
        system.debug('>>>rateToServiceFee '+rateToServiceFee);
        metataDataFields.put('Helo_service',rateToServiceFee);
        Logger.pop();
        return metataDataFields;
    }

    //Fetch Helo ARM Tier data
    public static map<string,map<String,String>> get_tierData_HeloARM(String fetchFrom){
        Logger.push('get_tierData_HeloARM', 'get_metadata');
        system.debug('fetchFrom '+fetchFrom);
        String partnerType = [select id,Contact.AccountId,Contact.Account.Partner_Type__c from user where id=:userinfo.getUserId()].Contact.Account.Partner_Type__c;
        map<string,map<String,String>> metataDataFields = new map<string,map<String,String>>();
        
        IF((fetchFrom==NULL || fetchFrom=='') && partnerType == 'Non Premier'){
            fetchFrom = 'HELO_ARM_1__mdt';
        }
        ELSE IF((fetchFrom==NULL || fetchFrom=='') && partnerType == 'Premier'){
            fetchFrom = 'HELO_ARM_2__mdt';
        }
        ELSE IF((fetchFrom==NULL || fetchFrom=='') && partnerType == 'Premier Plus'){
            fetchFrom = 'HELO_ARM_3__mdt';
        }    
        //SFDC - 289 end
        fetchFrom = fetchFrom.replace(',','');               
        list<string> metadatfields = 'Id, DeveloperName, MasterLabel, Language, NamespacePrefix, Label, QualifiedApiName, HELO_Credit_to_Borrower__c, HELO_Origination_to_Partner__c, HeloPrice__c, HELO_Rate__c, HELO_Servicing_Fee__c'.split(',');
        String metadataQuery = 'SELECT Id, DeveloperName, MasterLabel, Language, NamespacePrefix, Label, QualifiedApiName, HELO_Credit_to_Borrower__c, HELO_Origination_to_Partner__c, HeloPrice__c, HELO_Rate__c, HELO_Servicing_Fee__c FROM '+fetchFrom;
        list<sObject>metadataResults = database.query(metadataQuery);
        System.debug('>>>metadataResults '+metadataResults);
        map<String,String> heloArmPrice = new map<String,String>(); 
        map<String,String> heloArmRate = new map<String,String>(); 
        map<String,String> heloArmOrigination = new map<String,String>(); 
        map<String,String> rateToArmServiceFee = new map<String,String>(); 
        
        for(sObject eachsObject:metadataResults){
            heloArmPrice.put(String.valueOf(eachsObject.get('HELO_Rate__c')),String.valueOf(eachsObject.get('HeloPrice__c')));
        }
        metataDataFields.put('HeloArmPrice',heloArmPrice);
        
        for(sObject eachsObject:metadataResults){ 
            heloArmRate.put(String.valueOf(eachsObject.get('HELO_Rate__c')),String.valueOf(eachsObject.get('HELO_Rate__c')));        
        }
        metataDataFields.put('HeloArm_rate',heloArmRate);
        
        for(sObject eachsObject:metadataResults){
            heloArmOrigination.put(String.valueOf(eachsObject.get('HELO_Rate__c')),String.valueOf(eachsObject.get('HELO_Origination_to_Partner__c')));
        }
        metataDataFields.put('HeloArm_orm',heloArmOrigination);
        
        for(sObject eachsObject:metadataResults){
            rateToArmServiceFee.put(String.valueOf(eachsObject.get('HELO_Rate__c')),String.valueOf(eachsObject.get('HELO_Servicing_Fee__c')));
        }
        system.debug('>>>rateToArmServiceFee '+rateToArmServiceFee);
        metataDataFields.put('HeloArm_service',rateToArmServiceFee);
        Logger.pop();
        return metataDataFields;
    }
}