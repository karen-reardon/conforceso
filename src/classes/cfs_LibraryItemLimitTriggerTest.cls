/**
 * Created by kreardon on 8/20/2019.
 */
@isTest
public with sharing class cfs_LibraryItemLimitTriggerTest {

    static final String BORROWING_PERIOD_DAYS = 'Days';
    static final String BORROWING_PERIOD_HOURS = 'Hours';
    static final String CATEGORY_BOOK = 'Book';
    static final String CATEGORY_MAGAZINE = 'Magazine';
    static final String CATEGORY_DVD = 'DVD';
    static final String CATEGORY_TELEVISION = 'Television';
    static final String CATEGORY_MONITOR = 'Monitor';
    static final String CATEGORY_OTHER = 'Other';

    static final Integer BASE_COUNT = 3;

    private static Integer count(Library_Item_Limit__c libraryItemLimit) {
        return [SELECT COUNT()
        FROM Library_Item_Limit__c
        WHERE Borrowing_Period_Interval__c = :libraryItemLimit.Borrowing_Period_Interval__c
        AND Borrowing_Period__c = :libraryItemLimit.Borrowing_Period__c
        AND Category__c = :libraryItemLimit.Category__c];
    }

    private static Integer count() {
        return [SELECT COUNT()
        FROM Library_Item_Limit__c];
    }

    private static Library_Item_Limit__c create(Integer borrowingPeriodInterval, String borrowingPeriod, String category) {
        Library_Item_Limit__c libraryItemLimit = new Library_Item_Limit__c();
        libraryItemLimit.Borrowing_Period_Interval__c = borrowingPeriodInterval;
        libraryItemLimit.Borrowing_Period__c = borrowingPeriod;
        libraryItemLimit.Category__c = category;
        return libraryItemLimit;
    }

    private static Library_Item_Limit__c get(Integer borrowingPeriodInterval, String borrowingPeriod, String category) {
        Library_Item_Limit__c libraryItemLimit;
        List<Library_Item_Limit__c> libraryItemLimits;
        libraryItemLimits = [SELECT Id, Name, Borrowing_Period_Interval__c, Borrowing_Period__c, Category__c
                            FROM Library_Item_Limit__c
                            WHERE Borrowing_Period_Interval__c = :borrowingPeriodInterval
                            AND Borrowing_Period__c = :borrowingPeriod
                            AND Category__c = :category];
        if (libraryItemLimits.size() == 1) {
            libraryItemLimit = libraryItemLimits[0];
        }
        return libraryItemLimit;
    }

    private static Map<String, Library_Item_Limit__c> getAllByCategory() {
        List<Library_Item_Limit__c> libraryItemLimits;
        Map<String, Library_Item_Limit__c> libraryItemLimitMap = new Map<String, Library_Item_limit__c>();

        libraryItemLimits = [SELECT Id, Name, Borrowing_Period_Interval__c, Borrowing_Period__c, Category__c
        FROM Library_Item_Limit__c
        ORDER BY Category__c];

        for (Library_Item_Limit__c libraryItemLimit : libraryItemLimits) {
            libraryItemLimitMap.put(libraryItemLimit.Category__c, libraryItemLimit);
        }
        return libraryItemLimitMap;
    }

    private static Boolean match (Library_Item_Limit__c libraryItemLimit1, Library_Item_Limit__c libraryItemLimit2) {
        return ((libraryItemLimit1.Category__c != libraryItemLimit2.Category__c) ||
                (libraryItemLimit1.Borrowing_Period_Interval__c != libraryItemLimit2.Borrowing_Period_Interval__c) ||
                (libraryItemLimit1.Borrowing_Period__c != libraryItemLimit2.Borrowing_Period__c) ||
                (libraryItemLimit1.Borrowing_Limit__c != libraryItemLimit2.Borrowing_Limit__c));
    }

    private static String errorString (Library_Item_Limit__c libraryItemLimit, Integer count, String message) {
        return String.format(message + ' Borrowing Period Interval:{0} Borrowing Period:{1} Category:{2} Count:{3}.',
                new List<Object>{libraryItemLimit.Borrowing_Period_Interval__c, libraryItemLimit.Borrowing_Period__c, libraryItemLimit.Category__c, count});
    }

    //****************************************************************************************************************/

    @isTest
    private static void testGoodSingleInsert() {
        Library_Item_Limit__c libraryItemLimit = create(1, BORROWING_PERIOD_DAYS, CATEGORY_DVD);
        insert libraryItemLimit;
        Integer count = count(libraryItemLimit);
        System.assertEquals(1.0, count, errorString(libraryItemLimit, count, 'Good single insert LibraryItemLimit not uniquely found.'));
    }

    @isTest
    private static void testGoodSingleUpdate() {
        Library_Item_Limit__c libraryItemLimit = get(14, BORROWING_PERIOD_DAYS, CATEGORY_BOOK);
        Integer count = count(libraryItemLimit);
        System.assertNotEquals(null, libraryItemLimit, errorString(libraryItemLimit, 0, 'Test setup invalid. LibraryItemLimit not uniquely found.'));

        libraryItemLimit.Borrowing_Period_Interval__c = 12;
        update libraryItemLimit;

        count = count(libraryItemLimit);
        System.assertEquals(1.0, count, errorString(libraryItemLimit, count, 'Good single update LibraryItemLimit not uniquely found.'));
    }

    @isTest
    private static void testGoodMultipleInsert() {
        List<Library_Item_Limit__c> libraryItemLimits = new List<Library_Item_Limit__c>();

        libraryItemLimits.add(create(1, BORROWING_PERIOD_DAYS, CATEGORY_DVD));
        libraryItemLimits.add(create(6, BORROWING_PERIOD_HOURS, CATEGORY_OTHER));
        libraryItemLimits.add(create(3, BORROWING_PERIOD_HOURS, CATEGORY_TELEVISION));

        test.startTest();
        insert libraryItemLimits;
        Integer count = count();
        test.stopTest();

        System.assertEquals(BASE_COUNT+3.0, count, 'Good multiple insert LibraryItemLimit count not correct.');
    }

    @isTest
    private static void testGoodMultipleUpdate() {
        Library_Item_Limit__c libraryItemLimit1 = get(14, BORROWING_PERIOD_DAYS, CATEGORY_BOOK);
        Library_Item_Limit__c libraryItemLimit2 = get(6, BORROWING_PERIOD_DAYS, CATEGORY_MAGAZINE);

        System.assertNotEquals(null, libraryItemLimit1, errorString(libraryItemLimit1, 0, 'Test setup invalid. LibraryItemLimit not uniquely found.'));
        System.assertNotEquals(null, libraryItemLimit2, errorString(libraryItemLimit2, 0, 'Test setup invalid. LibraryItemLimit not uniquely found.'));

        List<Library_Item_Limit__c> libraryItemLimits = new List<Library_Item_Limit__c>();
        libraryItemLimit1.Borrowing_Period_Interval__c = 12;
        libraryItemLimit2.Borrowing_Period_Interval__c = 4;
        libraryItemLimits.add(libraryItemLimit1);
        libraryItemLimits.add(libraryItemLimit2);
        test.startTest();
        update libraryItemLimits;
        Integer count1 = count(libraryItemLimit1);
        Integer count2 = count(libraryItemLimit2);
        test.stopTest();

        System.assertEquals(1.0, count1, errorString(libraryItemLimit1, count1, 'Good single update LibraryItemLimit not uniquely found.'));
        System.assertEquals(1.0, count2, errorString(libraryItemLimit1, count2, 'Good single update LibraryItemLimit not uniquely found.'));
    }

    @isTest
    private static void testBadSingleInsert() {

        try {
            Library_Item_Limit__c libraryItemLimit = get(14, BORROWING_PERIOD_DAYS, CATEGORY_BOOK);
            libraryItemLimit.Id = null;
            test.startTest();
            insert libraryItemLimit;
            test.stopTest();
            System.assert(false, 'Bad single insert did not get caught as expected');
        }
        catch (Exception ex) {
            System.debug(ex.getMessage());
            System.assert(true);
        }
    }

    @isTest
    private static void testBadSingleUpdate() {
        try {
            Library_Item_Limit__c libraryItemLimit = get(14, BORROWING_PERIOD_DAYS, CATEGORY_BOOK);
            test.startTest();
            libraryItemLimit.Category__c = CATEGORY_OTHER;
            update libraryItemLimit;
            test.stopTest();
            System.assert(false, 'Bad single update did not get caught as expected');
        }
        catch (Exception ex) {
            System.debug(ex.getMessage());
            System.assert(true);
        }

    }
    @isTest
    private static void testBadMultipleInsert() {
        try {
            Library_Item_Limit__c libraryItemLimit1 = get(14, BORROWING_PERIOD_DAYS, CATEGORY_BOOK);
            Library_Item_Limit__c libraryItemLimit2 = get(6, BORROWING_PERIOD_DAYS, CATEGORY_MAGAZINE);

            System.assertNotEquals(null, libraryItemLimit1, errorString(libraryItemLimit1, 0, 'Test setup invalid. LibraryItemLimit not uniquely found.'));
            System.assertNotEquals(null, libraryItemLimit2, errorString(libraryItemLimit2, 0, 'Test setup invalid. LibraryItemLimit not uniquely found.'));

            List<Library_Item_Limit__c> libraryItemLimits = new List<Library_Item_Limit__c>();
            libraryItemLimit1.Id = null;
            libraryItemLimit2.Id = null;
            libraryItemLimits.add(libraryItemLimit1);
            libraryItemLimits.add(libraryItemLimit2);
            test.startTest();
            insert libraryItemLimits;
            test.stopTest();
            System.assert(false, 'Bad multiple insert did not get caught as expected');
        }
        catch (Exception ex) {
            System.debug(ex.getMessage());
            System.assert(true);
        }
    }

    @isTest
    private static void testBadMultipleUpdate() {
        try {
            Library_Item_Limit__c libraryItemLimit1 = get(14, BORROWING_PERIOD_DAYS, CATEGORY_BOOK);
            Library_Item_Limit__c libraryItemLimit2 = get(6, BORROWING_PERIOD_DAYS, CATEGORY_MAGAZINE);

            System.assertNotEquals(null, libraryItemLimit1, errorString(libraryItemLimit1, 0, 'Test setup invalid. LibraryItemLimit not uniquely found.'));
            System.assertNotEquals(null, libraryItemLimit2, errorString(libraryItemLimit2, 0, 'Test setup invalid. LibraryItemLimit not uniquely found.'));

            List<Library_Item_Limit__c> libraryItemLimits = new List<Library_Item_Limit__c>();
            libraryItemLimit1.Category__c = CATEGORY_OTHER;
            libraryItemLimit2.Category__c = CATEGORY_OTHER;
            libraryItemLimits.add(libraryItemLimit1);
            libraryItemLimits.add(libraryItemLimit2);
            test.startTest();
            insert libraryItemLimits;
            test.stopTest();
            System.assert(false, 'Bad multiple update did not get caught as expected');
        }
        catch (Exception ex) {
            System.debug(ex.getMessage());
            System.assert(true);
        }
    }

    @isTest
    private static void testMixedMultipleInsertWithEither() {
        Library_Item_Limit__c libraryItemLimit1 = get(14, BORROWING_PERIOD_DAYS, CATEGORY_BOOK);
        Library_Item_Limit__c libraryItemLimit2 = create(1, BORROWING_PERIOD_DAYS, CATEGORY_DVD);

        System.assertNotEquals(null, libraryItemLimit1, errorString(libraryItemLimit1, 0, 'Test setup invalid. LibraryItemLimit not uniquely found.'));

        List<Library_Item_Limit__c> libraryItemLimits = new List<Library_Item_Limit__c>();
        libraryItemLimit1.Id = null;
        libraryItemLimit1.Borrowing_Period_Interval__c = 12;
        libraryItemLimits.add(libraryItemLimit1);
        libraryItemLimits.add(libraryItemLimit2);
        test.startTest();
        Database.insert(libraryItemLimits, false);
        Integer count1 = count(libraryItemLimit1);
        Integer count2 = count(libraryItemLimit2);
        test.stopTest();

        System.assertEquals(0, count1, errorString(libraryItemLimit1, count1, 'Good mixed multiple insert LibraryItemLimit committed, when should have failed.'));
        System.assertEquals(1.0, count2, errorString(libraryItemLimit2, count2, 'Good mixed multiple insert LibraryItemLimit not committed when should have been.'));
    }

    @isTest
    private static void testMixedMultipleInsertWithNonOrAll() {
        try {
            Library_Item_Limit__c libraryItemLimit1 = get(14, BORROWING_PERIOD_DAYS, CATEGORY_BOOK);
            Library_Item_Limit__c libraryItemLimit2 = create(1, BORROWING_PERIOD_DAYS, CATEGORY_DVD);

            System.assertNotEquals(null, libraryItemLimit1, errorString(libraryItemLimit1, 0, 'Test setup invalid. LibraryItemLimit not uniquely found.'));

            List<Library_Item_Limit__c> libraryItemLimits = new List<Library_Item_Limit__c>();
            libraryItemLimit1.Id = null;
            libraryItemLimit1.Borrowing_Period_Interval__c = 12;
            libraryItemLimits.add(libraryItemLimit1);
            libraryItemLimits.add(libraryItemLimit2);
            test.startTest();
            Database.insert(libraryItemLimits, true);
            Integer count1 = count(libraryItemLimit1);
            Integer count2 = count(libraryItemLimit2);
            test.stopTest();
            System.assert(false, 'Mixed Multiple Insert with non-or-all exception did not get caught as expected');
        }
        catch (Exception ex) {
            System.debug(ex.getMessage());
            System.assert(true);
        }
    }
    @isTest
    private static void testMixedMultipleUpdateWithEither() {
        Library_Item_Limit__c libraryItemLimit1 = get(14, BORROWING_PERIOD_DAYS, CATEGORY_BOOK);
        Library_Item_Limit__c libraryItemLimit2 = get(6, BORROWING_PERIOD_DAYS, CATEGORY_MAGAZINE);

        System.assertNotEquals(null, libraryItemLimit1, errorString(libraryItemLimit1, 0, 'Test setup invalid. LibraryItemLimit not uniquely found.'));
        System.assertNotEquals(null, libraryItemLimit2, errorString(libraryItemLimit2, 0, 'Test setup invalid. LibraryItemLimit not uniquely found.'));

        List<Library_Item_Limit__c> libraryItemLimits = new List<Library_Item_Limit__c>();
        libraryItemLimit1.Category__c = CATEGORY_OTHER;
        libraryItemLimit2.Borrowing_Period_Interval__c = 4;
        libraryItemLimits.add(libraryItemLimit1);
        libraryItemLimits.add(libraryItemLimit2);
        test.startTest();
        Database.update(libraryItemLimits, false);
        Integer count1 = count(libraryItemLimit1);
        Integer count2 = count(libraryItemLimit2);
        test.stopTest();

        System.assertEquals(0, count1, errorString(libraryItemLimit1, count1, 'Good mixed multiple update LibraryItemLimit committed, when should have failed.'));
        System.assertEquals(1, count2, errorString(libraryItemLimit1, count2, 'Good mixed multiple update LibraryItemLimit not commited, when it should have been.'));
    }

    @isTest
    private static void testMixedMultipleUpdateWithNonOrAll() {
        try {
            Library_Item_Limit__c libraryItemLimit1 = get(14, BORROWING_PERIOD_DAYS, CATEGORY_BOOK);
            Library_Item_Limit__c libraryItemLimit2 = get(6, BORROWING_PERIOD_DAYS, CATEGORY_MAGAZINE);

            System.assertNotEquals(null, libraryItemLimit1, errorString(libraryItemLimit1, 0, 'Test setup invalid. LibraryItemLimit not uniquely found.'));
            System.assertNotEquals(null, libraryItemLimit2, errorString(libraryItemLimit2, 0, 'Test setup invalid. LibraryItemLimit not uniquely found.'));

            List<Library_Item_Limit__c> libraryItemLimits = new List<Library_Item_Limit__c>();
            libraryItemLimit1.Category__c = CATEGORY_OTHER;
            libraryItemLimit2.Borrowing_Period_Interval__c = 4;
            libraryItemLimits.add(libraryItemLimit1);
            libraryItemLimits.add(libraryItemLimit2);
            test.startTest();
            Database.update(libraryItemLimits, true);
            Integer count1 = count(libraryItemLimit1);
            Integer count2 = count(libraryItemLimit2);
            test.stopTest();

            System.assert(false, 'Mixed Multiple Update with non-or-all exception did not get caught as expected');
        }
        catch (Exception ex) {
            System.debug(ex.getMessage());
            System.assert(true);
        }
    }
    @testSetup
    private static void createTestData() {
        List<Library_Item_Limit__c> libraryItemLimits = new List<Library_Item_Limit__c>();
        Set<Id> libraryItemLimitIds = new Set<Id>();

        libraryItemLimits.add(create(14, BORROWING_PERIOD_DAYS, CATEGORY_BOOK));
        libraryItemLimits.add(create(6, BORROWING_PERIOD_DAYS, CATEGORY_MAGAZINE));
        libraryItemLimits.add(create(4, BORROWING_PERIOD_HOURS, CATEGORY_MONITOR));

        insert libraryItemLimits;
    }
}