@IsTest
 
public class HouseholdCounter_Test {
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
        cont.npo02__Household__c = a1.Id;
        Insert cont;
        
        Contact cont3 = New Contact();
        cont3.FirstName ='Bobbet';
        cont3.LastName ='Mastersson';
        cont3.npo02__Household__c = a.Id;
        Insert cont3;
        
        accountIDs.add(a.ID);
        accountIDs.add(a1.ID);
    
        Test.startTest();
        
        cont1.npo02__Household__c = a1.Id;
        HouseHoldMethods.countContacts(accountIDs);
        
        Update cont1;
        
        Delete cont3;
      
        Test.stopTest();
       // npo02__Household__c ACC = [select Number_In_Household__c from npo02__Household__c where id = :a.id ];
      // System.assertEquals(ACC.Number_In_Household__c,1);

    }
    
    
    
}