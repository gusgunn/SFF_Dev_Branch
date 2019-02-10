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
})