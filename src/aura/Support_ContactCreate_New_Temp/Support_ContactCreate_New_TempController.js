({
    
    handleRecordIdChange : function(component, event, helper) {
    
    },
    
    showToast : function (component,event, helper){
        var payload = event.getParams().response;
        let newContactId = payload.id;
        let newContactRecordType = payload.RecordType;
        //  alert('payload.RecordType' + newCaseRecordType );
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams({"title" : "New record created",
                                  "type" : "success",
                                  "message" : "Navigating to the new record.."});
            
            toastEvent.fire();
            helper.navToNewContact(component, event, helper, newContactId) ;
        }else{
            //No toast
            helper.navToNewContact(component, event, helper, newContactId) ;
        } 
    },
    
    prefillForm : function(component,event,helper){
        helper.handlePrefillForm(component,event,helper);
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
        component.set("v.isOpen", false);
        component.find("popuplib").notifyClose();
        $A.get("e.force:closeQuickAction").fire();
    },
    
     closeFocusedTab : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    
    handleRecordUpdated: function(component, event, helper) {
        var changeType = event.getParams().changeType;
        if (changeType === "ERROR") { /* handle error; do this first! */ }
        else if (changeType === "LOADED") {
            var  household =component.get('v.simpleRecord.npo02__Household__c');
            component.set('v.household',   household  );
            var  householdname =component.get('v.simpleRecord.npo02__Household__r.Name');
            component.set('v.householdname',   householdname );
            component.set("v.isOpen", true);
            
        }
            else if (changeType === "REMOVED") { /* handle record removal */ }
                else if (changeType === "CHANGED") { 
                    alert('change');
                }
    },
    
    
    onSubmit : function(component, event, helper) {
        event.preventDefault(); 
        var contactname = null;
        var birthdate='';
        var household ='';
        contactname = component.find("contactname").get("v.value");
        let recordType = component.get('v.recordTypelabel');
        var errorNoHousehold = '';
        var errorNoBirthdate = '';
        var errorNoLastName = '';
        var showError = false;
        if($A.util.isEmpty(contactname || contactname==null || contactname==='') ){
            alert(contactname);
           errorNoLastName = 'Please give this person a Name. ';
            showError = true;      
        }
        if(recordType === 'Child/Person with Disability'){
            birthdate = component.find("birthdate").get("v.value");
            household = component.find("household").get("v.value");
             if($A.util.isEmpty(contactname) ){
           errorNoLastName = 'Please give this person a Name. ';
            showError = true;  
            if($A.util.isEmpty(birthdate) || birthdate == null || birthdate ==''){
                errorNoBirthdate = 'Please add a birthdate for this child.' ;
                 showError = true;
            } 
               
        }
            if($A.util.isEmpty(household) ){
                errorNoHousehold = 'Please add this child to a household.';
                showError = true;
            }
        }
            
            if (showError === true){
                component.find('notifLib').showNotice({
                    "variant": "error",
                    "header": "Please fix the following errors:",
                    "message": errorNoLastName + " "  +  errorNoHousehold + " " + errorNoBirthdate,
                    closeCallback: function() {
                        
                    }
                });
                
            }  else{
                helper.handleSubmit(component, event, helper);
            }
        
    },
    
    
    
})