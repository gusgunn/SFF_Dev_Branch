({
    navToNewContact :function(cmp, event, helper, idValue) {
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.openTab({
            recordId: idValue,
            focus: true
        }).then(function(response) {
            workspaceAPI.getTabInfo({
                tabId: response
            }).then(function(tabInfo) {
                console.log("The url for this tab is: " + tabInfo.url);
            });
        })
        .catch(function(error) {
            console.log(error);
        });
        cmp.find("popuplib").notifyClose();
        cmp.set("v.isOpen", false);
        
    },  
    
    handlePrefillForm : function(component,event, helper){
        let household = component.get("v.household");
        if (typeof household !== 'undefined'){
            component.find('household').set('v.value', household );     
        }
       
    },
    
    handleSubmit : function(component, event, helper){
    	var eventFields = event.getParam("fields");
        component.find('recordEditForm').submit(eventFields);
     },
    
  
})