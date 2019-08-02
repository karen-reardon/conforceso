({       
    handleRefresh : function (component, event, helper){
        helper.doRefresh(component, helper);
	},
          
    handleVisitClick: function(component, event, helper) {
        helper.navigateTo(component, event.getSource().get("v.value").toString());
    }
})