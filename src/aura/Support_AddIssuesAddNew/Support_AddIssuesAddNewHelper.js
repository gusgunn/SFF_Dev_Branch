({
    handleInit  : function(component, event, helper) {
        var action = component.get("c.fetchAlreadyOpen");
        action.setParams({
            'objectName' : component.get("v.objectAPIName"),
            'kidId' : component.get('v.childID' ),
            'intId' : component.get('v.interactionID'),
            "conId" : component.get('v.contactID')
        });
        
        var opts = [];
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var allValues = response.getReturnValue();
                for (var i = 0; i < allValues.length; i++) {
                    opts.push({
                        label: allValues[i],
                        value: allValues[i]
                    });
                }
                
                component.set('v.options', opts); 
                
            } else if (state === 'ERROR') {
                const errors = response.getError();
                let message = 'Unknown error'; 
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    const error = errors[0];
                    if (typeof error.message != 'undefined') {
                        message = error.message;
                    } else if (typeof error.pageErrors != 'undefined' && Array.isArray(error.pageErrors) && error.pageErrors.length > 0) {
                        const pageError = error.pageErrors[0];
                        if (typeof pageError.message != 'undefined') {
                            message = pageError.message;
                        }
                    }
                }
                
                console.error('Error: '+ message);
                console.error(JSON.stringify(errors));
                // Fire error toast if available (LEX only)
                const toastEvent = $A.get('e.force:showToast');
                if (typeof toastEvent !== 'undefined') {
                    toastEvent.setParams({
                        title : 'Server Error',
                        message : message,
                        type : 'error',
                        mode: 'sticky'
                    });
                    toastEvent.fire();
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    
    addRelatedIssues: function(component, event, childRecordsIds) {
        var action = component.get('c.addRelatedIssues');
        action.setParams({
            "intId" : component.get("v.interactionID"),
            "lstOfIssueIds": childRecordsIds
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "variant": 'success',
                    "message": "Todays Issues have been added successfully."
                });
                toastEvent.fire();
                
            }
            
            else if (state === 'ERROR') {
                const errors = response.getError();
                let message = 'Unknown error'; 
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    const error = errors[0];
                    if (typeof error.message != 'undefined') {
                        message = error.message;
                    } else if (typeof error.pageErrors != 'undefined' && Array.isArray(error.pageErrors) && error.pageErrors.length > 0) {
                        const pageError = error.pageErrors[0];
                        if (typeof pageError.message != 'undefined') {
                            message = pageError.message;
                        }
                    }
                }
                
                console.error('Error: '+ message);
                console.error(JSON.stringify(errors));
                // Fire error toast if available (LEX only)
                const toastEvent = $A.get('e.force:showToast');
                if (typeof toastEvent !== 'undefined') {
                    toastEvent.setParams({
                        title : 'Server Error',
                        message : message,
                        type : 'error',
                        mode: 'sticky'
                    });
                    toastEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    
    addNewIssues: function(component, event, helper, saveNewIssuesList) {
        const fieldName = ('Type_Of_Issue__c');        
        var action = component.get('c.addNewIssues');
        action.setParams({
            "intId" : component.get("v.interactionID"),
            "conId" : component.get("v.contactID"),
            "kidId" : component.get("v.childID"),
            "lstOfIssueNamesSelected": saveNewIssuesList,
            "fld" : fieldName
            
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type": 'success',
                    "message": "New Issues have been created."
                });
                
                toastEvent.fire();
                
                console.log('added');
                //   $A.get('e.force:refreshView').fire();
                helper.relatedIssuesUpdated(component, event, helper);
            }
            else if (state === 'ERROR') {
                const errors = response.getError();
                let message = 'Unknown error'; 
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    const error = errors[0];
                    if (typeof error.message != 'undefined') {
                        message = error.message;
                    } else if (typeof error.pageErrors != 'undefined' && Array.isArray(error.pageErrors) && error.pageErrors.length > 0) {
                        const pageError = error.pageErrors[0];
                        if (typeof pageError.message != 'undefined') {
                            message = pageError.message;
                        }
                    }
                }
                
                console.error('Error: '+ message);
                console.error(JSON.stringify(errors));
                // Fire error toast if available (LEX only)
                const toastEvent = $A.get('e.force:showToast');
                if (typeof toastEvent !== 'undefined') {
                    toastEvent.setParams({
                        title : 'Server Error',
                        message : message,
                        type : 'error',
                        mode: 'sticky'
                    });
                    toastEvent.fire();
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    relatedIssuesUpdated : function(component, event, helper) {
        var appEvent =$A.get("e.c:evt_IssuesAdded");
        appEvent.setParams({
            
        });
        appEvent.fire();
        console.log('added new issue and fired to related');
    },
    
})