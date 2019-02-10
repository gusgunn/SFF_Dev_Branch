@isTest

public class CaseMethodsTest {
    private static RecordType rTProfInteraction = [SELECT Id, Name FROM recordType WHERE Name = 'Professional Case' AND sObjectType = 'Case' LIMIT 1];
    private static RecordType rTFamInteraction = [SELECT Id, Name FROM recordType WHERE Name = 'Family Case' AND sObjectType = 'Case' LIMIT 1];
    private static RecordType rtAdultContact = [select Id from RecordType where Name = 'Adult' and SobjectType = 'Contact' LIMIT 1];//Grab all required fields?
    private static RecordType rtChildContact = [Select Id, Name from RecordType where Name = 'Child/Person With Disability'  and SobjectType = 'Contact' limit 1];
    public static RecordType rTIntakeSurvey = [SELECT Id, Name FROM recordType WHERE Name = 'Intake Survey' AND sObjectType = 'Case' LIMIT 1];
    public static RecordType rTSwFAF = [SELECT Id, Name FROM recordType WHERE Name = 'SW Family Assessment' AND sObjectType = 'Case' LIMIT 1];
    private static Profile SW = [SELECT Id, Name from Profile where name ='SFCD Social Worker' LIMIT 1];
    static private Integer numAccts = 2;
    static private Integer numContactsPerAcct = 2;
    static date beginDate = date.today()-15;
    static date endDate = date.today();  
    static datetime myDateTime = date.today();
    static datetime firstDate = datetime.newInstance(2016,1, 1);
    static dateTime ProfIntDate = date.today()-20;  
    static date bdate = date.today()-100; 
    static date stdDate = myDateTime.date();
    static date stdProfDate = ProfIntDate.date();
    
    
    // Given
    @testSetup static void createTestRecords() {
        
        List<case> cases= new List<Case>();
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave=true;
        
        Account testAccount = new Account(Name = 'Test Account');
        database.insert(testAccount, dml); 
        
        npo02__Household__c hh = new npo02__Household__c(Name='Family House' ,
                                                         npo02__MailingPostalCode__c ='94110',
                                                         First_Intake__c = beginDate, Last_Intake__c= beginDate,
                                                         Most_Recent_Household_Interaction__c=beginDate, First_Interaction__c=beginDate);
        
        database.insert(hh, dml);
        
        Contact testContact = new Contact(RecordTypeId = rtAdultContact.Id, LastName = 'TestContact', Error_Contact__c  = true, 
                                          Email = 'test@example.com', npo02__Household__c = hh.ID, 
                                          First_Interaction__c =beginDate, Last_Interaction_Date__c= beginDate);
        database.insert(testContact, dml); 
        
        Contact testProfContact = new Contact(RecordTypeId = rtAdultContact.Id, AccountID = testAccount.ID, 
                                              LastName = 'ProfContact', Family__Professional__c = True
                                             );
        database.insert(testProfContact, dml); 
        npo02__Household__c hh2 = new npo02__Household__c(Name='NoIntake Family House' ,
                                                          npo02__MailingPostalCode__c ='94110'
                                                         );
        
        database.insert(hh2, dml);
        
        Contact testContact2 = new Contact(RecordTypeId = rtAdultContact.Id, LastName = 'TestContact2', Error_Contact__c  = true, 
                                           Email = 'test2@example.com', npo02__Household__c = hh2.ID);
        database.insert(testContact2, dml); 
        
        Contact childTestContact2 = new Contact(FirstName='Kid' , 
                                                LastName='GaveConsent' , 
                                                RecordTypeID = rtChildContact.Id,
                                                Family__Primary_Language__c = 'Spanish',
                                                Family__Gender__c = 'Male',
                                                Birthdate = BDate,
                                                npo02__Household__c=hh2.id
                                               );
        database.insert(childTestContact2, dml); 
        
        String Key = (string.ValueOf(testAccount.Id) + string.ValueOf(childTestContact2.Id));
        Consent__c existingConsent = new Consent__c( Child__c = childTestContact2.ID, First_Interaction_Date__c = beginDate,
                                                    Professional_Contact__c =testProfContact.ID, Organization__c = testAccount.id);
        database.insert(existingConsent, dml); 
        
        String rtKey = (string.ValueOf(testProfContact.Id) + string.ValueOf(childTestContact2.Id));
        ReferralTracking__c existingReferralTrack = new ReferralTracking__c(key__c = rtKey, Household_Referred__c = hh2.Id, 
                                                                            Referral_Received_From__c= testProfContact.Id, 
                                                                            Child_Referred__c=childTestContact2.ID, cbx_Referral_Received__c =true,
                                                                            Date_Referral_Received__c = stdProfDate
                                                                           );
        database.insert(existingReferralTrack, dml); 
        
        
        Contact childTestContact = new Contact(FirstName='Abe' , 
                                               LastName='Becee' , 
                                               RecordTypeID = rtChildContact.Id,
                                               Family__Primary_Language__c = 'Spanish',
                                               Family__Gender__c = 'Female',
                                               Birthdate = BDate,
                                               npo02__Household__c=hh.id	
                                              );
        
        database.insert(childTestContact, dml); 
        
        
        Case case3 = new Case(ContactId = testContact.ID,
                              
                              Call_Type__c = 'Intake',
                              Origin = 'In-person',
                              Status = 'Closed',
                              Start_time__c = myDateTime,
                              Add_5_Mins_to_Start_Time_For_End_Time__c = 5,  
                              Family__Household__c = hh.ID,
                              Family__Child__c = childTestContact.id,
                              RecordTypeId = rTIntakeSurvey.Id);
        
        database.insert(case3, dml);
        Case case2 = new Case(ContactId = testContact.ID,
                              
                              Call_Type__c = 'Intake',
                              Origin = 'In-person',
                              Status = 'Closed',
                              Start_time__c = myDateTime,
                              Add_5_Mins_to_Start_Time_For_End_Time__c = 5,  
                              Family__Household__c = hh.ID,
                              Family__Child__c = childTestContact.id,
                              RecordTypeId = rTFamInteraction.Id);
        
        
        List<Case> casesAfterInsert =[ SELECT Id 
                                      From Case
                                      Where call_Type__c = 'Intake'];
        
        System.assertEquals(1, casesAfterInsert.size(), 'casesAfterInsert not right number bozo');
        database.insert(case2, dml);
    }   
    
    
    // Test Household that hasnt had Intake yet
    @isTest static void testMethodFAmilyNewInt() {
        
        List<Contact> kiddo = [SELECT Id, First_Interaction__c, Last_Interaction_Date__c, 
                               recordTypeID, npo02__Household__c, Family__Gender__c, 
                               npo02__Household__r.First_Intake__c, npo02__Household__r.Last_Intake__c
                               FROM Contact 
                               Where Family__Gender__c = 'Male'
                              ];
        List<Contact> dad = [SELECT Id, First_Interaction__c, Last_Interaction_Date__c, 
                             recordTypeID, npo02__Household__c, Family__Gender__c, 
                             npo02__Household__r.First_Intake__c, npo02__Household__r.Last_Intake__c
                             FROM Contact 
                             Where Email = 'test2@example.com'
                            ];
        
        List <npo02__Household__c>  house = [SELECT id, Last_Intake__c, First_Intake__c, 
                                             Most_Recent_Household_Interaction__c, First_Interaction__c
                                             FROM npo02__Household__c
                                             WHERE Id = :dad[0].npo02__Household__c
                                            ];
        
        
        System.assertEquals(1, house.size(), 'house not right number');  
        System.assertEquals(NULL, house[0].First_Intake__c, 'First_Intake__c incorrect. '); 
        System.assertEquals(NULL, house[0].Last_Intake__c, 'Last_Intake__c incorrect. '); 
        System.assertEquals(NULL, house[0].First_Interaction__c, 'First_Interaction__c incorrect. '); 
        System.assertEquals(NULL, house[0].Most_Recent_Household_Interaction__c, 'Most recent interaction incorrect. '); 
        
        Case case2 = new Case(ContactId = dad[0].ID,
                              Call_Type__c = 'Intake',
                              Origin = 'In-person',
                              Status = 'Closed',
                              Start_time__c = myDateTime,
                              Add_5_Mins_to_Start_Time_For_End_Time__c = 5,  
                              Family__Household__c = house[0].Id,
                              Family__Child__c = kiddo[0].Id,
       
                              RecordTypeId = rTFamInteraction.Id);
        insert case2;
       
        
        List <npo02__Household__c>  houseAfterIntake = [SELECT id, Last_Intake__c, First_Intake__c, 
                                                        Most_Recent_Household_Interaction__c, First_Interaction__c
                                                        FROM npo02__Household__c
                                                        WHERE Id = :kiddo[0].npo02__Household__c
                                                       ];
        
      /*  System.assertEquals(1, houseAfterIntake.size(), 'house not right number');  
        System.assertEquals(Null, houseAfterIntake[0].First_Intake__c, 'First_Intake__c incorrect. '); 
        System.assertEquals(stdDate, houseAfterIntake[0].Last_Intake__c, 'Last_Intake__c incorrect. '); 
        System.assertEquals(stdDate, houseAfterIntake[0].First_Interaction__c, 'First_Interaction__c incorrect. '); 
        System.assertEquals(stdDate, houseAfterIntake[0].Most_Recent_Household_Interaction__c, 'Most recent interaction incorrect. '); */
        
    }    
  
