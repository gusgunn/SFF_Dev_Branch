// base_datatable Controller file
({
    doInit : function(cmp, event, helper) {
        console.log("base_datatable init started")
        cmp.set('v.atomicChanges', []);
        cmp.set('v.draftValues', []);
        cmp.set('v.mydata', []);
        var actions = [
            { label: 'Edit', name: 'edit' },
            { label: 'Delete', name: 'delete' },
            { label: 'Change Owner', name: 'change_owner' },
        ];
            cmp.set('v.mycolumns', [
          
            { label: 'Organization', fieldName: 'accounturl', type: 'url', initialWidth: 200, sortable :true, typeAttributes: { label: { fieldName: 'Name' } } },
            { label: 'Issues', fieldName: 'Issue_Type__c', type: 'text', initialWidth: 200, sortable :true, typeAttributes: { label: { fieldName: 'Name' } } },
            { label: 'Conditions', fieldName: 'Condition__c', type: 'text', initialWidth: 200, editable: false, sortable :true },
            { label: 'Website', fieldName: 'websiteUrl', type: 'url', initialWidth: 100, editable: true, sortable :true, typeAttributes: { label: { fieldName: 'Website' } } },
            { label: 'Phone', fieldName: 'Phone', type: 'phone', initialWidth: 140, editable: true, sortable :true},
            { label: 'W/C', fieldName: 'Wheelchair_Accessible__c', type: 'boolean', initialWidth: 70, editable: true, sortable :true },
            { label: 'Hours', fieldName: 'Open_Hours__c', type: 'text', initialWidth: 125, editable: false, sortable :true },
            { label: 'Zip', fieldName: 'BillingPostalCode', type: 'text', initialWidth: 100, editable: true, sortable :true },
            
            
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);
        
        var returnValue = cmp.get("v.dataIn");
        helper.handleLookups(cmp, returnValue, helper);
        helper.resolveSaveLocalStorage(cmp);
        helper.resolveAutoSaveValue(cmp);
        if (cmp.get('v.saveLocalStorage')) {
            helper.resolveDraftValues(cmp);
        }   
    },
     
    // the lookup icon is a button, which uses onrowaction
    // include other row actions here - I removed to keep this code snippet shorter 
    onRowAction : function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        var rows = cmp.get('v.mydata');
        cmp.set("v.selectedRow", row.Id);
        switch (action.name) {
            case 'edit_account':
                var rowId = row.Id;
                var rowIndex = rows.indexOf(row);
                cmp.set('v.rowinfo', rowIndex);
                helper.handleEditModal(cmp, rowId, helper);
                break;
            case 'delete':
                //delete code here
                break;
        }
    },
    
     onLookupUpdate : function(cmp, event, helper) {
        var rows =  cmp.get('v.mydata');
        var indexMap =[];
        if(rows){
        rows.forEach(function (row) {
             indexMap.push ({"index" : rows.indexOf(row), "key": row.Id});
            });
        localStorage.setItem('indexMap-save-local', JSON.stringify(indexMap));
        }
        helper.handleGetData(cmp, event, helper);
    },
    
    onSave: function(cmp, event, helper) {
        var draftValues = event.getParam('draftValues');
        helper.saveChanges(cmp, draftValues);
    },
    
    onSaveInLocalStorage : function(cmp, event, helper) {
        helper.handleSaveInLocalStorage(cmp, event);
    }, 
    
    onEditCell : function(cmp, event, helper) {
		helper.handleEditCell(cmp, event);
	},
    
    onCancel : function(cmp, event, helper) {
        helper.clearDraftValuesLS();
    },    
    
    onHeaderAction: function (cmp, event, helper) {
        var actionName = event.getParam('action').name;
        var colDef = event.getParam('columnDefinition');
        var columns = cmp.get('v.mycolumns');
        console.log('columns-->' + columns);
        var activeFilter = cmp.get('v.activeFilter');
        if (actionName !== activeFilter) {
            var idx = columns.indexOf(colDef);
            var actions = columns[idx].actions;
            actions.forEach(function (action) {
                action.checked = action.name === actionName;
            });
            cmp.set('v.activeFilter', actionName);
            cmp.set('v.mycolumns', columns);
        }
    },
    
    onColumnSorting : function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        event.getSource().set("v.sortedBy", fieldName);
        event.getSource().set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
    
    onClick : function(cmp, event, helper) {
        cmp.set("v.typeTest", "date");
    },
   
})