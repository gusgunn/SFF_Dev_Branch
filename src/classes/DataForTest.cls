@isTest
public class DataForTest {
    
    // Call DataFor_Test.createTestAccWithCons(2,2)
    // Invoice_Statement__c  obj = TestDataFactory .createOneInvoiceStatement(true);
    // public Static Void for inserts/updates
    // public static for returns
    
    public static RecordType rtProgramCampaign = [Select Id, Name from RecordType where Name = 'Program Campaign'  AND sObjectType = 'Campaign' limit 1];
    public static RecordType rtChildcare = [Select Id, Name from RecordType where Name = 'Childcare' AND sObjectType = 'Campaign' limit 1];
    //Private static RecordType rtDefault = [Select Id, Name from RecordType where Name = 'Default'AND sObjectType = 'Campaign' limit 1];
    public static RecordType rtAdultContact = [select Id from RecordType where Name = 'Adult' and SobjectType = 'Contact' LIMIT 1];//Grab all required fields?
    public static RecordType rtChildContact = [Select Id, Name from RecordType where Name = 'Child/Person With Disability'  and SobjectType = 'Contact' limit 1];
    public static RecordType rtFamilyInteraction = [Select Id, Name from RecordType where Name = 'Family Case' AND sObjectType = 'Case' limit 1];
    public static RecordType rtProfessionalInteraction = [Select Id, Name from RecordType where Name = 'Professional Case' AND sObjectType = 'Case' limit 1];
    public static RecordType actionRT = [SELECT Id, Name FROM recordType WHERE Name = 'Internal Referral' AND sObjectType = 'Action__c' LIMIT 1];
    public static RecordType actionExternalRT = [SELECT Id, Name FROM recordType WHERE Name = 'External Referral' AND sObjectType = 'Action__c' LIMIT 1];
    public static date NewDate = date.newInstance(2017, 3, 1);
    static date BDate = date.newInstance(2016, 7, 1);
    
    
    //Essential Measures Map
    public static Map <Integer, String> esMap =  new Map <Integer, String>{0 =>  'ES3' , 1 =>'ES1', 2 => 'ES2', 
        3 =>'ES3', 4 => 'ES1', 5 => 'ES2', 
        6 =>'ES3', 7 =>'ES2', 8 => 'ES1', 
        9 => 'ES3', 10 =>'ES2',11 =>'ES1'}; 
            
            public static Map <Integer, String> CaseCallTypeMap =  new Map <Integer, String>{0 =>  'Intake' , 1 =>'Contact', 2 => 'Left Message' 
                /* 3 =>'ES3', 4 => 'ES1', 5 => 'ES2', 
6 =>'ES3', 7 =>'ES2', 8 => 'ES1', 
9 => 'ES3', 10 =>'ES2',11 =>'ES1'*/
                }; 
                    
                    //Public Static insertTestData(){
                    //Database.DMLOptions dml = new Database.DMLOptions();
                    //dml.DuplicateRuleHeader.allowSave = true;
                    
                    //}
                    
                    public static List <Contact> createFamilies( Integer numAcc, Integer conPerAcc){
                        Database.DMLOptions dml = new Database.DMLOptions();
                        dml.DuplicateRuleHeader.allowSave = true;
                        List <Contact> familyContacts =new List<Contact>();
                        
                        List<Account> testConAccHH = createTestAccounts(numAcc, conPerAcc);
                        List <npo02__Household__c> testConHH = createHouseholds(numAcc, conPerAcc);
                        List <Contact> testContacts = createContacts(numAcc, conPerAcc, testConAccHH, testConHH );
                        familyContacts.addAll(testContacts);
                        List <Contact> testKids = createKids(numAcc, conPerAcc, testConAccHH, testConHH);
                        familyContacts.addAll(testKids);
                        
                        return familyContacts;
                        
                    }
    private static List <Account> createTestAccounts( Integer numAcc, Integer conPerAcc){
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        
        List <Account> accList = new List <Account>();
        for(Integer i = 0; i< numAcc; i++){
            accList.add(new Account(Name='ABC Acc' + String.ValueOf(i), Include_in_Resource_Guide__c = true, 
                                    Category__c='Adult Services', Email__c= String.ValueOf(i)+'xyz@test.com'));
        }
        database.insert(accList, dml);
        return accList;
    }
    public static List<npo02__Household__c> createHouseholds(Integer numAcc, Integer conPerAcc){
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        
        List<npo02__Household__c> hhList = new List<npo02__Household__c>();
        for(Integer i = 0; i< numAcc; i++){
            hhList.add(new npo02__Household__c(Name='House-' + String.ValueOf(i),
                                               npo02__MailingPostalCode__c ='94110'));
        }
        database.insert(hhList, dml);
        return hhList;
    }
    
