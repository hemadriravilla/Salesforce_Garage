global class QBSyncCommonObjectsScheduler implements Schedulable{
    global void execute(SchedulableContext SC){
        QBSyncCommonObjects.syncQBTaxRate();
        QBSyncCommonObjects.syncTaxCode();
        QBSyncCommonObjects.syncTerms();
        QBSyncCommonObjects.syncPaymentMethodReference();
    }
}