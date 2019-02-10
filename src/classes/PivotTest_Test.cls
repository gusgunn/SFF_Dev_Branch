@isTest
public class PivotTest_Test {
    static private Integer numAccts = 2;
    static private Integer numContactsPerAcct = 2;
    static date beginDate = date.newInstance(2015, 07, 01);
    static date endDate = date.newInstance(2016, 06, 30);    
    
    static testMethod void createTestRecords() {
        
        List<Contact> ContactsIn = new List <Contact>();  
        
        
        List<npo02__Household__c> accts = new List<npo02__Household__c>();
        for(Integer i=0;i<numAccts;i++) {
            npo02__Household__c a = new npo02__Household__c(Name='July15-' + i,
                                                            npo02__MailingPostalCode__c ='94110');
            
            accts.add(a);
        }
        System.debug('accts= ' + accts.size());
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
                                 dev__c = TRUE,
                                 //Mentor__c = true,
                                 npo02__Household__c=acct.Id));
            
        }
        // Insert all contacts for all accounts
        System.debug('Adult contacts= ' + cons.size());
        
        insert cons;
        
        // Child Record ID
        // 012G0000000qhDN
        List<Contact> chD = new List<Contact>();
        date pm = date.newInstance(2012, 3, 1 );
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
            Contact cont2 = cons[j]; 
            Contact Kid = chd[j];
            Datetime myDateTime1 = Datetime.newInstance(2015, 8, 25);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            cas.add(new Case(ContactId = cont2.Id,
                             Call_Type__c = 'Mtg',
                             Origin = 'In-person',
                             Status = 'Closed',
                             Start_time__c = myDateTime1.addDays(j),
                             Family__Child__c = kid.ID,
                             RecordTypeId = '012G0000000qhDK'));
            
        }
        System.debug('cases= ' + cas.size());
        insert cas;
        
        //Create 10 Interactions in Jan 2016 with above contacts
        List<Case> cas1 = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact cont3 = cons[j]; 
            Contact Kid = chd[j];
            Datetime myDateTime = Datetime.newInstance(2016, 10, 2);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            cas.add(new Case(ContactId = cont3.Id,
                             Call_Type__c = 'Mtg',
                             Origin = 'Email',
                             Status = 'Closed',
                             Start_time__c = myDateTime.addDays(j),
                             Family__Child__c = kid.ID,
                             RecordTypeId = '012G0000000qhDK'));
            
        }
        System.debug('cases= ' + cas1.size());
        insert cas1;
        
        
        //Create 10 Interactions in Jan 2016 with above contacts
        List<Case> cas3 = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact cont4 = cons[j]; 
            Contact Kid = chd[j];
            Datetime myDateTime = Datetime.newInstance(2016, 01, 25);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            cas.add(new Case(ContactId = cont4.Id,
                             Call_Type__c = 'Mtg',
                             Origin = 'In-person',
                             Status = 'Closed',
                             Start_time__c = myDateTime.addDays(j),
                             Family__Child__c = kid.ID,
                             RecordTypeId = '012G0000000qhDK'));
            
        }
        System.debug('cases= ' + cas3.size());
        insert cas3;
        
          //Create 10 Interactions in Jan 2016 with above contacts
        List<Case> cas2 = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact cont5 = cons[j]; 
            Contact Kid = chd[j];
            Datetime myDateTime = Datetime.newInstance(2016, 4, 25);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            cas.add(new Case(ContactId = cont5.Id,
                             Call_Type__c = 'Mtg',
                             Origin = 'Email',
                             Status = 'Closed',
                             Start_time__c = myDateTime.addDays(j),
                             Family__Child__c = kid.ID,
                             RecordTypeId = '012G0000000qhDK'));
            
        }
        System.debug('cases= ' + cas2.size());
        insert cas2;
        
        //Create 10 Campaign events in feb with above contacts
        List<Campaign> camp = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            
            Date myDate = Date.newInstance(2015, 9, 25);
            Datetime myDateTimeOc = Datetime.newInstance(2015, 9, 25);
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
        System.debug('campaigns= ' + camp.size());
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
        System.debug('cms= ' + CM.size());
        insert CM; 
        
        
          //Create 10 Campaign events in feb with above contacts
        List<Campaign> camp8 = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            
            Date myDate = Date.newInstance(2015, 10, 25);
            Datetime myDateTimeOc = Datetime.newInstance(2015, 10, 25);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            camp8.add(new Campaign(Name='Prog'+ j,
                                  //CampaignMemberRecordType ='012G0000000sIkG', 
                                  RecordTypeId = '012G0000000qhDJ',
                                  isActive = True,
                                  Maximum_Capacity_Adults__c = 1000,
                                  Maximum_Capacity_Children__c = 1000,
                                  Type = 'Clinic',
                                  Start_Date_Time__c = myDateTimeOc,
                                  StartDate = myDate.adddays(j)));
            
        }   
        System.debug('campaigns= ' + camp8.size());
        insert camp8;
        
        List<CampaignMember> CM8 = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts);j++) {
            Contact co8 = cons[j];
            Campaign campan8 = camp8[j];
            
            //for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {      
            CM8.add(new CampaignMember(ContactID = co8.Id,
                                      CampaignID = campan8.Id,
                                      Status = 'Family Attendee'));
            
        }  
        System.debug('cms= ' + CM8.size());
        insert CM8; 
        
        
        
           //Create 10 Campaign events in feb with above contacts
        List<Campaign> camp7 = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            
            Date myDate = Date.newInstance(2016, 5, 5);
            Datetime myDateTimeOc = Datetime.newInstance(2016, 5, 05);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            camp7.add(new Campaign(Name='Prog'+ j,
                                  //CampaignMemberRecordType ='012G0000000sIkG', 
                                  RecordTypeId = '012G0000000qhDJ',
                                  isActive = True,
                                  Maximum_Capacity_Adults__c = 1000,
                                  Maximum_Capacity_Children__c = 1000,
                                  Type = 'Clinic',
                                  Start_Date_Time__c = myDateTimeOc,
                                  StartDate = myDate.adddays(j)));
            
        }   
        System.debug('campaigns= ' + camp7.size());
        insert camp7;
        
        List<CampaignMember> CM1 = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts);j++) {
            Contact co1 = cons[j];
            Campaign campan1 = camp7[j];
            
            //for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {      
            CM1.add(new CampaignMember(ContactID = co1.Id,
                                      CampaignID = campan1.Id,
                                      Status = 'Family Attendee'));
            
        }  
        System.debug('cms= ' + CM1.size());
        insert CM1; 
        
        
          List<Campaign> camp2 = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            
            Date myDate = Date.newInstance(2016, 03, 25);
            Datetime myDateTimeOc = Datetime.newInstance(2016, 03, 25);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            camp2.add(new Campaign(Name='Prog'+ j,
                                  //CampaignMemberRecordType ='012G0000000sIkG', 
                                  RecordTypeId = '012G0000000qhDJ',
                                  isActive = True,
                                  Maximum_Capacity_Adults__c = 1000,
                                  Maximum_Capacity_Children__c = 1000,
                                  Type = 'Clinic',
                                  Start_Date_Time__c = myDateTimeOc,
                                  StartDate = myDate.adddays(j)));
            
        }   
        System.debug('campaigns= ' + camp2.size());
        insert camp2;
        
        List<CampaignMember> CMKids = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts);j++) { 
            Contact campKids = cons[j];
            Campaign campa =camp2[j];
            //for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {      
            CMKids.add(new CampaignMember(CampaignID = campa.Id,
                                          ContactID = campKids.Id,
                                          //Account_ID__c = acct.Id,
                                          Status = 'Family Attendee' ));
            
        }             
        insert CMkids;

        Test.startTest();
        PivotMakeTableTestCoverage.addToTable();
        
        // Test.stopTest();      
        
        // Test.startTest();
        PivotRowsQ1_16.addPivotRows();
        PivotRowsQ2_16.addPivotRows();
        PivotRowsQ3_16.addPivotRows();
        PivotMakeRows.addPivotRows();
        
        Test.stopTest(); 
        
        
        list<POC__c> totalTableEntries =[SELECT Person__c 
                                         FROM POC__c
                                         WHERE Person__c IN: cons];
        
        System.debug('totalTableEntries size = ' + totalTableEntries.size());
        //System.assertEquals(20, totalTableEntries.size());
        
        list<PivotTable__c> totalRowEntries =[SELECT Person__c 
                                         FROM PivotTable__c
                                         WHERE Person__c IN: cons];
        
        System.debug('totalRowEntries size = ' + totalRowEntries.size());
        //System.assertEquals(10, totalRowEntries.size());
        
    }
    
}