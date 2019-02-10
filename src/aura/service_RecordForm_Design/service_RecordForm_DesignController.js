({
    doInit : function (cmp, evt, hpl) {
      
        var str = cmp.get("v.fieldsToDisplay").replace(/\s+/g,'');
    
        
        var array = str.split(",");
        cmp.set("v.fieldsArray", array)     
    },
    
    showToast : function (cmp,evt,hlp){
        var toastEvent = $A.get("e.force:showToast");
        console.log("toast");
        if(toastEvent){
            toastEvent.setParams({"title" : "record Update",
                                  "type" : "success",
                                  "message" : "Record Updated"});
            toastEvent.fire();
        }else{
            alert(params.message);
        }
    
    },
})