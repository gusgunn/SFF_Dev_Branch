@isTest
private  class ResourceGuide_Test {
    
    @testSetup static void setup() {
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave=true;
        
        List<Account> testAccts = new List<Account>();
        for(Integer i=0;i<8;i++) {
            testAccts.add(new Account(Name ='Test Acc' + String.ValueOf(i), Include_in_Resource_Guide__c = True,  Condition__c = 'ADD-ADHD', Wheelchair_Accessible__c = True, 
                                      Website ='http://www.test' + String.ValueOf(i), Phone= '415-543-098' + i,  BillingPostalCode = '9432'+i,
                                      Issue_Type__c = 'Adult Services', Email__c= String.ValueOf(i)+'xyz@test.com'));
        }
        database.insert(testAccts, dml);
           
    }
    
   @isTest 
    static void testGetIssueTypes(){
        String selectListName = 'Issue_Type__c';
        ResourceGuide.getIssueTypes(selectListName);
    }
    
    @isTest 
    static void testGetConditionTypes(){
        String selectListName = 'Condition__c';
        ResourceGuide.getIssueTypes(selectListName);
    }
    
    
    @isTest 
    static void testGetSearchAccounts(){
        String objectName = 'Account';
        String searchKeyWord = 'Test';
        String accountName = 'Test';
        String issue ='Adult Services';
        String zipCode = '9432';
        String condition ='ADD-ADHD';
        List <Account> returnedAccs = ResourceGuide.fetchAvailableValues(objectName, searchKeyWord, accountName, issue, zipCode, condition);  
        System.assertEquals(8, returnedAccs.size());
        
    }
    
     
    @isTest 
    static void testGetZeroAccounts(){
        String objectName = '';
        String searchKeyWord = '';
        String accountName = '';
        String issue ='';
        String zipCode = '95667';
        String condition ='';
        List <Account> returnedAccs = ResourceGuide.fetchAvailableValues(objectName, searchKeyWord, accountName, issue, zipCode, condition);  
        System.assertEquals(0, returnedAccs.size());
       
    }
    
     @isTest 
    static void testGetMaxRowZero(){
        String objectName = '';
        String searchKeyWord = '';
        String accountName = '';
        String issue ='';
        String zipCode = '';
        String condition ='';
        List <Account> returnedAccs = ResourceGuide.fetchAvailableValues(objectName, searchKeyWord, accountName, issue, zipCode, condition);  
        System.assertEquals(0, returnedAccs.size());
        
    }
    
 
    
}