    /***  AND WHEN
*    Professional Case
* */
    @isTest static void testMethodProf() {
        List<Contact> Prof = [SELECT Id, First_Interaction__c, Last_Interaction_Date__c, 
                              Family__Professional__c, recordTypeID, AccountID
                              FROM Contact 
                              Where Family__Professional__c= True];
        
        List<Contact> kiddo = [SELECT Id, First_Interaction__c, Last_Interaction_Date__c, 
                               recordTypeID, npo02__Household__c, Family__Gender__c
                               FROM Contact 
                               Where recordTypeID = :rtChildContact.Id
                               AND  Family__Gender__c = 'Male'];
        
        Case caseP = new Case(ContactId = Prof[0].ID,
                              AccountID = Prof[0].AccountID,
                              Call_Type__c = 'Contact',
                              Origin = 'email',
                              Status = 'Closed',
                              Written_Consent_Date__c = beginDate,
                              Verbal_Consent_Date__c = endDate,
                              Start_time__c = ProfIntDate,
                              Add_5_Mins_to_Start_Time_For_End_Time__c = 5,  
                              Family__Household__c = kiddo[0].npo02__Household__c,
                              Family__Child__c = kiddo[0].id,
                              Relationship__c ='Social Worker',
                              RecordTypeId = rTProfInteraction.Id);
        test.startTest();
        try{
            
            insert caseP;
            
        } catch (DMLException e){
        }
        test.stopTest(); 
        
        // assert 2 cases toatl were inserted in this suite  
        List<Case> casesAfter2Inserts =[ SELECT Id , Family__Household__c
                                        From Case ];
        
        System.assertEquals(3, casesAfter2Inserts.size(), 'casesAfter2Inserts not right number');  
        
        // Prof Case particulars
        List<Case> profCasesAfterInserts =[ SELECT Id 
                                           From Case
                                           Where RecordTypeId = :rTProfInteraction.Id];
        
        System.assertEquals(1, profCasesAfterInserts.size(), 'ProfCasesAfterInserts not right number');  
        
        //  Assert Prof Contact & Child
        List<Contact> contactsAfterProfCase = [SELECT Id, First_Interaction__c, Last_Interaction_Date__c, Email,
                                               Family__Professional__c, recordTypeID, AccountID, Family__Gender__c
                                               FROM Contact
                                               Where Family__Gender__c ='Male'
                                               OR Family__Professional__c= true];
        
        for (Contact con: contactsAfterProfCase){
            
            // Boy in household has now had an interaction on stdProfDate.addDays(5)
            if(con.recordTypeID == rtChildContact.Id && con.Family__Gender__c =='Male'){
                //System.assertEquals(stdProfDate, con.First_Interaction__c, 'Child2 First ProfInteraction date not as expected'); 
                //System.assertEquals(stdProfDate, con.Last_Interaction_Date__c, 'Child2 Most recent ProfInteraction date not as expected'); 
                
                // Girl in household has still only had first interaction on MyDateTime
            }else if (con.recordTypeID == rtChildContact.Id && con.Family__Gender__c == 'Female'){
                System.assertEquals(stdDate, con.First_Interaction__c, 'Child1 First interaction date not as expected'); 
                System.assertEquals(stdDate, con.Last_Interaction_Date__c, 'Child1 Most recent interaction date not as expected'); 
                
                // Professional has had an interaction but only Family interactions are currently logged here
            }else if (con.Family__Professional__c == True){
                System.assertEquals(Null, con.First_Interaction__c, 'Prof First interaction date not as expected'); 
                System.assertEquals(Null, con.Last_Interaction_Date__c, 'Prof recent interaction date not as expected');
                // Adult in household no change-  no Interactions
            }else if (con.Email == 'test2@example.com'){
                System.assertEquals(Null, con.First_Interaction__c, 'Adult2 First interaction date not as expected'); 
                System.assertEquals(Null, con.Last_Interaction_Date__c, 'Adult2 recent interaction date not as expected');
                
                // Adult in household no change- had first  & Last interaction at beginDate in testsetup
            }else {
                System.assertEquals(beginDate, con.First_Interaction__c, 'Adult First interaction date not as expected'); 
                System.assertEquals(beginDate, con.Last_Interaction_Date__c, 'Adult Most recent interaction date not as expected ' ); 
            }
        }
        
        /*****                                         
* Test Household outcomes
* */
        
        /*****
*  Test Consent was made
*  Assert Consent was made for boy 
*  but not girl(no prof int)
* **/
        List <Consent__c> consents = [SELECT ID, Child__c, Child__r.LastName, Professional_Contact__r.LastName,
                                      Household__r.Name, Organization__r.Name,
                                      Written_Consent_Date__c, Verbal_Consent_Date__c
                                      FROM Consent__c];
        
        // Assert there is only 1 consent, for the boy and the prof
        System.assertEquals(1, consents.size(), 'consents made should = 1');
        System.assertEquals('GaveConsent', consents[0].Child__r.LastName, 'Kid Name who gave consent not right');
        System.assertEquals('ProfContact', consents[0].Professional_Contact__r.LastName, 'Prof Name who gave consent not right');
        System.assertEquals('Test Account', consents[0].Organization__r.Name, 'Org Name in consent not right');
       // System.assertEquals(Null, consents[0].Household__r.Name, 'Child HH Name who gave consent not right');
       //  System.assertEquals(endDate, consents[0].Verbal_Consent_Date__c, 'Child Verbal_Consent_Date__c Name who gave consent not right');
       // System.assertEquals(beginDate, consents[0].Written_Consent_Date__c, 'Child Verbal_Consent_Date__c Name who gave consent not right');
        
    }
    
    
    
