({
    handleGetRecord : function(cmp, recordId, selectedRowId, rowIndex, successCallback) {
        //alert('in helperLoader' + recordId);
        cmp.set('v.recordId' , recordId);
        cmp.set('v.selectedRowId' , selectedRowId);
        cmp.set('v.rowIndex' , rowIndex)
        cmp.find('recorddata').reloadRecord(true);
        cmp.set('v.resultCallback', successCallback);
    },
    
    handleSendDetails: function(cmp, event, helper) {
        var selectedRowId= cmp.get('v.selectedRowId');
        var name = cmp.get('v.simpleRecord.Name');
        var newId = cmp.get('v.simpleRecord.Id');
        var rowIndex = cmp.get('v.rowIndex');  
        var appEvent = $A.get('e.c:evt_dataTableReturnedLookup');
        appEvent.setParams({
            'rowId' : selectedRowId,
            'name' : name,
            'newId' : newId,
            'rowIndex' : rowIndex 
        });
        appEvent.fire();	  
    },
    handleRecordUpdated: function(cmp, event, helper) {
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED") {
            helper.handleSendDetails(cmp, event, helper);
        } else if(eventParams.changeType === "CHANGED") {
            // record is changed
            console.log('loader changed' +  cmp.get('v.simpleRecord.Name'));
        } else if(eventParams.changeType === "REMOVED") {
            // record is deleted
        } else if(eventParams.changeType === "ERROR") {
            // there’s an error while loading, saving, or deleting the record
        }
    },
})