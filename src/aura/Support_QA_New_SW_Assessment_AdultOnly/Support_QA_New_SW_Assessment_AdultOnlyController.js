({
    doInit : function(component, event, helper) {
        var recordId =component.get("v.recordId") 
        if(recordId){
            component.set('v.relatedId', recordId );
        }
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
        if (changeType === "ERROR") { console.log('***error') }
        else if (changeType === "LOADED") {
            console.log('component.get("v.simpleContact.npo02__Household__c")' + component.getReference("v.simpleContact.npo02__Household__c"));
            component.set('v.household', component.get("v.simpleContact.npo02__Household__c") );
            component.set('v.relatedId', component.getReference("v.recordId")  );
            console.log('in recordUpdate RecordId ='+ component.getReference("v.recordId") );
            helper.handleEditModal(component, event, helper);
        }
            else if (changeType === "REMOVED") { /* handle record removal */ }
                else if (changeType === "CHANGED") {
                    
                    component.set('v.household', component.get("v.simpleContact.npo02__Household__c") );
                    component.set('v.relatedId', component.getReference("v.recordId")  );
                    
                    helper.handleEditModal(component, event, helper);
                }
        
    },
    
    
    
    
    
})