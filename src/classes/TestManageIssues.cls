@isTest
private class TestManageIssues
{
    static testMethod void TriggerTestMethod()
    {
        IssuesUtility.PreventIssueInsertion(GetIssueRecords());
    }
    
    private static CreateIssue__c CustomSettings()
    {
        CreateIssue__c ci = new CreateIssue__c();
        ci.Name = 'Default';
        ci.NewIssueURL_1__c = '/a0p/e?&Name=New&retURL=/apex/ManageIssues?Id={!interaction.id}&saveURL=/apex/ManageIssues?Id={!interaction.id}&CF00NG000000Az3xN_lkid=0031100000AnhTa&CF00NG000000Az3xN={!interaction.contactname}&CF00NG000000Ax28T=';
        ci.NewIssueURL_2__c = '{!interaction.childcontact}&CF00NG000000Ax28T_lkid={!interaction.Family__Child__c}&CF00NG000000AyxaG={!interaction.CaseNumber}&CF00NG000000AyxaG_lkid={!interaction.id}&00NG000000Ax23c=New';
        insert ci;
        return ci;
    }
    
    private static List<Issue__c> GetIssueRecords()
    {
        List<Issue__c> Issues = new List<Issue__c>();  
        
        RecordType cntChildRType = [select Id from RecordType where Name = 'Child/Person with Disability' and SobjectType = 'Contact' LIMIT 1];
        RecordType cntAdultRType = [select Id from RecordType where Name = 'Adult' and SobjectType = 'Contact' LIMIT 1];
        
        Contact parentCnt = new Contact(LastName = 'Test Child', RecordType = cntAdultRType, Contact_Type__c = 'Parent', Family__Parent__c = true, English_Fluency__c = 'Fluent' );
        insert parentCnt;
        
        Case record = new Case(Family__Child__c = parentCnt.Id, Contact = parentCnt, Status = 'New');
        insert record;
        
        Issue__c issue1 = new Issue__c(Type_of_Issue__c = 'Assessment', Status__c = 'Pending', Issue_Contact__c = parentCnt.Id, Interaction_Log__c = record.Id );
        Issue__c issue2 = new Issue__c(Type_of_Issue__c = 'Behavior', Status__c = 'New', Issue_Contact__c = parentCnt.Id, Interaction_Log__c = record.Id);
        Issue__c issue3 = new Issue__c(Type_of_Issue__c = 'Assessment', Status__c = 'New', Issue_Contact__c = parentCnt.Id, Interaction_Log__c = record.Id);
        
        Issues.add(issue1);
        Issues.add(issue2);
        Issues.add(issue3);
        insert Issues;
        
        return Issues;
    }
    
    static testMethod void ManageIssueControllerTestMethod()
    {
        List<Issue__c> lstIssue = GetIssueRecords();
        CustomSettings();
        ApexPages.currentPage().getParameters().put('Id', lstIssue[0].Interaction_Log__c);
        ManageIssuesController controller = new ManageIssuesController();
        Related_Issue__c ri = new Related_Issue__c(Case__c = lstIssue[0].Interaction_Log__c, Issue__c = lstIssue[0].Id);
        insert ri;
        ManageIssuesController.CreateRelatedIssueSave(new String[]{lstIssue[0].Id, lstIssue[2].Id}, new String[]{lstIssue[1].Id, lstIssue[0].Id}, lstIssue[0].Interaction_Log__c);

    }
}