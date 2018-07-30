public class getClientfromDeclaration {

@AuraEnabled
public static List<ClientDeclarationDetails> AllClientsName(string loanID)
{
    //nausad
    
     	List<ClientDeclarationDetails> declarationList= new  List<ClientDeclarationDetails>();
        List <Declaration__c> ClientDeclarations =new List <Declaration__c>();
        ClientDeclarations = [SELECT DeclarationClient__c,IsDeclaration_Filled_From_Tab__c FROM Declaration__c where DeclarationLoan__c = :loanID];
        for(Declaration__c obj:ClientDeclarations)
        {
            ClientDeclarationDetails Objdeclaration= new  ClientDeclarationDetails();
            Client__c clientObj=new Client__c() ;
            clientObj=[Select First_Name__c ,Last_Name__c from Client__c where id = :obj.DeclarationClient__c limit 1];
            Objdeclaration.ClientFirstName= clientObj.First_Name__c;
            Objdeclaration.ClientLastName=clientObj.Last_Name__c ;
            Objdeclaration.ClientDeclarationStatus=obj.IsDeclaration_Filled_From_Tab__c;
            declarationList.Add(Objdeclaration);
           // system.debug(Objdeclaration);
        }
        return declarationList;
}
    
   
}