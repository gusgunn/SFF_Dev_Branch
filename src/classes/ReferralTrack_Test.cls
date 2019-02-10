@isTest

public class ReferralTrack_Test {
    static private Integer numAccts = 10;
    static private Integer numContactsPerAcct = 3;
    static date beginDate = date.newInstance(2016, 1, 1);
    static date endDate = date.newInstance(2016, 12, 31);  
    Static  DateTime myDateC = DateTime.newInstance(2016, 9, 30, 8,3, 5);
    
    Private static Profile adminProfile = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
    Private static RecordType rtAdultContact = [select Id from RecordType where Name = 'Adult' and SobjectType = 'Contact' LIMIT 1];//Grab all required fields?
    Private static RecordType rtChildContact = [Select Id, Name from RecordType where Name = 'Child/Person With Disability'  and SobjectType = 'Contact' limit 1];
    Private static RecordType actionRT = [SELECT Id, Name FROM recordType WHERE Name = 'Internal Referral' AND sObjectType = 'Action__c' LIMIT 1];
    Private static RecordType rTProfInteraction = [SELECT Id, Name FROM recordType WHERE Name = 'Professional Case' AND sObjectType = 'Case' LIMIT 1];
    static date BDate = date.newInstance(2016, 7, 1);
   // Public Static User u = dataFor_Test.getTestUser();
    
