@isTest
public class TestFactory {
    
    private static RecordType rtProgramCampaign = [Select Id, Name from RecordType where Name = 'Program Campaign'  AND sObjectType = 'Campaign' limit 1];
    private static RecordType rtChildcare = [Select Id, Name from RecordType where Name = 'Childcare' AND sObjectType = 'Campaign' limit 1];
    public static RecordType rtAdultContact = [select Id from RecordType where Name = 'Adult' and SobjectType = 'Contact' LIMIT 1];//Grab all required fields?
    public static RecordType rtChildContact = [Select Id, Name from RecordType where Name = 'Child/Person With Disability'  and SobjectType = 'Contact' limit 1];
    public static RecordType rtFamilyInteraction = [Select Id, Name from RecordType where Name = 'Family Case' AND sObjectType = 'Case' limit 1];
    public static RecordType rtProfessionalInteraction = [Select Id, Name from RecordType where Name = 'Professional Case' AND sObjectType = 'Case' limit 1];
    private static RecordType actionRT = [SELECT Id, Name FROM recordType WHERE Name = 'Internal Referral' AND sObjectType = 'Action__c' LIMIT 1];
    public static date teenager = date.newInstance(2004, 7, 2); // Date.ValueOf(Q1.addYears(-13)); 
    public static date espKid = date.newInstance(2015, 7, 2); 
    public static date hmgKid = date.newInstance(2012, 7, 2);
    public static dateTime priorQends = date.newInstance(2017, 6, 30);
    public static dateTime Q1 = date.newInstance(2017, 7, 2);
    public static dateTime Q2 = date.newInstance(2017, 9, 2);
    public static dateTime Q3 = date.newInstance(2017, 1, 2);
    public static dateTime Q4 = date.newInstance(2016, 3, 2);
    public static Map <Integer, Date> kidBdayMap = new Map<Integer, Date>{0 =>  espKid , 1 => hmgKid, 2 => teenager};
    //Essential Measures Map
    public static Map <Integer, String> esMap =  new Map <Integer, String>{0 =>  'ES3' , 1 =>'ES1', 2 => 'ES2', 
        3 =>'ES3', 4 => 'ES1', 5 => 'ES2', 
        6 =>'ES3', 7 =>'ES2', 8 => 'ES1', 
        9 => 'ES3', 10 =>'ES2',11 =>'ES1'}; 
            
            Public static Map <Integer, String> CaseCallTypeMap =  new Map <Integer, String>{0 =>  'Intake' , 1 =>'Contact', 2 => 'Left Message' 
                /* 3 =>'ES3', 4 => 'ES1', 5 => 'ES2', 
6 =>'ES3', 7 =>'ES2', 8 => 'ES1', 
9 => 'ES3', 10 =>'ES2',11 =>'ES1'*/
                }; 
                    
                    
    public static List <Contact> CreateFamilies( Integer numberOfCasesHouseholds, Integer numberOfContacts){
                        List <Contact> familyContacts =new List<Contact>();
                        List <npo02__Household__c> households = CreateHouseholds(numberOfCasesHouseholds);
                        List <Contact> adultContacts = CreateAdultContacts(numberOfContacts, households );
                        familyContacts.addAll(adultContacts);
                        List <Contact> childContacts = CreateChildContacts(numberOfContacts, households);
                        familyContacts.addAll(childContacts);
                        return familyContacts;  
                    }
    
    public static List<npo02__Household__c> createHouseholds(Integer numberOfCasesHouseholds){
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        
        List<npo02__Household__c> HouseHoldsList = new List<npo02__Household__c>();
        for(Integer i = 0; i< numberOfCasesHouseholds; i++){
            HouseHoldsList.add(new npo02__Household__c(Name='House-' + String.ValueOf(i),
                                                       npo02__MailingPostalCode__c ='9411' + String.ValueOf(i)));
        }
        database.insert(HouseHoldsList, dml);
        //System.assertEquals(1, HouseHoldsList.size());
        return HouseHoldsList;
    }
    
