<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Renewal_Approved</fullName>
        <ccEmails>ormsrenewals@onereverse.com</ccEmails>
        <description>Renewal Approved</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>ormsrenewals@onereverse.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Renewals/Renewal_is_Approved</template>
    </alerts>
    <alerts>
        <fullName>Renewal_Intro_Email</fullName>
        <description>Renewal Intro Email</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>danny@onereverse.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>ormsrenewals@onereverse.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Renewals/Renewal_is_due</template>
    </alerts>
    <alerts>
        <fullName>Renewal_Withdrawn</fullName>
        <ccEmails>ormsrenewals@onereverse.com</ccEmails>
        <description>Renewal Withdrawn</description>
        <protected>false</protected>
        <recipients>
            <field>Primary_Contact_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>ormsrenewals@onereverse.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Renewals/Renewal_is_Withdrawn</template>
    </alerts>
    <fieldUpdates>
        <fullName>App_Sent_Date</fullName>
        <field>App_Sent__c</field>
        <formula>Today()</formula>
        <name>App Sent Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>AccountId</targetObject>
    </fieldUpdates>
    <rules>
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
    </rules>
</Workflow>
