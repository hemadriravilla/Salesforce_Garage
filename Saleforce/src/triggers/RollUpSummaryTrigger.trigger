trigger RollUpSummaryTrigger on Company__c (after insert,after delete,after update) {
    
    
    if(trigger.isInsert && Trigger.isAfter){
         Rollupsummarytriggerclass.Rollupsummarytriggerclasscount(trigger.new);
    }
    
   
    if(trigger.isupdate && Trigger.isAfter){
         
         List<Company__c> oldNewValues = New List<Company__c>();
         oldNewValues.addAll(trigger.old);
         oldNewValues.addAll(trigger.New);
         
         Rollupsummarytriggerclass.Rollupsummarytriggerclasscount(oldNewValues);
    }
    
    
    if(trigger.isDelete && Trigger.isAfter){
         Rollupsummarytriggerclass.Rollupsummarytriggerclasscount(trigger.old);
    }
}