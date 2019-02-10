({
     saveChanges: function (cmp, draftValues) {
                        var self = this;
                       /***************** */
                          var action = cmp.get('c.updateActions');
                        
                        action.setParam("draftValues", draftValues);
                        action.setCallback(this, $A.getCallback(function (response) {
                            var state = response.getState();
                            
                            if (state === "SUCCESS") {
                                var returnValue = response.getReturnValue();
                                
                                if (Object.keys(returnValue.errors).length > 0) {
                                    cmp.set('v.errors', returnValue.errors);
                                } else {
                                    this.notifications.showToast({
                                        variant: 'success',
                                        title: returnValue.message,
                                    });
                                    cmp.set('v.errors', []);
                                    cmp.set('v.draftValues', []);
                                    cmp.set('v.atomicChanges', []);
                                    cmp.set('v.changeIndex', 0);
                                    self.clearDraftValuesLS();
                                    // sent to service cmp: self.getData(cmp);
                                }
                            } else if (state === "ERROR") {
                                var errors = response.getError();
                                console.error(errors);
                            }
                        }));
                        
                        $A.enqueueAction(action);
                    },
                    
    handleLookups: function (cmp, event){
                        var tempJson = cmp.get("v.dataIn");
                        if(tempJson){  
                           // console.log('tempJson.length-----> '+ tempJson.length);
                          //  console.log('tempJson.length-----> '+ JSON.stringify(tempJson));
                         	for (var i=0; i< tempJson.length; i++ ) {
                                var row =tempJson[i];
                                row.actionUrl = "/one/one.app#/sObject/" + row.Id;
                                if (row.Referral_Organization__c && row.Referral_Organization__r.Name ){
                                    row.Referral_Organization__c = row.Referral_Organization__r.Name;
                                    row.orgUrl = "/one/one.app#/sObject/" + row.Referral_Organization__r.Id;
                                   // console.log(row.Referral_Organization__c);
                                    
                                }
                                if (row.RecordTypeId && row.RecordType.Name ){
                                    if(row.RecordType.Name.includes('Internal') ){
                                    row.RecordTypeName = 'Internal' ;   
                                    } else if(row.RecordType.Name.includes('External') ){
                                    row.RecordTypeName = 'External' ; 
                                        
                                        } else if(row.RecordType.Name.includes('Check-In') ){
                                    row.RecordTypeName = 'Check-In' ; 
                                        } else row.RecordTypeName = row.RecordType.Name;
                                    //  console.log(row.RecordTypeName);
                                  
                                }
                                
                                if (row.Caller_Name__c && row.Caller_Name__r.Name ){
                                    row.Caller_Name__c = row.Caller_Name__r.Name;
                                    row.callerUrl = "/one/one.app#/sObject/" + row.Caller_Name__r.Id;
                                    //console.log(row.Caller_Name__c);
                                }
                                
                                 if (row.Material_Type__c){
                                    row.Action_Details = row.Material_Type__c;
                                    }
                                
                                
                                if (row.Action_Detail_Type_Internal_Referral__c){
                                    row.Action_Details = row.Action_Detail_Type_Internal_Referral__c;
                                    }
                                    
                                    if (row.Action_Detail_Type_External_Referral__c){
                                    row.Action_Details = row.Action_Detail_Type_External_Referral__c;
                                    }
                                   
                                     if (row.Action_Detail_Type_Information__c){
                                    row.Action_Details = row.Action_Detail_Type_Information__c;
                                    }
     
                            }
                            
                           // console.log('data sent to actiondatatable--> ' + JSON.stringify(tempJson));
                            cmp.set('v.mydata', tempJson);	
                        }    
           },
                    
	handleSaveInLocalStorage: function (cmp, event) {
                    var checked = event.getParam('checked');
                    localStorage.setItem('demo-save-local', JSON.stringify(checked));
                    if (checked) {
                    this.resolveSaveLocalStorage(cmp);
                } else {
                                 this.clearDraftValuesLS();
            }
        },
    resolveSaveLocalStorage: function (cmp) {
                           //debugger
                           var localStorageValue = localStorage.getItem('demo-save-local');
        try {
            var saveLocalStorage = JSON.parse(localStorageValue);
            if (saveLocalStorage) {
                cmp.set('v.saveLocalStorage', saveLocalStorage);
            }
        } catch (e) {
            cmp.set('v.saveLocalStorage', false);
        }
    },
    
    handleEditCell: function (cmp, event) {
        var saveLocalStorage = cmp.get('v.saveLocalStorage');
        if (saveLocalStorage) {
            var atomicChange = event.getParam('draftValues');
            var atomicChanges = cmp.get('v.atomicChanges');
            atomicChanges.push(atomicChange);
            cmp.set('v.changeIndex', atomicChanges.length);
            
            var draftValues = this.getBuildedDraftValues(atomicChanges, atomicChanges.length);
            
            localStorage.setItem('demo-draft-values', JSON.stringify(atomicChanges));
        }
        
        if (cmp.get('v.autoSaveEnabled')) {
            this.saveChanges(cmp, draftValues);
        }
    },
    
    getBuildedDraftValues: function (atomicChanges, lastChange) {
        var draftValues = [];
        var mergeChange = function (change, draft) {
            for (var j = 0; j < change.length; j++) {
                var row = false;
                draft.some(function (searchRow) {
                    if (searchRow['Id'] === change[j].Id) {
                        row = searchRow;
                        return true;
                    };
                    return false;
                });
                
                if (row) {
                    Object.assign(row, change[j]);
                } else {
                    draft.push(change[j]);
                }
            }
        }
        
        for (var i = 0; i < lastChange; i++) {
            mergeChange(atomicChanges[i], draftValues)
        }
        
        return draftValues;
    },
    
    resolveDraftValues: function (cmp) {
        try {
            var atomicChanges = JSON.parse(localStorage.getItem('demo-draft-values'));
            cmp.set('v.draftValues', this.getBuildedDraftValues(atomicChanges, atomicChanges.length));
            cmp.set('v.atomicChanges', atomicChanges);
            cmp.set('v.changeIndex', atomicChanges.length);
        } catch (e) {
            cmp.set('v.draftValues', []);
            cmp.set('v.atomicChanges', []);
            cmp.set('v.changeIndex', 0);
        }
    },
    
    clearDraftValuesLS: function () {
        localStorage.setItem('demo-draft-values', JSON.stringify([]));
    },
    
    handleAutoSaveChange: function (cmp, event) {
        var checked = event.getParam('checked');
        localStorage.setItem('demo-autosave', JSON.stringify(checked));
    },
    
    resolveAutoSaveValue: function (cmp) {
        //debugger
        var localStorageValue = localStorage.getItem('demo-autosave');
        
        try {
            var saveLocalStorage = JSON.parse(localStorageValue);
            if (saveLocalStorage) {
                cmp.set('v.autoSaveEnabled', saveLocalStorage);
            }
        } catch (e) {
            cmp.set('v.autoSaveEnabled', false);
        }
    },
    toggleCol: function (cmp, event, helper) {
        //var btn = cmp.find("newButton");
        //var tmp = btn.get("v.label");
        //((tmp == "New") ? btn.set("v.label", "Close") : btn.set("v.label", "New"));
        var event = $A.get("e.c:toggleColumn");
        event.fire();
    },
    deleteRec: function (cmp, event, helper) {
        console.log("fired");
        var tmp = cmp.find("recHandler");
        tmp.deleteRecord();
    },
     handleActionEditModal : function(component, rowId, helper) {
        //addpopuplib to this component and sort out params
        var modalBody;
        
         $A.createComponent("c:Support_IssuesViewCreateNewAction", {"recordId":rowId,
                                                             "sObjectName" : "Action__c",
                                                             //"fieldsToDisplay": "Caller_Name__c",
                                                             "mode" : "edit"},
                           function(content, status) {
                               if (status === "SUCCESS") {
                                   modalBody = content;
                                   component.find('popuplib').showCustomModal({
                                      // header: header,
                                       body: modalBody, 
                                       showCloseButton: true
                                   })
        
                                 }
                               
                           });
    },               
                    //
   /*  handleShowModal: function(component, evt, helper,header,flag,recID,rowIndex) {
        var modalBody;
        $A.createComponent("c:Util_Datatable_Crud", {"flag":flag,"recID":recID,"rowIndex":rowIndex},
                           function(content, status) {
                               if (status === "SUCCESS") {
                                   modalBody = content;
                                   component.find('popuplib').showCustomModal({
                                       header: header,
                                       body: modalBody, 
                                       showCloseButton: true
                                   })
                                   
                               }
                               
                           });
    },           */
                   
 
})