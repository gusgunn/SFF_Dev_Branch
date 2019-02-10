@isTest
public class CMSToDO_Test  {
    static private Integer numAccts = 2;
    static private Integer numContactsPerAcct = 2;
    static date beginDate = date.newInstance(2016, 7, 1);
    static date endDate = date.newInstance(2016, 12, 31);  
    Static  DateTime myDateC = DateTime.newInstance(2014, 9, 30, 8,3, 5);
    
    
    @testSetup static void createTestRecords() {
        RecordType rt1 = [Select Id, Name from RecordType where Name = 'Program Campaign' limit 1];
        RecordType rt2 = [Select Id, Name from RecordType where Name = 'Default' limit 1];
        Map <Integer, String> esMap =  new Map <Integer, String>{0 =>  '' , 1 =>'ES1', 2 => 'ES2', 
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
        
        
        List<Contact> cons = new List<Contact>();
        for (Integer j=0;j<numAccts;j++) {
            npo02__Household__c acct = accts[j];            
            cons.add(new Contact(firstname='Adult123-'+ j,
                                 lastname='Family123-'+ j ,
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
        insert cons;
        
        
        // Child Record ID
        // 012G0000000qhDN
        List<Contact> chD = new List<Contact>();
        date pm = date.newInstance(2005, 6, 1 );
        for (Integer j=0;j<numAccts;j++) {
            npo02__Household__c acct = accts[j];            
            chD.add(new Contact(firstname='Kid'+ j,
                                lastname='Family1-'+ j,
                                Birthdate = pm,
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
        Insert chD;
        
        List<Case> cas = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact cont = cons[j]; 
            Contact Kid = chd[j];
            Datetime myDateTime = Datetime.newInstance(2016,9, 30);
            cas.add(new Case(ContactId = cont.Id,
                             Call_Type__c = 'Contact',
                             Origin = 'In-person',
                             Status = 'Closed',
                             Start_time__c = myDateTime.addDays(j+80),
                             Add_5_Mins_to_Start_Time_For_End_Time__c =5+j,
                             Family__Child__c = kid.ID,
                             RecordTypeId = '012G0000000qhDK'));
            
        }
        insert cas;
        
        List<Case> cas6 = new List<Case>();
        for (Integer j=1;j<numAccts;j++) {
            Contact cont = cons[j]; 
            Contact Kid = chd[j];
            Datetime myDateTime = Datetime.newInstance(2016,9, 30);
            cas6.add(new Case(ContactId = cont.Id,
                              Call_Type__c = 'Mtg SDSE – Manifestation',
                              Origin = 'In-person',
                              Status = 'Closed',
                              Start_time__c = myDateTime.addDays(j+80),
                              Add_5_Mins_to_Start_Time_For_End_Time__c =5+j,
                              Family__Child__c = kid.ID,
                              RecordTypeId = '012G0000000qhDK'));
            
        }
        insert cas6;
        
        List<Case> casO = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact contO = cons[j]; 
            Contact KidO = chd[j];
            Datetime myDateTimeO = Datetime.newInstance(2016, 9, 29, 12,5,5);
            casO.add(new Case(ContactId = contO.Id,
                              Call_Type__c = 'Contact',
                              Origin = 'In-person',
                              Status = 'Closed',
                              Start_time__c = myDateTimeO.addDays(j),
                              Add_5_Mins_to_Start_Time_For_End_Time__c =5+j,
                              Family__Child__c = kidO.ID,
                              CMSQ__c = string.ValueOf(j+1),
                              
                              RecordTypeId = '012G0000000qhDK'));
            
        }
        insert casO;
        
        
        
        
        List<npo02__Household__c> accts2 = new List<npo02__Household__c>();
        for(Integer i=0;i<numAccts;i++) {
            npo02__Household__c a = new npo02__Household__c(Name='ede' + i,
                                                            npo02__MailingPostalCode__c ='94123');
            
            accts2.add(a);
        }
        insert accts2;
        
        
        List<Contact> cons2 = new List<Contact>();
        for (Integer j=0;j<numAccts;j++) {
            npo02__Household__c acct2 = accts2[j];            
            cons2.add(new Contact(firstname='fre'+ j,
                                  lastname='ser-'+ j ,
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
            chD2.add(new Contact(firstname='KidFe'+ j,
                                 lastname='zie-'+ j,
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
            cas2.add(new Case(ContactId = cont2.Id,
                              Call_Type__c = 'Contact',
                              Origin = 'Phone',
                              Status = 'New',
                              Start_time__c = myDateTime2,
                              Add_5_Mins_to_Start_Time_For_End_Time__c =5+j,
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
            cas22.add(new Case(ContactId = cont2.Id,
                               Call_Type__c = 'Contact',
                               Origin = 'Phone',
                               Status = 'New',
                               Start_time__c = myDateTime2,
                               Add_5_Mins_to_Start_Time_For_End_Time__c =5+j,
                               Family__Child__c = kid2.ID,
                               RecordTypeId = '012G0000000qhDL'));
            
        }
        insert cas22;
        
        //Professional case
        List<Case> cas222 = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact cont2 = cons2[j]; 
            Contact Kid2 = chd2[j];
            Datetime myDateTime2 = Datetime.newInstance(2016, 11, 1);
            cas222.add(new Case(ContactId = cont2.Id,
                                Call_Type__c = 'Contact',
                                Origin = 'Phone',
                                Status = 'New',
                                Start_time__c = myDateTime2,
                                Add_5_Mins_to_Start_Time_For_End_Time__c =5+j,
                                Family__Child__c = kid2.ID,
                                RecordTypeId = '012G0000000qhDL'));
            
        }
        insert cas222;
        
        List<Campaign> camp = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            Datetime myDateTimeOc = Datetime.newInstance(2016, 9, 29, 1,5,5);
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
                                  CMSName__c = esMap.get(j),
                                  Status = 'Completed',
                                  Project_or_Funder__c = 'Family Support',
                                  //CMSQ__c = '2',
                                  Start_Date_Time__c = myDateTimeOc.addDays(j+1),
                                  End_Date_Time__c = myDateTimeOc.addDays(j+2)
                                  //StartDate = myDate 
                                 ));
            
        }   
        insert camp;
        
        List<CampaignMember> CM = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts);j++) {
            Contact co = cons[j];
            Campaign campan = camp[j];    
            CM.add(new CampaignMember(ContactID = co.Id,
                                      CampaignID = campan.Id,
                                      Status = 'Family Attendee'
                                     ));
            
        }             
        insert CM; 
        
        
        List<CampaignMember> CMKids = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts);j++) { 
            Contact campKids = chd[j];
            Campaign campa =camp[j];  
            CMKids.add(new CampaignMember(CampaignID = campa.Id,
                                          ContactID = campKids.Id,
                                          Status = 'Child Attendee' ));
            
        }             
        insert CMkids;
        
        List<Contact> constag = new List<Contact>();
        for (Integer j=0;j<numAccts;j++) {
            constag.add(new Contact(firstname='TAgged'+ j,
                                    lastname='F'+ j ,
                                    RecordTypeID ='012G0000000qhDM',
                                    Family__Primary_Language__c = 'Spanish',
                                    Family__Gender__c = 'Female',
                                    CMS_Tag__c= TRUE,
                                    MailingPostalCode = '94124'
                                   ));
            
            
        }
        
        insert constag;
        
        List<Campaign> campwq = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            Datetime myDateTimeOc = Datetime.newInstance(2016, 9, 29, 1,5,5);
            campwq.add(new Campaign(Name='Prog'+ j,
                                    RecordTypeId = rt1.ID,
                                    CampaignMemberRecordType = rt2,
                                    isActive = True,
                                    Maximum_Capacity_Adults__c = 100,
                                    Maximum_Capacity_Children__c = 100,
                                    Type = 'Workshop',
                                    Campaign_Target__c =1,
                                    Unduplicated_Target__c = 10,
                                    Duplicated_Target__c = 20,
                                    CMSName__c = esMap.get(j),
                                    Status = 'Completed',
                                    Project_or_Funder__c = 'Family Support',
                                    //CMSQ__c = '2',
                                    Start_Date_Time__c = myDateTimeOc.addDays(j+1),
                                    End_Date_Time__c = myDateTimeOc.addDays(j+2)
                                    //StartDate = myDate 
                                   ));
            
        }   
        insert campwq;
        
        List<CampaignMember> CM6 = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts);j++) {
            Contact co = cons[j];
            Campaign campan = campwq[j];
            CM.add(new CampaignMember(ContactID = co.Id,
                                      CampaignID = campan.Id,
                                      
                                      Status = 'Family Attendee'
                                     ));
            
        }             
        insert CM6; 
        
        List<Campaign> childcare = new List<Campaign>();
        for (Integer j=0;j<numAccts;j++) { 
            
            Datetime myDateTimeOc = Datetime.newInstance(2016, 9, 29, 1,5,5);
            childcare.add(new Campaign(Name='Prog'+ j,
                                       RecordTypeId = '012G0000000s0WeIAI',
                                       CampaignMemberRecordType = rt2,
                                       isActive = True,
                                       Maximum_Capacity_Adults__c = 100,
                                       Maximum_Capacity_Children__c = 100,
                                       Campaign_Target__c =1,
                                       Unduplicated_Target__c = 10,
                                       Duplicated_Target__c = 20,
                                       Status = 'In Progress',
                                       Start_Date_Time__c = myDateTimeOc.addDays(j+1),
                                       End_Date_Time__c = myDateTimeOc.addDays(j+2)
                                      ));
            
        }   
        insert childcare;
        
        List<CampaignMember> CMKidschdcare = new List<Campaignmember>();
        for (Integer j=0;j<(numAccts);j++) { 
            Contact campKids = chd[j];
            Campaign campachildcare =childcare[j];   
            CMKids.add(new CampaignMember(CampaignID = campachildcare.Id,
                                          ContactID = campKids.Id,
                                          Status = 'Child' ));
            
        }             
        insert CMkidschdcare;
    } 
    
