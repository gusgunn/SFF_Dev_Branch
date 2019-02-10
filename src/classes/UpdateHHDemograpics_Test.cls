@Istest
public class UpdateHHDemograpics_Test {
    
    
    static private Integer numAccts = 10;
    static private Integer numContactsPerAcct = 2;
    static date beginDate = date.newInstance(2016, 7, 1);
    static date endDate = date.newInstance(2017, 6, 30);    
    
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
        date pm = date.newInstance(2016, 7, 1 );
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
        
        
     Contact c = new Contact(lastname='x', npo02__Household__c =accts[1].ID);
        insert c;
        Case cas = new Case();
            cas.ContactId = c.Id;
            cas.Call_Type__c = 'Mtg';
            cas.Origin = 'In-person';
            cas.Status = 'Closed';
            cas.Start_time__c = beginDate;
            cas.Family__Child__c = chd[1].ID;
            cas.RecordTypeId = '012G0000000qhDK';
        insert cas;
        
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(cas);
        UpdateHDemographicsCTR aclc = new UpdateHDemographicsCTR(sc);
        aclc.doQuery();
        aclc.Save();
        
    }
}