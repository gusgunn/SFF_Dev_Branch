@isTest
public class CMS_ByMeasure_Test {
    static private Integer numAccts = 2;
    static private Integer numContactsPerAcct = 2;
    static date beginDate = date.newInstance(2016, 7, 1);
    static date endDate = date.newInstance(2016, 12, 31);  
    Static  DateTime myDateC = DateTime.newInstance(2014, 9, 30, 8,3, 5);
    //005160000073KW2
    
    @testSetup static void createTestRecords() {
        RecordType rt1 = [Select Id, Name from RecordType where Name = 'Program Campaign' limit 1];
        RecordType rt2 = [Select Id, Name from RecordType where Name = 'Default' limit 1];
        Map <Integer, String> esMap =  new Map <Integer, String>{0 =>  'ES3' , 1 =>'ES1', 2 => 'ES2', 
            3 =>'ES3', 4 => 'ES1', 5 => 'ES2', 
            6 =>'ES3', 7 =>'ES2', 8 => 'ES1', 
            9 => 'ES3', 10 =>'ES2',11 =>'ES1'}; 
                
                
                List<npo02__Household__c> accts = new List<npo02__Household__c>();
        for(Integer i=0;i<numAccts;i++) {
            npo02__Household__c a = new npo02__Household__c(Name='House-' + i,
                                                            npo02__MailingPostalCode__c ='94110');
            
            accts.add(a);
        }
        insert accts;
        
        
        // For each account just inserted, add 1 adult contacts
        List<Contact> cons = new List<Contact>();
        for (Integer j=0;j<numAccts;j++) {
            npo02__Household__c acct = accts[j];            
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            cons.add(new Contact(firstname='Adult-'+ j,
                                 lastname='Family-'+ j ,
                                 RecordTypeID ='012G0000000qhDM',
                                 Family__Primary_Language__c = 'Spanish',
                                 Family__Gender__c = 'Female',
                                 Underserved__c= TRUE,
                                 Low_Income__c= TRUE,
                                 Income__c = 'Homeless',
                                 Housing_Status__c ='Vehicle',
                                 MailingPostalCode = '94124',
                                 lep__c = 'Declined',
                                 Incarcerated_youth__c = True,
                                 
                                 npo02__Household__c=acct.Id));
            
        }
        // Insert all contacts for all accounts
        insert cons;
        
        // Child Record ID
        // 012G0000000qhDN
        List<Contact> chD = new List<Contact>();
        date pm = date.newInstance(2005, 6, 1 );
        for (Integer j=0;j<numAccts;j++) {
            npo02__Household__c acct = accts[j];            
            // For each account just inserted, add 10 kid contacts
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            chD.add(new Contact(firstname='Kid'+ j,
                                lastname='Family-'+ j,
                                Birthdate = pm,
                                RecordTypeID ='012G0000000qhDN',
                                Family__Primary_Language__c = 'English',
                                Family__Ethnicity__c ='Hispanic or Latino',
                                //Ethnicity_Hispanic_Latino_Other__c = 'Central American',
                                Hispanic_Latino_please_specify__c = 'Central American',
                                Family__Race__c = 'Asian - Chinese;)',
                                Race_Other__c = '',
                                Family__Gender__c = 'Male',
                                School_Type__c ='Does not apply',
                                npo02__Household__c=acct.Id));
            
        }       
        Insert chD;
        
        
        //Create 10 Interactions in 7, 2016 with above contacts
        List<Case> cas = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact cont = cons[j]; 
            Contact Kid = chd[j];
            Datetime myDateTime = Datetime.newInstance(2016,9, 30);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            cas.add(new Case(ContactId = cont.Id,
                             Call_Type__c = 'Contact',
                             Origin = 'In-person',
                             Status = 'Closed',
                             Start_time__c = myDateTime.addDays(j+80),
                             Add_5_Mins_to_Start_Time_For_End_Time__c =5+j,
                             //End_time__c=myDateTime.addDays(j+81),
                             Family__Child__c = kid.ID,
                             RecordTypeId = '012G0000000qhDK'));
            
        }
        insert cas;
        
