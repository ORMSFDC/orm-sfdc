@isTest
public class PipeLineDetailsResponseTest {
    
    @isTest
    public static void PipeLineDetailsResponse()
    {
        PipeLineDetailsResponse response = new PipeLineDetailsResponse();
        response.Loanid='00P0q000000UZnHEAW';
        response.LoanNumberDetails = 'ABC' ;
        response.FullName='Nausad';
        response.LoanStatus='Pending';
        response.Address ='Detroit';
        response.Phone ='9630266959';
        response.CPhone='9630266959';
        response.DOB ='18/11/1988';
        response.CreatedBy ='Nausad';
        response.LoanDate='01/01/1941';
        response.Email='albert@sfdc.com';
        //System.assertEquals(response.LoanNumberDetails, 'ABC');
    }
}