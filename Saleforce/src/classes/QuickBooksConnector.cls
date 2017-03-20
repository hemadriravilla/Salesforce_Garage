public with sharing class QuickBooksConnector {
  public QBO_OAuthService__c service { get; set; }
    public QBO_OAuth_Token__c oaToken { get; set; }
    
    public String token;
    public String tokenSecret;
    public String verifier;
    
    public String nonce;
    public String timestamp;
    public String signature;
    public String consumerKey;
    public String consumerSecret;
    
    public String callbackUrl;
       
    public Map<String, String> parameters = new Map<String, String>();
    
    public QuickBooksConnector() {
        service = [
                SELECT QBO_Request_Token_URL__c, QBO_Access_Token_URL__c, QBO_Consumer_Key__c, QBO_Consumer_Secret__c,
                    QBO_Authorization_URL__c, QBO_Application_Token__c,
                    (SELECT QBO_Token__c, QBO_Secret__c, QBO_Is_Access__c, QBO_Realm_Id__c
                    FROM QBOOAuth_Token__r
                    WHERE QBO_Owner__c = :UserInfo.getUserId()  Order by CreatedDate DESC)
                FROM QBO_OAuthService__c
                order by lastModifiedDate LIMIT 1];
        system.debug('Service Token::::::'+service.QBOOAuth_Token__r);
        if(service != NULL && ! service.QBOOAuth_Token__r.isEmpty()) {
          oaToken = new QBO_OAuth_Token__c();
          oaToken = service.QBOOAuth_Token__r[0];
          system.debug('==oaToken==>>'+oaToken);
        }
    }
     public Boolean completeAuthorization(String p_Token, String p_Verifier, String p_RealmId) {
        oaToken = NULL;
        
        try {
            oaToken = [
                    SELECT QBOAuthService__r.Name, QBOAuthService__r.QBO_Access_Token_URL__c,
                        QBOAuthService__r.QBO_Consumer_Key__c, QBOAuthService__r.QBO_Consumer_Secret__c,
                        QBO_Token__c, QBO_Secret__c, QBO_Is_Access__c, QBO_Realm_Id__c
                    FROM QBO_OAuth_Token__c WHERE QBO_Owner__c = :UserInfo.getUserId()
                    AND QBO_Token__c = :EncodingUtil.urlEncode(p_Token, 'UTF-8')
                    AND QBO_Is_Access__c = false];
        
        } catch(System.QueryException e) {
            return false;
        }
        
        consumerKey = oaToken.QBOAuthService__r.QBO_Consumer_Key__c;
        consumerSecret = oaToken.QBOAuthService__r.QBO_Consumer_Secret__c;
        
        this.token = oaToken.QBO_Token__c;
        tokenSecret = oaToken.QBO_Secret__c;
        
        if(p_Verifier != NULL) {
            this.verifier = EncodingUtil.urlEncode(p_Verifier, 'UTF-8');
        }
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(oaToken.QBOAuthService__r.QBO_Access_Token_URL__c);
        req.setBody('');
        
        sign(req);
        
        HttpResponse res = NULL;
        
        if(Test.isRunningTest()) {
            res = new HttpResponse();
        } else {
            res = h.send(req);
        }
        
        System.debug('::::: Response from request token request: (' + res.getStatusCode() + ')' + res.getBody());
        
        if(res.getStatusCode() > 299) {
            return false;
        }
        
        String resParams = (Test.isRunningTest() ?
            'oauth_token=token&oauth_token_secret=token_secret' :
            res.getBody());
        
        Map<String, String> rp = new Map<String, String>();
        for(String s : resParams.split('&')) {
            List<String> kv = s.split('=');
            rp.put(kv[0], kv[1]);
        }
        
        oaToken.QBO_Token__c = rp.get('oauth_token');
        oaToken.QBO_Secret__c = rp.get('oauth_token_secret');
        oaToken.QBO_Realm_Id__c = p_RealmId;
        oaToken.QBO_Is_Access__c = true;
        
        Database.update(oaToken);
        
        return true;
    }
 public void sign(HttpRequest req) {
        nonce = String.valueOf(Crypto.getRandomLong());
        timestamp = String.valueOf(DateTime.now().getTime() / 1000);
        
        refreshParameters();
        
        String s = createBaseString(parameters, req);
        
        Blob sig = Crypto.generateMac('HmacSHA1', Blob.valueOf(s), Blob.valueOf(consumerSecret + '&' +
            (tokenSecret != NULL ? tokenSecret : '')));
        
        signature = EncodingUtil.urlEncode(EncodingUtil.base64encode(sig), 'UTF-8');
        
        String header = 'OAuth ';
        for(String key : parameters.keySet()) {
            header = header + key + '="' + parameters.get(key) + '", ';
        }
        
        header = header + 'oauth_signature="' + signature + '"';
        
        System.debug('::::: header = ' + header);
        
        req.setHeader('Authorization', header);
    }
     private void refreshParameters() {
        parameters.clear();
        parameters.put('oauth_consumer_key', consumerKey);
        
        if(token != NULL) {
            parameters.put('oauth_token', token);
        }
        
        if(verifier != NULL) {
            parameters.put('oauth_verifier', verifier);
        }
        
        if(callbackUrl != NULL) {
            parameters.put('oauth_callback', callbackUrl);
        }
        
        parameters.put('oauth_signature_method', 'HMAC-SHA1');
        parameters.put('oauth_timestamp', timestamp);
        parameters.put('oauth_nonce', nonce);
        parameters.put('oauth_version', '1.0');
        parameters.put('Host','qbo.intuit.com');
       // parameters.put('X-NewRelic-ID','UQMAU15RGwEFXVFUBQE=');
       // parameters.put('X-NewRelic-Transaction','PxQOI1BaCnEFJlNadgYAVCEDFB8EBw8RVT8=');
        parameters.put('Connection','Keep-Alive');
    }
      private String createBaseString(Map<String,String> oauthParams, HttpRequest req) {
        Map<String,String> p = oauthParams.clone();
        
       // if(req.getMethod().equalsIgnoreCase('post') && req.getBody() != NULL &&
           // req.getHeader('Content-Type') == 'application/x-www-form-urlencoded') {
            
            p.putAll(getUrlParams(req.getBody()));
           
        //}
        
        String host = req.getEndpoint();
        Integer n = host.indexOf('?');
        
        if(n > -1) {
            p.putAll(getUrlParams(host.substring(n + 1)));
            host = host.substring(0, n);
        }
        
        List<String> keys = new List<String>();
        keys.addAll(p.keySet());
        keys.sort();
        
        String s = (keys.get(0) != 'status' ?
            EncodingUtil.urlEncode(keys.get(0) + '=' + p.get(keys.get(0)), 'UTF-8') :
            urlEncode(keys.get(0) + '=' + p.get(keys.get(0))));
            
        for(Integer i = 1; i < keys.size(); i++) {
            if(keys.get(i) != 'status') {
                s += EncodingUtil.urlEncode('&' + keys.get(i) + '=' + p.get(keys.get(i)), 'UTF-8');
            } else {
                s += EncodingUtil.urlEncode('&', 'UTF-8');
                s += urlEncode(keys.get(i) + '=' + p.get(keys.get(i)));
            }
        }
        
        return req.getMethod().toUpperCase() + '&' + EncodingUtil.urlEncode(host, 'UTF-8') + '&' + s;
    }
     private Map<String, String> getUrlParams(String value) {
        Map<String, String> res = new Map<String, String>();
        
        if(value == NULL || value.trim() == '') {
            return res;
        }
        
        for(String s : value.split('&')) {
            List<String> kv = s.split('=');
            if(kv.size() > 1) {
                res.put(kv[0], kv[1]);
            }
        }
        
        return res;
    }
       @TestVisible private String urlEncode(String unencodedString) {
        String returnVal = NULL;
        
        if(unencodedString != NULL) {
            returnVal = '';
            
            for(Integer i = 0; i < unencodedString.length(); i++) {
                String c = charAt(unencodedString, i);
                
                if(' '.equals(c)) {
                    returnVal += '%20';
                } else {
                    returnVal += EncodingUtil.urlEncode(c, 'UTF-8');
                }
            }
        }
        
        return returnVal;
    }
     private String charAt(String str, Integer index) {
        if(str == NULL) {
            return NULL;
        }
        
        if(str.length() <= 0) {
            return str;
        }
        
        if(index < 0 || index >= str.length()){
            return null;
        }
        
        return str.substring(index, index + 1);
    }
     public PageReference authorize() {
        if(service == NULL) {
            return NULL;
        }
        
        // Use 'oob' when you do not have a callback url
        //callbackUrl =
         //   EncodingUtil.urlEncode('http://' + ApexPages.currentPage().getHeaders().get('Host') +
           //     '/QuickBooksLogin', 'UTF-8');
        callbackUrl=EncodingUtil.urlEncode('https://na34.salesforce.com/apex/QuickBooksLogin','UTF-8');
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(service.QBO_Request_Token_URL__c);
        
        consumerKey = service.QBO_Consumer_Key__c;
        consumerSecret = service.QBO_Consumer_Secret__c;
        
        sign(req);
        
        HttpResponse res = NULL;
        
        if(Test.isRunningTest()) {
            res = new HttpResponse();
        } else {
            res = h.send(req);
        }
        
        System.debug('::::: Response from request token request: (' + res.getStatusCode() + ')' + res.getBody());
        
        String resParams = (Test.isRunningTest() ?
            'oauth_token=token&oauth_token_secret=token_secret' :
            res.getBody());
        
        Map<String, String> rp = getUrlParams(resParams);
        
        oaToken = new QBO_OAuth_Token__c(
                QBO_Owner__c = UserInfo.getUserId(),
                QBOAuthService__c = service.Id,
                QBO_Token__c = rp.get('oauth_token'),
                QBO_Secret__c = rp.get('oauth_token_secret'),
                QBO_Is_Access__c = false);
        
        insert oaToken;
        
        String authorizePage = service.QBO_Authorization_URL__c + '?oauth_token=' +
            EncodingUtil.urlDecode(oaToken.QBO_Token__c, 'UTF-8') + '&oauth_consumer_key=' +
            service.QBO_Consumer_Key__c;
        
        return new PageReference(authorizePage);
    }
   
}