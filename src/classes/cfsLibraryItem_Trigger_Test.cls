@isTest
public class cfsLibraryItem_Trigger_Test {

    static testMethod void Execute() {
        
        Library_Item__c libraryItem;
                
        //Load Test Data
        try {
        	insert new Library_Settings__c(Barcode_Prefix__c='3119');
        	insert new Borrowing_Period__c(AV_Equipment_Interval__c = 5, Book_Interval__c=14);	
        }        
        catch (Exception ex) {
            System.Assert(false, ex.getMessage());        	
        }
        
        //Positive Tests

        //1. Insert one valid record
        try {
            libraryItem = new Library_Item__c();
            libraryItem.Name = 'Crime and Punishment';
            libraryItem.Barcode__c = '33119999999999';
            insert libraryItem;
            
            libraryItem = [SELECT Id, Availability_Status__c FROM Library_Item__c WHERE Barcode__c = '33119999999999'];
            
            System.assertEquals('Available', libraryItem.Availability_Status__c);            
        }
        catch (Exception ex) {
            System.Assert(false, ex.getMessage());
        }
        
        //2. Change one record
        try {            
            libraryItem = [SELECT Id FROM Library_Item__c WHERE Barcode__c = '33119999999999'];
            libraryItem.Circulation_Status__c = 'Damaged';            
            update libraryItem;
            
            libraryItem = [SELECT Id, Availability_Status__c FROM Library_Item__c WHERE Barcode__c = '33119999999999'];
            
            System.assertEquals('Damaged', libraryItem.Availability_Status__c);            
        }
        catch (Exception ex) {
            System.Assert(false, ex.getMessage());
        }
        
        //Negative Tests
        
        //1. Insert duplicate
        try {
            libraryItem = new Library_Item__c();
            libraryItem.Name = 'Tale of Two Cities';
            libraryItem.Barcode__c = '33119999999999';
            insert libraryItem;
                        
            System.Assert(false, 'Duplicate insert not rejected');            
        }
        catch (Exception ex) {
            System.Assert(true, ex.getMessage());
        }
        
        //2. Enter invalid barcode
        try {            
            libraryItem = [SELECT Id FROM Library_Item__c WHERE Barcode__c = '33119999999999'];
            libraryItem.Barcode__c = '2311801';
            update libraryItem;
            
            System.Assert(false, 'Invalid barcode not rejected');            
        }
        catch (Exception ex) {
            System.Assert(true, ex.getMessage());
        }        
        //3. Enter missing name
        try {
            libraryItem = new Library_Item__c();
            libraryItem.Name = '';
            libraryItem.Barcode__c = '33119888888888';
            insert libraryItem;
                        
            System.Assert(false, 'No name insert not rejected');            
        }
        catch (Exception ex) {
            System.Assert(true, ex.getMessage());
        }
    }
}