@isTest
public class FecAgeTest {
    
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
            npo02__Household__c a = new npo02__Household__c(Name='July15-' + i,
                                                            npo02__MailingPostalCode__c ='94110');
            
            accts.add(a);
        }
        Database.insert(accts, dml);
        
        
        // For each account just inserted, add 10 adult contacts
        List<Contact> cons = new List<Contact>();
        for (Integer j=0;j<numAccts;j++) {
            npo02__Household__c acct = accts[j];            
            
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
        Database.insert(Cons, dml);
        
        // Child Record ID
        // 012G0000000qhDN
        List<Contact> chD = new List<Contact>();
        date pm = date.newInstance(2006, 6, 1 );
        for (Integer j=0;j<numAccts;j++) {
            npo02__Household__c acct = accts[j];            
            
            chD.add(new Contact(firstname='JulyKidMaleEnParSp'+ j,
                                lastname='July15-'+ j,
                                Birthdate = pm.addYears(j),
                                RecordTypeID ='012G0000000qhDN',
                                Family__Primary_Language__c = 'English',
                                Family__Ethnicity__c ='Hispanic or Latino',
                                Hispanic_Latino_please_specify__c = 'Central American',
                                Family__Race__c = 'Asian - Chinese;)',
                                Race_Other__c = '',
                                Family__Gender__c = 'Male',
                                School_Type__c ='Does not apply',
                                npo02__Household__c=acct.Id));
            
        }       
        Database.insert(Chd, dml);
        
        
        //Create 10 Interactions in  with above contacts
        List<Case> cas = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact cont = cons[j]; 
            Contact Kid = chd[j];
            Datetime myDateTime = Datetime.newInstance(2017,1, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            cas.add(new Case(ContactId = cont.Id,
                             Call_Type__c = 'Contact',
                             Origin = 'In-person',
                             Status = 'Closed',
                             Start_time__c = myDateTime.addDays(j),
                             Family__Child__c = kid.ID,
                             RecordTypeId = '012G0000000qhDK'));
            
        }
        insert cas;
        
        
        
        
        /***************** Round 2  - same contacts, events in October

//Create 10 Interactions in Sept 2015 with above contacts
List<Case> casO = new List<Case>();
for (Integer j=0;j<numAccts;j++) {
Contact contO = cons[j]; 
Contact KidO = chd[j];
Datetime myDateTimeO = Datetime.newInstance(2015, 9, 1);
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


/********************************* Round 3 - new unduplicated contacs in November  */
        
        List<npo02__Household__c> accts2 = new List<npo02__Household__c>();
        for(Integer i=0;i<numAccts;i++) {
            npo02__Household__c a = new npo02__Household__c(Name='Apr-' + i,
                                                            npo02__MailingPostalCode__c ='94123');
            
            accts2.add(a);
        }
        Database.insert(accts2, dml);
        
        
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
        Database.insert(cons2, dml);
        
        // Child Record ID
        // 012G0000000qhDN
        List<Contact> chD2 = new List<Contact>();
        date pm2 = date.newInstance(2000, 9, 1 );
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
        Database.insert(chD2, dml);
        
        
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
                              Family__Child__c = kid2.ID,
                              RecordTypeId = '012G0000000qhDL'));
            
        }
        insert cas2;
        
     }
      @isTest static void testMethod1() {
        Test.startTest();
        // insert data
        
        // get reference to EIS Dashboard Page
        PageReference AnnualRep = Page.FecAgeVF;
        Test.setCurrentPage(AnnualRep);
        
        // get a Page controller instance
        FecAgeCtr AR = new FecAgeCtr();
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
        
        AR.getGenerateAge3_5(); 
        AR.getGenerateAge6_11();
        AR.getGenerateAge12_14();
        AR.getGenerateAge15_18();
        AR.getGenerateAge19_21();
        AR.getGenerateIntTotal();
        
        Test.stopTest();        
      }
     @isTest static void testMethod2() {
        Test.startTest();
        // insert data
        
        // get reference to EIS Dashboard Page
        PageReference AnnualRep = Page.FecAgeVF;
        Test.setCurrentPage(AnnualRep);
        
        // get a Page controller instance
        FecAgeCtr AR = new FecAgeCtr();
        
           date TestDateTo = date.newInstance(2016, 7, 31 );
        date TestDateFrom = date.newInstance(2016, 12, 1 );
        // Set Date From and Date To on Controller
        Date controllerDateFrom = TestDateFrom;
        Date controllerDateTo = TestDateTo;
        AR.datefrom = controllerDateFrom;
        AR.dateTo = controllerDateTo;
         AR.startGenerateBoard(); 
           
        Test.stopTest();        
      }
    @isTest static void testMethod3() {
        Test.startTest();
        // insert data
        
        // get reference to EIS Dashboard Page
        PageReference AnnualRep = Page.FecAgeVF;
        Test.setCurrentPage(AnnualRep);
        
        // get a Page controller instance
        FecAgeCtr AR = new FecAgeCtr();
          Date controllerDateFrom = endDate;
        Date controllerDateTo = beginDate ;
        AR.datefrom = NULL; //controllerDateFrom;
        AR.dateTo = controllerDateTo;
         AR.startGenerateBoard(); 
           
        Test.stopTest();        
      }
        
    }