({
    doInit : function(component, event, helper){
     //   alert('int contact agency' + component.get('v.interactionContactAgency'));
    }, 
    
    onToggleIssueColumn: function(component, event, helper) {
        var params = event.getParams();
        console.log('viewIssue recieved  ' + params.rowId);
        component.set('v.issueId', params.rowId );
        component.set('v.issueName', params.Name );
        component.set('v.viewAction', false);
        component.set('v.viewIssue', true);
        var f = component.find("rtCol");
        var m = component.find("mainCol");
        if (m.get("v.size") == "12") {
            m.set("v.size", "8");
            $A.util.toggleClass(f, "slds-show");
        } else {
            component.set('v.viewIssue', false);
            m.set("v.size", "12");
            $A.util.toggleClass(f, "slds-hide");
        }
    },
    onToggleActionColumn: function(component, event, helper) {
        console.log('actionId recieved');
        var params = event.getParams();
        component.set('v.actionId', params.rowId )
        component.set('v.recordTypeId', params.recordTypeId )
        console.log(' params.recordTypeId ' +  params.recordTypeId);
        component.set('v.viewIssue', false);
        component.set('v.viewAction', true);
        var f = component.find("rtCol");
        $A.util.toggleClass(f, "slds-hide");
        var m = component.find("mainCol");
        if (m.get("v.size") == "12") {
            m.set("v.size", "8");
        } else {
            m.set("v.size", "12");
        }
    }
});