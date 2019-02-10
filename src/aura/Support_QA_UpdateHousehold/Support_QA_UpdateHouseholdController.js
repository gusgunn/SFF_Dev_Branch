({
    doInit : function(component, event, helper) {
        component.set('v.relatedId', component.get("v.recordId")  );
    },
    
    cancel : function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
        component.set("v.isOpen", false);
        component.find("popuplib").notifyClose();
        $A.get("e.force:closeQuickAction").fire();
    },
    
    errors: function(component, event, helper) {
        var statusVal = event.getParam("error");
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type":"error",
            "title": "Error!",
            "message": statusVal.message
        });
        toastEvent.fire();
    },
    
    
    recordUpdate : function(component, event, helper) {
        var changeType = event.getParams().changeType;
        if (changeType === "ERROR") { /* handle error; do this first! */ }
        else if (changeType === "LOADED") {
            console.log('component.get("v.simpleContact.npo02__Household__c.OwnerId")' + component.getReference("v.simpleContact.npo02__Household__c.OwnerId"));
            component.set('v.household', component.get("v.simpleContact.npo02__Household__c") );
              component.set('v.householdOwner', component.get("v.simpleContact.npo02__Household__c.OwnerId") );
            component.set('v.relatedId', component.getReference("v.recordId")  );
            console.log('in recordUpdate RecordId ='+ component.getReference("v.recordId") );
           // helper.handleEditModal(component, event, helper);
        }
            else if (changeType === "REMOVED") { /* handle record removal */ }
                else if (changeType === "CHANGED") {}
        
    },
    
    
    
    
    
})