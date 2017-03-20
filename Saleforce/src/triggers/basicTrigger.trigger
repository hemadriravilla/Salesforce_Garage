Trigger basicTrigger on account(before insert,before update){
    
    if(trigger.isbefore && Trigger.isInsert){
        
        List<BillingCountry__c> mcs = BillingCountry__c.getall().values();

        Map<String,String> countryWithCodes = New Map<String,String>();
         
        for(integer i=0;i<mcs.size();i++){
            countryWithCodes.put(mcs[i].Name,mcs[i].CountryCodes__c);
        }
        
         
        for(integer i=0;i<trigger.new.size();i++){
            if(countryWithCodes.ContainsKey(Trigger.new[i].BillingCountry)){
                trigger.new[i].xyz__c = countryWithCodes.get(Trigger.new[i].BillingCountry);
            }else{
                trigger.new[i].BillingCountry.addError('COUNTRY CODE DOES NOT EXISTS');
            }
        }
    }
  
}