        List<Case> cas6 = new List<Case>();
        for (Integer j=1;j<numAccts;j++) {
            Contact cont = cons[j]; 
            Contact Kid = chd[j];
            Datetime myDateTime = Datetime.newInstance(2016,9, 30);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            cas6.add(new Case(ContactId = cont.Id,
                              Call_Type__c = 'Mtg SDSE – Manifestation',
                              Origin = 'In-person',
                              Status = 'Closed',
                              Start_time__c = myDateTime.addDays(j+80),
                              Add_5_Mins_to_Start_Time_For_End_Time__c =5+j,
                              //End_time__c=myDateTime.addDays(j+81),
                              Family__Child__c = kid.ID,
                              RecordTypeId = '012G0000000qhDK'));
            
        }
        insert cas6;
        
        
        
        // Round 2  - same contacts, events in October
        
        //Create 10 Interactions in Sept 2015 with above contacts
        List<Case> casO = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact contO = cons[j]; 
            Contact KidO = chd[j];
            Datetime myDateTimeO = Datetime.newInstance(2016, 9, 29, 12,5,5);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            casO.add(new Case(ContactId = contO.Id,
                              Call_Type__c = 'Contact',
                              Origin = 'In-person',
                              Status = 'Closed',
                              Start_time__c = myDateTimeO.addDays(j),
                              Add_5_Mins_to_Start_Time_For_End_Time__c =5+j,
                              //End_time__c=myDateTimeO.addDays(j+1),
                              Family__Child__c = kidO.ID,
                              OwnerID = '005160000073KW2',
                              CMSQ__c = string.ValueOf(j+1),
                              
                              RecordTypeId = '012G0000000qhDK'));
            
        }
        insert casO;
        
        
        
        
        List<npo02__Household__c> accts2 = new List<npo02__Household__c>();
        for(Integer i=0;i<numAccts;i++) {
            npo02__Household__c a = new npo02__Household__c(Name='Apr-' + i,
                                                            npo02__MailingPostalCode__c ='94123');
            
            accts2.add(a);
        }
        insert accts2;
        
        
        // For each account just inserted, add  adult contacts
        List<Contact> cons2 = new List<Contact>();
        for (Integer j=0;j<numAccts;j++) {
            npo02__Household__c acct2 = accts2[j];            
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            cons2.add(new Contact(firstname='Ap-'+ j,
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
            chD2.add(new Contact(firstname='KidF'+ j,
                                 lastname='zi-'+ j,
                                 Birthdate = pm2.addYears(j),
                                 RecordTypeID ='012G0000000qhDN',
                                 Family__Primary_Language__c = 'English',
                                 Family__Ethnicity__c ='Unknown',
                                 Family__Race__c = 'Native American;',
                                 Family__Gender__c = 'Female',
                                 School_Type__c ='Does not apply',
                                 npo02__Household__c=acctA.Id));
            
        }       
        Insert chD2;
        
        
        
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
                              Start_time__c = myDateTime2,
                              Add_5_Mins_to_Start_Time_For_End_Time__c =5+j,
                              //End_time__c=myDateTime2.addDays(j),
                              Family__Child__c = kid2.ID,
                              
                              
                              RecordTypeId = '012G0000000qhDK'));
            
        }
        insert cas2;
        //Professional case
        List<Case> cas22 = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact cont2 = cons2[j]; 
            Contact Kid2 = chd[j];
            Datetime myDateTime2 = Datetime.newInstance(2016, 11, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            cas22.add(new Case(ContactId = cont2.Id,
                               Call_Type__c = 'Contact',
                               Origin = 'Phone',
                               Status = 'New',
                               Start_time__c = myDateTime2,
                               Add_5_Mins_to_Start_Time_For_End_Time__c =5+j,
                               //End_time__c=myDateTime2.addDays(j),
                               Family__Child__c = kid2.ID,
                               // Family__Household__c = kid.npo02__Household__r.ID,
                               
                               RecordTypeId = '012G0000000qhDL'));
            
        }
        insert cas22;
        
        //Professional case
        List<Case> cas222 = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact cont2 = cons2[j]; 
            Contact Kid2 = chd2[j];
            Datetime myDateTime2 = Datetime.newInstance(2016, 11, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            cas222.add(new Case(ContactId = cont2.Id,
                                Call_Type__c = 'Contact',
                                Origin = 'Phone',
                                Status = 'New',
                                Start_time__c = myDateTime2,
                                Add_5_Mins_to_Start_Time_For_End_Time__c =5+j,
                                //End_time__c=myDateTime2.addDays(j),
                                Family__Child__c = kid2.ID,
                                // Family__Household__c = kid.npo02__Household__r.ID,
                                
                                RecordTypeId = '012G0000000qhDL'));
            
        }
        insert cas222;
        
        
    } 
    
    @isTest static void testMethod1() {
        
        
        Test.startTest();
        // get reference to page
        PageReference report = Page.CMS_ByMeasure_VF;
        Test.setCurrentPage(report);
        
        // get a Page controller instance
        CMS_ByMeasure AR = new CMS_ByMeasure();
        date TestDateTo = date.newInstance(2016, 12, 31 );
        date TestDateFrom = date.newInstance(2016, 7, 1 ); 
        // Set Date From and Date To on Controller
        Date controllerDateFrom = beginDate;
        Date controllerDateTo = endDate;
        AR.datefrom = controllerDateFrom;
        AR.dateTo = controllerDateTo;
        System.AssertEquals(AR.dateFrom, controllerDateFrom);
        System.AssertEquals(AR.dateTo, controllerDateTo);
        
        AR.startGenerateBoard(); 
        
        AR.getFRSInteractions();
        
        Test.stopTest();       
        
    }
    
    @isTest static void testMethod2() {
        
        
        Test.startTest();
        // insert data
        
        // get reference to EIS Dashboard Page
        PageReference report = Page.CMS_ByMeasure_VF;
        Test.setCurrentPage(report);
        
        
        CMS_ByMeasure AR = new CMS_ByMeasure();
        date TestDateTo = date.newInstance(2016, 9, 30 );
        date TestDateFrom = date.newInstance(2016, 7, 1 ); 
        // Set Date From and Date To on Controller
        Date controllerDateFrom = TestDateTo;
        Date controllerDateTo = TestDateTo ;
        
        AR.datefrom = controllerDateFrom;
        AR.dateTo = controllerDateTo;
        System.AssertEquals(AR.dateFrom, controllerDateFrom);
        System.AssertEquals(AR.dateTo, controllerDateTo);
        AR.startGenerateBoard(); 
        
        AR.getFRSInteractions();
        
        Test.stopTest();     
        
    }
    
    @isTest static void testMethod3() {
        
        Test.startTest();
        // get reference to EIS Dashboard Page
        PageReference report =Page.CMS_ByMeasure_VF;
        Test.setCurrentPage(report);
        
        // Use bad date range to get a Page controller instance
        CMS_ByMeasure AR = new CMS_ByMeasure();
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
        Test.stopTest();             
    }
    
    @isTest static void testMethod4() {
        
        Test.startTest();
        PageReference report = Page.CMS_ByMeasure_VF;
        Test.setCurrentPage(report);
        
        // Use bad date range to get a Page controller instance
        CMS_ByMeasure AR = new CMS_ByMeasure();
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
    
    @isTest static void testMethod5() {
        Test.startTest();
        
        PageReference report = Page.CMS_ByMeasure_VF;
        Test.setCurrentPage(report);
        CMS_ByMeasure AR = new CMS_ByMeasure();
        date TestDateTo = date.newInstance(2017, 3, 31 );
        date TestDateFrom = date.newInstance(2016, 7, 1 ); 
        AR.datefrom = TestDateFrom;
        AR.dateTo = TestDateTo;
        AR.startGenerateBoard(); 
        AR.getFRSInteractions();
        Test.stopTest();     
    }
    
    @isTest static void testMethod6() {
        Test.startTest();
        PageReference report = Page.CMS_ByMeasure_VF;
        Test.setCurrentPage(report);
        CMS_ByMeasure AR = new CMS_ByMeasure();
        Date TestDateTo = date.newInstance(2017, 6, 30 );
        Date TestDateFrom = date.newInstance(2016, 7, 1 ); 
        AR.datefrom = TestDateFrom;
        AR.dateTo = TestDateTo;
        AR.startGenerateBoard(); 
        AR.getFRSInteractions();
        Test.stopTest();     
    }
    //System.AssertEquals(x.size(), 30);
    
}