    @isTest static void testMethodProfException() {     
        test.startTest();
        List <Case> cases = new List <Case>();
        List<Contact> Prof = [SELECT Id, First_Interaction__c, Last_Interaction_Date__c, 
                              Family__Professional__c, recordTypeID, AccountID
                              FROM Contact 
                              Where Family__Professional__c= True];
        
        List<Contact> kiddo = [SELECT Id, First_Interaction__c, Last_Interaction_Date__c, 
                               recordTypeID, npo02__Household__c, Family__Gender__c
                               FROM Contact 
                               Where recordTypeID = :rtChildContact.Id
                               AND  Family__Gender__c = 'Male'];
        
        case casep = new Case(ContactId = Prof[0].ID,
                              AccountID = Prof[0].AccountID,
                              Call_Type__c = 'Contact',
                              Origin = 'In-person',
                              Status = 'Closed',
                              Written_Consent_Date__c = beginDate,
                              Verbal_Consent_Date__c = endDate,
                              Start_time__c = mydateTime,
                              Add_5_Mins_to_Start_Time_For_End_Time__c = 5,  
                              Family__Household__c = kiddo[0].npo02__Household__c,
                              Family__Child__c = kiddo[0].id,
                              Relationship__c ='Social Worker',
                              RecordTypeId = rTProfInteraction.Id);
        
        cases.add(caseP);
        insert cases;
        Map<Integer, List<case>> workerMap = new Map<Integer, List<case>>();
        Map<Integer, List<case>> workerUpsertMap = new Map<Integer, List<case>>();
        
        
        Map<Integer, List<sObject>> indexToObjects = new Map<Integer, List<SObject>>();
        indexToObjects.put(1, cases);
        
        CaseDispatcher.getDispatch(cases);
      
        CaseMethods.getDispatch(cases);
        //worker.testingException = true;
        // System.enqueueJob(new Worker(workerMap, 1));
        
        test.stopTest();
    }
    
