@isTest
public class ESP2_2Test {
     Private static RecordType rTProfInteraction = [SELECT Id, Name FROM recordType WHERE Name = 'Professional Case' AND sObjectType = 'Case' LIMIT 1];
    Private static RecordType rTFamInteraction = [SELECT Id, Name FROM recordType WHERE Name = 'Family Case' AND sObjectType = 'Case' LIMIT 1];
    Private static RecordType rtAdultContact = [select Id from RecordType where Name = 'Adult' and SobjectType = 'Contact' LIMIT 1];//Grab all required fields?
    Private static RecordType rtChildContact = [Select Id, Name from RecordType where Name = 'Child/Person With Disability'  and SobjectType = 'Contact' limit 1];
    
    static private Integer numAccts = 10;
    static private Integer numContactsPerAcct = 2;
    Static private Integer AgeYears = 10;
    static date priorBegins = date.newInstance(2016, 10, 01);
    static date priorEnds = date.newInstance(2016, 12, 31);
    static date beginDate = date.newInstance(2016, 7, 1);
    static date midDate = date.newInstance(2016, 12, 30);  
    static date deDupeDate = date.newInstance(2016, 9, 30);
    static date kidBDate = date.newInstance(2015, 7, 30);
    static date endDate = date.newInstance(2017, 3, 31);    
    
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
        
        
        List<npo02__Household__c> accts = new List<npo02__Household__c>();
        for(Integer i=0;i<numAccts;i++) {
            npo02__Household__c a = new npo02__Household__c(Name='July-' + i,
                                                            npo02__MailingPostalCode__c ='94110');
            
            accts.add(a);
        }
        insert accts;
        
        
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
        insert cons;
        
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
                                Birthdate = kidBDate.addDays(15),
                                RecordTypeID ='012G0000000qhDN',
                                Family__Primary_Language__c = 'English',
                                Family__Ethnicity__c ='Hispanic or Latino',
                                //Ethnicity_Hispanic_Latino_Other__c = 'Central American',
                                Hispanic_Latino_please_specify__c = 'Central American',
                                Family__Race__c = RaceMap.get(j),
                               // Race_Other__c = '',
                                Family__Gender__c = 'Male',
                                School_Type__c ='Does not apply',
                                npo02__Household__c=acct.Id));
            
        }       
        Insert chD;
        
        
        //Create 10 Interactions in Jan 2016 with above contacts
        List<Case> cas = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact cont = cons[j]; 
            Contact Kid = chd[j];
            Datetime myDateTime = Datetime.newInstance(2016,7, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            cas.add(new Case(ContactId = cont.Id,
                             Call_Type__c = 'Contact',
                             Origin = 'In-person',
                             Status = 'Closed',
                             Start_time__c = myDateTime.addDays(15),
                             Add_5_Mins_to_Start_Time_For_End_Time__c =5,
                             Family__Child__c = kid.ID,
                             RecordTypeId = rTFamInteraction.ID));
            
        }
        insert cas;
        
        
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
            Datetime myDateTimeO = Datetime.newInstance(2017, 1, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            casO.add(new Case(ContactId = contO.Id,
                              Call_Type__c = 'Contact',
                              Origin = 'In-person',
                              Status = 'Closed',
                              Start_time__c = myDateTimeO.addDays(j+10),
                              Add_5_Mins_to_Start_Time_For_End_Time__c =5,
                              Family__Child__c = kidO.ID,
                              RecordTypeId = '012G0000000qhDK'));
            
        }
        insert casO;
        
        
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
        insert accts2;
        
        
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
        insert cons2;
        
        // Child Record ID
        // 012G0000000qhDN
        List<Contact> chD2 = new List<Contact>();
        date pm2 = date.newInstance(2014, 9, 1 );
        for (Integer j=0;j<numAccts;j++) {
            npo02__Household__c acctA = accts2[j];            
            // For each account just inserted, add 10 kid contacts
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            chD2.add(new Contact(firstname='KidFEnParCant'+ j,
                                 lastname='zi-'+ j,
                                 Birthdate = pm2.addDays(j),
                                 RecordTypeID ='012G0000000qhDN',
                                 Family__Primary_Language__c = 'English',
                                 Family__Ethnicity__c ='Unknown',
                                 Family__Race__c = 'Native American;',
                                 Family__Gender__c = 'Female',
                                 School_Type__c ='Does not apply',
                                 npo02__Household__c=acctA.Id));
            
        }       
        Insert chD2;
        
        //Prior -- Create 10 Campaign events with above KIScontacts
        List<Campaign> camp2 = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            Datetime myDateTime11 = Datetime.newInstance(2016, 12, 1);
            Date myDate11 = Date.newInstance(2016, 12, 1);
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
        insert camp2;
        
        // create 5 child campaign members- attendees of above events - should count but no parent on on record linked as attending
        // with above contacts,(should not be counted as they are duplicates)
        List<CampaignMember> CMKids2 = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts-5);j++) { 
            Contact campKids2 = chd2[j];
            Campaign campa2 =camp2[j];
            //for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {      
            CMKids2.add(new CampaignMember(CampaignID = campa2.Id,
                                           ContactID = campKids2.Id,
                                           //Account_ID__c = acct.Id,
                                           Status = 'Child Attendee' ));  
        }             
        insert CMkids2;
        
        //Create 10 Interactions  with above contacts
        List<Case> cas2 = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact cont2 = cons2[j]; 
            Contact Kid2 = chd2[j];
            Datetime myDateTime2 = Datetime.newInstance(2016, 06, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            cas2.add(new Case(ContactId = cont2.Id,
                              Call_Type__c = 'Contact',
                              Origin = 'Phone',
                              Status = 'New',
                              Start_time__c = myDateTime2.addDays(j),
                              Add_5_Mins_to_Start_Time_For_End_Time__c =5,
                              Family__Child__c = kid2.ID,
                              RecordTypeId = '012G0000000qhDK'));
            
        }
        insert cas2;
        
        /* **************************round 4
* We want to count parents who are taged as having a kid <35 month in the reporting period
* check to see if the parent attended an event without the kid
* also check to see if the parent had an interaction with no older kid listed, duing reporting period?
* TODO: Add checkbox on household to say family with kid <35 months*/
        
        // create 5 adult campaign members- attendees of aboveevents
        // with above contacts,(should not be counted as they are duplicates)
        List<CampaignMember> CM2 = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts-5);j++) {
            Contact co2 = cons2[j];
            Campaign campan2 = camp2[j];
            
            //for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {      
            CM2.add(new CampaignMember(ContactID = co2.Id,
                                       CampaignID = campan2.Id,
                                       Status = 'Family Attendee'));
            
        }             
        insert CM2; 
    }
         @isTest static void testMethod1() { 
        Test.startTest();
        // insert data
        
        // get reference to EIS Dashboard Page
        PageReference ESPDashboard = Page.ESP2_Age;
        Test.setCurrentPage(ESPDashboard);
        
        // get a Page controller instance
        ESP2_Age ESP2 = new ESP2_Age();
       date TestDateFrom = date.newInstance(2016, 7, 1 );
        date TestDateTo = date.newInstance(2016, 3, 31 ); 
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
        
        
        Test.stopTest();        
        
    }
     @isTest static void testMethod2() { 
        Test.startTest();
        // insert data
        
        // get reference to EIS Dashboard Page
        PageReference ESPDashboard = Page.ESP2_Age;
        Test.setCurrentPage(ESPDashboard);
        
        // get a Page controller instance
        ESP2_Age ESP2 = new ESP2_Age();
        date TestDateFrom = date.newInstance(2017, 12, 1 );
        date TestDateTo = date.newInstance(2017,1 , 31 ); 
        // Set Date From and Date To on Controller
        Date controllerDateFrom = TestDateFrom;
        Date controllerDateTo = TestDateTo;
        ESP2.datefrom = controllerDateFrom;
        ESP2.dateTo = controllerDateTo;
        
        System.AssertEquals(ESP2.dateTo, controllerDateTo);
        System.AssertEquals(ESP2.dateFrom, controllerDateFrom);
        
        
        // generate EIS Dashboard
        
        ESP2.startGenerateEISDashboard();
        
        
        Test.stopTest();        
        
    }
     @isTest static void testMethod3() { 
        Test.startTest();
        // insert data
        
        // get reference to EIS Dashboard Page
        PageReference ESPDashboard = Page.ESP2_Age;
        Test.setCurrentPage(ESPDashboard);
        
        // get a Page controller instance
        ESP2_Age ESP2 = new ESP2_Age();
        date TestDateFrom = date.newInstance(2017, 12, 1 );
        date TestDateTo = date.newInstance(2017, 1, 31 ); 
        // Set Date From and Date To on Controller
        Date controllerDateFrom = TestDateFrom;
        Date controllerDateTo = TestDateTo;
        ESP2.datefrom = controllerDateFrom;
        ESP2.dateTo = NULL;
        // generate EIS Dashboard
        
        ESP2.startGenerateEISDashboard();
    
        
        
        Test.stopTest();        
        
    }
      @isTest static void testMethod4() { 
        Test.startTest();
        // insert data
        
        // get reference to EIS Dashboard Page
        PageReference ESPDashboard = Page.ESP2_Age;
        Test.setCurrentPage(ESPDashboard);
        
        // get a Page controller instance
        ESP2_Age ESP2 = new ESP2_Age();
       date TestDateFrom = date.newInstance(2016, 7, 1 );
        date TestDateTo = date.newInstance(2016, 12, 31 ); 
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
       Test.stopTest();
      }
   
}