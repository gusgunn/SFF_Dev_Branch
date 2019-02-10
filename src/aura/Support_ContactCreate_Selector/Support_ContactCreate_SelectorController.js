({
    
    doInit: function(component,event,helper){
        var value = helper.getParameterByName(component , event, 'inContextOfRef');
        var context = JSON.parse(window.atob(value));
        component.set("v.recordId", context.attributes.recordId);
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
        component.find("popuplib").notifyClose();
        $A.get("e.force:closeQuickAction").fire();
      //  helper.closeFocusedTab(component, event, helper);
    },
   
    
    handleButtonClick: function (cmp, event, helper) {       
        var selectedButtonLabel = event.getSource().get("v.label");
        
    },
    
    
    handleRecordUpdated: function(component, event, helper) {
       var changeType = event.getParams().changeType;

        if (changeType === "ERROR") { /* handle error; do this first! */ }
        else if (changeType === "LOADED") {
                var  household =component.get('v.simpleRecord.npo02__Household__c');
                component.set('v.household',   household  );
                alert('household loaded' + household) ;
        }
        else if (changeType === "REMOVED") { /* handle record removal */ }
        else if (changeType === "CHANGED") { 
          var  household =component.get('v.simpleRecord.npo02__Household__c');
                component.set('v.household',   household  );
                                            alert('household loaded' + household) ;
        }
        
    },
            
            /*
        
        alert('selector updated');
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            console.log('loaded ID' + component.get('v.simpleRecord.Id'));
            console.log('loader changed  ' + component.get('v.simpleRecord.npo02__Household__c'));
            component.set('v.household', component.get('v.simpleRecord.npo02__Household__c'));
            alert('household ' + household);
            
        } else if(eventParams.changeType === "CHANGED") {
            console.log('loaded ID' + component.get('v.simpleRecord.Id'));
            console.log('loader changed  ' + component.get('v.simpleRecord.npo02__Household__c'));
            component.set('v.household', component.get('v.simpleRecord.npo02__Household__c'));
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving, or deleting the record
        }
    },*/
    
    
    
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