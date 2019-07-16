/**
 * @description: fetch Pricing metadata to display pricing table on Portal 
 * @author: Ravi
 * @date: 1/17/2018
 *
 * changelog:
 * 07/17/2018: Sahitya - Added Helo for Pricing table
 * 09/20/2018: Sahitya -SFDC - 289 Added 3rd Tier for Portal and Backend Calculator
 * 07/08/2019: Sahitya - New HELO ARM for Pricing Table
 */
public class Pricing {
    
    // ARM/Broker Pricing
    @AuraEnabled
    public static List<PricingResponse> getBrokerPricing( ) {
        List<PricingResponse> PricingResponseFinalList=new List<PricingResponse>();       
        String partnerType;
        try{
            Id AccountID=[select AccountId from User where id=:UserInfo.getUserId()].AccountId;
            //SFDC - 289
            partnerType = [select Partner_Type__c from account where id=:AccountID].Partner_Type__c;
            if(partnerType == 'Premier'){
                PricingResponseFinalList= Tier2_Data();
            }
            else if(partnerType == 'Non Premier'){
                PricingResponseFinalList= Tier1_Data();
            }  
            else if(partnerType == 'Premier Plus'){
                PricingResponseFinalList= Tier3_Data();
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
    
    //SFDC - 289
    public static  List<PricingResponse> Tier3_Data()
    {
        List<PricingResponse> PricingResponseList=new List<PricingResponse>();
        List<Tier3__mdt> lstBrokerPricing = 
            [SELECT   Margin__c,X0_to_10__c,X10_to_20__c,X20_to_30__c,X30_to_40__c,X40_to_50__c,X50_to_60__c,
             X60_to_70__c,X70_to_80__c,X80_to_90__c,X90_to_100__c from  Tier3__mdt order by Margin__c desc];
        for(Tier3__mdt obj:lstBrokerPricing )
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

    //Fixed Pricing
    @AuraEnabled
    public static List<FixedRateResponse> getFixedRateORM( ) {
        List<FixedRateResponse> PricingResponseFinalList=new List<FixedRateResponse>();
        String partnerType;
        try{
            Id AccountID=[select AccountId from User where id=:UserInfo.getUserId()].AccountId;
            //SFDC - 289
            partnerType = [select Partner_Type__c from account where id=:AccountID].Partner_Type__c;
            if(partnerType == 'Premier'){
                PricingResponseFinalList= FixedRateTier2_Data();
            }
            else if(partnerType == 'Non Premier'){
                PricingResponseFinalList= FixedRateTier1_Data();
            }  
            else if(partnerType == 'Premier Plus'){
                PricingResponseFinalList= FixedRateTier3_Data();
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
        List<Fixed_Price_Tier2__mdt> Pricing = [SELECT   Rate__c,Price__c,Origination_to_ORM__c,Credit_to_Borrower__c
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
        List<Fixed_Price_Tier1__mdt> Pricing = [SELECT   Rate__c,Price__c,Origination_to_ORM__c,Credit_to_Borrower__c
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

    //SFDC - 289
    public static  List<FixedRateResponse> FixedRateTier3_Data()
    {
        List<FixedRateResponse> PricingResponseList=new List<FixedRateResponse>();
        List<Fixed_Price_Tier3__mdt> Pricing = [SELECT   Rate__c,Price__c,Origination_to_ORM__c,Credit_to_Borrower__c
                                                from  Fixed_Price_Tier3__mdt order by Rate__c desc ];
        for(Fixed_Price_Tier3__mdt obj:Pricing )
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
    
    
    //Helo Pricing - Bala
    @AuraEnabled
    public static List<HeloRateResponse> getHeloRateORM( ) {
        List<HeloRateResponse> PricingResponseFinalList=new List<HeloRateResponse>();
        String partnerType;
        try{
            Id AccountID=[select AccountId from User where id=:UserInfo.getUserId()].AccountId;
            //SFDC - 289
            partnerType = [select Partner_Type__c from account where id=:AccountID].Partner_Type__c;
            if(partnerType == 'Premier'){
                PricingResponseFinalList= HeloRateTier2_Data();
            }
            else if(partnerType == 'Non Premier'){
                PricingResponseFinalList= HeloRateTier1_Data();
            }
            else if(partnerType == 'Premier Plus'){
                PricingResponseFinalList= HeloRateTier3_Data();
            }  
        } 
        catch(Exception ex)
        {
            system.debug('getHeloRateORM .....'+ ex.getMessage());
        }
        return PricingResponseFinalList;
    }
    
    public static  List<HeloRateResponse> HeloRateTier2_Data()
    {
        List<HeloRateResponse> PricingResponseList=new List<HeloRateResponse>();
        List<Proprietary_Tier_2__mdt> Pricing = [SELECT   Rate__c,Price__c,Origination_to_Partner__c,Credit_to_Borrower__c,Servicing_Fee__c
                                                from  Proprietary_Tier_2__mdt order by Rate__c desc ];
        for(Proprietary_Tier_2__mdt obj:Pricing )
        {
            HeloRateResponse  ResponseObj=new HeloRateResponse();
            ResponseObj.Rate=String.valueOf(obj.Rate__c);
            ResponseObj.Price=String.valueOf(obj.Price__c)+'%';
            ResponseObj.OriginationToPartner=String.valueOf(obj.Origination_to_Partner__c)+'%';
            ResponseObj.CreditToBorrower=String.valueOf(obj.Credit_to_Borrower__c)+'%';
            ResponseObj.ServicingFee=String.valueOf(obj.Servicing_Fee__c);
            PricingResponseList.add(ResponseObj);
        }
        return PricingResponseList;
    }
    
    public static  List<HeloRateResponse> HeloRateTier1_Data()
    {
        List<HeloRateResponse> PricingResponseList=new List<HeloRateResponse>();
        List<Proprietary_Tier_1__mdt> Pricing = [SELECT   Rate__c,Price__c,Origination_to_Partner__c,Credit_to_Borrower__c,Servicing_Fee__c
                                                from  Proprietary_Tier_1__mdt order by Rate__c desc ];
        for(Proprietary_Tier_1__mdt obj:Pricing )
        {
            HeloRateResponse  ResponseObj=new HeloRateResponse();
            ResponseObj.Rate=String.valueOf(obj.Rate__c);
            ResponseObj.Price=String.valueOf(obj.Price__c)+'%';
            ResponseObj.OriginationToPartner=String.valueOf(obj.Origination_to_Partner__c)+'%';
            ResponseObj.CreditToBorrower=String.valueOf(obj.Credit_to_Borrower__c)+'%';
            ResponseObj.ServicingFee=String.valueOf(obj.Servicing_Fee__c);
            PricingResponseList.add(ResponseObj);
        }
        return PricingResponseList;
    }

    //SFDC - 289
    public static  List<HeloRateResponse> HeloRateTier3_Data()
    {
        List<HeloRateResponse> PricingResponseList=new List<HeloRateResponse>();
        List<Proprietary_Tier_3__mdt> Pricing = [SELECT   Rate__c,Price__c,Origination_to_Partner__c,Credit_to_Borrower__c,Servicing_Fee__c
                                                from  Proprietary_Tier_3__mdt order by Rate__c desc ];
        for(Proprietary_Tier_3__mdt obj:Pricing )
        {
            HeloRateResponse  ResponseObj=new HeloRateResponse();
            ResponseObj.Rate=String.valueOf(obj.Rate__c);
            ResponseObj.Price=String.valueOf(obj.Price__c)+'%';
            ResponseObj.OriginationToPartner=String.valueOf(obj.Origination_to_Partner__c)+'%'; 
            ResponseObj.CreditToBorrower=String.valueOf(obj.Credit_to_Borrower__c)+'%';
            ResponseObj.ServicingFee=String.valueOf(obj.Servicing_Fee__c);
            PricingResponseList.add(ResponseObj);
        }
        return PricingResponseList;
    }  



    //HELO ARM

    @AuraEnabled
    public static List<HeloARMRateResponse> getHeloARMRateORM( ) {
        List<HeloArmRateResponse> PricingResponseFinalList=new List<HeloArmRateResponse>();
        String partnerType;
        try{
            Id AccountID=[select AccountId from User where id=:UserInfo.getUserId()].AccountId;
            //SFDC - 289
            partnerType = [select Partner_Type__c from account where id=:AccountID].Partner_Type__c;
            if(partnerType == 'Premier'){
                PricingResponseFinalList= HeloArmRateTier2_Data();
            }
            else if(partnerType == 'Non Premier'){
                PricingResponseFinalList= HeloArmRateTier1_Data();
            }
            else if(partnerType == 'Premier Plus'){
                PricingResponseFinalList= HeloArmRateTier3_Data();
            }  
        } 
        catch(Exception ex)
        {
            system.debug('getHeloRateORM .....'+ ex.getMessage());
        }
        return PricingResponseFinalList;
    }
    
    public static  List<HeloArmRateResponse> HeloArmRateTier2_Data()
    {
        List<HeloArmRateResponse> PricingResponseList=new List<HeloArmRateResponse>();
        List<HELO_ARM_2__mdt> Pricing = [SELECT   HeloPrice__c, HeloArmMargin__c, HELO_Credit_to_borrower__c, HELO_Origination_to_partner__c, HELO_Rate__c, HELO_Servicing_Fee__c
                                                from  HELO_ARM_2__mdt order by HELO_Rate__c desc ];
        for(	HELO_ARM_2__mdt obj:Pricing )
        {
            HeloArmRateResponse  ResponseObj=new HeloArmRateResponse();
            ResponseObj.Rate=String.valueOf(obj.HELO_Rate__c);
            ResponseObj.Price=String.valueOf(obj.HeloPrice__c)+'%';
            ResponseObj.OriginationToPartner=String.valueOf(obj.HELO_Origination_to_partner__c)+'%';
            ResponseObj.CreditToBorrower=String.valueOf(obj.HELO_Credit_to_borrower__c)+'%';
            ResponseObj.ServicingFee=String.valueOf(obj.HELO_Servicing_Fee__c);
            PricingResponseList.add(ResponseObj);
        }
        return PricingResponseList;
    }
    
    public static  List<HeloArmRateResponse> HeloArmRateTier1_Data()
    {
        List<HeloArmRateResponse> PricingResponseList=new List<HeloArmRateResponse>();
        List<HELO_ARM_1__mdt> Pricing = [SELECT   HeloPrice__c, HeloArmMargin__c, HELO_Credit_to_borrower__c, HELO_Origination_to_partner__c, HELO_Rate__c, HELO_Servicing_Fee__c
                                                from  HELO_ARM_1__mdt order by HELO_Rate__c desc ];
        for(HELO_ARM_1__mdt obj:Pricing )
        {
            HeloArmRateResponse  ResponseObj=new HeloArmRateResponse();
            ResponseObj.Rate=String.valueOf(obj.HELO_Rate__c);
            ResponseObj.Price=String.valueOf(obj.HeloPrice__c)+'%';
            ResponseObj.OriginationToPartner=String.valueOf(obj.HELO_Origination_to_partner__c)+'%';
            ResponseObj.CreditToBorrower=String.valueOf(obj.HELO_Credit_to_borrower__c)+'%';
            ResponseObj.ServicingFee=String.valueOf(obj.HELO_Servicing_Fee__c);
            PricingResponseList.add(ResponseObj);
        }
        return PricingResponseList;
    }
    
    public static  List<HeloArmRateResponse> HeloArmRateTier3_Data()
    {
        List<HeloArmRateResponse> PricingResponseList=new List<HeloArmRateResponse>();
        List<HELO_ARM_3__mdt> Pricing = [SELECT   HeloPrice__c, HeloArmMargin__c, HELO_Credit_to_borrower__c, HELO_Origination_to_partner__c, HELO_Rate__c, HELO_Servicing_Fee__c
                                                from  HELO_ARM_3__mdt order by HELO_Rate__c desc ];
        for(HELO_ARM_3__mdt obj:Pricing )
        {
            HeloArmRateResponse  ResponseObj=new HeloArmRateResponse();
            ResponseObj.Rate=String.valueOf(obj.HELO_Rate__c);
            ResponseObj.Price=String.valueOf(obj.HeloPrice__c)+'%';
            ResponseObj.OriginationToPartner=String.valueOf(obj.HELO_Origination_to_partner__c)+'%';
            ResponseObj.CreditToBorrower=String.valueOf(obj.HELO_Credit_to_borrower__c)+'%';
            ResponseObj.ServicingFee=String.valueOf(obj.HELO_Servicing_Fee__c);
            PricingResponseList.add(ResponseObj);
        }
        return PricingResponseList;
    }  
}