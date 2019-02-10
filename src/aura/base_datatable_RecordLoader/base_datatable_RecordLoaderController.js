({
	onCallRecordLoader: function(cmp, evt, helper) {    
     //get the method parameters - NOTE arguments is a key word for this and you can't use any other word
        var params = evt.getParams().arguments;
        var paramObj = params.actionParameters;
        var recordId = params.actionParameters.recordId;
        var selectedRowId = params.actionParameters.selectedRowId
        var rowIndex = params.actionParameters.rowIndex
        var successCallback = params.successCallback
        helper.handleGetRecord(cmp, recordId, selectedRowId, rowIndex, successCallback);
	},
    onRecordUpdated: function(cmp, event, helper) {
        helper.handleRecordUpdated(cmp, event, helper);
    },
    
})