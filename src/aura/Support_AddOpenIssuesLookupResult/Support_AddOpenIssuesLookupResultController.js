({
    selectRecord : function(component, event, helper){      
        var getSelectRecord = component.get("v.oRecord");
        var getSelectRecordId = component.get("v.oRecordId");
        var compEvent = component.getEvent("oSelectedRecordEvent");
        compEvent.setParams({"recordByEvent" : getSelectRecord});   
        compEvent.fire();
    },
})