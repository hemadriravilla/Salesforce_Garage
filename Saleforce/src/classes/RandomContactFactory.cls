public class RandomContactFactory{
    Integer count = [SELECT COUNT() FROM Contact];
    Integer rand = Math.floor(Math.random() * count).intValue();
    Set<Id> contactIds = new Set<Id>();{
        for(CampaignMember cm : [Select Id, ContactId from CampaignMember where Status = 'To be Called' and Campaign.Name = '2014/15 Mascot Data']){
            contactIds.add(cm.ContactId);
            List<String> orderBys = new List<String>{'Email Asc','Email Desc','Lastname Asc','Firstname Desc','LastModifiedDate Desc','LastModifiedDate Asc','CreatedDate Asc','CreatedDate Desc','Id Asc','Id Desc'};
            String orderBy = orderBys.get(Math.mod(rand,orderBys.size()));
            List<Contact> contacts = (List<Contact>)Database.query('Select Name From Contact where ID in :contactIds Order By ' + orderBy + ' Limit 5 OFFSET :rand');
        }
    }
}