public class QBOInvoiceHandlerClass {
@future(callout=true)
    public static void createInvoicesInQBO(Set<Id>setofInvoiceId){
       
        Map<Id, List<QBO_Invoice_Line_Item__c>> invoiceAndLineItemsMap= new Map<Id, List<QBO_Invoice_Line_Item__c>>();
        List<QBO_Invoice__c>updateInvoiceList= new List<QBO_Invoice__c>();
        Map<Id,Account>customerMap= new Map<Id, Account>();
        Map<Id, QBO_Term__c>termMap= new Map<Id, QBO_Term__c>();
        Map<Id, Product2> QBOProductMap= new Map<Id,Product2>();
        Set<Id> QBOProductIdSet=new Set<Id>();
        Set<Id>customerIdSet= new Set<Id>();
        Set<Id>termIdSet= new Set<Id>();
        Map<Id,QBO_Invoice__c>invoiceMap= new Map<Id,QBO_Invoice__c>();
        for(QBO_Invoice__c invoice:[Select id,QBO_Invoice_Id__c,QBO_Invoice_Date__c,QBO_Invoice_Due_Date__c,QBO_Customer__c,QBO_Term__c,(Select id,QBO_Product__c,QBO_Line_Description__c,QBO_Unit_Price__c,QBO_Quantity__c from Invoice_Line_Items__r) from QBO_Invoice__c where QBO_Invoice_Id__c=null and Id IN:setofInvoiceId]){
            invoiceAndLineItemsMap.put(invoice.Id, invoice.Invoice_Line_Items__r);
            invoiceMap.put(invoice.Id,invoice);
            customerIdSet.add(invoice.QBO_Customer__c);
            termIdSet.add(invoice.QBO_Term__c);
            for(QBO_Invoice_Line_Item__c invlineitem:invoice.Invoice_Line_Items__r){
                QBOProductIdSet.add(invlineitem.QBO_Product__c);
            }
        }
        for(Product2 pr:[Select id,QBO_Product_Id__c,Name,Description from product2 where id in :QBOProductIdSet]){
            QBOProductMap.put(pr.Id,pr);
        }
        for(Account a:[Select id,QBO_Customer_Id__c from Account where Id IN:customerIdSet]){
           customerMap.put(a.Id, a); 
        }
        for(QBO_Term__c q:[Select id,QBO_Term_Id__c from QBO_Term__c where Id In:termIdSet]){
            termMap.put(q.Id, q);
        }
        JsonToQBInvoiceParser JsonInvoice= new JsonToQBInvoiceParser();
        List<JsonToQBInvoiceParser.BatchItemRequest> listofBatchItems= new List<JsonToQBInvoiceParser.BatchItemRequest>();
        for(String key:invoiceAndLineItemsMap.keySet()){
            JsonToQBInvoiceParser.BatchItemRequest br= new JsonToQBInvoiceParser.BatchItemRequest();
            JsonToQBInvoiceParser.Invoice inv= new JsonToQBInvoiceParser.Invoice();
             JsonToQBInvoiceParser.SalesTermRef term= new JsonToQBInvoiceParser.SalesTermRef();
                if(invoiceMap.get(Key).QBO_Term__c!=null){
                    if(termMap.get(invoiceMap.get(Key).QBO_Term__c)!=null)
                   term.value= termMap.get(invoiceMap.get(Key).QBO_Term__c).QBO_Term_Id__c;
                }
                inv.SalesTermRef=term;
            List<JsonToQBInvoiceParser.Line> listLineItems = new List<JsonToQBInvoiceParser.Line>();
            for(QBO_Invoice_Line_Item__c invline: invoiceAndLineItemsMap.get(key)){
                JsonToQBInvoiceParser.Line li= new JsonToQBInvoiceParser.Line();
                JsonToQBInvoiceParser.SalesItemLineDetail sadl= new JsonToQBInvoiceParser.SalesItemLineDetail();
                JsonToQBInvoiceParser.ItemRef itm= new JsonToQBInvoiceParser.ItemRef();
                if(invline.QBO_Product__c!=null){
                    if(QBOProductMap.get(invline.QBO_Product__c)!=null){
                     itm.Name=QBOProductMap.get(invline.QBO_Product__c).Name;
                    itm.Value=QBOProductMap.get(invline.QBO_Product__c).QBO_Product_Id__c;   
                    }
                }
                sadl.Qty=integer.valueof(invline.QBO_Quantity__c);
                sadl.UnitPrice=invline.QBO_Unit_Price__c;
                sadl.ItemRef=itm; 
                li.SalesItemLineDetail=sadl; 
                li.Description=invline.QBO_Line_Description__c;
                if(invline.QBO_Quantity__c!=null && invline.QBO_Unit_Price__c!=null)
                  li.Amount=invline.QBO_Quantity__c*invline.QBO_Unit_Price__c;
                  li.DetailType='SalesItemLineDetail';
                  listLineItems.add(li);
            }
            JsonToQBInvoiceParser.CustomerRef cust= new JsonToQBInvoiceParser.CustomerRef();
            if(invoiceMap.get(key).QBO_Customer__c!=null)
            cust.value=customerMap.get(invoiceMap.get(key).QBO_Customer__c).QBO_Customer_Id__c;
            inv.CustomerRef=cust;
            inv.TxnDate=String.valueof(invoiceMap.get(key).QBO_Invoice_Date__c);
            inv.DueDate=String.valueof(invoiceMap.get(key).QBO_Invoice_Due_Date__c);
            inv.Line=listLineItems;
            br.Invoice=inv;
            br.bId=key;
            br.operation='create';
            listofBatchItems.add(br);
        }
        JsonToQBInvoiceParser.BatchItemRequest batchInvoice=new JsonToQBInvoiceParser.BatchItemRequest();
        JsonInvoice.BatchItemRequest=listofBatchItems;
        String JsonString=Json.serialize(JsonInvoice);
        System.debug('JsonString'+JsonString);
        String response;
        if(!Test.isRunningTest()){
          response=QuickbooksSendRequestAndRecieveResponse.SendRequest(JsonString, 'batch', 'POST');   
        }else{
            response='{"BatchItemResponse":[{"Invoice":{"Deposit":0,"AllowIPNPayment":false,"AllowOnlinePayment":false,"AllowOnlineCreditCardPayment":false,"AllowOnlineACHPayment":false,"domain":"QBO","sparse":false,"Id":"148","SyncToken":"0","MetaData":{"CreateTime":"2016-05-17T06:17:53-07:00","LastUpdatedTime":"2016-05-17T06:17:53-07:00"},"CustomField":[{"DefinitionId":"1","Name":"Crew #","Type":"StringType"}],"DocNumber":"1041","TxnDate":"2016-05-17","CurrencyRef":{"value":"USD","name":"United States Dollar"},"LinkedTxn":[],"Line":[{"Id":"1","LineNum":1,"Description":"Test Product","Amount":2.00,"DetailType":"SalesItemLineDetail","SalesItemLineDetail":{"ItemRef":{"value":"4","name":"Design"},"UnitPrice":1,"Qty":2,"TaxCodeRef":{"value":"NON"}}},{"Amount":2.00,"DetailType":"SubTotalLineDetail","SubTotalLineDetail":{}}],"TxnTaxDetail":{"TotalTax":0},"CustomerRef":{"value":"70","name":"Amelia"},"BillAddr":{"Id":"97","Line1":"370 Easy St.","City":"Middlefield","CountrySubDivisionCode":"CA","PostalCode":"94482"},"ShipAddr":{"Id":"97","Line1":"370 Easy St.","City":"Middlefield","CountrySubDivisionCode":"CA","PostalCode":"94482"},"SalesTermRef":{"value":"4"},"DueDate":"2016-05-17","TotalAmt":2.00,"ApplyTaxAfterDiscount":false,"PrintStatus":"NeedToPrint","EmailStatus":"NotSet","Balance":2.00},"bId":"a032800000BFMoeAAH"}],"time":"2016-05-17T06:17:53.322-07:00"}';
        }
        
        System.debug('response'+response);
        JsonParserBatchInvoiceResponse batchResponseInvoice= new JsonParserBatchInvoiceResponse();
        batchResponseInvoice=(JsonParserBatchInvoiceResponse)JSON.deserialize(response, JsonParserBatchInvoiceResponse.class);
        if(batchResponseInvoice.BatchItemResponse!=null){
            for(JsonParserBatchInvoiceResponse.BatchItemResponse b: batchResponseInvoice.BatchItemResponse){
                if(invoiceMap.get(b.bId)!=null){
                   QBO_Invoice__c inv=invoiceMap.get(b.bId);
                   inv.QBO_Invoice_Id__c=b.Invoice.DocNumber;
                   inv.QBO_SyncToken__c=b.Invoice.SyncToken;
                   updateInvoiceList.add(inv);
            }   
        }
    }
        if(!updateInvoiceList.isEmpty()){
            QBO_ConstantUtilityClass.createInvoicesInQBOExecuting=true;
            Database.update(updateInvoiceList);
        }
 }  
}