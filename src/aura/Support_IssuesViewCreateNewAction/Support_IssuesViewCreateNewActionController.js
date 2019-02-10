({
    
    doInit : function(component, event, helper){
        component.find('child').set('v.value', component.get("v.childId"));
        console.log('in create Action' + component.get("v.childId"))
        component.find('issue').set('v.value', component.get("v.issue"));
        component.find('issueType').set('v.value', component.get("v.issueType"));
        component.find('caller').set('v.value', component.get("v.interactionContact"));
        console.log('in action, agency' + component.get("v.interactionContactAgency"));
    },        
    
    
    showToast : function (component, event, helper){
        var eventFields = event.getParam("fields");
        var actionType = component.get("v.recTypeName");
        var appEvent = $A.get('e.c:evt_AddNewActionToTable');
        console.log('firing event');
        appEvent.setParams({
            
        });
        appEvent.fire();	
        component.find('notifLib').showToast({
            variant: 'success',
            message: "New " + actionType + " Action created."  
            
        });
        
        component.find("popuplib").notifyClose();
        
    },
     
    setOrgRefresh : function(component,event,helper){
        $A.get("e.force:refreshView").fire()  ;
    },
    
    prefillForm : function(component,event,helper){
       var rectype = component.get('v.recTypeName');
        if (rectype === 'Internal Referral' ){
        component.find('referalorg').set('v.value', '001G000001kuowUIAQ');
        //   component.find('organization').set('v.value', 'N/A'); 
        component.find('calleragency').set('v.value', component.get("v.interactionContactAgency"));  
        } 
        if (rectype === 'External Referral' ){
        //Find out id required and put validation rule on  ||rectype === 'Information'
        //   component.find('organization').set('v.value', 'N/A'); 
        component.find('calleragency').set('v.value', component.get("v.interactionContactAgency"));  
        }
        $A.get("e.force:refreshView").fire()  
    },
    
    onSubmitForm  : function(component,event,helper){
        event.preventDefault(); 
        var rectype = component.get('v.recTypeName');
        var errorNoExternalActionDetail = '';
        var errorNoReferralOrganization = '';
        var errorNoInternalActionDetail = '';
        var showError = false;
               
        if (rectype === 'External Referral' ){
        var externalActionDetailType = component.find("external").get("v.value");
        var referralOrganization = component.find("referralOrganization").get("v.value");
  
            if($A.util.isEmpty(externalActionDetailType = component.find("external").get("v.value")) ){
                errorNoExternalActionDetail = "Please Add An Action Detail Type. ";
                showError = true;
            }
            if($A.util.isEmpty(component.find("referralOrganization").get("v.value"))){
            errorNoReferralOrganization = "Please Add The External Organization You are Referring Out To. ";
            showError = true;
        	}
        	}
        if (rectype === 'Internal Referral' ){
            var internalActionDetailType = component.find("internal").get("v.value");
            if($A.util.isEmpty(component.find("referralOrganization").get("v.value"))){
            errorNoInternalActionDetail = "Please Add An Action Detail Type. ";
            showError = true;
        	}
        
         }

    	if (showError === true){
                component.find('notifLib').showNotice({
                    "variant": "error",
                    "header": "Please fix the following errors:",
                    "message": errorNoExternalActionDetail + " "  +  errorNoReferralOrganization + " " + errorNoInternalActionDetail,
                    closeCallback: function() {
                        
                    }
                });
			} else{
            helper.handleSubmit(component, event, helper);
		}
      
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
    
    close : function(component, event, helper) {
        component.find("popuplib").notifyClose();
    },
    
       
    createActionEvent: function (component, event, helper) {
        console.log('in createActionEvent');
        /*  var rt = event.getParam("rt");
        var issue = event.getParam("issue");
        console.log('rt and issue--> ' +rt + ' ' + JSON.stringify(issue));
        helper.createActionEvent(component, rt, issue);    */
    },   
})