({
	// fireGetAvailableIssueTypesEvent    
    doInit  : function(component, event, helper) {
      /*    helper.addSelectedHelper(component, event, tempIDs);
        var myList =  component.get("v.excludedIssues");
        var appEvent =$A.get("e.c:cOpenIssues");
        appEvent.setParams({"openIssuesList": myList}) ;
        appEvent.fire();
        console.log('fired app event '  )
        */
        
    },
    
    handleCreateRecord : function(component, event, helper) {
        const input = component.get("v.selectedLookUpRecords");
        //console.log('input' + component.get("v.selectedLookUpRecords"));
        const createRecordEvent = $A.get("e.c:IssueCreateRecord");
        createRecordEvent.setParam("recordName",input);
        createRecordEvent.fire();
    },
    
  /*  addSelected: function(component, event, helper) {
        // create array[list] type temp. variable for store child record's id's from selected checkboxes.  
        var tempIDs = [];
        var tempTypes =[]
        
        
        
        // get(find) all checkboxes with aura:id "checkBox"
        var getAllId = component.get("V.selectedLookUpRecords");
        // var getAllName = component.find("V.selectedLookUpRecords");
        console.log('selectedLookUpRecords= ' + getAllId);
        console.log('getAllIdLength= ' + getAllId.length);
        // play a for loop and check every checkbox values 
        // if value is checked(true) then add those Id (store in Text attribute on checkbox) in tempIDs var.
        for (var i = 0; i < getAllId.length; i++) {
            console.log('tempIdsLength' + getAllId.length);
            alert(getAllId[getAllId.length-1]);
            tempIDs.push(getAllId[i].label); 
            console.log(getAllId[i]);
            console.log('tempIds' + tempIDs + i);
            //tempTypes.push(getAllName[i].get("v.title"));
            
            // const createRecordEvent = $A.get("e.c:IssueCreateRecord");
            // createRecordEvent.setParam("recordName", tempIDs);
            // createRecordEvent.setParam("recordName", getAllName[i].get("v.title"));
            //  createRecordEvent.fire();
            //}
        }
         
        helper.addSelectedHelper(component, event, tempIDs);
        
    }, 
     fireApplicationEvent : function(component, event, helper) {
        var myList =  component.get("v.ChildRecordList");
        
        var appEvent =$A.get("e.c:cOpenIssues");
        appEvent.setParams({"openIssuesList": myList}) ;
        appEvent.fire();
        console.log('fired app event '  )
        
        
    },*/
    fireGetAvailableIssueTypesEvent : function(component, event, helper) {
        var myList =  component.get("v.selectedLookUpRecords");
        var appEvent =$A.get("e.c:cOpenIssues");
        appEvent.setParams({"openIssuesList": myList}) ;
        appEvent.fire();
        console.log('fired app event '  )
        
        
    },
})