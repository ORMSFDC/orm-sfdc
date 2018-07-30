@IsTest
public class ClientSpouseResponseTest {
    @Istest static void ResponseClassTes(){
        ClientSpouseResponse obj =new ClientSpouseResponse();
        obj.ClientId ='1234';
        obj.NonborrowingSpouseYesNo  ='Yes' ;   
        obj.NonborrowingSpouseName = 'Spouse';
        obj.NonborrowingSpousePhone = '1236547890';
        obj.NonborrowingSpouseDOB = system.today();
        obj.NonborrowingSpouseRelation = 'Married';
        obj.NonborrowingSpouseAddressSameAs = true;
        obj.NonborrowingSpouseAddress = 'Detroit';
        obj.NonborrowingSpouseCity = 'Detroit';
        obj.NonborrowingSpouseState = 'CA';
        obj.NonborrowingSpouseZip = '12345';
        obj.NonborrowingSpouseMonthlyIncome = 12.00;
        obj.PlaceofCelebration ='Detroit';
    }
    
}