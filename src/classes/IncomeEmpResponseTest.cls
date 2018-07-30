@IsTest
public class IncomeEmpResponseTest {
    @isTest
    public static void IncomeEmpResponseMethodTest()
    {
        List<IncomeEmpListResponse>  IncomeEmpList1=new List<IncomeEmpListResponse>();
        IncomeEmpListResponse obj=new IncomeEmpListResponse();
        obj.IncomeType='IncomeEmp';
            obj.SourceName='Test';
            obj.MonthlyIncomeValue=23;
            obj.RecordID='a0N290000017m5eEAA';
            obj.ObjectType='Employment Income';
            obj.ClientId='a0N290000017m5eEAA';
        IncomeEmpList1.Add(obj);
        IncomeEmpResponse objIncEmpRes =  new IncomeEmpResponse();
        objIncEmpRes.ClientId = 'a0N290000017m5eEAA';
            objIncEmpRes.IncomeEmpList=IncomeEmpList1;
            objIncEmpRes.ClientName = 'Employment';
  
            objIncEmpRes.TotalIncome = 20000;
    }

}