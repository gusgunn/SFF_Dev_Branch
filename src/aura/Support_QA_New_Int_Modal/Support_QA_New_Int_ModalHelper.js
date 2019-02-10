({
	navToNewInteraction :function(component, event, helper, newCaseId) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.openTab({
            recordId: newCaseId,
            focus: true
        }).then(function(response) {
            workspaceAPI.getTabInfo({
                  tabId: response
            }).then(function(tabInfo) {
            console.log("The url for this tab is: " + tabInfo.url);
            });
        })
        .catch(function(error) {
               console.log(error);
        });
        component.find("popuplib").notifyClose();
        component.set("v.isOpen", false);
        $A.get("e.force:closeQuickAction").fire();
     },
        
     handleSubmit : function(component, event, helper){
    	var eventFields = event.getParam("fields");
       // eventFields["ContactId"] = component.get("v.relatedId");
        component.find('recordEditForm').submit(eventFields);
     },
    
    customErrorToast : function (component, event, missingField){
        var toastEvent = $A.get("e.force:showToast");
        if(toastEvent){
            toastEvent.setParams({"title" : "Error",
                                  "type" : "error",
                                  "message" : 'Please enter the ' +  missingField + ' for this interaction' });
              
            toastEvent.fire();
           
        }else{
              alert('Please enter the ' + missingField +  ' for this interaction');
        }
    },
    
    prefillForm : function(component,event, helper){
        var recordlabel = component.get("v.recordlabel");
      /* 	if (recordlabel == 'Survey' ){
            component.find('calltype').set('v.value', 'Survey');
        }	*/
        if (recordlabel == 'intakeChild'  || recordlabel =='intakeAdult'){
            component.find('callType').set('v.value', 'Intake');
        }	
        let contact = component.get("v.contactId");
        	if (typeof contact !== 'undefined'){   
        component.find('contactName').set('v.value', component.get("v.contactId") );
        }
		let household = component.get("v.household");
        	if (typeof household !== 'undefined'){
        component.find('household').set('v.value', household );     
        }
        let child = component.get('v.relatedId');
        	if (typeof child !== 'undefined'){   
        component.find('childName').set('v.value', component.get("v.relatedId"));
        }
         var obo = component.get('v.recordlabel');
         if (typeof obo !== 'undefined' &&  obo === 'oboAdult' ){   
           component.find('adultOBO').set('v.value', true );
           }
    },
   
})