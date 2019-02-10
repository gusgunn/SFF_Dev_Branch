//relatedRecordForm_byDesign Controller File
({
    doInit : function (component, event, helper) {
        var recTypeID = component.get('v.recTypeID');
        console.log('recTypeID-->' + recTypeID);
        
    },
    
    showToast : function (component,event, helper){
        var payload = event.getParams().response;
        let newCaseId = payload.id;
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams({"title" : "record Update",
                                  "type" : "success",
                                  "message" : "Record created"});
            
            toastEvent.fire();
            helper.navToNewInteraction(component, event, helper, newCaseId) 
        }else{
            //No toast
        }
    },
    
    prefillForm : function(component,event,helper){
        helper.prefillForm(component,event,helper);
        console.log('component.get("v.relatedId")' + component.get("v.relatedId"));
        console.log('component.get("v.household")' + component.get("v.household"));
       /* component.find('childName').set('v.value', component.get("v.relatedId") );
        component.find('household').set('v.value', component.get("v.household") );*/
    },
    
    errors: function(component, event, helper) {
        var statusVal = event.getParam("error");
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type":"error",
            "title": "Error!",
            "message": statusVal.message
        });
        toastEvent.fire();
    },
    cancel: function(component, event, helper) {
        component.find("popuplib").notifyClose();
        component.set("v.isOpen", false);
        $A.get("e.force:closeQuickAction").fire();
    },
    
    onSubmit : function(component, event, helper) {
        event.preventDefault(); // stop form submission
        var contactName = component.find("contactName").get("v.value");
        var calltype = component.find("callType").get("v.value");
        var origin = component.find("origin").get("v.value");
        console.log('contactName' + contactName);
        if($A.util.isEmpty(contactName) ){
            var name = "Contact Name";
            helper.customErrorToast(component, event, name);
            
        } else if($A.util.isEmpty(origin) ){
            var name = "Origin";
            helper.customErrorToast(component, event, name);
            
        } else if($A.util.isEmpty(calltype) ){
            var name = "Call Type";
            helper.customErrorToast(component, event, name);
        }else{
            helper.handleSubmit(component, event, helper);
        }
    },
    
})