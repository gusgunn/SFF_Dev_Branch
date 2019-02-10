//relatedRecord_byDesign controller
({
    recordUpdate: function(component, event, helper) {
      // 
        var changeType = event.getParams().changeType;
        if (changeType === "ERROR") { /* handle error; do this first! */ }
        else if (changeType === "LOADED") {
            component.find('r').set('v.value',
                                    component.getReference('v.record.'+
                                                           component.get('v.relatedId') ));
        //   component.set('v.show', false);
        }
            else if (changeType === "REMOVED") { /* handle record removal */ }
            else if (changeType === "CHANGED") {}
   
    },
   
})