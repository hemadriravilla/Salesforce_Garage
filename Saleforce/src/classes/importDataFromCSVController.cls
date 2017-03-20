public class importDataFromCSVController {
public Blob csvFileBody{get;set;}
public string csvAsString{get;set;}
public String[] csvFileLines{get;set;}
public List<bookacc__c> acclist{get;set;}
Public boolean renderedVariable{get;set;}
  public importDataFromCSVController(){
    csvFileLines = new String[]{};
    acclist = New List<bookacc__c>(); 
  }
  
  public void importCSVFile(){
       try{
           csvAsString = csvFileBody.toString();
           csvFileLines = csvAsString.split('\n'); 
            
           for(Integer i=1;i<csvFileLines.size();i++){
               bookacc__c accObj = new bookacc__c() ;
               string[] csvRecordData = csvFileLines[i].split(',');
               accObj.name = csvRecordData[0] ;             
               accObj.Account_No__c = csvRecordData[1];
               accObj.type__c= csvRecordData[2];
               accObj.Account_Source__c= csvRecordData[3];   
               accObj.Industry__c= csvRecordData[4];                                                                             
               acclist.add(accObj);   
           }
           renderedVariable = true;
        //Database.insert(acclist,false);
        }
        catch (Exception e)
        {
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR,'An error has occured while importin data Please make sure input csv file is correct');
            ApexPages.addMessage(errorMessage);
        }  
  }
  public void savedata(){
       Database.insert(acclist,false);
  
  }
}