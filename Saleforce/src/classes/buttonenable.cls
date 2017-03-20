public class buttonenable {

   public string student{get;set;}
   public integer studentcount{get;set;}
   public list<Student__c> searchstudent{get;set;}
   
   
   
   public void submitbutton (){
   
     searchstudent = [select Name,Age__c,Address__c,Hostel_Fees__c,Tution_Fees__c from Student__c where Name LIKE '%(:student%)'];
    
    }
     public void tryit (){
     studentcount=searchstudent.size();
     
     }
   
   
   





}