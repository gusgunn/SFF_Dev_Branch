({
    loadIssues : function(component, inter) {
        console.log('in helper ');
        var action = component.get('c.getRelatedIssue');
        
        action.setParams({
            "intId" : component.get('v.interactionID')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                var tempJson = JSON.parse(JSON.stringify(data).split('items').join('_children'));
                
                if(tempJson){
                    for (var i=0; i< tempJson.length; i++ ) {
                        var row =tempJson[i];
                        if (row.Name  ){
                            row.IssName = row.Name;
                        }
                    }
                    component.set('v.issueList', tempJson);
                   // console.log('issueList-->  ' + JSON.stringify(data));
                }
            }else{
                alert('ERROR...');
            }
        });
        $A.enqueueAction(action);	
    },
    
    fetchRecordTypes : function (component, event, helper){
        var action = component.get("c.fetchRecordTypeMap");
        action.setParams({
            "objectName" : "Action__c"
        });
        action.setCallback(this, function(response) {
            var mapOfRecordTypes = response.getReturnValue();
            component.set("v.mapOfRecordTypes", mapOfRecordTypes);
            var lstOfRecordTypes = [];
            for (var key in  mapOfRecordTypes) {
                lstOfRecordTypes.push(mapOfRecordTypes[key]);
            }
            if (lstOfRecordTypes.length == 0){
            }else{
                component.set("v.lstOfRecordTypes" , lstOfRecordTypes);
            }  
        });
        $A.enqueueAction(action);
    },
    
    handleSelectedRecordType : function(component, event, helper, issue, action){
        //add isEmpty
      //component.set("v.isOpen", false);
        if(action !=''){
            console.log('selectedRecordTypeName not null--> ' + action); 
            var selectedRecordTypeMap = component.get("v.mapOfRecordTypes");
            var selectedRecordTypeId;
            for(var key in selectedRecordTypeMap){
                
                if(action == selectedRecordTypeMap[key]){
                    console.log('selectedRecordTypeKey--> ' + selectedRecordTypeMap[key]);
                    selectedRecordTypeId = key;
                    break; 
                }
            }
            
            helper.handleShowActionModal(component, event, helper, issue, selectedRecordTypeId, action)
            component.set("v.isOpen", false);
        }else{
            alert('You did not select a record type');   
        }    
        
    },
    
    handleShowActionModal: function(component, event, helper, issue, selectedRecordTypeId, recordTypename) {
        console.log('RecordTypeId--> ' + selectedRecordTypeId);
        console.log('--> '  + ' issue ' + issue.Type_of_Issue__c);
        console.log('--> '  + ' issue ' + issue.Caller_Org__c);
        var header = "New " + recordTypename + " For Issue: " + issue.Type_of_Issue__c;
        var modalBody;
        $A.createComponent("c:Support_IssuesViewCreateNewAction", {
            "recordType" : selectedRecordTypeId,
            "recTypeName" : recordTypename,
            "childId" : issue.Issue_Contact__c, 
            "issue": issue.Id,
            "issueType" : issue.Type_of_Issue__c,
            "interactionContactAgency" : component.get("v.interactionContactAgency"),
            "interactionContact" : component.getReference("v.interactionContact")
            // "interactionTime" : component.getReference("v.interactionTime")  
        },
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
        
    },  
    
    accordianToggler : function(component,event, link) {
        //docment ref has got to go!
        var acc = document.getElementById("!iss.Name");
        console.log('acc' + acc);
        for(var cmp in acc) {
            $A.util.toggleClass(acc[cmp], 'slds-show');  
            $A.util.toggleClass(acc[cmp], 'slds-hide');  
        }
    },
})