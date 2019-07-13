/**
 * @description: To update POA field on Loan and stop users from adding multiple clients 
 *               as Primary Clients
 * @author: Sahitya
 * @date: 07/10/2019
 * changelog:
 */

public class ClientLoan{
    public static void updateLoanPOA(String clientID){
        Logger.push('updateLoanPOA','ClientLoan');
        client__c c = [SELECT Id, LoanId__c, First_Name__c, Middle_Name__c, Last_Name__c, Primary_Client_for_the_Loan__c, Is_there_a_POA__c 
                    FROM Client__c 
                    WHERE id = :clientID ];
        String loanId = c.LoanId__c;
        Loan_New__c objLoan = [SELECT Id, Client_Name__c, Co_Client_Name__c, Is_there_a_POA_Name_Representing_and__c 
                                FROM Loan_New__c
                                WHERE id =:loanId];

        String middleName;
        if(c.Middle_Name__c == null){
            middleName = '';
        }else{
            middleName = c.Middle_Name__c;
        }
        String fullName = (c.Last_Name__c + ', ' + c.First_Name__c +' '+ middleName).left(60);
        //Update Client Name on Loan
        if(c.Primary_Client_for_the_Loan__c == true)
        {
            objLoan.Client_Name__c = fullName;            
            update objLoan;
        }
        //Update Co-Client Name on Loan
        if(c.Primary_Client_for_the_Loan__c == false){            
            if(c.Primary_Client_for_the_Loan__c == false){
                objLoan.Co_Client_Name__c = fullName;
            }
            update objLoan; 
        }
        //update Is there a POA? (Name, Representing field on loan
        if(c.Is_there_a_POA__c == 'Yes' && c.Primary_Client_for_the_Loan__c == true){
            objLoan.Is_there_a_POA_Name_Representing_and__c = 'Yes';
            update objLoan;
        }
        if(c.Is_there_a_POA__c == 'No' && c.Primary_Client_for_the_Loan__c == true){
            objLoan.Is_there_a_POA_Name_Representing_and__c = 'No';
            update objLoan;
        }        
        Logger.pop();
    }

    //Display an error when there is existing Primary client on Loan
    public static string validatePrimaryClient(String clientID, String LoanId, List<Client__c> clients){
        Logger.push('validatePrimaryClient','ClientLoan');
        List<Client__c> clientList = new List<Client__c>();
        clientList  = [SELECT Primary_Client_for_the_Loan__c, Name FROM Client__c WHERE LoanId__c =: LoanId AND Primary_Client_for_the_Loan__c = true];
        String displayString = '';
        system.debug('clientList----->'+ClientList.size());
              

        for(client__c client : clients){
            if(clientList.size() > 0 && client.Primary_Client_for_the_Loan__c == true && client.LoanId__c == LoanId){
                String name = clientList[0].Name;
                displayString += '‘An existing primary client, ' +name+ ' is marked as the primary client on this loan. Please uncheck the ‘Primary Client’ checkbox for ' +name+ ' in order to make this client the primary client.’ ' ;
                client.Primary_Client_for_the_Loan__c.addError(displayString);
            }       
        }
        Logger.Pop();
        return displayString;
    }
}