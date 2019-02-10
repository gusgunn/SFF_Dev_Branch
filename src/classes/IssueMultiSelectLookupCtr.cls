/**
* Created by gus on 2/21/2018.
*/

public class IssueMultiSelectLookupCtr {
    
    @AuraEnabled
    public static List < String > fetchAlreadyOpen( String objectName,  String kidId, String intId, String conId) {
         if(String.isBlank(kidId)){
            kidId = conId;   
        }
        System.debug('in fetchAlreadyOpen. objectName-->' + objectName);
        String fieldname = 'Type_Of_Issue__c';
        Map<String, String> unavailableIssueTypes = new Map<String, String>();
        List < String > returnList = new List < String > ();
        String closed = 'Closed';
        List < Issue__c > lstOfRecords = [Select Type_Of_Issue__c from Issue__c where  Issue_Contact__c =: kidId AND isClosed__c = false order by createdDate DESC ];
        for (Issue__c obj: lstOfRecords) {
            unavailableIssueTypes.put(obj.Type_Of_Issue__c, obj.Type_Of_Issue__c);
            
        }
        
        System.debug('IssueMultiSelectController FetchalreadyOpenIssues openIssuesList --> ' + unavailableIssueTypes);
        returnList = getNewIssueTypes(fieldname , unavailableIssueTypes); 
        returnList.sort();
        System.debug('IssueMultiSelectController FetchalreadyOpenIssues returnList --> ' + returnList);
        return returnList;
    }
    
    @AuraEnabled
    public static List <String> getNewIssueTypes( string fld, Map<String, String> unavailableIssueTypes  ) {
        sObject objectName = new Issue__c();
        List <String> allOpts = new List <String> ();
        Schema.sObjectType objType = objectName.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
        list < Schema.PicklistEntry > values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        for (Schema.PicklistEntry a: values) {
            String type = a.getValue();
            if( !unavailableIssueTypes.containsKey(a.getValue())) {
                allOpts.add(a.getValue());
            }
        }
        system.debug('allOpts ---->' + allOpts);
        return allOpts;
    }
    
    @AuraEnabled
    public static List < sObject > fetchAvailableValues(String searchKeyWord, String objectName, String kidId, String intId) {
        
        List<String> excludedRelatedIssues = getAlreadyRelated(intId);
        String searchKey = '%' + searchKeyWord + '%';
        List < sObject > returnList = new List < sObject > ();
        
        String sQuery =  'select Id, name, Type_Of_Issue__c, isClosed__c from ' + objectName + ' where Name LIKE: searchKey AND isClosed__c = false  AND Id NOT IN : excludedRelatedIssues AND Issue_Contact__c =: kidId order by createdDate DESC limit 15';
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        returnList.sort();
        return returnList;
    }
    
    @AuraEnabled
    public static list <Related_Issue__c> getAlreadyRelatedName(String intId){
        List <Related_Issue__c> related = new List<Related_Issue__c>();
        System.debug('intId ' + intId);
        list <Related_Issue__c> relatedIssues = [SELECT Id, Name, Issue__r.Name, Issue__c, Date__c, Issue_Contact__c, Details__c FROM Related_Issue__c WHERE Case__c = : intId];
        return relatedIssues;   
    }
    
    @AuraEnabled
    public static list <String> getAlreadyRelated(String intIds){
        List <String> related = new List<String>();
        list <Related_Issue__c> relatedIssues = [SELECT Issue__r.Id FROM Related_Issue__c WHERE Case__c = : intIds];
        for (Related_Issue__c r :relatedIssues){
            related.add(r.Issue__r.Id);
        }
        return related;   
    }
    