    private static List<Contact> createContacts(Integer numAcc, Integer conPerAcc, List<Account> accList, List<npo02__Household__c> hhList) {
        
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        List <Contact> conList = new List <Contact>();
        for(Account a: accList){
            for(Integer i = 0; i< conPerAcc; i++){
                npo02__Household__c h = hhList[i]; 
                conList.add( new Contact (FirstName='Adult' +  String.ValueOf(i), 
                                          LastName='Becee' + String.ValueOf(i), 
                                          RecordTypeID = rtAdultContact.Id,
                                          Family__Primary_Language__c = 'Spanish',
                                          Family__Gender__c = 'Female',
                                          Underserved__c= TRUE,
                                          Low_Income__c= TRUE,
                                          Income__c = 'Homeless',
                                          Housing_Status__c ='Vehicle',
                                          MailingPostalCode = '94124',
                                          lep__c = 'Declined',
                                          Incarcerated_youth__c = True,
                                          npo02__Household__c=h.id,
                                          Last_Interaction_Date__c = BDate,
                                          AccountID= a.Id));
                
            }
        }
        Database.insert(conlist, dml);
        return conList;
    }
    
    public static List<Contact> createOnlyContacts(Integer numAcc) {
        
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        List <Contact> conOnlyList = new List <Contact>();
        
        for(Integer i = 0; i< numAcc; i++){
            
            conOnlyList.add( new Contact (FirstName='Adult' +  String.ValueOf(i), 
                                          LastName='Becee' + String.ValueOf(i), 
                                          RecordTypeID = rtAdultContact.Id,
                                          //Family__Primary_Language__c = 'Spanish',
                                          Family__Gender__c = 'Female',
                                          Underserved__c= TRUE,
                                          Low_Income__c= TRUE,
                                          Income__c = 'Homeless',
                                          Housing_Status__c ='Vehicle',
                                          MailingPostalCode = '94124',
                                          Last_Interaction_Date__c = BDate
                                         ));
        }    
        
        Database.insert(conOnlylist, dml);
        return conOnlyList;
    }
    
    private static List <Contact> createKids(Integer numAcc, Integer conPerAcc, List<Account> accList, List<npo02__Household__c> hhList){
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        List <Contact> ChildConlist = new List <Contact>();
        
        for(Integer i = 0; i< conPerAcc; i++){
            npo02__Household__c h = hhList[i]; 
            ChildConlist.add( new Contact (FirstName='Kid' +  String.ValueOf(i), 
                                           LastName='Becee' + String.ValueOf(i), 
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
                                           npo02__Household__c=h.id));
            
        }
        
        Database.insert(ChildConlist, dml);
        return ChildConlist;
    }
    
    public static User getTestUser(){
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        User u = new User(Alias = 'JD',
                          Email = 'jd@TestGTest.com',
                          FirstName = 'Jack',
                          LastName = 'fried',
                          TimeZoneSidKey = 'America/Los_Angeles',
                          UserName = 'jd@TestGTest.com',
                          ProfileID = UserInfo.getProfileId(),
                          LocaleSidKey = 'en_US',
                          EmailEncodingKey = 'UTF-8',
                          LanguageLocaleKey = 'en_US');
        
        Database.insert(u, dml);
        return u;
    }
    
    /*****************************************************************
* Campaigns And Members
* ********************************************************************/    
    public static void CreateCampaignAndMembers(){    
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        
        Contact c = new Contact(lastname='x');
        Database.insert(c, dml);
        
        // RecordType rt1 = [Select Id, Name from RecordType where Name = 'Program Campaign' limit 1];
        
        Campaign camp1 = new campaign();
        camp1.RecordTypeId = rtProgramCampaign.ID;
        camp1.Name = 'Program Campaign Test';
        camp1.IsActive = TRUE;
        camp1.StartDate = System.Today();
        
        Database.insert(camp1, dml);
        System.assert([SELECT Count() FROM Campaign] == 1,'Error, One Campaign Expexted');
        
        CampaignMember cmb = new CampaignMember();
        cmb.campaignID=camp1.id;
        cmb.flag__c =true;
        cmb.contactid = c.id;
        cmb.status = 'Family Attendee';
        
        Database.insert(cmb, dml);
        CampaignMember cMem =[SELECT status FROM CampaignMember where Id =: cmb.Id ];
        System.assert([SELECT Count() FROM CampaignMember] == 1,'Error, One CampaignMember Expexted');
        System.AssertEquals('Family Attendee', cMem.Status, 'Error, expected Family Attendee ');
        
        CampaignMemberStatus cms1 = new CampaignMemberStatus();
        cms1.Label = 'Family Attendee';
        cms1.CampaignId = camp1.Id;
        cms1.SortOrder = 3;
        Database.insert(cms1, dml);
        CampaignMemberStatus cm2 = [SELECT label FROM CampaignMemberStatus WHERE ID=:cms1.ID];
        System.AssertEquals('Family Attendee', cm2.label, 'Error, expected Family Attendee ');
        
    }
    
