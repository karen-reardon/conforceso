public with sharing class cfs_LibraryItemLimitsSelector extends fflib_SObjectSelector {
	
    public List<Schema.SObjectField> getSObjectFieldList() {
    	return new List<Schema.SObjectField> {
    		Library_Item_Limit__c.Id,
    		Library_Item_Limit__c.Name,
    		Library_Item_Limit__c.Category__c,
			Library_Item_Limit__c.Borrowing_Period__c,
			Library_Item_Limit__c.Borrowing_Period_Interval__c,
			Library_Item_Limit__c.Borrowing_Limit__c
    		};
    }
       
    public Schema.SObjectType getSObjectType() {
    	return Library_Item_Limit__c.SObjectType;	
    }

    public List<Library_Item_Limit__c> selectById(Set<Id> libraryItemLimitIds) {
    	return (List<Library_Item_Limit__c>) selectSObjectsById(libraryItemLimitIds);
    }


	public List<Library_Item_Limit__c> selectDuplicatesByCategory(Map<Id,String> categoryMap) {
		fflib_QueryFactory queryFactory = newQueryFactory();
		List<String> categories = categoryMap.values();
		Set<Id> excludedIds = categoryMap.keySet();
		queryFactory.setCondition('Category__c IN :categories AND Id NOT IN : excludedIds');
		return (List<Library_Item_Limit__c>) Database.query(queryFactory.toSOQL());
	}

	public Map<String,String> getMapOfDuplicateNamesByCategory(List<Library_Item_Limit__c> libraryItemLimits) {
		Map<String, String> returnMap = new Map<String,String>();
		Map<Id,String> categoryMap = cfs_LibraryItemLimitsHelper.getCategoryMap(libraryItemLimits);
		List<Library_Item_Limit__c> duplicateLibraryItemLimits = this.selectDuplicatesByCategory(categoryMap);
		for (Library_Item_Limit__c libraryItemLimit : duplicateLibraryItemLimits) {
			returnMap.put(libraryItemLimit.Category__c, libraryItemLimit.Name);
		}
		return returnMap;
	}
}