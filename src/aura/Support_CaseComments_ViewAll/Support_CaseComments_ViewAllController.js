({
    
    doInit : function (component, event, helper) {
       console.log('case comments kid Id ' + component.get('v.kidId'));
            helper.loadCaseComments(component);
        
    }, 
    
    navigateToRecord : function (component, event, helper) {
        var selectedItem = event.currentTarget;
        var recordId = selectedItem.dataset.record;
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId,
        });
        navEvt.fire();
    },
    
    recordUpdated : function(component, event, helper) {
        var changeType = event.getParams().changeType;
        if (changeType === "LOADED" || changeType === "CHANGED") {
           // helper.loadCaseComments(component);
        }
    },
    
    recordChangeHandler : function(component, event) {
        var id = event.getParam("recordId");
        component.set("v.recordId", id);
        var service = component.find("service");
        alert('record loaderservice found');
        service.reloadRecord();
    }


 })