@isTest
public class ConditionResponseTest {

    @isTest
    public static void LoanOfficerMethodResponseTest()
    {
        ConditionResponse ConditionRes = new ConditionResponse();
        ConditionRes.Id = '00P0q000000UZnHEAW';
        ConditionRes.Index = 'Condition-10';
        ConditionRes.DescText = 'Desc Text';
        ConditionRes.DropDownValue = '';
       Conditionres.Status = 'Outstanding';
       Conditionres.CreatedDate = date.today().format();
       Conditionres.StatusDate = date.today().format();
       Conditionres.CreatedBy = '00539000005a83kAAA';
       Conditionres.LastModifyBy = '00539000005a83kAAA';
       Conditionres.LastModifyDate = date.today().format();
       Conditionres.NewDescText = 'New Desc Text';
       Conditionres.NewStatus   = 'Revision Requested'; 
        
        System.assertEquals(ConditionRes.Index, 'Condition-10');
    }
    
}