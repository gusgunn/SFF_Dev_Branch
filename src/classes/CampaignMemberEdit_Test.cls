@isTest
private class CampaignMemberEdit_Test{

    public static TestMethod void test(){    
        
        Contact c = new Contact(lastname='x');
        insert c;
        
        RecordType rt1 = [Select Id, Name from RecordType where Name = 'Program Campaign' limit 1];
        
        Campaign camp1 = new campaign();
        camp1.RecordTypeId = rt1.ID;
        camp1.Name = 'Program Campaign Test';
        camp1.IsActive = TRUE;
        camp1.StartDate = System.Today();
        
        insert camp1;
        
        CampaignMember cmb = new CampaignMember();
        cmb.campaignID=camp1.id;
        cmb.flag__c =true;
        cmb.contactid = c.id;
        insert cmb;
        
        CampaignMemberStatus cms1 = new CampaignMemberStatus();
        cms1.Label = 'Family Attendee';
        cms1.CampaignId = camp1.Id;
        cms1.SortOrder = 3;
        insert cms1;
        
       
        
       
       
        // ContactListSimpleController clsc = new ContactListSimpleController();
        
        /*CampaignCMListController cmlc = new CampaignCMListController();
        cmlc.doQuery();
        cmlc.Save();*/
        
        ContactListController clc = new ContactListController();
        clc.doQuery();
        clc.Save();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cms1);
        CampaignCMListController aclc = new CampaignCMListController(sc);
        aclc.doQuery();
        aclc.Save();
  
    
    }     

    
}