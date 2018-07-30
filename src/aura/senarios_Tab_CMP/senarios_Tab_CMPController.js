({
	switch_tab : function(component, event, helper) {
		var tabis = event.target.id;
       // alert(tabis);
        component.set("v.tabName",tabis);
	}
})