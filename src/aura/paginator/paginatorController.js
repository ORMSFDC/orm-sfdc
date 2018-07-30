({
    previousPage : function(component, event, helper) {
        var pageChangeEvent = component.getEvent('pageChangeAction');
        pageChangeEvent.setParams({ "direction": "previous"});
        pageChangeEvent.fire();
    },

    nextPage : function(component, event, helper) {
        var pageChangeEvent = component.getEvent('pageChangeAction');
        pageChangeEvent.setParams({ "direction": "next"});
        pageChangeEvent.fire();
    },

    doInit: function (component) {
    },

    reCalculate: function(component, event, helper) {
        var maxPages = component.get("v.maxPages");
      // alert(component.get("v.total"));
        var pages = Math.ceil(component.get("v.total") / component.get("v.pageSize"));
      // alert('pagesize '+component.get("v.pageSize"));
        component.set("v.pages", pages);
        var currPage = component.get("v.page");
        var pagePartition = Math.ceil(currPage/maxPages);

        var start = (pagePartition * maxPages) - maxPages + 1;
     //  alert('start '+start);
        var end = pagePartition * maxPages > pages ? pages :  pagePartition * maxPages;
       // alert('end  '+end);
        var a = [];
        for(var i = start; i <= end; i++) {
            a.push(i);
        }
     //   alert(a);
        component.set("v.navButtons",a);
    },

    goToPage: function (component, event, helper) {
        var pageNum = event.getSource().get("v.value");
        $A.util.toggleClass(event.getSource(), "slds-button--brand");

        var pageChangeEvent = component.getEvent('pageChangeAction');
        pageChangeEvent.setParams({ "direction": pageNum});
        pageChangeEvent.fire();
    }

})