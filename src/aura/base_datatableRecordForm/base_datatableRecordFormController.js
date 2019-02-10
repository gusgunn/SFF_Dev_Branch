//base_datableRecordForm Controller File
({
    doInit : function (cmp, event, helper) {
        var str = cmp.get('v.fieldsToDisplay').replace(/\s+/g,'');
        var array = str.split(",");
        cmp.set('v.fieldsArray', array)  
        cmp.set('v.newLookupId', cmp.get('v.recordId')); 
    },
    
    onDone: function(cmp, event, helper) {
        var newId = cmp.find('primary').get('v.value');
        cmp.set('v.newlookupId', newId);
        helper.handleSelection(cmp,newId,helper);
    },    
    
    closeModal: function(cmp, event, helper) {
        // set "isOpen" attribute to false for hide/close model box 
        cmp.set("v.isOpen", false);
        cmp.find("popuplib").notifyClose();
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
      
})