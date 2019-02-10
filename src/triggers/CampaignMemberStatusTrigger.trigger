///Summary      : This Trigger is used to set Campaign member statuses.
///Author       :   Prakash Nawale
//Created On    :   12/05/2014
//LastModifed By:

trigger CampaignMemberStatusTrigger on Campaign (after insert , after update) {
    TriggerConfiguration__c triggerConfiguration = TriggerConfiguration__c.getInstance('CampaignMemberStatusTrigger');
    if( triggerConfiguration != null && triggerConfiguration.IsActive__c )
     if(Trigger.isInsert && Trigger.isAfter)
            CampaignMemberStatuses.setCampaignMebersStatus(Trigger.New,null); 
     if(Trigger.isUpdate && Trigger.isAfter)
            CampaignMemberStatuses.setCampaignMebersStatus(Trigger.New,Trigger.oldMap); 
}