@isTest
public class AddToIRC_Test {
    Private static RecordType rtChildcare = [select Id from RecordType where Name = 'Program Campaign' and SobjectType = 'Campaign' LIMIT 1];
    // Private static RecordType rtConference = [select Id from RecordType where Name = 'Conference/Event Campaign' and SobjectType = 'Campaign' LIMIT 1];
    Private static RecordType rtAdultContact = [select Id from RecordType where Name = 'Adult' and SobjectType = 'Contact' LIMIT 1];//Grab all required fields?
    Private static RecordType rtChildContact = [Select Id, Name from RecordType where Name = 'Child/Person With Disability'  and SobjectType = 'Contact' limit 1];
    Private static RecordType actionRT = [SELECT Id, Name FROM recordType WHERE Name = 'Internal Referral' AND sObjectType = 'Action__c' LIMIT 1];
    static date BDate = date.newInstance(2016, 7, 1);
    
    
    
    
    @testSetup static void createTestRecords() {
        
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave=true;
        
        // TO DO: implement unit test
        list<Campaign> InsertCampaigns=new list<Campaign>();   
        Campaign ACampaign = new Campaign (
            RecordTypeID = rtChildcare.id, Name='ACampaign',
            IRCMain__c = true,
            Status='In Progress',
            Start_Date_Time__c=date.today().addDays(17),
            IsActive=true,
            IRCTotals__c =true,
            Maximum_Capacity_Adults__c =100,
            Session__c='Morning',
            End_Date_Time__c=date.today().addDays(17)
        );
        InsertCampaigns.Add(ACampaign);
        Campaign BCampaign = new Campaign (
            Name='BCampaign',
            RecordTypeID = rtChildcare.id,
            Status='In Progress',
            Start_Date_Time__c=date.today().addDays(17),
            IsActive=true,
            Session__c='Morning',
            Maximum_Capacity_Adults__c =100,
            End_Date_Time__c=date.today().addDays(17)
        );
        InsertCampaigns.Add(BCampaign);
        
        Campaign CCampaign = new Campaign (
            Name='CCampaign',
            RecordTypeID = rtChildcare.id,
            Status='In Progress',
            Start_Date_Time__c=date.today().addDays(17),
            IsActive=true,
            Session__c='Morning',
            Maximum_Capacity_Adults__c =100,
            
            End_Date_Time__c=date.today().addDays(17)
        );
        InsertCampaigns.Add(CCampaign);
        Campaign DCampaign = new Campaign (
            Name='DCampaign',
            RecordTypeID = rtChildcare.id,
            Status='In Progress',
            Start_Date_Time__c =date.today().addDays(17),
            IsActive=true,
            Session__c='Morning',
            Maximum_Capacity_Adults__c =100,
            Maximum_Capacity_children__c =100,
            End_Date_Time__c =date.today().addDays(17)
        );
        
        InsertCampaigns.Add(DCampaign);
        System.Debug('# OF CAMPAIGNS=  '+ InsertCampaigns.size());
        
        database.insert(InsertCampaigns, dml);
        
        
        //Test participant Contact
        Contact myContact=new Contact( FirstName='jOE',
                                      LastName='GOYOS',
                                      Email='JG@rogers.com',
                                      Childcare_Request__c =true,
                                      CCSpotsNumber__c =2,
                                      aChild__c ='iuu',
                                      IRC_FoodChoice__c='Vegetarian',
                                      Family__Primary_language__c =''
                                     );
        insert myContact;
        
        
        
        CampaignMember ContactCM = new CampaignMember(CampaignId=BCampaign.Id,
                                                      ContactId=myContact.Id,
                                                      Status='Family Attendee',
                                                      //Interpreter_Service_Language__c = 'Spanish',
                                                      Registration_Status__c ='Registered',
                                                      IRC_Food_Preference__c ='Vegetarian',
                                                      IRCNumberChildcare__c =2,
                                                      Request_Childcare__c =True,
                                                      Special_Accommodations_Information__c = 'food');
        
        insert ContactCM;
        
    }
    @isTest static void testMethod1() {
        
        List<Campaign> testCampaigns = [Select id FROM Campaign ORDER BY Name] ;     
        Contact con = [SELECT Id From Contact];
        PageReference pageRef = new PageReference('/apex/addtoIRC?pid='+con.Id);
        
        Test.setCurrentPage(pageRef);
        
        // test.startTest();
        addtoIRC controller = new addtoIRC(new ApexPages.StandardController(testCampaigns[3]));
        boolean AllSelected=true;
        for (addtocampaigns_Wrapper Camp :controller.Campaign_List){
            if (Camp.disabled==false){
                AllSelected=false;
                controller.FilterSetting();
                system.debug('filter=' + controller.FilterSetting());
                controller.getCampaign_List();
                controller.SelectAll();
                
                controller.getItems();
                controller.getStatus();
                controller.getSpec();
                controller.getParentphoneNum();
                controller.getInterp();
                
                
                
                
                controller.Submit();
                controller.GoToParticipant();
                
            }
        }
    } 
    @isTest static void testMethod2() {
        
        List<Campaign> testCampaigns = [Select id FROM Campaign ORDER BY Name] ;     
        Contact con = [SELECT Id From Contact];
        PageReference pageRef = new PageReference('/apex/addtoIRC?pid='+con.Id);
        
        Test.setCurrentPage(pageRef);
        
        // test.startTest();
        addtoIRC controller = new addToIRC(new ApexPages.StandardController(testCampaigns[1]));
        boolean AllSelected2=true;
        for (addtocampaigns_Wrapper Camp2 :controller.Campaign_List){
            if (Camp2.disabled==false){
                AllSelected2=false;
                controller.Submit();
                controller.FilterSetting();
                system.debug('filter=' + controller.FilterSetting());
                controller.getCampaign_List();
                controller.SelectAll();
                
                controller.getItems();
                controller.getStatus();
                controller.getSpec();
                
                controller.getParentphoneNum();
                controller.getInterp();
                
                
                
                
                
                controller.Submit();
                controller.GoToParticipant();
                
            }
        } 
    }
    
    
}