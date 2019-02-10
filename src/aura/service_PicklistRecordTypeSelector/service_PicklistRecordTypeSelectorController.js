({ 
    loadEntries : function(component, event, helper) {
        // const params = event.getParam('arguments');
        var action = component.get('c.getRecordTypeMap');
        action.setParams({
            objectName : component.get('v.objectName')
        });
        action.setCallback(this, function(response) {
            const state = response.getState();
            if (state === 'SUCCESS') {
                var mapOfRecordTypes = response.getReturnValue();
                component.set("v.mapOfRecordTypes", mapOfRecordTypes);
                var optionsList = [];
                for (var key in mapOfRecordTypes) {
                    optionsList.push({value: key, label: mapOfRecordTypes[key]});
                }
                
                component.set('v.optionsList', optionsList);
            }
            else if (state === 'ERROR') {
                console.error('Failed to retrieve picklist values for '+ response.objectName );
                const errors = response.getError();
                if (errors) {
                    console.error(JSON.stringify(errors));
                } else {
                    console.error('Unknown error');
                }
            }
        });
        action.setStorable();
        $A.enqueueAction(action);
    },
    
    checkOptionValue : function(component, event, helper) {
        var newValue = event.getParam("value");
        var oldValue = event.getParam("oldValue");
        var newlabel = event.getParam("value[key]");
        var oldlabel = event.getParam("oldValue");
        var newl = component.get('v.selectedEntry');
        alert("recordType ID changed from '" + oldValue + "' to '" + newValue + "'");
        alert("recordType name changed from '" + oldValue + "' to '" + newl + "'");
    }
})