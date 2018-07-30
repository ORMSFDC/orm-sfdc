public class Pricing {
    @AuraEnabled
    public static List<PricingResponse> getBrokerPricing( ) {
        List<PricingResponse> PricingResponseFinalList=new List<PricingResponse>();
        Boolean IsPremierParthner;
        try{
            Id AccountID=[select AccountId from User where id=:UserInfo.getUserId()].AccountId;
            IsPremierParthner=[select Premier_Partner__c from account where id=:AccountID].Premier_Partner__c;
            if(IsPremierParthner)
            {
                PricingResponseFinalList= Tier2_Data();
            }
            else{
                PricingResponseFinalList= Tier1_Data();
            }  
        } 
        catch(Exception ex)
        {
            system.debug('getBrokerPricing .....'+ ex.getMessage());
        }
        return PricingResponseFinalList;
    }
    public static  List<PricingResponse> Tier2_Data()
    {
        List<PricingResponse> PricingResponseList=new List<PricingResponse>();
        List<Tier2__mdt> lstBrokerPricing = 
            [SELECT   Margin__c,X0_to_10__c,X10_to_20__c,X20_to_30__c,X30_to_40__c,X40_to_50__c,X50_to_60__c,
             X60_to_70__c,X70_to_80__c,X80_to_90__c,X90_to_100__c from  Tier2__mdt order by Margin__c desc];
        for(Tier2__mdt obj:lstBrokerPricing )
        {
            PricingResponse  BrokerResponseObj=new PricingResponse();
            BrokerResponseObj.Margin=String.valueOf(obj.Margin__c);
            BrokerResponseObj.x0_to_10=String.valueOf(obj.X0_to_10__c);
            BrokerResponseObj.x10_to_20=String.valueOf(obj.X10_to_20__c);
            BrokerResponseObj.x20_to_30=String.valueOf(obj.X20_to_30__c);
            BrokerResponseObj.x30_to_40=String.valueOf(obj.X30_to_40__c);
            BrokerResponseObj.x40_to_50=String.valueOf(obj.X40_to_50__c);
            BrokerResponseObj.x50_to_60=String.valueOf(obj.X50_to_60__c);
            BrokerResponseObj.x60_to_70=String.valueOf(obj.X60_to_70__c);
            BrokerResponseObj.x70_to_80=String.valueOf(obj.X70_to_80__c);
            BrokerResponseObj.x80_to_90=String.valueOf(obj.X80_to_90__c);
            BrokerResponseObj.x90_to_100=String.valueOf(obj.X90_to_100__c);
            PricingResponseList.add(BrokerResponseObj);
        }
        return PricingResponseList;
    }
    public static  List<PricingResponse> Tier1_Data()
    {
        List<PricingResponse> PricingResponseList=new List<PricingResponse>();
        List<Tier1__mdt> lstBrokerPricing = 
            [SELECT   Margin__c,X0_to_10__c,X10_to_20__c,X20_to_30__c,X30_to_40__c,X40_to_50__c,X50_to_60__c,
             X60_to_70__c,X70_to_80__c,X80_to_90__c,X90_to_100__c from  Tier1__mdt order by Margin__c desc];
        for(Tier1__mdt obj:lstBrokerPricing )
        {
            PricingResponse  BrokerResponseObj=new PricingResponse();
            BrokerResponseObj.Margin=String.valueOf(obj.Margin__c);
            BrokerResponseObj.x0_to_10=String.valueOf(obj.X0_to_10__c);
            BrokerResponseObj.x10_to_20=String.valueOf(obj.X10_to_20__c);
            BrokerResponseObj.x20_to_30=String.valueOf(obj.X20_to_30__c);
            BrokerResponseObj.x30_to_40=String.valueOf(obj.X30_to_40__c);
            BrokerResponseObj.x40_to_50=String.valueOf(obj.X40_to_50__c);
            BrokerResponseObj.x50_to_60=String.valueOf(obj.X50_to_60__c);
            BrokerResponseObj.x60_to_70=String.valueOf(obj.X60_to_70__c);
            BrokerResponseObj.x70_to_80=String.valueOf(obj.X70_to_80__c);
            BrokerResponseObj.x80_to_90=String.valueOf(obj.X80_to_90__c);
            BrokerResponseObj.x90_to_100=String.valueOf(obj.X90_to_100__c);
            PricingResponseList.add(BrokerResponseObj);
        }
        return PricingResponseList;
        
    }
    
    
     @AuraEnabled
    public static List<FixedRateResponse> getFixedRateORM( ) {
        List<FixedRateResponse> PricingResponseFinalList=new List<FixedRateResponse>();
        Boolean IsPremierParthner;
        try{
            Id AccountID=[select AccountId from User where id=:UserInfo.getUserId()].AccountId;
           IsPremierParthner=[select Premier_Partner__c from account where id=:AccountID].Premier_Partner__c;
            if(IsPremierParthner)
            {
                PricingResponseFinalList= FixedRateTier2_Data();
            }
            else{
                PricingResponseFinalList= FixedRateTier1_Data();
            }  
        } 
        catch(Exception ex)
        {
            system.debug('getFixedRateORM .....'+ ex.getMessage());
        }
        return PricingResponseFinalList;
    }
      public static  List<FixedRateResponse> FixedRateTier2_Data()
    {
        List<FixedRateResponse> PricingResponseList=new List<FixedRateResponse>();
        List<Fixed_Price_Tier2__mdt> Pricing = 
            [SELECT   Rate__c,Price__c,Origination_to_ORM__c,Credit_to_Borrower__c
             from  Fixed_Price_Tier2__mdt order by Rate__c desc ];
        for(Fixed_Price_Tier2__mdt obj:Pricing )
        {
            FixedRateResponse  ResponseObj=new FixedRateResponse();
            ResponseObj.Rate=String.valueOf(obj.Rate__c);
           	ResponseObj.Price=String.valueOf(obj.Price__c)+'%';
            ResponseObj.OriginationToORM=String.valueOf(obj.Origination_to_ORM__c);
            ResponseObj.CreditToBorrower=String.valueOf(obj.Credit_to_Borrower__c)+'%';
            PricingResponseList.add(ResponseObj);
        }
        return PricingResponseList;
    }
    
      public static  List<FixedRateResponse> FixedRateTier1_Data()
    {
        List<FixedRateResponse> PricingResponseList=new List<FixedRateResponse>();
        List<Fixed_Price_Tier1__mdt> Pricing = 
            [SELECT   Rate__c,Price__c,Origination_to_ORM__c,Credit_to_Borrower__c
             from  Fixed_Price_Tier1__mdt order by Rate__c desc ];
        for(Fixed_Price_Tier1__mdt obj:Pricing )
        {
             FixedRateResponse  ResponseObj=new FixedRateResponse();
            ResponseObj.Rate=String.valueOf(obj.Rate__c);
           	ResponseObj.Price=String.valueOf(obj.Price__c)+'%';
            ResponseObj.OriginationToORM=String.valueOf(obj.Origination_to_ORM__c);
            ResponseObj.CreditToBorrower=String.valueOf(obj.Credit_to_Borrower__c)+'%';
            PricingResponseList.add(ResponseObj);
        }
        return PricingResponseList;
    }
      
}