({
    doRefresh: function (component, helper) {
        component.set("v.errorMessage",[]);
        component.set("v.counter",0);
        helper.enableScan(component, helper);
    	component.find("currentLibraryItemCheckOutList").refresh();
    },

    enableScan: function (component, helper) {
        component.set("v.scanState", true);
        component.find("barcode").focus();        
    },
    
    disableScan: function (component, helper) {
        component.set("v.scanState", false);
    },

    processBarcode: function (component, helper, barcodeValue) {
        try {            
            let activeTab = component.get("v.activeTab");
            let borrowerId = component.find("borrower").get("v.value");
            switch (activeTab) {
                case "CheckOut" : {
                    helper.checkOutLibraryItem(component, barcodeValue, borrowerId)
                    .then(function(response) {
                        helper.incrementCounter(component);
                    })
                    .catch(function(err){
                        helper.handleError(component,err);
                    })
                    break;
                }                        
                case "CheckIn" : {
                    helper.checkInLibraryItem(component, barcodeValue, borrowerId)
                    .then(function(response) {
                        helper.incrementCounter(component);
                    })
                    .catch(function(err){
                        helper.handleError(component,err);
                    })
                    break;
                }
                default: {
                    cfsLog("Internal Error: handleKeyPress unexpectedly triggered");                        
                }
            }
        }
        catch (ex) {
            helper.handleError(component, ex);
        }
    },
    
    checkOutLibraryItem: function (component, barcodeValue, borrowerId) {
        let action = component.get("c.cfsCheckOut");
        action.setParams({barcode : barcodeValue, borrowerRecordId : borrowerId});
        let p = cfsExecuteAction(action)
        return p;
    },    

    checkInLibraryItem: function (component, barcodeValue, borrowerId) {
        let action = component.get("c.cfsCheckIn");
        action.setParams({barcode : barcodeValue});
        let p = cfsExecuteAction(action)
        return p;
    },

    incrementCounter: function (component) {
       component.set("v.counter", component.get("v.counter")+1);
    },
    
    handleError: function (component, err) {
        let errorMessage = component.get("v.errorMessage");
        errorMessage.push(err);
        component.set("v.errorMessage",errorMessage);
        cfsLog(err);
    },    
})