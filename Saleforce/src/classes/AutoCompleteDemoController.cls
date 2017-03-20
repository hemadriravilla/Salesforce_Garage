public with sharing class AutoCompleteDemoController{

public String selectedAccout{get;set;}
public list<account> accobj{get;set;}
public void setInputvalue(){
 accobj=[select id,name from account where name=:selectedAccout];
    System.debug (accobj);
}

public list<account> getAccountList(){
    return [select id,name from account limit 25];
}
}