    @testSetup static void createTestRecords() {
        
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        User assignedTo = new User(Alias = 'JD',
                          Email = 'jd@TestGTestgg.com',
                          FirstName = 'Jack',
                          LastName = 'fried',
                          TimeZoneSidKey = 'America/Los_Angeles',
                          UserName = 'jd@TestGTestgg.com',
                          ProfileID = UserInfo.getProfileId(),
                          LocaleSidKey = 'en_US',
                          EmailEncodingKey = 'UTF-8',
                          LanguageLocaleKey = 'en_US');
        
        Database.insert(assignedTo, dml);
         Account ACC1 = new Account(Name = 'MEDA');
        database.insert(ACC1, dml); 
        
        npo02__Household__c hh1 = new npo02__Household__c(Name='House-' , OwnerID=assignedTo.Id, Last_Intake__c = beginDate,
                                                         npo02__MailingPostalCode__c ='94110', First_Interaction__c = beginDate,
                                                         Most_Recent_Household_Interaction__c= beginDate);
        
        
        database.insert(hh1, dml);
        
        
        Contact testContact1 = new Contact(RecordTypeId = rtAdultContact.Id, AccountID =Acc1.ID, LastName = 'Contact');
        database.insert(testContact1, dml); 
        
        Contact childTestContact1 = new Contact(FirstName='be' , 
                                               LastName='ecee' , 
                                               RecordTypeID = rtChildContact.Id,
                                               Family__Primary_Language__c = 'Spanish',
                                               Family__Gender__c = 'Female',
                                               Birthdate = BDate,
                                               
                                               npo02__Household__c=hh1.Id,	
                                               First_Interaction__c =BDate, 
                                               Last_Interaction_Date__c= BDate,
                                               OwnerID=assignedTo.Id);
        
        database.insert(childTestContact1, dml); 
        
        
        Datetime myDateTime1 = Datetime.newInstance(2016,9, 30);
        Case case1 = new Case(ContactId = testContact1.ID,
                              Call_Type__c = 'Contact',
                              Origin = 'In-person',
                              Status = 'Closed',
                              AccountID = ACC1.Id,
                            Start_time__c = myDateTime1,
                              Add_5_Mins_to_Start_Time_For_End_Time__c = 5,                            
                              Family__Child__c = rtChildContact.Id,
                              Family__Household__c = hh1.ID,
                              OwnerID= assignedTo.ID,
                              RecordTypeId = rTProfInteraction.Id);
        
        
        
        database.insert(case1, dml);
        
        Account testAccount = new Account(Name = 'GGRC');
        database.insert(testAccount, dml); 
        
        npo02__Household__c hh = new npo02__Household__c(Name='House-' , OwnerID=assignedTo.Id, Last_Intake__c = beginDate,
                                                         npo02__MailingPostalCode__c ='94110', First_Interaction__c = beginDate,
                                                         Most_Recent_Household_Interaction__c= beginDate);
        
        
        database.insert(hh, dml);
        
        
        Contact testContact = new Contact(RecordTypeId = rtAdultContact.Id, AccountID =testAccount.ID, LastName = 'Grrrrr');
        database.insert(testContact, dml); 
        
        Contact childTestContact = new Contact(FirstName='fRED' , 
                                               LastName='BeAN' , 
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
                                               npo02__Household__c=hh.Id,	
                                               First_Interaction__c =BDate, 
                                               Last_Interaction_Date__c= BDate,
                                               OwnerID=assignedTo.Id);
        
        database.insert(childTestContact, dml); 
        
        
        Datetime myDateTime = Datetime.newInstance(2016,9, 30);
        Case case2 = new Case(ContactId = testContact.ID,
                              AccountID = testAccount.Id,
                              Call_Type__c = 'Contact',
                              Origin = 'In-person',
                              Status = 'Closed',
                              Start_time__c = myDateTime,
                              Add_5_Mins_to_Start_Time_For_End_Time__c = 5,                            
                              Family__Child__c = childTestContact1.Id,
                              Family__Household__c = hh.ID,
                              OwnerID= assignedTo.ID,
                              RecordTypeId = rTProfInteraction.Id);
        
        
        
        database.insert(case2, dml);
        
        
        
        
        
        Issue__c testIssue = new Issue__c(Name = 'MYIssue', Caller_Name__c = testContact.id, Status__c = 'Open',
                                          Issue_Contact__c = childTestContact.id, Type_of_Issue__c = 'Behavior', 
                                          Opened_Date__c = myDateTime.date());
        
        database.insert(testIssue, dml);
        
        /*	F2F_Outcomes_Key__c testOutcome = new F2F_Outcomes_Key__c(Action_Detail_Type__c = 'test', Community_Services__c = 'test Comm',
Financing__c = 'test Fin', Medical_Home__c = 'test Med',
Partnering__c = 'test Part', Screening__c = 'test Scr',
Transition__c = 'test Tran');
insert testOutcome;*/
        List <Action__c> insertActions = new list <Action__c>();	
        Action__c testAction = new Action__c(recordTypeId = actionRt.Id, Caller_Name__c = testContact.id, Child_Name__c = childTestContact.ID,
                                             Action_Status__c = 'test', Referral_Date__c = BDate, Referral_Organization__c = testAccount.id,
                                             issues__c = testIssue.Id,   Assigned_To__c = assignedTo.ID,  
                                             Action_Detail_Type_Internal_Referral__c= 'Received Referral to SFCD;Referral Thank You;Referral Contact Confirmation');
        
        //insertActions.add(testAction);
        database.insert(testAction, dml);
        List<ReferralTracking__c> rt= [Select  Key__c
                                       FROM ReferralTracking__c
                                      ];
        Integer n = 0;
        for(ReferralTracking__c r:rt){
            N+=1; 
        }
        //String key = string.ValueOf(testAction.Caller_Name__c) + string.ValueOf( testAction.Child_Name__c);
        //System.assertEquals(1, n, 'Error, more thant 1 referralTrack inserted');
        
        Action__c testActionDupeKey1 = new Action__c(recordTypeId = actionRt.Id, Caller_Name__c = testContact.id, Child_Name__c = childTestContact.ID,
                                                     Action_Status__c = 'test', Referral_Date__c = BDate, Referral_Organization__c = testAccount.id,
                                                     issues__c = testIssue.Id, Assigned_To__c = assignedTo.ID, 
                                                     Action_Detail_Type_Internal_Referral__c= 'Referral Update');
        insertActions.add(testActionDupeKey1);
        Action__c testActionDupeKey2 = new Action__c(recordTypeId = actionRt.Id, Caller_Name__c = testContact.id, Child_Name__c = childTestContact.ID,
                                                     Action_Status__c = 'test', Referral_Date__c = BDate, Referral_Organization__c = testAccount.id,
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
       // System.assertEquals(1, x, 'Error, more thant 2 referralTracks inserted');
        //System.assertEquals(rt2[0].Key__c, key);
        
        /*F2F_Outcomes_Key__c testOutcome2 = new F2F_Outcomes_Key__c();
insert testOutcome2;*/
        Action__c testActionError = new Action__c(recordTypeId = actionRt.Id, Caller_Name__c = testContact.id,
                                                  Action_Status__c = 'test', Referral_Date__c = BDate, Referral_Organization__c = testAccount.id,
                                                  issues__c = testIssue.Id, Assigned_To__c = assignedTo.ID, 
                                                  Action_Detail_Type_Internal_Referral__c= 'Referral Contact UTC');
        //Action_Detail_Type_Information__c = 'test', Action_Detail_Type_External_Referral__c = 'test'									 
        
        database.insert(testActionError, dml);	
        
    }
    
    
    
    
    
    
    
    @isTest static void testMethod1() {
        Contact x = [SELECT OwnerId From CONTACT WHERE RecordTypeID = :rtChildContact.Id Limit 1 ];
        User ux = [SELECT ID FROM USER WHERE ID =: x.OwnerId];
        System.runAs(ux) {
            
            Test.startTest();
            
            
            
            PageReference ReferralTracksReportVF = Page.ReferralTotals;
            Test.setCurrentPage(ReferralTracksReportVF);
            
            // get a Page controller instance
            ReferralTrackReportsCtr AR = new ReferralTrackReportsCtr();
            date TestDateTo = date.newInstance(2016, 12, 31 );
            date TestDateFrom = date.newInstance(2016, 1, 1 ); 
            String defaultSelector = 'IA';
            // Set Date From and Date To on Controller
            Date controllerDateFrom = beginDate;
            Date controllerDateTo = endDate;
            AR.selector = defaultSelector;
            AR.datefrom = controllerDateFrom;
            AR.dateTo = controllerDateTo;
            System.AssertEquals(AR.dateFrom, controllerDateFrom);
            System.AssertEquals(AR.dateTo, controllerDateTo);
            
            
            AR.startGenerateBoard();
            AR.getItems();
            AR.getGenerateRTs(); 
            AR.getReferralCase();
            
            AR.getTotalUndupeP();
            AR.getTotalUndupeK();
            AR.getOrgCats();
            AR.doQuery();
            
            Test.stopTest();       
        }
    }
    
    @isTest static void testMethod2() {
         Contact x = [SELECT OwnerId From CONTACT WHERE RecordTypeID = :rtChildContact.Id Limit 1 ];
        User ux = [SELECT ID FROM USER WHERE ID =: x.OwnerId];
        System.runAs(ux) {
            Test.startTest();
            
            PageReference ReferralTracksReportVF = Page.ReferralTracksReportVF;
            Test.setCurrentPage(ReferralTracksReportVF);
            
            // get a Page controller instance
            ReferralTrackReportsCtr AR = new ReferralTrackReportsCtr();
            
            date TestDateTo = date.newInstance(2016, 12, 31 );
            date TestDateFrom = date.newInstance(2016, 1, 1 ); 
            // Set Date From and Date To on Controller
            Date controllerDateFrom = TestDateTo;
            Date controllerDateTo = TestDateTo ;
            
            AR.datefrom = controllerDateFrom;
            AR.dateTo = controllerDateTo;
            System.AssertEquals(AR.dateFrom, controllerDateFrom);
            System.AssertEquals(AR.dateTo, controllerDateTo);
            
            AR.startGenerateBoard(); 
            AR.getItems();
            AR.getSelector();
             AR.getGenerateRTs(); 
            AR.getTotalUndupeP();
            AR.getTotalUndupeK();
            AR.getOrgCats();
           
            Test.stopTest();       
        }
    }
    
    @isTest static void testMethod3() {
        Contact x = [SELECT OwnerId From CONTACT WHERE RecordTypeID = :rtChildContact.Id Limit 1 ];
        User ux = [SELECT ID FROM USER WHERE ID =: x.OwnerId];
        System.runAs(ux) {
            Test.startTest();
            // get reference to EIS Dashboard Page
            PageReference ReferralTracksReportVF = Page.ReferralTracksReportVF;
            Test.setCurrentPage(ReferralTracksReportVF);
            
            // get a Page controller instance
            ReferralTrackReportsCtr AR = new ReferralTrackReportsCtr();
            
            date TestDateTo = NULL; //date.newInstance(2016, 7, 31 );
            date TestDateFrom = date.newInstance(2016, 12, 1 ); 
            // Set Date From and Date To on Controller
            Date controllerDateFrom = TestDateTo;
            Date controllerDateTo = TestDateTo ;
            AR.datefrom = controllerDateFrom;
            AR.dateTo = controllerDateTo;
            System.AssertEquals(AR.dateFrom, controllerDateFrom);
            System.AssertEquals(AR.dateTo, controllerDateTo);
            AR.startGenerateBoard(); 
            AR.getGenerateFRCs();
            AR.getGenerateRTs(); 
            AR.getReferralCase();
            AR.getGenerateFRCs();
            AR.getContactsOpenIssues();
            AR.getTotalUndupeP();
            AR.getTotalUndupeK();
            AR.getOrgCats();
            Test.stopTest();  
        }
        
    }
    
    @isTest static void testMethod4() {
       Contact x = [SELECT OwnerId From CONTACT WHERE RecordTypeID = :rtChildContact.Id Limit 1 ];
        User ux = [SELECT ID FROM USER WHERE ID =: x.OwnerId];
        System.runAs(ux) {
            Test.startTest();
            PageReference ReferralTracksReportVF = Page.ReferralTracksReportVF;
            Test.setCurrentPage(ReferralTracksReportVF);
            
            // get a Page controller instance
            ReferralTrackReportsCtr AR = new ReferralTrackReportsCtr();
            
            date TestDateTo = date.newInstance(2016, 7, 31 );
            date TestDateFrom = date.newInstance(2016, 12, 1 );
            // Set Date From and Date To on Controller
            Date controllerDateFrom = endDate;
            Date controllerDateTo = beginDate ;
            AR.datefrom = controllerDateFrom;
            AR.dateTo = controllerDateTo;
            System.AssertEquals(AR.dateFrom, controllerDateFrom);
            System.AssertEquals(AR.dateTo, controllerDateTo);
            AR.startGenerateBoard();
            AR.getGenerateRTs(); 
            AR.getReferralCase();
            AR.getGenerateFRCs();
            AR.getGenerateFRCs();
            AR.getContactsOpenIssues();
            AR.getTotalUndupeP();
            AR.getTotalUndupeK();
            AR.getOrgCats();
            Test.stopTest();       
        }
    }
    
    @isTest static void testMethod5() {
        Contact x = [SELECT OwnerId From CONTACT WHERE RecordTypeID = :rtChildContact.Id Limit 1 ];
        User ux = [SELECT ID FROM USER WHERE ID =: x.OwnerId];
        System.runAs(ux) {
            Test.startTest();
            
            PageReference ReferralTracksReportVF = Page.FRS_DB_VF;
            Test.setCurrentPage(ReferralTracksReportVF);
            
            // get a Page controller instance
            ReferralTrackReportsCtr AR = new ReferralTrackReportsCtr();
            
            date TestDateTo = date.newInstance(2017, 12, 31 );
            date TestDateFrom = date.newInstance(2016, 1, 1 ); 
            // Set Date From and Date To on Controller
            Date controllerDateFrom = TestDateFrom;
            Date controllerDateTo = TestDateTo;
            AR.datefrom = controllerDateFrom;
            AR.dateTo = controllerDateTo;
            System.AssertEquals(AR.dateFrom, controllerDateFrom);
            System.AssertEquals(AR.dateTo, controllerDateTo);
            AR.startGenerateBoard();
            AR.getGenerateFRCs();
            AR.getGenerateRTs(); 
            AR.getReferralCase();
            AR.getGenerateFRCs();
           AR.getContactsOpenIssues();
            AR.getTotalUndupeP();
            AR.getTotalUndupeK();
            AR.getOrgCats();
            
            Test.stopTest();
        }
    }
    
    @isTest static void testMethod6() {
       Contact x = [SELECT OwnerId From CONTACT WHERE RecordTypeID = :rtChildContact.Id Limit 1 ];
        User ux = [SELECT ID FROM USER WHERE ID =: x.OwnerId];
        System.runAs(ux) {
            Test.startTest();
            
            PageReference ReferralTracksReportVF = Page.ReferralTracksReportVF;
            Test.setCurrentPage(ReferralTracksReportVF);
            
            // get a Page controller instance
            ReferralTrackReportsCtr AR = new ReferralTrackReportsCtr();
            
            date TestDateTo = date.newInstance(2017, 12, 31 );
            date TestDateFrom = date.newInstance(2016, 1, 1 ); 
            // Set Date From and Date To on Controller
            Date controllerDateFrom = TestDateFrom;
            Date controllerDateTo = TestDateTo;
            AR.datefrom = controllerDateFrom;
            AR.dateTo = controllerDateTo;
            System.AssertEquals(AR.dateFrom, controllerDateFrom);
            System.AssertEquals(AR.dateTo, controllerDateTo);
            AR.startGenerateBoard();
            AR.getGenerateRTs(); 
            AR.getReferralCase();
            AR.getGenerateFRCs();
            AR.getOrgCats();
            AR.getDupeOrgCats();
			AR.getContactsOpenIssues();
            AR.getTotalUndupeP();
            AR.getTotalUndupeK();
            test.stopTest();
        }
    }
     @isTest static void testMethod7() {
       Contact x = [SELECT OwnerId From CONTACT WHERE RecordTypeID = :rtChildContact.Id Limit 1 ];
        User ux = [SELECT ID FROM USER WHERE ID =: x.OwnerId];
        System.runAs(ux) {
            Test.startTest();
            
            PageReference ReferralTracksReportVF = Page.ReferralTotals;
            Test.setCurrentPage(ReferralTracksReportVF);
            
            // get a Page controller instance
            ReferralTrackReportsCtr AR = new ReferralTrackReportsCtr();
            String selected ='IA';
            date TestDateTo = date.newInstance(2017, 12, 31 );
            date TestDateFrom = date.newInstance(2016, 1, 1 ); 
            // Set Date From and Date To on Controller
            Date controllerDateFrom = TestDateFrom;
            Date controllerDateTo = TestDateTo;
            AR.selector=selected;
            AR.datefrom = controllerDateFrom;
            AR.dateTo = controllerDateTo;
            System.AssertEquals(AR.dateFrom, controllerDateFrom);
            System.AssertEquals(AR.dateTo, controllerDateTo);
            AR.selector=selected;
            AR.startGenerateBoard();
            AR.selector=selected;
            AR.getGenerateRTs(); 
            AR.doquery();
            AR.getReferralCase();
            AR.getGenerateFRCs();
            AR.getOrgCats();
            AR.getDupeOrgCats();
			AR.getContactsOpenIssues();
            AR.getTotalUndupeP();
            AR.getTotalUndupeK();
            test.stopTest();
        }
    }
    
}