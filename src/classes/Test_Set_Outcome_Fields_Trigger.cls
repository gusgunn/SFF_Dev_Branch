@isTest
private class Test_Set_Outcome_Fields_Trigger {

    static testMethod void Test_Triggers() {
    	
    	recordType actionRT = [SELECT Id, Name FROM recordType WHERE Name = 'Internal Referral' AND sObjectType = 'Action__c' LIMIT 1];
    	recordType contactRT = [SELECT Id, Name FROM recordType WHERE Name = 'Adult' AND sObjectType = 'Contact' LIMIT 1];
    	
    	Contact testContact = new Contact(RecordTypeId = contactRT.Id, LastName = 'Test Contact');
    		insert testContact;
    		
    	Account testAccount = new Account(Name = 'Test Account');
    		insert testAccount;
    		
    	Issue__c testIssue = new Issue__c(Name = 'Test Issue', Caller_Name__c = testContact.id, Status__c = 'test',
    									  Issue_Contact__c = testContact.id, Type_of_Issue__c = 'test', Opened_Date__c = date.Today());
    		insert testIssue;
    		
    	F2F_Outcomes_Key__c testOutcome = new F2F_Outcomes_Key__c(Action_Detail_Type__c = 'test', Community_Services__c = 'test Comm',
    															  Financing__c = 'test Fin', Medical_Home__c = 'test Med',
    															  Partnering__c = 'test Part', Screening__c = 'test Scr',
    															  Transition__c = 'test Tran');
        	insert testOutcome;
    		
    	Action__c testAction = new Action__c(recordTypeId = actionRt.Id, Caller_Name__c = testContact.id, Action_Status__c = 'test',
    										 Referral_Date__c = date.Today(), Referral_Organization__c = testAccount.id,
    										 issues__c = testIssue.Id, Action_Detail_Type_Internal_Referral__c = 'test',
    										 Action_Detail_Type_Information__c = 'test', Action_Detail_Type_External_Referral__c = 'test');
    		insert testAction;
    		
    	F2F_Outcomes_Key__c testOutcome2 = new F2F_Outcomes_Key__c();
        	insert testOutcome2;
    		
        
    }
}