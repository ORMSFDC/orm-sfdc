({
	myAction : function(component, event, helper) {
		
        var a=component.get("v.id");
       // alert(a)
       component.set('v.show_success',true);
        component.set('v.show_success1',a);
	},
    alertmsg : function(component, event, helper) {
		
        var a=component.get("v.value");
        alert(a)},
     handleValueChange : function (component, event, helper) {
        alert('a handle value change')
        console.log("old value: " + event.getParam("oldValue"));
        console.log("current value: " + event.getParam("value"));
    }
})