@isTest
public class CMS_UserSW_Test {
    static private Integer numAccts = 4;
    static private Integer numContactsPerAcct = 4;
    static date beginDate = date.newInstance(2016, 7, 1);
    static date endDate = date.newInstance(2016, 12, 31);  
    Static  DateTime myDateC = DateTime.newInstance(2014, 9, 30, 8,3, 5);
    public User testUserSW;
    
    
    @testSetup static void createTestRecords() {
 		Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;        
     
        Profile testProfile = [SELECT Id 
                                       FROM profile
                                       WHERE Name = 'SFCD Social Worker' 
                                      
                                       LIMIT 1];
   
        User u = new User(Alias = 'JD',
                          Email = 'jd@TestGTest.com',
                          FirstName = 'Jack',
                          LastName = 'fried',
                          IsActive = TRUE,
                          TimeZoneSidKey = 'America/Los_Angeles',
                          UserName = 'jd@TestGTest.com',
                          ProfileID = '00e16000000GgJwAAK',
                          LocaleSidKey = 'en_US',
                          EmailEncodingKey = 'UTF-8',
                          LanguageLocaleKey = 'en_US');
        
        Database.insert(u, dml);
         System.runas(u) {
             
		DataForTest.createFamilyCasesForOneFamily(3);
        }
 
    
        
        
    }
        static testmethod void Sw() {
          
            test.startTest();
            
            // get reference to EIS Dashboard Page
            PageReference AnnualRep = Page.CMS_Interactions_VF;
            Test.setCurrentPage(AnnualRep);
            
            // get a Page controller instance set to Q4
            CMS_CTR_Int AR = new CMS_CTR_Int();
            date TestDateTo = date.newInstance(2017, 6, 30 );
            date TestDateFrom = date.newInstance(2016, 7, 1 ); 
            // Set Date From and Date To on Controller
            Date controllerDateFrom = TestDateFrom;
            Date controllerDateTo = TestDateTo;
            AR.datefrom = controllerDateFrom;
            AR.dateTo = controllerDateTo;
            System.AssertEquals(AR.dateFrom, controllerDateFrom);
            System.AssertEquals(AR.dateTo, controllerDateTo);
            
            AR.startGenerateBoard(); 
            
            AR.getIASWInteractions();
            AR.getFRSInteractions();
            AR.getFS_SWInteractions();
            //   AR.getIAInteractions();
            
            AR.getFRSProviderInteractions();
            //  AR.getIAProviderInteractions();
        }
        
    }