    public static List <Case> createFamilyCasesForOneFamily(Integer numCases ){
        createFamilies(1, 1);
        
        
        Contact  parentCnt = [SELECT Id, npo02__Household__c FROM Contact WHERE RecordTypeID =: rtAdultContact.Id  Limit 1];
        Contact  kidCnt = [SELECT Id, npo02__Household__c FROM Contact WHERE RecordTypeID =: rtChildContact.Id Limit 1];
        
        
        List<case> testCases = new List<case>();
        
        integer m =0;
        for (Integer jc=0;jc<numCases;jc++) {
            if(m>2){
                m=0;
            }Else{
                m++;
            }
            
            Datetime myDateTime = Datetime.newInstance(2017,2, 1);
            
            testCases.add(new Case(ContactId = parentCnt.Id,
                                   Call_Type__c = 'Contact', 
                                   Origin = 'In-person',
                                   Status = 'Closed',
                                   Family__Household__c = kidCnt.npo02__Household__c,
                                   Start_time__c = myDateTime.addDays(jc + numCases),
                                   Add_5_Mins_to_Start_Time_For_End_Time__c = 5,
                                   Family__Child__c = kidCnt.ID,
                                   RecordTypeId = DataForTest.rtFamilyInteraction.id));
            
        }
        insert testCases;
        System.assertEquals(numCases, testCases.size());
        
        return testCases;
    }
    
    public static List <Case> createProfCasesForOneFamily(Integer numCases ){
        createFamilies(1, 1);
        
        
        Contact  parentCnt = [SELECT Id, npo02__Household__c FROM Contact WHERE RecordTypeID =: rtAdultContact.Id  Limit 1];
        Contact  kidCnt = [SELECT Id, npo02__Household__c FROM Contact WHERE RecordTypeID =: rtChildContact.Id Limit 1];
        
        
        List<case> testCases = new List<case>();
        
        integer m =0;
        for (Integer jc=0;jc<numCases;jc++) {
            if(m>2){
                m=0;
            }Else{
                m++;
            }
            
            Datetime myDateTime = Datetime.newInstance(2017,2, 1);
            
            testCases.add(new Case(ContactId = parentCnt.Id,
                                   Call_Type__c = CaseCallTypeMap.get(m), 
                                   Origin = 'In-person',
                                   Status = 'Closed',
                                   Family__Household__c = kidCnt.npo02__Household__c,
                                   Start_time__c = myDateTime.addDays(jc + numCases),
                                   Add_5_Mins_to_Start_Time_For_End_Time__c = 5,
                                   Family__Child__c = kidCnt.ID,
                                   RecordTypeId = DataForTest.rtProfessionalInteraction.id));
            
        }
        insert testCases;
        System.assertEquals(numCases, testCases.size());
        
        return testCases;
    }
    
    /*** * Issues*****************/
    
    
    private static CreateIssue__c CustomSettings(){
        
        CreateIssue__c ci = new CreateIssue__c();
        ci.Name = 'Default';
        ci.NewIssueURL_1__c = '/a0p/e?&Name=New&retURL=/apex/ManageIssues?Id={!interaction.id}&saveURL=/apex/ManageIssues?Id={!interaction.id}&CF00NG000000Az3xN_lkid=0031100000AnhTa&CF00NG000000Az3xN={!interaction.contactname}&CF00NG000000Ax28T=';
        ci.NewIssueURL_2__c = '{!interaction.childcontact}&CF00NG000000Ax28T_lkid={!interaction.Family__Child__c}&CF00NG000000AyxaG={!interaction.CaseNumber}&CF00NG000000AyxaG_lkid={!interaction.id}&00NG000000Ax23c=New';
        insert ci;
        return ci;
    }
    
