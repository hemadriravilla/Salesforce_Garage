public class search{
    public List<Account> allAccts{get;set;}
    public search(){
        allAccts = [SELECT id,Name,AccountNumber,Fax,phone,NumberOfEmployees FROM Account];
    }
}