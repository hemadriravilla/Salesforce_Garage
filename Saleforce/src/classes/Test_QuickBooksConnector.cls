@isTest
public class Test_QuickBooksConnector {
    @testSetup
    static void allTheDataForThisTestClass() {
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
        oauthToken.QBO_Is_Access__c=false;
        oauthToken.QBOAuthService__c=service.Id;
        oauthToken.QBO_Token__c=EncodingUtil.urlEncode('dniw', 'UTF-8');
        insert oauthToken;
    }
    private static testMethod void unitTest1(){
     
        QuickBooksLoginController qbl =new QuickBooksLoginController();
        qbl.completeAuthorization();
        QuickBooksConnector qbConnector1 = new QuickBooksConnector();
        qbConnector1.consumerKey='1nwssdns';
        qbConnector1.consumerSecret='2i9ei9we0w';
        qbConnector1.verifier='nkio';
        qbConnector1.token='dniw';
        qbl.qbConnector=qbConnector1;
        qbConnector1.completeAuthorization('dniw', 'nkio','');
        qbConnector1.authorize();
    }
}