    @isTest static void testMethodBulk() {
        List <Case> CaseBulkTest = new List <Case>();
        List<Contact> Prof = [SELECT Id, First_Interaction__c, Last_Interaction_Date__c, 
                              Family__Professional__c, recordTypeID, AccountID
                              FROM Contact 
                              Where Family__Professional__c= True];
        
        List<Contact> kiddo = [SELECT Id, First_Interaction__c, Last_Interaction_Date__c, 
                               recordTypeID, npo02__Household__c, Family__Gender__c
                               FROM Contact 
                               Where recordTypeID = :rtChildContact.Id
                               AND  Family__Gender__c = 'Male'];
        
        Case caseP = new Case(ContactId = Prof[0].ID,
                              AccountID = Prof[0].AccountID,
                              Call_Type__c = 'Contact',
                              Origin = 'In-person',
                              Status = 'Closed',
                              Written_Consent_Date__c = beginDate,
                              Verbal_Consent_Date__c = endDate,
                              Start_time__c = ProfIntDate,
                              Add_5_Mins_to_Start_Time_For_End_Time__c = 5,  
                              Family__Household__c = kiddo[0].npo02__Household__c,
                              Family__Child__c = kiddo[0].id,
                              Relationship__c ='Social Worker',
                              RecordTypeId = rTProfInteraction.Id);
        CaseBulkTest.add(caseP);
        
        Case casec = new Case(ContactId = Prof[0].ID,
                              AccountID = Prof[0].AccountID,
                              Call_Type__c = 'Contact',
                              Origin = 'In-person',
                              Status = 'Closed',
                              Written_Consent_Date__c = beginDate,
                              Verbal_Consent_Date__c = endDate,
                              Start_time__c = ProfIntDate,
                              Add_5_Mins_to_Start_Time_For_End_Time__c = 5,  
                              Family__Household__c = kiddo[0].npo02__Household__c,
                              Family__Child__c = kiddo[0].id,
                              Relationship__c ='Social Worker',
                              RecordTypeId = rTProfInteraction.Id);
        CaseBulkTest.add(casec);
        test.startTest();
        try{
            
            insert CaseBulkTest;
            Map<Integer, List<case>> workerMap = new Map<Integer, List<case>>();
            Map<Integer, List<case>> workerUpsertMap = new Map<Integer, List<case>>();
            
            
            Map<Integer, List<sObject>> indexToObjects = new Map<Integer, List<SObject>>();
            Integer Index = 0;
            indexToObjects.put(Index, CaseBulkTest);
            Index+=1;
            indexToObjects.put(Index, CaseBulkTest);
            
            Integer startingIndex=0;
            
            // workerUpsertMap = CaseDispatcher.getDispatch(CaseBulkTest);
            
            System.enqueueJob(new WorkerUpsert(indexToObjects, startingIndex));
            
            
        } catch (DMLException e){
        }
        test.stopTest(); 
    }  
    
