public with sharing class cfsLibraryItem {

    private static final String AVAILABLE = 'Available';

    public static Boolean IsAvailable(String availabilityStatus) {
        return (availabilityStatus == AVAILABLE);
    }

    //Returns the Library Item for the given barcode
    //Note: Before Insert and Before Update triggers validate that a Library Item is assigned a unique barcode
    //Barcode specified must be assigned on an existing Library Item
    //
    public static Library_Item__c Get (String barcode) {
        Library_Item__c libraryItem;
        try {
            libraryItem = [SELECT Id, Name, Barcode__c, Availability_Status__c FROM Library_Item__c WHERE barcode__c = :barcode ];  
            return libraryItem;
        }
        catch (Exception ex) {
	        throw new cfsLibraryException ('Library Item could not be found. Barcode: ' + barcode, ex);
        }
    }    
}