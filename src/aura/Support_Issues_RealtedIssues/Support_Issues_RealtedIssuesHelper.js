({
    loadRelatedIssues : function(component) {
        //var con = component.get("v.iss");
        var action = component.get("c.getAlreadyRelatedName");
        action.setStorable();
        action.setParams({
            intId: component.get("v.recordId"),
        });
        action.setCallback(this, function(response){
            component.set("v.relatedIssues", response.getReturnValue());
        });
        $A.enqueueAction(action);
    },
})