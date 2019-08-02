@isTest
public class cfsLibraryItem_Test {

    static testMethod void Execute() {
        
        Library_Item__c libraryItem;
                
        //Load Test Data
        try {
        	insert new Library_Settings__c(Barcode_Prefix__c='3119');
        	insert new Borrowing_Period__c(AV_Equipment_Interval__c = 5, Book_Interval__c=14);

            libraryItem = new Library_Item__c();
            libraryItem.Name = 'Crime and Punishment';
            libraryItem.Barcode__c = '33119777777777';
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

        //1. Get a valid record
        try {
        	libraryItem = cfsLibraryItem.Get('33119888888888');
            
            System.assertEquals('Pride and Prejudice', libraryItem.Name);            
        }
        catch (Exception ex) {
            System.Assert(false, ex.getMessage());
        }
        
        //2. Get Availability Status
        try {
        	Boolean isAvailable = cfsLibraryItem.IsAvailable('Available');
            
            System.assertEquals(true, isAvailable);            
        }
        catch (Exception ex) {
            System.Assert(false, ex.getMessage());
        }
        
        //Negative Tests
        //1. Get a invalid record
        try {            
        	libraryItem = cfsLibraryItem.Get('33119111111111');
            
            System.Assert(false, 'Invalid record get not rejected');            
        }
        catch (Exception ex) {
            System.Assert(true, ex.getMessage());
        }        
   }
}