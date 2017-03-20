global class QBOSyncObjectsScheduler implements Schedulable{
    global void execute(SchedulableContext SC){
       string cronid;
       cronid=sc.getTriggerId();

CronTrigger scheduledjob=new CronTrigger(Id=cronid);
string value=[Select CronExpression From CronTrigger where id=:cronid limit 1].CronExpression;
List <string> value1 =value.split(' ');

system.abortJob(scheduledjob.Id); //abort scheduled job
Datetime sysTime = System.now();
integer minute=integer.valueof(value1[1]);
integer hour1=sysTime.hour();
if(integer.valueOf(value1[1])==45)
{
minute=0;
}
else
{
minute=minute+15;
}

String chron_exp = '' + sysTime.second() + ' ' + minute + ' 0-23 * * ?';
QBOSyncObjectsScheduler scheduler= new QBOSyncObjectsScheduler();
QBOSyncObjects.syncCustomers();
QBOSyncObjects.syncInvoicesAndLineItems();
QBOSyncObjects.syncPayments();        
string id=System.schedule('QBOSyncObjects Scheduler',chron_exp,scheduler);
    }
}