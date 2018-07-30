<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata"><alerts>
        <fullName>QLMS_AE_Lead_Contacted_notification_email</fullName>
        <description>QLMS AE Lead Contacted notification email</description>
        <protected>false</protected>
        <recipients>
            <field>QLMS_AE_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AE_Notification_Emails/QLMS_AE_Contacted_notification</template>
    </alerts><alerts>
        <fullName>QLMS_AE_Lead_Not_Interested_notification_email</fullName>
        <description>QLMS AE Lead Not Interested notification email</description>
        <protected>false</protected>
        <recipients>
            <field>QLMS_AE_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AE_Notification_Emails/QLMS_AE_Not_Interested_notification</template>
    </alerts></Workflow>