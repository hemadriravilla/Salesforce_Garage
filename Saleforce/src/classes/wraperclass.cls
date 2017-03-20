public class wraperclass{
   public list<wc> allwcs{get;set;}
   public integer inputtext{get;set;}
   public integer myoutput{get;set;}
   
   public void runmethod(){
   allWCs = New List<WC>();
     for(integer j=0;j<inputtext;j++){
     wc varName =new WC();
     varName.odd=j;
     j=j+1;
     varName.even=j;
     varname.b=false;
     
     allwcs.add(varName);
     }
   

   
   }
   
   public void calculatedata(){
   integer myoutput=0;
   for(integer i=0;i<allwcs.size();i++){
   if(allwcs[i].b){
   
   myoutput=myoutput+allwcs[i].odd+allwcs[i].even;
   
          }
      
      
     }
   
   }

}