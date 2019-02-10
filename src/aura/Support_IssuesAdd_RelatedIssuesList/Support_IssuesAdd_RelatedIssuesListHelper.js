({
    loadRelatedIssues : function(component, event, helper) {
        var action = component.get("c.getAlreadyRelatedName");
        //action.setStorable();
        action.setParams({
            intId: component.get("v.recordId")
        });
        
        action.setCallback(this, function(response){
            if (response.getState() == "SUCCESS") {
           		 component.set("v.relatedIssues", response.getReturnValue());
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
})