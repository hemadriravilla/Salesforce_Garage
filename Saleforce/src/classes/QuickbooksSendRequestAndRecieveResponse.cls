public class QuickbooksSendRequestAndRecieveResponse {
    private static String CompanyId;
    private static String Endpoint;
    public static string SendRequest(String requestbody, String ObjectType, String method){
        CompanyId=System.label.QBCompanyId;
        Endpoint=System.label.QBEndPoint;
        String responseBody;
        HttpResponse res;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod(method);
        req.setEndPoint(Endpoint+'/v3/company/'+CompanyId+'/'+ObjectType);
        req.setHeader('Content-Type', 'application/json');
        req = QuickBooksUtilityClass.sign(req);
        req.setBody(requestbody);
        
        if(!Test.isRunningTest()){
           res=h.send(req);
           responseBody=res.getbody(); 
        }else{
           responseBody=null; 
        }
        
        return responseBody;
        
    }
    public static String sendGetRequest(String URL){
         CompanyId=System.label.QBCompanyId;
        Endpoint=System.label.QBEndPoint;
        String responseBody;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setHeader('Authorization', 'OAuth '+UserInfo.getSessionId());
        req.setEndPoint(Endpoint+'/v3/company/'+CompanyId+'/'+'query?query='+URL);
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setHeader('Accept', 'application/json');
        req=QuickBooksUtilityClass.sign(req);
        HttpResponse res=h.send(req);
        responseBody=res.getbody();
        return responseBody;
    }
}