    @isTest static void testMethodFAmilyReferralTracking() {
        
        Map <Integer, String> esMap =  new Map <Integer, String>{0 =>  'Contact' , 1 =>'FRS 1 wk', 2 => 'FRS 2 mo', 
            3 =>'Left Message 1', 4 => 'Left Message 2', 5 => 'Sent UTC Letter', 
            6 =>'Intake', 7 =>'Contact', 8 => 'Mtg SDSE –Resolution Session', 
            9 => 'FRS 1 wk', 10 =>'Sent UTC Letter',11 =>'Mtg SDSE –Resolution Session'}; 
                
                List<Contact> kiddo = [SELECT Id, First_Interaction__c, Last_Interaction_Date__c, 
                                       recordTypeID, npo02__Household__c, Family__Gender__c, 
                                       npo02__Household__r.First_Intake__c, npo02__Household__r.Last_Intake__c
                                       FROM Contact 
                                       Where Family__Gender__c = 'Male'
                                      ];
        List<Contact> dad = [SELECT Id, First_Interaction__c, Last_Interaction_Date__c, 
                             recordTypeID, npo02__Household__c, Family__Gender__c, 
                             npo02__Household__r.First_Intake__c, npo02__Household__r.Last_Intake__c
                             FROM Contact 
                             Where Email = 'test2@example.com'
                            ];
        
        List <npo02__Household__c>  house = [SELECT id, Last_Intake__c, First_Intake__c, 
                                             Most_Recent_Household_Interaction__c, First_Interaction__c
                                             FROM npo02__Household__c
                                             WHERE Id = :kiddo[0].npo02__Household__c
                                            ];
        
        
        System.assertEquals(1, house.size(), 'house not right number');  
        System.assertEquals(NULL, house[0].First_Intake__c, 'First_Intake__c incorrect. '); 
        System.assertEquals(NULL, house[0].Last_Intake__c, 'Last_Intake__c incorrect. '); 
        System.assertEquals(NULL, house[0].First_Interaction__c, 'First_Interaction__c incorrect. '); 
        System.assertEquals(NULL, house[0].Most_Recent_Household_Interaction__c, 'Most recent interaction incorrect. '); 
        List<Case> cases = new List<Case>();
        for (Integer j=0;j<12;j++) {
            cases.add(new Case(ContactId = dad[0].ID,
                               Call_Type__c = esMap.get(j),
                               Origin = 'In-person',
                               Status = 'Closed',
                               Start_time__c = ProfIntDate.addDays(j),
                               Add_5_Mins_to_Start_Time_For_End_Time__c = 5,  
                               Family__Household__c = house[0].ID,
                               Family__Child__c = kiddo[0].id,
                               RecordTypeId = rTFamInteraction.Id));
        }
        test.startTest();
        try{
            
            insert cases;
            
            
        } catch (DMLException e){
            System.debug(' Insert Failed');
        }
        test.stopTest();
    }
    
