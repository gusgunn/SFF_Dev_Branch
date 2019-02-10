({
    handleSelect: function(component, event, helper) {
        var stepName = event.getParam("detail").value;
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: "Success!",
            message: "Toast from " + stepName
        });
        toastEvent.fire();
    },
    handleRecordUpdated: function(component, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
           let contactId = component.get('v.recordId');
           let household = component.get('v.simpleRecord.npo02__Household__c');
           component.set('v.household' , household);
           let newInakeNeeded = component.get('v.simpleRecord.Most_Recent_Intake__c');
            // do most recent intake - x month = overdue, cmp set intateStatus to true
            
            // helper.fireApplicationEvent(component);
        } else if(eventParams.changeType === "CHANGED") {
            // record is changed
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving, or deleting the record
        }
    },
    onNewIntake : function(component, event, helper) {
        helper.newModalInteractrion(component, event,  '012G0000000qhDKIAY', 'intakeChild');
    },
 
    onNewSurvey : function(component, event, helper) {
        helper.newModalInteractrion(component, event,  '0121L000001gymXQAQ', 'surveyChild');
    },
    onNewSwAssessment : function(component, event, helper) {
         helper.newModalInteractrion(component, event, '01216000001gyCKAAY','child');
    },
    
    onAddToChildcare : function(component, event, helper) {
        alert('create modal for add to childcare');
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
    
    
});