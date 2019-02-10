@isTest
public class AgeByYear_Test {
    static private Integer numAccts = 1;
    static private Integer numContactsPerAcct = 5;
    static date beginDate = date.newInstance(2016, 1, 1);
    static date endDate = date.newInstance(2016, 12, 31);    
    
    @testSetup static void createTestRecords() {
        
 
        
        npo02__Household__c a = new npo02__Household__c(Name='Household',
                                                        npo02__MailingPostalCode__c ='94110');
        insert a;
        
        List<Contact> cons = new List<Contact>();
        
        
        cons.add(new Contact(firstname='GrownUp',
                             lastname='Fred',
                             RecordTypeID ='012G0000000qhDM',
                             Family__Primary_Language__c = 'Spanish',
                             Family__Gender__c = 'Female',
                             Underserved__c= TRUE,
                             Low_Income__c= TRUE,
                             Income__c = 'Homeless',
                             lep__c = 'Declined',
                             Incarcerated_youth__c = True,
                             npo02__Household__c=a.Id));
        
        insert cons;
        
        // Child Record ID
        // 012G0000000qhDN
        List<Contact> chD = new List<Contact>();
        date pm = date.newInstance(2003, 6, 1 );
        for (Integer j=0;j<numAccts;j++) {
            npo02__Household__c acct = a;            
            // For each account just inserted, add 10 kid contacts
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            chD.add(new Contact(firstname='Kid'+ j,
                                lastname='Kid'+ j,
                                Birthdate = pm.addYears(j),
                                RecordTypeID ='012G0000000qhDN',
                                Family__Primary_Language__c = 'English',
                                Family__Ethnicity__c ='Hispanic or Latino',
                                //Ethnicity_Hispanic_Latino_Other__c = 'Central American',
                                Hispanic_Latino_please_specify__c = 'Central American',
                                Family__Race__c = 'Asian - Chinese;)',
                                Race_Other__c = '',
                                Family__Gender__c = 'Male',
                                School_Type__c ='Does not apply',
                                npo02__Household__c=a.Id));
            
        }       
        Insert chD;
        
        
        
        //Create 10 Interactions in Jan 2016 with above contacts
        List<Case> cas = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact cont = cons[j]; 
            Contact Kid = chd[j];
            Datetime myDateTime = Datetime.newInstance(2016,8, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            cas.add(new Case(ContactId = cont.Id,
                             Call_Type__c = 'Contact',
                             Origin = 'In-person',
                             Status = 'Closed',
                             Start_time__c = myDateTime, //.addDays(j),
                             End_Time__c= myDateTime.addDays(j),
                             Family__Child__c = kid.ID,
                             RecordTypeId = '012G0000000qhDK'));
            
        }
        insert cas;
        
        
        List<npo02__Household__c> accts2 = new List<npo02__Household__c>();
        for(Integer i=0;i<numAccts;i++) {
            npo02__Household__c a2 = new npo02__Household__c(Name='Apr-' + i,
                                                             npo02__MailingPostalCode__c ='94123');
            
            accts2.add(a2);
        }
        insert accts2;
        
        
        List<Contact> cons2 = new List<Contact>();
        for (Integer j=0;j<numAccts;j++) {
            npo02__Household__c acct2 = accts2[j];            
            
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
        date pm2 = date.newInstance(2001, 9, 1 );
        for (Integer j=0;j<numAccts;j++) {
            npo02__Household__c acctA = accts2[j];            
            
            chD2.add(new Contact(firstname='KidFEnParCant'+ j,
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
        
                List<Contact> chD4 = new List<Contact>();
        date pm4 = date.newInstance(2001, 9, 1 );
        for (Integer j=0;j<numAccts;j++) {
            npo02__Household__c acctA = accts2[j];            
            
            chD4.add(new Contact(firstname='KidFEnParCant'+ j,
                                 lastname='zi-'+ j,
                                 Birthdate = pm4,
                                 RecordTypeID ='012G0000000qhDN',
                                 Family__Primary_Language__c = 'English',
                                 Family__Ethnicity__c ='Unknown',
                                 Family__Race__c = 'Native American;',
                                 Family__Gender__c = 'Female',
                                 School_Type__c ='Does not apply',
                                 npo02__Household__c=acctA.Id));
            
        }       
        Insert chD4;
        
       
        
        
        List<Case> cas2 = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact cont2 = cons2[j]; 
            Contact Kid2 = chd4[j];
            Datetime myDateTime2 = Datetime.newInstance(2016, 11, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            cas2.add(new Case(ContactId = cont2.Id,
                              Call_Type__c = 'contact',
                              Origin = 'Phone',
                              Status = 'New',
                              Start_time__c = myDateTime2,
                               End_Time__c= myDateTime2.addDays(j),
                              Family__Child__c = kid2.ID,
                              RecordTypeId = '012G0000000qhDL'));
            
        }
        insert cas2;
        
           //date pm7 = date.newInstance(2001, 9, 1 );
        Contact contact0 = new contact(firstname='s',
                                 lastname='i-',
                                // Birthdate = pm8,
                                 RecordTypeID ='012G0000000qhDN',
                                 Family__Primary_Language__c = 'English',
                                 Family__Ethnicity__c ='Unknown',
                                 Family__Race__c = 'Native American;',
                                 Family__Gender__c = 'Female',
                                 School_Type__c ='Does not apply');
        Insert Contact0;
       Datetime myDateTime9 = Datetime.newInstance(2016, 5, 1);
       
        Case  cas12= new Case(ContactId = cons2[0].Id,
                              Call_Type__c = 'contact',
                              Origin = 'Phone',
                              Status = 'New',
                              Start_time__c = myDateTime9,
                              End_time__c = myDateTime9+1,
                              Family__Child__c = Contact0.ID,
                              RecordTypeId = '012G0000000qhDL');
        Insert cas12;
        
        
        date pm8 = date.newInstance(2001, 9, 1 );
        Contact contact1 = new contact(firstname='s',
                                 lastname='i-',
                                 Birthdate = pm8,
                                 RecordTypeID ='012G0000000qhDN',
                                 Family__Primary_Language__c = 'English',
                                 Family__Ethnicity__c ='Unknown',
                                 Family__Race__c = 'Native American;',
                                 Family__Gender__c = 'Female',
                                 School_Type__c ='Does not apply');
        Insert Contact1;
        
       Datetime myDateTime8 = Datetime.newInstance(2016, 5, 1);
       Case  cas10= new Case(ContactId = cons2[0].Id,
                              Call_Type__c = 'contact',
                              Origin = 'Phone',
                              Status = 'New',
                               Start_time__c = myDateTime8,
                             End_time__c = myDateTime8 +1,
                              Family__Child__c = Contact1.ID,
                              RecordTypeId = '012G0000000qhDL');
        Insert cas10;
        
    }
    @isTest static void testMethod1() { 
        Test.startTest();
        // insert data
        
        // get reference to EIS Dashboard Page
        PageReference AnnualRep = Page.AgeByYearVF;
        Test.setCurrentPage(AnnualRep);
        
        // get a Page controller instance
        AgeByYear_Cls AR = new AgeByYear_Cls();
        date TestDate = date.newInstance(2016, 1, 1 );
        date TestDateTo = date.newInstance(2016, 12, 31 ); 
        //Set Date From and Date To on Controller
        Date controllerDateFrom = beginDate;
        Date controllerDateTo = endDate;
        AR.datefrom = controllerDateFrom;
        AR.dateTo = controllerDateTo;
        System.AssertEquals(AR.dateFrom, controllerDateFrom);
        System.AssertEquals(AR.dateTo, controllerDateTo);
        
        AR.startGenerateBoard(); 
        
	    AR.getGenerateKids0();
	    AR.getGenerateKids1();
	    AR.getGenerateKids2();
	    AR.getGenerateKids3();
	    AR.getGenerateKids4();
	    AR.getGenerateKids5();
	    AR.getGenerateKids6();
	    AR.getGenerateKids7();
	    AR.getGenerateKids8();
	    AR.getGenerateKids9(); 
	    AR.getGenerateKids10(); 
	    AR.getGenerateKids11(); 
	    AR.getGenerateKids12(); 
	    AR.getGenerateKids13(); 
	    AR.getGenerateKids14(); 
        
        Test.stopTest();        
        
    }
    @isTest static void testMethod4() {
        Test.startTest();
        // get reference to EIS Dashboard Page
        PageReference AnnualRep = Page.AgeByYearVF;
        Test.setCurrentPage(AnnualRep);
         AgeByYear_Cls AR = new AgeByYear_Cls();
        
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
        // get reference to EIS Dashboard Page
        PageReference AnnualRep = Page.AgeByYearVF;
        Test.setCurrentPage(AnnualRep);
         AgeByYear_Cls AR = new AgeByYear_Cls();
        
        date TestDateTo = date.newInstance(2016, 7, 31 );
       // date TestDateFrom = date.newInstance(2016, 12, 1 );
        // Set Date From and Date To on Controller
       // Date controllerDateFrom = endDate;
        Date controllerDateTo = beginDate ;
        //AR.datefrom = controllerDateFrom;
        AR.dateTo = controllerDateTo;
        //System.AssertEquals(AR.dateFrom, controllerDateFrom);
        System.AssertEquals(AR.dateTo, controllerDateTo);
        AR.startGenerateBoard();
        
        Test.stopTest();       
        
    }
    
}