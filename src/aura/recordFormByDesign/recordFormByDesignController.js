({
    doInit : function (cmp, evt, hpl) {
        var str = cmp.get("v.fieldsToDisplay");
        console.log('fieldsToDisplay in from design --> ' + cmp.get("v.fieldsToDisplay"));
        
        // TODO remove any blank spaces added in design resourse
        var array = str.split(",");
        cmp.set("v.fieldsArray", array)     
    },
    
})