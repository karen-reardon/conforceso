public class cfsLibraryItemController {
    
    //Checks out a Library Item
    //Library Item is found using the given barcode
    //		Validation:
    //			Borrower and Library Item (via barcode) must be specified
    //    		Library Item must be available - in circulation and not already be checked out
    //
    @AuraEnabled
    public static void cfsCheckOut (String barcode, String borrowerRecordId) {
        if (String.isEmpty(borrowerRecordId)) {
            throw new AuraHandledException('Select a borrower before checking out a Library Item');
        }
        Library_Item__c libraryItem;
        try {
            libraryItem = cfsLibraryItem.Get(barcode);
            
            if (libraryItem != null && cfsLibraryItem.IsAvailable(libraryItem.Availability_Status__c)) {
                cfsLibraryItemCheckOut.CheckOut(libraryItem.Id, borrowerRecordId);
            }
        }
        catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
        if (!cfsLibraryItem.IsAvailable(libraryItem.Availability_Status__c)) {
            throw new AuraHandledException('"' + libraryItem.Name + '" (' + libraryItem.Barcode__c + ') is not available for check out: ' + libraryItem.Availability_Status__c);
        }
    }
    
    //Checks in a Library Item
    //Library Item is found using the given barcode
    //		Validation:
    //			Library Item must be specified and exist
    //
    @AuraEnabled
    public static void cfsCheckIn (String barcode) {
    	Library_Item__c libraryItem;
        try {
            libraryItem = cfsLibraryItem.Get(barcode);
            
            if (libraryItem != null && libraryItem.Id != null) {
                cfsLibraryItemCheckOut.CheckIn(libraryItem.Id);                
            }
        }
        catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    //Returns a list of Checked Out Library Item Check Outs, including Overdue items, for a given Borrower
    //		Validation:
    //			Library Item must be specified and exist
    //    
    @AuraEnabled
    public static List<Library_Item_Check_Out__c> cfsListCurrentLibraryItemCheckOuts (String borrowerRecordId) {
        List<Library_Item_Check_Out__c> libraryItemCheckOuts = new List<Library_Item_Check_Out__c>();
        if (String.isEmpty(borrowerRecordId)) {
            return libraryItemCheckOuts;
        }
        try {
            
            List<String> checkedOutStatuses = new List<String>{cfsLibraryItemCheckOut.CHECKED_OUT, cfsLibraryItemCheckOut.OVERDUE};
                libraryItemCheckOuts = cfsLibraryItemCheckOut.GetList(borrowerRecordId, checkedOutStatuses);
            return libraryItemCheckOuts;
        }
        catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage());
        }
    }
}