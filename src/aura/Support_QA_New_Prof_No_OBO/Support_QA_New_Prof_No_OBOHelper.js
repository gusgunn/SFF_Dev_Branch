({
    
    
    
    handleEditModal : function(component, event, helper ) {
        // open modal 
        var modalBody;
        $A.createComponent("c:Support_QA_New_Int_Modal", { "sObjectName" : component.get('v.sObjectName'),
                                                          "contactId" : component.getReference("v.recordId"),
                                                          "recTypeID" : "012G0000000qhDLIAY",
                                                          "recordlabel" : 'prof'
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