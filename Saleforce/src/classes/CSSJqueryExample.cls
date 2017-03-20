public class CSSJqueryExample{
 public List<Account> allAccts{get;set;}
    public CSSJqueryExample(){
        allAccts = [SELECT id,Name,AccountNumber,Fax,phone,NumberOfEmployees FROM Account];
    }


}