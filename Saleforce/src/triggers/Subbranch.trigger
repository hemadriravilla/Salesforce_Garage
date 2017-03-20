trigger Subbranch on Account (after insert,before update) {
Triggermute__c mt = new Triggermute__c();
list<Sub_Branch__c> sbbranch1 =new list<Sub_Branch__c>();
Sub_Branch__c sbbranch ;
if(mt.triggerunmute__c==false){

for(account acc2:trigger.new){
if(acc2.Number_of_Sub_Branches__c!=null)
for(integer i=1;i<=acc2.Number_of_Sub_Branches__c;i++){
sbbranch =new Sub_Branch__c();
sbbranch.Name=acc2.name+'SUB'+'000'+i ;
 sbbranch1.add(sbbranch);
}
}
}
upsert sbbranch1 ;
}