({
	 changePath : function(component, event, helper) {
        var stepNameOld = event.getParam("oldValue");
        var stepNameNew = component.get('v.pathStep');
        
        var toggleIndicatorCurrent = component.find(stepNameOld);
        $A.util.removeClass(toggleIndicatorCurrent,'slds-tabs--path__item slds-is-current');
        $A.util.addClass(toggleIndicatorCurrent,'slds-tabs--path__item slds-is-complete');
        
        var toggleIndicatorNext = component.find(stepNameNew);
        var toggleIndicatorAhead = parseInt(stepNameNew) + 1;
        
        $A.util.removeClass(toggleIndicatorNext, 'slds-tabs--path__item slds-is-complete');
        $A.util.addClass(toggleIndicatorNext,'slds-tabs--path__item slds-is-current');
        
    },
    fireApplicationEvent : function(component) {
        var intId = component.get('v.recordId');
        var appEvent =$A.get("e.c:aeEvent");
        appEvent.setParams({"message": intId }) ;
        appEvent.fire();	
	},
})