@isTest
global class QBOMockGenerator implements HttpCalloutMock{
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res;
        if(req.getEndpoint().contains('Customer') && req.getMethod()=='GET'){
            res = new HttpResponse();
           res.setBody('{"QueryResponse": {"Customer": [{"Taxable": true,"BillAddr": {"Id": "2","Line1": "4581 Finch St.","City": "Bayshore","CountrySubDivisionCode": "CA","PostalCode": "94326","Lat": "INVALID","Long": "INVALID"},"Id": "1","SyncToken": "0","MetaData": { "CreateTime": "2016-03-03T16:48:43-08:00", "LastUpdatedTime": "2016-05-09T03:30:22-07:00"},"GivenName": "Amy","FamilyName": "Lauterbach","FullyQualifiedName": "Amy","CompanyName": "Amy","DisplayName": "Amy","PrintOnCheckName": "Amy","Active": true,"PrimaryPhone": {"FreeFormNumber": "(650) 555-3311"},"PrimaryEmailAddr": {"Address": "Birds@Intuit.com"}}]}}'); 
        }
        if(req.getEndpoint().contains('Invoice') && req.getMethod()=='GET'){
             res = new HttpResponse();
            res.setBody('{"QueryResponse": {"Invoice": [{"Id": "145","SyncToken": "0","MetaData": {"CreateTime": "2016-05-09T03:30:21-07:00","LastUpdatedTime": "2016-05-09T03:30:21-07:00"},"CustomField": [{ "DefinitionId": "1","Name": "Crew #","Type": "StringType"}],"DocNumber": "1038","TxnDate": "2016-05-09","CurrencyRef": {"value": "USD","name": "United States Dollar"},"LinkedTxn": [],"Line": [{"Id": "1","LineNum": 1,"Description": "test invoice","Amount": 1.0,"DetailType": "SalesItemLineDetail","SalesItemLineDetail": {"ItemRef": {"value": "3","name": "Concrete"},"UnitPrice": 1,"Qty": 1,"TaxCodeRef": {"value": "NON"}}},{"Id": "2","LineNum": 2,"Description": "test invoice","Amount": 1.0,"DetailType": "SalesItemLineDetail","SalesItemLineDetail": {"ItemRef": {"value": "3","name": "Concrete"},"UnitPrice": 1,"Qty": 1,"TaxCodeRef": {"value": "NON"}}},{"Amount": 2.0,"DetailType": "SubTotalLineDetail","SubTotalLineDetail": {}}],"TxnTaxDetail": {"TotalTax": 0},"CustomerRef": {"value": "1","name": "Amy"},"DueDate": "2016-06-08","TotalAmt": 2.0}],"startPosition": 1,"maxResults": 1,"totalCount": 1},"time": "2016-05-16T02:45:08.963-07:00"}	');
        }
        if(req.getEndpoint().contains('Payment') && req.getMethod()=='GET'){
             res = new HttpResponse();
            res.setBody('{"QueryResponse": {"Payment": [{"CustomerRef": {"value": "8","name": "Freeman Sporting Goods:0969 Ocean View Road"},"DepositToAccountRef": {"value": "4"},"TotalAmt": 387.0,"UnappliedAmt": 0,"ProcessPayment": false,"domain": "QBO","Id": "128","SyncToken": "0","MetaData": {"CreateTime": "2016-03-11T13:13:33-08:00","LastUpdatedTime": "2016-03-11T13:13:33-08:00"},"TxnDate": "2016-03-11","CurrencyRef": {"value": "USD","name": "United States Dollar"},"Line": [{"Amount": 387.0,"LinkedTxn": [{"TxnId": "96","TxnType": "Invoice"}]}]}],"startPosition": 1,"maxResults": 1},"time": "2016-05-16T04:51:50.915-07:00"}');
        }
         if(req.getEndpoint().contains('PaymentMethod') && req.getMethod()=='GET'){
             res = new HttpResponse();
            res.setBody('{"QueryResponse": {"PaymentMethod": [{"Name": "American Express","Active": true,"Type": "CREDIT_CARD","domain": "QBO","sparse": false,"Id": "6","SyncToken": "0","MetaData": {"CreateTime": "2016-03-03T14:42:05-08:00","LastUpdatedTime": "2016-03-03T14:42:05-08:00"}}],"startPosition": 1,"maxResults": 1},"time": "2016-05-16T05:16:56.867-07:00"}');
        }
        if(req.getEndpoint().contains('TaxRate') && req.getMethod()=='GET'){
             res = new HttpResponse();
            res.setBody('{"QueryResponse": {"TaxRate": [{"Name": "Agecy 2-Adjustments to tax on sales","Description": "Adjustment","Active": true,"AgencyRef": {"value": "5"},"TaxReturnLineRef": {"value": "48"},"SpecialTaxType": "ADJUSTMENT_RATE","DisplayType": "HideInAll","domain": "QBO","sparse": false,"Id": "12","SyncToken": "0","MetaData": {"CreateTime": "2016-05-10T06:30:51-07:00","LastUpdatedTime": "2016-05-10T06:30:51-07:00"}}],"startPosition": 1,"maxResults": 1,"totalCount": 1},"time": "2016-05-16T05:20:44.878-07:00"}');
        }
        if(req.getEndpoint().contains('TaxCode') && req.getMethod()=='GET'){
             res = new HttpResponse();
            res.setBody('{"QueryResponse": {"TaxCode": [{"Name": "California","Description": "California","Active": true,"Taxable": true,"TaxGroup": true,"SalesTaxRateList": {"TaxRateDetail": [{"TaxRateRef": {"value": "3","name": "California"},"TaxTypeApplicable": "TaxOnAmount","TaxOrder": 0}]},"PurchaseTaxRateList": {"TaxRateDetail": []},"SyncToken": "0","MetaData": {"CreateTime": "2016-03-10T12:17:04-08:00","LastUpdatedTime": "2016-03-10T12:17:04-08:00"}}],"startPosition": 1,"maxResults": 4,"totalCount": 4},"time": "2016-05-16T05:36:51.76-07:00"}');
        }
         if(req.getEndpoint().contains('Term') && req.getMethod()=='GET'){
             res = new HttpResponse();
            res.setBody('{"QueryResponse": {"Term": [{"Name": "Due on receipt","Active": true,"Type": "STANDARD","DiscountPercent": 0,"DueDays": 0,"DiscountDays": 0,"domain": "QBO","sparse": false,"Id": "1","SyncToken": "0","MetaData": {"CreateTime": "2016-03-03T14:41:49-08:00","LastUpdatedTime": "2016-03-03T14:41:49-08:00"}}],"startPosition": 1,"maxResults": 1},"time": "2016-05-16T05:43:30.941-07:00"}');
        }
         if(req.getEndpoint().contains('Item') && req.getMethod()=='GET'){
             res = new HttpResponse();
            res.setBody('{"QueryResponse": {"Item": [{"Name": "Concrete","Description": "Concrete for fountain installation","Active": true,"FullyQualifiedName": "Concrete","Taxable": true,"UnitPrice": 0,"Type": "Service","Id": "3","SyncToken": "1","MetaData": {"CreateTime": "2016-03-08T10:36:03-08:00","LastUpdatedTime": "2016-03-11T12:47:47-08:00"}}],"startPosition": 1,"maxResults": 1},"time": "2016-05-16T05:47:35.517-07:00"}');
        }
        return res;
    }
}