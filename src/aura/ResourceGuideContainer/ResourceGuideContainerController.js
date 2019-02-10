({
    doInit : function(component, event, helper) {
     helper.searchHelper(component, event, helper);
    },
    
    onSearchAll : function(component, event, helper) {
     helper.searchHelper(component, event, helper);
    },
    
    onSearchIssues : function(component, event, helper) {
        var getIssueType = event.getParam("stringToPass");
        var field = event.getParam("field");
   
      console.log('-----------Container Field lookup  ' + getIssueType );
        if(field=="Condition__c"){
               component.set("v.conditionName", getIssueType);
        } else{
               component.set("v.issueName", getIssueType);
        }
     
        helper.refreshDatatable(component, event, helper);
	},
    
    onSearchKeyChange: function(component, event, helper) {
        var getInputkeyWord = event.getParam("searchKey");
        var getField = event.getParam("field");
      	console.log('getField ' + getField );
        if(getInputkeyWord.length > 3) {
            //var vField = "v." + getField
            if(getField ==="BillingPostalCode"){
                 component.set("v.zip", getInputkeyWord);
                console.log('getInputkeyWord' + getInputkeyWord);
            }else{
                 var searchKey = '%' + getInputkeyWord;
                 component.set("v.searchWord", searchKey);
            }

            helper.searchHelper(component, event, helper);
        }
	},
     onResetOne : function(component, event, helper) {
        var getField = event.getParam("field");
          	console.log('getField ' + getField );
          if(getField ==="BillingPostalCode"){
                 component.set("v.zip", '');
              console.log('v.zip ' + component.get('v.zip') );
          }else{
                 component.set('v.searchWord', '');
          }
        helper.refreshDatatable(component, event, helper);
	},
    
      onRefresh : function(component, event, helper) {
        helper.refreshDatatable(component, event, helper);
	},
    
    onReset: function(component, event, helper) {
         component.set('v.searchWord', '');
         component.set('v.organizationName', '');
         component.set('v.issueName', '');
         component.set('v.conditionName', '');
         component.set('v.zip', '');
         component.find('searchBar').reset();
         component.find('lookup').reset();
         component.set('v.mydata', []);
         var appEvent = $A.get("e.c:evt_resetForm");
        	appEvent.fire()
        // helper.refreshDatatable(component, event, helper);
    }
})