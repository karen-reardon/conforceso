({
    doRefresh : function (component, helper) {
        let borrowerId = component.get("v.borrowerId");
        
        component.set("v.errorMessage",[]);

        if (!borrowerId) {
            helper.listLibraryItemCheckOutsResponse(component, []);            
        }
        else {
	        component.set("v.showSpinner",true);
            helper.listLibraryItemCheckOuts(component, borrowerId)
            .then(function(response) {
                helper.listLibraryItemCheckOutsResponse(component,response);
                component.set("v.showSpinner",false);
            })
            .catch(function(err){
                component.set("v.showSpinner",false);
                helper.handleError(component,err);
            })            
        }
    },
    
    listLibraryItemCheckOuts: function (component, borrowerId) {
        let action = component.get("c.cfsListCurrentLibraryItemCheckOuts");
        action.setParams({borrowerRecordId : borrowerId});
        let p = cfsExecuteAction(action)
        return p;        
    },
    listLibraryItemCheckOutsResponse: function (component, response) {
        component.set("v.libraryItemCheckOutList", response);            
    },
    
    handleError : function (component, err) {
        let errorMessage = component.get("v.errorMessage");
        errorMessage.push(err);
        component.set("v.errorMessage",errorMessage);
        cfsLog(err);
    },
    
    navigateTo : function (component, recordId) {
        cfsNavigateTo(recordId);
    }
})