public class UpdateHDemographicsCTR {


 
    //Global Variables
    
    public List<Contact> cons {get;set;}
    public List<Contact> consALL {get;set;}
    public List<Contact> consAdult {get;set;}
    
    //public List<Contact> contacts {get;set;}
    
    
    public String searchString {get;set;}
    
    
    private String conID;
    private String HHID; 
    
    //only use if view on standard controller
    
    
    
    //Constructor for standard page
    
    public UpdateHDemographicsCTR (ApexPages.StandardController controller) 
    {
        
        searchString='';
        conID = controller.getId();
        doQuery();
    }
    
    public void doQuery()
    {
        
        String queryString = '';
        
        if(searchString != null) 
            
            //add in % in the query string
            
            queryString = searchString+'%';
        
        List<Contact> HH = new List<Contact>();
        
        
        //if viewing on standard controller (), add in filter for ContacId
        
        cons = [SELECT ID,  contact.npo02__Household__r.name, 
                               contact.npo02__Household__c      
                               FROM Contact 
                               WHERE LastName like :queryString
                               AND ID = :conID 
                                   
                               ORDER BY LastName asc
                               LIMIT 1];
        for (contact c :cons){
            hhID = c.npo02__Household__c;
        }
        
        consAll = [SELECT ID, Written_Release_Date__c, Verbal_Release_Date__c, Birthdate, Childcare_Special_Considerations__c, Childcare_best_way_to_soothe__c,Childcare_Favorites__c,
                                 Family__Diagnosis_1_Group__c, Family__Diagnosis_1__c, Family__Gender__c, Family__Parent__c, Family__Race__c, Family__Ethnicity__c, 
                                 Family__Primary_Language__c, English_Fluency__c, School_Type__c, contact.AccountID, contact.RecordType.Name, 
                                 contact.npo02__Household__r.name,  contact.npo02__Household__c,  FirstName, LastName, writtenReleaseNeeded__c, VerbalReleaseNeeded__c
                                 FROM Contact 
                                 WHERE LastName like :queryString
                                 AND (contact.npo02__Household__c = :hhID)
                                                 AND contact.RecordType.Name ='Child/Person with Disability'
                                 ORDER BY LastName asc
                                 LIMIT 30];
    
          consAdult = [SELECT ID, MobilePhone,
                                Family__Parent__c, Family__Race__c, Family__Ethnicity__c,  Family__Primary_Language__c, English_Fluency__c,  MailingPostalCode, contact.AccountID, contact.RecordType.Name, 
                                 contact.npo02__Household__r.name,  contact.npo02__Household__c,  FirstName, LastName, Email, Phone
                                 FROM Contact 
                                 WHERE LastName like :queryString
                                 AND (contact.npo02__Household__c = :hhID)
                                                 AND contact.RecordType.Name ='Adult'
                                 ORDER BY LastName asc
                                 LIMIT 6];
    
    //save all records that were updated
    
    }
    public void save() 
    {
        
        update consAll; 
        update consAdult;
    }
    
}