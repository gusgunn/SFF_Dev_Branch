@isTest
public class CPIRAge_Test {
    static private Integer numAccts = 9;
    static private Integer numContactsPerAcct = 9;
    static date beginDate = date.newInstance(2016, 1, 1);
    static date endDate = date.newInstance(2016, 12, 30);    
    
    Public static boolean  testingException;
    Private static RecordType rTProfInteraction = [SELECT Id, Name FROM recordType WHERE Name = 'Professional Case' AND sObjectType = 'Case' LIMIT 1];
    Private static RecordType rTFamInteraction = [SELECT Id, Name FROM recordType WHERE Name = 'Family Case' AND sObjectType = 'Case' LIMIT 1];
    Private static RecordType rtAdultContact = [select Id from RecordType where Name = 'Adult' and SobjectType = 'Contact' LIMIT 1];//Grab all required fields?
    Private static RecordType rtChildContact = [Select Id, Name from RecordType where Name = 'Child/Person With Disability'  and SobjectType = 'Contact' limit 1];
    
    
    
    static datetime myDateTime = date.today()-1;//datetime.newInstance(2017,9, 1);
    static datetime firstIntakeDate = date.today()-1000;
    static date bday = date.newInstance(1998, 6, 30);  
    static date bdate = date.today()-400;
    
