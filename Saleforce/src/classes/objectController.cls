public class objectController
{
    public Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
     Public list<Sobject> abc{get;set;}

    public String selectedObject {get; set;}

    public String selectedField {get; set;}  
    
    Public List<string> leftselected{get;set;}
    
   public string showSelectedValues{get;set;}
    
    Set<string> leftvalues = new Set<string>();
     
    Set<string> rightvalues = new Set<string>();
     
    Public List<string> rightselected{get;set;}
    Public boolean renderedVariable{get;set;}
    Public objectController()
    {   
        selectedObject = 'college_students__c';
        
        rightselected = new List<String>();
    }

     public PageReference selectclick(){
     
        rightselected.clear();
        for(String s : leftselected){
            leftvalues.remove(s);
            rightvalues.add(s);
        }
        return null;
        }
        
    public PageReference unselectclick(){
        leftselected.clear();
        for(String s : rightselected){
            rightvalues.remove(s);
            leftvalues.add(s);
        }
        return null;
    }
    public List<SelectOption> getObjectNames() 
    {
        List<SelectOption> objNames = new List<SelectOption>();
        List<String> entities = new List<String>(schemaMap.keySet());
        entities.sort();
        for(String name : entities)
        {
            objNames.add(new SelectOption(name,name));
        }
        return objNames;
     }

     public List<SelectOption> getObjectFields() 
     {
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Schema.SObjectType ObjectSchema = schemaMap.get(selectedObject);
            Map<String, Schema.SObjectField> fieldMap = ObjectSchema.getDescribe().fields.getMap();
            List<SelectOption> fieldNames = new List<SelectOption>();
            for (String fieldName: fieldMap.keySet()) 
            {  
                fieldNames.add(new SelectOption(fieldName,fieldName));
              //fieldMap.get(fieldName).getDescribe().getLabel();//It provides to get the object fields label.
            }
            return fieldNames;
      }   
      
      public List<SelectOption> getunSelectedValues(){
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(leftvalues);
        tempList.sort();
        for(string s : tempList)
            options.add(new SelectOption(s,s));
        return options;
    }
 
    public List<SelectOption> getSelectedValues(){
    
        List<SelectOption> options1 = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(rightvalues);
        tempList.sort();
        for(String s : tempList)
            options1.add(new SelectOption(s,s));
        return options1;
    }
    
    Public list<Sobject> selectedObjQuery{get;set;}
    
    public void showSelected(){    
            renderedVariable = true;
        
        showSelectedValues = String.valueOF(rightvalues);
        
        List<String> selectedRgtValues = New List<String>();
        selectedRgtValues.addAll(rightvalues);
        String validateQuery = 'SELECT id';
        for(integer i=0;i<selectedRgtValues.size();i++) {
         validateQuery += ', ' + selectedRgtValues[i];
        }
        validateQuery += ' from '+selectedObject;
        
        
        showSelectedValues = validateQuery;
        
        
        rightselected.addall(rightvalues);
        
        
        //selectedObjQuery = DataBase.Query(showSelectedValues);
        
        
        //rightselected.addall(rightvalues);
        
    
    }
    public void querygenerate(){
    
   // renderedVariable = true; renderedVariable = true;
        
        showSelectedValues = String.valueOF(rightvalues);
        
        List<String> selectedRgtValues = New List<String>();
        selectedRgtValues.addAll(rightvalues);
        String validateQuery = 'SELECT id';
        for(integer i=0;i<selectedRgtValues.size();i++) {
         validateQuery += ', ' + selectedRgtValues[i];
        }
        validateQuery += ' from '+selectedObject;
        
        
        showSelectedValues = validateQuery;
        
        
        rightselected.addall(rightvalues);
        
  
                 abc = DataBase.Query(showSelectedValues);
                
                System.debug('objdata' + abc);
                 
                 
                 
    }
    
    
    
    
       
}