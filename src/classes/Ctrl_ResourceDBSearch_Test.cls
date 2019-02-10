@isTest
public class Ctrl_ResourceDBSearch_Test {
    Private static RecordType rtProgram = [select Id from RecordType where Name = 'Program Campaign' and SobjectType = 'Campaign' LIMIT 1];
    Private static RecordType rtAdultContact = [select Id from RecordType where Name = 'Adult' and SobjectType = 'Contact' LIMIT 1];//Grab all required fields?
    Private static RecordType rtChildContact = [Select Id, Name from RecordType where Name = 'Child/Person With Disability'  and SobjectType = 'Contact' limit 1];
    Private static RecordType actionRT = [SELECT Id, Name FROM recordType WHERE Name = 'Internal Referral' AND sObjectType = 'Action__c' LIMIT 1];
    
    
    @testSetup static void createTestRecords() {
        
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        DataForTest.createFamilies(20, 1);
        
        
        
        
        //  Database.insert(myInserts, dml);
        
    }
    
    @isTest static void testMethod1() {
        List<Account> myAccountList = [SELECT ID, Name, recordTypeID, Include_in_Resource_Guide__c, Category__c
                                       FROM Account
                                       LIMIT 5];
        
        
        Test.startTest();
        PageReference rdb = Page.ResourceDB_Search;
        Test.setCurrentPage(rdb);
        Ctrl_ResourceDBSearch controller = new Ctrl_ResourceDBSearch();
        controller.getIssueTypes();
        controller.getConditions();
        controller.searchResources();
        // controller.Save();
        //(myAccountList[2]));
        controller.category='Adult Services';
        Test.stopTest();
    }
   
}