({
    doInit: function(cmp, event, helper) {
        cmp.set('v.atomicChanges', []);
        cmp.set('v.draftValues', []);
        var actions = [
           // { label: 'Edit', name: 'edit' },
           // { label: 'Delete', name: 'delete' }
            //{ label: 'Change Owner', name: 'change_owner' },
        ];
        var classname ='';
        cmp.set('v.mycolumns', [
            
            
            { label: 'Record Link', fieldName: 'recordUrl', type: 'url', initialWidth: 170, sortable :true, typeAttributes: { label: { fieldName: 'Name' } } },
            { label: 'Child', fieldName: 'childUrl', type: 'url', initialWidth: 170, sortable :true, typeAttributes: { label: { fieldName: 'Child__c' } } },
            { label: 'Organization', fieldName: 'orgUrl', type: 'url', initialWidth: 200, sortable :true, typeAttributes: { label: { fieldName: 'Organization__c' } } },
            { label: 'Professional', fieldName: 'profUrl', type: 'url', initialWidth: 180, sortable :true, typeAttributes: { label: { fieldName: 'Professional_Contact__c' } } },
            { label: 'Current Verbal Consent', fieldName: 'Verbal_Consent_Date__c', type: 'date', initialWidth: 150, editable: true, sortable :true },
            { label: 'First Verbal Consent', fieldName: 'First_Verbal_Consent_date__c', type: 'date', initialWidth: 150, editable: true, sortable :true },
            { label: 'Current Written Consent', fieldName: 'Written_Consent_Date__c', type: 'date', initialWidth: 150, editable: true, sortable :true },
            { label: 'First Written Consent', fieldName: 'First_Written_Consent_Date__c', type: 'date', initialWidth: 150, editable: true, sortable :true },
            
           // { type: 'action', typeAttributes: { rowActions: actions } }
            ]);
        helper.handleGetData(cmp);
        helper.resolveSaveLocalStorage(cmp);
        helper.resolveAutoSaveValue(cmp);
        if (cmp.get('v.saveLocalStorage')) {
            helper.resolveDraftValues(cmp);
            console.log('after initlocalStorage -->' + localStorage);
        }
    },
    onLookupReturn : function(cmp, event, helper) {
        var params = event.getParams();
        var Id = params.rowId;
        var newId = params.newId;
        var rowIndex = params.rowIndex;
        var name = params.name;
        var lookupChange = ([{"Organization__c" : newId,
                              "Id" : Id}]);
        cmp.set('v.lookupChanges' , lookupChange ); 
        helper.handleEditCell(cmp, event, helper);
        helper.handleUpdateUI(cmp, Id, newId, name, rowIndex);
    },
    onLookupId: function(cmp, event, helper) {
        helper.dataRecieved(cmp, event, helper);
    }, 
    handleEditCell: function(cmp, event, helper) {
        helper.handleEditCell(cmp, event, helper);
    },
    handleRowActionForLookup: function (cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        var rows = cmp.get('v.mydata');
        cmp.set("v.selectedRow", row.Id);
        switch (action.name) {
            case 'edit_account':
                var rowId = row.Id;
                var rowIndex = rows.indexOf(row);
                cmp.set('v.rowinfo', rowIndex);
                helper.handleEditModal(cmp, rowId, rowIndex, row, helper);
                break;
            case 'edit':
                var btn = cmp.find("newButton").get("v.label");
                if (btn == "New") {
                    helper.toggleCol(cmp,event,helper);
                }
                var evt = $A.get("e.c:recordChange");
                evt.setParams({
                    "message": row.Id
                });
                evt.fire();
                break;
                
            case 'delete':
                var rows = cmp.get('v.mydata');
                var rowIndex = rows.indexOf(row);
                rows.splice(rowIndex, 1);
                cmp.set('v.mydata', rows);
                var tmp = cmp.find("recHandler");
                
                tmp.reloadRecord(true, function(){
                    tmp.deleteRecord();
                })
        }
    },
    
    handleSave: function(cmp, event, helper) {
        var draftValues = cmp.get('v.draftValues');
        helper.saveChanges(cmp, draftValues);
    },
    handleSaveInLocalStorage: function(cmp, event, helper) {
        helper.handleSaveInLocalStorage(cmp, event);
    },
    handleCancel: function(cmp, event, helper) {
        cmp.set('v.draftValues', []);
        cmp.set('v.atomicChanges', []);
        cmp.set('v.changeIndex', 0);
        helper.clearDraftValuesLS();
        helper.handleGetData(cmp);
        
    },    
    handleHeaderAction: function (cmp, event, helper) {
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
    handleRowAction: function(cmp, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        cmp.set("v.selectedRow", row.Id);
        switch (action.name) {
            case 'edit':
                var btn = cmp.find("newButton").get("v.label");
                if (btn == "New") {
                    helper.toggleCol(cmp,event,helper);
                }
                var evt = $A.get("e.c:recordChange");
                evt.setParams({
                    "message": row.Id
                });
                evt.fire();
                break;
            case 'delete':
                var rows = cmp.get('v.mydata');
                var rowIndex = rows.indexOf(row);
                rows.splice(rowIndex, 1);
                cmp.set('v.mydata', rows);
                var tmp = cmp.find("recHandler");
                tmp.set("v.recordId", row.Id);
                tmp.reloadRecord(true, function(){
                    tmp.deleteRecord();
                })
        }
    },
    handletoggleColumn: function(cmp, event, helper) {
        helper.toggleCol(cmp,event,helper);
    },
    handleClick: function(cmp, event, helper) {
        cmp.set("v.typeTest", "date")
    },
    undateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        event.getSource().set("v.sortedBy", fieldName);
        event.getSource().set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },    
})