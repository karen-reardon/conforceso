/**
 * Created by kreardon on 8/20/2019.
 */

public with sharing class cfs_Utils {

    public Static String getFirstNonMatchingItem (Set<String> items, String exclusionItem) {
        String nonMatchingItem = '';
        for (String item : items) {
            if (item != exclusionItem) {
                nonMatchingItem = item;
                break;
            }
        }
        return nonMatchingItem;
    }
}