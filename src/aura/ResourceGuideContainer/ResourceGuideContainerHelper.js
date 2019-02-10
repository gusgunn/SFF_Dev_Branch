({
    searchHelper : function(component, event, helper) {
        console.log('issue ' + component.get('v.issueName'));
        console.log('SearchWord ' + component.get('v.searchWord'));
        console.log('Zip ' + component.get('v.zip'));
         console.log('conditionName ' + component.get('v.conditionName'));
        
        var action = component.get('c.fetchAvailableValues'); 
        action.setParams({
            'objectName' : component.get('v.objectAPIName'),
            'searchKeyWord': component.get('v.searchWord'),
            'accountName' : component.get('v.organizationName'),
            'issue' : component.get('v.issueName'),
            'zipCode' : component.get('v.zip'),
            'condition' : component.get('v.conditionName'),
        });  
        
        action.setCallback(this, function(response) {
            $A.util.removeClass(component.find('mySpinner'), 'slds-show');
            var state = response.getState();
            if (state === 'SUCCESS') {
                var storeResponse = response.getReturnValue();
             //   console.log('storeResponse -->' + JSON.stringify(storeResponse));
                if (storeResponse.length == 0) {
                    component.set('v.Message', 'No Records Found...');
                } else {
                    component.set('v.Message', '');
                }
                component.set('v.mydata', storeResponse); 
            }
        });  
        $A.enqueueAction(action);
     
    },
    refreshDatatable : function(component, event, helper) {
   		 component.set('v.mydata', []);
         helper.searchHelper(component, event, helper);
    }
})