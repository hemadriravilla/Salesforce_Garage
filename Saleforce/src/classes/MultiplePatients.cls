public Class MultiplePatients{
    Public List<Fees__c> StudentFeeDetails{get;set;}
    
    public MultiplePatients(){
        
        StudentFeeDetails = New List<Fees__c>();
        Fees__c  stuObj= New Fees__c();
        StudentFeeDetails.add(stuObj);
    }
    
    public void AddrowMethod(){
        Fees__c stuObj = New Fees__c();
        StudentFeeDetails.add(stuObj);
    }
    
    public void RemoveRowMethod(){
        integer i = StudentFeeDetails.size();
        StudentFeeDetails.remove(i-1);
    }
    
    public void CustomSave(){
        insert StudentFeeDetails;
    }
    
}