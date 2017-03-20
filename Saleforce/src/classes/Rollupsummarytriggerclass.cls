public class Rollupsummarytriggerclass{

      public static void Rollupsummarytriggerclasscount(list<Company__c> companyObj){
      
        list<ID> clientIds = New List<ID>();
        Map<ID,Integer> countOfChilds = New Map<ID,Integer>();          
        
        for(integer i=0;i<companyObj.size();i++){
              clientIds.add(companyObj[i].client__c);   
        }
        
        List<company__c> companyClients = [SELECT id,Client__c FROM company__c where Client__c = :clientIds ];
        
        for(integer j=0;j<companyClients.size();j++){
            if(!countOfChilds.containsKey(companyClients[j].client__c)){
                countOfChilds.put(companyClients[j].Client__c,1);
            }else{
                integer increseCount = countOfChilds.get(companyClients[j].client__c) + 1;
                countOfChilds.put(companyClients[j].Client__c,increseCount);
            }
        }
        
        List<client__c> clientRollUpupdate = [SELECT id FROM Client__c WHERE id=:clientIds];
        List<client__c> allClientCountupdates = New List<client__c>();
        
        for(integer k=0;k<clientRollUpupdate.size();k++){
            if(countOfChilds.containsKey(clientRollUpupdate[k].id)){
                clientRollUpupdate[k].Count__c = countOfChilds.get(clientRollUpupdate[k].id);
            }
            allClientCountupdates.add(clientRollUpupdate[k]);
        }   
       
       update  allClientCountupdates;
    }
}