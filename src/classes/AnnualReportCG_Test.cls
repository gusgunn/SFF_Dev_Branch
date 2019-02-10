@isTest
public class AnnualReportCG_Test {
    static private Integer numAccts = 3;
    static private Integer numContactsPerAcct = 3;
    static date beginDate = date.newInstance(2016, 1, 1);
    static date endDate = date.newInstance(2016, 12, 31);    
    
    @testSetup static void createTestRecords()  {
          Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave=true;
        
      // List<String> EspList = new List <String>();  
        

        List<npo02__Household__c> accts = new List<npo02__Household__c>();
        for(Integer i=0;i<numAccts;i++) {
            npo02__Household__c a = new npo02__Household__c(Name='July15-' + i,
                                                           npo02__MailingPostalCode__c ='94110');
            
            accts.add(a);
        }
        
        database.insert(accts, dml);
        
        Map <Integer, String> RaceMap =  new Map <Integer, String>{0 =>  'White - European American' , 1 =>'Multiracial/Multiethnic', 2 => 'African American', 3 =>'Asian - Chinese',
                                                                     4 => 'Pacific Islander - Samoan', 5 => 'Middle Eastern - Arab', 
                                                                        6 =>'Native American', 7 =>'Declined', 8 => 'Unknown', 
                                                                            9 => 'Other', 10 =>'Native Alaskan'}; 

        
        List<Contact> RaceKids = new List <Contact>();
        for (Integer j=0;j<10;j++) {
                        
       
            RaceKids.add(new Contact(firstname='Kid'+ j,
                                lastname='Kid'+ j,
                               // Birthdate = bday.addDays(j),
                                RecordTypeID ='012G0000000qhDM',
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
        Database.Insert( RaceKids, dml);
        
        Contact checkRace =[SELECT Family__Race__c
                           FROM Contact
                           WHERE ID=:RaceKids.get(6).ID];
        System.assertEquals('Native American', checkRace.Family__Race__c);
        
        
         // For each account just inserted, add 1 adult contacts
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
                                     Family__Race__c = RaceMap.get(j+2),
                                     Income__c = 'Homeless',
                                     Housing_Status__c ='Vehicle',
                                     MailingPostalCode = '94124',
                                     lep__c = 'Declined',
                                     Incarcerated_youth__c = True,
                                     
                                     npo02__Household__c=acct.Id));
            
        }
        // Insert all contacts for all accounts
        
        database.insert(cons, dml);
        
        // Child Record ID
        // 012G0000000qhDN
        List<Contact> chD = new List<Contact>();
        date pm = date.newInstance(2014, 6, 1 );
        for (Integer j=0;j<numAccts;j++) {
            npo02__Household__c acct = accts[j];            
            // For each account just inserted, add 10 kid contacts
           // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
                chD.add(new Contact(firstname='JulyKidMaleEnParSp'+ j,
                                    lastname='July15-'+ j,
                                    Birthdate = pm.addDays(j),
                                    RecordTypeID ='012G0000000qhDN',
                                    Family__Primary_Language__c = 'English',
                                    Family__Ethnicity__c ='Hispanic or Latino',
                                    //Ethnicity_Hispanic_Latino_Other__c = 'Central American',
                                    Hispanic_Latino_please_specify__c = 'Central American',
                                    Family__Race__c = RaceMap.get(j+4),
                                    Race_Other__c = '',
                                    Family__Gender__c = 'Male',
                                    School_Type__c ='Does not apply',
                                    npo02__Household__c=acct.Id));
            
        }       
       
        database.insert(chD, dml);
        
        
        //Create 10 Interactions in Jan 2016 with above contacts
        List<Case> cas = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact cont = RaceKids[j]; 
            Contact Kid = chd[j];
            Datetime myDateTime = Datetime.newInstance(2016,7, 1);
           // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
                cas.add(new Case(ContactId = cont.Id,
                                 Call_Type__c = 'Contact',
                                 Origin = 'In-person',
                                 Status = 'Closed',
                                 Start_time__c = myDateTime,
                                 Add_5_Mins_to_Start_Time_For_End_Time__c = 5, 
                                 Family__Child__c = kid.ID,
                                 RecordTypeId = '012G0000000qhDK'));
             
        }
       
