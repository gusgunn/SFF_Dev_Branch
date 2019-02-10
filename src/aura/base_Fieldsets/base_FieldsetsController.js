//generic_recordForm controller ;

({
    doInit : function (component, event, helper) {
        helper.getFieldsetHandler(component, event, helper);
        
    },   
    
    getToast : function(component, event, helper) {
       helper.showToast({
                "title": "Record Update",
                "type": "success",
                "message": "Record Updated"
            });
    },  
})