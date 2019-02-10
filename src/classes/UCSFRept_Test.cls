@isTest
public class UCSFRept_Test {
    static private Integer numAccts = 1;
    static private Integer numContactsPerAcct = 2;
    static date beginDate = date.newInstance(2015, 7, 1);
    static date endDate = date.newInstance(2016, 6, 30);    
    
    static testMethod void createTestRecords() {
        
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
           // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
                cons.add(new Contact(firstname='JulySpanishFemale-'+ j,
                                     lastname='July15-'+ j ,
                                     RecordTypeID ='012G0000000qhDM',
                                     Family__Primary_Language__c = 'Spanish',
                                     Family__Gender__c = 'Female',
                                     npo02__Household__c=acct.Id));
            
        }
        // Insert all contacts for all accounts
        insert cons;
        
        // Child Record ID
        // 012G0000000qhDN
        List<Contact> chD = new List<Contact>();
        date pm = date.newInstance(2015, 7, 1 );
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
            Datetime myDateTime = Datetime.newInstance(2016,3, 1);
           // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
                cas.add(new Case(ContactId = cont.Id,
                                 Call_Type__c = 'Mtg',
                                 Origin = 'In-person',
                                 Status = 'Closed',
                                 Start_time__c = myDateTime.addDays(j),
                                 Family__Child__c = kid.ID,
                                 RecordTypeId = '012G0000000qhDK'));
             
        }
        insert cas;
        
        
        //Create 10 Campaign events in feb with above contacts
        List<Campaign> camp = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            
            Date myDate = Date.newInstance(2016, 3, 1);
            Datetime myDateTimeOc = Datetime.newInstance(2016, 3, 1);
           // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
                camp.add(new Campaign(Name='Prog'+ j,
                                      //CampaignMemberRecordType ='012G0000000sIkG', 
                                      RecordTypeId = '012G0000000qhDJ',
                                      isActive = True,
                                      Maximum_Capacity_Adults__c = 1000,
                                      Maximum_Capacity_Children__c = 1000,
                                      Type = 'Clinic',
                                      Start_Date_Time__c = myDateTimeOc,
                                      StartDate = myDate.adddays(j)));
            
        }   
        
        insert camp;
        
        List<CampaignMember> CM = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts);j++) {
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
        
      /***************** Round 2  - same contacts, events in October
       * *****************************/
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
        for (Integer j=0;j<(numAccts);j++) {
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
        
        
      /* 
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
                                     Family__Gender__c = 'Male',
                                     npo02__Household__c=acct2.Id));
            
        }
        insert cons2;
        
        // Child Record ID
        // 012G0000000qhDN
        List<Contact> chD2 = new List<Contact>();
        date pm2 = date.newInstance(1900, 9, 1 );
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
  
        //Create 10 Campaign events in December with above KIScontacts
        List<Campaign> camp2 = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            Datetime myDateTime11 = Datetime.newInstance(2015, 12, 1);
            Date myDate11 = Date.newInstance(2015, 12, 1);
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
        
       //Create 10 Interactions in Nov 2015 with above contacts
        List<Case> cas2 = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact cont2 = cons2[j]; 
            Contact Kid2 = chd2[j];
            Datetime myDateTime2 = Datetime.newInstance(2015, 11, 1);
           // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
                cas2.add(new Case(ContactId = cont2.Id,
                                 Call_Type__c = 'Mtg',
                                 Origin = 'Phone',
                                 Status = 'New',
                                 Start_time__c = myDateTime2.addDays(j),
                                 Family__Child__c = kid2.ID,
                                 RecordTypeId = '012G0000000qhDK'));
             
        }
        insert cas2;
        
        List<Contact> chD3 = new List<Contact>();
        date pm3 = date.newInstance(2010, 9, 1 );
        for (Integer j=0;j<numAccts;j++) {
            npo02__Household__c acctA = accts2[j];            
            // For each account just inserted, add 10 kid contacts
           // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
                chD3.add(new Contact(firstname='KidFEnParCant'+ j,
                                    lastname='zi-'+ j,
                                    Birthdate = pm3.addDays(j),
                                    RecordTypeID ='012G0000000qhDN',
                                    Family__Primary_Language__c = 'English',
                                    Family__Ethnicity__c ='Unknown',
                                    Family__Race__c = 'Native American;',
                                    Family__Gender__c = 'Female',
                                    School_Type__c ='Does not apply',
                                    npo02__Household__c=acctA.Id));
            
        }       
        Insert chD3;
        
        //Create 10 Interactions in Nov 2015 with above contacts
        List<Case> cas3 = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact cont2 = cons2[j]; 
            Contact Kid3 = chd3[j];
            Datetime myDateTime3 = Datetime.newInstance(2015, 7, 10);
           // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
                cas3.add(new Case(ContactId = cont2.Id,
                                 Call_Type__c = 'PMP Initial',
                                 Origin = 'Email',
                                 Status = 'Closed',
                                 Start_time__c = myDateTime3.addDays(j),
                                 Family__Child__c = kid3.ID,
                                 RecordTypeId = '012G0000000qhDK'));
             }
        insert cas3;
        

        // create 5 adult campaign members- attendees of above August events
        // with above contacts,(should not be counted as they are duplicates)
        List<CampaignMember> CM2 = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts);j++) {
            Contact co2 = cons2[j];
            Campaign campan2 = camp2[j];
            
            //for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {      
                CM2.add(new CampaignMember(ContactID = co2.Id,
                                          CampaignID = campan2.Id,
                                          Status = 'Family Attendee'));
            
        }             
        insert CM2; 
        */
        
         Test.startTest();
     // insert data
        
        // get reference to EIS Dashboard Page
        PageReference ESPDashboard = Page.UCSFRptVF;
        Test.setCurrentPage(ESPDashboard);
        
        // get a Page controller instance
        UCSFRept ESP2 = new UCSFRept();
        date TestDateFrom = date.newInstance(2015, 7, 1 );
        date TestDateTo = date.newInstance(2016, 6, 30 ); 
        // Set Date From and Date To on Controller
        Date controllerDateFrom = TestDateFrom;
        Date controllerDateTo = TestDateTo;
        ESP2.fyb = controllerDateFrom;
        ESP2.dateTo = controllerDateTo;
        System.AssertEquals(ESP2.fyb, controllerDateFrom);
        System.AssertEquals(ESP2.dateTo, controllerDateTo);
        
        
  // generate EIS Dashboard
       
        ESP2.startGenerateEISDashboard();
        ESP2.getGenerateAge1(); 
      
        ESP2.getGenerateAge7();
       
        
 

        
        Test.stopTest();        
        
    }
        


  
}