        database.insert(cas, dml);
        
        
        //Create 10 Campaign events in feb with above contacts
        List<Campaign> camp = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            
            Date myDate = Date.newInstance(2016, 7, 1);
            Datetime myDateTimeOc = Datetime.newInstance(2016, 7, 1);
           // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
                camp.add(new Campaign(Name='Prog'+ j,
                                      
                                      //RecordTypeId = '012G0000000qhDJ',
                                      isActive = True,
                                      Maximum_Capacity_Adults__c = 100,
                                      Maximum_Capacity_Children__c = 100,
                                      Type = 'Clinic',
                                      Start_Date_Time__c = myDateTimeOc,
                                       End_Date_Time__c  = myDateTimeOc.addDays(j+1),
                                      StartDate = myDate));
            
        }   
        
       
        database.insert(camp, dml);
        
        DateTime myCDate = DateTime.newInstance(2016, 7, 1, 8,3, 5);
        List<CampaignMember> CM = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts);j++) {
            Contact co = cons[j];
            Campaign campan = camp[j];
            
            //for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {      
                CM.add(new CampaignMember(ContactID = co.Id,
                                          CampaignID = campan.Id,
                                          
                                          Status = 'Family Attendee'));
            
        }             
        
        database.insert(CM, dml);
        
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
                                              Status = 'Family Attendee' ));
            
        }             
      
        database.insert(CMKids, dml);
        
      /***************** Round 2  - same contacts, events in October
       * *****************************/
         //Create 10 Interactions in Sept 2015 with above contacts
        List<Case> casO = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact contO = cons[j]; 
            Contact KidO = chd[j];
            Datetime myDateTimeO = Datetime.newInstance(2016, 9, 1);
           // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
                casO.add(new Case(ContactId = contO.Id,
                                 Call_Type__c = 'Contact',
                                 Origin = 'In-person',
                                 Status = 'Closed',
                                 Start_time__c = myDateTimeO.addDays(j),
                                 Add_5_Mins_to_Start_Time_For_End_Time__c = 5, 
                                 Family__Child__c = kidO.ID,
                                 RecordTypeId = '012G0000000qhDK'));
             
        }
       
        database.insert(casO, dml);
        
        
        //Create  Campaign events in October with above contacts - shouldnt count
        List<Campaign> campO = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            Datetime myDateTimeOc = Datetime.newInstance(2016, 10, 1);
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
                                        End_Date_Time__c  = myDateTimeOc.addDays(j+1),
                                      StartDate = myDateO.addDays(j)));
            
        }   
        
      
        database.insert(campO, dml);
        
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
      
        database.insert(CMO, dml);
        System.debug(' cam Members inserted line 199= ' + CMO );
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
                                              Status = 'Family Attendee' ));
            
        }             
       
        database.insert(CMKidsO, dml);
        
        
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
                                     Family__Race__c = RaceMap.get(j+6),
                                     Family__Professional__c = TRUE,
                                     Family__Gender__c = 'Male',
                                     npo02__Household__c=acct2.Id));
            
        }
       database.insert(cons2, dml);
        
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
                                    RecordTypeID ='012G0000000qhDM',
                                    Family__Primary_Language__c = 'English',
                                    Family__Ethnicity__c ='Unknown',
                                    Family__Race__c = 'Native American;',
                                    Family__Gender__c = 'Female',
                                    School_Type__c ='Does not apply',
                                    npo02__Household__c=acctA.Id));
            
        }       
       database.insert(chD2, dml);
  
        //Create 10 Campaign events in December with above KIScontacts
        List<Campaign> camp2 = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            Datetime myDateTime11 = Datetime.newInstance(2016, 5, 1);
            Date myDate11 = Date.newInstance(2016, 12, 1);
           // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
                camp2.add(new Campaign(Name='xellentEvent'+ j,
                                      //CampaignMemberRecordType ='012G0000000sIkG', 
                                      RecordTypeId = '012G0000000qhDJ',
                                      isActive = True,
                                      Maximum_Capacity_Adults__c = 1000,
                                      Maximum_Capacity_Children__c = 1000,
                                      Type = 'Workshop',
                                      Start_Date_Time__c = myDateTime11.addDays(j),
                                       End_Date_Time__c  = myDateTime11.addDays(j),
                                      StartDate = myDate11.addDays(j)));
            
        }   
     
        database.insert(camp2, dml);
        
        // create 5 child campaign members- attendees of above events - should count but no parent on on record linked as attending
        // with above contacts,(should not be counted as they are duplicates)
        List<CampaignMember> CMKids2 = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts-5);j++) { 
            Contact campKids2 = cons2[j];
            Campaign campa2 =camp2[j];
            //for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {      
                CMKids2.add(new CampaignMember(CampaignID = campa2.Id,
                                              ContactID = campKids2.Id,
                                              //Account_ID__c = acct.Id,
                                              Status = 'Family Attendee' ));  
        }             
       
        database.insert(CMKids2, dml);
        
       //Create 10 Interactions in Nov 2015 with above contacts
        List<Case> cas2 = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact cont2 = cons2[j]; 
            Contact Kid2 = chd2[j];
            Datetime myDateTime2 = Datetime.newInstance(2016, 10, 1);
           // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
                cas2.add(new Case(ContactId = cont2.Id,
                                 Call_Type__c = 'Contact',
                                 Origin = 'Phone',
                                 Status = 'New',
                                 Start_time__c = myDateTime2.addDays(j),
                                Add_5_Mins_to_Start_Time_For_End_Time__c = 5, 
                                 Family__Child__c = kid2.ID,
                                 RecordTypeId = '012G0000000qhDL'));
             
        }
       
        database.insert(cas2, dml);
        
        List<CampaignMember> CM2 = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts-5);j++) {
            Contact co2 = cons2[j];
            Campaign campan2 = camp2[j];
            
            //for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {      
                CM2.add(new CampaignMember(ContactID = co2.Id,
                                          CampaignID = campan2.Id,
                                          Status = 'Family Attendee'));
            
        }             
        
        database.insert(CM2, dml);
        }
         @isTest static void testMethod1() {
         Test.startTest();
  
        // get reference to EIS Dashboard Page
        PageReference AnnualRep = Page.AnnualReportStatsCG;
        Test.setCurrentPage(AnnualRep);
        
        // get a Page controller instance
        AnnualReportStatsCG AR = new AnnualReportStatsCG();
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
       AR.getGenerateParentLanguage();
       AR.getGenerateRace();
     AR.getGenerateEthnicity();
       AR.getGenerateZip();
       AR.getGenerateIntTotals();
       AR.getGenerateCampTotals();
                AR.getGenerateIntEduCampTotals();
             AR.getGenerateParentLanguageEduInt();
       
        Test.stopTest();  
    }

         @isTest static void testMethod2() {
        
        
        Test.startTest();
        // insert data
        
        // get reference to  Dashboard Page
        PageReference AnnualRep = Page.AnnualReportStatsCG;
        Test.setCurrentPage(AnnualRep);
        
        // bad date range
        AnnualReportStatsCG AR = new AnnualReportStatsCG();
        date TestDateTo = date.newInstance(2016, 1, 31 );
        date TestDateFrom = date.newInstance(2016, 12, 1 ); 
        // Set Date From and Date To on Controller
        Date controllerDateFrom = TestDateTo;
        Date controllerDateTo = TestDateTo ;
        
        AR.datefrom = controllerDateFrom;
        AR.dateTo = controllerDateTo;
        System.AssertEquals(AR.dateFrom, controllerDateFrom);
        System.AssertEquals(AR.dateTo, controllerDateTo);
        
        AR.startGenerateBoard(); 
        
        Test.stopTest();       
        
    }
    
    @isTest static void testMethod3() {
        
        Test.startTest();
        // get reference to EIS Dashboard Page
         PageReference AnnualRep = Page.AnnualReportStatsCG;
        Test.setCurrentPage(AnnualRep);
        
        // bad date range 2
        AnnualReportStatsCG AR = new AnnualReportStatsCG();
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
           AR.getGenerateIntEduCampTotals();
        Test.stopTest();             
    }
    
    @isTest static void testMethod4() {
        
        Test.startTest();
       PageReference AnnualRep = Page.CPIRCaregivers;
        Test.setCurrentPage(AnnualRep);
        
        // get a Page controller instance
        AnnualReportStatsCG AR = new AnnualReportStatsCG();
        date TestDateTo = date.newInstance(2016, 1, 1 );
        date TestDateFrom = date.newInstance(2017, 12, 31 );
        // Set Date From and Date To on Controller
        Date controllerDateFrom = endDate;
        Date controllerDateTo = beginDate ;
        AR.datefrom = controllerDateFrom;
        AR.dateTo = controllerDateTo;
        System.AssertEquals(AR.dateFrom, controllerDateFrom);
        System.AssertEquals(AR.dateTo, controllerDateTo);
        AR.startGenerateBoard(); 
           AR.getGenerateIntEduCampTotals();
        Test.stopTest();       
        
    }
    
    @isTest static void testMethod5() {
        Test.startTest();
        
        PageReference AnnualRep = Page.AnnualReportStatsCG;
        Test.setCurrentPage(AnnualRep);
        
        // get a Page controller instance
        AnnualReportStatsCG AR = new AnnualReportStatsCG();
        date TestDateTo = date.newInstance(2016, 12, 31 );
        date TestDateFrom = date.newInstance(2016, 1, 1 ); 
        // Set Date From and Date To on Controller
        Date controllerDateFrom = TestDateFrom;
        Date controllerDateTo = TestDateTo;
        AR.datefrom = controllerDateFrom;
        AR.dateTo = controllerDateTo;
        System.AssertEquals(AR.dateFrom, controllerDateFrom);
        System.AssertEquals(AR.dateTo, controllerDateTo);
        
       AR.startGenerateBoard(); 
       AR.getGenerateParentLanguage();
       AR.getGenerateRace();
        AR.getGenerateEthnicity();
       AR.getGenerateZip();
       AR.getGenerateIntTotals();
       AR.getGenerateCampTotals();
       AR.getGenerateHH();
           AR.getGenerateIntEduCampTotals();
        AR.getGenerateParentLanguageEduInt();
    }
    
    @isTest static void testMethod6() {
        Test.startTest();
        
         PageReference AnnualRep = Page.AnnualReportStatsCG;
        Test.setCurrentPage(AnnualRep);
        
        // get a Page controller instance
        AnnualReportStatsCG AR = new AnnualReportStatsCG();
        date TestDateTo = date.newInstance(2017, 6, 30 );
        date TestDateFrom = date.newInstance(2016, 7, 1 ); 
        // Set Date From and Date To on Controller
        Date controllerDateFrom = TestDateFrom;
        Date controllerDateTo = TestDateTo;
        AR.datefrom = controllerDateFrom;
        AR.dateTo = controllerDateTo;
        System.AssertEquals(AR.dateFrom, controllerDateFrom);
        System.AssertEquals(AR.dateTo, controllerDateTo);
       
       AR.startGenerateBoard(); 
       AR.getGenerateParentLanguage();
       AR.getGenerateRace();
     AR.getGenerateEthnicity();
       AR.getGenerateZip();
       AR.getGenerateIntTotals();
       AR.getGenerateCampTotals();
          AR.getGenerateHH();
        AR.getGenerateIntEduCampTotals();
        AR.getGenerateParentLanguageEduInt();
        
    }      
        
      
  
}