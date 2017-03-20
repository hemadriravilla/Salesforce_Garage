public with sharing class treeviewcon {
    public List<Account> accnts{get; set;}
    public treeviewcon(){
        accnts = [Select id, name,(Select id, name from Contacts),(Select Id,CaseNumber,Subject from Cases) from account];
    }
}