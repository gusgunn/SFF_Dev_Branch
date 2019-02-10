@isTest
private class TestSetCampaignMemberStatus {

    static testMethod void myUnitTest() {
        
        RecordType rt1 = [Select Id, Name from RecordType where Name = 'Program Campaign' limit 1];
        
        Campaign camp1 = new campaign();
        camp1.RecordTypeId = rt1.ID;
        camp1.Name = 'Program Campaign Test';
        camp1.IsActive = TRUE;
        camp1.StartDate = System.Today();
        
        insert camp1;
        
        CampaignMemberStatus cms1 = new CampaignMemberStatus();
        cms1.Label = 'Family Attendee';
        cms1.CampaignId = camp1.Id;
        cms1.SortOrder = 3;
         
		insert cms1;
    }
}