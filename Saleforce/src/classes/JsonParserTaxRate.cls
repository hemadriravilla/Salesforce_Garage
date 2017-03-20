public class JsonParserTaxRate{
 public JsonParserTaxRate(){
 }
    public QueryResponse QueryResponse;
    public class TaxRate{
        public String Id;
        public String SyncToken;
        public Boolean sparse;
        public String DisplayType;
        public String domain;
        public String SpecialTaxType;
        public MetaData MetaData;
        public AgencyRef AgencyRef;
        public Boolean Active;
        public String Description;
        public Decimal RateValue;
        public String Name;
    }
    public class QueryResponse{
        public list<TaxRate> TaxRate;
        public Integer maxResults;
        public Integer totalCount;
        public Integer startPosition;
    }
    public class MetaData{
        public String CreateTime;
        public String LastUpdatedTime;
    }
    public class AgencyRef{
        public String value;
    }
}