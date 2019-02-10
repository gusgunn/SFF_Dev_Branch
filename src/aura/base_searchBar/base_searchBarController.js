({
    
    doInit : function(component, event, helper) {
        //   var getLabel = component.get('v.field');
        //  component.set('v.fieldOut', getLabel);
        
    },
    
    onSearchKeyChange: function(component, event, helper) {
        var getLabel = component.get('v.field');
        helper.handelSearchKeyChange(component, event, getLabel);
        
    },
    
    onReset : function(component, event, helper){
        component.set('v.value', '');
        var getLabel = component.get('v.field');
        helper.handelSearchKeyChange(component, event, getLabel);
    },
})