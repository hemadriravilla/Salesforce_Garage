public class QBOSyncObjects {
    @future(Callout=true)
    public static void syncCustomers(){
        Set<String>QBOCustomerId= new Set<String>();
        Map<String, Account> qbOCustomerIdMap= new Map<String, Account>();
        String lastsyncDate;
        String URL;
        QB_Sync_Date__c  qbs= QB_Sync_Date__c.getInstance('QBOLastSync');
        if(qbs.value__c==null){
            URL='Select%20%2A%20from%20Customer%20MAXRESULTS%201000';
            
        }else{
          lastsyncDate=qbs.Value__c.format('yyyy-MM-dd\'T\'HH:mm:ss')+'Z';
            URL='Select%20%2A%20from%20Customer%20where%20Metadata.LastUpdatedTime%20%3E%20%27'+EncodingUtil.urlEncode(lastsyncDate, 'UTF-8')+'%27%20MaxResults%201000';
        }
        String response=QuickbooksSendRequestAndRecieveResponse.sendGetRequest(URL);
        System.debug('response'+response);
        JsonParserBatchCustomerResponse responseJsonCust= new JsonParserBatchCustomerResponse();
        responseJsonCust=(JsonParserBatchCustomerResponse)JSON.deserialize(response, JsonParserBatchCustomerResponse.class);
        if(responseJsonCust.QueryResponse!=null){
            for(JsonParserBatchCustomerResponse.Customer c:responseJsonCust.QueryResponse.Customer){
                QBOCustomerId.add(c.Id);
            }
        }
        List<Account>accLisToUpdate=[Select id ,QBO_Customer_Id__c from Account where QBO_Customer_Id__c IN: QBOCustomerId];
        for(Account a:accLisToUpdate){
            qbOCustomerIdMap.put(a.QBO_Customer_Id__c,a);
        }
        List<Account>AccountInsertupdateList= new List<Account>();
        for(JsonParserBatchCustomerResponse.Customer c:responseJsonCust.QueryResponse.Customer){
            Account ac;
            if(qbOCustomerIdMap.keySet().contains(c.Id)){
                ac=qbOCustomerIdMap.get(c.Id);
            }else{
                ac= new Account();
            }
            ac.Name=c.GivenName;
            ac.QBO_SyncToken__c=c.SyncToken;
            if(c.PrimaryEmailAddr!=null)
            ac.QBO_Customer_Email__c=c.PrimaryEmailAddr.Address;
            if(c.PrimaryPhone!=null)
            ac.Phone=c.PrimaryPhone.FreeFormNumber;
            if(c.BillAddr!=null){
            ac.BillingCity=c.BillAddr.City;
            ac.BillingCountry=c.BillAddr.Country;
            ac.BillingPostalCode=c.billAddr.PostalCode;
            ac.BillingState=c.BillAddr.CountrySubDivisionCode;
            ac.BillingStreet=c.BillAddr.Line1;  
            }
            QBO_ConstantUtilityClass.QBOInsertionExecuting=true;
            AccountInsertupdateList.add(ac);
        }
        if(!AccountInsertupdateList.isEmpty()){
            upsert AccountInsertupdateList;
        }
    }
    @future(callout=true)
    public static void syncInvoicesAndLineItems(){
        Set<String>QBOInvoiceIdSet= new Set<String>();
        Set<String>CustomerRefSet=new Set<String>();
        Map<String, QBO_Term__c> qboTermMap=new Map<String, QBO_Term__c>();
        Map<String, QBO_Invoice__c>qboInvoiceMap= new Map<String,QBO_Invoice__c>();
        Map<String,List<QBO_Invoice_Line_Item__c>> invInvoiceLineitemMap= new Map<String,List<QBO_Invoice_Line_Item__c>>();
        List<QBO_Invoice_Line_Item__c> updateinvoiceItemList= new List<QBO_Invoice_Line_Item__c>();
        Map<String, Account> qbOCustomerIdMap= new Map<String, Account>();
        Map<String, Id> InvoicenameIdMap= new Map<String, Id>();
        Map<String,Product2>prodcutMap= new Map<String,Product2>();
        String lastsyncDate;
        String URL;
        QB_Sync_Date__c  qbs= QB_Sync_Date__c.getInstance('QBOLastSync');
        if(qbs.value__c==null){
            URL='Select%20%2A%20from%20Invoice%20MAXRESULTS%201000';
            
        }else{
          lastsyncDate=qbs.Value__c.format('yyyy-MM-dd\'T\'HH:mm:ss')+'Z';
            URL='Select%20%2A%20from%20Invoice%20where%20Metadata.LastUpdatedTime%20%3E%20%27'+EncodingUtil.urlEncode(lastsyncDate, 'UTF-8')+'%27%20MaxResults%201000';
        }
        String response=QuickbooksSendRequestAndRecieveResponse.sendGetRequest(URL);
        System.debug('response'+response);
        JsonParserBatchInvoiceResponse responseJsonInv= new JsonParserBatchInvoiceResponse();
        responseJsonInv=(JsonParserBatchInvoiceResponse)JSON.deserialize(response, JsonParserBatchInvoiceResponse.class);
        if(responseJsonInv.QueryResponse!=null && responseJsonInv.QueryResponse.Invoice!=null){
            for(JsonParserBatchInvoiceResponse.Invoice inv:responseJsonInv.QueryResponse.Invoice){
                QBOInvoiceIdSet.add(inv.DocNumber);
                CustomerRefSet.add(inv.CustomerRef.Value);
            }
            for(QBO_Term__c qt: [Select id ,QBO_Term_Id__c,Name from QBO_Term__c]){
               qboTermMap.put(qt.QBO_Term_Id__c,qt); 
            }
            for(Product2 pr:[Select id, QBO_Product_Id__c from Product2]){
                prodcutMap.put(pr.QBO_Product_Id__c,pr);
            }
            for(QBO_Invoice__c qbInv:[Select id,Name,QBO_Invoice_Id__c,QBO_Invoice_Date__c,QBO_Customer__r.QBO_Customer_Id__c,QBO_Invoice_Due_Date__c from QBO_Invoice__c where QBO_Invoice_Id__c IN:QBOInvoiceIdSet]){
                qboInvoiceMap.put(qbInv.QBO_Invoice_Id__c,qbInv);
            }
            for(Account a:[Select id ,QBO_Customer_Id__c from Account where QBO_Customer_Id__c IN: CustomerRefSet]){
                qbOCustomerIdMap.put(a.QBO_Customer_Id__c,a);
            }
            List<QBO_Invoice__c> invoiceList= new List<QBO_Invoice__c>();
            for(JsonParserBatchInvoiceResponse.Invoice inv:responseJsonInv.QueryResponse.Invoice){
                QBO_Invoice__c invoice;
                if(qboInvoiceMap.keySet().contains(inv.DocNumber)){
                   invoice=qboInvoiceMap.get(inv.DocNumber);
                }else{
                    invoice= new QBO_Invoice__c();
                }
                invoice.QBO_SyncToken__c=inv.SyncToken;
                invoice.QBO_Invoice_Date__c=Date.valueof(inv.TxnDate);
                invoice.QBO_Invoice_Due_Date__c=Date.valueOf(inv.DueDate);
                invoice.QBO_Invoice_Id__c=inv.DocNumber;
                if(inv.SalesTermRef!=null){
                    if(qboTermMap.get(inv.SalesTermRef.value)!=null)
                   invoice.QBO_Term__c=qboTermMap.get(inv.SalesTermRef.value).Id;
                }
                if(qbOCustomerIdMap.keySet().contains(inv.CustomerRef.Value)){
                    invoice.QBO_Customer__c=qbOCustomerIdMap.get(inv.CustomerRef.Value).Id;
                }
                invoiceList.add(invoice);
                if(inv.line!=null){
                    List<QBO_Invoice_Line_Item__c> invlineItemList= new List<QBO_Invoice_Line_Item__c>();
                    for(JsonParserBatchInvoiceResponse.Line invline: inv.Line){
                        if(invline.Id!=null){
                            QBO_Invoice_Line_Item__c invlineitem= new QBO_Invoice_Line_Item__c();
                            if(invline.SalesItemLineDetail!=null){
                                invlineitem.QBO_Quantity__c=invline.SalesItemLineDetail.Qty;
                                invlineitem.QBO_Unit_Price__c=invline.SalesItemLineDetail.UnitPrice;
                                invlineitem.QBO_Line_Description__c=invline.Description;
                                if(invline.SalesItemLineDetail.itemRef!=null){
                                    if(prodcutMap.keySet().contains(invline.SalesItemLineDetail.itemRef.Value)) {
                                        invlineitem.QBO_Product__c=prodcutMap.get(invline.SalesItemLineDetail.itemRef.Value).Id;
                                    }
                                }
                            }
                            invlineItemList.add(invlineitem);
                        }
                    }
                    //creating a map of invoice number and invoice line item list
                    invInvoiceLineitemMap.put(inv.DocNumber,invlineItemList);
                }
            }
            if(!invoicelist.isEmpty()){
                Database.upsert(invoicelist);
            }
            for(QBO_Invoice__c inv:invoicelist){
          //after inserting the invoice creaint  a map of invoice number and Invoice id
           InvoicenameIdMap.put(inv.QBO_Invoice_Id__c, inv.id);
          }
           List<QBO_Invoice_Line_Item__c> listofInvoiceLineItems=[Select id,QBO_Invoice__c from QBO_Invoice_Line_Item__c where QBO_Invoice__c IN:InvoicenameIdMap.values()];
           delete listofInvoiceLineItems;
            for(String invoicedoc:InvoicenameIdMap.keyset()){ 
         
            for(QBO_Invoice_Line_Item__c invline: invInvoiceLineitemMap.get(invoicedoc)){
              invline.QBO_Invoice__c=InvoicenameIdMap.get(invoicedoc);
              updateinvoiceItemList.add(invline);
          }
        }
           
          if(!updateinvoiceItemList.isEmpty()){
          Database.upsert(updateinvoiceItemList);
      }
      }
    }
  
   
    @future(Callout=true)
    public static void syncPayments(){
        Set<String>paymentRefSet= new Set<String>();
        Map<String,QBO_Payment__c> mapQBOPaymentMap= new Map<String,QBO_Payment__c>();
        List<QBO_Payment__c>paymentListUpdate= new List<QBO_Payment__c>();
        Set<String>customerIdSet= new Set<String>();
        Map<String, QBO_Payment_Method__c>qboPaymentMethodMap=new Map<String,QBO_Payment_Method__c>();
        Map<String, Account>qboCustomerMap= new Map<String, Account>();
        String lastsyncDate;
        String URL;
        QB_Sync_Date__c  qbs= QB_Sync_Date__c.getInstance('QBOLastSync');
        if(qbs.value__c==null){
            URL='Select%20%2A%20from%20Payment%20MAXRESULTS%201000';
            
        }else{
          lastsyncDate=qbs.Value__c.format('yyyy-MM-dd\'T\'HH:mm:ss')+'Z';
            URL='Select%20%2A%20from%20Payment%20where%20Metadata.LastUpdatedTime%20%3E%20%27'+EncodingUtil.urlEncode(lastsyncDate, 'UTF-8')+'%27%20MaxResults%201000';
        }
        String response=QuickbooksSendRequestAndRecieveResponse.sendGetRequest(URL);
        System.debug('response'+response);
        JSONToQBPaymentParser responsepayment= new JSONToQBPaymentParser();
        responsepayment=(JSONToQBPaymentParser)JSON.deserialize(response, JSONToQBPaymentParser.class);
        if(responsepayment.QueryResponse!=null){
            for(JSONToQBPaymentParser.Payment paym:responsepayment.QueryResponse.Payment){
                paymentRefSet.add(paym.PaymentRefNum);
                if(paym.CustomerRef!=null)
                customerIdSet.add(paym.CustomerRef.value);
            }
            for(QBO_Payment__c payment:[Select id,Name,QBO_Client__c,QBO_Payment_Method__c,QBO_Total_Amount__c,QBO_Transaction_Date__c from QBO_Payment__c where Name IN: paymentRefSet]){
                mapQBOPaymentMap.put(payment.Name,payment);
            }
            for(QBO_Payment_Method__c paymentMethod:[Select id, QBO_PaymentMethod_Ref_Id__c from QBO_Payment_Method__c]){
                qboPaymentMethodMap.put(paymentMethod.QBO_PaymentMethod_Ref_Id__c,paymentMethod);
            }
            for(Account acc:[Select id,QBO_Customer_Id__C from Account where QBO_Customer_Id__C IN:customerIdSet]){
               qboCustomerMap.put(acc.QBO_Customer_Id__C, acc); 
            }
            for(JSONToQBPaymentParser.Payment paym:responsepayment.QueryResponse.Payment){
                QBO_Payment__c payment;
                if(mapQBOPaymentMap.get(paym.PaymentRefNum)!=null){
                    payment=mapQBOPaymentMap.get(paym.PaymentRefNum);
                }else{
                    payment= new QBO_Payment__c();
                }
                payment.Name=paym.Id;
                payment.QBO_Payment_Reference_Number__c=paym.PaymentRefNum;
                payment.QBO_Total_Amount__c=paym.TotalAmt;
                if(qboCustomerMap.get(paym.CustomerRef.value)!=null)
                payment.QBO_Client__c=qboCustomerMap.get(paym.CustomerRef.value).Id;
                if(paym.PaymentMethodRef!=null){
                    if(qboPaymentMethodMap.get(paym.PaymentMethodRef.value)!=null)
                   payment.QBO_Payment_Method__c=qboPaymentMethodMap.get(paym.PaymentMethodRef.value).Id;
                }
                if(paym.TxnDate!=null)
                payment.QBO_Transaction_Date__c=Date.valueof(paym.TxnDate);
                paymentListUpdate.add(payment);
            } 
            if(!paymentListUpdate.isEmpty()){
                Database.upsert(paymentListUpdate);
            }
        }
        QB_Sync_Date__c qbsyndate=[Select Name, Value__c from QB_Sync_Date__c where Name='QBOLastSync' Limit 1];
        qbsyndate.Value__c=Datetime.now()-(1/1440);
        update qbsyndate;
        
    }
  
}