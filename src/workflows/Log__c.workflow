<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>update_loan_id</fullName>
        <field>LoanID__c</field>
        <formula>MID( Message__c , FIND("L-0", Message__c )+0 , FIND("mortgage_applied_for", Message__c )-(FIND("L-0", Message__c )+3))</formula>
        <name>update loan id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Populate LoanID for Log View</fullName>
        <actions>
            <name>update_loan_id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Log__c.Message__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Need to find Loan Number from Message__c(Logs object) and populate in new field</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
