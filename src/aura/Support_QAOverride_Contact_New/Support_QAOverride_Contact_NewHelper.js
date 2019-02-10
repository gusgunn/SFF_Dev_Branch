({
    
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
				
                    switch (selectedRecordTypeName) {
                        case 'Adult':
                            fieldsToDisplay =  "npo02__Household__c, Name, Email, HomePhone, MobilePhone, Family_Role__c" ;
                            break;
                        case 'Child/Person with Disability':
                            fieldsToDisplay =  "npo02__Household__c, Name, Birthdate, School_Type__c, Specify_School__c, Family_Role__c" ;
                            break;
                        default:
                            fieldsToDisplay =  "npo02__Household__c, Name, Email, HomePhone, MobilePhone, Birthdate, School_Type__c, Specify_School__c, Family_Role__c" 
                    }    
                    
                }
            }
          
            helper.handleShowActionModal(cmp, event, helper, selectedRecordTypeId, fieldsToDisplay, selectedRecordTypeName);
        }
        
    },
    
    
    handleNoSelection : function(){
        alert('You did not select a record type');
    },
    
    handleShowActionModal: function (cmp, event,  helper, selectedRecordTypeId, fieldsToDisplay, selectedRecordTypeName) {
        
        var selectedRecordType = cmp.get('v.selectedEntry');
        var modalBody;
        $A.createComponent("c:Support_Modal_CreateNewRecord_RecordForm", {
            "recordTypeId" : selectedRecordType,
            "fieldsToDisplay" : fieldsToDisplay,
            "title" : selectedRecordTypeName
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
    
    
    
    handleRecordUpdated: function (cmp, event, helper) {
        var eventParams = event.getParams();
        // NOT IMPLEMENTED - USE FOR PREFILL
        if (eventParams.changeType === 'LOADED') {
            console.log('loaded ID' + cmp.get('v.simpleRecord.Id'));
            console.log('loader changed  ' + cmp.get('v.simpleRecord.npo02__Household__c'));
            cmp.set('v.relatedId', cmp.get('v.simpleRecord.npo02__Household__c'));
        } else if (eventParams.changeType === 'CHANGED') {
            console.log('loader changed  ' + cmp.get('v.simpleRecord.npo02__Household__c'));
            cmp.set('v.relatedId', cmp.get('v.simpleRecord.npo02__Household__c'));
        } else if (eventParams.changeType === 'REMOVED') {
            
        } else if (eventParams.changeType === 'ERROR') {
            
        }
        
    },
    
    handlePrefilHouseholdId: function (cmp, fields, helper) {
        //NOT IMPLEMENTED
        var fields = event.getParam("fields");
        fields["npo02__Household__c"] = cmp.get('v.relatedId');
        
        cmp.find("recordForm").submit(fields);
        
    },
    
    
})