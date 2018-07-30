public class LoanExportMapHelper{

    public String Nameis{get;set;}
    public  list<LoanFieldValueMap> data{get;set;}
    
    public LoanExportMapHelper(String Nameis,list<LoanFieldValueMap> data){
        this.Nameis = Nameis;
        this.data  =data;
    }

}