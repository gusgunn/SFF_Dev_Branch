({
    doInit : function (component, event, helper) {
      console.log('related issues list int id= ' + component.get('v.recordId'));
      helper.loadRelatedIssues(component, event, helper);  
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
            console.log('in recordupdated');
            helper.loadRelatedIssues(component, event, helper);
        }
    },
    
    recordChangeHandler : function(component, event, helper) {
        console.log('in record change handler reload service');
        var id = event.getParam("recordId");
        component.set("v.recordId", id);
        var service = component.find("service");
        service.reloadRecord();
    },

 })