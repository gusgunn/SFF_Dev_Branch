({
	helperMethod : function(component) {
		component.find("createNew").getNewRecord(
        "Case",
        null,
        false,
        $A.getCallback(function() {
           // var rec = component.get("v.propertyRecord");
            var error = component.get("v.recordError");
            if (error || (rec === null)) {
                console.log("Error initializing record template: " + error);
                return;
            }
        })
    );

	}
})