public with sharing class Ctrl_ResourceDBSearch {

    public String programDescription { get; set; }
    public String zipcode { get; set; }
    public String description { get; set; }
    public String condition { get; set; }
    public List<Account> accounts { get; set; }
    public String nameSearch { get; set; }
    public String category { get; set; }
    
    
    
    public Ctrl_ResourceDBSearch()
    {
        accounts = new List<Account>();
        nameSearch ='';
        category ='';
        programDescription='';
        description='';
        condition='';
        zipcode='';
        
    }
    
    public PageReference searchResources()
    {
        system.debug('========nameSearch======='+nameSearch);
        String searchName = '';
       
        if(nameSearch !=NULL && nameSearch !='') {
            searchName = nameSearch; //default to a wildcard search on name - its fine, we only have 800 resources to look thru
            system.debug('========search Name ======='+searchName);
            
        }
        String searchIssue = NULL;
        if(category !=Null && category!='') searchIssue = category +';';
        system.debug('========searchIssue======='+searchIssue);
        
        accounts = [SELECT Id, npe01__SYSTEM_AccountType__c, Name, Website, Phone, Issue_Type__c
                    FROM Account 
                    
                    WHERE npe01__SYSTEM_AccountType__c!= 'One-to-One Individual'
                    AND (Issue_Type__c Includes (:searchIssue) 
                    AND Name LIKE :('%'+searchName+'%') ) 
                    
                    //Include_in_Resource_Guide__c = TRUE                     
                    //following 2 work but out for testing to find results easier
                    //Issue_Type__c includes (:category) AND
                    
                   ];
        
        System.debug('accounts--> ' + accounts);
        return null;
    }
    
    //by gus - the good one
    public list<SelectOption> getIssueTypes(){
        //SObject obj = Account;
        String fld = 'Issue_Type__c';
        
        list<SelectOption> options = new list<SelectOption>();
        // Get the object type of the SObject.
        Schema.sObjectType objType = Account.getSObjectType(); 
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        // Add these values to the selectoption list.
        for (Schema.PicklistEntry a : values)
        { 
            options.add(new SelectOption(a.getLabel(), a.getValue())); 
        }
        return options;
    }
    
    //by xina - might have problem with "--NONE--"
  
    public list<SelectOption> getConditions(){
        String fld = 'Condition__c';
        
        list<SelectOption> options = new list<SelectOption>();
        // Get the object type of the SObject.
        Schema.sObjectType objType = Account.getSObjectType(); 
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();       
        // Get a map of fields for the SObject
        map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap(); 
        // Get the list of picklist values for this field.
        list<Schema.PicklistEntry> values =
            fieldMap.get(fld).getDescribe().getPickListValues();
        // Add these values to the selectoption list.
        //Start with a None option so they can clear a condition
        options.add(new SelectOption('--NONE--', '--NONE--'));
        for (Schema.PicklistEntry a : values)
        { 
            options.add(new SelectOption(a.getLabel(), a.getValue())); 
        }
        return options;
    }
    
}