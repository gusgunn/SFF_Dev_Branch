({
    doInit: function(component,event,helper){
        //add check if issue isopen and reload with it open
        console.log('IssuesAction__get fire - ' + component.get('v.interactionContact') );
        var interaction = component.get('v.interactionID')
        helper.loadIssues(component, interaction);
        console.log('IssuesActions IntId  -->' + interaction);
        var resp = component.get('v.issueList');
        helper.fetchRecordTypes(component, event, helper);
    },
   
    viewIssue : function(cmp, event) {
        var rowId =    event.getSource().get("v.value");
        //cmp.set('v.issId', rowId);
        console.log('viewIssue');
        let issueLabel = cmp.get('v.viewIssuelabel');
        if(issueLabel === 'View Issue Detail') {
        	cmp.set('v.viewIssuelabel', 'Close Issue Detail');
            cmp.set('v.viewIssue', false);
        }else {
            cmp.set('v.viewIssuelabel', 'View Issue Detail');
            cmp.set('v.viewIssue', true);
           
    	}
        var appEvent = $A.get("e.c:evtApp_Support_ActionDatatable_ViewIssueRecord");
        appEvent.setParams({ 
            rowId : rowId,
            buttonLabel :  cmp.get('v.viewIssuelabel')
            
        });
        appEvent.fire();
    },


  /*  openModal: function(component, event, helper) {
        var selectedRecordTypeName = event.getSource().getLocalId();
        component.set("v.selectedRecordTypeName",  selectedRecordTypeName) 
        helper.createInternalReferral(component, event, helper);  
    },*/
    
    openRecordTypeSelector: function(component, event, helper) {
        var issue = event.getSource().get("v.value");
        //console.log('pass issue in ' + JSON.stringify(issue)) ;
        component.set('v.selectedIssue', issue);
        component.set("v.isOpen", true);    
    },
    
    createNewAction: function (component, event, helper) {
        var action = component.find('recordTypePickList').get('v.value');
        var issue = component.get('v.selectedIssue');
       // alert('issueviewcont agencyname' + component.get("v.interactionContactAgency"));
        helper.handleSelectedRecordType(component, event, helper, issue, action); 
     
    },
    
    closeModal: function(component, event, helper) {
        // set "isOpen" attribute to false for hide/close model box 
        component.set("v.isOpen", false);
    },
    
    handleButtonClick: function (cmp, event, helper) {       
        var selectedButtonLabel = event.getSource().get("v.label");
        
    },
    
    gotoIssue: function (component, event, helper) {
        var link =    event.getSource().get("v.value");
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": link
        });
        navEvt.fire();
    },
    
     openSection : function(component, event, helper) {
        var tog = event.getSource().get("v.value");
       
     
        component.set('v.open', tog)
        console.log('tog---->' + tog);
        // helper.accordianToggler(component,event, link);
    },
    
    
    closeSection : function(component, event, helper) {
        var tog = event.getSource().get("v.value");
        // get highest index (total related issues)
        // get into the iteration
        // get iss.Actions__c 
        // if(tog+1)
        // if actions>0 
        // set to tog +1
        // else
        // check tog + 2
        // else ?
        component.set('v.open', tog+1)
        console.log('tog---->' + tog);
        // helper.accordianToggler(component,event, link);
    },
    
})