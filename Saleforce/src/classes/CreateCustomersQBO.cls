public class CreateCustomersQBO {
 public static Boolean CreateCustomersQBOexecuting=false;
    @future(callout=true)
    public static void createUpdateCustomersQB(set<Id> accIdSet, String Operation){
        if(CreateCustomersQBO.CreateCustomersQBOexecuting==true){
        return;
        }
        Map<Id, Account>accountIdMap= new Map<Id, Account>();
        String x;//for githubtetsss
        CreateCustomersQBO.CreateCustomersQBOexecuting=true;
        List<Account> acclist=[Select id,Name,QBO_Customer_Email__c,QBO_Customer_Id__c,QBO_Sync_With_Quickbooks__c,Phone,QBO_SyncToken__c,BillingAddress,BillingCity,BillingCountry,BillingPostalCode,BillingState,BillingStreet from Account where id IN:accIdSet];
        List<Account>updateAccountList= new List<Account>();
        String response;
        if(Operation=='create'){
          JSONToApexCustomer customerBatch= new JSONToApexCustomer();
        
        List<JSONToApexCustomer.BatchItemRequest> listBatchItemreq= new List<JSONToApexCustomer.BatchItemRequest>();
        for(Account ac: accList){
            accountIdMap.put(ac.Id, ac);
            JSONToApexCustomer.BatchItemRequest batchitemrequest= new JSONToApexCustomer.BatchItemRequest();
            JSONToApexCustomer.Customer customer = new JSONToApexCustomer.Customer();
            JSONToApexCustomer.BillAddr address= new JSONToApexCustomer.BillAddr();
            JSONToApexCustomer.PrimaryPhone primePhone= new JSONToApexCustomer.PrimaryPhone();
            JSONToApexCustomer.PrimaryEmailAddr primEmail= new JSONToApexCustomer.PrimaryEmailAddr();
            primEmail.Address=ac.QBO_Customer_Email__c;
            primePhone.FreeFormNumber=ac.Phone;
            customer.GivenName=ac.Name;
            address.City=ac.BillingCity;
            address.Country=ac.BillingCountry;
            address.PostalCode=ac.BillingPostalCode;
            address.CountrySubDivisionCode=ac.BillingState;
            address.Line1=ac.BillingStreet;
            customer.PrimaryEmailAddr=primEmail;
            batchitemrequest.operation='create';
            customer.PrimaryPhone=primePhone;
            customer.BillAddr=address;
            
            batchitemrequest.Customer=customer;
            batchitemrequest.bId=String.valueof(ac.Id);
          
            listBatchItemreq.add(batchitemrequest);
           
        }
        customerBatch.BatchItemRequest=listBatchItemreq;
        String JsonString=Json.serialize(customerBatch);
        System.debug('JsonString'+JsonString); 
            if(!Test.isRunningTest()){
              response=QuickbooksSendRequestAndRecieveResponse.SendRequest(JsonString, 'batch', 'POST');  
            }else{
                response='{"BatchItemResponse":[{"Customer":{"Taxable":true,"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","domain":"QBO","sparse":false,"Id":"69","SyncToken":"0","MetaData":{"CreateTime":"2016-05-16T07:05:24-07:00","LastUpdatedTime":"2016-05-16T07:05:24-07:00"},"GivenName":"Test Record types","FullyQualifiedName":"Test Record types","DisplayName":"Test Record types","PrintOnCheckName":"Test Record types","Active":true,"DefaultTaxCodeRef":{"value":"2"}},"bId":"0012800000d9qFvAAI"}],"time":"2016-05-16T07:05:24.106-07:00"}';
            }    
        
        }else if(Operation=='update'){
             JSONToApexCustomerUpdate customerBatch= new JSONToApexCustomerUpdate();
        
        List<JSONToApexCustomerUpdate.BatchItemRequest> listBatchItemreq= new List<JSONToApexCustomerUpdate.BatchItemRequest>();
        for(Account ac: accList){
            accountIdMap.put(ac.Id, ac);
            JSONToApexCustomerUpdate.BatchItemRequest batchitemrequest= new JSONToApexCustomerUpdate.BatchItemRequest();
            JSONToApexCustomerUpdate.Customer customer = new JSONToApexCustomerUpdate.Customer();
            JSONToApexCustomerUpdate.BillAddr address= new JSONToApexCustomerUpdate.BillAddr();
            JSONToApexCustomerUpdate.PrimaryPhone primePhone= new JSONToApexCustomerUpdate.PrimaryPhone();
            JSONToApexCustomerUpdate.PrimaryEmailAddr primEmail= new JSONToApexCustomerUpdate.PrimaryEmailAddr();
            primEmail.Address=ac.QBO_Customer_Email__c;
            primePhone.FreeFormNumber=ac.Phone;
            customer.GivenName=ac.Name;
            address.City=ac.BillingCity;
            address.Country=ac.BillingCountry;
            address.PostalCode=ac.BillingPostalCode;
            address.CountrySubDivisionCode=ac.BillingState;
            address.Line1=ac.BillingStreet;
            customer.PrimaryEmailAddr=primEmail;
            customer.SyncToken=ac.QBO_SyncToken__c;
            batchitemrequest.operation='update';
            customer.PrimaryPhone=primePhone;
            customer.BillAddr=address;
            customer.Id=ac.QBO_Customer_Id__c;
            batchitemrequest.Customer=customer;
            batchitemrequest.bId=String.valueof(ac.id);
          
            listBatchItemreq.add(batchitemrequest);
           
        }
        customerBatch.BatchItemRequest=listBatchItemreq;
        String JsonString=Json.serialize(customerBatch);
        System.debug('JsonString'+JsonString); 
            if(!Test.isRunningTest()){
               response=QuickbooksSendRequestAndRecieveResponse.SendRequest(JsonString, 'batch', 'POST'); 
            }else{
               response='{"BatchItemResponse":[{"Customer":{"Taxable":true,"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","domain":"QBO","sparse":false,"Id":"69","SyncToken":"0","MetaData":{"CreateTime":"2016-05-16T07:05:24-07:00","LastUpdatedTime":"2016-05-16T07:05:24-07:00"},"GivenName":"Test Record types","FullyQualifiedName":"Test Record types","DisplayName":"Test Record types","PrintOnCheckName":"Test Record types","Active":true,"DefaultTaxCodeRef":{"value":"2"}},"bId":"0012800000d9qFvAAI"}],"time":"2016-05-16T07:05:24.106-07:00"}';
            }    
        
        }
         System.debug('response'+response);
        JsonParserBatchCustomerResponse responseJsonCust= new JsonParserBatchCustomerResponse();
        responseJsonCust=(JsonParserBatchCustomerResponse)JSON.deserialize(response, JsonParserBatchCustomerResponse.class);
        if(responseJsonCust.BatchItemResponse!=null){
            for(JsonParserBatchCustomerResponse.BatchItemResponse b: responseJsonCust.BatchItemResponse){
                if(accountIdMap.get(b.bId)!=null){
                    Account acc=accountIdMap.get(b.bId);
                    acc.QBO_Customer_Id__c=b.Customer.Id;
                    acc.QBO_SyncToken__c=b.customer.synctoken;
                    updateAccountList.add(acc);
                }
            }
        }
       
        if(!updateAccountList.isEmpty()){
        QBO_ConstantUtilityClass.QBOInsertionTriggerExecuting=true;
        update updateAccountList;
        
        }

    }   

}