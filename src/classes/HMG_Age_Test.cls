@isTest
public class HMG_Age_Test {
    
    
    Public static boolean  testingException;
    Private static RecordType rTProfInteraction = [SELECT Id, Name FROM recordType WHERE Name = 'Professional Case' AND sObjectType = 'Case' LIMIT 1];
    Private static RecordType rTFamInteraction = [SELECT Id, Name FROM recordType WHERE Name = 'Family Case' AND sObjectType = 'Case' LIMIT 1];
    Private static RecordType rtAdultContact = [select Id from RecordType where Name = 'Adult' and SobjectType = 'Contact' LIMIT 1];//Grab all required fields?
    Private static RecordType rtChildContact = [Select Id, Name from RecordType where Name = 'Child/Person With Disability'  and SobjectType = 'Contact' limit 1];
    
    static private Integer Counter = 200;
    static private Integer numAccts = 10;
    static private Integer numContactsPerAcct = 2;
    Static private Integer AgeYears = 10;
    static date priorBegins = date.newInstance(2017, 7, 01);
    static date priorEnds = date.newInstance(2017, 7, 31);
    static date beginDate = date.newInstance(2017, 9, 1);
    static date midDate = date.newInstance(2017, 11, 30);  
    static date deDupeDate = date.newInstance(2010, 9, 30);
    static date kidBDate = date.newInstance(2014, 7, 30);
    static date endDate = date.newInstance(2016, 3, 31);
    static datetime myDateTime = datetime.newInstance(2017,9, 1);    
    
