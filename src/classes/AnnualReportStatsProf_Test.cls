@isTest
public class AnnualReportStatsProf_Test {
    static private Integer numAccts = 10;
    static private Integer numContactsPerAcct = 2;
    static date beginDate = date.newInstance(2016, 1, 1);
    static date endDate = date.newInstance(2016, 12, 30);    
    
    static testMethod void createTestRecords() {
        
       List<String> EspList = new List <String>();  
        

  /* ******************************************************************
        * Create July - 10 households each with an adult contact and a kid contacts 
		* Give each household a July interaction 
		* Kids Zip from household -System.AssertEquals.npo02__MailingPostalCode__c(94110 x10)count an all Male 
		* (Test- these adults are all Female)
		* Parent language all Spanish - System.AssertEquals.Family__Primary_Language__c(Spanish x 10)count
		* (Test, all their kids speak English)
		* Add first 5 adults and kids to events in august 
	    * They shouldnt count as August contacts as they are duplicates
	    * 
		******************************************************************/
        
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
            Datetime myDateTime = Datetime.newInstance(2016,7, 1);
           // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
                cas.add(new Case(ContactId = cont.Id,
                                 Call_Type__c = 'Mtg',
                                 Origin = 'In-person',
                                 Status = 'Closed',
                                 Start_time__c = myDateTime.addDays(j),
                                 Family__Child__c = kid.ID,
                                 RecordTypeId = '012G0000000qhDL'));
             
        }
        insert cas;
        
        
        //Create 10 Campaign events in feb with above contacts
        List<Campaign> camp = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            
            Date myDate = Date.newInstance(2016, 7, 1);
            Datetime myDateTimeOc = Datetime.newInstance(2016, 7, 1);
           // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
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
            
            //for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {      
                CM.add(new CampaignMember(ContactID = co.Id,
                                          CampaignID = campan.Id,
                                          Status = 'Professional Attendee'));
            
        }             
        insert CM; 
     
            

        
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
                                 
                                 RecordTypeId = '012G0000000qhDL'));
             
        }
        insert casO;
        
        
        //Create  Campaign events in October with above contacts - shouldnt count
        List<Campaign> campO = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            Datetime myDateTimeOc = Datetime.newInstance(2016, 10, 1);
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
        for (Integer j=0;j<(numAccts-5);j++) {
            Contact coO = cons[j];
            Campaign campanO = campO[j];
            
            //for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {      
                CMO.add(new CampaignMember(ContactID = coO.Id,
                                          CampaignID = campanO.Id,
                                           
                                          Status = 'Professional Attendee'));
            
        }             
        insert CMO;  
   
        
        
        /********************************* Round 3 - new unduplicated contacs in November
         * ************************************************************************/
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
  
        
        
       //Create 10 Interactions in Nov 2015 with above contacts
        List<Case> cas2 = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact cont2 = cons2[j]; 
          
            Datetime myDateTime2 = Datetime.newInstance(2016, 11, 1);
           // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
                cas2.add(new Case(ContactId = cont2.Id,
                                 Call_Type__c = 'Mtg',
                                 Origin = 'Phone',
                                 Status = 'New',
                                 Start_time__c = myDateTime2.addDays(j),
                                 Family__Child__c = NULL,
                                 RecordTypeId = '012G0000000qhDL'));
             
        }
        insert cas2;
       
        
         Test.startTest();
     // insert data
        
        // get reference to EIS Dashboard Page
        PageReference AnnualRep = Page.AnnualReportStatsProf;
        Test.setCurrentPage(AnnualRep);
        
        // get a Page controller instance
        AnnualReportStatsProf AR = new AnnualReportStatsProf();
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
         AR.getGenerateOrgProfessionals();
        AR.getGenerateAllProfessionals();
        AR.getGenerateProIntTotals();
        AR.getGenerateProEvents();
        AR.getGenerateProEduCampTotals();
       // AR.getGenerateTotalKids();
       // AR.getGenerateGen();
        
      //  AR.getGenerateHousing();
       // AR.getGenerateIncome();
       // AR.getGenerateZip();
       
       // AR.getGenerateLep();
       // AR.getGenerateLowIncome();
       // AR.getGenerateUnderServed();
       // AR.getGenerateIncarcerated();
    
        
        Test.stopTest();        
        
    }
          

//System.AssertEquals(x.size(), 30);
  
}