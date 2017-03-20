@isTest
public class Test_QBOSyncObjects {
    @testSetup
    static void allTheDataForThisTestClass() {
        List<QB_Sync_Date__c> lstCustomSeting= new List<QB_Sync_Date__c>();
        QB_Sync_Date__c qboCustomSetting= new QB_Sync_Date__c();
        qboCustomSetting.Name='QBOLastSync';
        lstCustomSeting.add(qboCustomSetting);
        QB_Sync_Date__c qboCustomSetting1= new QB_Sync_Date__c();
        qboCustomSetting1.Name='QBOCoMObjSyncDate';
        lstCustomSeting.add(qboCustomSetting1);
        insert lstCustomSeting;
         QBO_OAuthService__c service = new QBO_OAuthService__c();
        service.Name='OAuthServiceName';
        service.QBO_Access_Token_URL__c='https://oauth.intuit.com/oauth/v1/get_access_token';
        service.QBO_Application_Token__c='02de095eb826ab47b0b9cf1b004911e4c297';
        service.QBO_Authorization_URL__c='https://appcenter.intuit.com/Connect/Begin';
        service.QBO_Consumer_Key__c='qyprdqfb1ASlWDBaaHVPefZEuylmtO';
        service.QBO_Consumer_Secret__c='8dSEELSMbwx6L2OiH1Kon62Z5hmsqQXR7MArzuOX';
        service.QBO_Request_Token_URL__c='https://oauth.intuit.com/oauth/v1/get_request_token';
        insert service;  
        
        QBO_OAuth_Token__c oauthToken= new QBO_OAuth_Token__c();
        oauthToken.QBO_Is_Access__c=true;
        oauthToken.QBOAuthService__c=service.Id;
        oauthToken.QBO_Token__c=EncodingUtil.urlEncode('dniw', 'UTF-8');
        oauthToken.QBO_Secret__c='qw';
        insert oauthToken;
        Account acc= new Account();
        acc.Name='test';
        acc.QBO_Sync_With_Quickbooks__c=true;
        insert acc;
        Product2 pr= new Product2();
        pr.name='TestProduct';
        insert pr;
        QBO_Invoice__c invoice= new QBO_Invoice__c();
        invoice.QBO_Invoice_Date__c=Date.today();
        invoice.QBO_Invoice_Due_Date__c=Date.today()+5;
        invoice.QBO_Customer__c=acc.Id;
        insert invoice;
        QBO_Invoice_Line_Item__c linitem= new QBO_Invoice_Line_Item__c();
        linitem.QBO_Product__c=pr.Id;
        linitem.QBO_Line_Description__c='Test';
        linitem.QBO_Quantity__c=1.0;
        linitem.QBO_Unit_Price__c=1.0;
        linitem.QBO_Invoice__c=invoice.Id;
        insert linitem;
    }
    public static testMethod void unitTest1(){
        Test.setMock(HttpCalloutMock.class, new QBOMockGenerator());
        QBOSyncObjects.syncCustomers();
        QBOSyncObjects.syncInvoicesAndLineItems();
        QBOSyncObjects.syncPayments();
        QBSyncCommonObjects.syncPaymentMethodReference();
        QBSyncCommonObjects.syncProductsQB();
        QBSyncCommonObjects.syncQBTaxRate();
        QBSyncCommonObjects.syncTaxCode();
        QBSyncCommonObjects.syncTerms();
    }
    public static testMethod void unitTest2(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new QBOMockGenerator());
        Account acc= new Account();
        acc.Name='test Account';
        acc.QBO_Sync_With_Quickbooks__c=true;
        insert acc;
        
        Account a=[Select id, QBO_Customer_Email__c from Account where Name='test'];
        a.QBO_Customer_Email__c='avd@dus.com';
        update a;
        Test.stopTest();
    }
    public static testMethod void unitTest3(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new QBOMockGenerator());
        Account a=[Select id, QBO_Customer_Email__c from Account where Name='test'];
        a.QBO_Customer_Email__c='avd@dus.com';
        update a;
        Test.stopTest();
    }
    public static testMethod void unitTest4(){
        Test.startTest();
        QBO_Invoice__c invoice=[Select id,QBO_Status__c from QBO_Invoice__c limit 1];
        invoice.QBO_Status__c='Issued';
        update invoice;
        Test.stopTest();
    }
    public static testMethod void unitTest5(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new QBOMockGenerator());
        QuickbooksSendRequestAndRecieveResponse.SendRequest('requestbody', 'Invoice', 'POST');     
        Test.stopTest();
    }
    public static testMethod void unitTest6(){
        Test.setMock(HttpCalloutMock.class, new QBOMockGenerator());
        QB_Sync_Date__c qbsync=[Select id, Name, Value__c from QB_Sync_Date__c where Name='QBOLastSync'];
        qbsync.value__c=date.today();
        update qbsync;
        QB_Sync_Date__c qbsync1=[Select id, Name, Value__c from QB_Sync_Date__c where Name='QBOCoMObjSyncDate'];
        qbsync1.value__c=date.today();
        update qbsync1;
        
        QBOSyncObjects.syncCustomers();
        QBOSyncObjects.syncInvoicesAndLineItems();
        QBOSyncObjects.syncPayments();
        QBSyncCommonObjects.syncPaymentMethodReference();
        QBSyncCommonObjects.syncProductsQB();
        QBSyncCommonObjects.syncQBTaxRate();
        QBSyncCommonObjects.syncTaxCode();
        QBSyncCommonObjects.syncTerms();
        QuickBooksConnector qb= new QuickBooksConnector();
        qb.urlEncode('abd');
    }
}