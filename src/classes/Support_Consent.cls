public with sharing class Support_Consent {
    @AuraEnabled
    public static List<Consent__c> getDatatableData(String soqlFilterId) {
        List<Consent__c> consent = 
            [SELECT Id, Name,  Child__c, Child__r.Name, Child__r.Id, First_Verbal_Consent_date__c, First_Written_Consent_Date__c, Household__c,
             Household__r.Name, Household_Owner__c, Household_Social_Worker__c, Verbal_Consent_Date__c,
             Written_Consent_Date__c, Organization__c, Organization__r.Name, Professional_Contact__c, Professional_Contact__r.Name, Professional_Contact__r.Id
             FROM Consent__c 
             WHERE Household__c =: soqlFilterId
             LIMIT 5];
        return consent;
    }
    
    @AuraEnabled
    public static Map<String, Object> updateDatatable(List<Consent__c> draftValues) {
        system.debug('drafValues In' + draftValues);
        Map<String, Object> response = new Map<String, Object>();
        try {
            System.debug('in try catch');
            update draftValues;
            response.put('code', 'success');
            response.put('message', 'Your changes are saved.');
        } catch (DMLException e) {
            response.put('code', 'error');
            response.put('message', e.getDmlMessage(0));     
        }
        system.debug('response ' +  response);
        return response;
    }
    

}