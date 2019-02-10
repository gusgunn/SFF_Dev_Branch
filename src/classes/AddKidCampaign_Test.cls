@isTest
public class AddKidCampaign_Test {
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        list<Campaign> InsertCampaigns=new list<Campaign>();   
        Campaign myCampaign = new Campaign (
            Name='Test Tour Registration',
            Type='PPW',
            Status='In Progress',
            Start_Date_Time__c=date.today().addDays(1),
            IsActive=true,
            Maximum_Capacity_Adults__c =100,
            Maximum_Capacity_children__c =100,
            End_Date_Time__c=date.today().addDays(1)
        );
        InsertCampaigns.Add(myCampaign);
        Campaign myCampaign1 = new Campaign (
            Name='Test Tour Registration',
            Type='Workshop',
            Status='In Progress',
            Start_Date_Time__c=date.today(),
            IsActive=true,
            Maximum_Capacity_Adults__c =100,
            Maximum_Capacity_children__c =100,
            End_Date_Time__c=date.today().addDays(1)
        );
        InsertCampaigns.Add(myCampaign1);
        Campaign myCampaign2 = new Campaign (
            Name='Test Tour Registration',
            Type='Clinic',
            Status='In Progress',
            Start_Date_Time__c=date.today(),
            IsActive=true,
            Maximum_Capacity_Adults__c =100,
            Maximum_Capacity_children__c =100,
            End_Date_Time__c=date.today().addDays(1)
        );
        InsertCampaigns.Add(myCampaign2);
        Campaign myCampaign3 = new Campaign (
            Name='Web Request',
            Type='Clinic',
            Status='In Progress',
            Start_Date_Time__c =date.today(),
            IsActive=true,
            Maximum_Capacity_Adults__c =100,
            Maximum_Capacity_children__c =100,
            End_Date_Time__c =date.today().addDays(1)
        );
        
        InsertCampaigns.Add(myCampaign3);
        System.Debug('# OF CAMPAIGNS=  '+ InsertCampaigns.size());
        insert (InsertCampaigns);
        System.debug('myCampaign3ID= ' +  myCampaign3.id);
        
        //Test participant Lead
        Lead myLead=new Lead( FirstName='Nebojsa',
                             LastName='Zgonjaniny',
                             Company='Test Co',
                             Status='Applied',
                             LeadSource='Other', 
                             Email='nzgonjaniny@rogers.com',
                             Country='Canada'
                            );
        insert myLead;
        
        CampaignMember LeadCM = new CampaignMember(CampaignId=myCAmpaign3.Id,
                                                   LeadId=myLead.Id,
                                                   Status='Family Attendee',
                                                   Interpreter_Service_Language__c = 'English',
                                                   Registration_Status__c ='Registered',
                                                   Special_Accommodations_Information__c = 'food');
        insert LeadCM;
        System.debug('my leadCM =' + LeadCM.id);
        
        
        //Test participant Contact
        Contact myContact=new Contact( FirstName='jOE',
                                      LastName='GOYOS',
                                      recordTypeId='012G0000000qhDN'
                                     );
        insert myContact;
        System.debug('my contact =' + myContact);
        CampaignMember ContactCM = new CampaignMember(CampaignId=myCampaign3.Id,
                                                      ContactId=myContact.Id,
                                                      Status='Child Attendee',
                                                      Interpreter_Service_Language__c = 'Spanish',
                                                      Registration_Status__c ='Registered',
                                                      Special_Accommodations_Information__c = 'food');
        //System.debug('ContactCM = ' +  ContactCM);
        insert ContactCM;
        system.debug('contactCM= ' + ContactCM );
        
        // test.startTest();
        PageReference pageRef = new PageReference('/apex/addKidtoCampaigns?pid='+ myContact.Id);
        //PageReference atc = new Page.pageRef();
        Test.setCurrentPage(pageRef);
        system.debug('pageref= ' + pageRef );
        // pageRef.getItems();
        
        
        
        //assert processed records for lead
        addtocampaignKidAttendee controller = new addtocampaignKidAttendee(new ApexPages.StandardController(myCampaign2));
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
                
                
                controller.getLangItems();
                
                
                
                
                controller.Submit();
                controller.GoToParticipant();
                
            }
        }
            pageRef = new PageReference('/apex/addKidtoCampaigns?pid='+myLead.Id);
            //PageReference atc = new Page.pageRef();
            Test.setCurrentPage(pageRef);
            system.debug('pageref= ' + pageRef );
            // pageRef.getItems();
            
            
            
            //assert processed records for lead
            controller = new addtocampaignKidAttendee(new ApexPages.StandardController(myCampaign1));
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
                    
                    
                    controller.getLangItems();
                    
                    
                    
                    
                    controller.Submit();
                    controller.GoToParticipant();
                    
                }
            
            //System.assert(AllSelected); */
            /*  addtocampaigns_Ex controller = new addtocampaigns_Ex(new ApexPages.StandardController());
//test empty selection
//controller.Submit();
//select something
controller.SelectAll();
controller.Submit();
controller.GoToParticipant();*/
            
            
            
            /*    addtocampaigns_Ex controller = new addtocampaigns_Ex(new ApexPages.StandardController(myCampaign3));
//test empty selection
controller.Submit();
//select something
controller.SelectAll();
controller.Submit();
controller.GoToParticipant();
controller.FilterSetting();

//test DMLException 
delete myCampaign3;
controller.Submit();*/
            
            //assert processed records for contact
            /*  controller = new addtocampaigns_Ex(new ApexPages.StandardController(myCampaign3));
//AllSelected=true;
for (addtocampaigns_Wrapper Camp :controller.Campaign_List){
boolean AllSelected=true;
if (Camp.disabled==false){
AllSelected=false;
}

//System.assert(AllSelected);*/
            // test.stopTest();
        }//end of myUnitTest()
    }
}