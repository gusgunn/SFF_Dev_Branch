@IsTest
public class HouseholdCounterBatch_Test {
    public static TestMethod void test() {
        Set<ID> accountIDs = new Set<ID>();
        
        npo02__Household__c a = new npo02__Household__c();
        a.Name = 'Test Account';
        Insert a;
        
        npo02__Household__c a1 = new npo02__Household__c();
        a1.Name = 'Test Account1';
        Insert a1;
        
        Contact cont1 = New Contact();
        cont1.FirstName ='Bobby';
        cont1.LastName ='Master';
        cont1.npo02__Household__c = a.Id;
        insert cont1;
        
        Contact cont = New Contact();
        cont.FirstName ='Bob';
        cont.LastName ='Masters';
        cont.npo02__Household__c = a.Id;
        Insert cont;
        
        Contact cont3 = New Contact();
        cont3.FirstName ='Bobbet';
        cont3.LastName ='Mastersson';
        cont3.npo02__Household__c = a.Id;
        Insert cont3;
        
        accountIDs.add(a.ID);
        accountIDs.add(a1.ID);
        List <npo02__Household__c> UpdateHH = new List <npo02__Household__c>();
    	List <npo02__Household__c> zeroNumber = [Select ID FROM npo02__Household__c];
        for (npo02__Household__c n: zeroNumber){
           n.Number_In_Household__c = NULL;
            
            
            UpdateHH.add(n);
        }
        update UpdateHH;
        Test.startTest();
        
        HouseholdBatchRollup hcb = new HouseholdBatchRollup();
        Id batchId = Database.executeBatch(hcb);
     
      
        Test.stopTest();
       // npo02__Household__c ACC = [select Number_In_Household__c from npo02__Household__c where id = :a.id ];
      // System.assertEquals(ACC.Number_In_Household__c,1);

    }
    
}   
/*
     * @isTest
private class LeadProcessorTest {

    @testSetup 
    static void setup() {
        List<Lead> leads = new List<Lead>();
        //List<Account> accounts = new List<Account>();
        // insert 200 Leads
        for (Integer i=0;i<200;i++) {
            leads.add(new Lead(LastName='Lead '+i, Status ='Open - Not Contacted',
                Company ='York'));
        }
        insert Leads;
        
    }

    static testmethod void test() {        
        Test.startTest();
        LeadProcessor uca = new LeadProcessor();
        Id batchId = Database.executeBatch(uca);
        Test.stopTest();

        // after the testing stops, assert records were updated properly
        System.assertEquals(200, [select count() from Lead ]);
    }*/