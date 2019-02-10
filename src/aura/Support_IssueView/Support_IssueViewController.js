({
	
    happyDance : function(component, event, helper) {
        var evt = $A.get("e.c:recordChange");
        evt.setParams({
            "message" : component.get('v.recordId') });
        evt.fire();
    },
    prefillForm : function(component,event,helper){
        var tmpId = event.getParam("message");
         console.log('tmpId' + tmpId);
        var form = component.find('recordForm');
        form.set('v.recordId', tmpId);
    }
})