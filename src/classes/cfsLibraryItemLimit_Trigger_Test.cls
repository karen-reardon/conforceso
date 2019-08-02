@isTest
public class cfsLibraryItemLimit_Trigger_Test {
    
    static testMethod void Execute() {
        
        Library_Item_Limit__c libraryItemLimit;
        
        //Positive Tests
        
        //1. Insert one valid record
        try {
            libraryItemLimit = new Library_Item_Limit__c ();
            libraryItemLimit.Category__c = 'Book';
            libraryItemLimit.Borrowing_Period__c = 'Days';
            libraryItemLimit.Borrowing_Period_Interval__c = 14;        
            insert libraryItemLimit;
            
            libraryItemLimit = [SELECT Id, Borrowing_Limit__c FROM Library_Item_Limit__c WHERE Category__c = 'Book'];
            
            System.assertEquals(14.0, libraryItemLimit.Borrowing_Limit__c);            
        }
        catch (Exception ex) {
            System.Assert(false, ex.getMessage());
        }
        
        //2. Change one record from Days to Hours
        try {            
            libraryItemLimit = [SELECT Id FROM Library_Item_Limit__c WHERE Category__c = 'Book'];
            
            libraryItemLimit.Borrowing_Period__c = 'Hours';
            libraryItemLimit.Borrowing_Period_Interval__c = 48;        
            update libraryItemLimit;
            
            libraryItemLimit = [SELECT Id, Borrowing_Limit__c FROM Library_Item_Limit__c WHERE Category__c = 'Book'];
            
            System.assertEquals(2.0, libraryItemLimit.Borrowing_Limit__c);            
        }
        catch (Exception ex) {
            System.Assert(false, ex.getMessage());
        }
        
        //Negative Tests
        
        //1. Insert duplicate
        try {
            libraryItemLimit = new Library_Item_Limit__c ();
            libraryItemLimit.Category__c = 'Book';
            libraryItemLimit.Borrowing_Period__c = 'Days';
            libraryItemLimit.Borrowing_Period_Interval__c = 14;        
            insert libraryItemLimit;
            
            System.Assert(false, 'Duplicate insert not rejected');            
        }
        catch (Exception ex) {
            System.Assert(true, ex.getMessage());
        }
        
        //2. Enter negative limit
        try {            
            libraryItemLimit = [SELECT Id FROM Library_Item_Limit__c WHERE Category__c = 'Book'];
            
            libraryItemLimit.Borrowing_Period__c = 'Hours';
            libraryItemLimit.Borrowing_Period_Interval__c = -1;        
            update libraryItemLimit;
            
            System.Assert(false, 'Negative interval not rejected');            
        }
        catch (Exception ex) {
            System.Assert(true, ex.getMessage());
        }
        
        //3. Enter zero limit
        try {            
            libraryItemLimit = [SELECT Id FROM Library_Item_Limit__c WHERE Category__c = 'Book'];
            
            libraryItemLimit.Borrowing_Period__c = 'Hours';
            libraryItemLimit.Borrowing_Period_Interval__c = 0;        
            update libraryItemLimit;
            
            System.Assert(false, 'Zero interval not rejected');            
        }
        catch (Exception ex) {
            System.Assert(true, ex.getMessage());
        }
        
    }
}