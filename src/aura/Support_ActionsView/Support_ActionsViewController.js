({
    
    doInit : function(component, event, helper) {
         alert(component.get('v.recordTypeId'));
    },
    
    happyDance : function(component, event, helper) {
        alert(component.get('v.recordTypeId'));
        var evt = $A.get("e.c:recordChange");
        evt.setParams({
            "message" : component.get('v.recordId') });
        evt.fire();
    },
    prefillForm : function(component,event,helper){
     
        var tmpId = event.getParam("message");
           console.log('tmpId' + tmpId);
        var form = component.find('actionRecordForm');
        form.set('v.recordId', tmpId);
        form.set('v.recordTypeId', component.get('v.recordTypeId'));
    }
})