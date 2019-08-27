@IsTest
public class PricingTest {    
    @IsTest Static void GetBrockerPricingTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Account Executive/PCS'];
        UserRole UR=[Select Id from UserRole where Name='Partner Care Specialist'];
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;        
        User user1 = new User(Alias = uniqueName.substring(18, 23),  email = uniqueName + '@test1' + orgId + '.org',
                              Username = uniqueName + '@test1' + orgId + '.org', 
                              EmailEncodingKey='UTF-8', LastName='Tester', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id,userroleid=UR.ID, 
                              TimeZoneSidKey='America/Los_Angeles');
        insert user1;    
        system.runAs(user1)
        {  
            Test.startTest();
            List<PricingResponse> lst=  Pricing.getBrokerPricing();
            List<PricingResponse> lst1=  Pricing.Tier2_Data();
            List<PricingResponse> lst2=  Pricing.Tier1_Data();
            List<PricingResponse> lst4=  Pricing.Tier3_Data();    
            List<FixedRateResponse> lst5=  Pricing.getFixedRateORM();
            List<FixedRateResponse> lst6=  Pricing.FixedRateTier2_Data();
            List<FixedRateResponse> lst7=  Pricing.FixedRateTier1_Data(); 
            List<FixedRateResponse> lst8=  Pricing.FixedRateTier3_Data(); 
            List<HeloRateResponse> lst9=  Pricing.getHeloRateORM();
            List<HeloRateResponse> lst10=  Pricing.HeloRateTier2_Data();
            List<HeloRateResponse> lst11=  Pricing.HeloRateTier1_Data();
            List<HeloRateResponse> lst12=  Pricing.HeloRateTier3_Data();
            List<HeloArmRateResponse> lst13=  Pricing.getHeloARMRateORM();
            List<HeloArmRateResponse> lst14= Pricing.HeloArmRateTier1_Data();
            List<HeloArmRateResponse> lst15= Pricing.HeloArmRateTier2_Data();
            List<HeloArmRateResponse> lst16= Pricing.HeloArmRateTier3_Data();
            Test.stopTest();
            
        }
    }}