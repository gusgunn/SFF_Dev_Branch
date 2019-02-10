({
	refreshData : function(cmp,evt,hlp) {
		var appEvent = $A.get("e.c:dataTableUpdate");
            appEvent.setParam({
                "refreshMe" : "yes"
            });
            appEvent.fire();
            
	}
})