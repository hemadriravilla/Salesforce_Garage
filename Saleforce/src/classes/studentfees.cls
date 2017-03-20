Public Class studentfees{
    
    public List<Fees__c> feeObj{get;set;}
    public string feeObj1{get;set;}
    
    public studentfees(){
        
        
        String validateQuery = 'SELECT id';
        for(Schema.FieldSetMember fld :SObjectType.Fees__c.FieldSets.feesfieldset.getFields()) {
                 validateQuery += ', ' + fld.getFieldPath();
        }
        validateQuery += ' from Fees__c ';
        
        feeObj = dataBase.Query(validateQuery);
        feeobj=new list<Fees__c>();
        Fees__c feeObj1 =new Fees__c();
        
        feeObj.add(feeObj1);
       
        
    }
     public PageReference save(){
     insert feeObj;
     feeObj=null;
     return null;
   } 
   public void AddrowMethod(){
        Fees__c feeObj1 =new Fees__c();
        feeObj.add(feeObj1);
    }
    
    public void RemoveRowMethod(){
        integer i = feeObj.size();
        //feeObj.remove(i-1);
    }    
    
    
}