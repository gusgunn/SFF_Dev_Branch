@isTest
public class CPIRcG_Test {
    static private Integer numAccts = 10;
    //static private Integer numContactsPerAcct = 8;
    static date beginDate = date.newInstance(2016, 1, 1);
    static date endDate = date.newInstance(2016, 12, 31);    
    
    @testSetup static void createTestRecords()  {
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave=true;
        
        // List<String> EspList = new List <String>();  
        
        
        List<npo02__Household__c> accts = new List<npo02__Household__c>();
        for(Integer i=0;i<10;i++) {
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
                                 Family__Race__c = RaceMap.get(j),
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
                                Family__Race__c = RaceMap.get(j),
                                Race_Other__c = '',
                                Family__Gender__c = 'Male',
                                School_Type__c ='Does not apply',
                                npo02__Household__c=acct.Id));
            
        }       
        
        database.insert(chD, dml);
        
        
        //Create 10 Interactions in Jan 2016 with above contacts
        List<Case> cas = new List<Case>();
        for (Integer j=0;j<10;j++) {
            Contact cont = cons[j]; 
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
        for (Integer j=0;j<10;j++) { 
            
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
       
    }
    @isTest static void testMethod1() {
        Test.startTest();
        
        // get reference to EIS Dashboard Page
        PageReference AnnualRep = Page.CPIRCG_VF;
        Test.setCurrentPage(AnnualRep);
        
        // get a Page controller instance
        CPIRcG AR = new CPIRcG();
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
        //AR.getGenerateCampTotals();
        
        
        
        Test.stopTest();  
    }
    
    @isTest static void testMethod2() {
        
        
        Test.startTest();
        // insert data
        
        // get reference to  Dashboard Page
        PageReference AnnualRep = Page.CPIRCG_VF;
        Test.setCurrentPage(AnnualRep);
        
        // bad date range
        CPIRcG AR = new CPIRcG();
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
        PageReference AnnualRep = Page.CPIRCG_VF;
        Test.setCurrentPage(AnnualRep);
        
        // bad date range 2
        CPIRcG AR = new CPIRcG();
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
        PageReference AnnualRep = Page.CPIRCG_VF;
        Test.setCurrentPage(AnnualRep);
        
        // get a Page controller instance
        CPIRcG AR = new CPIRcG();
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
        
        PageReference AnnualRep = Page.CPIRCG_VF;
        Test.setCurrentPage(AnnualRep);
        
        // get a Page controller instance
        CPIRcG AR = new CPIRcG();
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
        AR.startGenerateBoard(); 
        AR.getGenerateParentLanguage();
        AR.getGenerateRace();
        AR.getGenerateEthnicity();
        
        AR.getGenerateIntTotals();
        
        AR.getGenerateEthEduCampTotals();
        AR.getGenerateIntEduCampTotals();
        AR.getGenerateEthIntTotals();
        
        AR.getGenerateIntEduCampTotals();
        
        AR.getGenerateParentLanguageEduCamp();
        AR.getGenerateParentLanguage();
        
        AR.getGenerateZip();
        
        AR.getGenerateCampRace();
        AR.getGenerateIntRace();
    }
    
    @isTest static void testMethod6() {
        Test.startTest();
        
        PageReference AnnualRep = Page.CPIRCG_VF;
        Test.setCurrentPage(AnnualRep);
        
        // get a Page controller instance
        CPIRcG AR = new CPIRcG();
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
        
        AR.getGenerateIntTotals();
        
        AR.getGenerateEthEduCampTotals();
        AR.getGenerateIntEduCampTotals();
        AR.getGenerateEthIntTotals();
        
        AR.getGenerateIntEduCampTotals();
        
        AR.getGenerateParentLanguageEduCamp();
        AR.getGenerateParentLanguage();
        
        AR.getGenerateZip();
        
        AR.getGenerateCampRace();
        AR.getGenerateIntRace();
        
    }      
    
    
    
}