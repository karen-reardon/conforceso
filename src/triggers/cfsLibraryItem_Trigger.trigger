trigger cfsLibraryItem_Trigger on Library_Item__c (before insert, before update) {
    
    //This trigger is used to check for duplicate barcodes because the standard unique error message is not user-friendly.
    
    //Get the list of barcodes for all the requested insert/updates
    List<String> requestedBarcodes = new List<String>();
    for (Library_Item__c libraryItems : trigger.new) {
        requestedBarcodes.add(libraryItems.Barcode__c);
    }
    
    //Get the list of existing Library Items that match a requested barcode, indexed by the barcode for lookup
    Map<String,Library_Item__c> duplicateBarcodes = new Map<String,Library_Item__c>();
    for (Library_Item__c libraryItem : 
         [SELECT Id, Name, Barcode__c 
          FROM Library_Item__c 
          WHERE Barcode__c IN :requestedBarcodes ]) {
              duplicateBarcodes.put(libraryItem.Barcode__c, libraryItem);
          }
    
    //Tag the record as an error if the requested barcode is a duplicate with another Library Item
    for (Library_Item__c libraryItem : trigger.new) {
        if (String.IsEmpty(libraryItem.Name)) {
                libraryItem.addError('Name is required');
        }
        if (duplicateBarcodes.ContainsKey(libraryItem.Barcode__c) && 
            (duplicateBarcodes.get(libraryItem.Barcode__c).Id != libraryItem.Id)) {
                libraryItem.addError(
                    'Duplicate barcodes are not allowed. Library Item "' + libraryItem.Name + '"' + 
                    ' has the same barcode as ' + 
                    '"' + duplicateBarcodes.get(libraryItem.Barcode__c).Name + '".');
            }
    }
    
}