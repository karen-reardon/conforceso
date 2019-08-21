public class cfs_LibraryItemLimits extends fflib_SObjectDomain {

    public List<Library_Item_Limit__c> libraryItemLimits = new List<Library_Item_Limit__c>();
    
    public cfs_LibraryItemLimits (List<Library_Item_Limit__c> sObjectList) {
        super(sObjectList);
        libraryItemLimits = this.Records;
    }
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new cfs_LibraryItemLimits(sObjectList);
        }
    }
    
    //Called in the handleBeforeInsert
    public override void onApplyDefaults() { }
    
    //Called in the handleAfterInsert
    public override void onValidate() {
    	cfs_LibraryItemLimitsHelper.validateDuplicates(libraryItemLimits);
    }
    
    //Called in the handleAfterUpdate
    public override void onValidate(Map<Id,SObject> existingRecords) {
        cfs_LibraryItemLimitsHelper.validateCategoryChange(this.libraryItemLimits, existingRecords);
    }

    public override void onBeforeInsert() { }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) { }
    
    public override void onBeforeDelete() { }
    
    public override void onAfterInsert() { }
    
    public override void onAfterUpdate(Map<Id,SObject> existingRecords) { }
    
    public override void onAfterDelete() { }	
	
    public override void onAfterUndelete() { }	

}