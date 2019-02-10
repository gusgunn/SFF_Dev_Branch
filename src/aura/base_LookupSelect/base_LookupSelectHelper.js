({
    handleInit : function(component, event, helper) {
        let issue = component.get('v.field');
        var action = component.get('c.getIssueTypes');
        action.setParams({
            'selectListName' : issue
        });
        action.setCallback(this,function(response){
            var opts = [];
        
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                
                
                component.set("v.issueTypes", opts);
                console.log('issueTypes recieved');
               // console.log('v.issueTypes' + component.get("v.issueTypes"));
            }
            else {
                // console.log(error);
            }
        });
        
        $A.enqueueAction(action);
    }, 
    
    handleSelected : function(component, event, selected){
        console.log('id to send: ', component.get("v.selectedValue"));
        var issueTypeName = selected;
        var fieldName = component.get("v.field");
        var cmpEvent = component.getEvent("passIssueType");
        cmpEvent.setParams({
            "stringToPass" : issueTypeName,
            "field" : fieldName
        });
        cmpEvent.fire();
     
        
    },
    
   /* handleSearchIssues : function(component, event, helper){
        var searchissues = component.get("v.selectedValue");
        console.log('selected value--> ', component.get("v.selectedValue"));
    }*/
})