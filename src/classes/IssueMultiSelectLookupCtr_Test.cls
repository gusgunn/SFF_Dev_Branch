@isTest
/***********
* 8/25/18 Novo phoneline
* GG
***********/

private  class IssueMultiSelectLookupCtr_Test {
    private static Profile adminProfile = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
    private static RecordType rtAdultContact = [select Id from RecordType where Name = 'Adult' and SobjectType = 'Contact' LIMIT 1];//Grab all required fields?
    private static RecordType rtChildContact = [Select Id, Name from RecordType where Name = 'Child/Person With Disability'  and SobjectType = 'Contact' limit 1];
    private static RecordType actionRT = [SELECT Id, Name FROM recordType WHERE Name = 'Internal Referral' AND sObjectType = 'Action__c' LIMIT 1];
    private static RecordType rTProfInteraction = [SELECT Id, Name FROM recordType WHERE Name = 'Professional Case' AND sObjectType = 'Case' LIMIT 1];
    private static String fld = 'Type_of_Issue__c';
    private static String searchKeyWord = 'AAC';
    private static String objectName = 'Issue__c';
    private static List<String> lstOfIssueNamesSelected = new List<String> {'Transportation', 'Visual Supports'};
    private static List <Issue__c> excludeItemsList = new List <Issue__c>();
    public static Boolean testingException = false;
    static date BDate = date.newInstance(2016, 7, 1);
    
    @isTest 
    static void testGetNewIssueTypes(){
        String fld = 'Type_Of_Issue__c';
        Map<String, String> unavailableIssueTypes = new Map<String, String>();
        unavailableIssueTypes.put('Advocacy Opportunities-Partnering', 'Advocacy Opportunities-Partnering')  ;
        IssueMultiSelectLookupCtr.getNewIssueTypes( fld, unavailableIssueTypes);
    }
    
    @isTest 
    static void testFetchAvailableValues(){
        List<Contact> childIDs = [SELECT Id FROM Contact WHERE RecordTypeId = :rtChildContact.Id LIMIT 1];
        String kidId = String.ValueOf(childIDs[0].Id);
        List<case> cases = [select id FROM Case LIMIT 1];
        String intID = String.ValueOf(cases[0].Id);
        IssueMultiSelectLookupCtr.fetchAvailableValues(searchKeyWord, objectName, kidId, intID );    
    }
    
