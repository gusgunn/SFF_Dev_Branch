// base_dataTableWithEdit Controller file
({
    doInit: function(cmp, event, helper) {
        cmp.set('v.atomicChanges', []);
        cmp.set('v.draftValues', []);
        /* var actions = [
           // { label: 'Edit', name: 'edit' },
          //  { label: 'Delete', name: 'delete' },
          //  { label: 'Change Owner', name: 'change_owner' },
        ]; */
        var classname ='';
        cmp.set('v.mycolumns', [
            { label: 'Name', fieldName: 'actionUrl', type: 'url', initialWidth: 90, sortable :true, 
             typeAttributes: { label: { fieldName: 'Name' } } },
            { label: 'Created By', fieldName: 'CreatedBy__c', type: 'text', initialWidth: 125, sortable :true, typeAttributes: { label: { fieldName: 'CreatedBy__c' } } },
            { label: 'Type', fieldName: 'RecordTypeName', type: 'text', initialWidth: 95, sortable :true , typeAttributes: { label: { fieldName: 'RecordTypeId' } }},
            {label: 'Action Details', fieldName: 'Action_Details', type: 'button',initialWidth: 200, typeAttributes: {label: { fieldName: 'Action_Details'}, title: {fieldName: 'templateTitle' }, variant: "base", class:"notLink"}},
            { label: 'Status', fieldName: 'Action_Status__c', type: 'text', initialWidth: 95,editable: false, sortable :true},
            { label: 'Specifics', fieldName: 'Action_Status_Specifics__c', type: 'text', initialWidth: 110,editable: false, sortable :true},
            { label: 'Date', fieldName: 'Referral_Date__c', type: 'date', initialWidth: 120, editable: false, sortable :true },
             { label: 'Referral Organization', fieldName: 'orgUrl', type: 'url', initialWidth: 210, editable: false, sortable :true, 
             typeAttributes: { label: { fieldName: 'Referral_Organization__c' } }},
            
            { label: 'Caller Name', fieldName: 'callerUrl', type: 'url', initialWidth: 150,  sortable :true, 
             typeAttributes: { label: { fieldName: 'Caller_Name__c' } }},
            //  { label: 'Caller Agency', fieldName: 'orgUrl', type: 'url', initialWidth: 120,  sortable :true, typeAttributes: { label: { fieldName: 'Organization__c' } },
            // cellAttributes: { class: {  fieldName:"classname"}}},
            
            { label: 'Organization', fieldName: 'Organization__c', type: 'text', initialWidth: 110, editable: false, sortable :true, 
             typeAttributes: { label: { fieldName: 'Organization__c' } }},
           
           
        ]);
            var returnValue = cmp.get("v.dataIn");
            helper.handleLookups(cmp, returnValue, helper);
            helper.resolveSaveLocalStorage(cmp);
            helper.resolveAutoSaveValue(cmp);
            if (cmp.get('v.saveLocalStorage')) {
            helper.resolveDraftValues(cmp);
            }
            },
            
            onLookupReturn : function(cmp, event, helper) {
            var params = event.getParams();
            var Id = params.rowId;
            var newId = params.newId;
            var rowIndex = params.rowIndex;
            var name = params.name;
            var lookupChange = ([{"Caller_Name__c" : newId,
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
                var appEvent = $A.get("e.c:evtApp_Support_ActionDatatable_ViewRecord");
                appEvent.setParams({
                    rowId : row.Id,
                    recordTypeId : row.RecordTypeId
                });
                appEvent.fire();
                break;
                /* var btn = cmp.find("newButton").get("v.label");
                if (btn == "New") {
                    helper.toggleCol(cmp,event,helper);
                }
                var evt = $A.get("e.c:recordChange");
                evt.setParams({
                    "message": row.Id
                });
                evt.fire();
                break;*/
                
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
    
    undateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        event.getSource().set("v.sortedBy", fieldName);
        event.getSource().set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },    
    
})