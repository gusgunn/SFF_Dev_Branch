({
	  
    handlePathStepChange: function(component, event, helper) {
        helper.changePath(component, event, helper);
    },
    
    selectPathStep1: function(component, event, helper) {
       component.set("v.pathStep", "1");
      
    },
    selectPathStep2: function(component, event, helper) {
        component.set("v.pathStep", "2");
      
    },
    selectPathStep3: function(component, event, helper) {
        component.set("v.pathStep", "3");
    },
    selectPathStep4: function(component, event, helper) {
        component.set("v.pathStep", "4");
       
    },
    selectPathStep5: function(component, event, helper) {
        component.set("v.pathStep", "5");
    },
    selectPathStep6: function(component, event, helper) {
        component.set("v.pathStep", "6");
    },
    selectPathStep7: function(component, event, helper) {
        component.set("v.pathStep", "7");
    },
    selectPathStep8: function(component, event, helper) {
        component.set("v.pathStep", "8");
    },
    
      handleRecordUpdated: function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            var intId = component.get('v.recordId');
            var childId = component.get('v.simpleInteraction.Family__Child__c');
            var contactId = component.get('v.simpleInteraction.ContactId');
            var contactAgency = component.get("v.simpleInteraction.Account.Id");
     		component.set( "v.interactionContactAgency" , contactAgency);
            helper.fireApplicationEvent(component);
        } else if(eventParams.changeType === "CHANGED") {
            // record is changed
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving, or deleting the record
        }
    },
    
    
    handleSelect : function (component, event, helper) {
    },
    
    openModel: function(component, event, helper) {
        component.set("v.isOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isOpen", false);
    },

})