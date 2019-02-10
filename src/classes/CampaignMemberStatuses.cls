///Summary      : This class is called from CampaignMemberStatus.
///Author       :   Prakash Nawale
//Created On    :   12/05/2014
//LastModifed By:

public class CampaignMemberStatuses {
public Static void setCampaignMebersStatus(List<Campaign> lstCampaigns,map<Id, Campaign> oldMapCampaigns)
    { 
         Map<Id,Schema.Recordtypeinfo> mapRecordTypes = Campaign.SObjectType.getDescribe().getRecordTypeInfosByID();
         
         Map<String,String> mapCampaignMebersStatus = new Map<String,String>( );
         for(CampaignMemberstatuses__c campaignMembers :[ SELECT ID,Name,Record_Type__c,Campaign_Member_Status__c FROM CampaignMemberstatuses__c LIMIT 1000])          
            if(mapCampaignMebersStatus.containsKey(campaignMembers.Record_Type__c))              
                mapCampaignMebersStatus.put(campaignMembers.Record_Type__c, mapCampaignMebersStatus.get(campaignMembers.Record_Type__c)+',' + campaignMembers.Campaign_Member_Status__c);
            else
                mapCampaignMebersStatus.put(campaignMembers.Record_Type__c,campaignMembers.Campaign_Member_Status__c);
             
         List<CampaignMemberStatus> NewLstCampaignMemberStatus = new  List<CampaignMemberStatus>(); 
         
         Set<ID> setCampaignMemberStatusToDelete = new  Set<ID>();
         for(Campaign campaign :lstCampaigns)
         { 
            if(test.isRunningTest())            
                setCampaignMemberStatusToDelete.add(campaign.Id);
                    
             if( campaign.RecordTypeId != null && mapRecordTypes != null && mapCampaignMebersStatus != null && mapCampaignMebersStatus.get(mapRecordTypes.get(campaign.RecordTypeId).getName()) != 'master')
                {
                    if( oldMapCampaigns != null && oldMapCampaigns.get(campaign.id) != null )
                    {
                        if( oldMapCampaigns.get(campaign.id).RecordTypeId != campaign.RecordTypeId )
                        {
                            setCampaignMemberStatusToDelete.add(campaign.Id);
                            if( !mapCampaignMebersStatus.containsKey(mapRecordTypes.get(campaign.RecordTypeId).getName()))
                            {
                                NewLstCampaignMemberStatus.add(new CampaignMemberStatus(CampaignId = campaign.Id,Label = 'Sent',SortOrder = 1));
                                NewLstCampaignMemberStatus.add(new CampaignMemberStatus(CampaignId = campaign.Id,Label = 'Responded',SortOrder = 2));
                            }
                        }                       
                    }
                    else if( mapCampaignMebersStatus.containsKey(mapRecordTypes.get(campaign.RecordTypeId).getName()))
                    {
                        setCampaignMemberStatusToDelete.add(campaign.Id);
                    }
                    
                }
            Set<String> Statuses = new Set<String>();       
            Integer iSortOrder = 0;    
             List<string> lstMapCampaignMebersStatus = new List<String>();
             if(mapRecordTypes != null && mapRecordTypes.size() > 0 && mapCampaignMebersStatus != null && mapCampaignMebersStatus.size() >0 && campaign.RecordTypeId!= null && mapRecordTypes.get(campaign.RecordTypeId).getName() != null && mapCampaignMebersStatus.get(mapRecordTypes.get(campaign.RecordTypeId).getName()) != null )             
                 lstMapCampaignMebersStatus.addAll( mapCampaignMebersStatus.get(mapRecordTypes.get(campaign.RecordTypeId).getName()).split(';')); 
            if( oldMapCampaigns != null && oldMapCampaigns.get(campaign.id) != null )
            {
                 if( oldMapCampaigns.get(campaign.id).RecordTypeId != campaign.RecordTypeId )
                    for(string key : lstMapCampaignMebersStatus)                             
                        NewLstCampaignMemberStatus.add(new CampaignMemberStatus(CampaignId = campaign.Id,Label = key,SortOrder = iSortOrder++));  
            }
            else 
            {
              for(string key : lstMapCampaignMebersStatus)                             
                NewLstCampaignMemberStatus.add(new CampaignMemberStatus(CampaignId = campaign.Id,Label = key,SortOrder = iSortOrder++));   
            }           
         }
         
         List<CampaignMemberStatus> lstCampaignMemberStatusToDelete = new List<CampaignMemberStatus>();
         map<Id,CampaignMemberStatus> mapOldCapaignMemberStatus = new  map<Id,CampaignMemberStatus>([SELECT ID,IsDefault FROM  CampaignMemberStatus where CampaignId IN : setCampaignMemberStatusToDelete  ORDER BY IsDefault ASC LIMIT 50000]);
         if(mapOldCapaignMemberStatus != null && mapOldCapaignMemberStatus.size() >0 )
          for(CampaignMemberStatus OldCapaignMemberStatus :mapOldCapaignMemberStatus.values())
          {   
                OldCapaignMemberStatus.IsDefault = False;
                lstCampaignMemberStatusToDelete.add(OldCapaignMemberStatus);
          }
          List<Database.Saveresult> UpdateSaveResult  = Database.update( lstCampaignMemberStatusToDelete);
         if( lstCampaignMemberStatusToDelete != null && lstCampaignMemberStatusToDelete.size() > 0)
          {
            
            if( UpdateSaveResult != null  && UpdateSaveResult.size() >0 || lstCampaignMemberStatusToDelete != null && lstCampaignMemberStatusToDelete.size() >0 )
                try{                     
                    List<Database.DeleteResult> DeleteSaveResult  = Database.delete(lstCampaignMemberStatusToDelete);
                    List<DataBase.Saveresult> lstSaveResult= Database.insert(NewLstCampaignMemberStatus,false);
                }
                catch(Exception ex)
                {
                  String strError = 'Cannot delete this CampaignMemberStatus because it is being used';
                  if(!ex.getMessage().contains(strError )){
                      lstCampaigns[0].addError(ex.getMessage());
                  }
                }
         }      
         
         
     
    }
}