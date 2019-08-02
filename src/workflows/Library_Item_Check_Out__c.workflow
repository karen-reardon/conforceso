<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Library_Item_Overdue_Email_Alert</fullName>
        <description>Library Item Overdue Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Borrower__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Library_Item_Overdue</template>
    </alerts>
    <fieldUpdates>
        <fullName>Expire_Overdue_Trigger</fullName>
        <description>Specifies that the overdue trigger has expired by setting it to NULL.</description>
        <field>Overdue_Trigger__c</field>
        <name>Expire Overdue Trigger</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Library_Item_Check_Out_Search_Tags</fullName>
        <description>Copy search tags formula value into a searchable field</description>
        <field>Search_Tags__c</field>
        <formula>Search_Tags_Formula__c</formula>
        <name>Library Item Check Out Search Tags</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Library Item Check Out Overdue Trigger</fullName>
        <active>true</active>
        <description>Triggered if Library Item Check Out Overdue Trigger set</description>
        <formula>NOT(ISBLANK( Overdue_Trigger__c )) &amp;&amp;
ISBLANK(  Check_In_Time__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Expire_Overdue_Trigger</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Library_Item_Check_Out__c.Overdue_Trigger__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Library Item Check Out Search Tags Change</fullName>
        <actions>
            <name>Library_Item_Check_Out_Search_Tags</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Triggered if Library Item Check Out Search Tags formula has changed</description>
        <formula>Search_Tags_Formula__c != Search_Tags__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
