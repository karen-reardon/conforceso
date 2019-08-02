trigger cfsLibraryItemLimit_Trigger on Library_Item_Limit__c (before insert, before update) {
    
    //This trigger is used to check for duplicate categories because the standard unique error message is not user-friendly
    
    //Get the list of categories for all the requested inserts/updates
    List<String> requestedCategories = new List<String>();
    for (Library_Item_Limit__c libraryItemLimit : trigger.new) {
        requestedCategories.add(libraryItemLimit.Category__c);
    }
    
    //Get the list of existing Library Item Limits that match a requested category, indexed by the category for lookup
    Map<String,Library_Item_Limit__c> duplicateCategories = new Map<String,Library_Item_Limit__c>();
    for (Library_Item_Limit__c libraryItemLimit : 
         [SELECT Id, Name, Category__c 
          FROM Library_Item_Limit__c 
          WHERE Category__c IN :requestedCategories ]) {
              duplicateCategories.put(libraryItemLimit.Category__c, libraryItemLimit);
          }
    
    //Tag the record as an error if the requested category is a duplicate with another Library Item Limit
    for (Library_Item_Limit__c libraryItemLimit : trigger.new) {
        if (duplicateCategories.ContainsKey(libraryItemLimit.Category__c) && 
            (duplicateCategories.get(libraryItemLimit.Category__c).Id != libraryItemLimit.Id)) {
                libraryItemLimit.addError(
                    'Duplicate categories are not allowed. Library Item Limit has the same category as ' + 
                    '"' + duplicateCategories.get(libraryItemLimit.Category__c).Name + '".');
            }
    }
}