    public static List<Issue__c> GetIssueRecords(){
        // Makes 3 issues
        List <Case> cases = createFamilyCasesForOneFamily(5);     
        Contact parentCnt = [SELECT Id FROM Contact WHERE RecordTypeID =: rtAdultContact.Id Limit 1];
        Case record = [SELECT Id FROM CASE Limit 1];
        
        List<Issue__c> Issues = new List<Issue__c>();
        
        Issue__c issue1 = new Issue__c(Type_of_Issue__c = 'Assessment', Status__c = 'Pending', Issue_Contact__c = parentCnt.Id, Interaction_Log__c = record.Id );
        Issue__c issue2 = new Issue__c(Type_of_Issue__c = 'Behavior', Status__c = 'New', Issue_Contact__c = parentCnt.Id, Interaction_Log__c = record.Id);
        Issue__c issue3 = new Issue__c(Type_of_Issue__c = 'Assessment', Status__c = 'New', Issue_Contact__c = parentCnt.Id, Interaction_Log__c = record.Id);
        
        Issues.add(issue1);
        Issues.add(issue2);
        Issues.add(issue3);
        insert Issues;
        return Issues;
    }
    
    public static List <Action__c> createActions(){
        //GetIssueRecords();
        //List <Issue__c> testIssue = [SELECT Id, Name, Caller_Name__c, Status__c, Issue_Contact__c, Type_of_Issue__c, Opened_Date__c FROM Issue__c LIMIT 1];
        Contact testContact = new Contact(RecordTypeId = rtAdultContact.Id, LastName = 'Test Contact');
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
        List <Action__c> insertActions = new list <Action__c>();	
        Action__c testAction = new Action__c(recordTypeId = actionRt.Id, Caller_Name__c = testContact.id, Action_Status__c = 'test',
                                             Referral_Date__c = date.Today(), Referral_Organization__c = testAccount.id,
                                             issues__c = testIssue.Id, 
                                             Action_Detail_Type_Internal_Referral__c= 'Received Referral to SFCD;Referral Thank You;Referral Contact Confirmation');
        insertActions.add(testAction);
        Action__c testActionDupeKey = new Action__c(recordTypeId = actionRt.Id, Caller_Name__c = testContact.id, Action_Status__c = 'test',
                                                    Referral_Date__c = date.Today(), Referral_Organization__c = testAccount.id,
                                                    issues__c = testIssue.Id, 
                                                    Action_Detail_Type_Internal_Referral__c= 'Referral Update;Referral Contact UTC');
        //Action_Detail_Type_Information__c = 'test', Action_Detail_Type_External_Referral__c = 'test'									 
        insertActions.add(testActionDupeKey);	
        
        
        F2F_Outcomes_Key__c testOutcome2 = new F2F_Outcomes_Key__c();
        insert testOutcome2;
        return insertActions; 
        
    } 
    
    public static List<Issue__c> testSetupCoreObjects()  {
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave=true; 
          List<Issue__c> issuesList= new List<Issue__c>();
        User ux = getTestUser();
        //  = [SELECT ID FROM USER WHERE ID =: x.OwnerId];
        System.runAs(ux) {
            npo02__Household__c hh = new npo02__Household__c(Name='House-' ,
                                                             npo02__MailingPostalCode__c ='94110');
            
            database.insert(hh, dml);
            
            
            Contact testContact = new Contact(RecordTypeId = rtAdultContact.Id,
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
                                                   npo02__Household__c=hh.id	
                                                  );
            
            database.insert(childTestContact, dml); 
            
            
            Datetime myDateTime = Datetime.newInstance(2016,9, 30);
            Case case1 = new Case(ContactId = testContact.ID,
                                  Call_Type__c = 'Contact',
                                  Origin = 'In-person',
                                  Status = 'Closed',
                                  Start_time__c = myDateTime,
                                  Add_5_Mins_to_Start_Time_For_End_Time__c = 5,                            
                                  Family__Child__c = childTestContact.Id
                                 );
            
            database.insert(case1, dml);
                                 
            Issue__c testIssue = new Issue__c(Name = 'Test Issue',  Caller_Name__c = testContact.id, Status__c = 'test',
                                              Issue_Contact__c = childTestContact.id, Interaction_Log__c = case1.Id, Type_of_Issue__c = 'AAC', 
                                              Opened_Date__c = date.Today());
            
            issuesList.add(testIssue);
            database.insert(issuesList, dml);
   
        } 
            return issuesList;
    }
    
}