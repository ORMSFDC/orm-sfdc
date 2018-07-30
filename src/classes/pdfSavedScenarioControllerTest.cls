@isTest
public class pdfSavedScenarioControllerTest {
	@isTest
    public Static void userTest() {
        
        ClientInfo__c ClientInsert = new ClientInfo__c(Name = 'Dhiresh', Last_Name__c  = 'Khare',Client_State__c = 'Alabama', Zip__c = '123456', Email_Optional__c ='d@k.com',Phone_Number__c = '1234456678',Street_Address__c = 'Noida Sector-62',  DOB__c=date.today());
        insert  ClientInsert;
        
        Scenario__c ScenarioInsert = new Scenario__c(Estimated_home_value__c = 500.00, 
                                 Current_Mortgage_Balance__c = 200.00, Current_Mortgage_Interest_Rate__c = 300.00,MIP__c = 200.00,
                                 Monthly_Mortgage_Payment__c = 400.00, 
                                 Principal_Limit__c = 400.00,
                                 Line_of_Credit__c = 200.00,ClientId__c =ClientInsert.Id, priority__c = 'LOC And CashFlow');
       	ScenarioInsert.PieChartResponse__c ='{"errorMessages":{},"priority":["loc","cashflow"],"modelType":"LineOfCredit","annualLiborChangeDate":"1-08-2018","annualMIP":0.5,"lendersMargin":2.5,"growthRateInitial":5.15,"growthRateAverage10yr":6.495,"growthRateAverage20yr":6.612,"apr":4.65,"annualLibor":2.15,"maxCash":20027.0,"cashToClose":0.0,"closingCosts":6500.0,"originationFees":0.0,"thirdPartyCosts":0.0,"upfrontMip":3358.0,"terms":[{"age":74,"month":0,"loc":52461,"delayedLOC":null,"reverseUPB":28624,"homeValue":167876},{"age":75,"month":12,"loc":55227,"delayedLOC":null,"reverseUPB":30133,"homeValue":172669},{"age":76,"month":24,"loc":58769,"delayedLOC":null,"reverseUPB":32065,"homeValue":176158},{"age":77,"month":36,"loc":63168,"delayedLOC":null,"reverseUPB":34466,"homeValue":179532},{"age":78,"month":48,"loc":67729,"delayedLOC":null,"reverseUPB":36954,"homeValue":184412},{"age":79,"month":60,"loc":72368,"delayedLOC":77660,"reverseUPB":39486,"homeValue":190679},{"age":80,"month":72,"loc":77027,"delayedLOC":82856,"reverseUPB":42027,"homeValue":197992},{"age":81,"month":84,"loc":82070,"delayedLOC":89356,"reverseUPB":44779,"homeValue":205944},{"age":82,"month":96,"loc":87622,"delayedLOC":97335,"reverseUPB":47808,"homeValue":213991},{"age":83,"month":108,"loc":93750,"delayedLOC":105766,"reverseUPB":51152,"homeValue":221596},{"age":84,"month":120,"loc":100379,"delayedLOC":114531,"reverseUPB":54769,"homeValue":228979},{"age":85,"month":132,"loc":107391,"delayedLOC":123544,"reverseUPB":58594,"homeValue":236215},{"age":86,"month":144,"loc":114793,"delayedLOC":133404,"reverseUPB":62633,"homeValue":243332},{"age":87,"month":156,"loc":122673,"delayedLOC":144343,"reverseUPB":66933,"homeValue":250240},{"age":88,"month":168,"loc":131100,"delayedLOC":156514,"reverseUPB":71531,"homeValue":257083},{"age":89,"month":180,"loc":140140,"delayedLOC":169835,"reverseUPB":76463,"homeValue":263916},{"age":90,"month":192,"loc":149852,"delayedLOC":184142,"reverseUPB":81762,"homeValue":271092},{"age":91,"month":204,"loc":160277,"delayedLOC":199481,"reverseUPB":87450,"homeValue":278773},{"age":92,"month":216,"loc":171470,"delayedLOC":216042,"reverseUPB":93557,"homeValue":286955},{"age":93,"month":228,"loc":183483,"delayedLOC":233987,"reverseUPB":100112,"homeValue":295535},{"age":94,"month":240,"loc":196364,"delayedLOC":253486,"reverseUPB":107140,"homeValue":304822}]}';				
        ScenarioInsert.Date_of_birth__c = System.today().addYears(-20);
        insert ScenarioInsert;
        Test.setCurrentPage(Page.pdfSavedScenario);
        Apexpages.currentPage().getparameters().put('Id',ScenarioInsert.Id);
        pdfSavedScenarioController pdfController = new PdfSavedScenarioController();
    }
}