    @testSetup static void createTestRecords(){
        
        List<String> EspList = new List <String>();  
        Map <Integer, String> RaceMap =  new Map <Integer, String>{0 =>  'White' , 1 =>'Multi', 2 => 'African', 3 =>'Asian',
            4 => 'Pacific', 5 => 'Middle', 
            6 =>'Native American', 7 =>'Declined', 8 => 'Unknown', 
            9 => 'Other', 10 =>'Native Alaskan'}; 
                
                
                
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
                                                Birthdate = kidBDate,
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
                                               Birthdate = endDate,
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
                              Family__Child__c = childTestContact.id,
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
        
        
        
        List<npo02__Household__c> acctsss = new List<npo02__Household__c>();
        for(Integer i=0;i<numAccts;i++) {
            npo02__Household__c a = new npo02__Household__c(Name='July15-' + i,
                                                            npo02__MailingPostalCode__c ='94110');
            
            acctsss.add(a);
        }
        Database.insert( acctsss, dml);
        
        
        // For each account just Database.insert( , dml)ed, add 10 adult contacts
        List<Contact> consss = new List<Contact>();
        for (Integer j=0;j<numAccts;j++) {
            npo02__Household__c acct = acctsss[j];            
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            consss.add(new Contact(firstname='JulySpanishFemale-'+ j,
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
        Database.insert( consss, dml) ;
        
        // Child Record ID
        // 012G0000000qhDN
        List<Contact> chDss = new List<Contact>();
        date pm = date.newInstance(2007, 6, 1 );
        for (Integer j=0;j<numAccts;j++) {
            integer y = 3;
            npo02__Household__c acct = acctsss[j];            
            // For each account just Database.insert( , dml)ed, add 10 kid contacts
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            chDss.add(new Contact(FirstName='Kid' + Counter , 
                                  LastName='CaseTest'+ Counter, 
                                  RecordTypeID = rtChildContact.Id,
                                  Family__Primary_Language__c = 'Spanish',
                                  Family__Gender__c = 'Female',
                                  Birthdate = endDate.addYears(y),
                                  Family__Ethnicity__c ='Hispanic or Latino',
                                  //Ethnicity_Hispanic_Latino_Other__c = 'Central American',
                                  Hispanic_Latino_please_specify__c = 'Unknown',
                                  Family__Race__c = 'Pacific',
                                  MailingPostalCode = '94124',
                                  
                                  npo02__Household__c=hh.id	
                                 ));
            
        }       
        Database.insert(chDss , dml) ;
        
        
        //Create 10 Interactions in Jan 2016 with above contacts
        List<Case> cas = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact cont = consss[j]; 
            Contact Kid = chdss[j];
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
        
        List<npo02__Household__c> accts = new List<npo02__Household__c>();
        for(Integer i=0;i<numAccts;i++) {
            npo02__Household__c a = new npo02__Household__c(Name='July-' + i,
                                                            npo02__MailingPostalCode__c ='94110');
            
            accts.add(a);
        }
        Database.insert( accts, DML);
        
        
        // For each account just inserted, add 10 adult contacts
        List<Contact> cons = new List<Contact>();
        for (Integer j=0;j<numAccts;j++) {
            npo02__Household__c acct = accts[j];            
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            cons.add(new Contact(firstname='JulySpanishFemale-'+ j,
                                 lastname='July15-'+ j ,
                                 //RecordTypeID ='012G0000000qhDM',
                                 Family__Primary_Language__c = 'Spanish',
                                 Family__Gender__c = 'Female',
                                 npo02__Household__c=acct.Id));
            
        }
        // Insert all contacts for all accounts
        Database.insert( cons, DML);
        
        // Child Record ID
        // 012G0000000qhDN
        List<Contact> chD = new List<Contact>();
        //date pm = date.newInstance(2015, 6, 1 );
        for (Integer j=0;j<numAccts;j++) {
            npo02__Household__c acct = accts[j];            
            // For each account just inserted, add 10 kid contacts
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            chD.add(new Contact(firstname='JulyKidMaleEnParSp'+ j,
                                lastname='July15-'+ j,
                                Birthdate = kidBDate,
                                RecordTypeID ='012G0000000qhDN',
                                Family__Primary_Language__c = 'English',
                                Family__Ethnicity__c ='Hispanic or Latino',
                                //Ethnicity_Hispanic_Latino_Other__c = 'Central American',
                                Hispanic_Latino_please_specify__c = 'Central American',
                                Family__Race__c = 'Asian - Chinese',
                                
                                Family__Gender__c = 'Male',
                                School_Type__c ='Does not apply',
                                npo02__Household__c=acct.Id));
            
        }       
        Database.insert( chD, DML);
        
        
        //Create 10 Interactions in Jan 2016 with above contacts
        List<Case> casss = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact cont = consss[j]; 
            Contact Kid = chdss[j];
            // Datetime myDateTime = Datetime.newInstance(2016,7, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            casss.add(new Case(ContactId = cont.Id,
                               Call_Type__c = 'Contact',
                               Origin = 'In-person',
                               Status = 'Closed',
                               Start_time__c = midDate.addDays(15),
                               Add_5_Mins_to_Start_Time_For_End_Time__c =5,
                               Family__Child__c = kid.ID,
                               RecordTypeId = '012G0000000qhDK'));
            
        }
        Database.insert (casss, DML);
        
        
        //Create 10 Campaign events in feb with above contacts
        List<Campaign> camp = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            
            Date myDate = Date.newInstance(2017, 1, 1);
            //Datetime myDateTimeOc = Datetime.newInstance(2016, 7, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            camp.add(new Campaign(Name='Prog'+ j,
                                  //CampaignMemberRecordType ='012G0000000sIkG', 
                                  RecordTypeId = '012G0000000qhDJ',
                                  isActive = True,
                                  Maximum_Capacity_Adults__c = 1000,
                                  Maximum_Capacity_Children__c = 1000,
                                  Type = 'Clinic',
                                  Start_Date_Time__c = myDate.addDays(j),
                                  StartDate = midDate.addDays(j+10)));
            
        }   
        
        insert camp;
        
        List<CampaignMember> CM = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts-5);j++) {
            Contact co = cons[j];
            Campaign campan = camp[j];
            
            //for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {      
            CM.add(new CampaignMember(ContactID = co.Id,
                                      CampaignID = campan.Id,
                                      Status = 'Family Attendee'));
            
        }             
        insert CM; 
        
        // create 5 child campaign members- attendees of above August events
        // with above contacts,(should not be counted as they are duplicates)
        List<CampaignMember> CMKids = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts-5);j++) { 
            Contact campKids = chd[j];
            Campaign campa =camp[j];
            //for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {      
            CMKids.add(new CampaignMember(CampaignID = campa.Id,
                                          ContactID = campKids.Id,
                                          //Account_ID__c = acct.Id,
                                          Status = 'Child Attendee' ));
            
        }             
        insert CMkids;
        
        /***************** Round 2  - same contacts, events in October
* *****************************/
        //Create 10 Interactions in Sept 2015 with above contacts
        List<Case> casO = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact contO = cons[j]; 
            Contact KidO = chd[j];
            Datetime myDateTimeO = Datetime.newInstance(2017, 9, 30);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            casO.add(new Case(ContactId = contO.Id,
                              Call_Type__c = 'Contact',
                              Origin = 'In-person',
                              Status = 'Closed',
                              Start_time__c = myDateTimeO.addDays(1),
                              Add_5_Mins_to_Start_Time_For_End_Time__c =5,
                              Family__Child__c = kidO.ID,
                              RecordTypeId = '012G0000000qhDK'));
            
        }
        Database.insert( casO, DML);
        
        
        //Create  Campaign events in October with above contacts - shouldnt count
        List<Campaign> campO = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            // Datetime myDateTimeOc = Datetime.newInstance(2016, 8, 1);
            // Date myDateO = Date.newInstance(2016, 8, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            campO.add(new Campaign(Name='Dat'+ j,
                                   //CampaignMemberRecordType ='012G0000000sIkG', 
                                   RecordTypeId = '012G0000000qhDJ',
                                   isActive = True,
                                   Maximum_Capacity_Adults__c = 1000,
                                   Maximum_Capacity_Children__c = 1000,
                                   Type = 'Workshop',
                                   Start_Date_Time__c = deDupeDate.addDays(j),
                                   StartDate = deDupeDate.addDays(j)));
            
        }   
        
        insert campO;
        
        // Attendees shouldnt count
        List<CampaignMember> CMO = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts-5);j++) {
            Contact coO = cons[j];
            Campaign campanO = campO[j];
            
            //for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {      
            CMO.add(new CampaignMember(ContactID = coO.Id,
                                       CampaignID = campanO.Id,
                                       
                                       Status = 'Family Attendee'));
            
        }             
        insert CMO;  
        
        // create 5 child campaign members- attendees of above August events
        // with above contacts,(should not be counted as they are duplicates)
        List<CampaignMember> CMKidsO = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts-5);j++) { 
            Contact campKidsO = chd[j];
            Campaign campaO =campO[j];
            //for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {      
            CMKidsO.add(new CampaignMember(CampaignID = campaO.Id,
                                           ContactID = campKidsO.Id,
                                           //Account_ID__c = acct.Id,
                                           Status = 'Child Attendee' ));
            
        }             
        insert CMkidsO;
        
        
        /********************************* Round 3 - new unduplicated contacs in November
* ************************************************************************/
        List<npo02__Household__c> accts2 = new List<npo02__Household__c>();
        for(Integer i=0;i<numAccts;i++) {
            npo02__Household__c a = new npo02__Household__c(Name='Apr-' + i,
                                                            npo02__MailingPostalCode__c ='94123');
            
            accts2.add(a);
        }
        Database.insert( accts2, DML);
        
        
        // For each account just inserted, add 10 adult contacts
        List<Contact> cons2 = new List<Contact>();
        for (Integer j=0;j<numAccts;j++) {
            npo02__Household__c acct2 = accts2[j];            
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            cons2.add(new Contact(firstname='AprilMndarinMale-'+ j,
                                  lastname='Apr-'+ j ,
                                  //RecordTypeID ='012G0000000qhDM',
                                  Family__Primary_Language__c = 'Mandarin',
                                  Family__Gender__c = 'Male',
                                  npo02__Household__c=acct2.Id));
            
        }
        Database.insert( cons2, DML);
        
        // Child Record ID
        // 012G0000000qhDN
        List<Contact> chD2 = new List<Contact>();
        date pm2 = date.newInstance(2010, 9, 30 );
        for (Integer j=0;j<numAccts;j++) {
            npo02__Household__c acctA = accts2[j];            
            // For each account just inserted, add 10 kid contacts
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            chD2.add(new Contact(firstname='KidFEnParCant'+ j,
                                 lastname='zi-'+ j,
                                 Birthdate = pm2.addYears(1),
                                 RecordTypeID ='012G0000000qhDN',
                                 Family__Primary_Language__c = 'English',
                                 Family__Ethnicity__c ='Unknown',
                                 Family__Race__c = RaceMap.get(j),
                                 Family__Gender__c = 'Female',
                                 School_Type__c ='Does not apply',
                                 npo02__Household__c=acctA.Id));
            
        }       
        Database.insert( chD2, DML);
        
        
        
        //Create 10 Interactions  with above contacts
        List<Case> cas2 = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact cont2 = cons2[j]; 
            Contact Kid2 = chd2[j];
            Datetime myDateTime2 = Datetime.newInstance(2017, 9, 25);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            cas2.add(new Case(ContactId = cont2.Id,
                              Call_Type__c = 'Contact',
                              Origin = 'Phone',
                              Status = 'New',
                              Start_time__c = myDateTime2.addDays(j),
                              Add_5_Mins_to_Start_Time_For_End_Time__c =5,
                              Family__Child__c = kid2.ID,
                              RecordTypeId = rTFamInteraction.Id));
            
        }
        insert cas2;
        
    }
    
    @isTest static void testMethod1() { 
        
        Test.startTest();
        // insert data
        
        // get reference to EIS Dashboard Page
        PageReference ESPDashboard = Page.HMG_Age_VF;
        Test.setCurrentPage(ESPDashboard);
        
        // get a Page controller instance
        HMG_Age ESP2 = new HMG_Age();
        date TestDateFrom = date.newInstance(2017, 7, 1 );
        date TestDateTo = date.newInstance(2017, 12, 31 ); 
        // Set Date From and Date To on Controller
        Date controllerDateFrom = TestDateFrom;
        Date controllerDateTo = TestDateTo;
        ESP2.datefrom = controllerDateFrom;
        ESP2.dateTo = controllerDateTo;
        
        System.AssertEquals(ESP2.dateTo, controllerDateTo);
        System.AssertEquals(ESP2.dateFrom, controllerDateFrom);
        
        
        
        // generate EIS Dashboard
        
        ESP2.startGenerateEISDashboard();
        ESP2.getGenerateAge1(); 
        ESP2.getGenerateAge2(); 
        ESP2.getGenerateAge3(); 
        ESP2.getGenerateAge4(); 
        ESP2.getGenerateAge5(); 
        ESP2.getGenerateAge6();
        ESP2.getGenerateGenYTD();
        ESP2.getGenerateGenP();
        ESP2.getGenerateGenC();
        ESP2.getGenerateParentLanguageP();
        ESP2.getGenerateParentLanguage();
        ESP2.getGenerateParentLanguageYTD();
        ESP2.getGenerateEthnicity();
        ESP2.getGenerateRace();
        ESP2.getGenerateEthnicityYTD();
        ESP2.getGenerateRaceYTD();
        ESP2.GetAll();
        ESP2.GetAge1();
        ESP2.GetAge2();
        ESP2.GetAge3();
        ESP2.GetAge4();
        ESP2.GetAge5();
        ESP2.GetAge6();
        
        
        Test.stopTest();   
    }
    @isTest static void testMethod2() { 
        Test.startTest();
        // insert data
        
        // get reference to EIS Dashboard Page
        PageReference ESPDashboard = Page.HMG_Age_VF;
        Test.setCurrentPage(ESPDashboard);
        
        // get a Page controller instance
        HMG_Age ESP2 = new HMG_Age();
        date TestDateFrom = date.newInstance(2017, 12, 1 );
        date TestDateTo = date.newInstance(2017, 1, 31 ); 
        // Set Date From and Date To on Controller
        Date controllerDateFrom = TestDateFrom;
        Date controllerDateTo = TestDateTo;
        ESP2.datefrom = controllerDateFrom;
        ESP2.dateTo = controllerDateTo;
        ESP2.startGenerateEISDashboard();
        test.stopTest();
        
    }
    
    @isTest static void testMethod3() { 
        Test.startTest();
        // insert data
        
        // get reference to EIS Dashboard Page
        PageReference ESPDashboard = Page.HMG_Age_VF;
        Test.setCurrentPage(ESPDashboard);
        
        // get a Page controller instance
        HMG_Age ESP2 = new HMG_Age();
        date TestDateFrom = date.newInstance(2017, 12, 1 );
        date TestDateTo = date.newInstance(2017, 1, 31 ); 
        // Set Date From and Date To on Controller
        Date controllerDateFrom = TestDateFrom;
        Date controllerDateTo = TestDateTo;
        ESP2.datefrom = controllerDateFrom;
        ESP2.dateTo = NULL;
        ESP2.startGenerateEISDashboard();
        test.stopTest();
        
    }
    
    @isTest static void testMethodPrior() { 
        
        Test.startTest();
        // insert data
        
        // get reference to EIS Dashboard Page
        PageReference ESPDashboard = Page.HMG_Age_VF;
        Test.setCurrentPage(ESPDashboard);
        
        // get a Page controller instance
        HMG_Age ESP2 = new HMG_Age();
        date TestDateFrom = date.newInstance(2018, 1, 1 );
        date TestDateTo = date.newInstance(2018, 3, 31 ); 
        // Set Date From and Date To on Controller
        Date controllerDateFrom = TestDateFrom;
        Date controllerDateTo = TestDateTo;
        ESP2.datefrom = controllerDateFrom;
        ESP2.dateTo = controllerDateTo;
        
        System.AssertEquals(ESP2.dateTo, controllerDateTo);
        System.AssertEquals(ESP2.dateFrom, controllerDateFrom);
        
        
        
        // generate EIS Dashboard
        
        ESP2.startGenerateEISDashboard();
        ESP2.getGenerateAge1(); 
        ESP2.getGenerateAge2(); 
        ESP2.getGenerateAge3(); 
        ESP2.getGenerateAge4(); 
        ESP2.getGenerateAge5(); 
        ESP2.getGenerateAge6();
        ESP2.getGenerateGenYTD();
        ESP2.getGenerateGenP();
        ESP2.getGenerateGenC();
        ESP2.getGenerateParentLanguageP();
        ESP2.getGenerateParentLanguage();
        ESP2.getGenerateParentLanguageYTD();
        ESP2.getGenerateEthnicity();
        ESP2.getGenerateEthnicityYTD();
        ESP2.getGenerateRace();
        ESP2.getGenerateRaceYTD();
        
        
        Test.stopTest();   
    }
    
}