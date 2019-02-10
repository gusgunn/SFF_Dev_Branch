({
	onSuccess: function (component, event, helper) {
		var evt = $A.get("e.c:evtApp_dataTableOriginal_toContact");
		evt.setParams({
			"message": component.get('v.recordId')
		});
		evt.fire();
	},
	onPrefillForm: function (component, event, helper) {
		var tmpId = event.getParam("message");
		var form = component.find('recordFormView');
		form.set('v.recordId', tmpId);
	}
})