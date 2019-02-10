({
    doInit  : function(component, event, helper) {
        helper.handleInit(component, event, helper); 
    },
    
    handleDeleteRecord : function(component, event, helper) {
        let records = component.get("v.records");
        const arrayIndex = event.getParam('arrayIndex');
        records.splice(arrayIndex,1);
        component.set('v.records',records);
    },

    
    handleChange: function (component, event) {
        var selectedOptionsList = event.getParam("value");
        component.set("v.selectedArray", selectedOptionsList);
        
    },
    
    handleTodaysOpenIssues : function(component, event, helper) {
	    var saveNewIssuesList = component.get("v.values");
        var allSelectedList = component.get("v.values");
        var optionValues = component.get("v.options");
        if (saveNewIssuesList.length >0){
            optionValues = optionValues.filter(function(n){ return allSelectedList.indexOf(n.value)>-1?false:n;});
         
            component.set("v.options", optionValues );
            component.set("v.values", [] );
            helper.addRelatedIssues(component, event, helper, saveNewIssuesList);
         } else{
            
             var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "error!",
                    "variant": 'info',
                    "message": "Please select an Open Issue to add"
                });
                toastEvent.fire();
        }
    },
    
    
    
})