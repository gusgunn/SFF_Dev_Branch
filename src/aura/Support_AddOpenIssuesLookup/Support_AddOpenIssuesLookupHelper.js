({
    searchHelper : function(component, event, getInputkeyWord) {
        var action = component.get("c.fetchAvailableValues"); 
        action.setParams({
            'searchKeyWord': getInputkeyWord,
            'objectName' : component.get("v.objectAPIName"),
            'kidId' : component.get("v.childID"),
            'intId' : component.get("v.interactionID")
        });  
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find("mySpinner"), "slds-show");
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                if (storeResponse.length == 0) {
                    component.set("v.Message", 'No Records Found...');
                } else {
                    component.set("v.Message", '');
                }
                component.set("v.listOfSearchRecords", storeResponse); 
                component.set("v.excludedIssues", storeResponse); 
                // console.log('listOfSearchRecords -->' + JSON.stringify(component.get("v.listOfSearchRecords")));
            }
        });  
        $A.enqueueAction(action);
    },
    
    addRelatedIssues: function(component, event, helper, childRecordsIds) {
        console.log('enter addRelatedIssues, ids= ' + childRecordsIds);
        var action = component.get('c.addRelatedIssues');
        action.setParams({
            "intId" : component.get("v.interactionID"), 
            "lstOfIssueIds": childRecordsIds,
            "conId" : component.get("v.contactID") 
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var toastEvent = $A.get("e.force:showToast");
                
                toastEvent.setParams({
                    "title": "Success!",
                    "type" : "success",
                    "message": "Issues added"
                }); 
                toastEvent.fire();
                helper.relatedIssuesUpdated(component, event, helper);
                $A.get('e.force:refreshView').fire();
                component.set("v.selectedLookUpRecordIDs", [] );
                component.set("v.lstSelectedRecords", [] );
                
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
    }
    
   
})