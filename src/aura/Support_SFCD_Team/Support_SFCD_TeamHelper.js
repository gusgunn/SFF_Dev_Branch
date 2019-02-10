({  
    newModalFRS : function(component, event, helper ) {
        var modalBody;
        $A.createComponent("c:Support_QA_HouseholdOwnerChange_UtilityModal", { "sObjectName" : 'npo02__Household__c',
                                                                       		   "recordId" : component.get("v.relatedId"),
                                                                               "updateType" : 'FRS',
                                                                              "fieldsToDisplay" : "Household_Name__c, OwnerId, Change_Household_Owner_FRS__c" 
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
    
    newModalSW : function(component, event, helper ) {
        //,  SFCD_Social_Worker_Consent__c
        var modalBody;
        $A.createComponent("c:Support_QA_HouseholdOwnerChange_UtilityModal", { "sObjectName" : 'npo02__Household__c',
                                                                        		"recordId" : component.get("v.relatedId"),
                                                                             	"updateType" : 'SW',
                                                                                "fieldsToDisplay" : "Household_Name__c, Household_SW__c"
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
    
    newModalSFIN : function(component, event, helper ) {
        var modalBody;
        $A.createComponent("c:Support_QA_HouseholdOwnerChange_UtilityModal", { "sObjectName" : 'npo02__Household__c',
                                                                            	"recordId" : component.get("v.relatedId"),
                                                                         		"updateType" : 'SFIN',
                                                                              "fieldsToDisplay" : "Household_Name__c,  HouseholdInclusionCoach1__c, Household_Inclusion_Coach_2__c"
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