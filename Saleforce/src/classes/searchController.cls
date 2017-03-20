public with sharing class searchController {

    //Properties
    public SelectOption[] objectSelect{
        get; set;
    }

    public String objName{get; set;}

    //Constructor
    public searchController()
    {
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();

        objectSelect = new SelectOption[]{};
        for(String name : schemaMap.keySet())
        {
            //objectSelect.add(new SelectOption(name, schemaMap.get(name).getDescribe().getLabel()));
            objectSelect.add(new SelectOption(name, name));
        }

        objName = objectSelect[0].getValue();
       // filter = new FilterRule(objName);
    }
    
    public  void  objname(){
    
    Map<String,Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
    Schema.SObjectType sobjType = gd.get(objName); 
    Schema.DescribeSObjectResult describeResult = sobjType.getDescribe(); 
    Map<String,Schema.SObjectField> fieldsMap = describeResult.fields.getMap();
    for(Schema.SObjectField t:fieldsMap.values() )
    {
    
    }
    }


}