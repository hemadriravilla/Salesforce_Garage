public class multipleOP{
    public integer myinputvalue{get;set;}
    public List<integer> myOutputValue{get;set;}
    
    public void myLogic(){
        myOutputValue = new List<integer>();
        
        for(integer i=0;i<=myinputvalue;i++){
            myOutputValue.add(i);
        }
    }
}