    static private Integer Counter = 200;
    
    
    @testSetup static void createTestRecords() {
        
        //caseMethods.testingException = true;
        List<case> cases= new List<Case>();
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave=true;
        
        Account testAccount = new Account(Name = Counter +'MethodsAccount');
        database.insert(testAccount, dml); 
        
        npo02__Household__c hh = new npo02__Household__c(Name= Counter +'MyNewCaseHouse' ,
                                                         npo02__MailingPostalCode__c ='94110'
                                                         //First_Intake__c = beginDate, Last_Intake__c= beginDate,
                                                         // Most_Recent_Household_Interaction__c=beginDate, First_Interaction__c=beginDate
                                                        );
        
        database.insert(hh, dml);
        
        Contact testProfContact = new Contact(RecordTypeId = rtAdultContact.Id, AccountID = testAccount.ID, 
                                              LastName = Counter + 'ProfContact CaseTest', Family__Professional__c = True
                                             );
        database.insert(testProfContact, dml); 
        
        Contact testContact = new Contact(RecordTypeId = rtAdultContact.Id, LastName = Counter + 'Contact  CaseTest', Error_Contact__c  = true, 
                                          Email = Counter + 'nnmw@example.com', npo02__Household__c = hh.ID 
                                          //First_Interaction__c =beginDate, Last_Interaction_Date__c= beginDate
                                         );
        database.insert(testContact, dml); 
        
        Contact childTestContact2 = new Contact(FirstName='Kid' , 
                                                LastName='ConsentTest' + Counter , 
                                                RecordTypeID = rtChildContact.Id,
                                                Family__Primary_Language__c = 'Spanish',
                                                Family__Gender__c = 'Female',
                                               // Birthdate = BDate,
                                                npo02__Household__c=hh.id
                                                //First_Interaction__c = endDate 
                                                // Last_Interaction_Date__c= endDate
                                               );
        database.insert(childTestContact2, dml);   
        /*    
String Key = string.ValueOf(testAccount.Id) + string.ValueOf(childTestContact2.Id);
Consent__c existingConsent = new Consent__c( Child__c = childTestContact2.ID, Professional_Contact__c = testProfContact.ID, 
Organization__c = testAccount.Id); //Written_Consent_Date__c = beginDate,
database.insert(existingConsent, dml); */
        
        Contact childTestContact = new Contact(FirstName='Kid' , 
                                               LastName='CaseTest'+ Counter, 
                                               RecordTypeID = rtChildContact.Id,
                                               Family__Primary_Language__c = 'Spanish',
                                               Family__Gender__c = 'Female',
                                               Birthdate = BDate,
                                               //schooltype etc
                                               // Underserved__c= TRUE,
                                               //  Low_Income__c= TRUE,
                                               // Income__c = 'Homeless',
                                               // Housing_Status__c ='Vehicle',
                                               MailingPostalCode = '94124',
                                               //lep__c = 'Declined',
                                               //Incarcerated_youth__c = True,
                                               npo02__Household__c=hh.id	
                                              );
        
        database.insert(childTestContact, dml); 
        list <Case> Casebulk = New List <Case>();
        Case caseP = new Case(ContactId =testContact.ID,
                            //  AccountID = testContact.AccountID,
                              Call_Type__c = 'email',
                              Origin = 'In-person',
                              Status = 'Closed',
                              Start_time__c = MyDateTime,
                              Add_5_Mins_to_Start_Time_For_End_Time__c = 5,  
                              Family__Household__c = hh.ID,
                              Family__Child__c = childTestContact2.id,
                             // Verbal_Consent_Date__c =beginDate + 1,
                             // Relationship__c = 'Social Worker',
                              RecordTypeId = rTFamInteraction.Id);
        database.insert(caseP, dml);
        
        Case caseB = new Case(ContactId =testProfContact.ID,
                             // AccountID = testProfContact.AccountID,
                              Call_Type__c = 'Contact',
                              Origin = 'In-person',
                              Status = 'Closed',
                              Start_time__c = MyDateTime,
                              Add_5_Mins_to_Start_Time_For_End_Time__c = 5,  
                              Family__Household__c = hh.ID,
                              Family__Child__c = childTestContact2.id,
                             // Verbal_Consent_Date__c =beginDate,
                             // Relationship__c = 'Social Worker',
                              RecordTypeId = rTFamInteraction.Id);
        Casebulk.add(caseB);
        //  database.insert(caseP, dml);
        Case caseF = new Case(ContactId = testContact.ID,
                              //AccountID = testAccount.ID,
                              Call_Type__c = 'Intake',
                              Origin = 'In-person',
                              Status = 'Closed',
                              Start_time__c = myDateTime,
                              Add_5_Mins_to_Start_Time_For_End_Time__c = 5,  
                              Family__Household__c = hh.ID,
                              Family__Child__c = childTestContact.id,
                              RecordTypeId = rTFamInteraction.Id);
        
        Casebulk.add(caseF);
        
        
        Case case2 = new Case(ContactId = testContact.ID,
                              //AccountID = testAccount.ID,
                              Call_Type__c = 'Intake',
                              Origin = 'In-person',
                              Status = 'Closed',
                              Start_time__c = myDateTime,
                              Add_5_Mins_to_Start_Time_For_End_Time__c = 5,  
                              Family__Household__c = hh.ID,
                              Family__Child__c = childTestContact.id,
                              RecordTypeId = rTFamInteraction.Id);
        
        Casebulk.add(case2);
        
        //System.assertEquals(6, casesAfterInsert.size(), 'casesAfterInsert not right number bozo');
        database.insert(Casebulk, dml);
        
        
        
        List<npo02__Household__c> accts = new List<npo02__Household__c>();
        for(Integer i=0;i<numAccts;i++) {
            npo02__Household__c a = new npo02__Household__c(Name='July15-' + i,
                                                            npo02__MailingPostalCode__c ='94110');
            
            accts.add(a);
        }
        Database.insert( accts, dml);
        
        
        // For each account just Database.insert( , dml)ed, add 10 adult contacts
        List<Contact> cons = new List<Contact>();
        for (Integer j=0;j<numAccts;j++) {
            npo02__Household__c acct = accts[j];            
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            cons.add(new Contact(firstname='JulySpanishFemale-'+ j,
                                 lastname='July15-'+ j ,
                                 RecordTypeID ='012G0000000qhDM',
                                 Family__Primary_Language__c = 'Spanish',
                                 Family__Gender__c = 'Female',
                                 Underserved__c= TRUE,
                                 Low_Income__c= TRUE,
                                 Income__c = 'Homeless',
                                 Housing_Status__c ='Vehicle',
                                 
                                 lep__c = 'Declined',
                                 Incarcerated_youth__c = True,
                                 
                                 npo02__Household__c=acct.Id));
            
        }
        // Database.insert( , dml) all contacts for all accounts
        Database.insert( cons, dml) ;
        
        // Child Record ID
        // 012G0000000qhDN
        List<Contact> chD = new List<Contact>();
        date pm = date.newInstance(2007, 6, 1 );
        for (Integer j=0;j<numAccts;j++) {
            integer y = 3;
            npo02__Household__c acct = accts[j];            
            // For each account just Database.insert( , dml)ed, add 10 kid contacts
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            chD.add(new Contact(FirstName='Kid' + Counter , 
                                               LastName='CaseTest'+ Counter, 
                                               RecordTypeID = rtChildContact.Id,
                                               Family__Primary_Language__c = 'Spanish',
                                               Family__Gender__c = 'Female',
                                               Birthdate = bday.addYears(y),
                                               
                                               MailingPostalCode = '94124',
                                               
                                               npo02__Household__c=hh.id	
                                              ));
            
        }       
        Database.insert(chD , dml) ;
        
        
        //Create 10 Interactions in Jan 2016 with above contacts
        List<Case> cas = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact cont = cons[j]; 
            Contact Kid = chd[j];
            Datetime myDateTime = Datetime.newInstance(2016,10, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            cas.add(new Case(ContactId = cont.Id,
                             Call_Type__c = 'Contact',
                             Origin = 'In-person',
                             Status = 'Closed',
                             Start_time__c = myDateTime.addDays(j),
                             Add_5_Mins_to_Start_Time_For_End_Time__c = 5, 
                             Family__Child__c = kid.ID,
                             RecordTypeId = rTFamInteraction.Id));
            
        }
        Database.insert( cas, dml) ;
        
        
        //Create 10 Campaign events in feb with above contacts
        List<Campaign> camp = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            
            Date myDate = Date.newInstance(2016, 7, 1);
            Datetime myDateTimeOc = Datetime.newInstance(2016, 7, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            camp.add(new Campaign(Name='Prog'+ j,
                                  //CampaignMemberRecordType ='012G0000000sIkG', 
                                  RecordTypeId = '012G0000000qhDJ',
                                  isActive = True,
                                  Maximum_Capacity_Adults__c = 1000,
                                  Maximum_Capacity_Children__c = 1000,
                                  Type = 'Clinic',
                                  Start_Date_Time__c = myDateTimeOc,
                                  StartDate = myDate.addDays(j)));
            
        }   
        
        Database.insert( camp, dml) ;
        
        List<CampaignMember> CM = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts);j++) {
            Contact co = cons[j];
            Campaign campan = camp[j];
            
            //for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {      
            CM.add(new CampaignMember(ContactID = co.Id,
                                      CampaignID = campan.Id,
                                      Status = 'Family Attendee'));
            
        }             
        Database.insert(CM , dml) ; 
        
        // create 5 child campaign members- attendees of above August events
        // with above contacts,(should not be counted as they are duplicates)
        List<CampaignMember> CMKids = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts);j++) { 
            Contact campKids = chd[j];
            Campaign campa =camp[j];
            //for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {      
            CMKids.add(new CampaignMember(CampaignID = campa.Id,
                                          ContactID = campKids.Id,
                                          //Account_ID__c = acct.Id,
                                          Status = 'Child Attendee' ));
            
        }             
        Database.insert( CMkids, dml) ;
        
        /********************************* Round 3 - new unduplicated contacs in November  */
        
        List<npo02__Household__c> accts2 = new List<npo02__Household__c>();
        for(Integer i=0;i<numAccts;i++) {
            npo02__Household__c a = new npo02__Household__c(Name='Apr-' + i,
                                                            npo02__MailingPostalCode__c ='94123');
            
            accts2.add(a);
        }
        Database.insert( accts2, dml) ;
        
        
        // For each account just Database.insert( , dml)ed, add 10 adult contacts
        List<Contact> cons2 = new List<Contact>();
        for (Integer j=0;j<numAccts;j++) {
            npo02__Household__c acct2 = accts2[j];            
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            cons2.add(new Contact(firstname='AprilMndarinMale-'+ j,
                                  lastname='Apr-'+ j ,
                                  RecordTypeID ='012G0000000qhDM',
                                  Family__Primary_Language__c = 'Mandarin',
                                  Family__Professional__c = TRUE,
                                  Family__Gender__c = 'Male',
                                  npo02__Household__c=acct2.Id));
            
        }
        Database.insert( cons2, dml) ;
        
        // Child Record ID
        // 012G0000000qhDN
        List<Contact> chD2 = new List<Contact>();
        date pm2 = date.newInstance(2004, 1, 1 );
        for (Integer j=0;j<numAccts;j++) {
            npo02__Household__c acctA = accts2[j];            
            // For each account just Database.insert( , dml)ed, add 10 kid contacts
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            chD2.add(new Contact(firstname='KidFEnParCant'+ j,
                                 lastname='zi-'+ j,
                                 Birthdate = pm2.addYears(j),
                                 RecordTypeID =rtChildContact.Id,
                                 Family__Primary_Language__c = 'English',
                                 Family__Ethnicity__c ='Unknown',
                                 Family__Race__c = 'Native American;',
                                 Family__Gender__c = 'Female',
                                 School_Type__c ='Does not apply',
                                 npo02__Household__c=acctA.Id));
            
        }       
        Database.insert( chD2, dml) ;
        
        //Create 10 Campaign events in December with above KIScontacts
        List<Campaign> camp2 = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            Datetime myDateTime11 = Datetime.newInstance(2016, 12, 1);
            Date myDate11 = Date.newInstance(2016, 10, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            camp2.add(new Campaign(Name='xellentEvent'+ j,
                                   //CampaignMemberRecordType ='012G0000000sIkG', 
                                   RecordTypeId = '012G0000000qhDJ',
                                   isActive = True,
                                   Maximum_Capacity_Adults__c = 1000,
                                   Maximum_Capacity_Children__c = 1000,
                                   Type = 'PPW',
                                   Start_Date_Time__c = myDateTime11.addDays(j),
                                   StartDate = myDate11.addDays(j)));
            
        }   
        Database.insert(camp2, dml) ;
        
        // create 5 child campaign members- attendees of above events - should count but no parent on on record linked as attending
        // with above contacts,(should not be counted as they are duplicates)
        List<CampaignMember> CMKids2 = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts);j++) { 
            Contact campKids2 = chd2[j];
            Campaign campa2 =camp2[j];
            //for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {      
            CMKids2.add(new CampaignMember(CampaignID = campa2.Id,
                                           ContactID = campKids2.Id,
                                           //Account_ID__c = acct.Id,
                                           Status = 'Child Attendee' ));  
        }             
        Database.insert( CMkids2, dml) ;
        
        //Create 10 Interactions in Nov 2015 with above contacts
        List<Case> cas2 = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact cont2 = cons2[j]; 
            Contact Kid2 = chd2[j];
            Datetime myDateTime2 = Datetime.newInstance(2016, 11, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            cas2.add(new Case(ContactId = cont2.Id,
                              Call_Type__c = 'Contact',
                              Origin = 'Phone',
                              Status = 'New',
                              Start_time__c = myDateTime2.addDays(j),
                              Add_5_Mins_to_Start_Time_For_End_Time__c = 5, 
                              Family__Child__c = kid2.ID,
                              RecordTypeId = rTFamInteraction.Id));
            
        }
        Database.insert(cas2 , dml) ;
    }
    @isTest static void testMethod1() { 
        
        Test.startTest();
        
        PageReference Rep = Page.CPIRAge;
        Test.setCurrentPage(Rep);
        
        // get a Page controller instance
        CPIRAge AR = new CPIRAge();
        
        date TestDateFrom = date.newInstance(2016, 1, 1 ); 
        date TestDate = date.newInstance(2017, 12, 31 );
        // Set Date From and Date To on Controller
        Date controllerDateFrom = TestDateFrom;
        Date controllerDateTo = TestDate;
        AR.datefrom = controllerDateFrom;
        AR.dateTo = controllerDateTo;
        System.AssertEquals(AR.dateFrom, controllerDateFrom);
        System.AssertEquals(AR.dateTo, controllerDateTo);
        
        AR.startGenerateBoard(); 
        
        AR.getGenerateAgeCamp();
        AR.getGenerateAgeInt();
        
        Test.stopTest();        
        
    }
    
    @isTest static void testMethod4() {
        Test.startTest();
        // get reference to EIS Dashboard Page
        PageReference Rep = Page.CPIRAge;
        Test.setCurrentPage(Rep);
        CPIRAge AR = new CPIRAge();
        
        date TestDateTo = date.newInstance(2017, 7, 31 );
        date TestDateFrom = date.newInstance(2016, 12, 1 );
        // Set Date From and Date To on Controller
        Date controllerDateFrom = endDate;
        Date controllerDateTo = beginDate ;
        AR.datefrom = controllerDateFrom;
        AR.dateTo = controllerDateTo;
        System.AssertEquals(AR.dateFrom, controllerDateFrom);
        System.AssertEquals(AR.dateTo, controllerDateTo);
        AR.startGenerateBoard();
        
        AR.getGenerateAgeCamp();
        AR.getGenerateAgeInt();
        Test.stopTest();       
        
    }
    @isTest static void testMethod5() {
        Test.startTest();
        // get reference to EIS Dashboard Page
        PageReference AnnualRep = Page.CPIRAge;
        Test.setCurrentPage(AnnualRep);
        CPIRAge AR = new CPIRAge();
        
        date TestDateTo = date.newInstance(2016, 7, 31 );
        // date TestDateFrom = date.newInstance(2016, 12, 1 );
        // Set Date From and Date To on Controller
        Date controllerDateFrom = NULL;
        Date controllerDateTo = NULL ;
        AR.datefrom = controllerDateFrom;
        AR.dateTo = controllerDateTo;
        //System.AssertEquals(AR.dateFrom, controllerDateFrom);
        System.AssertEquals(AR.dateTo, controllerDateTo);
        AR.startGenerateBoard();
        
        AR.getGenerateAgeCamp();
        AR.getGenerateAgeInt();
        Test.stopTest();       
        
    }
    @isTest static void testMethod6() {
        Test.startTest();
        // get reference to EIS Dashboard Page
        PageReference AnnualRep = Page.CPIRAge;
        Test.setCurrentPage(AnnualRep);
        CPIRAge AR = new CPIRAge();
        
        // date TestDateTo = date.newInstance(2016, 7, 31 );
        // date TestDateFrom = date.newInstance(2016, 12, 1 );
        // Set Date From and Date To on Controller
        Date controllerDateFrom = endDate;
        Date controllerDateTo = NULL ;
        AR.datefrom = controllerDateFrom;
        AR.dateTo = controllerDateTo;
        // System.AssertEquals(AR.dateFrom, controllerDateFrom);
        // System.AssertEquals(AR.dateTo, controllerDateTo);
        AR.startGenerateBoard();
        
        AR.getGenerateAgeCamp();
        AR.getGenerateAgeInt();
        Test.stopTest();       
        
    }
    
    
}