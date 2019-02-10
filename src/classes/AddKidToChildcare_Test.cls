@isTest
public class AddKidToChildcare_Test {
    Private static RecordType rtChildcare = [select Id from RecordType where Name = 'Childcare' and SobjectType = 'Campaign' LIMIT 1];
    Private static RecordType rtAdultContact = [select Id from RecordType where Name = 'Adult' and SobjectType = 'Contact' LIMIT 1];//Grab all required fields?
    Private static RecordType rtChildContact = [Select Id, Name from RecordType where Name = 'Child/Person With Disability'  and SobjectType = 'Contact' limit 1];
    Private static RecordType actionRT = [SELECT Id, Name FROM recordType WHERE Name = 'Internal Referral' AND sObjectType = 'Action__c' LIMIT 1];
    static date BDate = date.newInstance(2016, 7, 1);
    
    static testMethod void myUnitTest() {
        
        Database.DMLOptions dml = new Database.DMLOptions();
        dml.DuplicateRuleHeader.allowSave=true;
        
        // TO DO: implement unit test
        list<Campaign> InsertCampaigns=new list<Campaign>();   
        Campaign myCampaign = new Campaign (
            RecordTypeID = rtChildcare.id, Name='Test Registration',
            
            Status='In Progress',
            Start_Date_Time__c=date.today().addDays(17),
            IsActive=true,
            
            Maximum_Capacity_children__c =100,
            End_Date_Time__c=date.today().addDays(17)
        );
        InsertCampaigns.Add(myCampaign);
        Campaign myCampaign1 = new Campaign (
            Name='Test Tour Registration',
            RecordTypeID = rtChildcare.id,
            Status='In Progress',
            Start_Date_Time__c=date.today().addDays(17),
            IsActive=true,
            
            Maximum_Capacity_children__c =100,
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
            Maximum_Capacity_children__c =100,
            End_Date_Time__c=date.today().addDays(17)
        );
        InsertCampaigns.Add(myCampaign2);
        Campaign myCampaign3 = new Campaign (
            Name='Web Request',
            RecordTypeID = rtChildcare.id,
            Status='In Progress',
            Start_Date_Time__c =date.today().addDays(17),
            IsActive=true,
            //Maximum_Capacity_Adults__c =100,
            Maximum_Capacity_children__c =100,
            End_Date_Time__c =date.today().addDays(17)
        );
        
        InsertCampaigns.Add(myCampaign3);
        System.Debug('# OF CAMPAIGNS=  '+ InsertCampaigns.size());
        
        database.insert(InsertCampaigns, dml);
        
        
        //Test participant Lead
        /*   Lead myLead=new Lead( FirstName='Nebojsa',
LastName='Zgonjaniny',
Company='Test Co',
Status='Applied',
LeadSource='Other', 
Email='nzgonjaniny@rogers.com',
Country='Canada'
);

database.insert(myLead, dml);
CampaignMember LeadCM = new CampaignMember(CampaignId=myCAmpaign3.Id,
LeadId=myLead.Id,
Status='Child',
Interpreter_Service_Language__c = 'English',
Parent_Caregiver__c = myLead.Id,
Registration_Status__c ='Registered',
Special_Accommodations_Information__c = 'food');

database.insert(LeadCM, dml);
System.debug('my leadCM =' + LeadCM.id);*/
        
        
        //Test participant Contact
        Contact myOtherContact=new Contact( FirstName='jOE',
                                           LastName='Nuyen',
                                           
                                           recordTypeId='012G0000000qhDN'
                                          );
        database.insert(myOtherContact, dml);
        Contact myContact=new Contact( FirstName='jOE',
                                      LastName='GOYOS',
                                      Phone = '415324-5432',
                                      recordTypeId='012G0000000qhDN'
                                     );
        database.insert(myContact, dml);
        Contact childTestContact = new Contact(FirstName='Abe' , 
                                               LastName='Becee' , 
                                               RecordTypeID = rtChildContact.Id,
                                               Family__Primary_Language__c = 'Spanish',
                                               Family__Gender__c = 'Female',
                                               Birthdate = BDate,
                                               //schooltype etc
                                               Underserved__c= TRUE,
                                               Low_Income__c= TRUE,
                                               Income__c = 'Homeless',
                                               Housing_Status__c ='Vehicle',
                                               MailingPostalCode = '94124',
                                               lep__c = 'Declined',
                                               Child_requires_1_on_1_care__c = 'Yes',
                                               Childcare_Special_Considerations__c = 'None', 
                                               Childcare_Favorites__c= 'food', 
                                               Childcare_best_way_to_soothe__c ='cuddle',
                                               Food_Allergies__c = 'Yes', 
                                               Food_Allergies_Description__c= 'ds', 
                                               Food_Allergy_Typical_Reactions__c= 'rash',
                                               Describe_type_s_of_seizure_disorder__c='ads', 
                                               Child_has_a_seizure_disorder__c ='Yes',
                                               Childcare_Primary_Contact__c =myContact.id, 
                                               //ChildcarePrimaryContactPhone__c ,
                                               Incarcerated_youth__c = True);
        
        
        database.insert(childTestContact, dml); 
        
        
        Contact childTestContact2 = new Contact(FirstName='ez' , 
                                                LastName='Tree' , 
                                                RecordTypeID = rtChildContact.Id,
                                                Family__Primary_Language__c = 'Spanish',
                                                Family__Gender__c = 'Female',
                                                Birthdate = BDate,
                                                //schooltype etc
                                                Underserved__c= TRUE,
                                                Low_Income__c= TRUE,
                                                Income__c = 'Homeless',
                                                Housing_Status__c ='Vehicle',
                                                MailingPostalCode = '94124',
                                                lep__c = 'Declined',
                                                Child_requires_1_on_1_care__c = 'Yes',
                                                Childcare_Special_Considerations__c = 'None', 
                                                Childcare_Favorites__c= 'food', 
                                                Childcare_best_way_to_soothe__c ='cuddle',
                                                Food_Allergies__c = 'Yes', 
                                                Food_Allergies_Description__c= 'ds', 
                                                Food_Allergy_Typical_Reactions__c= 'rash',
                                                Describe_type_s_of_seizure_disorder__c='ads', 
                                                Child_has_a_seizure_disorder__c ='Yes',
                                                Childcare_Primary_Contact__c =myContact.id, 
                                                Incarcerated_youth__c = True);
        
        
        //database.insert(childTestContact2, dml); 
        // Contacts.add(childTestContact2);
        database.insert(childTestContact2, dml);
        
        CampaignMember ContactCM = new CampaignMember(CampaignId=myCampaign1.Id,
                                                      ContactId=  childTestContact.Id ,
                                                      Status='Child',
                                                      Parent_Caregiver__c =myOtherContact.id,
                                                      Interpreter_Service_Language__c = 'French',
                                                      Child_requires_1_1_support__c = 'yes',
                                                      Special_Accommodations__c =true,
                                                      Interpreter_Service_Required__c = true,
                                                      Special_Accommodations_Information__c = 'food',                                                      
                                                      Registration_Status__c ='Registered'
                                                     );
        
        database.insert(ContactCM, dml);
        CampaignMember ContactCM2 = new CampaignMember(CampaignId=myCampaign2.Id,
                                                       ContactId= childTestContact.id,
                                                       Status='Waitlist Childcare',
                                                       Parent_Caregiver__c =MyContact.Id,
                                                       Interpreter_Service_Required__c =False,
                                                       Interpreter_Service_Language__c =NULL,
                                                       Registration_Status__c ='Registered'
                                                      );
        
        database.insert(ContactCM2, dml);
        
        
        Test.startTest();
        
        PageReference pageRef = new PageReference('/apex/AddKidToChildcareVF?pid='+ childTestContact2.Id);
        //PageReference atc = new Page.pageRef();
        Test.setCurrentPage(pageRef);
        system.debug('pageref= ' + pageRef );
        // pageRef.getItems();
        
        
        
        //assert processed 
        AddKidToChildcare controller = new AddKidToChildcare(new ApexPages.StandardController(myCampaign2));
        boolean AllSelected=true;
        for (addtocampaigns_Wrapper Camp :controller.Campaign_List){
            if (Camp.disabled==false){
                AllSelected=false;
                controller.FilterSetting();
                controller.getCampaign_List();
                controller.SelectAll();
                controller.getItems();
                controller.getStatus();
                controller.getSpec();
                controller.getparentPhoneNum();
                controller.getinterp();
                controller.Submit();
                controller.GoToParticipant();
                
            }
            
        }
        
        PageReference pageRef3 = new PageReference('/apex/AddKidToChildcareVF?pid='+ childTestContact.Id);
        
        Test.setCurrentPage(pageRef3);
        
        
        //assert processed 
        AddKidToChildcare controller3 = new AddKidToChildcare(new ApexPages.StandardController(myCampaign3));//myCampaign3
        boolean AllSelected3=true;
        for (addtocampaigns_Wrapper Camp :controller3.Campaign_List){
            controller3.getCampaign_List();
            if (Camp.disabled==false){
                AllSelected3=false;
                controller3.FilterSetting();
                
                controller3.getItems();
                controller3.getStatus();
                controller3.getSpec();
                
                controller3.getinterp();
                controller3.getParentCaregiver();
                
                controller3.Submit();
                controller3.GoToParticipant();
                
            }
            
        }
        
        
        Try{
            PageReference pageRef2 = new PageReference('/apex/AddKidToChildcareVF?pid='+ myContact.Id);
            
            Test.setCurrentPage(pageRef2);
            
            
            
            
            
            //assert processed records for lead
            AddKidToChildcare controller2 = new AddKidToChildcare(new ApexPages.StandardController(myCampaign1));
            boolean AllSelected2=true;
            for (addtocampaigns_Wrapper Camp :controller2.Campaign_List){
                if (Camp.disabled==false){
                    AllSelected2=false;
                    controller2.FilterSetting();
                    //system.debug('filter=' + controller.FilterSetting());
                    controller2.getCampaign_List();
                    controller.getParentCaregiver();
                    controller2.SelectAll();
                    
                    controller2.getItems();
                    controller2.getStatus();
                    controller2.getSpec();
                    //controller.contactToUpdate();
                    //controller.getcare();
                    controller2.getinterp();
                    // controller2.getParentCaregiver();
                    
                    controller2.Submit();
                    controller2.GoToParticipant();
                    
                }
            }
            
        } catch (DMLException e){
        }
    }
}