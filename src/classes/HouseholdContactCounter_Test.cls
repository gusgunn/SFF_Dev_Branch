@isTest

public class HouseholdContactCounter_Test {
    
    
    @istest
    public static void TestInsertSingleHousehold() {
        Test.startTest();
        InsertContacts(1);
        Test.stopTest();
    }
    
    @istest static void TestInsertBulkContact(){
        Long startTime = DateTime.now().getTime();
        Long startCPU = Limits.getCpuTime();
        Test.startTest();
        InsertContacts(100);
        Test.stopTest();
        system.debug('Elapsed: ' + (Datetime.Now().getTime()- startTime));
        system.debug('Elapsed CPU: ' + (Limits.getCpuTime() - startCPU));
    }
    
    
    public static void InsertContacts(Integer count){
        List<Contact> contactsToInsert = new List<Contact>();
        for(Integer x = 0; x<count; x++) {
            String xs = string.valueOf(x);
            contactsToInsert.add(new Contact(FirstName =  xs + 'f' + xs, LastName = xs+ 'l' + xs,
                                             email = xs + 'e' + xs + '@gmail.com'
                                            ));
        }
        insert contactsToInsert;
       
    }
    
    public static void UpdateHouseholdCount() {
       
        List<npo02__Household__c>  households = [SELECT Id, Number_In_Household__c 
                                                 FROM npo02__Household__c
                                                 LIMIT 1
                                                ];
        
        Id bigHousehold = households[0].Id;
        List<Contact> addContactToHousehold = new List<Contact>();
          Test.startTest();
        addContactToHousehold.add(new Contact(FirstName = 'New Household', LastName ='Member',
                                              npo02__Household__c =bigHousehold
                                             ));
        insert addContactToHousehold;
        
        List<npo02__Household__c>  householdCount = [SELECT Id, Number_In_Household__c 
                                                 FROM npo02__Household__c
                                                 WHERE Id =:bigHousehold
                                                ];
        Test.stopTest();
        System.assertEquals(1, householdCount.size());
        System.assertEquals(2, householdCount[0].Number_In_Household__c);
       

        
        
    }   
    
} 


/*
public static TestMethod void test() {

List<Contact> contacts =new List<Contact>();

Contact cont1 = New Contact();
cont1.FirstName ='Bobby';
cont1.LastName ='Master';

contacts.add(cont1);

Contact cont = New Contact();
cont.FirstName ='qweBob';
cont.LastName ='yayiuiiyuMasters';
contacts.add(cont);
insert contacts;

List<npo02__Household__c>  households = [select Id from npo02__Household__c ];
System.assertEquals(2, households.size());
Set<Id> householdIds = new Set<Id>();
for(npo02__Household__c h: households){
householdIds.add(h.Id);
}
HouseHoldMethods.countContacts(householdIds);

Contact cont3 = New Contact();
cont3.FirstName ='nmbhjBobbet';
cont3.LastName ='iu;oiaouiMastersson';
cont3.npo02__Household__c = households[0].Id;
Insert cont3;
List<npo02__Household__c>  NewHouseholds = [select Id from npo02__Household__c ];
Set<Id> updatedhouseholdIds = new Set<Id>();
for(npo02__Household__c h: NewHouseholds){
updatedhouseholdIds.add(h.Id);
}
HouseHoldMethods.countContacts(householdIds);

List<npo02__Household__c> hh = [select Number_In_Household__c from npo02__Household__c where id = :households[0].Id ];
System.assertEquals(2, hh[0].Number_In_Household__c);
System.assertEquals(2, hh.size());
Test.startTest();

Delete cont3;

HouseHoldMethods.countContacts(householdIds);
Test.stopTest();
List<npo02__Household__c> ACC = [select Id, Number_In_Household__c from npo02__Household__c where id = :households[0].Id ];
System.assertEquals(1, ACC[0].Number_In_Household__c);

}



}*/