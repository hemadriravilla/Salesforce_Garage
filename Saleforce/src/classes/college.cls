public class college{

   
    public string myinput{get;set;}
    public string currentpayfees{get;set;}
    public list<college_students__c> studentobject{get;set;}
    Public boolean renderedvariable{get;set;}
    public list<Fees__c> f {get;set;}
   
   
    public void  searchstudent(){
            
             studentobject=[SELECT Name,Age__c,Amount__c,Student_Name__c,Class__r.Name from college_students__c where Name=:myinput];         
             
    F= New list<Fees__c>();
           Fees__c feesobj= New Fees__c();
           f.add(feesobj);
           renderedVariable = true;
    }

    public void payfees(){
             renderedVariable = true;
        
            // F =[select Name,college_students__c.Name,Mode_Of_Payment__c,Month__c from Fees__c ];
           insert f;
           
    }
}