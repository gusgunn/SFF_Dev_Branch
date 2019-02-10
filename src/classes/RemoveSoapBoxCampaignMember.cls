global class RemoveSoapBoxCampaignMember implements Database.Batchable<sObject>
{   
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
		RecordType rt2 = [select Id,RecordType.name from RecordType where name='Soapbox Registration' and sObjectType='CampaignMember'];
        
        String Query = 'Select Id,RecordTypeId,Status from CampaignMember where RecordTypeId=\''+rt2.Id+'\' or Status =\'\'';
        System.debug('qXX'+Query);
        return Database.getQueryLocator(Query);
    }
    
    global void execute(Database.BatchableContext BC,list<CampaignMember> scope)
    {
        Delete scope;
    
    }

    global void finish(Database.BatchableContext BC)    
    {
    }

}