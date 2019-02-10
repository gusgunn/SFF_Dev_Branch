@isTest
public class service_Picklist_RecordTypeSelector_Test {

    static testMethod void getRecordTypeMap_should_work() {
        Test.startTest();
        Map<Id, String> entries = service_Picklist_RecordTypeSelector.getRecordTypeMap('Account');
        Test.stopTest();
        System.assert(entries.size() > 0);
        System.debug('entries');
   
    } 
    
    static testMethod void getRecordTypeMap_should_fail_when_invalid_objectName() {
        Test.startTest();
        try {
            service_Picklist_RecordTypeSelector.getRecordTypeMap('xyq__c');
            System.assert(false, 'Exception was expected');
        } catch (Exception e) {
            System.assert(e instanceof AuraHandledException);
        }
        Test.stopTest();
    }
    
     static testMethod void getRecordTypeMap_should_fail_when_null_objectName() {
        Test.startTest();
        try {
            service_Picklist_RecordTypeSelector.getRecordTypeMap('  ');
            System.assert(false, 'Exception was expected');
        } catch (Exception e) {
            System.assert(e instanceof AuraHandledException);
        }
        Test.stopTest();
    }
    
}