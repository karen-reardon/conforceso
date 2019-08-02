@isTest
public class cfsLibraryItemCheckOut_Test {

    static testMethod void Execute() {
        
        Library_Item__c libraryItem;
        Library_Item_Check_Out__C libraryItemCheckOut;
        User borrower;
                
        //Load Test Data
        try {
        	insert new Library_Settings__c(Barcode_Prefix__c='3119');
        	insert new Borrowing_Period__c(AV_Equipment_Interval__c = 5, Book_Interval__c=14);
        	borrower = [SELECT Id FROM User WHERE Alias = 'starly'];

            libraryItem = new Library_Item__c();
            libraryItem.Name = 'Crime and Punishment';
            libraryItem.Barcode__c = '33119777777777';
            libraryItem.Circulation_Status__c = 'Retired';
            insert libraryItem;
            
            libraryItem = new Library_Item__c();
            libraryItem.Name = 'Pride and Prejudice';
            libraryItem.Barcode__c = '33119888888888';
            insert libraryItem;
            
            libraryItem = new Library_Item__c();
            libraryItem.Name = 'War and Peace';
            libraryItem.Barcode__c = '33119999999999';
            insert libraryItem;

        }        
        catch (Exception ex) {
            System.Assert(false, ex.getMessage());        	
        }
        
        //Positive Tests

        //1. Check Out Available item
        try {
        	libraryItem =[SELECT ID from Library_Item__c WHERE Barcode__c = '33119888888888'];
        	cfsLibraryItemCheckOut.CheckOut(libraryItem.Id, borrower.Id);

			libraryItemCheckOut = [SELECT Id, Library_Item__c, Borrower__c, Check_Out_Status__c FROM Library_Item_Check_Out__c WHERE Library_Item__c = :libraryItem.Id AND Borrower__c = :borrower.Id];        	
            
            System.assertEquals(libraryItem.Id, libraryItemCheckOut.Library_Item__c);       
            System.assertEquals(borrower.Id, libraryItemCheckOut.Borrower__c);       
            System.assertEquals('Checked Out', libraryItemCheckOut.Check_Out_Status__c);     
        }
        catch (Exception ex) {
            System.Assert(false, ex.getMessage());
        }
        
        //2. Check In valid item
        try {
        	libraryItem =[SELECT ID from Library_Item__c WHERE Barcode__c = '33119888888888'];
        	cfsLibraryItemCheckOut.CheckIn(libraryItem.Id);

			libraryItemCheckOut = [SELECT Id, Library_Item__c, Borrower__c, Check_Out_Status__c FROM Library_Item_Check_Out__c WHERE Library_Item__c = :libraryItem.Id AND Borrower__c = :borrower.Id];        	
            
            System.assertEquals(libraryItem.Id, libraryItemCheckOut.Library_Item__c);            
            System.assertEquals(borrower.Id, libraryItemCheckOut.Borrower__c);            
            System.assertEquals('Checked In', libraryItemCheckOut.Check_Out_Status__c);     
        }
        catch (Exception ex) {
            System.Assert(false, ex.getMessage());
        }
        
        //3. Valid List
        try {
	        List<String> statuses = new List<String>{cfsLibraryItemCheckOut.CHECKED_OUT, cfsLibraryItemCheckOut.OVERDUE, cfsLibraryItemCheckOut.CHECKED_IN};
        	List<Library_Item_Check_Out__c> libraryItemCheckOutList = cfsLibraryItemCheckOut.GetList(borrower.Id, statuses);
            
            System.assertEquals(1, libraryItemCheckOutList.size());     
        }
        catch (Exception ex) {
            System.Assert(false, ex.getMessage());
        }
        

        //Negative Tests

        //1. Check Out duplicate item
        try {            
        	libraryItem =[SELECT ID from Library_Item__c WHERE Barcode__c = '33119888888888'];
        	cfsLibraryItemCheckOut.CheckOut(libraryItem.Id, borrower.Id);
        	libraryItem =[SELECT ID from Library_Item__c WHERE Barcode__c = '33119888888888'];
        	cfsLibraryItemCheckOut.CheckOut(libraryItem.Id, borrower.Id);
           
            System.Assert(false, 'Duplicate check out not rejected');            
        }
        catch (Exception ex) {
            System.Assert(true, ex.getMessage());
        }        

        //2. Check Out Unavailable item
        try {            
        	libraryItem =[SELECT ID from Library_Item__c WHERE Barcode__c = '33119777777777'];
        	cfsLibraryItemCheckOut.CheckOut(libraryItem.Id, borrower.Id);
            
            System.Assert(false, 'Unavailable check out not rejected');            
        }
        catch (Exception ex) {
            System.Assert(true, ex.getMessage());
        }        

        //3. Check Out invalid Library Item
        try {            
        	cfsLibraryItemCheckOut.CheckOut(NULL, borrower.Id);
            
            System.Assert(false, 'Invalid library item not rejected');            
        }
        catch (Exception ex) {
            System.Assert(true, ex.getMessage());
        }        

        //4. Check Out invalid borrowerId
        try {            
        	libraryItem =[SELECT ID from Library_Item__c WHERE Barcode__c = '33119999999999'];
        	cfsLibraryItemCheckOut.CheckOut(libraryItem.Id, NULL);
            
            System.Assert(false, 'Invalid borrowerid get not rejected');            
        }
        catch (Exception ex) {
            System.Assert(true, ex.getMessage());
        }        

        //5. Check In invalid Library Item
        try {            
        	cfsLibraryItemCheckOut.CheckIn(NULL);
            
            System.Assert(false, 'Invalid library item not rejected');            
        }
        catch (Exception ex) {
            System.Assert(true, ex.getMessage());
        }
        
        //6. Invalid List input
        try {            
        	List<Library_Item_Check_Out__c> libraryItemCheckOutList = cfsLibraryItemCheckOut.GetList(borrower.Id, NULL);
            
            System.Assert(false, 'Invalid GetList statuses not rejected');            
        }
        catch (Exception ex) {
            System.Assert(true, ex.getMessage());
        }
   }
}