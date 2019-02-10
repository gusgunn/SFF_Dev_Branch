({
    actionAdded : function(cmp, event, helper) {
        var cmpEvent = cmp.getEvent("AddNewActionToTable");
        cmpEvent.setParams({
        });
        cmpEvent.fire();
        console.log('actionAddedFire');
        
    },
   
    handleSubmit : function(component, event, helper){
        var eventFields = event.getParam("fields");
        component.find('recordEditForm').submit(eventFields);
    },
    
    
    
    
})