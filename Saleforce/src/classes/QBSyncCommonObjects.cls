public class QBSyncCommonObjects {
  @future(Callout=true)
    public static void syncPaymentMethodReference(){
        Set<String>QBOPaymentMethodRefIdSet= new Set<String>();
        List<QBO_Payment_Method__c>updatePaymentMethodList= new List<QBO_Payment_Method__c>();
        Map<String, QBO_Payment_Method__c> qbOPaymentMethodIdMap= new Map<String, QBO_Payment_Method__c>();
        String lastsyncDate;
        String URL;
        QB_Sync_Date__c  qbs= QB_Sync_Date__c.getInstance('QBOCoMObjSyncDate');
        if(qbs.value__c==null){
            URL='Select%20%2A%20from%20PaymentMethod%20MAXRESULTS%201000';
            
        }else{
          lastsyncDate=qbs.Value__c.format('yyyy-MM-dd\'T\'HH:mm:ss')+'Z';
            URL='Select%20%2A%20from%20PaymentMethod%20where%20Metadata.LastUpdatedTime%20%3E%20%27'+EncodingUtil.urlEncode(lastsyncDate, 'UTF-8')+'%27%20MaxResults%201000';
        }
        String response=QuickbooksSendRequestAndRecieveResponse.sendGetRequest(URL);
        System.debug('response'+response);
        JSONQBPaymentMethodParser responseJsonPaymentMethod= new JSONQBPaymentMethodParser();
        responseJsonPaymentMethod=(JSONQBPaymentMethodParser)JSON.deserialize(response, JSONQBPaymentMethodParser.class);
        if(responseJsonPaymentMethod.QueryResponse!=null){
            for(JSONQBPaymentMethodParser.PaymentMethod pay:responseJsonPaymentMethod.QueryResponse.PaymentMethod){
                QBOPaymentMethodRefIdSet.add(pay.Id);
            }
            for(QBO_Payment_Method__c qbpaym:[Select id,QBO_PaymentMethod_Ref_Id__c,Name,QBO_IsActive__c,QBO_Payment_Type__c from QBO_Payment_Method__c where QBO_PaymentMethod_Ref_Id__c IN:QBOPaymentMethodRefIdSet]){
                qbOPaymentMethodIdMap.put(qbpaym.QBO_PaymentMethod_Ref_Id__c,qbpaym);
            }
            for(JSONQBPaymentMethodParser.PaymentMethod pay:responseJsonPaymentMethod.QueryResponse.PaymentMethod){
                QBO_Payment_Method__c paymentMethod;
                if(qbOPaymentMethodIdMap.keySet().contains(pay.Id)){
                    paymentMethod=qbOPaymentMethodIdMap.get(pay.Id);
                }else{
                   paymentMethod= new QBO_Payment_Method__c();
                }
                paymentMethod.Name=pay.Name;
                paymentMethod.QBO_Payment_Type__c=pay.Type;
                paymentMethod.QBO_IsActive__c=pay.Active;
                paymentMethod.QBO_PaymentMethod_Ref_Id__c=pay.Id;
                updatePaymentMethodList.add(paymentMethod);
            }
            if(!updatePaymentMethodList.isEmpty()){
                Database.upsert(updatePaymentMethodList);
            }
        }
        QB_Sync_Date__c qbsyndate=[Select Name, Value__c from QB_Sync_Date__c where Name='QBOCoMObjSyncDate' Limit 1];
        qbsyndate.Value__c=Datetime.now()-(1/1440);
        update qbsyndate;
    }
      @future(Callout=true)
    public static void syncQBTaxRate(){
        set<String>taxRateIdSet= new set<String>();
        Map<String,QBO_Tax_Rate__c>taxRateMap= new Map<String,QBO_Tax_Rate__c>();
        List<QBO_Tax_Rate__c>updateListTaxtRate= new List<QBO_Tax_Rate__c>();
        String lastsyncDate;
        String URL;
        QB_Sync_Date__c  qbs= QB_Sync_Date__c.getInstance('QBOCoMObjSyncDate');
        if(qbs.value__c==null){
            URL='Select%20%2A%20from%20TaxRate%20MAXRESULTS%201000';
            
        }else{
          lastsyncDate=qbs.Value__c.format('yyyy-MM-dd\'T\'HH:mm:ss')+'Z';
            URL='Select%20%2A%20from%20TaxRate%20where%20Metadata.LastUpdatedTime%20%3E%20%27'+EncodingUtil.urlEncode(lastsyncDate, 'UTF-8')+'%27%20MaxResults%201000';
        }
        String response=QuickbooksSendRequestAndRecieveResponse.sendGetRequest(URL);
        System.debug('response'+response);
        JsonParserTaxRate responseTaxRate= new JsonParserTaxRate();
        responseTaxRate=(JsonParserTaxRate)JSON.deserialize(response, JsonParserTaxRate.class);
        if(responseTaxRate.QueryResponse!=null){
            for(JsonParserTaxRate.TaxRate tr:responseTaxRate.QueryResponse.TaxRate){
                taxRateIdSet.add(tr.Id);
            }
            for(QBO_Tax_Rate__c qtr:[Select id, Name,QBO_Tax_Rate_Ref__c from QBO_Tax_Rate__c where QBO_Tax_Rate_Ref__c IN:taxRateIdSet]){
                taxRateMap.put(qtr.QBO_Tax_Rate_Ref__c,qtr);
            }
            for(JsonParserTaxRate.TaxRate tr:responseTaxRate.QueryResponse.TaxRate){
                QBO_Tax_Rate__c taxRate;
                if(taxRateMap.get(tr.Id)!=null){
                    taxRate=taxRateMap.get(tr.Id);
                }else{
                    taxRate= new QBO_Tax_Rate__c();
                }
                taxRate.Name=tr.Name;
                taxRate.QBO_Rate_Value__c=tr.RateValue;
                taxRate.QBO_Tax_Rate_Ref__c=tr.Id;
                updateListTaxtRate.add(taxRate);
            }
            if(!updateListTaxtRate.isEmpty()){
                Database.upsert(updateListTaxtRate);
            }
        }
    }
    @future(Callout=true)
    public static void syncTaxCode(){
        Set<String>taxCodeIdSet=new Set<String>();
        Map<String, String>taxCodeandRateMap= new Map<String, String>();
        List<QBO_Tax_Rate__c>updateQBOTaxRate= new List<QBO_Tax_Rate__c>();
        String lastsyncDate;
        String URL;
        List<QBO_Tax_Code__c>updatetaxcodeList= new List<QBO_Tax_Code__c>();
        Map<String, QBO_Tax_Code__c>taxCodMap= new Map<String, QBO_Tax_Code__c>();
        QB_Sync_Date__c  qbs= QB_Sync_Date__c.getInstance('QBOCoMObjSyncDate');
        if(qbs.value__c==null){
            URL='Select%20%2A%20from%20TaxCode%20MAXRESULTS%201000';
            
        }else{
          lastsyncDate=qbs.Value__c.format('yyyy-MM-dd\'T\'HH:mm:ss')+'Z';
            URL='Select%20%2A%20from%20TaxCode%20where%20Metadata.LastUpdatedTime%20%3E%20%27'+EncodingUtil.urlEncode(lastsyncDate, 'UTF-8')+'%27%20MaxResults%201000';
        }
        String response=QuickbooksSendRequestAndRecieveResponse.sendGetRequest(URL);
        System.debug('response'+response);
        JsonParserTaxCode taxCodeResponse= new JsonParserTaxCode();
        taxCodeResponse=(JsonParserTaxCode)JSON.deserialize(response, JsonParserTaxCode.class);
        if(taxCodeResponse.QueryResponse!=null){
            for(JsonParserTaxCode.TaxCode taxcode:taxCodeResponse.QueryResponse.TaxCode){
                taxCodeIdSet.add(taxcode.Id);
                if(taxcode.SalesTaxRateList!=null){
                    for(JsonParserTaxCode.TaxRateDetail tr:taxcode.SalesTaxRateList.TaxRateDetail){
                        if(tr.TaxRateRef!=null){
                            taxCodeandRateMap.put(tr.TaxRateRef.value,taxcode.Id);
                        }
                    }
                }
            }
            for(QBO_Tax_Code__c taxcode:[Select id,QBO_Tax_Id__c from QBO_Tax_Code__c where QBO_Tax_Id__c IN:taxCodeIdSet]){
                taxCodMap.put(taxcode.QBO_Tax_Id__c,taxcode);
            }
            for(JsonParserTaxCode.TaxCode taxcode:taxCodeResponse.QueryResponse.TaxCode){
                QBO_Tax_Code__c tax;
                if(taxCodMap.get(taxcode.Id)!=null){
                    tax=taxCodMap.get(taxcode.Id);
                }else{
                    tax= new QBO_Tax_Code__c();
                }
                tax.Name=taxcode.Name;
                tax.QBO_Description__c=taxcode.Description;
                tax.QBO_Tax_Id__c=taxcode.Id;
                updatetaxcodeList.add(tax);
            }
            if(!updatetaxcodeList.isempty()){
                Database.upsert(updatetaxcodeList);
            }
            
            for(QBO_Tax_Rate__c qbtr:[Select id,QBO_Tax_Code__c,QBO_Tax_Rate_Ref__c from QBO_Tax_Rate__c where QBO_Tax_Code__c=null and QBO_Tax_Rate_Ref__c IN: taxCodeandRateMap.keySet()]){
                if(taxCodeandRateMap.get(qbtr.QBO_Tax_Rate_Ref__c)!=null)
                 if(taxCodMap.get(taxCodeandRateMap.get(qbtr.QBO_Tax_Rate_Ref__c))!=null)    
                qbtr.QBO_Tax_Code__c=taxCodMap.get(taxCodeandRateMap.get(qbtr.QBO_Tax_Rate_Ref__c)).Id;
                updateQBOTaxRate.add(qbtr);
            }
 
            if(!updateQBOTaxRate.isEmpty()){
                Database.update(updateQBOTaxRate);
            }
        }
    }
     @future(Callout=true)
    public static void syncTerms(){
        Set<String>TermIdSet=  new Set<String>();
        List<QBO_Term__c> listTermUpdate= new List<QBO_Term__c>();
        Map<String, QBO_Term__c> mapTerms= new Map<String,QBO_Term__c>();
        String lastsyncDate;
        String URL;
        QB_Sync_Date__c  qbs= QB_Sync_Date__c.getInstance('QBOCoMObjSyncDate');
        if(qbs.value__c==null){
            URL='Select%20%2A%20from%20Term%20MAXRESULTS%201000';
            
        }else{
          lastsyncDate=qbs.Value__c.format('yyyy-MM-dd\'T\'HH:mm:ss')+'Z';
            URL='Select%20%2A%20from%20Term%20where%20Metadata.LastUpdatedTime%20%3E%20%27'+EncodingUtil.urlEncode(lastsyncDate, 'UTF-8')+'%27%20MaxResults%201000';
        }
        String response=QuickbooksSendRequestAndRecieveResponse.sendGetRequest(URL);
        JsonParserTerms responseTerm= new JsonParserTerms();
        responseTerm=(JsonParserTerms)JSON.deserialize(response, JsonParserTerms.class);
        if(responseTerm.QueryResponse!=null){
            for(JsonParserTerms.Term t:responseTerm.QueryResponse.Term){
                TermIdSet.add(t.Id);
            }
            for(QBO_Term__c q:[Select id,QBO_Term_Id__c ,Name from QBO_Term__c where QBO_Term_Id__c IN:TermIdSet]){
                mapTerms.put(q.Id,q);
            }
            for(JsonParserTerms.Term t:responseTerm.QueryResponse.Term){
                QBO_Term__c tr;
                if(mapTerms.keySet().contains(t.Id)){
                    tr=mapTerms.get(t.Id);
                }else{
                    tr= new QBO_Term__c();
                }
                tr.Name=t.Name;
                tr.QBO_Term_Id__c=t.Id;
                listTermUpdate.add(tr);
            }
            if(!listTermUpdate.isEmpty()){
                Database.upsert(listTermUpdate);
            }
        }
    }
    
    @future(Callout=true)
    public static void syncProductsQB(){
        Set<String>QBOProdcutIdSet= new Set<String>();
        Map<String, Product2> mapOfProduct= new Map<String,Product2>();
        List<Product2> listofProducts= new list<Product2>();
         String lastsyncDate;
        String URL;
        QB_Sync_Date__c  qbs= QB_Sync_Date__c.getInstance('QBOCoMObjSyncDate');
        if(qbs.value__c==null){
            URL='Select%20%2A%20from%20Item%20MAXRESULTS%201000';
            
        }else{
          lastsyncDate=qbs.Value__c.format('yyyy-MM-dd\'T\'HH:mm:ss')+'Z';
            URL='Select%20%2A%20from%20Item%20where%20Metadata.LastUpdatedTime%20%3E%20%27'+EncodingUtil.urlEncode(lastsyncDate, 'UTF-8')+'%27%20MaxResults%201000';
        }
        String response=QuickbooksSendRequestAndRecieveResponse.sendGetRequest(URL);
        System.debug('response'+response);
        JsonParserQBItem qbItemResponse= new JsonParserQBItem();
        qbItemResponse=(JsonParserQBItem)JSON.deserialize(response, JsonParserQBItem.class);
        if(qbItemResponse.QueryResponse!=null){
            for(JsonParserQBItem.Item item:qbItemResponse.QueryResponse.Item ){
                QBOProdcutIdSet.add(item.Id);
            }
            for(Product2 p:[Select id, Name,QBO_Product_Id__c from Product2 where QBO_Product_Id__c IN:QBOProdcutIdSet]){
               mapOfProduct.put(p.QBO_Product_Id__c,p); 
            }
            for(JsonParserQBItem.Item item:qbItemResponse.QueryResponse.Item ){
                Product2 pr;
                if(mapOfProduct.get(item.Id)!=null){
                    pr=mapOfProduct.get(item.Id);
                }else{
                    pr= new Product2();
                }
                pr.Name=item.Name;
                pr.Family=item.Type;
                pr.Description=item.Description;
                pr.QBO_Product_Id__c=item.Id;
                listofProducts.add(pr);
            }
            if(!listofProducts.isEmpty()){
                Database.upsert(listofProducts);
            }
        }
    }
}