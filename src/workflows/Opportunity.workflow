<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata"><fieldUpdates>
        <fullName>App_Sent_Date</fullName>
        <field>App_Sent__c</field>
        <formula>Today()</formula>
        <name>App Sent Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates><rules>
        <fullName>Opportunity created update App sent date</fullName>
        <actions>
            <name>App_Sent_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner Onboarding</value>
        </criteriaItems>
        <description>Whenever an Opportunity is created, App sent date on Account is updated</description>
        <triggerType>onCreateOnly</triggerType>
    </rules></Workflow>