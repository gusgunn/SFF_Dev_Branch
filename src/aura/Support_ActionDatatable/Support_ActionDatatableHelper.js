// base_dataTableWithEdit Helper file

({
    handleGetData: function(cmp) {
        //call aura method from service component:
        cmp.find("service").callApex(cmp, "c.getContacts", {}, this.handleLookups);
    }, 
    
    handleLookups: function(cmp, returnValue, helper) {
        // flatten data
        
        var data = JSON.parse(JSON.stringify(returnValue).split('items').join('_children'));      
        if(data){
            for (var i=0; i< data.length; i++ ) {
                var row =data[i];     
               if (row.ContactId && row.Contact.Name ){
                    row.ContacttId = row.Contact.Name;
                    row.Contacturl = "/one/one.app#/sObject/" + row.Contact.Id;
                    row.classname ="";
                }
          
                if (row.Referral_Organization__c && row.Referral_Organization__r.Name ){
                     row.Referral_Organization__c = row.Referral_Organization__r.Name;
                     row.orgUrl = "/one/one.app#/sObject/" + row.Referral_Organization__r.Id;
                                   // console.log(row.Referral_Organization__c);
                                    
                }
                
                if (row.RecordTypeId && row.RecordType.Name ){
                     if(row.RecordType.Name.includes('Internal') ){
                                     row.RecordTypeName = 'Internal' ; 
                        			 row.RecordTypeId = row.RecordTypeId
                     } else if(row.RecordType.Name.includes('External') ){
                                    row.RecordTypeName = 'External' ; 
                        			row.RecordTypeId = row.RecordTypeId
                                        
                     } else if(row.RecordType.Name.includes('Check-In') ){
                                    row.RecordTypeName = 'Check-In' ; 
                          			row.RecordTypeId = row.RecordTypeId
                     } else {
                        		   row.RecordTypeName = row.RecordType.Name;
                                    row.RecordTypeId = row.RecordTypeId
                                  
                     }
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

            data.forEach(row => {
                row.actionUrl = "/one/one.app#/sObject/" + row.Id;
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
                $A.createComponent("c:Support_ActionDatatable_RecordForm", {"recordId": rowId,
                                                                  "sObjectName" : "Action__c",
                                                                  "fieldsToDisplay": "Id",
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
                    row.Caller_Name__c = name;
                    row.callerUrl = "/one/one.app#/sObject/" + newId;
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
                
      saveChanges : function (cmp, draftValues) {
                    var self = this;
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
                                self.clearDraftValuesLS();
                                self.handleGetData(cmp);
                            }
                        } else if (state === "ERROR") {
                            var errors = response.getError();
                            console.error(errors);
                        }
                    }));
                    
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
               //alert('add code here');    
      },
                
   /*   onViewAction: function(component, event, helper) {
      
      console.log('viewaction recieved');
      //component.set('v.isOpen', true);
    var f = component.find("rtCol");
    $A.util.toggleClass(f, "slds-hide");
    var m = component.find("mainCol");
    if (m.get("v.size") == "12") {
      m.set("v.size", "8");
    } else {
      m.set("v.size", "12");
    }
  }

      toggleCol : function (cmp,event,helper) {
                    var btn = cmp.find("newButton");
                    var tmp = btn.get("v.label") ;
                    ((tmp == "New") ? btn.set("v.label", "Close") : btn.set("v.label", "New"));
                    var event = $A.get("e.c:toggleColumn");
                    event.fire();
                },     
                 */
                
                
      handleActionEditModal : function(component, rowId, helper) {
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

            
})