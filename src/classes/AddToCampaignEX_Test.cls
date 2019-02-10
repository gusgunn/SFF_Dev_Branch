@isTest
public class AddToCampaignEX_Test {
    
    Private static RecordType rtChildcare = [select Id from RecordType where Name = 'Program Campaign' and SobjectType = 'Campaign' LIMIT 1];
    Private static RecordType rtAdultContact = [select Id from RecordType where Name = 'Adult' and SobjectType = 'Contact' LIMIT 1];//Grab all required fields?
    Private static RecordType rtChildContact = [Select Id, Name from RecordType where Name = 'Child/Person With Disability'  and SobjectType = 'Contact' limit 1];
    Private static RecordType actionRT = [SELECT Id, Name FROM recordType WHERE Name = 'Internal Referral' AND sObjectType = 'Action__c' LIMIT 1];
    static date BDate = date.newInstance(2016, 7, 1);
    
    static testMethod void myUnitTest() {
        
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave=true;
        
        list<Campaign> InsertCampaigns=new list<Campaign>();   
        Campaign myCampaign = new Campaign (
            RecordTypeID = rtChildcare.id, Name='Test Registration',
            
            Status='In Progress',
            Start_Date_Time__c=date.today().addDays(17),
            IsActive=true,
            
            Maximum_Capacity_Adults__c =100,
            End_Date_Time__c=date.today().addDays(17)
        );
        InsertCampaigns.Add(myCampaign);
        Campaign myCampaign1 = new Campaign (
            Name='Test Tour Registration',
            RecordTypeID = rtChildcare.id,
            Status='In Progress',
            Start_Date_Time__c=date.today().addDays(17),
            IsActive=true,
            
            Maximum_Capacity_Adults__c =100,
            End_Date_Time__c=date.today().addDays(17)
        );
        InsertCampaigns.Add(myCampaign1);
        Campaign myCampaign2 = new Campaign (
            Name='Test Tour Child',
            RecordTypeID = rtChildcare.id,
            Status='In Progress',
            Start_Date_Time__c=date.today().addDays(17),
            IsActive=true,
            //Maximum_Capacity_Adults__c =100,
            Maximum_Capacity_Adults__c =100,
            End_Date_Time__c=date.today().addDays(17)
        );
        InsertCampaigns.Add(myCampaign2);
        Campaign myCampaign3 = new Campaign (
            Name='Web Request',
            RecordTypeID = rtChildcare.id,
            Status='In Progress',
            Start_Date_Time__c =date.today().addDays(17),
            IsActive=true,
            Maximum_Capacity_Adults__c =100,
            Maximum_Capacity_children__c =100,
            End_Date_Time__c =date.today().addDays(17)
        );
        
        InsertCampaigns.Add(myCampaign3);
        System.Debug('# OF CAMPAIGNS=  '+ InsertCampaigns.size());
        
        database.insert(InsertCampaigns, dml);
        
        
        //Test participant Contact
        Contact myContact=new Contact( FirstName='jOE',
                                      LastName='GOYOS',
                                      Email='JG@rogers.com',
                                      Family__Primary_language__c =''
                                     );
        insert myContact;
        
        //Test participant Contact
        Contact myContact2=new Contact( FirstName='jeb',
                                       LastName='Yoyo',
                                       Email='JG@Yoyo.com',
                                       Family__Primary_language__c ='Spanish'
                                      );
        insert myContact2;
        
        CampaignMember ContactCM = new CampaignMember(CampaignId=myCampaign3.Id,
                                                      ContactId=myContact2.Id,
                                                      Status='Family Attendee',
                                                      //Interpreter_Service_Language__c = 'Spanish',
                                                      Registration_Status__c ='Registered',
                                                      IRC_Food_Preference__c ='Vegetarian',
                                                      IRCNumberChildcare__c =2,
                                                      Request_Childcare__c =True,
                                                      Special_Accommodations_Information__c = 'food');
        //System.debug('ContactCM = ' +  ContactCM);
        insert ContactCM;
        system.debug('contactCM= ' + ContactCM );
        CampaignMember ContactCM2 = new CampaignMember(CampaignId=myCampaign2.Id,
                                                       ContactId=myContact.Id,
                                                       Status='Null',
                                                       Interpreter_Service_Language__c = 'Spanish',
                                                       Registration_Status__c ='Registered',
                                                       Special_Accommodations_Information__c = 'food');
        //System.debug('ContactCM = ' +  ContactCM);
        insert ContactCM2;
        system.debug('contactCM= ' + ContactCM );
        
        // test.startTest();
        PageReference pageRef = new PageReference('/apex/addtocampaigns?pid='+myContact.Id);
        //PageReference atc = new Page.pageRef();
        Test.setCurrentPage(pageRef);
        system.debug('pageref= ' + pageRef );
        // pageRef.getItems();
        
        
        
        //assert processed records for lead
        addtocampaigns_Ex controller = new addtocampaigns_Ex(new ApexPages.StandardController(myCampaign3));
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
        pageRef = new PageReference('/apex/addtocampaigns?pid='+myContact.Id);
        //PageReference atc = new Page.pageRef();
        Test.setCurrentPage(pageRef);
        system.debug('pageref= ' + pageRef );
        // pageRef.getItems();
        
        
        
        //assert processed records for lead
        controller = new addtocampaigns_Ex(new ApexPages.StandardController(myCampaign1));
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