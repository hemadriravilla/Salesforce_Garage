public class QuickBooksUtilityClass {
    

    public static HttpRequest sign(HttpRequest req){
        QBO_OAuth_Token__c oaToken;
        QBO_OAuthService__c service=getServiceObject();
        String tokenSecret;
        system.debug('Service Token::::::'+service.QBOOAuth_Token__r);
         if(service != NULL && ! service.QBOOAuth_Token__r.isEmpty()) {
          oaToken = new QBO_OAuth_Token__c();
          oaToken = service.QBOOAuth_Token__r[0];
           tokenSecret = oaToken.QBO_Secret__c;  
        }
         String consumerSecret = service.QBO_Consumer_Secret__c;
        // String tokenSecret = oaToken.Secret__c;  
            
        Map<String, String> parameters = new Map<String, String>();
        String nonce = String.valueOf(Crypto.getRandomLong());
        String timestamp = String.valueOf(DateTime.now().getTime() / 1000);
        
        
        parameters.put('oauth_consumer_key', service.QBO_Consumer_Key__c);
        parameters.put('oauth_nonce', nonce);
        parameters.put('oauth_signature_method', 'HMAC-SHA1');
        parameters.put('oauth_timestamp', timestamp);
        parameters.put('oauth_token', EncodingUtil.urlEncode(oaToken.QBO_Token__c, 'UTF-8'));
        parameters.put('oauth_version', '1.0');
 
        String signature = generateSignature(req, consumerSecret, tokenSecret, parameters);
        String header = generateHeader(signature, parameters);
        req.setHeader('Authorization', header);
        req.setHeader('Accept', 'application/json');
 
       return req;
    }
    
     private static String generateSignature(HttpRequest req, String consumerSecret, String tokenSecret, Map<String,String> parameters) {
        String s 	= createBaseString(req, parameters);        
        String key  = EncodingUtil.urlEncode(consumerSecret, 'UTF-8') + '&' + EncodingUtil.urlEncode(tokenSecret, 'UTF-8');
 
        Blob sig = Crypto.generateMac(
           'HmacSHA1'
          , Blob.valueOf(s)
          , Blob.valueOf(key)
        );
        return EncodingUtil.urlEncode( EncodingUtil.base64encode(sig), 'UTF-8');
    }
    
     private static String generateHeader(String signature, Map<String,String> parameters) {
        String header = 'OAuth ';
        for (String key : parameters.keySet()) {
            header = header + key + '="'+parameters.get(key)+'", ';
        }
        return header + 'oauth_signature="' + signature + '"';
    }
     private static String createBaseString(HttpRequest req, Map<String,String> parameters) {
        Map<String,String> p = parameters.clone();
        String host = req.getEndpoint();
        Integer n = host.indexOf('?');
        if(n>-1) {
            p.putAll(getUrlParams(host.substring(n+1)));
            host = host.substring(0,n);
        }
        List<String> keys = new List<String>();
        keys.addAll(p.keySet());
        keys.sort();
        String s = keys.get(0)+'='+p.get(keys.get(0));
        for(Integer i=1;i<keys.size();i++) {
            s = s + '&' + keys.get(i)+'='+p.get(keys.get(i));
        }
 
        return req.getMethod().toUpperCase()+ '&' +
            EncodingUtil.urlEncode(host, 'UTF-8') + '&' +
            EncodingUtil.urlEncode(s, 'UTF-8');
    }
     private static Map<String,String> getUrlParams(String value) {
        Map<String,String> res = new Map<String,String>();
        if(value==null || value=='') {
            return res;
        }
        for(String s : value.split('&')) {
            System.debug('getUrlParams: '+s);
            List<String> kv = s.split('=');
            if(kv.size()>1) {
                System.debug('getUrlParams: -> '+kv[0]+','+kv[1]);
                res.put(kv[0],kv[1]);
            }
        }
        return res;
    }
    private static QBO_OAuthService__c getServiceObject(){
        QBO_OAuthService__c service = [
                SELECT QBO_Request_Token_URL__c, QBO_Access_Token_URL__c, QBO_Consumer_Key__c, QBO_Consumer_Secret__c,
                    QBO_Authorization_URL__c, QBO_Application_Token__c,
                    (SELECT QBO_Token__c, QBO_Secret__c, QBO_Is_Access__c, QBO_Realm_Id__c
                    FROM QBOOAuth_Token__r
                    WHERE QBO_Is_Access__c=true Order by CreatedDate DESC)
                FROM QBO_OAuthService__c
                order by lastModifiedDate LIMIT 1];
        system.debug('Service Token::::::'+service.QBOOAuth_Token__r);
        return service;
    }
}