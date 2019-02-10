@isTest
public class AnnualReportAgeTest {
    static private Integer numAccts = 10;
    static private Integer numContactsPerAcct = 2;
    static date beginDate = date.newInstance(2016, 1, 1);
    static date endDate = date.newInstance(2016, 12, 30);    
    
    @testSetup static void createTestRecords() {
        
        List<String> EspList = new List <String>();  
        
        
        List<npo02__Household__c> accts = new List<npo02__Household__c>();
        for(Integer i=0;i<numAccts;i++) {
            npo02__Household__c a = new npo02__Household__c(Name='July15-' + i,
                                                            npo02__MailingPostalCode__c ='94110');
            
            accts.add(a);
        }
        insert accts;
        
        
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

        insert cons;
   
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
                                //Ethnicity_Hispanic_Latino_Other__c = 'Central American',
                                Hispanic_Latino_please_specify__c = 'Central American',
                                Family__Race__c = 'Asian - Chinese;)',
                                Race_Other__c = '',
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
            Datetime myDateTime = Datetime.newInstance(2016,1, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            cas.add(new Case(ContactId = cont.Id,
                             Call_Type__c = 'Mtg',
                             Origin = 'In-person',
                             Status = 'Closed',
                             Start_time__c = myDateTime.addDays(j),
                             End_time__c = myDateTime.addDays(j+1),
                             Family__Child__c = kid.ID,
                             RecordTypeId = '012G0000000qhDK'));
            
        }
        insert cas;
        
        
        //Create 10 Campaign events in feb with above contacts
        List<Campaign> camp = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            
            Date myDate = Date.newInstance(2016, 7, 1);
            Datetime myDateTimeOc = Datetime.newInstance(2016, 7, 1);
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
        
        insert camp;
        
        List<CampaignMember> CM = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts-5);j++) {
            Contact co = cons[j];
            Campaign campan = camp[j];
      
            CM.add(new CampaignMember(ContactID = co.Id,
                                      CampaignID = campan.Id,
                                      Status = 'Family Attendee'));
            
        }             
        insert CM; 
        

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
        
        /********************************* Round 3 - new unduplicated contacs in November  */
        
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
        

        List<Contact> chD2 = new List<Contact>();
        date pm2 = date.newInstance(2016, 9, 1 );
        for (Integer j=0;j<numAccts;j++) {
            npo02__Household__c acctA = accts2[j];            

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
        
        //Create 10 Campaign events in December with above KIScontacts
        List<Campaign> camp2 = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            Datetime myDateTime11 = Datetime.newInstance(2016, 12, 1);
            Date myDate11 = Date.newInstance(2016, 12, 1);

            camp2.add(new Campaign(Name='xellentEvent'+ j,

                                   RecordTypeId = '012G0000000qhDJ',
                                   isActive = True,
                                   Maximum_Capacity_Adults__c = 1000,
                                   Maximum_Capacity_Children__c = 1000,
                                   Type = 'PPW',
                                   Start_Date_Time__c = myDateTime11.addDays(j),
                                   StartDate = myDate11.addDays(j)));
            
        }   
        insert camp2;

        List<CampaignMember> CMKids2 = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts-5);j++) { 
            Contact campKids2 = chd2[j];
            Campaign campa2 =camp2[j];

            CMKids2.add(new CampaignMember(CampaignID = campa2.Id,
                                           ContactID = campKids2.Id,
                                     
                                           Status = 'Child Attendee' ));  
        }             
        insert CMkids2;
        
        //Create 10 Interactions in Nov 2015 with above contacts
        List<Case> cas2 = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact cont2 = cons2[j]; 
            Contact Kid2 = chd2[j];
            Datetime myDateTime2 = Datetime.newInstance(2016, 11, 1);
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
    }
    @isTest static void testMethod1() { 
        
        Test.startTest();

        PageReference AnnualRep = Page.AnnualReportAge;
        Test.setCurrentPage(AnnualRep);
        AnnualReportAge AR = new AnnualReportAge();
        date TestDate = date.newInstance(2016, 1, 1 );
        date TestDateFrom = date.newInstance(2016, 12, 31 ); 
        Date controllerDateFrom = beginDate;
        Date controllerDateTo = endDate;
        AR.datefrom = controllerDateFrom;
        AR.dateTo = controllerDateTo;
        System.AssertEquals(AR.dateFrom, controllerDateFrom);
        System.AssertEquals(AR.dateTo, controllerDateTo);
        
        AR.startGenerateBoard(); 
        
        AR.getGenerateAge2();
        AR.getGenerateAge1();
        AR.getGenerateAge0();
        AR.getGenerateAge9_17();
        AR.getGenerateAge6_8();
        AR.getGenerateAge5();
        AR.getGenerateAge4();
        AR.getGenerateAge3();
        AR.getGenerateAge18_22();
        AR.getGenerateAgeNoAge();
        
        Test.stopTest();        
        
    }
    
    @isTest static void testMethod4() {
        Test.startTest();
        PageReference AnnualRep = Page.AnnualReportAge;
        Test.setCurrentPage(AnnualRep);
        AnnualReportAge AR = new AnnualReportAge();
        
        date TestDateTo = date.newInstance(2016, 7, 31 );
        date TestDateFrom = date.newInstance(2016, 12, 1 );
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
     
        PageReference AnnualRep = Page.AnnualReportAge;
        Test.setCurrentPage(AnnualRep);
        AnnualReportAge AR = new AnnualReportAge();
        Date TestDateTo = date.newInstance(2016, 7, 31 );
        Date controllerDateTo = beginDate ;
        
        AR.dateTo = controllerDateTo;
        
        System.AssertEquals(AR.dateTo, controllerDateTo);
        AR.startGenerateBoard();
        
        Test.stopTest();       
        
    }
    
    
}