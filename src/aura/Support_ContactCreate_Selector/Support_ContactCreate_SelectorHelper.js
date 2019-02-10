({
    
    getParameterByName: function(component, event, name) {
        name = name.replace(/[\[\]]/g, "\\$&");
        var url = window.location.href;
        var regex = new RegExp("[?&]" + name + "(=1\.([^&#]*)|&|#|$)");
        var results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, " "));
    },
    
    loadEntries: function (cmp, event, helper) {
        var action = cmp.get('c.getRecordTypeMap');
        action.setParams({
            objectName: cmp.get('v.objectName')
        });
        action.setCallback(this, function (response) {
            const state = response.getState();
            if (state === 'SUCCESS') {
                var mapOfRecordTypes = response.getReturnValue();
                
                cmp.set("v.mapOfRecordTypes", mapOfRecordTypes);
                var optionsList = [];
                optionsList.push({ value: 'Select', label: '--Select--' });
                
                for (var key in mapOfRecordTypes) {
                    if (!mapOfRecordTypes[key].includes('C&P'))
                        optionsList.push({ value: key, label: mapOfRecordTypes[key] });
                }
                
                
                cmp.set('v.optionsList', optionsList);
                
                cmp.set('v.isOpen', true);
            }
            else if (state === 'ERROR') {
                console.error('Failed to retrieve picklist values for ' + response.objectName);
                const errors = response.getError();
                if (errors) {
                    console.error(JSON.stringify(errors));
                } else {
                    console.error('Unknown error');
                }
            }
        });
        action.setStorable();
        $A.enqueueAction(action);
    },
    
    
    getByValue: function(map, searchValue) {
        for (let [key, value] of map.entries()) {
            if (value === searchValue)
                alert('value = ' + value);
            return key;
            
        }
    },
    
    handleSelectedRecordType: function (cmp, event, helper) {
        var selectedRecordTypeId = cmp.get('v.selectedEntry');
        if(selectedRecordTypeId == null || selectedRecordTypeId === 'Select') {
      	 helper.handleNoSelection(cmp,  event, helper);
     
        } else {
            var mapOfRecordTypes = cmp.get("v.mapOfRecordTypes");
            var selectedRecordTypeName;
            var  fieldsToDisplay=[];
            for (var rtId in mapOfRecordTypes) {
                if (selectedRecordTypeId === rtId) {
                    selectedRecordTypeName = mapOfRecordTypes[rtId]; 
                }
            }
          
            helper.handleShowActionModal(cmp, event, helper, selectedRecordTypeId,  selectedRecordTypeName);
        }
        
    },
    
    
    handleNoSelection : function(){
        alert('You did not select a record type');
    },
    
     
    closeFocusedTab : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
    },
    
    handleShowActionModal: function (cmp, event,  helper, selectedRecordTypeId,  selectedRecordTypeName) {
		var selectedRecordType = cmp.get('v.selectedEntry');
        var record = cmp.get('v.recordId');
        var modalBody;
        $A.createComponent("c:Support_ContactCreate_New_Temp", {
            "relatedId" : cmp.getReference('v.recordId'),
            "recordTypeId" : selectedRecordType,
            "recordTypelabel" : selectedRecordTypeName
            
        },
                           function(content, status) {
                               if (status === "SUCCESS") {
                                   modalBody = content;
                                   cmp.find('popuplib').showCustomModal({
                                       // header: header,
                                       body: modalBody, 
                                       showCloseButton: true
                                   })
                                   
                               }
                               
                           });
        
        cmp.set("v.isOpen", false);
        
        
    },
    
  
    
})