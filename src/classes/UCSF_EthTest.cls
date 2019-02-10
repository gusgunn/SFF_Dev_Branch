@isTest
public class UCSF_EthTest {
    static private Integer numAccts = 10;
    static private Integer numContactsPerAcct = 2;
    static date beginDate = date.newInstance(2015, 7, 1);
    static date endDate = date.newInstance(2016, 6, 30);    
    
    static testMethod void createTestRecords() {
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
       List<String> EspList = new List <String>();  
        

 
        
        List<npo02__Household__c> accts = new List<npo02__Household__c>();
        for(Integer i=0;i<numAccts;i++) {
            npo02__Household__c a = new npo02__Household__c(Name='July15-' + i,
                                                           npo02__MailingPostalCode__c ='94110');
            
            accts.add(a);
        }
        database.insert(accts, dml);
        
        
        List<Contact> cons = new List<Contact>();
        for (Integer j=0;j<numAccts;j++) {
            npo02__Household__c acct = accts[j];            
           
                cons.add(new Contact(firstname='JulySpanishFemale-'+ j,
                                     lastname='July15-'+ j ,
                                     RecordTypeID ='012G0000000qhDM',
                                     Family__Primary_Language__c = 'Spanish',
                                     Family__Gender__c = 'Female',
                                     npo02__Household__c=acct.Id));
            
        }
       
           database.insert(cons, dml);
        List<Contact> chD = new List<Contact>();
        date pm = date.newInstance(2015, 7, 1 );
        for (Integer j=0;j<numAccts;j++) {
            npo02__Household__c acct = accts[j];            
            
                chD.add(new Contact(firstname='JulyKidMaleEnParSp'+ j,
                                    lastname='July15-'+ j,
                                    Birthdate = pm.addDays(j),
                                    RecordTypeID ='012G0000000qhDN',
                                    Family__Primary_Language__c = 'English',
                                    Family__Ethnicity__c ='Non-Hispanic or Non-Latino',
                                   
                                    Family__Race__c = 'Declined',
                                   
                                    Family__Gender__c = 'Male',
                                    School_Type__c ='Does not apply',
                                    npo02__Household__c=acct.Id));
            
        }       
          database.insert(chd, dml);
        
          List<Contact> chD5 = new List<Contact>();
        date pm5 = date.newInstance(2014, 7, 1 );
        for (Integer j=0;j<numAccts;j++) {
            npo02__Household__c acct = accts[j];            
           
                chD5.add(new Contact(firstname='JulyKidMaleEnParSp'+ j,
                                    lastname='July15-'+ j,
                                    Birthdate = pm5.addDays(j),
                                    RecordTypeID ='012G0000000qhDN',
                                    Family__Primary_Language__c = 'French',
                                    Family__Ethnicity__c ='Hispanic or Latino',
                                    Ethnicity_Hispanic_Latino_Other__c = 'Central American',
                                    Hispanic_Latino_please_specify__c = 'Central American',
                                    Family__Race__c = 'Asian - Chinese;)',
                                    Race_Other__c = '',
                                    Family__Gender__c = 'Male',
                                    School_Type__c ='Does not apply',
                                    npo02__Household__c=acct.Id));
            
        }       
           database.insert(chd5, dml);
        
        List<Case> cas = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact cont = cons[j]; 
            Contact Kid = chd[j];
            Datetime myDateTime = Datetime.newInstance(2015,7, 1);
           
                cas.add(new Case(ContactId = cont.Id,
                                 Call_Type__c = 'Mtg',
                                 Origin = 'In-person',
                                 Status = 'Closed',
                                 Start_time__c = myDateTime.addDays(j),
                                 Family__Child__c = kid.ID,
                                 RecordTypeId = '012G0000000qhDK'));
             
        }
           database.insert(cas, dml);
        
        
        
        List<Campaign> camp = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            
            Date myDate = Date.newInstance(2015, 8, 1);
            Datetime myDateTimeOc = Datetime.newInstance(2015, 8, 1);
         
