({
	 onChangeOwner : function(component, event, helper) {
        component.set('v.household', component.get("v.simpleContact.npo02__Household__c") );
        component.set('v.relatedId', component.get("v.simpleContact.npo02__Household__c")  )
        helper.newModalFRS(component, event,  helper);
    },
    
    onChangeSW : function(component, event, helper) {
        component.set('v.household', component.get("v.simpleContact.npo02__Household__c") );
        component.set('v.relatedId', component.get("v.simpleContact.npo02__Household__c")  )
         
                               
        helper.newModalSW(component, event,  helper);
      },
    
    onChangeSFIN : function(component, event, helper) {
        component.set('v.household', component.get("v.simpleContact.npo02__Household__c") );
        component.set('v.relatedId', component.get("v.simpleContact.npo02__Household__c")  )
        helper.newModalSFIN(component, event,  helper);
      },
    
   
    
    cancel : function(component, event, helper){
        $A.get("e.force:closeQuickAction").fire();
        component.set("v.isOpen", false);
        component.find("popuplib").notifyClose();
        $A.get("e.force:closeQuickAction").fire();
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
      updateRecord : function(component, event, helper) {
            $A.get('e.force:refreshView').fire();
    	
      },
    
    recordUpdate : function(component, event, helper) {
        var changeType = event.getParams().changeType;
        if (changeType === "ERROR") {  }
        else if (changeType === "LOADED") {
            component.set('v.household', component.get("v.simpleContact.npo02__Household__c") );
            component.set('v.relatedId', component.get("v.simpleContact.npo02__Household__c")  );
 		    
        } else if (changeType === "REMOVED") {  
        } else if (changeType === "CHANGED") { 
            component.set('v.household', component.get("v.simpleContact.npo02__Household__c") );
            component.set('v.relatedId', component.get("v.simpleContact.npo02__Household__c")  );
            component.find('contactRecordLoader').reloadRecord();
        }
        
    },
})