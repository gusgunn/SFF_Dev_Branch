///Summary      : TestCampaignMemberStatuses.
///Author       :   Prakash Nawale
//Created On    :   23/05/2014
//LastModifed By:
@isTest(SeeAllData=TRUE)
public class TestCampaignMemberStatuses {

public static testmethod void MyUnitTest()
{
	Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
	User u = new User(Alias = 'standt', Email='SysAdmin@PicDe.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='SysAdmin@PicDe.com');
      
    System.RunAs(u){
	
    	Map<Id,Schema.Recordtypeinfo> mapRecordTypes = Campaign.SObjectType.getDescribe().getRecordTypeInfosByID();
     
     	//mapRecordTypes.get(campaign.RecordTypeId).getName()
      
   		List<RecordType>  lstRecordType  = new List<RecordType>([ Select Name, IsActive, Id From RecordType  where SobjectType = 'Campaign']);
         
          //For Trigger Enabling
        /*TriggerConfiguration__c triggerConfiguration = new TriggerConfiguration__c();
        triggerConfiguration.Name = 'CampaignMemberStatusTrigger';
        triggerConfiguration.IsActive__c = True;
        insert triggerConfiguration;*/
        
        ///Custom Setting Records
        CampaignMemberstatuses__c CampaignMemberstatuses = new CampaignMemberstatuses__c();
        CampaignMemberstatuses.Name = 'Master';
        CampaignMemberstatuses.Record_Type__c = 'Master';
        CampaignMemberstatuses.Campaign_Member_Status__c = 'sent,processed';
        insert CampaignMemberstatuses;    
          
         
        CampaignMemberstatuses__c CampaignMemberstatuses2 = new CampaignMemberstatuses__c();
        CampaignMemberstatuses2.Name = 'Master1';
        CampaignMemberstatuses2.Record_Type__c = 'Master';
        CampaignMemberstatuses2.Campaign_Member_Status__c = 'reviedd,test';
        insert CampaignMemberstatuses2; 
              
        System.debug('CampaignMemberstatuses:::'+CampaignMemberstatuses);
        
        ///New Campaign Records.
        Campaign campaing = new Campaign();
        campaing.Name = 'Test Campagin';
        
        Campaign campaing2 = new Campaign();
        campaing2.Name = 'Test Campagin';
        
      
                
        insert campaing;
        
        CampaignMemberStatus MemberStatus1 = new CampaignMemberStatus();
        MemberStatus1.CampaignId = campaing.id;
        MemberStatus1.Label = 'Test';
       	MemberStatus1.SortOrder = 100;
        insert MemberStatus1;
          
        insert campaing2;
        CampaignMemberStatus MemberStatus2 = new CampaignMemberStatus();
        MemberStatus2.CampaignId = campaing2.id;
        MemberStatus2.Label = 'Test';
       	MemberStatus2.SortOrder = 100;
        insert MemberStatus2;
          
       
        //if(mapRecordTypes != null && mapRecordTypes.size() >0 )
        //campaing2.RecordTypeId = mapRecordTypes.values()[0].getRecordTypeId();         
        //update campaing2;
        
                
         CampaignMemberStatus MemberStatus3 = new CampaignMemberStatus();
        MemberStatus3.CampaignId = campaing2.id;
        MemberStatus3.Label = 'Test';
       	MemberStatus3.SortOrder = 100;
        insert MemberStatus3;
        
    }        
}
}