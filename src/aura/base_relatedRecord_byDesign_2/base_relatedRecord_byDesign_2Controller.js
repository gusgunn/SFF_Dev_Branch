//relatedRecord_byDesign controller
({
    onRecordUpdated: function(component, event, helper) {
      
        var changeType = event.getParams().changeType;
        if (changeType === "ERROR") { /* handle error; do this first! */ }
        else if (changeType === "LOADED") {
       
      
		let related = component.getReference('v.record.'+  component.get('v.relatedId') )
        
                component.set("v.related" , component.getReference('v.record.'+
                                                           component.get('v.relatedId') ));
            
            console.log('related --> ' + component.get('v.related'));
          
            if (typeof related !== undefined){
            helper.handleFieldsToDisplay(component, event, helper);
          
            }
           
        }
            else if (changeType === "REMOVED") { /* handle record removal */ }
            else if (changeType === "CHANGED") {}
   
    },
    
    showToast : function (component, event, helper){
		var toastEvent = $A.get("e.force:showToast");
 		console.log("toast");
 		if(toastEvent){
			toastEvent.setParams({"title" : "Record Update",
                                              "type" : "success",
                                              "message" : "Record Updated"});

            toastEvent.fire();

        }else{
            //No toast
        }
    },
    
    
   
})