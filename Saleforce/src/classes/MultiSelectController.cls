public class MultiSelectController {

public MultiSelectController(ApexPages.StandardController controller) {
    MultiSelectDefaultLoad();
}

                public String[] parentPicklistVal {public get; public set;}
                public String[] selectedparentPicklistVal {public get; public set;}
                public String[] childPicklistVal {public get; public set;}
                public String[] selectedchildPicklistVal {public get; public set;}

                public List<SelectOption> ParentPicklistOptions{get;set;}
                public List<SelectOption> SelectedParentPicklistOptions{get;set;}
                public List<SelectOption> ChildPicklistOptions{get;set;}
                public list<SelectOption> SelectedChildPicklistOptions{get;set;}


                public lead lead{get;set;}
                public list<string> lstgroup=new list<string>();
                public list<string> lstSubgroup=new list<string>();
                private Map<String, List<String>> parentChildMap;

                public boolean bIsRemoved{get;set;}
                public boolean bIsRemovedChild{get;set;}
                public boolean bIsAddChild{get;set;}

                private String[] parentOpts = new String[] { 'Animals', 'Fruits','Vegetables','Birds' };
                private String[] childMultiOpts = new String[] { 'Aluminum-alloy tubulars', ' Cementing Services', 'Closed-loop drilling',' Downhole drilling products','Drilling fluids & waste management','Drilling Services','Elastomer products','Well construction','Wellhead systems' };


public void MultiSelectDefaultLoad(){
    bIsRemoved=false;
    bIsRemovedChild=false;
    bIsAddChild=false;
    
    list<string> lstOne=new list<string>();
    
    lstOne.add('Tiger');
    lstOne.add('Lion');
    lstOne.add('Deer');
    lstOne.add('Elephant');
    lstOne.add('Giraffe');
    lstOne.add('Zebra');
    lstOne.add('rat');
    lstOne.add('Cat');
    lstOne.add('Dog');
    
    list<string> lst2=new list<string>();

    lst2.add('Apple');
    lst2.add('Orange)');
    lst2.add('Grapes');
    lst2.add('Water Melon');
    lst2.add('Banana');
    lst2.add('Pomogranate');
    
    list<string> lst3=new list<string>();
    lst3.add('Carrot');
    lst3.add('Chilly');
    lst3.add('Brinjal');
    lst3.add('Cucumber');
    lst3.add('Bitter-guard');
    lst3.add('Lemon');
    
    list<string> lst4=new list<string>();
    
    lst4.add('Pigeon');
    lst4.add('Parrot');
    lst4.add('peacock');
    lst4.add('eagle');
    lst4.add('owls');
    lst4.add('Sparrow');
    lst4.add('Ducks');
    lst4.add('Wood-peaker');
    lst4.add('Ostrich');
    lst4.add('vultures');
    
    
       
    parentChildMap=new Map<String, List<String>>();
    parentChildMap.put(parentOpts[0], lstOne);
    parentChildMap.put(parentOpts[1], lst2);
    parentChildMap.put(parentOpts[2], lst3);
    parentChildMap.put(parentOpts[3], lst4);
   
    
    //parentChildMap.put(parentOpts[1], (new String[]{childMultiOpts[2], childMultiOpts[3]}));
    //parentChildMap.put(parentOpts[2], (new String[]{childMultiOpts[4], childMultiOpts[5], childMultiOpts[6]}));
    
    ParentPicklistOptions=new List<SelectOption>();
    SelectedParentPicklistOptions=new List<SelectOption>();
    ChildPicklistOptions=new List<SelectOption>();
    SelectedChildPicklistOptions=new List<SelectOption>();

    List<SelectOption> selectOpts = new List<SelectOption>();
    for(String s : parentOpts  ){
        selectOpts.add(new SelectOption(s, s));
    }
     
    ParentPicklistOptions.addAll(selectOpts);

}

public PageReference actionUpdatePicklistVals() {
        // this doesn't really need to do anything, since the picklists should be updated when their getters call after returning
        bIsRemoved=false;
        List<SelectOption> selectOpts = new List<SelectOption>();
        if (parentPicklistVal != null && parentPicklistVal.size() > 0 ) {
           for(String s : parentPicklistVal ){
                selectOpts.add(new SelectOption(s, s));
            }    
        }
        
        SelectedParentPicklistOptions.addAll(selectOpts);
        
        List<System.SelectOption> AllPRaentSelectedVal=SelectedParentPicklistOptions;
        
        set<string> setselectVal=new set<string>();
        
        for(System.SelectOption opt:AllPRaentSelectedVal){
            setselectVal.add(opt.getvalue());
        }
        
        
        ParentPicklistOptions.clear();
        
        List<SelectOption> selectOpts2 = new List<SelectOption>();
        for(String s : parentOpts  ){
            if(!setselectVal.contains(s))
            selectOpts2.add(new SelectOption(s, s));
        }
     
        ParentPicklistOptions.addAll(selectOpts2);
        
        fCallAddToChildAvailableList();
    
        
        return null;
    }
    
    public void fCallAddToChildAvailableList(){
    
        List<System.SelectOption> AllPRaentSelectedVal=SelectedParentPicklistOptions;
        
        set<string> setselectVal=new set<string>();
        
        for(System.SelectOption opt:AllPRaentSelectedVal){
            setselectVal.add(opt.getvalue());
        }
        
        List<SelectOption> selectOpts = new List<SelectOption>();
        Set<String> possibleOpts = new Set<String>();
        for ( String val : setselectVal){
            if(parentChildMap.get(val)!=null)
            possibleOpts.addAll(parentChildMap.get(val));
        }
        
        list<system.Selectoption> AllselectedChildPickListOption=SelectedChildPicklistOptions;
        
        set<string> setselectedChildOpt=new set<string>();
        
        for(System.SelectOption opt:AllselectedChildPickListOption){
            setselectedChildOpt.add(opt.getvalue());
        }
            
        for ( String s : possibleOpts ){
            if(!setselectedChildOpt.contains(s))
            selectOpts.add(new SelectOption(s, s));
        }    
        ChildPicklistOptions.clear();
        ChildPicklistOptions.addAll(selectOpts);        
                
                
        
    
    }
        
  
    
    public PageReference addChildPicklistVals(){
        bIsRemovedChild=false;
        bIsAddChild=true;
        
        List<SelectOption> selectOpts = new List<SelectOption>();
        if (childPicklistVal != null && childPicklistVal .size() > 0 ) {
           for(String s : childPicklistVal ){
                selectOpts.add(new SelectOption(s, s));
            }    
        }
        
        
        SelectedChildPicklistOptions.addAll(selectOpts);
        ChildPicklistOptions.clear();
        
        List<System.SelectOption> AllPRaentSelectedVal=SelectedParentPicklistOptions;
        
        set<string> setselectVal=new set<string>();
        
        for(System.SelectOption opt:AllPRaentSelectedVal){
            setselectVal.add(opt.getvalue());
        }
        
        List<SelectOption> selectOpts2 = new List<SelectOption>();
        Set<String> possibleOpts = new Set<String>();
        for ( String val : setselectVal){
            if(parentChildMap.get(val)!=null)
            possibleOpts.addAll(parentChildMap.get(val));
        }    
        list<system.Selectoption> AllselectedChildPickListOption=SelectedChildPicklistOptions;
        
        set<string> setselectedChildOpt=new set<string>();
        
        for(System.SelectOption opt:AllselectedChildPickListOption){
            setselectedChildOpt.add(opt.getvalue());
        }
        
        for (String s : possibleOpts ){
            if(!setselectedChildOpt.contains(s))
            selectOpts2.add(new SelectOption(s, s));
        }
        ChildPicklistOptions.addAll(selectOpts2);
        
        
        return null;
    }   
    
    

  
 public PageReference actionRemovePicklistVals() {
        // this doesn't really need to do anything, since the picklists should be updated when their getters call after returning
        bIsRemoved=true;
        
        set<string> setRemoveSelected=new set<string>();
        if (selectedparentPicklistVal != null && selectedparentPicklistVal .size() > 0 ) {
           for(String s : selectedparentPicklistVal){
                setRemoveSelected.add(s);
            }    
        }
        
        List<System.SelectOption> AllPRaentSelectedVal=SelectedParentPicklistOptions;
        
        set<string> setselectVal=new set<string>();
        
        for(System.SelectOption opt:AllPRaentSelectedVal){
            setselectVal.add(opt.getvalue());
        }
        
        setselectVal.removeAll(setRemoveSelected);
        
        SelectedParentPicklistOptions.clear();
        
        List<SelectOption> selectOpts2 = new List<SelectOption>();
        
        for(string s:setselectVal){
            selectOpts2.add(new SelectOption(s, s));
        }
        
        SelectedParentPicklistOptions.addAll(selectOpts2);
        
        RefreshParentOption();
        RefreshChildOption();
        
        
        return null;
    }
    
    public void RefreshParentOption(){
    
        ParentPicklistOptions.clear();
        
        List<System.SelectOption> AllPRaentSelectedVal=SelectedParentPicklistOptions;
        
        set<string> setselectVal=new set<string>();
        
        for(System.SelectOption opt:AllPRaentSelectedVal){
            setselectVal.add(opt.getvalue());
        }
        
        List<SelectOption> selectOpts2 = new List<SelectOption>();
        for(String s : parentOpts  ){
            if(!setselectVal.contains(s))
            selectOpts2.add(new SelectOption(s, s));
        }
     
        ParentPicklistOptions.addAll(selectOpts2);
    
    
    }
    
    public void RefreshChildOption(){
    
        ChildPicklistOptions.clear();
        
        List<System.SelectOption> AllPRaentSelectedVal=SelectedParentPicklistOptions;
        
        set<string> setselectVal=new set<string>();
        
        for(System.SelectOption opt:AllPRaentSelectedVal){
            setselectVal.add(opt.getvalue());
        }
        
        List<SelectOption> selectOpts2 = new List<SelectOption>();
        Set<String> possibleOpts = new Set<String>();
        for ( String val : setselectVal){
            if(parentChildMap.get(val)!=null)
            possibleOpts.addAll(parentChildMap.get(val));
        }
        
        list<system.SelectOption> lstSelectedChildPickListOpt=SelectedChildPicklistOptions;
        set<string> setAlreadySelectedChildPickListVal=new set<string>();
        
        for(system.SelectOption opt:lstSelectedChildPickListOpt){
            setAlreadySelectedChildPickListVal.add(opt.getValue());
        }
        
        list<system.selectoption> lstSelectOpt=new list<system.selectoption>();
        for (String s : possibleOpts ){
            if(!setAlreadySelectedChildPickListVal.contains(s))
                lstSelectOpt.add(new SelectOption(s, s));
        }
        ChildPicklistOptions.addAll(lstSelectOpt);
        
        
    
    }
    
    public PageReference RemoveChildPicklistVals(){
        //bIsRemovedChild=true;
        //bIsAddChild=false;
        
        set<string> setSelectedChildItem=new set<string>();
        if(selectedchildPicklistVal!=null && selectedchildPicklistVal.size()>0){
            for(string s:selectedchildPicklistVal){
                setSelectedChildItem.add(s);
            }
        }
        
        list<system.SelectOption> lstSelectedChildOption=new list<system.SelectOption>();
        lstSelectedChildOption=SelectedChildPicklistOptions;
        
        set<string> setAllOptionSelectedChild=new set<string>();
        
        for(system.SelectOption opt:lstSelectedChildOption){
            setAllOptionSelectedChild.add(opt.getValue());
        }
        
        setAllOptionSelectedChild.removeAll(setSelectedChildItem);
        
        list<system.selectoption> lstSelectOpt=new list<system.selectoption>();
        for(string s:setAllOptionSelectedChild){
            lstSelectOpt.add(new SelectOption(s, s));
        }
        
        SelectedChildPicklistOptions.clear();
        SelectedChildPicklistOptions.addAll(lstSelectOpt);
        RefreshChildOption();
        return null;
    }
    
      public string showselectedchildPicklistVal{get;set;}
      
      public void showSelectedChildPicklistOptions(){
      
      }


}