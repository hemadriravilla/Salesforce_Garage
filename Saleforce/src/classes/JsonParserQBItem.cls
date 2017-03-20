public class JsonParserQBItem{
public JsonParserQBItem(){
}
public QueryResponse QueryResponse;
    public class QueryResponse{
        public Integer startPosition;
        public Integer maxResults;
        public list<Item> Item;
    }
    public class MetaData{
        public String LastUpdatedTime;
        public String CreateTime;
    }
    public class Item{
        public String domain;
        public IncomeAccountRef IncomeAccountRef;
        public String Type;
        public Integer UnitPrice;
        public Boolean TrackQtyOnHand;
        public Boolean Taxable;
        public Boolean sparse;
        public String FullyQualifiedName;
        public String Id;
        public Boolean Active;
        public String SyncToken;
        public String Description;
        public MetaData MetaData;
        public String Name;
    }
    public class IncomeAccountRef{
        public String name;
        public String value;
    }
}