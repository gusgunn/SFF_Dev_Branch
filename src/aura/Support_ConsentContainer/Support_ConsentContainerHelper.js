({
    handleGetData: function(cmp) {
        //call aura method from service component:
        cmp.find("service").callApex(cmp, "c.getDatatableData", 
                                     {
                                         "soqlFilterId": cmp.get("v.filterId"),
                                     }, 
                                     this.datasuccess);
    }, 
    datasuccess: function(cmp, returnValue, helper) {
        // flatten data
        var data = JSON.parse(JSON.stringify(returnValue).split('items').join('_children'));      
        if(data){
            for (var i=0; i< data.length; i++ ) {
                var row =data[i];     
                if (row.Organization__c && row.Organization__r.Name ){
                    row.Organization__c = row.Organization__r.Name;
                    row.orgUrl = "/one/one.app#/sObject/" + row.Organization__r.Id;
                    row.classname ="";
                }
                
                if (row.Professional_Contact__c && row.Professional_Contact__r.Name ){
                    row.Professional_Contact__c = row.Professional_Contact__r.Name;
                    row.profUrl = "/one/one.app#/sObject/" + row.Professional_Contact__r.Id;
                    row.classname ="";
                }
                
                if (row.Child__c && row.Child__r.Name ){
                    row.Child__c = row.Child__r.Name;
                    row.childUrl = "/one/one.app#/sObject/" + row.Child__r.Id;
                    row.classname ="";
                }
            }
            data.forEach(row => {
                row.recordUrl = "/one/one.app#/sObject/" + row.Id;
            });
                cmp.set('v.mydata', data); 
                cmp.set('v.errors', []);
                cmp.set('v.draftValues', []);
                cmp.set('v.atomicChanges', []);
                cmp.set('v.changeIndex', 0);
                
            }           
            }, 
                handleEditModal : function(cmp,  rowId, rowIndex, row, helper) {
                    var modalBody;
                    $A.createComponent("c:base_datatableRecordForm", {"recordId": rowId,
                                                                      "sObjectName" : "Consent__c",
                                                                      "fieldsToDisplay": "Organization__c",
                                                                      "rowinfo" : rowIndex,
                                                                      "mode" : "edit"},
                                       function(content, status) {
                                           if (status === "SUCCESS") {
                                               modalBody = content;
                                               cmp.find('popuplib').showCustomModal({
                                                   body: modalBody, 
                                                   showCloseButton: true
                                               })  
                                           } 
                                       });
                }, 
                dataRecieved : function(cmp, event, helper) { 
                    var data = cmp.get('v.mydata');
                    var params = event.getParams();
                    var selectedRowId = params.rowId;
                    var newId =params.refreshMe;
                    var rowIndex = params.myIndex;
                    cmp.find("recordLoad").callRecordLoader(cmp, 
                                                            { "recordId" :  newId,
                                                             "selectedRowId" : selectedRowId,
                                                             "rowIndex" :  rowIndex
                                                            });
                },
                handleUpdateUI : function(cmp, Id, newId, name, rowIndex) {
                    var data = cmp.get('v.mydata');
                    var row = data[rowIndex];
                    row.Organization__c = name;
                    row.orgUrl = "/one/one.app#/sObject/" + newId;
                    row.classname ="slds-cell-edit slds-is-edited";
                    cmp.set('v.mydata', data);
                },  
                handleEditCell : function (cmp, event, helper) {
                    var saveLocalStorage = cmp.get('v.saveLocalStorage');
                    var atomicChanges = cmp.get('v.atomicChanges');
                    var lookupChange = cmp.get('v.lookupChanges');
                    if (saveLocalStorage) {
                        var atomicChange = event.getParam('draftValues');
                        if(atomicChange){
                            atomicChanges.push(atomicChange);
                        } else {  
                            atomicChanges.push(lookupChange);
                        }
                        cmp.set('v.changeIndex', atomicChanges.length);  
                        cmp.set('v.lookupChanges', []);                   
                        cmp.set('v.atomicLookups', atomicChanges)
                        var draftValues = this.getBuildedDraftValues(atomicChanges, atomicChanges.length); 
                        cmp.set('v.draftValues', draftValues);
                        localStorage.setItem('demo-draft-values', atomicChanges);
                    }
                    if (cmp.get('v.autoSaveEnabled')) {
                        this.saveChanges(cmp, draftValues);
                    }
                },           
                getBuildedDraftValues : function (atomicChanges, lastChange) {      
                    //merge all with same id into same row
                    var draftValues = [];
                    var mergeChange = function (change, draft) {
                        console.log('change  ' + JSON.stringify(change) + '  draft ' + JSON.stringify(draft));
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
                
                saveChanges: function (cmp, draftValues) {
                    var self = this;
                    var action = cmp.get('c.updateDatatable');
                    
                    action.setParam("draftValues", draftValues);
                    action.setCallback(this, function (response) {
                        var state = response.getState();
                        
                        if (state === "SUCCESS") {
                            var returnValue = response.getReturnValue();
                           
                            var code = response.getReturnValue().code;
                            var message = returnValue.message;
                            message = message.replace(",", "");
                            message = message.replace("&quot;", ""); //replace(/& quot;/g,'')*/
                            
                           // cmp.set('v.errors', message);
                            //alert('error', cmp.get('v.errors'));
                            self.notifications.showToast({
                                variant:  code,
                                title: code,
                                message: message,
                            });
                             if(code != 'error'){
                            cmp.set('v.errors', []);
                            cmp.set('v.draftValues', []);
                            cmp.set('v.atomicChanges', []);
                            cmp.set('v.changeIndex', 0);
                            self.clearDraftValuesLS();
                            self.handleGetData(cmp);
                             }
                        } else if (state === "ERROR") {
                            var errors = response.getError();
                            console.error(errors);
                        }
                    });
                    
                    $A.enqueueAction(action);
                },
               
                resolveDraftValues : function (cmp) {
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
                clearDraftValuesLS : function () {
                    localStorage.setItem('demo-draft-values', JSON.stringify([]));
                    
                }, 
                resetLocalStorage : function () {
                    localStorage.setItem('datatable-in-action', null);
                },
                resolveSaveLocalStorage : function (cmp) {
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
                handleSaveInLocalStorage : function (cmp, event) {
                    var checked = event.getParam('checked');
                    localStorage.setItem('demo-save-local', JSON.stringify(checked));
                    if (checked) {
                        this.resolveSaveLocalStorage(cmp);
                    } else {
                        this.clearDraftValuesLS(cmp);
                        // need to reload?with sorting same?
                    }
                },
                handleAutoSaveChange : function (cmp, event) {
                    var checked = event.getParam('checked');
                    localStorage.setItem('demo-autosave', JSON.stringify(checked));
                },  
                resolveAutoSaveValue : function (cmp) {
                    //debugger
                    var localStorageValue = localStorage.getItem('demo-autosave');
                    
                    try {
                        var saveLocalStorage = JSON.parse(localStorageValue);
                        if(saveLocalStorage) {
                            cmp.set('v.autoSaveEnabled', saveLocalStorage);   
                        }            
                    } catch (e) {
                        cmp.set('v.autoSaveEnabled', false);
                    }
                },   
                deleteRec : function (cmp,event,helper) {
                    //console.log("fired");
                    var tmp = cmp.find("recHandler");
                    tmp.deleteRecord();
                },
                editRowStatus: function (cmp, row) {
                    var data = cmp.get('v.mydata');
                    data = data.map(function(rowData) {
                        if (rowData.id === row.id) {
                            switch(row.status) {
                                case 'Pending':
                                    rowData.status = 'Approved';
                                    rowData.actionLabel = 'Complete';
                                    break;
                                case 'Approved':
                                    rowData.status = 'Complete';
                                    rowData.actionLabel = 'Close';
                                    break;
                                case 'Complete':
                                    rowData.status = 'Closed';
                                    rowData.actionLabel = 'Closed';
                                    rowData.actionDisabled = true;
                                    break;
                                default:
                                    break;
                            }
                        }
                        return rowData;
                    });
                    cmp.set("v.mydata", data);
                },
                showRowDetails : function(row) {
                    
                },
                
                toggleCol : function (cmp,event,helper) {
                    var btn = cmp.find("newButton");
                    var tmp = btn.get("v.label") ;
                    ((tmp == "New") ? btn.set("v.label", "Close") : btn.set("v.label", "New"));
                    var event = $A.get("e.c:toggleColumn");
                    event.fire();
                },                
                sortData : function (cmp, fieldName, sortDirection) {
                    var data = cmp.get("v.mydata");
                    var reverse = sortDirection !== 'asc'; 
                    data = Object.assign([], data.sort(this.sortBy(fieldName, reverse ? -1 : 1))
                                        );
                    cmp.set("v.mydata", data);
                },
                sortBy: function (field, reverse, primer) {
                    var key = primer ?
                        function(x) {return primer(x[field])} :
                    function(x) {return x[field]};
                    reverse = !reverse ? 1 : -1;
                    return function (a, b) {
                        return a = key(a)?key(a):'', b = key(b)?key(b):'', reverse * ((a > b) - (b > a));
                    }
                },
                storeColumnWidths: function (widths) {
                    localStorage.setItem('datatable-in-action', JSON.stringify(widths));
                },
                getColumnWidths : function () {
                    var widths = localStorage.getItem('datatable-in-action');
                    
                    try {
                        widths = JSON.parse(widths);
                    } catch(e) {
                        return [];
                    }
                    return Array.isArray(widths) ? widths : [];
                },
                
                activateContact: function (cmp, row) {
                    var rows = cmp.get('v.data');
                    var rowIndex = rows.indexOf(1);
                    rows[rowIndex]['isActive'] = true;
                    rows[rowIndex]['active'] = 'Active';
                    cmp.set('v.data', rows);
                },
                deactivateContact: function (cmp, row) {
                    var rows = cmp.get('v.data');
                    var rowIndex = rows.indexOf(row);
                    rows[rowIndex]['isActive'] = false;
                    rows[rowIndex]['active'] = 'Inactive';
                    cmp.set('v.data', rows);
                },
                
                
            })