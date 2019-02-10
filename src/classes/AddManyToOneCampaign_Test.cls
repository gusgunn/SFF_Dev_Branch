@isTest
public class AddManyToOneCampaign_Test {
    Private static RecordType rtProgram = [select Id from RecordType where Name = 'Program Campaign' and SobjectType = 'Campaign' LIMIT 1];
    Private static RecordType rtAdultContact = [select Id from RecordType where Name = 'Adult' and SobjectType = 'Contact' LIMIT 1];//Grab all required fields?
    Private static RecordType rtChildContact = [Select Id, Name from RecordType where Name = 'Child/Person With Disability'  and SobjectType = 'Contact' limit 1];
    Private static RecordType actionRT = [SELECT Id, Name FROM recordType WHERE Name = 'Internal Referral' AND sObjectType = 'Action__c' LIMIT 1];
    static date BDate = date.newInstance(2016, 7, 1);
    public static String myFullCampaign ='myFullCampaign';
    
    @testSetup static void createTestRecords() {
        
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave = true;
        List <Contact> myContactList = DataForTest.createOnlyContacts(5);
        
        Campaign myCampaign = new Campaign (
            RecordTypeID = rtProgram.id, Name='Test Registration',
            Status='In Progress',
            Start_Date_Time__c=date.today().addDays(17),
            IsActive=true,
            Maximum_Capacity_Adults__c =100,
            End_Date_Time__c=date.today().addDays(17));
        
           Database.insert(myCampaign, dml);
        
        CampaignMember cmb = new CampaignMember();
        cmb.campaignID=myCampaign.id;
        cmb.flag__c =true;
        cmb.contactid = myContactList[0].id;
        cmb.status = 'Family Attendee';
        Database.insert( cmb, dml);
        
         Campaign myFullCampaign = new Campaign (
            RecordTypeID = rtProgram.id, Name='myFullCampaign',
            Status='In Progress',
            Start_Date_Time__c=date.today().addDays(17),
            IsActive=true,
            Maximum_Capacity_Adults__c =0,
             Maximum_Capacity_Children__c=0,
             
            End_Date_Time__c=date.today().addDays(17));
        
       Database.insert(myFullCampaign, dml);
        
        
        
    }
    @isTest static void testMethod1() {
        List<Contact> myContactList = [SELECT ID, Name, recordTypeID, Family__Primary_language__c
                                       FROM Contact
                                       LIMIT 5];
        Campaign myCampaign = [SELECT ID
                               FROM Campaign
                               LIMIT 1];
        
        Test.startTest();
        PageReference pageRef = new PageReference('/apex/addManyNewVF?pid='+myCampaign.Id);
        Test.setCurrentPage(pageRef);
        AddManyAlphaTemplate controller = new AddManyAlphaTemplate(new ApexPages.StandardController(myContactList[2]));
        // controller.searchString='';
        
        for (Wrapper Camp :controller.ContactList){
            if (Camp.disabled==false){
                controller.getItems();
                controller.getCampaignDetails(); //2
                controller.getCurrentCMS(); //3
                controller.AlphaFilter = 'ALL';
                controller.BuildQuery();
                
                controller.last();
                controller.first();
                controller.cancel();
                
            }
            camp.aCheckBox = true;
            
            //controller.DoSomethingOne();
            controller.Submit();
            
        }
        Test.stopTest();
    }
    @isTest static void testMethod2() {
        List<Contact> myContactList = [SELECT ID, Name, recordTypeID, Family__Primary_language__c
                                       FROM Contact
                                       LIMIT 5];
        Campaign myCampaign = [SELECT ID
                               FROM Campaign
                               LIMIT 1];
        
        Test.startTest();
        PageReference pageRef = new PageReference('/apex/addManyNewVF?pid='+myCampaign.Id);
        Test.setCurrentPage(pageRef);
        AddManyAlphaTemplate controller = new AddManyAlphaTemplate(new ApexPages.StandardController(myContactList[2]));
        
        controller.getCampaignDetails(); //2
        controller.getCurrentCMS(); //3
        controller.BuildQuery(); //
        controller.getItems();
        
        controller.getCurrentContactList();
        controller.SortToggle();
        controller.BuildWhere('c', 'Te');
        for (Wrapper Camp :controller.ContactList){
            
            if (Camp.disabled==false){
                controller.getItems();
                controller.getCampaignDetails(); //2
                controller.getCurrentCMS(); //3
                controller.AlphaFilter = 'Other';
                controller.BuildQuery();
                camp.aCheckBox=true;
                //camp.aInterp=true;
                camp.aSpecial='yes';
                camp.status=null;
                
            }
        }
        controller.Submit();
        
        Test.stopTest();
    }
    @isTest static void testMethodContactUpdateFail() {
        List<Contact> myContactList = [SELECT ID, Name, recordTypeID, Family__Primary_language__c
                                       FROM Contact
                                       LIMIT 5];
        Campaign myCampaign = [SELECT ID
                               FROM Campaign
                               LIMIT 1];
        
        Test.startTest();
        PageReference pageRef = new PageReference('/apex/addManyNewVF?pid='+myCampaign.Id);
        Test.setCurrentPage(pageRef);
        AddManyAlphaTemplate controller = new AddManyAlphaTemplate(new ApexPages.StandardController(myContactList[2]));
        controller.getItems();
                controller.getCampaignDetails(); //2
                controller.getCurrentCMS(); //3
                controller.AlphaFilter = 'ALL';
                controller.BuildQuery();

        controller.getItems();
        
        controller.getCurrentContactList();
        controller.SortToggle();
        controller.BuildWhere('c', 'Te');
        for (Wrapper Camp :controller.ContactList){
            
            if (Camp.disabled==false){
                
                camp.aCheckBox=true;
                //camp.aInterp=true;
                camp.aSpecial='yes';
                camp.status='FAmily Attendee';
                camp.aContact.Family__Primary_Language__c ='Eph';
                
            }
        }
        controller.Submit();
        
        Test.stopTest();
    }
    @isTest static void testMethod3() {
        List<Contact> myContactList = [SELECT ID, Name, recordTypeID, Family__Primary_language__c
                                       FROM Contact
                                       LIMIT 5];
        Campaign myCampaign = [SELECT ID
                               FROM Campaign
                               LIMIT 1];
        
        Test.startTest();
        PageReference pageRef = new PageReference('/apex/addManyNewVF?pid='+myCampaign.Id);
        Test.setCurrentPage(pageRef);
        AddManyAlphaTemplate controller = new AddManyAlphaTemplate(new ApexPages.StandardController(myContactList[2]));
        

        controller.getCampaignDetails(); //2
        controller.getCurrentCMS(); //3
        controller.BuildQuery(); //
        controller.getItems();
        
        controller.getCurrentContactList();
        controller.SortToggle();
        controller.SortToggle();
        controller.BuildWhere('c', 'Te');
        controller.SearchContact();
        controller.UpdateContactSelectedSet();
        controller.getLastOnPage();
        controller.getPageTotal(); 
        
        for (Wrapper Camp :controller.ContactList){
            
            if (Camp.disabled==false){
                
                camp.aCheckBox=true;
                //camp.aContact.Family__Primary_Language__c ='English';
                //camp.aInterp=true;
               // camp.aSpecial='yes';
                camp.status='Child Attendee';
                
            }
        }
        controller.Submit();
        Test.stopTest();
        
    }
     @isTest static void testMethodFullCampaign() {
        List<Contact> myContactList = [SELECT ID, Name, recordTypeID, Family__Primary_language__c
                                       FROM Contact
                                       LIMIT 5];
        Campaign myCampaign = [SELECT ID, Name
                               FROM Campaign
                               WHERE name = 'myFullCampaign'
                               LIMIT 1];
        
        Test.startTest();
        PageReference pageRef = new PageReference('/apex/addManyNewVF?pid='+myCampaign.Id);
        Test.setCurrentPage(pageRef);
        AddManyAlphaTemplate controller = new AddManyAlphaTemplate(new ApexPages.StandardController(myContactList[2]));
        

        controller.getCampaignDetails(); //2
        controller.getCurrentCMS(); //3
        controller.BuildQuery(); //
        controller.getItems();
        
        controller.getCurrentContactList();
        controller.SortToggle();
        controller.SortToggle();
        controller.BuildWhere('c', 'Te');
        controller.SearchContact();
        for (Wrapper Camp :controller.ContactList){
            
            if (Camp.disabled==false){
                
                camp.aCheckBox=true;
                camp.aContact.Family__Primary_Language__c ='English';
                camp.aInterp=true;
                camp.aSpecial='yes';
                camp.status='Adult Attendee';
                
            }
        }
        controller.Submit();
        Test.stopTest();
        
    }
    @isTest static void testMethod4() {
        List<Contact> myContactList = [SELECT ID, Name, recordTypeID, Family__Primary_language__c
                                       FROM Contact
                                       LIMIT 5];
        Campaign myCampaign = [SELECT ID
                               FROM Campaign
                               LIMIT 1];
        Test.startTest();
        PageReference pageRef = new PageReference('/apex/addManyNewVF?pid='+myCampaign.Id);
        Test.setCurrentPage(pageRef);
        AddManyAlphaTemplate controller = new AddManyAlphaTemplate(new ApexPages.StandardController(myContactList[2]));
        // AddManyAlphaTemplate StSetcontroller = new AddManyAlphaTemplate(new ApexPages.StandardSetController(myContactList));
    
        controller.getCampaignDetails(); //2
        controller.getCurrentCMS(); //3
        controller.BuildQuery(); //
        controller.getItems();
        
        controller.getCurrentContactList();
        controller.SortToggle();
        controller.BuildWhere('c', 'Te');
        controller.getReccount();
        
        
        for (Wrapper Camp :controller.ContactList){
            
            if (Camp.disabled==false){
                
                camp.aCheckBox=true;
               camp.aContact.Family__Primary_Language__c ='English';
                camp.aInterp=true;
                camp.aSpecial='yes';
                camp.status='Family Attendee';
                
            }
        }
        controller.Submit();
        
        Test.stopTest();
        
        
        // Test Wrapper
        // Wrapper w = new Wrapper();
        Wrapper w2 = new Wrapper(1,myContactList[2], true);
        
        
        //System.assertEquals(w2.camp.name,'Test1');
        //System.assertEquals(w2.aCheckBox,false);
        
    }
}