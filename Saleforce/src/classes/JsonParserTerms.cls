public class JsonParserTerms {
public JsonParserTerms(){
}
public QueryResponse QueryResponse;
    public class Term{
        public String SyncToken;
        public String Id;
        public String domain;
        public Integer DiscountDays;
        public Boolean sparse;
        public Integer DueDays;
        public MetaData MetaData;
        public Integer DiscountPercent;
        public Boolean Active;
        public String Type;
        public String Name;
    }
    public class QueryResponse{
        public list<Term> Term;
        public Integer maxResults;
        public Integer startPosition;
    }
    public class MetaData{
        public String CreateTime;
        public String LastUpdatedTime;
    }

}