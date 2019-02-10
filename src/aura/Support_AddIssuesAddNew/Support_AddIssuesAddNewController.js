({
	 doInit  : function(component, event, helper) {
        console.log('AddNewIssuesDualBos childId> ' + component.get('v.childID'));
        helper.handleInit(component, event, helper);
        
    },
    
    handleDeleteRecord : function(component, event, helper) {
        let records = component.get("v.records");
        const arrayIndex = event.getParam('arrayIndex');
        records.splice(arrayIndex,1);
        component.set('v.records',records);
    },
    
    onCreateNewIssues : function(component, event, helper) {
        var saveNewIssuesList = component.get("v.values");
        if (saveNewIssuesList.length >0){
            var allSelectedList = component.get("v.values");
            var options = component.get("v.options");
            var optionValues =[];
            for (var j = 0; j < options.length; j++) {
                optionValues.push(
                    options[j].label   
                );
            }
            optionValues = optionValues.filter(function(n){ return allSelectedList.indexOf(n)>-1?false:n;});
            var opts =[];
            for (var i = 0; i < optionValues.length; i++) {
                opts.push({
                    label: optionValues[i],
                    value: optionValues[i]
                });
            }
            component.set("v.options", opts );
            component.set("v.values", [] );
            helper.addNewIssues(component, event, helper, saveNewIssuesList);
        } else{
            
             var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "error!",
                    "variant": 'info',
                    "message": "Please select a New Issue type to add"
                });
                toastEvent.fire();
        }
    },
    
    handleChange : function(component, event, helper) {
        console.log('handle Dual list change');
        $A.get('e.force:refreshView').fire();
    }
})