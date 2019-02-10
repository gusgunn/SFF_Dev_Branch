({
    
    handleClose : function(cmp, event, helper) {
       cmp.find("popuplib").notifyClose();
    },

    handleSelection: function(cmp, newId, helper) {
       //alert('in handleselection ' +  newId);
        var myIndex = cmp.get('v.rowinfo');
       // alert('myIndex ' +  myIndex);
        var appEvent = $A.get('e.c:evt_dataTableUpdate');
        appEvent.setParams({
            "rowId" : cmp.get('v.recordId'),
            "refreshMe" : newId, 
            "myIndex" : myIndex
        });
        appEvent.fire();	
        helper.handleClose(cmp,event,helper);
     
    },
    
   
    
    
    
})