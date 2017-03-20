Public Class WrapperClass{
    
    public List<WC> allWCs{get;set;}
    public Integer myInputNumber{get;set;}
    public integer myoutPut{get;set;}
    //public integer opt{get;set;}
//public integer even{get;set;}
// public integer odd{get;set;}
//public wc varname{get;set;}
    
    public void runWrapperMethod(){
         allWCs = New List<WC>();

        for(integer j=0;j<myInputNumber;j++){
            integer k=math.mod(j,2);
         WC varName = New WC();
    if(k!=0)
    {
           
            integer even=j;
            varName.o = j;
            varName.b = false;

    }
    else{

            integer odd=j;
            varName.i = j;
            varName.b = false;


    }
            
            allWCs.add(varName);
        }
    }
    
    public void calculateData(){
        myoutPut = 0;
        for(integer i=0;i<allWCs.size();i++){
            if(allWCs[i].b){
                myoutPut = myoutPut + allWCs[i].i;
            }
        }
    
    }
}