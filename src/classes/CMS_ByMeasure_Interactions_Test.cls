@isTest
public class CMS_ByMeasure_Interactions_Test {

    @testSetup static void createTestRecords() {
    	TestFactory.createCasesFor1Child(4);
        List<Contact> c = [SELECT Id FROM Contact];
        Contact  adult = [SELECT Id, npo02__Household__c FROM Contact WHERE RecordTypeID =: TestFactory.rtAdultContact.Id  Limit 1];
        Contact  child = [SELECT Id, npo02__Household__c FROM Contact WHERE RecordTypeID =: TestFactory.rtChildContact.Id Limit 1];
        System.assertEquals(2, c.size());
        List<Case> cases = new List<Case>();
        Integer m =0;
        String quarter;
        for (Integer caseCount=1;caseCount<13;caseCount++) {
            if(m>2){
                m=1;
             
            }Else{
                 
                m++;
            }

            cases.add(new Case(ContactId = adult.Id,
                                   Call_Type__c = TestFactory.CaseCallTypeMap.get(m), 
                                   Origin = 'In-person',
                                   Status = 'Closed',
                                   Family__Household__c = child.npo02__Household__c,
                                   Start_time__c = TestFactory.Q1.addMonths(caseCount),
                                   Add_5_Mins_to_Start_Time_For_End_Time__c = 5,
                                   Family__Child__c = child.ID,
                                   RecordTypeId = TestFactory.rtFamilyInteraction.id));    
        }
        insert cases;
        System.assertEquals(12, cases.size());
        }
        
   @isTest static void testQ1() {
        Test.startTest();
        List<Contact> contacts = [SELECT Id FROM Contact];
        List<Case> cases = [SELECT Id, Start_time__c FROM Case];
     
        System.assertEquals(7, cases[1].Start_time__c.month());
        System.assertEquals(2, contacts.size());
        System.assertEquals(16, cases.size());
        //TestFactory.createCasesFor1Child(4);
        PageReference VFpage = Page.CMS_ByMeasure_Interactions_VF;
        Test.setCurrentPage(VFpage);
        CMS_ByMeasure_Interactions p = new CMS_ByMeasure_Interactions();
        date testDateTo = date.newInstance(2017, 9, 30 );
        date testDateFrom = date.newInstance(2017, 7, 1 ); 
        p.datefrom = testDateFrom;
        p.dateTo = testDateTo;
        System.AssertEquals(p.dateFrom, testDateFrom);
        System.AssertEquals(p.dateTo, testDateTo); 
        p.startGenerateBoard(); 
        p.getInteractionCounts();
        Test.stopTest();       
    }
    
     @isTest static void testQ2() {
        Test.startTest();
        PageReference VFpage = Page.CMS_ByMeasure_Interactions_VF;
        Test.setCurrentPage(VFpage);
        CMS_ByMeasure_Interactions p = new CMS_ByMeasure_Interactions();
        Date testDateTo = date.newInstance(2017, 12, 31 );
        Date testDateFrom = date.newInstance(2017, 7, 1 ); 
        p.datefrom = testDateFrom;
        p.dateTo = testDateTo;
        p.startGenerateBoard(); 
        p.getInteractionCounts();
        Test.stopTest(); 
        }
    
      @isTest static void testQ3() {
        Test.startTest();
        PageReference VFpage = Page.CMS_ByMeasure_Interactions_VF;
        Test.setCurrentPage(VFpage);
        CMS_ByMeasure_Interactions p = new CMS_ByMeasure_Interactions();
        Date testDateTo = date.newInstance(2018, 3, 31 );
        Date testDateFrom = date.newInstance(2017, 7, 1 ); 
        p.datefrom = testDateFrom;
        p.dateTo = testDateTo;
        p.startGenerateBoard(); 
        p.getInteractionCounts();
        Test.stopTest(); 
        }
    @isTest static void testQ4() {
        Test.startTest();
        PageReference VFpage = Page.CMS_ByMeasure_Interactions_VF;
        Test.setCurrentPage(VFpage);
        CMS_ByMeasure_Interactions p = new CMS_ByMeasure_Interactions();
        Date testDateTo = date.newInstance(2018, 6, 30 );
        Date testDateFrom = date.newInstance(2017, 7, 1 ); 
        p.datefrom = testDateFrom;
        p.dateTo = testDateTo;
        p.startGenerateBoard(); 
        p.getInteractionCounts();
        Test.stopTest(); 
        }
        @isTest static void testNulldate() {
        Test.startTest();
        PageReference VFpage = Page.CMS_ByMeasure_Interactions_VF;
        Test.setCurrentPage(VFpage);
        CMS_ByMeasure_Interactions p = new CMS_ByMeasure_Interactions();
        Date testDateTo = date.newInstance(2017, 12, 31 );
        Date testDateFrom = date.newInstance(2017, 7, 1 ); 
        p.datefrom = testDateFrom;
        p.dateTo = Null;
        p.startGenerateBoard(); 
        p.getInteractionCounts();
        Test.stopTest(); 
        }
     @isTest static void testBeginDateAfterEndDate() {
        Test.startTest();
        PageReference VFpage = Page.CMS_ByMeasure_Interactions_VF;
        Test.setCurrentPage(VFpage);
        CMS_ByMeasure_Interactions p = new CMS_ByMeasure_Interactions();
        Date testDateTo = date.newInstance(2016, 12, 31 );
        Date testDateFrom = date.newInstance(2018, 7, 1 ); 
        p.datefrom = testDateFrom;
        p.dateTo = testDateTo;
        p.startGenerateBoard(); 
        p.getInteractionCounts();
        Test.stopTest(); 
        }
}