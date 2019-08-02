@isTest
public class cfsLibraryItemCheckOut_Trigger_Test {

    static testMethod void Execute() {
        
        User borrower;
        Library_Item__c libraryItem;
        Library_Item_Check_Out__c libraryItemCheckOut;
        Boolean valid;
        
        //Load test data
        try {
        	insert new Library_Settings__c(Barcode_Prefix__c='3119');
        	insert new Borrowing_Period__c(AV_Equipment_Interval__c = 5, Book_Interval__c=14);	
        	borrower = [SELECT Id FROM User WHERE Alias = 'starly'];
        }
        catch (Exception ex) {
            System.Assert(false, ex.getMessage());
        }
        try {
            libraryItem = new Library_Item__c();
            libraryItem.Name = 'Pride and Prejudice';
            libraryItem.Barcode__c = '33119888888888';
            insert libraryItem;            
        }
        catch (Exception ex) {
            System.Assert(false, ex.getMessage());
        }

        //Positive Tests
        
        //1. Insert one valid record
        try {
            libraryItemCheckOut = new Library_Item_Check_Out__c();
            libraryItemCheckOut.Library_Item__c = libraryItem.Id;
            libraryItemCheckOut.Borrower__c = borrower.Id;
            insert libraryItemCheckOut;
            
            libraryItemCheckOut = [SELECT Id, Check_Out_Status__c FROM Library_Item_Check_Out__c WHERE Id = :libraryItemCheckOut.Id];            
            libraryItem = [SELECT Id, Availability_Status__c, Current_Check_Out__c FROM Library_Item__c WHERE Id = :LibraryItem.Id];
            
            System.assertEquals('Checked Out', libraryItemCheckOut.Check_Out_Status__c);
            System.assertEquals(libraryItemCheckOut.Id, libraryItem.Current_Check_Out__c);
            System.assertEquals('Checked Out', libraryItem.Availability_Status__c);	
			}        
			catch (Exception ex) {
            	System.Assert(false, ex.getMessage());
        }
        
        //2. Change one record
        try {            
            libraryItemCheckOut = [SELECT Id FROM Library_Item_Check_Out__c WHERE Id = :libraryItemCheckOut.Id];
            libraryItemCheckOut.Check_In_Time__c = Datetime.now();
            update libraryItemCheckOut;
            
            libraryItemCheckOut = [SELECT Id, Check_Out_Status__c FROM Library_Item_Check_Out__c WHERE Id = :libraryItemCheckOut.Id];            
            libraryItem = [SELECT Id, Availability_Status__c, Current_Check_Out__c FROM Library_Item__c WHERE Id = :LibraryItem.Id];
            
            System.assertEquals('Checked In', libraryItemCheckOut.Check_Out_Status__c);
            System.assertEquals(NULL, libraryItem.Current_Check_Out__c);
            System.assertEquals('Available', libraryItem.Availability_Status__c);	
        }
        catch (Exception ex) {
            System.Assert(false, ex.getMessage());
        }
        
        //Negative Tests
        
        //1. Insert duplicate
        try {
            libraryItemCheckOut = new Library_Item_Check_Out__c();
            libraryItemCheckOut.Library_Item__c = libraryItem.Id;
            libraryItemCheckOut.Borrower__c = borrower.Id;
            insert libraryItemCheckOut;
            insert libraryItemCheckOut;

            System.Assert(false, 'Duplicate insert not rejected');            
        }
        catch (Exception ex) {
            System.Assert(true, ex.getMessage());
        }
        
        //1. Insert not available
        try {
            libraryItemCheckOut = [SELECT Id FROM Library_Item_Check_Out__c WHERE Id = :libraryItemCheckOut.Id];
            libraryItemCheckOut.Check_In_Time__c = Datetime.now();
            update libraryItemCheckOut;

            libraryItem = [SELECT Id FROM Library_Item__c WHERE Id = :LibraryItem.Id];
            libraryItem.Circulation_Status__c = 'Damaged';            
            update libraryItem;
        	
            libraryItemCheckOut = new Library_Item_Check_Out__c();
            libraryItemCheckOut.Library_Item__c = libraryItem.Id;
            libraryItemCheckOut.Borrower__c = borrower.Id;
            insert libraryItemCheckOut;
            
            System.Assert(false, 'Unavailable insert not rejected');            
        }
        catch (Exception ex) {
            System.Assert(true, ex.getMessage());
        }
    }
}