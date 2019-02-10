//relatedRecord_byDesign Helper File
({
    handleFieldsToDisplay : function (component, event, helper) {
        var str = component.get("v.fieldsToDisplay").replace(/\s+/g,'');
        var fieldsArray = str.split(",");
        component.set("v.fieldsArray", fieldsArray)  
        component.set("v.show", true);
         
    },
})