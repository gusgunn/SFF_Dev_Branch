({ 
    helpSaveNewOwner : function(cmp, fields, helper) {
        var fields = event.getParam("fields");
        fields["npo02__Household__c"] = cmp.get('v.recordId');
        fields["OwnerId"] = cmp.get('v.householdOwnerName');
        cmp.find("changeOwnerForm").submit(fields);
        
    },
    
    notifySFCD_Team : function(cmp, event, helper) {
   	 	var appEvent = $A.get("e.c:Support_evtApp_reloadSFCDTeam");
	 	appEvent.fire();
      	helper.handleClose(cmp,event,helper);
	},
    
    handleRecordUpdated: function(cmp, event, helper) {
        var eventParams = event.getParams();
        
        if(eventParams.changeType === 'LOADED') {
            console.log('loaded ID' +  cmp.get('v.simpleRecord.Id'));
			console.log('loader changed  ' +  cmp.get('v.simpleRecord.Change_Household_Owner_FRS__c'));
        } else if(eventParams.changeType === 'CHANGED') {
            console.log('loader changed  ' +  cmp.get('v.simpleRecord.Change_Household_Owner_FRS__c'));
         
        } else if(eventParams.changeType === 'REMOVED') {
            
        } else if(eventParams.changeType === 'ERROR') {
           
        }
    },
  
         
    handleClose : function(cmp, event, helper) {
       $A.get("e.force:closeQuickAction").fire();
        cmp.set("v.isOpen", false);
        cmp.find("popuplib").notifyClose();
        $A.get("e.force:closeQuickAction").fire();
    },

})