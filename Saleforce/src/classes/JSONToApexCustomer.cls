public class JSONToApexCustomer {
    public JSONToApexCustomer(){
        
    }
    public list<BatchItemRequest> BatchItemRequest;
    public Class Customer{
    public BillAddr BillAddr;
    public String Notes;
    public String Title;
    public String GivenName;
    public String MiddleName;
    public String FamilyName;
    public String Suffix;
    public String FullyQualifiedName;
    public String CompanyName;
    public String DisplayName;
    public PrimaryPhone PrimaryPhone;
    public PrimaryEmailAddr PrimaryEmailAddr;
    public transient String syncToken;
    }

 public Class BillAddr {
        public String Line1;
        public String City;
        public String Country;
        public String CountrySubDivisionCode;
        public String PostalCode;
    }
    public Class PrimaryPhone {
        public String FreeFormNumber;
    }

    public Class PrimaryEmailAddr {
        public String Address;
    }
  public class BatchItemRequest{
        public Customer Customer;
        public String operation;
        public String bId;
    }
    
}