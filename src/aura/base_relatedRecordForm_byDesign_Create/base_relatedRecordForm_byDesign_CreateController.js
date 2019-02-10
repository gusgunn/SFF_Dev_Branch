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
    
    handleSuccess : function(component, event, helper) {
        var payload = event.getParams().response;
        console.log(JSON.stringify(payload));
          console.log(payload.id);
    },   
    
       setOrgRefresh : function(component,event,helper){
        $A.get("e.force:refreshView").fire()  ;
    },
    
    prefillForm : function(component,event,helper){
        alert('prefil form');
         component.find('contactName').set('v.value', component.get("v.relatedId") );
       // alert('contactId+ '+ component.get('v.contactId'))
        $A.get("e.force:refreshView").fire()  
    },   
    
})