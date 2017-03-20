public class JsonParserTaxCode{
public JsonParserTaxCode(){
}
        public QueryResponse QueryResponse; 
    public class TaxRateRef{
        public String name;
        public String value;
    }
    public class TaxRateDetail{
        public TaxRateRef TaxRateRef;
        public Integer TaxOrder;
        public String TaxTypeApplicable;
    }
    public class TaxCode{
        public PurchaseTaxRateList PurchaseTaxRateList;
        public String Id;
        public String SyncToken;
        public Boolean sparse;
        public SalesTaxRateList SalesTaxRateList;
        public String domain;
        public Boolean Taxable;
        public Boolean Active;
        public Boolean TaxGroup;
        public String Description;
        public MetaData MetaData;
        public String Name;
    }
    public class SalesTaxRateList{
        public list<TaxRateDetail> TaxRateDetail;
    }
    public class QueryResponse{
        public Integer maxResults;
        public Integer startPosition;
        public Integer totalCount;
        public list<TaxCode> TaxCode;
    }
    public class PurchaseTaxRateList{
        public list<String> TaxRateDetail;
    }
    public class MetaData{
        public String CreateTime;
        public String LastUpdatedTime;
    }
}