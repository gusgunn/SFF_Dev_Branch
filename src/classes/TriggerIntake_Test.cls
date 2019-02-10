@isTest
public class TriggerIntake_Test {
    
    static private Integer numAccts = 1;
    static private Integer numContactsPerAcct = 2;
    static date beginDate = date.newInstance(2016, 1, 1);
    static date endDate = date.newInstance(2016, 12, 30);    
    
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
                                 Underserved__c= TRUE,
                                 Low_Income__c= TRUE,
                                 Income__c = 'Homeless',
                                 Housing_Status__c ='Vehicle',
                                 
                                 lep__c = 'Declined',
                                 Incarcerated_youth__c = True,
                                 
                                 npo02__Household__c=acct.Id));
            
        }
        // Insert all contacts for all accounts
        insert cons;
        
        // Child Record ID
        // 012G0000000qhDN
        List<Contact> chD = new List<Contact>();
        date pm = date.newInstance(2006, 6, 1 );
        for (Integer j=0;j<numAccts;j++) {
            npo02__Household__c acct = accts[j];            
            // For each account just inserted, add 10 kid contacts
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            chD.add(new Contact(firstname='JulyKidMaleEnParSp'+ j,
                                lastname='July15-'+ j,
                                Birthdate = pm.addYears(j),
                                RecordTypeID ='012G0000000qhDN',
                               // Family__Primary_Language__c = 'English',
                                Family__Ethnicity__c ='Hispanic or Latino',
                                //Ethnicity_Hispanic_Latino_Other__c = 'Central American',
                                Hispanic_Latino_please_specify__c = 'Central American',
                                Family__Race__c = 'Asian - Chinese;)',
                                Race_Other__c = '',
                                Family__Gender__c = 'Male',
                                //School_Type__c ='Does not apply',
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
                             Call_Type__c = 'Intake',
                             Origin = 'In-person',
                             Status = 'Closed',
                             Start_time__c = myDateTime.addDays(j),
                             Family__Child__c = kid.ID,
                             RecordTypeId = '012G0000000qhDK'));
            
        }
        insert cas;
        
        List<Case> cas2 = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact cont2 = cons[j]; 
            Contact Kid2 = chd[j];
            Datetime myDateTime2 = Datetime.newInstance(2016, 11, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            cas2.add(new Case(ContactId = cont2.Id,
                              Call_Type__c = 'Intake',
                              Origin = 'Phone',
                              Status = 'New',
                              Start_time__c = myDateTime2.addDays(j),
                              Family__Child__c = kid2.ID,
                              RecordTypeId = '012G0000000qhDK'));
            
        }
        insert cas2;
        
         List<Case> cas3 = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact cont3 = cons[j]; 
            Contact Kid3 = chd[j];
            Datetime myDateTime = Datetime.newInstance(2016,1, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            cas3.add(new Case(ContactId = cont3.Id,
                             Call_Type__c = 'contact',
                             Origin = 'In-person',
                             Status = 'Closed',
                             Start_time__c = myDateTime.addDays(j),
                             //Family__Child__c = kid3.ID,
                             RecordTypeId = '012G0000000qhDK'));
            
        }
        insert cas3;
        
        
         List<Case> cas4 = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact cont4 = cons[j]; 
            Contact Kid4 = chd[j];
            Datetime myDateTime = Datetime.newInstance(2016,1, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            cas4.add(new Case(ContactId = cont4.Id,
                             Call_Type__c = 'Intake',
                             Origin = 'In-person',
                             Status = 'Closed',
                             Start_time__c = myDateTime.addDays(j),
                             //Family__Child__c = kid3.ID,
                             RecordTypeId = '012G0000000qhDK'));
            
        }
        insert cas4;
   
         List<Contact> chD2 = new List<Contact>();
        date pm2 = date.newInstance(2006, 6, 1 );
        for (Integer j=0;j<numAccts;j++) {
            npo02__Household__c acct2 = accts[j];            
            // For each account just inserted, add 10 kid contacts
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            chD2.add(new Contact(firstname='noBday'+ j,
                                lastname='None-'+ j,
                                Birthdate = pm.addYears(j),
                                RecordTypeID ='012G0000000qhDN',
                                Family__Primary_Language__c = 'English',
                                Family__Ethnicity__c ='Hispanic or Latino',
                                //Ethnicity_Hispanic_Latino_Other__c = 'please explain',
                                Hispanic_Latino_please_specify__c = 'Central American',
                                Family__Race__c = 'Asian - Chinese;)',
                                Race_Other__c = '',
                                Family__Gender__c = 'Male',
                                School_Type__c ='Does not apply',
                                npo02__Household__c=acct2.Id));
            
        } 
          
        Insert chD2;
         List<Case> cas5 = new List<Case>();
        for (Integer j=0;j<numAccts;j++) {
            Contact cont5 = cons[j]; 
            Contact Kid5 = chd2[j];
            Datetime myDateTime = Datetime.newInstance(2016,1, 1);
            // for (Integer k=numContactsPerAcct*j;k<numContactsPerAcct*(j+1);k++) {
            cas4.add(new Case(ContactId = cont5.Id,
                             Call_Type__c = 'Intake',
                             Origin = 'In-person',
                             Status = 'Closed',
                             Start_time__c = myDateTime.addDays(j),
                             Family__Child__c = kid5.ID,
                             RecordTypeId = '012G0000000qhDK'));
            
        }
        //delete cas5;
        insert cas5;
        
        
       
    }
}