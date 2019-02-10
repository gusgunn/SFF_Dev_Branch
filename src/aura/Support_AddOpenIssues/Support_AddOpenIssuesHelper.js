({
	 addRelatedIssues: function(component, event, childRecordsIds) {
        //call apex class method
        var IntId = component.get("v.interactionId")
        var action = component.get('c.addRelatedIssues');
        console.log('childRecordsIds=  ' + childRecordsIds);
        console.log('IntId=  ' + IntId);

        action.setParams({
            "interactionId" :IntId, 
            "lstOfIssueIds": childRecordsIds
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
             
                 var toastEvent = $A.get("e.force:showToast");
          			toastEvent.setParams({
        				"title": "Success!",
        				"message": "Todays Issues have been added successfully."
    				}); 
                    toastEvent.fire();
                $A.get('e.force:refreshView').fire(); 
                
                this.getChildRecors(component,event);
                  
            }
        });
        $A.enqueueAction(action);
    },
    
})