    private static List<Contact> CreateAdultContacts(Integer numberOfContacts, List<npo02__Household__c> HouseHoldsList) {
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        List <Contact> AdultContactsList = new List <Contact>();
        for(npo02__Household__c h: HouseHoldsList){
            for(Integer i = 0; i< numberOfContacts; i++){ 
                AdultContactsList.add( new Contact (FirstName='Adult' +  String.ValueOf(i), 
                                                    LastName='Becee' + String.ValueOf(i), 
                                                    RecordTypeID = rtAdultContact.Id,
                                                    Family__Primary_Language__c = 'Spanish',
                                                    Family__Gender__c = 'Female',
                                                    Underserved__c= TRUE,
                                                    Low_Income__c= TRUE,
                                                    Income__c = 'Homeless',
                                                    Housing_Status__c ='Vehicle',
                                                    MailingPostalCode = '9412' + String.ValueOf(i),
                                                    lep__c = 'Declined',
                                                    Incarcerated_youth__c = True,
                                                    npo02__Household__c=h.id,
                                                    Last_Interaction_Date__c = espKid
                                                   ));  
            }
        }
        Database.insert(AdultContactsList, dml);
       // System.assertEquals(1, AdultContactsList.size());
        return AdultContactsList;
    }
    private static List <Contact> CreateChildContacts(Integer numberOfContacts,  List<npo02__Household__c> HouseHoldsList){
        System.debug('-------------------------------------------------------------> ' + teenager);
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        Integer m=0;
        List <Contact> ChildContactslist = new List <Contact>();
        for(Integer i = 0; i< numberOfContacts; i++){
             if(m>1){
                m=0;
            }Else{
                m++;
            }
            npo02__Household__c h = HouseHoldsList[0]; 
            ChildContactslist.add( new Contact (FirstName='Kid' +  String.ValueOf(i), 
                                                LastName='Becee' + String.ValueOf(i), 
                                                RecordTypeID = rtChildContact.Id,
                                                Family__Primary_Language__c = 'Spanish',
                                                Family__Gender__c = 'Female',
                                                Birthdate = teenager, // kidBdayMap.get(m),
                                                //schooltype etc
                                                Underserved__c= TRUE,
                                                Low_Income__c= TRUE,
                                                Income__c = 'Homeless',
                                                Housing_Status__c ='Vehicle',
                                                MailingPostalCode = '9412' + String.ValueOf(i),
                                                lep__c = 'Declined',
                                                Incarcerated_youth__c = True,
                                                npo02__Household__c=h.id));
            
        }
        Database.insert(ChildContactslist, dml);
        //System.assertEquals(1, ChildContactslist.size(), 'child');
        return ChildContactslist;
    }
    
    public static List <Case> createCasesFor1Child(Integer numberOfCases ){
        createFamilies(1, 1);
        Contact  adult = [SELECT Id, npo02__Household__c FROM Contact WHERE RecordTypeID =: rtAdultContact.Id  Limit 1];
        Contact  child = [SELECT Id, npo02__Household__c FROM Contact WHERE RecordTypeID =: rtChildContact.Id Limit 1];
        List<Case> cases = new List<Case>();
        Integer m =0;
        for (Integer caseCount=0;caseCount<numberOfCases;caseCount++) {
            if(m>1){
                m=0;
            }Else{
                m++;
            }

            cases.add(new Case(ContactId = adult.Id,
                                   Call_Type__c = CaseCallTypeMap.get(m), 
                                   Origin = 'In-person',
                                   Status = 'Closed',
                                   Family__Household__c = child.npo02__Household__c,
                                   Start_time__c = priorQends.addMonths(caseCount),
                                   Add_5_Mins_to_Start_Time_For_End_Time__c = 5,
                                   Family__Child__c = child.ID,
                                   RecordTypeId = rtFamilyInteraction.id));    
        }
        insert cases;
        System.assertEquals(numberOfCases, cases.size());
        return cases;
    }
    
    
}