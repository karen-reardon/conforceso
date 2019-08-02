trigger cfsLibraryItemCheckOut_Trigger on Library_Item_Check_Out__c (before insert, before update) {
    
    //This trigger is used to check for duplicate Check Outs
    
    //Get the list of Library Item Ids with Library Item Check Outs with a status of Checked Out/Overdue
    List<Id> requestedLibraryItemIds = new List<Id>();
    for (Library_Item_Check_Out__c libraryItemCheckOut : trigger.new) {
        if (libraryItemCheckOut.Check_Out_Status__c != 'Checked In') {
            requestedLibraryItemIds.add(libraryItemCheckOut.Library_Item__c);        
        }
    }
    
    //Get the list of unavailable Library Items that match a requested Library Item, indexed by the Library Item Id for lookup
    Map<Id,Library_Item__c> unavailableLibraryItems = new Map<Id,Library_Item__c>(
        [SELECT Id, Current_Check_Out__c, Availability_Status__c
         FROM Library_Item__c 
         WHERE Id IN :requestedLibraryItemIds AND Availability_Status__c != 'Available']);
    
    //Tag the record as an error if the requested Library Item Check Out is a duplicate of another Library Item Check Out
    for (Library_Item_Check_Out__c libraryItemCheckOut : trigger.new) {
        if (unavailableLibraryItems.ContainsKey(libraryItemCheckOut.Library_Item__c) && 
            (unavailableLibraryItems.get(libraryItemCheckOut.Library_Item__c).Current_Check_Out__c != libraryItemCheckOut.Id)) {
                libraryItemCheckOut.addError(
                    'Library Item "' + libraryItemCheckOut.Title__c + '"' + 
                    ' is unavailable. Reason: ' + 
                    '"' + unavailableLibraryItems.get(libraryItemCheckOut.Library_Item__c).Availability_Status__c + '"');
            }
    }
    
}