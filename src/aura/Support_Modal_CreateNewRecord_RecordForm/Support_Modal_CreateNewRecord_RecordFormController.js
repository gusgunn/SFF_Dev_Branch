({
    doInit : function (cmp, event, helper) {
        var str = cmp.get('v.fieldsToDisplay').replace(/\s+/g,'');
        var array = str.split(",");
        cmp.set('v.fieldsArray', array) ;
        
        
    },
    
    onSubmit : function(cmp, event, helper) {
        var validateFields = event.getParam("fields");
        let recordType = cmp.get('v.title');
        var errorNoHousehold = '';
        var errorNoBirthdate = '';
        var errorNoLastName = '';
        var showError = false;
        if (validateFields.hasOwnProperty("LastName")) {
              if ( !validateFields.LastName ) { 
                    errorNoLastName = 'Please give this person a last name.';
                    showError = true;
                }
        }
        if(recordType.includes('Child')){
            if (validateFields.hasOwnProperty("npo02__Household__c")) {
                if ( !validateFields.npo02__Household__c ) { 
                    errorNoHousehold = 'Please add this child to a household.';
                    showError = true;
                }
            }
            if (validateFields.hasOwnProperty("Birthdate")) {
                if ( !validateFields.Birthdate ) { 
                    errorNoBirthdate = 'Please add a birthdate for this child.';
                    showError = true;
                }
            }
        }
            if (showError === true){
                cmp.find('notifLib').showNotice({
                    "variant": "error",
                    "header": "Please fix the following errors:",
                    "message": errorNoLastName + " "  +  errorNoHousehold + " " + errorNoBirthdate,
                    closeCallback: function() {
                        
                    }
                });
            }
    },
    
    
    onCloseModal: function(cmp, event, helper) {
        cmp.set("v.isOpen", false);
        cmp.find("popuplib").notifyClose();
    },
    
    onErrors: function(component, event, helper) {
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type":"error",
            "title": "Error!",
            "message": "Please fill out required fields"
        });
        toastEvent.fire();
        //component.set("v.isOpen", false);
        // component.find("popuplib").notifyClose();
    },
    
    showToast: function(cmp, event, helper) {
        var fields = event.getParams().fields;
        var idValue = event.getParams().id;
        console.log('fields ' + JSON.stringify(fields));
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type" :  "success",
            "title":   "Success!",
            "message": fields.FirstName.value +" " +  fields.LastName.value + " created",
            // '/' + idValue 
            
        });
        toastEvent.fire();
        helper.navToNewContact(cmp, event, helper, idValue);

    },
    
})