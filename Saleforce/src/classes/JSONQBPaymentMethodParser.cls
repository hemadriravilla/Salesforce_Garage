public class JSONQBPaymentMethodParser{
public JSONQBPaymentMethodParser(){
}
        public QueryResponse QueryResponse;
    
    public class QueryResponse{
        public Integer startPosition;
        public Integer maxResults;
        public list<PaymentMethod> PaymentMethod;
    }
    public class PaymentMethod{
        public String Id;
        public String domain;
        public Boolean sparse;
        public String Type;
        public String SyncToken;
        public Boolean Active;
        public MetaData MetaData;
        public String Name;
    }
    public class MetaData{
        public String CreateTime;
        public String LastUpdatedTime;
    }
}