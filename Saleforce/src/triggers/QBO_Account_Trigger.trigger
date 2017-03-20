trigger QBO_Account_Trigger on Account (after insert,after update) {
    Set<Id>accountIdSet=new Set<Id>();
    if(QBO_ConstantUtilityClass.QBOInsertionExecuting==true)
        return;
   if(QBO_ConstantUtilityClass.QBOInsertionTriggerExecuting==true)
       return;
    if(trigger.isInsert && trigger.isAfter){
      for(Account a:trigger.new){
          
      accountIdSet.add(a.Id);
      }
      if(!accountIdSet.isEmpty()){
      CreateCustomersQBO.createUpdateCustomersQB(accountIdSet,'create');
      }
    }
    if(trigger.isUpdate && trigger.isAfter){
        for(Account a:trigger.new){
          accountIdSet.add(a.Id);
      }
      if(!accountIdSet.isEmpty()){
      CreateCustomersQBO.createUpdateCustomersQB(accountIdSet,'update');
      }
    }
}