    @isTest static void testMethod1() {
        
        
        Test.startTest();
        PageReference AnnualRep = Page.CMS_ToDoVF;
        Test.setCurrentPage(AnnualRep);
        
        CMS_ToDoCtr AR = new CMS_ToDoCtr();
        date TestDateTo = date.newInstance(2016, 12, 31 );
        date TestDateFrom = date.newInstance(2016, 7, 1 ); 
        
        Date controllerDateFrom = beginDate;
        Date controllerDateTo = endDate;
        AR.datefrom = controllerDateFrom;
        AR.dateTo = controllerDateTo;
        System.AssertEquals(AR.dateFrom, controllerDateFrom);
        System.AssertEquals(AR.dateTo, controllerDateTo);
        
        AR.startGenerateBoard(); 
        AR.tagContacts();
        AR.getGenerateTagTotals();
        AR.getGenerateUnAss();
        Test.stopTest();       
        
    }
    
    @isTest static void testMethod2() {
        
        Test.startTest();
        PageReference AnnualRep = Page.CMS_ToDoVF;
        Test.setCurrentPage(AnnualRep);
        
        
        CMS_ToDoCtr AR = new CMS_ToDoCtr();
        date TestDateTo = date.newInstance(2016, 9, 30 );
        date TestDateFrom = date.newInstance(2016, 7, 1 ); 
        Date controllerDateFrom = TestDateTo;
        Date controllerDateTo = TestDateTo ;
        
        AR.datefrom = controllerDateFrom;
        AR.dateTo = controllerDateTo;
        System.AssertEquals(AR.dateFrom, controllerDateFrom);
        System.AssertEquals(AR.dateTo, controllerDateTo);
        
        AR.getGenerateUnAss();
        AR.getGenerateTagTotals();
        Test.stopTest();       
        
    }
    
    
    @isTest static void testMethod3() {
        
        
        Test.startTest();
        PageReference AnnualRep = Page.CMS_ToDoVF;
        Test.setCurrentPage(AnnualRep);
        CMS_ToDoCtr AR = new CMS_ToDoCtr();
        date TestDateTo = date.newInstance(2016, 12, 31 );
        date TestDateFrom = date.newInstance(2016, 7, 1 ); 
        Date controllerDateFrom = beginDate;
        Date controllerDateTo = endDate;
        AR.datefrom = controllerDateFrom;
        AR.dateTo = controllerDateTo;
        System.AssertEquals(AR.dateFrom, controllerDateFrom);
        System.AssertEquals(AR.dateTo, controllerDateTo);
        AR.getGenerateTagTotals();
        
        List<Contact> constt = new List<Contact>();
        for (Integer j=0;j<numAccts;j++) {
            constt.add(new Contact(firstname='Adult-'+ j,
                                   lastname='Family-'+ j ,
                                   RecordTypeID ='012G0000000qhDM',
                                   Family__Primary_Language__c = 'Spanish',
                                   Family__Gender__c = 'Female',
                                   Underserved__c= TRUE,
                                   CMS_Tag__c= TRUE,
                                   MailingPostalCode = '94124'
                                  ));

        }
        AR.getGenerateTagTotals();
        Test.stopTest();       
        
    }
  
}