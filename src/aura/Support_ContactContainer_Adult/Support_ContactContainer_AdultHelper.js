({
 
    newModalInteractrion : function(component, event, recordType, recordlabel ) {
        let household= component.getReference("v.household");
        var modalBody;
        $A.createComponent("c:Support_QA_New_Int_Modal", { "sObjectName" : 'Case',
                                                          "contactId" : component.getReference("v.recordId"),
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