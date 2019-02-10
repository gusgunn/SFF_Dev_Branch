public class ResourceGuide {

    @AuraEnabled
    public static List <Account> fetchAvailableValues(String objectName, String searchKeyWord,  String accountName, String issue, String zipCode, String condition) {
        System.debug('issue ' + issue);
        Boolean blankForm = true;
        String sQuery ='SELECT Id, Issue_Type__c, Condition__c, Wheelchair_Accessible__c, Open_Hours__c, RecordTypeId, Name, Website, Phone,  BillingPostalCode FROM Account WHERE Include_in_Resource_Guide__c = TRUE';
        
        if(String.isNotBlank(issue) && issue != NULL && issue !='Select'){
            sQuery += ' AND Issue_Type__c INCLUDES ( \'' + issue + '\')';
            blankForm = false;
            System.debug('issue not blank');
        }
        
        if(String.isNotBlank(condition) && condition != NULL && condition !='Select'){
            sQuery += ' AND Condition__c INCLUDES ( \'' + condition + '\')';
            blankForm = false;
        }
        
        if(String.isNotBlank(searchKeyWord)&& searchKeyWord != NULL && searchKeyWord !='Select'){
            sQuery += ' AND Name LIKE \'' + String.escapeSingleQuotes(searchKeyWord)+'%\''; 
            blankForm = false;
        }
        
        
        if(String.isNotBlank(zipCode) && zipCode != NULL && zipCode !='Select'){
            sQuery += ' AND BillingPostalCode LIKE \''+String.escapeSingleQuotes(zipCode)+'%\'';
            blankForm = false;
        }
        
        String maxRow;
            if(blankForm == true) {       
                maxRow = ' Limit 0';
            } else {
                maxRow= ' Limit 199';
                    }
        sQuery += maxRow;
        List <Account> returnList = new List <Account> ();           
        System.debug('sQuery ' + sQuery);
        List <Account> lstOfRecords = Database.query(sQuery);
        
        for (Account obj: lstOfRecords) {
            returnList.add(obj);
        }
        System.debug('returnList ' + returnList);
        returnList.sort();
        return returnList;
    }
    
    @AuraEnabled
    public static List<String> getIssueTypes(String selectListName){
        List<String> options = new List<String>();
        Schema.sObjectType objType = Account.getSObjectType(); 
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        list<Schema.PicklistEntry> values =
            fieldMap.get(selectListName).getDescribe().getPickListValues();
         options.add('');
        for (Schema.PicklistEntry a : values)
        { 
            options.add( a.getValue()); 
        }
        return options;
    }
    
    
    
}