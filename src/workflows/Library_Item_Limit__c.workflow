<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Library_Item_Limit_Search_Tags</fullName>
        <description>Copy search tags formula value into a searchable field</description>
        <field>Search_Tags__c</field>
        <formula>Search_Tags_Formula__c</formula>
        <name>Library Item Limit Search Tags</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Library Item Limit Search Tags Change</fullName>
        <actions>
            <name>Library_Item_Limit_Search_Tags</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Triggered if Library Item Limit Search Tags formula has changed</description>
        <formula>Search_Tags_Formula__c !=  Search_Tags__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
