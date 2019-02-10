({
    
    doInit:  function (component, event, helper) {
        console.log('multiselect init fire');
        console.log(' ChildID' + component.get("v.childID"));
        console.log(' contactID--> ' + component.get("v.contactID"));
        
    },
    
    onblur : function(component,event,helper){
        // on mouse leave clear the listOfSeachRecords & hide the search result component 
        component.set("v.listOfSearchRecords", null );
        component.set("v.SearchKeyWord", '');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
    },
    onfocus : function(component,event,helper){
        // show the spinner,show child search result component and call helper function
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        component.set("v.listOfSearchRecords", null ); 
        component.set("v.selectedLookUpRecordIDs", null ); 
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC 
        var getInputkeyWord = '';
        helper.searchHelper(component,event,getInputkeyWord);
    },
    
    keyPressController : function(component, event, helper) {
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        if(getInputkeyWord.length > 0){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchRecords", null ); 
            component.set("v.selectedLookUpRecordIDs", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
    },
    
    // function for clear the Record Selaction 
    clear :function(component,event,heplper){
        var selectedPillId = event.getSource().get("v.name");
        
        console.log(' ChildID' + component.get("v.childID"));
        console.log(' contactID--> ' + component.get("v.contactID"));
        var allPillsList = component.get("v.lstSelectedRecords"); 
        
        for(var i = 0; i < allPillsList.length; i++){
            if(allPillsList[i].Id == selectedPillId){
                allPillsList.splice(i, 1);
                component.set("v.lstSelectedRecords", allPillsList);
            }  
        }
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );  
        component.set("v.selectedLookUpRecordIDs", null ); 
    },
    
    // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
        component.set("v.SearchKeyWord",null);
        
        // get the selected object record from the COMPONENT event 	 
        var listSelectedItems =  component.get("v.lstSelectedRecords" );
        console.log('listSelectedItems= ' + listSelectedItems);
        
        var selectedAccountGetFromEvent = event.getParam("recordByEvent");
        console.log('selectedAccountGetFromEvent= ' + JSON.stringify(selectedAccountGetFromEvent));
        
        console.log('selectedAccountGetFromEvent Name= ' + selectedAccountGetFromEvent.Name);
        listSelectedItems.push(selectedAccountGetFromEvent);
        component.set("v.lstSelectedRecords" , listSelectedItems); 
        
        
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open'); 
    },
    
    handleChildIDEvent  : function(component, event, helper) {
        var contactID =  component.get("v.contactID");
        component.set("v.childID" , childIdIn); 
        var childID =  component.get("v.childID");
        var childIdIn = event.getParam("childID");
        component.set("v.childID" , childIdIn); 
    },
    
    handleTodaysOpenIssues : function(component, event, helper) {
        var allPillsIdList = [];
        var allPillsList = component.get("v.lstSelectedRecords"); 
        
        for(var i = 0; i < allPillsList.length; i++){
            console.log('allPillsList[i].Id =' + allPillsList[i].Id )
            allPillsIdList.push(allPillsList[i].Id );
            console.log('allPillsIdList length= ' + allPillsIdList.length);
        } 
        helper.addRelatedIssues(component, event, helper, allPillsIdList);
        
    },
    
    fireGetAvailableIssueTypesEvent : function(component, event, helper) {
        var myList =  component.get("v.excludedIssues");
        console.log('fire myList-->' + myList);
        var appEvent =$A.get("e.c:cOpenIssues");
        appEvent.setParams({"openIssuesList": myList}) ;
        appEvent.fire();
        console.log('fired app event '  )  
    },
    
})