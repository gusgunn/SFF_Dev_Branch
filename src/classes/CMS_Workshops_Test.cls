@isTest

public class CMS_Workshops_Test {
    static private Integer numAccts = 3;
    static private Integer numContactsPerAcct = 3;
    static date beginDate = date.newInstance(2016, 7, 1);
    static date endDate = date.newInstance(2016, 12, 31);  
    Static  DateTime myDateC = DateTime.newInstance(2014, 9, 30, 8,3, 5);
    
    @testSetup static void createTestRecords() {
        RecordType rt1 = [Select Id, Name from RecordType where Name = 'Program Campaign' limit 1];
        RecordType rt2 = [Select Id, Name from RecordType where Name = 'Default' limit 1];
        Map <Integer, String> esMap =  new Map <Integer, String>{0 =>  'ES4' , 1 =>'ES6', 2 => 'ES4C', 
            3 =>'ES4', 4 => 'ES6', 5 => 'ES4C', 
            6 =>'ES4', 7 =>'ES6', 8 => 'ES4C', 
            9 => 'ES4', 10 =>'ES6',11 =>'ES4C'}; 
                
                
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
                                 //Income__c = 'Homeless',
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
       
        
        //Create 10 Campaign events in feb with above contacts
        List<Campaign> camp = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            
            //Date myDate = Date.newInstance(2016, 9, 30);
            Datetime myDateTimeOc = Datetime.newInstance(2016, 9, 29, 1,5,5);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            camp.add(new Campaign(Name='Prog'+ j,
                                  
                                  RecordTypeId = rt1.ID,
                                  CampaignMemberRecordType = rt2,
                                  isActive = True,
                                  Maximum_Capacity_Adults__c = 100,
                                  Maximum_Capacity_Children__c = 100,
                                  //Type = 'Workshop',
                                  Campaign_Target__c =1,
                                  Unduplicated_Target__c = 10,
                                  Duplicated_Target__c = 20,
                                  CMSName__c = 'ES4',
                                  Status = 'Completed',
                                  Project_or_Funder__c = 'Family Support',
                                  CMSQ__c = '2',
                                  Start_Date_Time__c = myDateTimeOc.addDays(j+1),
                                  End_Date_Time__c = myDateTimeOc.addDays(j+2)
                                  //StartDate = myDate 
                                 ));
            
        }   
        insert camp;
        
