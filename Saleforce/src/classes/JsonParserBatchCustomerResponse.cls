public class JsonParserBatchCustomerResponse{
public JsonParserBatchCustomerResponse(){
}
    public list<BatchItemResponse> BatchItemResponse;
    
       public QueryResponse QueryResponse;
    public class MetaData{
        public String CreateTime;
        public String LastUpdatedTime;
    }
    public class DefaultTaxCodeRef{
        public String value;
    }
    public class Customer{
        public String SyncToken;
        public Boolean sparse;
        public String Id;
        public String domain;
        public BillAddr BillAddr;
        public MetaData MetaData;
        public String PreferredDeliveryMethod;
        public String GivenName;
        public CurrencyRef CurrencyRef;
        public String FullyQualifiedName;
        public Decimal BalanceWithJobs;
        public String DisplayName;
        public Decimal Balance;
        public String PrintOnCheckName;
        public Boolean BillWithParent;
        public Boolean Active;
        public Boolean Job;
        public PrimaryPhone PrimaryPhone;
        public PrimaryEmailAddr PrimaryEmailAddr;
        public DefaultTaxCodeRef DefaultTaxCodeRef;
        public Boolean Taxable;
    }
    public class PrimaryPhone{
        public String FreeFormNumber;
    }
    public class PrimaryEmailAddr{
        public String Address;
    }
    public Class BillAddr {
        public String Line1;
        public String City;
        public String Country;
        public String CountrySubDivisionCode;
        public String PostalCode;
    }
    public class CurrencyRef{
        public String name;
        public String value;
    }
    public class BatchItemResponse{
        public Customer Customer;
        public String bId;
    }
    public class QueryResponse{
        public list<Customer> Customer;
        public Integer maxResults;
        public Integer startPosition;
    }
     
}