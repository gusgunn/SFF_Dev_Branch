/**
* Created by gus on 2/24/2018.
*/

@istest
public class CloneCampaignTest {
    
    static private Integer numAccts = 3;
    static private Integer numContactsPerAcct = 3;
    static date beginDate = date.newInstance(2016, 7, 1);
    static date endDate = date.newInstance(2016, 12, 31);
    Static  DateTime myDateC = DateTime.newInstance(2017, 9, 30, 8,3, 5);
    
    @testSetup static void createTestRecords() {
        RecordType rt1 = [Select Id, Name from RecordType where Name = 'Program Campaign' limit 1];
        //RecordType rt2 = [Select Id, Name from RecordType where Name = 'Default' limit 1];
        
        
        
        
        
    }
    
    @isTest static void testMethod1() {
        Campaign c = new Campaign (
            Name='Test Tour Registration',
            Type='PPW',
            Status='In Progress',
            Start_Date_Time__c=date.today(),
            End_Date_Time__c=date.today().addDays(1),
            CampaignRecordType__c = 'Program',
            SeriesName__c ='newevent',
            Repeats__c =52,
            Maximum_Capacity_Adults__c =100,
            Maximum_Capacity_children__c =100
        );
        
        insert c;
        
        Test.startTest();
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        ApexPages.currentPage().getParameters().put('pid', c.id);
        campaignClone pcp = new campaignClone(sc);
        PageReference tpageRef = Page.campaignClone;
        
        Campaign myCAmpaign = (campaign)sc.getRecord();
        
        
        pcp.CloneTemplate();
        pcp.CloneTemplateToCreateForm();
        
        pcp.doClone();
        
        test.stopTest();
        
        Integer testresults = [Select count() from Campaign  ];
        System.AssertEquals(53,testresults);
        system.debug(testresults + ' testresults');
        
        List<Campaign> testresultsSize = [Select id from Campaign  ];
        System.AssertEquals(53,testresultsSize.size());
        system.debug('testresultsSize' +testresultsSize.size());
        
        
    }
    
    
    @isTest static void testMethod2() {
        Campaign c = new Campaign (
            Name='Test Tour Registration',
            Type='PPW',
            Status='In Progress',
            Start_Date_Time__c=date.today(),
            End_Date_Time__c=date.today().addDays(1),
            CampaignRecordType__c = 'Childcare',
            SeriesName__c ='newevent',
            Repeats__c =52,
            Maximum_Capacity_Adults__c =100,
            Maximum_Capacity_children__c =100
        );
        
        insert c;
        
        Test.startTest();
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        ApexPages.currentPage().getParameters().put('pid', c.id);
        campaignClone pcp = new campaignClone(sc);
        PageReference tpageRef = Page.campaignCloneChildcare;
        
        Campaign myCAmpaign = (campaign)sc.getRecord();
        
        
        pcp.cloneChildcareTemplate();
        pcp.CloneTemplateToCreateForm();
        
        pcp.doClone();
        
        test.stopTest();
        
        Integer testresults = [Select count() from Campaign  ];
        System.AssertEquals(2, testresults,  ' testresults should = 2');
      
    }
}