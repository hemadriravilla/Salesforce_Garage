public class JsonParserBatchInvoiceResponse {
    public JsonParserBatchInvoiceResponse(){
        
    }
public list<BatchItemResponse> BatchItemResponse;
public QueryResponse QueryResponse;
		//public String timeat;
	public class TxnTaxDetail{
		public Decimal TotalTax;
		public TxnTaxCodeRef TxnTaxCodeRef;
		public list<TaxLine> TaxLine;
	}
	public class TxnTaxCodeRef{
		public String value;
	}
	public class TaxRateRef{
		public String value;
	}
	public class TaxLineDetail{
		public TaxRateRef TaxRateRef;
		public Boolean PercentBased;
		public Decimal NetAmountTaxable;
		public Decimal TaxPercent;
	}
	public class TaxLine{
		public String DetailType;
		public Decimal Amount;
		public TaxLineDetail TaxLineDetail;
	}
	public class TaxCodeRef{
		public String value;
	}
	public class SalesTermRef{
		public String value;
	}
	public class SalesItemLineDetail{
		public TaxCodeRef TaxCodeRef;
		public Decimal Qty;
		public Decimal UnitPrice;
		public ItemRef ItemRef;
	}
	public class QueryResponse{
		public list<Invoice> Invoice;
		public Integer startPosition;
		public Integer maxResults;
		public Integer totalCount;
	}
	public class MetaData{
		public String LastUpdatedTime;
		public String CreateTime;
	}
	public class Line{
		public SalesItemLineDetail SalesItemLineDetail;
		public Integer LineNum;
		public String Description;
		public String Id;
		public Decimal Amount;
		public String DetailType;
	}
	public class ItemRef{
		public String name;
		public String value;
	}
	public class Invoice{
		//public list<String> LinkedTxn;
		public String TxnDate;
		public CurrencyRef CurrencyRef;
		public String DocNumber;
		public list<Line> Line;
	   // public list<CustomField> CustomField;
		public TxnTaxDetail TxnTaxDetail;
		public MetaData MetaData;
		public CustomerRef CustomerRef;
		public String SyncToken;
		public CustomerMemo CustomerMemo;
		public String Id;
		public SalesTermRef SalesTermRef;
		public Boolean sparse;
		public String DueDate;
		public String domain;
		public Decimal TotalAmt;
		public Boolean AllowOnlineACHPayment;
		public Boolean ApplyTaxAfterDiscount;
		public Boolean AllowOnlineCreditCardPayment;
		public String PrintStatus;
		public Boolean AllowOnlinePayment;
		public String EmailStatus;
		public Boolean AllowIPNPayment;
		public Decimal Balance;
		public Decimal Deposit;
	}
	/*public class CustomField{
		public String Type;
		public String Name;
		public String DefinitionId;
        public String StringValue;
        
    }*/
	public class CustomerRef{
		public String value;
		public String name;
	}
	public class CustomerMemo{
		public String value;
	}
	public class CurrencyRef{
		public String value;
		public String name;
	}
    public class BatchItemResponse{
		public Invoice Invoice;
		public String bId;
	}
}