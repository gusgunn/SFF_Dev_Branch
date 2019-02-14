@isTest
public class Dynamic_Report_ByAge_Test {
    static private Integer numHouseholds = 5;
    static private Integer numContactsPerHousehold = 2;
    
    static private Integer ageOfChildrenToTest = 3;
    
    static date beginDate = date.newInstance(2015, 7, 1);
    static date endDate = date.newInstance(2015, 9, 30);    
    
    
    
    
    static List<npo02__Household__c> splitFamilies (List <contact> families){
        return [SELECT Id, (SELECT Id, recordType.DeveloperName  FROM npo02__Contacts__r) FROM  npo02__Household__c];
        
    }
    
    static List<Case> makeCases (Integer numberOfCases, Map <Id, Contact> families){
        List<case> testCases = new List<case>();
        for(Id a: families.keyset()){
            Contact kid =   families.get(a);
            
            for(Integer i = 0; i< numberOfCases; i++){
                testCases.add(new Case(ContactId = a,
                                       Call_Type__c = 'Contact', 
                                       Origin = 'In-person',
                                       Status = 'Closed',
                                       Family__Household__c = kid.npo02__Household__c,
                                       Start_time__c = date.Today().addMonths(-i),
                                       Add_5_Mins_to_Start_Time_For_End_Time__c = 5,
                                       Family__Child__c = kid.Id,
                                       RecordTypeId = Dynamic_Report_TestData.rtFamilyInteraction.id)); 
            }   
        }
        insert testCases;
        // System.assertEquals(numberOfCases, testCases.size());
        return testCases;    
    } 
    
    @isTest
    static void getNullDateRequest(){
        Test.startTest();
        PageReference dashboard = Page.Dynamic_Report_ByAge_VF;
        Test.setCurrentPage(dashboard);
        Dynamic_Report_ByAge ctr = new Dynamic_Report_ByAge();
        date TestDateFrom = date.today().addYears(-1);
        date TestDateTo = date.today(); 
        ctr.dateFrom = TestDateFrom;
        ctr.startGenerateBoard();
        ctr.getGenerateAgeNoAge(); 
        ctr.getGenerateAge1();
        Test.stopTest();        
    }
    
  @isTest
    static void getBadDateRequest(){
        Test.startTest();
        PageReference dashboard = Page.Dynamic_Report_ByAge_VF;
        Test.setCurrentPage(dashboard);
        Dynamic_Report_ByAge ctr = new Dynamic_Report_ByAge();
        date TestDateFrom = date.today().addYears(-1);
        ctr.dateTo = TestDateFrom;
        ctr.startGenerateBoard();
        ctr.getGenerateAgeNoAge(); 
        ctr.getGenerateAge1();
        Test.stopTest();        
    }
    
    
    @isTest 
    static void testFamiliesWithTwelveYearOld(){
        Map <Id, Contact> families = Dynamic_Report_TestData.createFamilies( 10, 1, 12);
        makeCases(6, families);
        getDashboardNumbers(); 
    }
    
    @isTest 
    static void testFamiliesWithNineYearOld(){
        Map <Id, Contact> families = Dynamic_Report_TestData.createFamilies( 10, 1, 9);
        makeCases(6, families);
        getDashboardNumbers(); 
    }
    
    @isTest 
    static void testFamiliesWithEightYearOld(){
        Map <Id, Contact> families = Dynamic_Report_TestData.createFamilies( 10, 1, 8);
        makeCases(6, families);
        getDashboardNumbers(); 
    }
    
    @isTest 
    static void testFamiliesWithSevenYearOld(){
        Map <Id, Contact> families = Dynamic_Report_TestData.createFamilies( 10, 1, 7);
        makeCases(6, families);
        getDashboardNumbers(); 
    }
    
    @isTest 
    static void testFamiliesWithSixYearOld(){
        Map <Id, Contact> families = Dynamic_Report_TestData.createFamilies( 10, 1, 6);
        makeCases(6, families);
        getDashboardNumbers(); 
    }
    
    @isTest 
    static void testFamiliesWithFiveYearOld(){
        Map <Id, Contact> families = Dynamic_Report_TestData.createFamilies( 10, 1, 5);
        makeCases(6, families);
        getDashboardNumbers(); 
    }
    
    @isTest 
    static void testFamiliesWith4YearOld(){
        Map <Id, Contact> families = Dynamic_Report_TestData.createFamilies( 10, 1, 4);
        makeCases(6, families);
        getDashboardNumbers(); 
    }
    
    @isTest 
    static void testFamiliesWithThreeYearOld(){
        Map <Id, Contact> families = Dynamic_Report_TestData.createFamilies( 10, 1, 3);
        makeCases(6, families);
        getDashboardNumbers(); 
    }
    
    @isTest 
    static void testFamiliesWithTwoYearOld(){
        Map <Id, Contact> families = Dynamic_Report_TestData.createFamilies( 10, 1, 2);
        makeCases(6, families);
        getDashboardNumbers(); 
    }
    
    
    @isTest 
    static void testFamiliesWithOneYearOld(){
        Map <Id, Contact> families = Dynamic_Report_TestData.createFamilies( 10, 1, 1);
        makeCases(6, families);
        getDashboardNumbers(); 
    }
    
    @isTest 
    static void testFamiliesWithZeroYearOld(){
        Map <Id, Contact> families = Dynamic_Report_TestData.createFamilies( 10, 1, 0);
        makeCases(6, families);
        getDashboardNumbers(); 
    }
    
    static void getDashboardNumbers(){
        Test.startTest();
        PageReference dashboard = Page.annualReportVF;
        Test.setCurrentPage(dashboard);
        annualReportAge ctr = new annualReportAge();
        date TestDateFrom = date.today().addYears(-1);
        date TestDateTo = date.today(); 
        ctr.dateFrom = TestDateFrom;
        ctr.dateTo = TestDateTo;
        System.AssertEquals(ctr.dateFrom, TestDateFrom );
        System.AssertEquals(ctr.dateTo, TestDateTo);
        ctr.startGenerateBoard();
        ctr.getGenerateAgeNoAge(); 
        ctr.getGenerateAge1();
       // ctr.GenerateKidsYTD();
        Test.stopTest();        
    }

    
   
    
}