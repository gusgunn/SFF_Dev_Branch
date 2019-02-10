({
    
    doInit: function(component,event,helper){
        helper.loadEntries(component, event, helper);
    },
    
    setSelectedEntry: function (component, event, helper) { 
        var newvalue = event.getParam("value");
        component.set('v.selectedRecordTypeId', newvalue );  
    },
    
    openModal: function(component, event, helper) {
        var selectedRecordTypeName = event.getSource().getLocalId();
        component.set("v.selectedRecordTypeName",  selectedRecordTypeName) 
        
    },
    
    
    closeModal: function(component, event, helper) {
        component.set("v.isOpen", false);
    },
    
    handleButtonClick: function (cmp, event, helper) {       
        var selectedButtonLabel = event.getSource().get("v.label");
        
    },
    
   
    
    showToast: function (cmp, evt, hlp) {
        var toastEvent = $A.get("e.force:showToast");
        
        console.log("toast");
        
        if (toastEvent) {
            
            toastEvent.setParams({
                "title": "Record Created",
                
                "type": "success",
                
                "message": "Contact Added"
            });
            
            toastEvent.fire();
            
        } else {
            //No toast
        }
    },
 
    onRecordTypeSelected: function(cmp,event,helper){
        helper.handleSelectedRecordType(cmp, event,helper);
    },
    
    
    
})