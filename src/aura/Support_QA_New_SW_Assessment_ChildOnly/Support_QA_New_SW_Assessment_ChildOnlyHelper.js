({
   handleEditModal : function(component, event, helper ) {
        var modalBody;
        $A.createComponent("c:Support_QA_New_Int_Modal", { "sObjectName" : component.get('v.sObjectName'),
                                                          "relatedId" : component.getReference("v.recordId"),
                                                           "household" : component.getReference("v.household"),
                                                            "recTypeID" : "01216000001gyCKAAY",
                                                            "recordlabel" : 'child'
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