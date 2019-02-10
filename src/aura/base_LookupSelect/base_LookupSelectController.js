({
    doInit : function(component, event, helper) {
           
        helper.handleInit(component, event, helper);
    },
    
    onSelected : function(component, event, helper) {
        var selected =  component.find('issuePicked').get("v.value");
        component.set("v.selectedValue", selected);
        console.log('handleselected value--> ', component.get("v.selectedValue"));
        helper.handleSelected(component, event, selected);
    },
    
    onSearch : function(component, event, helper){
        helper.handleSearchIssues(component, event, helper);
        
    },
    
    onReset : function(component, event, helper){
        component.set('v.issueTypes', [] );
        helper.handleInit(component, event, helper);
        var selected =''
        component.set('v.selectedValue', '');
        helper.handleSelected(component, event, selected);
    },
    
    onSubmit : function(component, event, helper){
        console.log('id to send ', component.get("v.selectedValue"));
        var issueTypeName = component.get("v.selectedValue");
        var fieldName = component.get("v.field");
        var cmpEvent = component.getEvent("passIssueType");
        cmpEvent.setParams({
            "stringToPass" : issueTypeName,
            "field" : fieldName
        });
        cmpEvent.fire();
     
    },
    
   /* onNewissue : function(component, event, helper) {
        var createNewissueType =  $A.get("e.force:createRecord");
        
        createNewissueType.setParams({ "entityApiName" : "issue__c",
                                     "defaultFieldValues": {
                                         'issueType__c' : component.get('v.selectedValue')
                                     }
                                    });
        
        createNewissueType.fire();	
    },*/
    
    
    
})