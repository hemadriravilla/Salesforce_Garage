trigger QBO_Invoice_Trigger on QBO_Invoice__c (after insert, after update) {
    Set<Id>setofInvoiceId= new Set<Id>();
     if(QBO_ConstantUtilityClass.createInvoicesInQBOExecuting==true)
            return;
    if((trigger.isInsert || trigger.isUpdate) && trigger.isAfter){
        for(QBO_Invoice__c qbInvoice:trigger.New){
            if(qbInvoice.QBO_Status__c=='Issued'){
                setofInvoiceId.add(qbInvoice.Id);
            }
        }
        if(!setofInvoiceId.isEmpty()){
            QBOInvoiceHandlerClass.createInvoicesInQBO(setofInvoiceId);
        }
    }
}