       /* Campaign checkES =[SELECT CMSName__c,Start_Date_Time__c, CMSQ__c
                           FROM Campaign
                           WHERE ID=:camp.get(1).ID];
        
        System.assertEquals('ES1', checkES.CMSName__c);
        System.assertEquals( 10 , checkES.Start_Date_Time__c.Month());
        System.assertEquals('2', checkES.CMSQ__c);
        */
        List<CampaignMember> CM = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts);j++) {
            Contact co = cons[j];
            Campaign campan = camp[j];
            
            //for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {      
            CM.add(new CampaignMember(ContactID = co.Id,
                                      CampaignID = campan.Id,
                                      
                                      Status = 'Family Attendee'
                                     ));
            
        }             
        insert CM; 
        System.AssertEquals(3, CM.size());
        
      /* CampaignMember checkCM =[SELECT Status
                                 FROM CampaignMember
                                 WHERE ID=:CM.get(1).ID];
        
        System.assertEquals('Family Attendee', checkCM.Status);
        // System.assertEquals( 10 , checkES.Start_Date_Time__c.Month());
        // System.assertEquals('2', checkES.CMSQ__c);*/
        
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
                                          Status = 'Child Attendee' ));
            
        }             
        insert CMkids;
        
        
        // Round 2  - same contacts, events in October
        
        
        
        //Create  Campaign events in October with above contacts - shouldnt count
        List<Campaign> campO = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            Datetime myDateTimeOc = Datetime.newInstance(2016, 10, 1, 12,5,5);
            Date myDateO = Date.newInstance(2016, 10, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            campO.add(new Campaign(Name='Datt'+ j,
                                  Campaign_Target__c =1,
                                  RecordTypeId = rt1.ID,
                                   isActive = True,
                                   Maximum_Capacity_Adults__c = 1000,
                                   Maximum_Capacity_Children__c = 1000,
                                   
                                  Unduplicated_Target__c = 20,
                                  Duplicated_Target__c = 10,
                                   Type = 'Workshop',
                                   CMSName__c = esMap.get(j+2),
                                   Status = 'Completed',
                                   Project_or_Funder__c = 'Family Support',
                                   Start_Date_Time__c = myDateTimeOc,
                                   End_Date_Time__c = myDateTimeOc.addDays(j),
                                   StartDate = myDateO.addDays(j)));
            
        }   
        System.debug(' ES2 campO size = ' + campO.size() );
        insert campO;
        
        // Attendees shouldnt count
        List<CampaignMember> CMO = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts);j++) {
            Contact coO = cons[j];
            Campaign campanO = campO[j];
            
            //for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {      
            CMO.add(new CampaignMember(ContactID = coO.Id,
                                       CampaignID = campanO.Id,
                                       
                                       Status = 'Family Attendee'));
            
        }             
        insert CMO;  
        System.debug(' cam Members inserted line 199= ' + CMO );
        
        List<CampaignMember> CMKidsO = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts);j++) { 
            Contact campKidsO = chd[j];
            Campaign campaO =campO[j];
            //for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {      
            CMKidsO.add(new CampaignMember(CampaignID = campaO.Id,
                                           ContactID = campKidsO.Id,
                                           //Account_ID__c = acct.Id,
                                           Status = 'Child Attendee' ));
            
        }             
        insert CMkidsO;
        
        
        
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
        
        //Create 10 Campaign events in December with above KIScontacts
        List<Campaign> camp2 = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            Datetime myDateTime11 = Datetime.newInstance(2016, 10, 1, 12,5,5);
            Date myDate11 = Date.newInstance(2016, 12, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            camp2.add(new Campaign(Name='xell'+ j,
                                   Campaign_Target__c =1,
                                  RecordTypeId = rt1.ID,
                                   isActive = True,
                                   Maximum_Capacity_Adults__c = 1000,
                                   Maximum_Capacity_Children__c = 1000,
                                   //Type = 'PPW',
                                   
                                   Unduplicated_Target__c = 20,
                                   Duplicated_Target__c = 10,
                                   CMSName__c =esMap.get(j+3),
                                   Status = 'Completed',
                                   Project_or_Funder__c = 'Family Support',
                                   Start_Date_Time__c = myDateTime11,
                                   End_Date_Time__c = myDateTime11.addDays(j),
                                   StartDate = myDate11.addDays(j)));
            
        }   
        insert camp2;
        
        // create 5 child campaign members- attendees of above events - should count but no parent on on record linked as attending
        // with above contacts,(should not be counted as they are duplicates)
        List<CampaignMember> CMKids2 = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts);j++) { 
            Contact campKids2 = chd2[j];
            Campaign campa2 =camp2[j];
            //for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {      
            CMKids2.add(new CampaignMember(CampaignID = campa2.Id,
                                           ContactID = campKids2.Id,
                                           //Account_ID__c = acct.Id,
                                           Status = 'Child Attendee' ));  
        }             
        insert CMkids2;
        
        
       
        //Create 10 Campaign events in December with above KIScontacts
        List<Campaign> camp3 = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            Datetime myDateTime11 = Datetime.newInstance(2016, 10, 1);
            Date myDate11 = Date.newInstance(2016, 10, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            camp3.add(new Campaign(Name='xellet'+ j,
                                   Campaign_Target__c =1,
                                  RecordTypeId = rt1.ID,
                                   isActive = True,
                                   Maximum_Capacity_Adults__c = 1000,
                                   Maximum_Capacity_Children__c = 1000,
                                  
                                   Unduplicated_Target__c = 20,
                                    Duplicated_Target__c = 10,
                                   //Type = 'Workshop',
                                   CMSName__c =esMap.get(j+6),
                                   Status = 'Completed',
                                   Project_or_Funder__c = 'Family Support',
                                   Start_Date_Time__c = myDateTime11.addDays(j),
                                   StartDate = myDate11.addDays(j)));
            
        }   
        insert camp3;
        List<CampaignMember> CM3 = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts-5);j++) {
            Contact co2 = cons2[j];
            Campaign campan2 = camp3[j];
            
            //for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {      
            CM3.add(new CampaignMember(ContactID = co2.Id,
                                       CampaignID = campan2.Id,
                                       Status = 'Family Attendee'));
            
        }             
        insert CM3; 
        
        
        
        //Create 10 Campaign no es
        List<Campaign> camp5 = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            Datetime myDateTime11 = Datetime.newInstance(2016, 10, 1);
            Date myDate11 = Date.newInstance(2016, 10, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            camp5.add(new Campaign(Name='xEvent'+ j,
                                   Campaign_Target__c =1,
                                  RecordTypeId = rt1.ID,
                                   isActive = True,
                                   Maximum_Capacity_Adults__c = 1000,
                                   Maximum_Capacity_Children__c = 1000,
                                   Type = 'PPW',
                                   CMSName__c =esMap.get(j+7),
                                   CMSQ__c ='2',
                                   Status = 'Planned',
                                   Project_or_Funder__c = 'Family Support',
                                   Start_Date_Time__c = myDateTime11.addDays(j),
                                   StartDate = myDate11.addDays(j)));
            
        }   
        insert camp5;
        List<CampaignMember> CM5 = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts-5);j++) {
            Contact co2 = cons2[j];
            Campaign campan2 = camp5[j];
            
            //for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {      
            CM5.add(new CampaignMember(ContactID = co2.Id,
                                       CampaignID = campan2.Id,
                                       Status = 'Family Attendee'));
            
        }             
        insert CM5; 
        
        
        List<Campaign> camp6 = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            Datetime myDateTime11 = Datetime.newInstance(2016, 10, 1);
            Date myDate11 = Date.newInstance(2016, 10, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            camp6.add(new Campaign(Name='xellEvent'+ j,
                                   
                                   isActive = True,
                                   Unduplicated_Target__c = 20,
                                   Duplicated_Target__c = 10,
                                    Campaign_Target__c =1,
                                  RecordTypeId = rt1.ID,
                                   Maximum_Capacity_Adults__c = 1000,
                                   Maximum_Capacity_Children__c = 1000,
                                   //Type = 'Workshop',
                                   CMSName__c =esMap.get(j),
                                   CMSQ__c ='2',
                                   Status = 'Planned',
                                   Project_or_Funder__c = 'Family Support',
                                   Start_Date_Time__c = myDateTime11,
                                   End_Date_Time__c = myDateTime11.addDays(j)
                                  ));
            
        }   
        insert camp6;
        
        List<CampaignMember> CM6 = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts-5);j++) {
            Contact co2 = cons[j];
            Campaign campan2 = camp6[j];
            
            //for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {      
            CM6.add(new CampaignMember(ContactID = co2.Id,
                                       CampaignID = campan2.Id,
                                       Status = 'Family Attendee'));
            
        }             
        insert CM6; 
        
        //Create 10 Campaign events in December with above KIScontacts
        List<Campaign> camp7 = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            Datetime myDateTime11 = Datetime.newInstance(2016, 11, 1);
            Date myDate11 = Date.newInstance(2016, 11, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            camp7.add(new Campaign(Name='xellent'+ j,
                                   Campaign_Target__c =1,
                                  RecordTypeId = rt1.ID,
                                   isActive = True,
                                   Maximum_Capacity_Adults__c = 1000,
                                   Maximum_Capacity_Children__c = 1000,
                                  
                                   Unduplicated_Target__c = 20,
                                   Duplicated_Target__c = 10,
                                   //Type = 'Workshop',
                                   CMSName__c =esMap.get(4),
                                   CMSQ__c ='2',
                                   //Status = '',
                                   Project_or_Funder__c = 'Family Support',
                                   Start_Date_Time__c = myDateTime11,
                                   End_Date_Time__c = myDateTime11.addDays(j),
                                   StartDate = myDate11.addDays(j)));
            
        }   
        insert camp7;
        List<CampaignMember> CM7 = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts-5);j++) {
            Contact co2 = cons[j];
            Campaign campan2 = camp7[j];
            
            //for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {      
            CM7.add(new CampaignMember(ContactID = co2.Id,
                                       CampaignID = campan2.Id,
                                       Status = 'Family Attendee'));
            
        }             
        insert CM7; 
        
        //Create 10 Campaign events in December with above KIScontacts
        List<Campaign> camp8= new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            Datetime myDateTime11 = Datetime.newInstance(2016, 11, 1);
            Date myDate11 = Date.newInstance(2016, 11, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            camp8.add(new Campaign(Name='Event'+ j,
                                    Campaign_Target__c =1,
                                  RecordTypeId = rt1.ID,
                                   isActive = True,
                                   Maximum_Capacity_Adults__c = 100,
                                   Maximum_Capacity_Children__c = 100,
                                   Unduplicated_Target__c = 20,
                                    Duplicated_Target__c = 10,
                                   //Type = 'Family Event',
                                   CMSName__c = 'ES6',
                                   CMSQ__c ='2',
                                   //Status = 'Completed',
                                   Project_or_Funder__c = 'Family Support',
                                   Start_Date_Time__c = myDateTime11,
                                   End_Date_Time__c = myDateTime11.addDays(j),
                                   StartDate = myDate11.addDays(j)));
            
        }   
        insert camp8;
        
      List<CampaignMember> CM8 = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts-5);j++) {
            Contact co2 = cons[j];
            Campaign campan2 = camp8[j];
            
            //for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {      
            CM8.add(new CampaignMember(ContactID = co2.Id,
                                       CampaignID = campan2.Id,
                                       Status = 'Family Attendee'));
            
        }             
        insert CM8; 
        
        
        //Create 10 Campaign events in December with above KIScontacts
        List<Campaign> campU= new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            Datetime myDateTime11 = Datetime.newInstance(2016, 11, 1);
            Date myDate11 = Date.newInstance(2016, 11, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            campU.add(new Campaign(Name='Unass'+ j,
                                   //CampaignMemberRecordType ='012G0000000sIkG', 
                                   RecordTypeId = '012G0000000s2un',
                                   isActive = True,
                                   Maximum_Capacity_Adults__c = 100,
                                   Maximum_Capacity_Children__c = 100,
                                   Target__c = 100,
                                   Unduplicated_Target__c = 20,
                                    Duplicated_Target__c = 10,
                                   //Type = 'Support Group',
                                   CMSName__c = 'ES4C',
                                   CMSQ__c ='2',
                                   Status = 'Completed',
                                   Project_or_Funder__c = 'Family Support',
                                   Start_Date_Time__c = myDateTime11,
                                   End_Date_Time__c = myDateTime11.addDays(j),
                                   StartDate = myDate11.addDays(j)));
            
        }   
        insert campU;
        

    } 
    @isTest static void testMethod1() {
        
        
        Test.startTest();
      
        PageReference AnnualRep = Page.CMS_WorkshopsVF;
        Test.setCurrentPage(AnnualRep);
        
        // get a Page controller instance
        CMS_Workshops AR = new CMS_Workshops();
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
        
        AR.getGenerateES4();
        AR.getGenerateES6();
        AR.getGenerateES7();
        
        AR.getGenerateES4List();
        AR.getGenerateES4NoList();
        AR.getGenerateES4Pie();
        
        AR.getGenerateES6List();
        AR.getGenerateES6NoList();
        AR.getGenerateES6Pie();
       
        
        AR.getGenerateES7List();
        AR.getGenerateES7NoList();
        AR.getGenerateES7Pie();
        
        AR.getGenerateES4Kids6();
        AR.getGenerateESq22();
        AR.getGenerateESqw2();
        AR.getGenerateESq212();
        AR.getGenerateESqw();
        AR.getGenerateESq();
        AR.getGenerateESq2();
       
        Test.stopTest();       
        
    }
    
    @isTest static void testMethod2() {
        
        
        Test.startTest();
        // insert data
        
        // get reference to EIS Dashboard Page
        PageReference AnnualRep = Page.CMS_WorkshopsVF;
        Test.setCurrentPage(AnnualRep);
        
        // Use bad date range to get a Page controller instance
        CMS_Workshops AR = new CMS_Workshops();
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
        
        Test.stopTest();       
        
    }
    
    @isTest static void testMethod3() {
        
        Test.startTest();
        // get reference to EIS Dashboard Page
        PageReference AnnualRep = Page.CMS_WorkshopsVF;
        Test.setCurrentPage(AnnualRep);
        
        // Use bad date range to get a Page controller instance
        CMS_Workshops AR = new CMS_Workshops();
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
        PageReference AnnualRep = Page.CMS_WorkshopsVF;
        Test.setCurrentPage(AnnualRep);
        
        // Use bad date range to get a Page controller instance
        CMS_Workshops AR = new CMS_Workshops();
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
        PageReference AnnualRep = Page.CMS_WorkshopsVF;
        Test.setCurrentPage(AnnualRep);
        
        // get a Page controller instance set to Q3
        CMS_Workshops AR = new CMS_Workshops();
        date TestDateTo = date.newInstance(2017, 3, 31 );
        date TestDateFrom = date.newInstance(2016, 7, 1 ); 
        // Set Date From and Date To on Controller
        Date controllerDateFrom = TestDateFrom;
        Date controllerDateTo = TestDateTo;
        AR.datefrom = controllerDateFrom;
        AR.dateTo = controllerDateTo;
        System.AssertEquals(AR.dateFrom, controllerDateFrom);
        System.AssertEquals(AR.dateTo, controllerDateTo);
        
        AR.startGenerateBoard(); 
             AR.getGenerateES4();
        AR.getGenerateES6();
        AR.getGenerateES7();
        
        AR.getGenerateES4List();
        AR.getGenerateES4NoList();
        AR.getGenerateES4Pie();
        
        AR.getGenerateES6List();
        AR.getGenerateES6NoList();
        AR.getGenerateES6Pie();
       
        
        AR.getGenerateES7List();
        AR.getGenerateES7NoList();
        AR.getGenerateES7Pie();
        
        AR.getGenerateES4Kids6();
        AR.getGenerateESq22();
        AR.getGenerateESqw2();
        AR.getGenerateESq212();
        AR.getGenerateESqw();
        AR.getGenerateESq();
        AR.getGenerateESq2();
        
        Test.stopTest();  
    }
    
    @isTest static void testMethod6() {
        Test.startTest();
        
        // get reference to EIS Dashboard Page
        PageReference AnnualRep = Page.CMS_WorkshopsVF;
        Test.setCurrentPage(AnnualRep);
        
        // get a Page controller instance set to Q4
        CMS_Workshops AR = new CMS_Workshops();
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
             AR.getGenerateES4();
        AR.getGenerateES6();
        AR.getGenerateES7();
        
        AR.getGenerateES4List();
        AR.getGenerateES4NoList();
        AR.getGenerateES4Pie();
        
        AR.getGenerateES6List();
        AR.getGenerateES6NoList();
        AR.getGenerateES6Pie();
       
        
        AR.getGenerateES7List();
        AR.getGenerateES7NoList();
        AR.getGenerateES7Pie();
        
        AR.getGenerateES4Kids6();

        AR.getGenerateESq22();
        AR.getGenerateESqw2();
        AR.getGenerateESq212();
        AR.getGenerateESqw();
        AR.getGenerateESq();
        AR.getGenerateESq2();
        Test.stopTest();  
        
    }
    //System.AssertEquals(x.size(), 30);
    
}