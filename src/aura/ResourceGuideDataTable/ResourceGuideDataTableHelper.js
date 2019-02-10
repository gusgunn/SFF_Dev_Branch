// base_datatable helper file
({
  
    handleLookups : function(cmp, returnValue, helper) {
        var data = JSON.parse(JSON.stringify(returnValue).split('items').join('_children'));      
        if(data){
                 for (var i=0; i< data.length; i++ ) {
                     var row =data[i];     
                     if (row.Id && row.Name ){
                                       row.Name = row.Name;
                                       row.accounturl = "/one/one.app#/sObject/" + row.Id;
                                    }
                       
                  if (row.Id && row.Website ){
                                       row.websiteUrl = row.Website ;
                      					row.Website = 'Website' 
                                    }
                        }
                    cmp.set('v.mydata', data); 
                   }           
    },      
                        
    handleEditModal : function(cmp, rowId, helper) {
        // open modal 
     /*   var modalBody;
        $A.createComponent("c:base_datatableLookup", {"recordId": rowId,
                                                       "sObjectName" : cmp.get('v.objectName'),
                                                       "fieldsToDisplay": "AccountId",
                                                       "mode" : "edit"},
                           function(content, status) {
                               if (status === "SUCCESS") {
                                   modalBody = content;
                                   cmp.find('popuplib').showCustomModal({
                                      body: modalBody, 
                                       showCloseButton: true
                                   })
                               } 
                           });*/
    },  
                 
   // todo: incorperate this into CallApex.           
   saveChanges : function (cmp, draftValues) {
       var self = this;
       var action = cmp.get('c.updateAccounts');
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
                   self.handleGetData(cmp);
               }
           } else if (state === "ERROR") {
               var errors = response.getError();
               console.error(errors);
           }
       }));
       
       $A.enqueueAction(action);
   },  
   /**** Handle inline edits, prep draft values for save, resolve draft values and more***/     
                   
   handleEditCell : function (cmp, event) {
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
              
   getBuildedDraftValues : function (atomicChanges, lastChange) {
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
                        
   handleSaveInLocalStorage : function (cmp, event) {
       var checked = event.getParam('checked');
       localStorage.setItem('demo-save-local', JSON.stringify(checked));
       if (checked) {
           this.resolveSaveLocalStorage(cmp);
       } else {
           this.clearDraftValuesLS();
       }
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
    // set autosave default to true and try this out!
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
                        
/***** Sort columns and set widths *****/                     
    sortData : function (cmp, fieldName, sortDirection) {
        var data = cmp.get("v.mydata");
        var reverse = sortDirection !== 'asc';
        data = Object.assign([],
            data.sort(this.sortBy(fieldName, reverse ? -1 : 1))
        );
        cmp.set("v.mydata", data);
    },
    sortBy : function (field, reverse, primer) {
        var key = primer ?
            function(x) {return primer(x[field])} :
            function(x) {return x[field]};
        reverse = !reverse ? 1 : -1;
        return function (a, b) {
            return a = key(a)?key(a):'', b = key(b)?key(b):'', reverse * ((a > b) - (b > a));
        }
    },                    
    storeColumnWidths : function (widths) {
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
                        
 })