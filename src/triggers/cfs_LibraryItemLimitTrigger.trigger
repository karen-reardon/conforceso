trigger cfs_LibraryItemLimitTrigger on Library_Item_Limit__c (after delete, after insert, after update, before delete, before insert, before update) {

    fflib_SObjectDomain.triggerHandler(cfs_LibraryItemLimits.class);
}