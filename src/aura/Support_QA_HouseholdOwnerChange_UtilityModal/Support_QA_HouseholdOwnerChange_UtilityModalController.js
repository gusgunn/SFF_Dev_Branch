({ 
    // add  var newConsentDate = fields["SFCD_Social_Worker_Consent__c"]
    // add to refresh?
    doInit: function (cmp, evt, hpl) {
		var str = cmp.get("v.fieldsToDisplay").replace(/\s+/g, '');
		console.log('fieldsToDisplay in from design --> ' + cmp.get("v.fieldsToDisplay"));

		var array = str.split(",");
		cmp.set("v.fieldsArray", array)
	},

    handleSaveNewOwner : function(cmp, event, helper) {
        var fields = event.getParam("fields");
        fields["npo02__Household__c"] = cmp.get('v.recordId');
        var newOwner = fields["Change_Household_Owner_FRS__c"]
        fields["OwnerId"] = newOwner; 
       
        fields["Change_Household_Owner_FRS__c"] = '';
        cmp.find("changeOwnerForm").submit(fields);
   
    },

    handleOwnerChanged: function(cmp, event, helper) {
    	 helper.notifySFCD_Team(cmp,event,helper);
       
    },    
    
    oncancel: function(cmp, event, helper) {
        helper.handleClose(cmp, event, helper);
    },
    
    errors: function(cmp, event, helper) {
        var statusVal = event.getParam('error');
        var toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({
            'type':'error',
            'title': 'Error!',
            'message': statusVal.message
        });
        toastEvent.fire();
    },
    
    onRecordUpdated: function(cmp, event, helper) {
        console.log('onRecordUpdated');
        helper.handleRecordUpdated(cmp, event, helper);
    },
    
})