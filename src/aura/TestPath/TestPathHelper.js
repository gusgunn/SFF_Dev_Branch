({
   
 	changePath : function(component, event, helper) {
		var stepNameOld = event.getParam("oldValue");
        var stepNameNew = component.get('v.pathStep');
        
        var toggleIndicatorCurrent = component.find(stepNameOld);
        $A.util.removeClass(toggleIndicatorCurrent,'slds-tabs--path__item slds-is-current');
        $A.util.addClass(toggleIndicatorCurrent,'slds-tabs--path__item slds-is-complete');
        
        var toggleIndicatorNext = component.find(stepNameNew);
        var toggleIndicatorAhead = parseInt(stepNameNew) + 1;
      
         $A.util.removeClass(toggleIndicatorNext, 'slds-tabs--path__item slds-is-complete');
        $A.util.addClass(toggleIndicatorNext,'slds-tabs--path__item slds-is-current');
     
	},


	   newModalInteractrion : function(component, event, recordType, recordlabel ) {
        var modalBody;
        $A.createComponent("c:Support_QA_New_Int_Modal", { "sObjectName" : 'Case',
                                                           "relatedId" : component.getReference("v.recordId"),
                                                           "household" : component.getReference("v.household"),
                                                           "recTypeID" : recordType,
                                                           "recordlabel" : recordlabel
                                                       },
                           
                           function(content, status) {
                               if (status === "SUCCESS") {
                                   modalBody = content;
                                   component.find('popuplib').showCustomModal({
                                      body: modalBody, 
                                      showCloseButton: false
                                   })
                               } 
                           });

    },  
})