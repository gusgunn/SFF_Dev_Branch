@isTest
public class InteractionDispatcher_Test {
    private static RecordType rTProfInteraction = [SELECT Id, Name FROM recordType WHERE Name = 'Professional Case' AND sObjectType = 'Case' LIMIT 1];
    private static RecordType rTFamInteraction = [SELECT Id, Name FROM recordType WHERE Name = 'Family Case' AND sObjectType = 'Case' LIMIT 1];
    private static RecordType rtAdultContact = [select Id from RecordType where Name = 'Adult' and SobjectType = 'Contact' LIMIT 1];//Grab all required fields?
    private static RecordType rtChildContact = [Select Id, Name from RecordType where Name = 'Child/Person With Disability'  and SobjectType = 'Contact' limit 1];
    public static RecordType rTIntakeSurvey = [SELECT Id, Name FROM recordType WHERE Name = 'Intake Survey' AND sObjectType = 'Case' LIMIT 1];
    public static RecordType rTSwFAF = [SELECT Id, Name FROM recordType WHERE Name = 'SW Family Assessment' AND sObjectType = 'Case' LIMIT 1];
    private static Profile SW = [SELECT Id, Name from Profile where name ='SFCD Social Worker' LIMIT 1];
    static private Integer numAccts = 2;
    static private Integer numContactsPerAcct = 2;
    static date beginDate = date.today()-15;
    static date endDate = date.today();  
    static datetime myDateTime = date.today();
    static datetime firstDate = datetime.newInstance(2016,1, 1);
    static dateTime ProfIntDate = date.today()-20;  
    static date bdate = date.today()-100; 
    static date stdDate = myDateTime.date();
    static date stdProfDate = ProfIntDate.date();
    
    
    // Given
    @testSetup static void createTestRecords() {
        
        List<case> cases= new List<Case>();
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave=true;
        
        Account testAccount = new Account(Name = 'Test Account');
        database.insert(testAccount, dml); 
        
        npo02__Household__c hh = new npo02__Household__c(Name='Family House' ,
                                                         npo02__MailingPostalCode__c ='94110',
                                                         First_Intake__c = beginDate, Last_Intake__c= beginDate,
                                                         Most_Recent_Household_Interaction__c=beginDate, First_Interaction__c=beginDate);
        
        database.insert(hh, dml);
        
        Contact testContact = new Contact(RecordTypeId = rtAdultContact.Id, LastName = 'TestContact', Error_Contact__c  = true, 
                                          Email = 'test@example.com', npo02__Household__c = hh.ID, 
                                          First_Interaction__c =beginDate, Last_Interaction_Date__c= beginDate);
        database.insert(testContact, dml); 
        
       
        
        Contact childTestContact = new Contact(FirstName='Abe' , 
                                               LastName='Becee' , 
                                               RecordTypeID = rtChildContact.Id,
                                               Family__Primary_Language__c = 'Spanish',
                                               Family__Gender__c = 'Female',
                                               Birthdate = BDate,
                                               npo02__Household__c=hh.id	
                                              );
        
        database.insert(childTestContact, dml); 
        
        
       
        Case firstcase = new Case(ContactId = testContact.ID,
                              
                              Call_Type__c = 'Intake',
                              Origin = 'In-person',
                              Status = 'Closed',
                              Start_time__c = firstDate ,
                              Add_5_Mins_to_Start_Time_For_End_Time__c = 5,  
                              Family__Household__c = hh.ID,
                              Family__Child__c = childTestContact.id,
                              RecordTypeId = rTFamInteraction.Id);
        
        
      
        database.insert(firstcase, dml);
      
    
    Case case2 = new Case(ContactId = testContact.ID,
                              
                              Call_Type__c = 'Contact',
                              Origin = 'In-person',
                              Status = 'Closed',
                              Start_time__c = myDateTime,
                              Add_5_Mins_to_Start_Time_For_End_Time__c = 5,  
                              Family__Household__c = hh.ID,
                              Family__Child__c = childTestContact.id,
                              RecordTypeId = rTFamInteraction.Id);
        
        
      
        database.insert(case2, dml);
    }   
    
    
    @isTest static void testMethodFAmilyNewInt() {
        
        List<Contact> kiddo = [SELECT Id, First_Interaction__c, Last_Interaction_Date__c, 
                               recordTypeID, npo02__Household__c,  
                               npo02__Household__r.First_Intake__c, npo02__Household__r.Last_Intake__c,
                               npo02__Household__r.Most_Recent_Household_Interaction__c,npo02__Household__r.First_Interaction__c
                               FROM Contact 
                           
                              ];
            System.assertEquals(2, kiddo.size(), 'number of kiddo sould be 1'); 
    }
   

}