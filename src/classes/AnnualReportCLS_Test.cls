@isTest
//Novo11/1/17
//added CPIRChildStats
public class AnnualReportCLS_Test {
    static private Integer numAccts = 10;
    static private Integer numContactsPerAcct =5;
    static date beginDate = date.newInstance(2016, 7, 1);
    static date endDate = date.newInstance(2017, 6, 30);  
    static date bday = date.newInstance(2014, 6, 30);   
    
       @testSetup static void createTestRecords() {
        
       
        
         List<case> cases= new List<Case>();
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave=true;
          
        
        List<npo02__Household__c> accts = new List<npo02__Household__c>();
        for(Integer i=0;i<numAccts;i++) {
            npo02__Household__c a = new npo02__Household__c(Name='July15-' + i,
                                                            npo02__MailingPostalCode__c ='94110');
            
            accts.add(a);
        }
        insert accts;
        
        
        // For each account just inserted, add 10 adult contacts
        List<Contact> cons = new List<Contact>();
        for (Integer j=0;j<numContactsPerAcct;j++) {
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
        // Insert all contacts for all accounts
        insert cons;
        
        // Child Record ID
        // 012G0000000qhDN
      Map <Integer, String> RaceMap =  new Map <Integer, String>{0 =>  'White' , 1 =>'Multi', 2 => 'African', 3 =>'Asian',
            														 4 => 'Pacific', 5 => 'Middle', 
            															6 =>'Native American', 7 =>'Declined', 8 => 'Unknown', 
            																9 => 'Other', 10 =>'Native Alaskan'}; 

        
        List<Contact> RaceKids = new List <Contact>();
        for (Integer j=0;j<10;j++) {
                        
       
            RaceKids.add(new Contact(firstname='Kid'+ j,
                                lastname='Kid'+ j,
                                Birthdate = bday.addDays(j),
                                RecordTypeID ='012G0000000qhDN',
                                Family__Primary_Language__c = 'English',
                                Family__Ethnicity__c ='Hispanic or Latino',
                                Hispanic_Latino_please_specify__c = 'Central American',
                                Family__Race__c = RaceMap.get(j),
                                Race_Other__c = '',
                                Family__Gender__c = 'Male',
                                School_Type__c ='Does not apply'
                                //npo02__Household__c = acct.Id
                                    ));
            
          }   
        System.assertEquals(10, RaceKids.size());
        System.assertEquals('Native American', RaceKids.get(6).Family__Race__c);
        Insert RaceKids;
        
        
        
        //Create 10 Interactions in Jan 2016 with above contacts
        List<Case> cas = new List<Case>();
        for (Integer j=0;j<10;j++) {
            Contact cont = RaceKids[j]; 
            Contact Kid = RaceKids[j];
            Datetime myDateTime = Datetime.newInstance(2016,9, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            cas.add(new Case(ContactId = cont.Id,
                             Call_Type__c = 'Mtg',
                             Origin = 'In-person',
                             Status = 'Closed',
                             Start_time__c = myDateTime.addDays(j),
                             End_Time__c = myDateTime.addDays(j),
                             Family__Child__c = kid.ID,
                             RecordTypeId = '012G0000000qhDK'));
            
        }
        insert cas;
        
        //System.assertEquals('Native', cas.get(1).Family__Child__r.Family__Race__c);
       
        //Create 10 Campaign events in feb with above contacts
        List<Campaign> camp = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            
            Date myDate = Date.newInstance(2016, 12, 1);
            Datetime myDateTimeOc = Datetime.newInstance(2016, 12, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            camp.add(new Campaign(Name='Prog'+ j,
                                  //CampaignMemberRecordType ='012G0000000sIkG', 
                                  RecordTypeId = '012G0000000qhDJ',
                                  isActive = True,
                                  Maximum_Capacity_Adults__c = 1000,
                                  Maximum_Capacity_Children__c = 1000,
                                  Type = 'Family Event',
                                  Start_Date_Time__c = myDateTimeOc,
                                  End_Date_Time__c = myDateTimeOc.addDays(j),
                                  StartDate = myDate.addDays(j)));
            
        }   
        
        insert camp;
        
        List<CampaignMember> CM = new List<Campaignmember>();
        for (Integer j=0;j<(numContactsPerAcct);j++) {
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
        for (Integer j=0;j<numContactsPerAcct;j++) { 
            Contact campKids = RaceKids[j];
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
   /*     //Create 10 Interactions in Sept 2015 with above contacts
        List<Case> casO = new List<Case>();
        for (Integer j=0;j<numContactsPerAcct;j++) {
            Contact contO = cons[j]; 
            Contact KidO = RaceKids[j];
            Datetime myDateTimeO = Datetime.newInstance(2016, 9, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            casO.add(new Case(ContactId = contO.Id,
                              Call_Type__c = 'Mtg',
                              Origin = 'In-person',
                              Status = 'Closed',
                              Start_time__c = myDateTimeO.addDays(j),
                              Family__Child__c = kidO.ID,
                              RecordTypeId = '012G0000000qhDK'));
            
        }
        insert casO;
        
        
        //Create  Campaign events in October with above contacts - shouldnt count
        List<Campaign> campO = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            Datetime myDateTimeOc = Datetime.newInstance(2016, 3, 1);
            Date myDateO = Date.newInstance(2016, 3, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            campO.add(new Campaign(Name='Dat'+ j,
                                   //CampaignMemberRecordType ='012G0000000sIkG', 
                                   RecordTypeId = '012G0000000qhDJ',
                                   isActive = True,
                                   Maximum_Capacity_Adults__c = 1000,
                                   Maximum_Capacity_Children__c = 1000,
                                   Type = 'Workshop',
                                   Start_Date_Time__c = myDateTimeOc.addDays(j),
                                   StartDate = myDateO.addDays(j)));
            
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
            Contact campKidsO = raceKids[j];
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
                                  RecordTypeID ='012G0000000qhDM',
                                  Family__Primary_Language__c = 'Mandarin',
                                  Family__Professional__c = TRUE,
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
                                 Family__Race__c = '',
                                 Family__Gender__c = 'Female',
                                 School_Type__c ='Does not apply',
                                 npo02__Household__c=acctA.Id));
            
        }       
        Insert chD2;
        
        //Create 10 Campaign events in December with above KIScontacts
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
        
        //Create 10 Interactions in Nov 2015 with above contacts
        List<Case> cas2 = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact cont2 = cons2[j]; 
            Contact Kid2 = chd2[j];
            Datetime myDateTime2 = Datetime.newInstance(2016, 11, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            cas2.add(new Case(ContactId = cont2.Id,
                              Call_Type__c = 'Mtg',
                              Origin = 'Phone',
                              Status = 'New',
                              Start_time__c = myDateTime2.addDays(j),
                              End_time__c = myDateTime2.addDays(j+1),
                              Family__Child__c = kid2.ID,
                              RecordTypeId = '012G0000000qhDL'));
            
        }
        insert cas2;
      
        List<CampaignMember> CM2 = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts-5);j++) {
            Contact co2 = cons2[j];
            Campaign campan2 = camp2[j];
            
            //for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {      
            CM2.add(new CampaignMember(ContactID = co2.Id,
                                       CampaignID = campan2.Id,
                                       Status = 'Family Attendee'));
            
        }     
		System.debug(CM2.size());        
        insert CM2; 
        
    }
     @isTest static void testMethod1() {
        Test.startTest();
        // insert data
        
        // get reference to EIS Dashboard Page
        PageReference AnnualRep = Page.AnnualReportsStats1;
        Test.setCurrentPage(AnnualRep);
        
        // get a Page controller instance
        AnnualReportCls AR = new AnnualReportCls();
        date TestDate = date.newInstance(2016, 1, 1 );
        date TestDateFrom = date.newInstance(2016, 12, 31 ); 
        // Set Date From and Date To on Controller
        Date controllerDateFrom = beginDate;
        Date controllerDateTo = endDate;
        AR.datefrom = controllerDateFrom;
        AR.dateTo = controllerDateTo;
        System.AssertEquals(AR.dateFrom, controllerDateFrom);
        System.AssertEquals(AR.dateTo, controllerDateTo);
        
        AR.startGenerateBoard(); 
        AR.getGenerateFedDis();
        AR.getGenerateTotalKids();
        AR.getGenerateGen();
        AR.getGenerateRace();
         AR.getGenerateRaceInt();
 		AR.getGenerateRaceCamp();
         AR.getGenerateFedDisCamp();
         AR.getGenerateFedDisInt();
        AR.getGenerateGenCamp();
         AR.getGenerateGenInt();
        
        
        
        Test.stopTest();        
        
    }
    @isTest static void testMethod42() {
        
        Test.startTest();
        PageReference AnnualRep = Page.AnnualReportsStats1;
        Test.setCurrentPage(AnnualRep);
        
        // get a Page controller instance
        AnnualReportCls AR = new AnnualReportCls();
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
        Test.stopTest();       
        
    }     
    
   @isTest static void testMethod3() {
        Test.startTest();
        // insert data
        
        // get reference to EIS Dashboard Page
        PageReference AnnualRep = Page.CPIRChildStats;
        Test.setCurrentPage(AnnualRep);
        
        // get a Page controller instance
        CPIRChildStats AR = new CPIRChildStats();
        date TestDate = date.newInstance(2016, 12, 31 );
        date TestDateFrom = date.newInstance(2016, 1, 1 ); 
        // Set Date From and Date To on Controller
        Date controllerDateFrom = beginDate;
        Date controllerDateTo = endDate;
        AR.datefrom = controllerDateFrom;
        AR.dateTo = controllerDateTo;
        System.AssertEquals(AR.dateFrom, controllerDateFrom);
        System.AssertEquals(AR.dateTo, controllerDateTo);
        
        AR.startGenerateBoard(); 
        AR.getGenerateFedDis();
        AR.getGenerateEthInt();
        AR.getGenerateEthCamp();
        AR.getGenerateRace();
         AR.getGenerateRaceInt();
 		AR.getGenerateRaceCamp();
         AR.getGenerateFedDisCamp();
         AR.getGenerateFedDisInt();
        AR.getGenerateGenCamp();
         AR.getGenerateGenInt();
       AR.getGenerateEthAll();
        AR.getGenerateGenAll();
        
        
        Test.stopTest();        
        
    }
    @isTest static void testMethod4() {
        
        Test.startTest();
        PageReference AnnualRep = Page.CPIRChildStats;
        Test.setCurrentPage(AnnualRep);
        
        // get a Page controller instance
        CPIRChildStats AR = new CPIRChildStats();
        date TestDateTo = date.newInstance(2016, 1, 31 );
        date TestDateFrom = date.newInstance(2016, 12, 1 );
        // Set Date From and Date To on Controller
        Date controllerDateFrom = endDate;
        Date controllerDateTo = beginDate ;
        AR.datefrom = controllerDateFrom;
        AR.dateTo = controllerDateTo;
        System.AssertEquals(AR.dateFrom, controllerDateFrom);
        System.AssertEquals(AR.dateTo, controllerDateTo);
        AR.startGenerateBoard(); 
        Test.stopTest();       
        
    } 
     @isTest static void testMethod5() {
        
        Test.startTest();
        PageReference AnnualRep = Page.CPIRChildStats;
        Test.setCurrentPage(AnnualRep);
        
        // get a Page controller instance
        CPIRChildStats AR = new CPIRChildStats();
       date TestDateTo = date.newInstance(2016, 7, 31 );
        date TestDateFrom = date.newInstance(2016, 12, 1 );
        // Set Date From and Date To on Controller
        Date controllerDateFrom = endDate;
        Date controllerDateTo = Null ;
        AR.datefrom = controllerDateFrom;
        AR.dateTo = controllerDateTo;
        System.AssertEquals(AR.dateFrom, controllerDateFrom);
        System.AssertEquals(AR.dateTo, controllerDateTo);
        AR.startGenerateBoard(); 
        Test.stopTest();       
        
    } 
    
}