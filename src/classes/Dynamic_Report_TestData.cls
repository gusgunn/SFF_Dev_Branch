@isTest
public class Dynamic_Report_TestData {
    
    public static RecordType rtProgramCampaign = [Select Id, Name from RecordType where Name = 'Program Campaign'  AND sObjectType = 'Campaign' limit 1];
    public static RecordType rtChildcare = [Select Id, Name from RecordType where Name = 'Childcare' AND sObjectType = 'Campaign' limit 1];
    //Private static RecordType rtDefault = [Select Id, Name from RecordType where Name = 'Default'AND sObjectType = 'Campaign' limit 1];
    public static RecordType rtAdultContact = [select Id from RecordType where Name = 'Adult' and SobjectType = 'Contact' LIMIT 1];//Grab all required fields?
    public static RecordType rtChildContact = [Select Id, Name from RecordType where Name = 'Child/Person With Disability'  and SobjectType = 'Contact' limit 1];
    public static RecordType rtFamilyInteraction = [Select Id, Name from RecordType where Name = 'Family Case' AND sObjectType = 'Case' limit 1];
    public static RecordType rtProfessionalInteraction = [Select Id, Name from RecordType where Name = 'Professional Case' AND sObjectType = 'Case' limit 1];
    public static RecordType actionRT = [SELECT Id, Name FROM recordType WHERE Name = 'Internal Referral' AND sObjectType = 'Action__c' LIMIT 1];
    public static RecordType actionExternalRT = [SELECT Id, Name FROM recordType WHERE Name = 'External Referral' AND sObjectType = 'Action__c' LIMIT 1];
    public static date NewDate =  Date.today(); 
    static date BDate = Date.today();
    
    
    //Num Contacts should be 1 to keep households simple 
    public static Map <Id, Contact>  createFamilies( Integer numHouseholds, Integer numContacts, Integer ageOfChildrenToTest){
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        Map <Id, Contact> familyContacts = new Map<Id, Contact>();
        List <npo02__Household__c> householdList = createHouseholds(numHouseholds);
        Map <Id, Contact> adultList = createContacts(numHouseholds, numContacts, householdList );
        Map <Id, Contact> kidList = createKids(numHouseholds, numContacts, householdList, ageOfChildrenToTest);
        for(npo02__Household__c h: householdList){
            Contact addAdult = adultList.get(h.Id);
            Contact addKid= kidList.get(h.Id);
            familyContacts.put(addAdult.Id, addKid);
        }
        
        return familyContacts;
        
    }
    
    public static List<npo02__Household__c> createHouseholds(Integer numAccounts){
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        
        List<npo02__Household__c> hhList = new List<npo02__Household__c>();
        for(Integer i = 0; i< numAccounts; i++){
            hhList.add(new npo02__Household__c(Name='House-' + String.ValueOf(i),
                                               npo02__MailingPostalCode__c ='94110'));
        }
        System.assertEquals(numAccounts, hhList.size()  ); 
        database.insert(hhList, dml);
        return hhList;
    }
    
    private static Map <Id, Contact> createContacts(Integer numAccounts, Integer numContacts,  List<npo02__Household__c> hhList) {
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
          Map <Id, Contact> adultContactMap = new   Map <Id, Contact>();
        List<Contact> adultContactList = new List <Contact>();
        for( npo02__Household__c  h : hhList){
            for(Integer i = 0; i< numContacts; i++){
                adultContactList.add( new Contact (FirstName= String.ValueOf(i) + 'Adult'   , 
                                          LastName= String.ValueOf(i) + 'Becee' , 
                                          RecordTypeID = rtAdultContact.Id,
                                          Family__Primary_Language__c = 'Spanish',
                                          Family__Gender__c = 'Female',
                                          npo02__Household__c =h.Id
                                          
                                         ));
                
            }
          
        }
        integer totalContacts =(numContacts* hhList.size());
        System.assertEquals(totalContacts, adultContactList.size()  );
        Database.insert(adultContactList, dml);
        for(Contact c: adultContactList){
               adultContactMap.put(c.npo02__Household__c, c);
        }
        return adultContactMap;
    }
    
    private static Map <Id, Contact> createKids(Integer numAccounts, Integer numContacts,  List<npo02__Household__c> hhList, Integer ageOfChildrenToTest){
        // Date BDate = Date.today()-ageOfKidsTest ;
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        Map <Id, Contact> ChildContactMap = new  Map <Id, Contact>();
        List<Contact> ChildContactList = new List <Contact>();
        for( npo02__Household__c  h : hhList){
            for(Integer i = 0; i< numContacts; i++){
                ChildContactList.add( new Contact (FirstName=String.ValueOf(i) + 'Kid' , 
                                               LastName= hhList[i].name, 
                                               RecordTypeID = rtChildContact.Id,
                                               Family__Primary_Language__c = 'Spanish',
                                               Family__Gender__c = 'Female',
                                               Birthdate = BDate.addYears(-ageOfChildrenToTest),
                                               npo02__Household__c=h.id
                                              ));
              
                
            }
             
        }
       
        Integer totalContacts =(numContacts* hhList.size());
       // System.assertEquals(totalContacts, ChildContactMap.size()  );
        Database.insert(ChildContactList, dml);
      for(Contact c: ChildContactList) {
            ChildContactMap.put(c.npo02__Household__c, c);
      }
        return ChildContactMap;
    }
    
    
}