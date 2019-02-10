public class IssuesActionsCtr {
    
    @AuraEnabled
    public static Map<Id, String> recordtypemap {get;set;}
    
    @AuraEnabled        
    public static Map<Id, String> fetchRecordTypeMap(String objectName){
        List<Schema.RecordTypeInfo> recordtypes = Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfos(); 
        // List<Schema.RecordTypeInfo> recordtypes = Action__c.SObjectType.getDescribe().getRecordTypeInfos(); 
        recordtypemap = new Map<Id, String>();
        for(RecordTypeInfo rt : recordtypes){
            if(rt.getName() != 'Master' && rt.getName().trim() !='')
                recordtypemap.put(rt.getRecordTypeId(), rt.getName());
        }        
        system.debug('recordTypeMap --> ' + recordtypemap);
        return recordtypemap;
    }
    
    @AuraEnabled
    public static List<Issue__c> getRelatedIssue(String intId){
        //Get Today's Issues
        System.debug('enter related Issue--> ' + intId);
        
        Map<String, String> issueId = new Map<String, String>();
        list <Related_Issue__c> relatedIssues = [SELECT Issue__r.Id FROM Related_Issue__c WHERE Case__c = :intId];
        for (Related_Issue__c r :relatedIssues){
            issueId.put(r.Issue__r.Id, r.Issue__r.Id);
        }
        //Caller_Name__r.Name, Caller_Name__c,
        List<Issue__c> issueList = new List<Issue__c>();
        issueList = [SELECT Id, Name, Actions__c, Child_Name__c,  Type_of_Issue__c,  Issue_Contact__c, Status__c, Caller_Name__r.Name, Caller_Name__r.Id,
                     (SELECT  Id, Name, Caller_Name__c, Caller_Name__r.Name, Caller_Name__r.Id, Referral_Contact__c, Referral_Contact__r.Name,
                      Referral_Organization__c, Referral_Organization__r.Id,  Referral_Organization__r.Name, Referral_Follow_up_Date__c,
                      Action_Status__c , Action_Status_Specifics__c, Referral_Date__c, Due_Date__c, Completed_Date__c, Date_On_Referral_Form__c,
                      Action_Detail_Type_Internal_Referral__c, Action_Detail_Type_External_Referral__c, Action_Detail_Type_Information__c,
                      Issues__c, Issues__r.Name, Issue_Type__c, RecordTypeId, RecordType.Name, Organization__c, CreatedBy__c, CreatedById,
                      Material_Type__c
                      FROM Issue__c.Actions__r) 
                     From Issue__c
                     WHERE Id In : issueId.keyset() 
                     LIMIT 50
                    ];
        for(Issue__c i : IssueList){
            for(Action__c a: i.Actions__r){
                
                System.debug('recordType from get issues-->' + a.recordType.name);
                System.debug('Referral_Contact__r.Name from get issues-->' + a.Referral_Contact__r.Name);
                System.debug('CallerName get issues-->' + a.Caller_Name__r.Name);
                System.debug('Action name get issues-->' + a.Referral_Organization__r.Name);
            }
        }
        issueList.sort();
        return issueList;
    }
    
     @AuraEnabled
    public static Map<String, Object> updateActions(List<Action__c> draftValues) {
        Map<String, Object> response = new Map<String, Object>();
        Map<String, Object> errors = validate(draftValues);
        errors.put('error', draftValues[0]);
        if (errors.size() > 0) {
            response.put('code', 'ERROR_SAVING');
            response.put('errors', errors);
            return response;
        }
        
        update draftValues;
        
        response.put('code', 'SUCCESS');
        response.put('errors', errors);
        response.put('message', 'Your changes are saved.');
        
        return response;
    }
    
     private static Map<String, Object> validate(List<Action__c> draftValues) {
        Integer totalErrors = 0;
        Map<String, Object> errors = new Map<String, Object>();
        Map<String, Object> rowsError = new Map<String, Object>();
        
        for (Action__c contact: draftValues) {
            List<String> rowErrorMessages = new List<String>();
            List<String> rowErrorFieldNames = new List<String>();
            rowErrorMessages.add('Error');
            rowErrorFieldNames.add('error');
            
            // TODO FIX QUERY
            if (rowErrorMessages.size() > 0) {
                 Action__c contactWithName = [SELECT Id, Name FROM Action__c WHERE Id = :contact.Id];
                Map<String, Object> rowErrors = new Map<String, Object>();
                
                rowErrors.put('messages', rowErrorMessages);
                rowErrors.put('fieldNames', rowErrorFieldNames);
                //   rowErrors.put('title', contactWithName.Name + ' has ' + rowErrorMessages.size() + ' errors');
                
                totalErrors += rowErrorMessages.size();
                
                // rowsError.put((String) Action__c.Id, rowErrors);
            }
        }
        
        if (totalErrors > 0) {
            Map<String, Object> table = new Map<String, Object>();
            List<String> tableMessages = new List<String>();
            
            for (Object rowError: rowsError.values()) {
                String rowErrorTitle = (String)((Map<String, Object>)rowError).get('title');
                
                tableMessages.add(rowErrorTitle);
            }
            table.put('title', 'Some records have errors');
            table.put('messages', tableMessages);
            errors.put('rows', rowsError);
            errors.put('table', table);
        }
        
        return errors;
    }    
  

}