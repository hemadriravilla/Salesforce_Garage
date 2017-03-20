public class JsonToQBInvoiceParser {
public JsonToQBInvoiceParser(){
}
public list<BatchItemRequest> BatchItemRequest;
    public class SalesItemLineDetail{
        public ItemRef ItemRef;
        public Integer Qty;
        public Decimal UnitPrice;
    }
    public class Line{
        public SalesItemLineDetail SalesItemLineDetail;
        public String DetailType;
        public Decimal Amount;
        public String Description;
    }
    public class ItemRef{
        public String name;
        public String value;
    }
    public class CustomerRef{
        public String value;
    }
    public class Invoice{
        
        public String TxnDate;
       
        public list<Line> Line;
       
        public CustomerRef CustomerRef;
        
        public Boolean sparse;
        public String DueDate;
        public String domain;
        public SalesTermRef SalesTermRef;
        
    }
    public class SalesTermRef{
        public String value;
    }
    public class BatchItemRequest{
        public Invoice Invoice;
        public String operation;
        public String bId;
    }
}