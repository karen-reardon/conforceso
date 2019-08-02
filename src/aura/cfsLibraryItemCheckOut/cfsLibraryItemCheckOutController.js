({
    doLoad : function(component, event, helper) {
        component.set("v.activeTab", "CheckOut");
        helper.doRefresh(component, helper);
    },
    
    handleKeyUp : function (component, event, helper) {
        let DELIMITERS = [13,88];

        //If delimiter keypress - process input
        if (DELIMITERS.includes(event.keyCode)) {                  
            let barcode = component.find("barcode");
            let barcodeValue = barcode.get("v.value");
            barcode.set("v.value","");
            if ((barcodeValue !== undefined) && (barcodeValue.length > 0)) {
                helper.processBarcode(component, helper, barcodeValue);
            }
        }
    },
    
    handleBorrowerChange : function (component, event, helper){
        component.set("v.borrowerId", component.find("borrower").get("v.value"));
        helper.doRefresh(component, helper);
	},

    handleTabSelect : function (component, event, helper) {
        component.set("v.activeTab", event.getSource().get('v.id'));
        helper.doRefresh(component, helper);
    },
    
    handleStartScan : function (component, event, helper) {
        helper.enableScan(component, helper);
    },
    
    handleRefresh : function (component, event, helper) {
        helper.doRefresh(component, helper);
    },
    
    handleBlur : function (component, event, helper) {
        helper.disableScan(component, helper);
    },  
    
})