                camp.add(new Campaign(Name='Prog'+ j,
                                    
                                      RecordTypeId = '012G0000000qhDJ',
                                      isActive = True,
                                      Maximum_Capacity_Adults__c = 1000,
                                      Maximum_Capacity_Children__c = 1000,
                                      Type = 'Clinic',
                                      Start_Date_Time__c = myDateTimeOc,
                                      StartDate = myDate.addDays(j)));
            
        }   
        
           database.insert(camp, dml);
        
        List<CampaignMember> CM = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts);j++) {
            Contact co = cons[j];
            Campaign campan = camp[j];
             
                CM.add(new CampaignMember(ContactID = co.Id,
                                          CampaignID = campan.Id,
                                          Status = 'Family Attendee'));
            
        }             
           database.insert(cm, dml);
        
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
           database.insert(cmKids, dml);
        
      /***************** Round 2  - same contacts, events in October
       * *****************************/
         //Create 10 Interactions in Sept 2015 with above contacts
        List<Case> casO = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact contO = cons[j]; 
            Contact KidO = chd[j];
            Datetime myDateTimeO = Datetime.newInstance(2015, 9, 1);
          
                casO.add(new Case(ContactId = contO.Id,
                                 Call_Type__c = 'Mtg',
                                 Origin = 'In-person',
                                 Status = 'Closed',
                                 Start_time__c = myDateTimeO.addDays(j),
                                 Family__Child__c = kidO.ID,
                                 RecordTypeId = '012G0000000qhDK'));
             
        }
         database.insert(cas, dml);
        
        
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
        
           database.insert(campO, dml);
        
   // Attendees shouldnt count
        List<CampaignMember> CMO = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts);j++) {
            Contact coO = cons[j];
            Campaign campanO = campO[j];
                
                CMO.add(new CampaignMember(ContactID = coO.Id,
                                          CampaignID = campanO.Id,
                                           
                                          Status = 'Family Attendee'));
            
        }             
          database.insert(CMO, dml); 
        
        List<CampaignMember> CMKidsO = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts);j++) { 
            Contact campKidsO = chd[j];
            Campaign campaO =campO[j];
               
                CMKidsO.add(new CampaignMember(CampaignID = campaO.Id,
                                              ContactID = campKidsO.Id,
                                              //Account_ID__c = acct.Id,
                                              Status = 'Child Attendee' ));
            
        }             
        database.insert(CMKIDSo, dml);
        
        
        /********************************* Round 3 - new unduplicated contacs in November
         * ************************************************************************/
         List<npo02__Household__c> accts2 = new List<npo02__Household__c>();
        for(Integer i=0;i<numAccts;i++) {
            npo02__Household__c a = new npo02__Household__c(Name='Apr-' + i,
                                                           npo02__MailingPostalCode__c ='94123');
            
            accts2.add(a);
        }
           database.insert(accts2, dml);
        
        
     
        List<Contact> cons2 = new List<Contact>();
        for (Integer j=0;j<numAccts;j++) {
            npo02__Household__c acct2 = accts2[j];            

                cons2.add(new Contact(firstname='AprilMndarinMale-'+ j,
                                     lastname='Apr-'+ j ,
                                     RecordTypeID ='012G0000000qhDM',
                                     Family__Primary_Language__c = 'Mandarin',
                                     Family__Gender__c = 'Male',
                                       Family__Ethnicity__c ='Unknown',
                                    Family__Race__c = 'African American',
                                     npo02__Household__c=acct2.Id));
            
        }
           database.insert(cons2, dml);
        
      
 
        List<Contact> chD2 = new List<Contact>();
        date pm2 = date.newInstance(2013, 9, 1 );
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
         database.insert(chd2, dml);  
       
        List<Campaign> camp2 = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            Datetime myDateTime11 = Datetime.newInstance(2016, 1, 1);
            Date myDate11 = Date.newInstance(2016, 1, 1);

                camp2.add(new Campaign(Name='xellentEvent'+ j,
                                   
                                      RecordTypeId = '012G0000000qhDJ',
                                      isActive = True,
                                      Maximum_Capacity_Adults__c = 1000,
                                      Maximum_Capacity_Children__c = 1000,
                                      Type = 'PPW',
                                      Start_Date_Time__c = myDateTime11.addDays(j),
                                      StartDate = myDate11.addDays(j)));
            
        }   
           database.insert(camp2, dml);
    
        List<CampaignMember> CMKids2 = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts);j++) { 
            Contact campKids2 = chd2[j];
            Campaign campa2 =camp2[j];   
                CMKids2.add(new CampaignMember(CampaignID = campa2.Id,
                                              ContactID = campKids2.Id,
                                              
                                              Status = 'Child Attendee' ));  
        }             
           database.insert(cmKids2, dml);
        
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
                                 Family__Child__c = kid2.ID,
                                 RecordTypeId = '012G0000000qhDK'));
             
        }
           database.insert(cas2, dml);
    
        List<CampaignMember> CM2 = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts);j++) {
            Contact co2 = cons2[j];
            Campaign campan2 = camp2[j];
     
                CM2.add(new CampaignMember(ContactID = co2.Id,
                                          CampaignID = campan2.Id,
                                          Status = 'Family Attendee'));
            
        }             
          database.insert(cm2, dml);
        
        
         Test.startTest();

        PageReference ESPDashboard = Page.UCSF_Eth;
        Test.setCurrentPage(ESPDashboard);
        

        UCSF_Stats ESP1 = new UCSF_Stats();
        date TestDate = date.newInstance(2015, 6, 30 );
        date TestDateFrom = date.newInstance(2016, 7, 1 ); 

        Date controllerDateFrom = beginDate;
        Date controllerDateTo = endDate;
        ESP1.datefrom = controllerDateFrom;
        ESP1.dateTo = controllerDateTo;
        System.AssertEquals(ESP1.dateFrom, controllerDateFrom);
        System.AssertEquals(ESP1.dateTo, controllerDateTo);

        ESP1.startGenerateEISDashboard();
        ESP1.getGenerateParentLanguage();
        
        ESP1.getGenerateEthnicity();
        ESP1.getGenerateEthnicityP();
      
        
        Test.stopTest();        
        
    }
          
 
}