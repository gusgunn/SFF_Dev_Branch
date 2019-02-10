({
    doInit: function (cmp, event, helper) {
        console.log("init started" + JSON.stringify('v.dataIn'));
        cmp.set('v.atomicChanges', []);
        cmp.set('v.draftValues', []);
        var actions = [
          //  { label: 'Edit', name: 'edit' },
           // { label: 'Delete', name: 'delete' },
           // { label: 'Change Owner', name: 'change_owner' },
        ];
            
            // onchange set iconflipper to edit
            var iconIs = cmp.get('v.iconFlipper');
            
            cmp.set('v.mycolumns', [ 
            { label: 'Name', fieldName: 'actionUrl', type: 'url', typeAttributes: { label: { fieldName: 'Name' } } },
            { label: 'Status Specifics', fieldName: 'Action_Status_Specifics__c', type: 'text', editable: false},
            { label: 'Action status', fieldName: 'Action_Status__c', type: 'text', editable: false},//, cellAttributes: { alignment: 'center' }, initialWidth: 120 } }
            { label: 'Date Referred', fieldName: 'Referral_Date__c', type: 'Date'},
            { label: 'Referral Organization', fieldName: 'orgUrl', type: 'url', typeAttributes: { label: { fieldName: 'Referral_Organization__c' } }},
            { label: 'Caller Name', fieldName: 'callerUrl', type: 'url', initialWidth: 150 ,typeAttributes: { label: { fieldName: 'Caller_Name__c' } }},
          { label: 'Org', fieldName: 'Organization__c', type: 'text'},
             // {label: 'Edit', type: 'button', initialWidth: 60, typeAttributes:
           // { label: { fieldName: 'actionLabel'}, title: 'Click to Edit', name: 'edit_account', initialWidth: 60,  iconName: cmp.get('v.iconFlipper'), //iconIs,//'utility:edit', 
          //  disabled: {fieldName: 'actionDisabled'}, class: 'btn_next'}},
			
            { label: 'Action Type', fieldName: 'RecordTypeName', type: 'text', initialWidth: 120 },
            { label: 'Action Details', fieldName: 'Action_Details', type: 'text', cellAttributes: { alignment: 'center' }, initialWidth: 120 },          
            
         //   { label: 'Action', type: 'button', initialWidth: 60,  typeAttributes: { label: 'view ', name: 'view', title: 'Click to View Details'}} ,
          //  { type: 'action', typeAttributes: { rowActions: actions } },
        ]);
        helper.handleLookups(cmp, event, helper);
        
        helper.resolveSaveLocalStorage(cmp);
        helper.resolveAutoSaveValue(cmp);
        if (cmp.get('v.saveLocalStorage')) {
            helper.resolveDraftValues(cmp);
        }
    },
    updatable : function (component, event, helper) {
        console.log("update Table evt");
    },
    handleClick: function (component, event, helper) {
        component.set("v.typeTest", "date")
    },
    handleSave: function (cmp, event, helper) {
        var draftValues = event.getParam('draftValues');
        helper.saveChanges(cmp, draftValues);
    },
    handleSaveInLocalStorage: function (cmp, event, helper) {
        helper.handleSaveInLocalStorage(cmp, event);
    },
    handleEditCell: function (cmp, event, helper) {
        helper.handleEditCell(cmp, event);
    },
    handleCancel: function (cmp, event, helper) {
        helper.clearDraftValuesLS();
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
              //  alert('view');
                var rowId = row.Id;
                var rowIndex = rows.indexOf(row);
                cmp.set('v.rowinfo', rowIndex);
                helper.handleActionEditModal(cmp, rowId, helper);
                break;
            case 'view':
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
            
   
    handleRowAction: function (cmp, event, helper) {
       var action = event.getParam('action');
		var row = event.getParam('row');
        console.log('row.Id___. ' + row.Id);
        
		cmp.set("v.selectedRow", row.Id);
		
				var evt = $A.get("e.c:recordChange");
				evt.setParams({
					"message": row.Id
				});
				evt.fire();
        console.log('event fired--> ' + row.Id);
    },
    
    toggleColumn: function (component, event, helper) {
        helper.toggleCol(component, event, helper);
    },
    
    handleViewRequest: function (component, event, helper) {
        helper.viewRequest(component, event, helper);
        
    },
    
    
    handleRecordUpdated : function(component, event, helper) {
        
        //var action = event.getParams(actionRow);
        
        //component.find("recHandler").reloadRecord();
        
    },
    
    
    updateColumnSorting: function (cmp, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        cmp.set("v.sortedBy", fieldName);
        cmp.set("v.sortedDirection", sortDirection);
        helper.sortData(cmp, fieldName, sortDirection);
    },
     closeModal: function(component, event, helper) {
        // set "isOpen" attribute to false for hide/close model box 
        component.set("v.isOpen", false);
    },
    
})