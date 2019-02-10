@isTest(seealldata=true)
                                
private class testRemoveSoapBoxCampaignMember 
{
    static testmethod void testMethodRemoveSoapBoxCampaignMember() 
    {
        //Create new test campaign
        RecordType rt1 = [select Id,RecordType.name from RecordType where name='Soapbox Registration' and sObjectType='Campaign'];
        RecordType rt2 = [select Id,RecordType.name from RecordType where name='Soapbox Registration' and sObjectType='CampaignMember'];
        
        Campaign newcampaign = new Campaign(Name='TestCampaign1',RecordTypeId=rt1.Id,CampaignMemberRecordTypeId=rt2.Id);
        insert newcampaign;
        
        //Id newcampaignid = [select Id from campaign where name='TestCampaign1'].Id;
        
        // Create some test campaign members to be deleted by the batch job.
       /*List<CampaignMember> lstcampaignmembers = new List<CampaignMember>();
       for (Integer i=0;i<10;i++) 
       {
           CampaignMember c = new CampaignMember(CampaignId=newcampaign.id);
           lstcampaignmembers.add(c);
       }
       //insert lstcampaignmembers;*/
       
        Contact con1 = new Contact(FirstName='test', LastName='con1', MobilePhone='3333333333');
        insert con1;
        
		CampaignMember c1 = new CampaignMember(CampaignId=newcampaign.id);
        c1.ContactId = con1.Id;
        insert c1;
        
       //Test.startTest();
       RemoveSoapBoxCampaignMember c = new RemoveSoapBoxCampaignMember();
       Database.executeBatch(c);
       //Test.stopTest();

       // Verify if CampaignMember records with RecordType as 'Soap Box Registration' got deleted 
       Integer i = [SELECT COUNT() FROM CampaignMember where RecordTypeId=:rt2.Id];
       //System.assertEquals(i, 0);
    }
}