@isTest
public class UpDateHH_Test {
    
    
    public static TestMethod void test(){    
        list<contact> u = new List<contact>();
        list<contact> z = new List<contact>();
        
        Contact c = new Contact(lastname='y');
        
        
        insert c;
        
        
        
        c.dev__c = true;
        update c;
        
        
        
        
        
        
        
        
        
        
        // ContactListSimpleController clsc = new ContactListSimpleController();
        
        /*CampaignCMListController cmlc = new CampaignCMListController();
cmlc.doQuery();
cmlc.Save();*/
        
        ContactListController clc = new ContactListController();
        clc.doQuery();
        clc.Save();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        CampaignCMListController aclc = new CampaignCMListController(sc);
        aclc.doQuery();
        aclc.Save();
    } 
    
}