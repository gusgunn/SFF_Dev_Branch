({  
    handleEditModal : function(component, event, helper ) {
        var modalBody;
        $A.createComponent("c:Support_QA_HouseholdOwnerChange_UtilityModal", { "sObjectName" : 'npo02__Household__c',
                                                                        "recordId" : component.get("v.relatedId"),
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