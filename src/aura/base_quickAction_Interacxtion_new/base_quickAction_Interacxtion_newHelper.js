({
   
   
    
     handleEditModal : function(component, event, helper ) {
        // open modal 
        var modalBody;
        $A.createComponent("c:base_quickAction_Interacxtion_NewModal", { "sObjectName" : component.get('v.sObjectName'),
                                                          "relatedId" : component.getReference("v.recordId"),
                                                          "household" : component.getReference("v.household"),
                                                           "recTypeID" : "012G0000000qhDKIAY"
                                                          // "recTypeID" : "012G0000000qhDLIAY"
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