@isTest
//For FEC child Disabilty & ethnicity
public class Fec_Test {
    
    Private static RecordType rtProgramCampaign = [Select Id, Name from RecordType where Name = 'Program Campaign'  AND sObjectType = 'Campaign' limit 1];
    Private static RecordType rtAdultContact = [select Id from RecordType where Name = 'Adult' and SobjectType = 'Contact' LIMIT 1];//Grab all required fields?
    Private static RecordType rtChildContact = [Select Id, Name from RecordType where Name = 'Child/Person With Disability'  and SobjectType = 'Contact' limit 1];
    Private static RecordType rtFamilyInteraction = [Select Id, Name from RecordType where Name = 'Family Case' AND sObjectType = 'Case' limit 1];
    Private static RecordType rtProfInteraction = [Select Id, Name from RecordType where Name = 'Professional Case' AND sObjectType = 'Case' limit 1];
       
    static private Integer numAccts = 12;
    static private Integer numContactsPerAcct =12;
    static date beginDate = date.newInstance(2016, 7, 1);
    static date endDate = date.newInstance(2017, 6, 30);  
    static date bday = date.newInstance(1995, 6, 30);   
    
       @testSetup static void createTestRecords() {
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;  
        
        List<npo02__Household__c> accts = new List<npo02__Household__c>();
        for(Integer i=0;i<numAccts;i++) {
            npo02__Household__c a = new npo02__Household__c(Name='Householdx' + i,
                                                            npo02__MailingPostalCode__c ='94110');
            
            accts.add(a);
        }
        Database.insert(accts, dml);
        
        
        // For each account just inserted, add 10 adult contacts
        //List<Contact> cons = new List<Contact>();
       Contact  conA = new Contact(firstname='Tst',
                                 lastname='Adult' ,
                                 RecordTypeID =rtAdultContact.Id,
                                 Family__Primary_Language__c = 'Spanish',
                                 Family__Gender__c = 'Female',
                                 Underserved__c= TRUE,
                                 Low_Income__c= TRUE,
                                 Income__c = 'Homeless',
                                 Housing_Status__c ='Vehicle',
                                 lep__c = 'Declined',
                                 Incarcerated_youth__c = True);
            
        
       
      Database.insert(conA, dml);
                       
            
         Contact  con = new Contact(firstname='Tst',
                                 lastname='Adult' ,
                                 RecordTypeID =rtChildContact.Id,
                                 Family__Primary_Language__c = 'Spanish',
                                 Family__Gender__c = 'Female',
                                 Underserved__c= TRUE,
                                 Low_Income__c= TRUE,
                                 Income__c = 'Homeless',
                                 Housing_Status__c ='Vehicle',
                                 lep__c = 'Declined',
                                 Incarcerated_youth__c = True);
            
        
       
      Database.insert(con, dml);
        
        // Child Record ID
        // 012G0000000qhDN
      Map <Integer, String> RaceMap =  new Map <Integer, String>{0 =>  'White' , 1 =>'Multi', 2 => 'African', 3 =>'Asian',
            														 4 => 'Pacific', 5 => 'Middle', 
            															6 =>'Native American', 7 =>'Declined', 8 => 'Unknown', 
            																9 => 'Other', 10 =>'Native Alaskan',  11 => 'Asian; White'}; 

        
        List<Contact> RaceKids = new List <Contact>();
        for (Integer j=0;j<numContactsPerAcct;j++) {
              npo02__Household__c acct = accts[j];          
       
            RaceKids.add(new Contact(firstname='Kid'+ j,
                                lastname='Kid'+ j,
                                Birthdate = bday.addyears(j),
                                RecordTypeID = rtChildContact.Id,
                                Family__Primary_Language__c = 'English',
                                //Family__Ethnicity__c ='Unknown',
                               // Hispanic_Latino_please_specify__c = 'Central American',
                               // Family__Ethnicity__c ='Hispanic or Latino',
                                Family__Primary_Diagnostic_Category__c = 'Gifted',
                                Family__Race__c = RaceMap.get(j),
                                //Race_Other__c = '',
                                Family__Gender__c = 'Male',
                                School_Type__c ='Does not apply',
                                npo02__Household__c = acct.Id
                                    ));
            
          }   
        System.assertEquals(12, RaceKids.size());
        System.assertEquals('Native American', RaceKids.get(6).Family__Race__c);
        Database.insert(racekids, dml);
        
        
        
        //Create 10 Interactions in Jan 2016 with above contacts
        List<Case> cas = new List<Case>();
        for (Integer j=0;j<10;j++) {
            Contact cont = RaceKids[j]; 
            Contact Kid = RaceKids[j];
            Datetime myDateTime = Datetime.newInstance(2016,12, 1);
          
            cas.add(new Case(ContactId = cont.Id,
                             Call_Type__c = 'Contact',
                             Origin = 'In-person',
                             Status = 'Closed',
                             Start_time__c = myDateTime.addDays(j),
                             Add_5_Mins_to_Start_Time_For_End_Time__c =5,
                             Family__Child__c = kid.ID,
                             RecordTypeId = rtFamilyInteraction.id));
            
        }
        Database.insert(cas, dml);
        
      
     //Create 10 Interactions in Sept 2015 with above contacts
        List<Case> casO = new List<Case>();
        for (Integer j=0;j<numContactsPerAcct;j++) {
            //Contact contO = cons[j]; 
            Contact KidO = RaceKids[j];
            Datetime myDateTimeO = Datetime.newInstance(2016, 9, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            casO.add(new Case(ContactId = conA.Id,
                              Call_Type__c = 'Contact',
                              Origin = 'In-person',
                             // Status = 'Closed',
                              Start_time__c = myDateTimeO.addDays(j),
                              Family__Child__c = kidO.ID,
                              RecordTypeId = rtProfInteraction.Id));
            
        }
        insert casO;

        List<npo02__Household__c> accts2 = new List<npo02__Household__c>();
        for(Integer i=0;i<numAccts;i++) {
            npo02__Household__c a = new npo02__Household__c(Name='Apr-' + i,
                                                            npo02__MailingPostalCode__c ='94123');
            
            accts2.add(a);
        }
        Database.insert(accts2, dml);
        
        
       
         Contact  con2 = new Contact(firstname='AprilMndarinMale-',
                                  lastname='Apr-' ,
                                  RecordTypeID = rtAdultContact.Id,
                                  Family__Primary_Language__c = 'Mandarin',
                                  Family__Professional__c = TRUE,
                                  Family__Gender__c = 'Male');
    
        insert con2;
        
        // Child Record ID
        // 012G0000000qhDN
        List<Contact> chD2 = new List<Contact>();
        date pm2 = date.newInstance(2001, 9, 1 );
        for (Integer j=0;j<numContactsPerAcct;j++) {
            npo02__Household__c acctA = accts2[j];            
            
            chD2.add(new Contact(firstname='KidFEnParCant'+ j,
                                 lastname='zi-'+ j,
                                 Birthdate = pm2.addyears(j),
                                 RecordTypeID = rtChildContact.id,
                                  Family__Primary_Language__c = 'Spanish',
                                 Family__Ethnicity__c ='Hispanic or Latino',
                                 Hispanic_Latino_please_specify__c = 'Central American',
                                 Family__Race__c = RaceMap.get(j),
                                 Family__Gender__c = 'Female',
                                 Family__Primary_Diagnostic_Category__c = 'Autism Spectrum',
                                 School_Type__c ='Does not apply',
                                 npo02__Household__c=acctA.Id));
            
        }       
        Database.insert(Chd2, dml);
      
    }
     @isTest static void testMethod1() {
        Test.startTest();
        // insert data
        
        // get reference to EIS Dashboard Page
        PageReference FEC = Page.FecVF;
        Test.setCurrentPage(FEC);
        
        // get a Page controller instance
        FecCtr AR = new FecCtr();
        date TestDate = date.newInstance(2017, 6, 30 );
        date TestDateFrom = date.newInstance(2016, 7, 1 ); 
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
        AR.getGenerateParentLanguage();
        AR.getGenerateFamiliyIntTotalsTotals();
 		AR.getGenerateHHTotals();
        AR.getGenerateProfTotals();
        AR.getGenerateProfIntTotals();
           AR.getGenerateKidLanguage();
            AR.getGenerateFamiliyIntWithAgeLimitTotals();
        AR.getGenerateFamiliyIntTotalsTotals();
         AR.getGenerateProfCallTypeTotals();
        AR.getGenerateParentRT();
         AR.getGenerateParentRace();
        AR.getGenerateParentEth();
        
        
        Test.stopTest();        
        
    }
    @isTest static void testMethod2() {
        
        Test.startTest();
           PageReference FEC = Page.FecVF;
        Test.setCurrentPage(FEC);
        
        // get a Page controller instance
        FecCtr AR = new FecCtr();
        date TestDateTo = date.newInstance(2016, 7, 31 );
        date TestDateFrom = date.newInstance(2016, 12, 1 );
        // Set Date From and Date To on Controller
        Date controllerDateFrom = TestDateFrom;
        Date controllerDateTo = TestDateTo;
        AR.datefrom = controllerDateFrom;
        AR.dateTo = controllerDateTo;
        System.AssertEquals(AR.dateFrom, controllerDateFrom);
        System.AssertEquals(AR.dateTo, controllerDateTo);
        AR.startGenerateBoard(); 
         AR.getGenerateFedDis();
        AR.getGenerateTotalKids();
        AR.getGenerateGen();
        AR.getGenerateRace();
         AR.getGenerateParentLanguage();
 		AR.getGenerateHHTotals();
        AR.getGenerateProfTotals();
          AR.getGenerateKidLanguage();
        AR.getGenerateFamiliyIntWithAgeLimitTotals();
        AR.getGenerateFamiliyIntTotalsTotals();
         AR.getGenerateProfCallTypeTotals();
        AR.getGenerateParentRT();
        Test.stopTest();       
        
    }     
     @isTest static void testMethod3() {
        
        Test.startTest();
           PageReference FEC = Page.FecVF;
        Test.setCurrentPage(FEC);
        
        // get a Page controller instance
        FecCtr AR = new FecCtr();
        //date TestDateTo = date.newInstance();
       // date TestDateFrom = date.newInstance( );
        // Set Date From and Date To on Controller
        Date controllerDateFrom = endDate;
        Date controllerDateTo = beginDate ;
        AR.datefrom = NULL; //controllerDateFrom;
        AR.dateTo = controllerDateTo;
        //System.AssertEquals(AR.dateFrom, controllerDateFrom);
       // System.AssertEquals(AR.dateTo, controllerDateTo);
        AR.startGenerateBoard(); 
        AR.getGenerateFedDis();
        AR.getGenerateTotalKids();
        AR.getGenerateGen();
        AR.getGenerateRace();
        AR.getGenerateParentLanguage();
        AR.getGenerateProfTotals();
        AR.getGenerateKidLanguage();
        Test.stopTest();       
        
    }     
    
    
    //System.AssertEquals(.size(), 30);
    
}