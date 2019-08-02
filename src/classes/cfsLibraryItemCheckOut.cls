public with sharing class cfsLibraryItemCheckOut {
    
    public static final String CHECKED_IN = 'Checked In';
    public static final String CHECKED_OUT = 'Checked Out';
    public static final String OVERDUE = 'Overdue';
    
    //Checks out a Library Item by creating a Library Item Check Out record
    //Borrower and Library Item must be specified and exist
    //		Defaults:
    //			Check Out Status is defaulted to the 'Checked Out' by field definition
    //			Checked Out Time is defaulted to current time by field definition
    //
    public static void CheckOut (ID libraryItemRecordId, ID borrowerRecordId) {
        Library_Item_Check_Out__c libraryItemCheckOut = new Library_Item_Check_Out__c();
        try {            
            libraryItemCheckOut.Library_Item__c = libraryItemRecordId;
            libraryItemCheckOut.Borrower__c = borrowerRecordId;
            
            insert libraryItemCheckOut;
        }
        catch (Exception ex) {
            throw new cfsLibraryException('Library Item Check Out creation failed', ex);
        }
    }
    
    //Checks in a Library Item Check Out by setting the 'Checked In Time' to the current time 
    //for any 'Checked Out' Library Item Check Out records for the given Library Item
    //Note: Before Insert and Before Update triggers validate that only one 'Checked Out' Library Item Check Out record exists for a Library Item
    //Borrower is not required. Library Item must be specified and exist
    //
    public static void CheckIn (ID libraryItemRecordId) {
        List<Library_Item_Check_Out__c> libraryItemCheckOuts = new List<Library_Item_Check_Out__c>();
        try {
	        if (String.isEmpty(libraryItemRecordId)) {
    	        throw new cfsLibraryException('Invalid Library Item Id');
        	}
            libraryItemCheckOuts = [SELECT Id FROM Library_Item_Check_Out__c 
                                    WHERE (Library_Item__c = :libraryItemRecordId 
                                           AND Check_Out_Status__c != :CHECKED_IN)];
            if ((libraryItemCheckOuts != null) && (!libraryItemCheckOuts.isEmpty())) {
                for (Library_Item_Check_Out__c libraryItemCheckOut : libraryItemCheckOuts) {
                    libraryItemCheckOut.Check_In_Time__c = Datetime.now();
                }
                update libraryItemCheckOuts;
            }
        }
        catch (Exception ex) {
            throw new cfsLibraryException('Library Item Check In failed', ex);            
        }
    }
    
    //Returns a list of Library Item Check Outs for the given Borrower that have a Checked Out Status in the given status list
    //Borrower must exist. Status list must not be NULL
    //    
    public static List<Library_Item_Check_Out__c> GetList (String borrowerRecordId, List<String> checkOutStatusList) {
        List<Library_Item_Check_Out__c> libraryItemCheckOuts = new List<Library_Item_Check_Out__c>();
        try {
            libraryItemCheckOuts = [SELECT Id, Name, Title__c, Borrower__c, Library_Item__c, Check_Out_Status__c, Due_Back_Time__c 
                                    FROM Library_Item_Check_Out__c 
                                    WHERE (borrower__c = :borrowerRecordId
                                           AND Check_Out_Status__c IN :checkOutStatusList)];            
            return libraryItemCheckOuts;
        }
        catch (Exception ex) {
            throw new cfsLibraryException('Library Item Check List failed', ex);                        
        }
    }
}