public with sharing class cfs_LibraryItemLimitsHelper {

    public Map<Id,String> getCategoryMap(List<Library_Item_Limit__c> libraryItemLimits) {
        Map<Id,String> categoryMap = new Map<Id,String>();
        for (Library_Item_Limit__c libraryItemLimit : libraryItemLimits) {
            categoryMap.put(libraryItemLimit.Id, libraryItemLimit.Category__c);
        }
        return categoryMap;
    }

    public static void validateDuplicates(List<Library_Item_Limit__c> libraryItemLimits) {
        cfs_LibraryItemLimitsSelector selector = new cfs_LibraryItemLimitsSelector();

        Map<String, String> duplicateMapByCategory = selector.getMapOfDuplicateNamesByCategory(libraryItemLimits);

        for (Library_Item_Limit__c libraryItemLimit : libraryItemLimits) {
            String duplicateName = duplicateMapByCategory.get(libraryItemLimit.Category__c);
            if (String.IsNotBlank(duplicateName)) {
                libraryItemLimit.addError(
                        String.format('Duplicate categories are not allowed. Library Item Limit has the same category as "{0}".', new List<Object>{duplicateName}));

            }
        }
    }

    public static void validateCategoryChange(List<Library_Item_Limit__c> libraryItemLimits, Map<Id,SObject> existingRecords) {
        for (Library_Item_Limit__c libraryItemLimit : libraryItemLimits) {
            Library_Item_Limit__c existingLibraryItemLimit = (Library_Item_Limit__c)existingRecords.get(libraryItemLimit.Id);
            if (existingLibraryItemLimit.Category__c != libraryItemLimit.Category__c) {
                libraryItemLimit.addError(String.format('You cannot change the Category after the Library Item Limit has been created {0}.', new List<Object>{Library_Item_Limit__c.Category__c}));
            }
        }
    }
}