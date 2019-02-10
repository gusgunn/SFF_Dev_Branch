//relatedRecordForm_byDesign Controller File
({
    doInit : function (component, event, helper) {
        var str = component.get("v.fieldsToDisplay").replace(/\s+/g,'');
        var array = str.split(",");
        component.set("v.fieldsArray", array)  
         
    },
    
    showToast : function (cmp,evt,hlp){
		var toastEvent = $A.get("e.force:showToast");
 		console.log("toast");
 		if(toastEvent){
			toastEvent.setParams({"title" : "record Update",

                                  "type" : "success",

                                  "message" : "Record Updated"});

            toastEvent.fire();

        }else{
            //No toast
        }
    },
    
})