    @isTest static void testMethodSWNewInt() {
        
        Profile testProfile = [SELECT Id 
                               FROM profile
                               WHERE Name = 'SFCD Social Worker' 
                               LIMIT 1];
        
        User testUser = new User(LastName = 'test user 1', 
                                 Username = 'test.user.1@example.com', 
                                 Email = 'test.1@example.com', 
                                 Alias = 'testu1', 
                                 TimeZoneSidKey = 'GMT', 
                                 LocaleSidKey = 'en_GB', 
                                 EmailEncodingKey = 'ISO-8859-1', 
                                 ProfileId = testProfile.Id, 
                                 LanguageLocaleKey = 'en_US');   
        
        System.runas(testUser) {
            
            List<Contact> kiddo = [SELECT Id, First_Interaction__c, Last_Interaction_Date__c, 
                                   recordTypeID, npo02__Household__c, Family__Gender__c, 
                                   npo02__Household__r.First_Intake__c, npo02__Household__r.Last_Intake__c
                                   FROM Contact 
                                   Where Family__Gender__c = 'Male'
                                  ];
            List<Contact> dad = [SELECT Id, First_Interaction__c, Last_Interaction_Date__c, 
                                 recordTypeID, npo02__Household__c, Family__Gender__c, 
                                 npo02__Household__r.First_Intake__c, npo02__Household__r.Last_Intake__c
                                 FROM Contact 
                                 Where Email = 'test2@example.com'
                                ];
            
            List <npo02__Household__c>  house = [SELECT id, Last_Intake__c, First_Intake__c, 
                                                 Most_Recent_Household_Interaction__c, First_Interaction__c,
                                                 Most_Recent_HH_Interaction_Call_Type__c, First_Family_Assessment__c,
                                                 Most_Recent_Family_Assessment__c, First_Intake_Survey__c, Most_Recent_Intake_Survey__c
                                                 FROM npo02__Household__c
                                                 WHERE Id = :kiddo[0].npo02__Household__c
                                                ];
            
            
            System.assertEquals(1, house.size(), 'house not right number');  
            System.assertEquals(NULL, house[0].First_Intake__c, 'First_Intake__c incorrect. '); 
            System.assertEquals(NULL, house[0].Last_Intake__c, 'Last_Intake__c incorrect. '); 
            System.assertEquals(NULL, house[0].First_Interaction__c, 'First_Interaction__c incorrect. '); 
            System.assertEquals(NULL, house[0].Most_Recent_Household_Interaction__c, 'Most recent interaction incorrect. '); 
            list<Case> testNewCaseRTs = new List<Case>();
            Case case2 = new Case(ContactId = dad[0].ID,
                                  Call_Type__c = 'Contact',
                                  Origin = 'In-person',
                                  Status = 'Closed',
                                  Start_time__c = myDateTime,
                                  Add_5_Mins_to_Start_Time_For_End_Time__c = 5,  
                                  Family__Household__c = house[0].ID,
                                  Family__Child__c = kiddo[0].id,
                                  RecordTypeId = rTSwFAF.Id);
            
            testNewCaseRTs.add(case2);
            Case case3 = new Case(ContactId = dad[0].ID,
                                  Call_Type__c = 'Contact',
                                  Origin = 'In-person',
                                  Status = 'Closed',
                                  Start_time__c = myDateTime,
                                  Add_5_Mins_to_Start_Time_For_End_Time__c = 5,  
                                  Family__Household__c = house[0].ID,
                                  Family__Child__c = kiddo[0].id,
                                  RecordTypeId = rTIntakeSurvey.Id);
            testNewCaseRTs.add(case3);
            Case case4 = new Case(ContactId = dad[0].ID,
                                  Call_Type__c = 'Contact',
                                  Origin = 'In-person',
                                  Status = 'Closed',
                                  Start_time__c = firstDate,
                                  Add_5_Mins_to_Start_Time_For_End_Time__c = 5,  
                                  Family__Household__c = house[0].ID,
                                  Family__Child__c = kiddo[0].id,
                                  RecordTypeId = rTFamInteraction.Id);
            testNewCaseRTs.add(case4);
            Case case5 = new Case(ContactId = dad[0].ID,
                                  Call_Type__c = 'Contact',
                                  Origin = 'In-person',
                                  Status = 'Closed',
                                  Start_time__c = myDateTime,
                                  Add_5_Mins_to_Start_Time_For_End_Time__c = 5,  
                                  Family__Household__c = house[0].ID,
                                  Family__Child__c = kiddo[0].id,
                                  RecordTypeId = rTFamInteraction.Id);
            
            
            test.startTest();
            try{
                
                insert testNewCaseRTs;
                insert case5;
                
                
            } catch (DMLException e){
                System.debug('No Intake Case Insert Failed');
            }
            test.stopTest();
            
            List <npo02__Household__c>  houseAfterInteractions  = [SELECT id, Last_Intake__c, First_Intake__c, 
                                                                   Most_Recent_Household_Interaction__c, First_Interaction__c,
                                                                   Most_Recent_HH_Interaction_Call_Type__c, First_Family_Assessment__c,
                                                                   Most_Recent_Family_Assessment__c, First_Intake_Survey__c, Most_Recent_Intake_Survey__c,
                                                                   First_SW_HH_Interaction__c, Most_Recent_SW_HH_Interaction__c
                                                                   FROM npo02__Household__c
                                                                   WHERE Id = :kiddo[0].npo02__Household__c
                                                                  ];
            
            //async testing 
            //System.assertEquals(firstDate, houseAfterInteractions[0].Most_Recent_SW_HH_Interaction__c, 'Most_Recent_SW_HH_Interaction__c not the one inserted. '); 
            //System.assertEquals(firstDate, houseAfterInteractions[0].First_SW_HH_Interaction__c, 'First_SW_HH_Interaction__c not the one inserted. '); 
            //System.assertEquals(myDateTime, houseAfterInteractions[0].Last_Intake__c, 'Last_Intake__c  '); 
            //System.assertEquals(Null, houseAfterInteractions[0].Most_Recent_Household_Interaction__c, 'Most recent interaction Not Null '); 
            //System.assertEquals(Null, houseAfterInteractions[0].First_Interaction__c, ' First interactionnot  Null '); 
            
        }    
    }
}