     @isTest 
    static void testGetOpenIssues(){
        List<Contact> childIDs = [SELECT Id FROM Contact WHERE RecordTypeId = :rtChildContact.Id LIMIT 1];
        String kidId = String.ValueOf(childIDs[0].Id);
        List<case> cases = [select contactId, id FROM Case LIMIT 1];
        String intId = String.ValueOf(cases[0].Id);
        String conId = String.ValueOf(cases[0].ContactId);
        IssueMultiSelectLookupCtr.getOpenIssues( kidId, intId , conId);    
    }
    
    
    @isTest 
    static void testFetchAlreadyOpen(){
        List<Contact> childIDs = [SELECT Id FROM Contact WHERE RecordTypeId = :rtChildContact.Id LIMIT 1];
        String kidId = String.ValueOf(childIDs[0].Id);
        List<case> cases = [select Id, ContactId  FROM Case LIMIT 1];
        String conId = String.ValueOf(cases[0].ContactId);
        String intID = String.ValueOf(cases[0].Id);
        IssueMultiSelectLookupCtr.fetchAlreadyOpen(objectName, kidId, intID, conId );
      
    }
    @isTest 
    static void testGetAlreadyRelated(){
        List<case> cases = [select id FROM Case LIMIT 1];
        String intIds = String.ValueOf(cases[0].Id);
        IssueMultiSelectLookupCtr.getAlreadyRelated(intIds);
       
    }
     @isTest 
    static void testGetAlreadyRelatedName(){
        List<case> cases = [select id FROM Case LIMIT 1];
        String intId = String.ValueOf(cases[0].Id);
        IssueMultiSelectLookupCtr.getAlreadyRelatedName(intId);
       
    }
    @isTest 
    static void testAddNewIssues(){
        List<Contact> conIds = [SELECT Id FROM Contact WHERE RecordTypeId != :rtChildContact.Id LIMIT 1];
        String conId = String.ValueOf(conIds[0].Id);
        List<Contact> childIDs = [SELECT Id FROM Contact WHERE RecordTypeId = :rtChildContact.Id LIMIT 1];
        String kidId = String.ValueOf(childIDs[0].Id);
        List<case> cases = [select id FROM Case LIMIT 1];
        String intId = String.ValueOf(cases[0].Id);
        IssueMultiSelectLookupCtr.addNewIssues(intId, conId, kidId, lstOfIssueNamesSelected, fld );
    }
    @isTest 
    static void testGetIssues(){
        List<Contact> childIDs = [SELECT Id FROM Contact WHERE RecordTypeId = :rtChildContact.Id LIMIT 1];
        String kidId = String.ValueOf(childIDs[0].Id);
        IssueMultiSelectLookupCtr.getIssues(excludeItemsList, kidId);
        
    }
    @isTest 
    static void testAddRelatedIssues(){
        List<Contact> conIds = [SELECT Id FROM Contact WHERE RecordTypeId != :rtChildContact.Id LIMIT 1];
        String ConId = String.ValueOf(conIds[0].Id);
        List<Contact> childIDs = [SELECT Id FROM Contact WHERE RecordTypeId = :rtChildContact.Id LIMIT 1];
        String kidId = String.ValueOf(childIDs[0].Id);
        List<case> cases = [select id FROM Case LIMIT 1];
        String IntId = String.ValueOf(cases[0].Id);
        list<Issue__c> lstOfIssues = [SELECT Id, Interaction_Log__c FROM Issue__c LIMIT 1];
        List<String> lstOfIssueIds = new List<String>();
        for(Issue__c i : lstOfIssues){
          lstOfIssueIds.add(i.Id) ; 
        }
        IssueMultiSelectLookupCtr.addRelatedIssues(intId, lstOfIssueIds, conId);  
    }
    
    
    @testSetup static void testSetupCoreObjects()  {
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave=true;
        
        User assignedTo = new User(Alias = 'JD',
                                   Email = 'jd@mg.com',
                                   FirstName = 'Jesse',
                                   LastName = 'Dylan',
                                   TimeZoneSidKey = 'America/Los_Angeles',
                                   UserName = 'jd@mg.com',
                                   ProfileID = UserInfo.getProfileId(),
                                   LocaleSidKey = 'en_US',
                                   EmailEncodingKey = 'UTF-8',
                                   LanguageLocaleKey = 'en_US');
        database.insert(assignedTo, dml);
        
        Account testAccount = new Account(Name = 'Test Account');
        database.insert(testAccount, dml); 
        
        npo02__Household__c hh = new npo02__Household__c(Name='House-' ,
                                                         npo02__MailingPostalCode__c ='94110');
        
        database.insert(hh, dml);
        
        
        Contact testContact = new Contact(RecordTypeId = rtAdultContact.Id, AccountID = testAccount.ID, 
                                          LastName = 'Test Contact', Error_Contact__c  = true, Email = 'test@example.com');
        database.insert(testContact, dml); 
        
        Contact childTestContact = new Contact(FirstName='Abe' , 
                                               LastName='Becee' , 
                                               RecordTypeID = rtChildContact.Id,
                                               Family__Primary_Language__c = 'Spanish',
                                               Family__Gender__c = 'Female',
                                               Birthdate = BDate,
                                               //schooltype etc
                                               Underserved__c= TRUE,
                                               Low_Income__c= TRUE,
                                               Income__c = 'Homeless',
                                               Housing_Status__c ='Vehicle',
                                               MailingPostalCode = '94124',
                                               lep__c = 'Declined',
                                               Incarcerated_youth__c = True,
                                               npo02__Household__c=hh.id,	
                                               AccountID= testAccount.Id);
        
        database.insert(childTestContact, dml); 
        
        
        Datetime myDateTime = Datetime.newInstance(2016,9, 30);
        Case case1 = new Case(ContactId = testContact.ID,
                              AccountID = testAccount.ID,
                              Call_Type__c = 'Contact',
                              Origin = 'In-person',
                              Status = 'Closed',
                              Start_time__c = myDateTime,
                              Add_5_Mins_to_Start_Time_For_End_Time__c = 5,                            
                              Family__Child__c = childTestContact.Id,
                              RecordTypeId = rTProfInteraction.Id);
        
        database.insert(case1, dml);
        List<Issue__c> issuesList= new List<Issue__c>();                       
        Issue__c testIssue = new Issue__c(Name = 'Test Issue',  Caller_Name__c = testContact.id, Status__c = 'test',
                                          Issue_Contact__c = testContact.id, Interaction_Log__c = case1.Id, Type_of_Issue__c = 'Advocacy Opportunities-Partnering', 
                                          Opened_Date__c = date.Today());
        
        issuesList.add(testIssue);
        database.insert(issuesList, dml);
        
        
        
        /*F2F_Outcomes_Key__c testOutcome = new F2F_Outcomes_Key__c(Action_Detail_Type__c = 'test', Community_Services__c = 'test Comm',
Financing__c = 'test Fin', Medical_Home__c = 'test Med',
Partnering__c = 'test Part', Screening__c = 'test Scr',
Transition__c = 'test Tran');
* insert testOutcome;*/
        
        List <Action__c> insertActions = new list <Action__c>();	
        Action__c testAction = new Action__c(recordTypeId = actionRt.Id, Caller_Name__c = testContact.id, Child_Name__c = childTestContact.ID,
                                             Action_Status__c = 'test', Referral_Date__c = date.Today(), Referral_Organization__c = testAccount.id,
                                             issues__c = testIssue.Id,Completed_Date__c = date.Today(), Referral_Follow_up_Date__c = date.Today(), Date_On_Referral_Form__c = bDate,
                                             Action_Detail_Type_Internal_Referral__c= 'Received Referral to SFCD;Referral Thank You;Referral Contact Confirmation; Referral Update; Referral Contact UTC');
        
        //insertActions.add(testAction);
        database.insert(testAction, dml);
        List<ReferralTracking__c> rt= [Select  Key__c, Referral_Organization__c
                                       FROM ReferralTracking__c
                                      ];
        Integer n = 0;
        for(ReferralTracking__c r:rt){
            N+=1; 
            //System.assertEquals(testAccount.id, r.Referral_Organization__c, 'Error, caller Agency incorrect');
        }
        //String key = string.ValueOf(testAction.Caller_Name__c) + string.ValueOf( testAction.Child_Name__c);
        System.assertEquals(1, n, 'Error, more than 1 referralTrack inserted');
        
        Action__c testActionDupeKey1 = new Action__c(recordTypeId = actionRt.Id, Caller_Name__c = testContact.id, Child_Name__c = childTestContact.ID,
                                                     Action_Status__c = 'test', Referral_Date__c = date.Today(), Referral_Organization__c = testAccount.id,
                                                     issues__c = testIssue.Id, Assigned_To__c = assignedTo.ID,
                                                     Action_Detail_Type_Internal_Referral__c= 'Referral Update');
        insertActions.add(testActionDupeKey1);
        Action__c testActionDupeKey2 = new Action__c(recordTypeId = actionRt.Id, Caller_Name__c = testContact.id, Child_Name__c = childTestContact.ID,
                                                     Action_Status__c = 'test', Referral_Date__c = date.Today(), Referral_Organization__c = testAccount.id,
                                                     issues__c = testIssue.Id,
                                                     Action_Detail_Type_Internal_Referral__c= 'Referral Contact UTC');
        //Action_Detail_Type_Information__c = 'test', Action_Detail_Type_External_Referral__c = 'test'									 
        insertActions.add(testActionDupeKey2);	
        database.insert(insertActions, dml);
        
        List<ReferralTracking__c> rt2= [Select  Key__c
                                        FROM ReferralTracking__c
                                       ];
        Integer x = 0;
        for(ReferralTracking__c r:rt2){
            x+=1; 
        }
        String key = string.ValueOf(testAction.Caller_Name__c) + string.ValueOf( testAction.Child_Name__c);
        System.assertEquals(1, x, 'Error, more thant 2 referralTracks inserted');
        System.assertEquals(rt2[0].Key__c, key);
        
        /* F2F_Outcomes_Key__c testOutcome2 = new F2F_Outcomes_Key__c();
* insert testOutcome2;
* */
        
        Action__c testActionError = new Action__c(recordTypeId = actionRt.Id, Caller_Name__c = testContact.id,
                                                  Action_Status__c = 'test', Referral_Date__c = date.Today(), Referral_Organization__c = testAccount.id,
                                                  issues__c = testIssue.Id, Assigned_To__c = assignedTo.ID,
                                                  Action_Detail_Type_Internal_Referral__c= 'Referral Contact UTC');
        //Action_Detail_Type_Information__c = 'test', Action_Detail_Type_External_Referral__c = 'test'									 
        Test.startTest();
        database.insert(testActionError, dml);	
        Test.stopTest();
        
    }
    
    
    
}