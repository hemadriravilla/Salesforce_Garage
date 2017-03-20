public class JSONToQBPaymentParser {
public JSONToQBPaymentParser(){
}
public QueryResponse QueryResponse;
    public class value{
        public String Value;
        public String Name;
    }
    public class QueryResponse{
        public list<Payment> Payment;
        public Integer maxResults;
        public Integer startPosition;
    }
    public class Payment{
        public MetaData MetaData;
        public Boolean sparse;
        public String domain;
        public String Id;
        public Boolean ProcessPayment;
        public String PaymentRefNum;
        public String SyncToken;
        public Integer UnappliedAmt;
        public String TxnDate;
        public Decimal TotalAmt;
        public CurrencyRef CurrencyRef;
        public PaymentMethodRef PaymentMethodRef;
        public DepositToAccountRef DepositToAccountRef;
        public list<Line> Line;
        public CustomerRef CustomerRef;
    }
    public class PaymentMethodRef{
        public String value;
    }
    public class MetaData{
        public String LastUpdatedTime;
        public String CreateTime;
    }
    public class LinkedTxn{
        public String TxnId;
        public String TxnType;
    }
    
    public class Line{
        public Decimal Amount;
        public list<LinkedTxn> LinkedTxn;
    }
    public class DepositToAccountRef{
        public String value;
    }
    public class CustomerRef{
        public String name;
        public String value;
    }
    public class CurrencyRef{
        public String name;
        public String value;
    }
}