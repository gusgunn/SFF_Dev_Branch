@isTest

public class HouseholdContactCounter_Test {
    
    
    
    @testSetup static void InsertContacts(){
        List<SObject> aList = Test.loadData(npo02__Household__c.sObjectType,'Households');
        
        List<npo02__Household__c> householdList= [SELECT Id, Name, Number_In_Household__c FROM npo02__Household__c  WHERE Name='OneHouse'];
        system.assertEquals(20, householdList[0].Number_In_Household__c);   
        
        List<SObject> cList = Test.loadData(Contact.sObjectType,'Contacts');
        system.assertEquals(4, aList.size());
        system.assertEquals(4, cList.size());
     
        
    }
    
    @isTest
    public static void householdCountAfterOneContactInserted() {
        Test.startTest();    
        List<npo02__Household__c> updatedHouseholdList= [SELECT Id, Name, Number_In_Household__c FROM npo02__Household__c  WHERE Name='OneHouse'];
        system.assertEquals(1, updatedHouseholdList[0].Number_In_Household__c); 
        Test.stopTest();
     
    }  
    
    public static void InsertContacts(Integer count){
        List<npo02__Household__c> householdList= [SELECT Id, Name, Number_In_Household__c FROM npo02__Household__c  WHERE Name='OneHouse'];
        system.assertEquals(1, householdList[0].Number_In_Household__c); 
        String contactHousehold = householdList[0].Id;
        List<Contact> contactsToInsert = new List<Contact>();
        for(Integer x = 0; x<count; x++) {
            String xs = string.valueOf(x);
            contactsToInsert.add(new Contact(FirstName =  xs + 'f' + xs, LastName = xs+ 'l' + xs,
                                             npo02__Household__c=contactHousehold
                                            ));
        }
        insert contactsToInsert;
    }

    
    @istest static void TestInsertBulkContact(){
        Long startTime = DateTime.now().getTime();
        Long startCPU = Limits.getCpuTime();
        Test.startTest();
        InsertContacts(100);
        Test.stopTest();
        system.debug('Elapsed: ' + (Datetime.Now().getTime()- startTime));
        system.debug('Elapsed CPU: ' + (Limits.getCpuTime() - startCPU));
        
        List<Contact> contacts= [SELECT Id, npo02__Household__c,npo02__Household__r.Name FROM Contact WHERE npo02__Household__r.Name='OneHouse' ];
        system.assertEquals(101, contacts.Size());  
    }
    
}