    @AuraEnabled
    public static List<Issue__c> getIssues(List<sObject> excludeItemsList, String kidId) {
       // List<String> excludedRelatedIssues = getAlreadyRelated(intId);
        System.debug('excludeItemsList =' + excludeItemsList);
        System.debug('Child =' + kidId);
        List<Issue__c> totalList = new List<Issue__c>();
        List<string> lstExcludeItems = new List<string>();
        for(sObject item : excludeItemsList ){
            lstExcludeItems.add(item.id);
        }
        String closed ='Closed';
        for(Issue__c cc : [SELECT id, Type_of_Issue__c  from Issue__c where Id NOT IN : lstExcludeItems AND Issue_Contact__c =: kidId AND isClosed__c = false order by createdDate DESC ]){
            totalList.add(cc);
        }
        return totalList;
    }
    
    @AuraEnabled
    public static List<Issue__c> getOpenIssues(String kidId, String intId, String conId) {
        
        System.debug('Child =' + kidId);
         if(String.isBlank(kidId)){
            kidId = conId;   
        }
        List<String> excludedRelatedIssues = getAlreadyRelated(intId);
        List<Issue__c> totalList = new List<Issue__c>();
        
        String closed ='Closed';
        List<Issue__c> cc = [SELECT Id, Name from Issue__c where  Issue_Contact__c =: kidId  AND Id NOT IN : excludedRelatedIssues AND isClosed__c = false order by createdDate DESC ];
        cc.sort();
        return cc;
    }
    
    
    @AuraEnabled
    public static List<Issue__c> addNewIssues(String intId, String conId, String kidId, List<String> lstOfIssueNamesSelected, String fld){
        System.debug('conId=' + conId);
        System.debug('kidId=' + kidId);
        System.debug('IntId =' + intId);
        System.debug('lstOfIssueNamesSelected =' + lstOfIssueNamesSelected);
        Date myDate = date.today();
        if(String.isBlank(kidId)){
            kidId = conId;   
        }
        list<Issue__c> lstOfNewIssues = new list<Issue__c>();
        for(String sIssueName : LstOfIssueNamesSelected){
            Issue__c oIssue = new Issue__c();
            oIssue.Type_of_Issue__c = sIssueName;
            oIssue.Interaction_Log__c = intId;
            oIssue.Caller_Name__c = conId;
            oIssue.Issue_Contact__c = kidId;
            oIssue.Opened_Date__c =  myDate;
            oIssue.Status__c =  'New';
            lstOfNewIssues.add(oIssue);
            System.debug('lstOfIssueNamesSelected =' + LstOfIssueNamesSelected);
        }
        Insert lstOfNewIssues;
        List<String> LstOfIssueIds = new List<String>();
        for(Issue__c i : LstOfNewIssues){
            LstOfIssueIds.add(i.Id);
        }
        addRelatedIssues(intId, lstOfIssueIds, conId);
        System.debug('lstOfNewIssues =' + lstOfNewIssues[0].Id);
        
        return lstOfNewIssues;
    }
    
    
    
    @AuraEnabled
    public static List<Related_Issue__c> addRelatedIssues(String intId, List<String> lstOfIssueIds, String conId){
        System.debug('intId =' + intId);
        System.debug('conId =' + conId);
        System.debug('lstOfIssueIds =' + lstOfIssueIds);
        System.debug('Pass conId to next step!!conId =' + conId);
        Date myDate = date.today();
        list<Related_Issue__c> lstOfRelatedIssues = new list<Related_Issue__c>();
        for(String sIssueId : lstOfIssueIds){
            Related_Issue__c oRelatedIssue = new Related_Issue__c();
            oRelatedIssue.Issue__c = sIssueId;
            oRelatedIssue.Case__c = intId;
            oRelatedIssue.Date__c =  myDate;
            lstOfRelatedIssues.add(oRelatedIssue);
            // System.debug('lstOfRelatedIssues =' + lstOfRelatedIssues);
        }
        Insert lstOfRelatedIssues;
        System.debug('lstOfRelatedIssues1 =' + lstOfRelatedIssues[0].Id);
        return lstOfRelatedIssues;
    }
    
}