<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ReOS_Email_Alert_External_Service</fullName>
        <ccEmails>team-reos-dev@reosapp.io</ccEmails>
        <description>ReOS Email Alert External Service</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>reOS_Email_Templates/reOS_Email_Alert_External_Service</template>
    </alerts>
    <alerts>
        <fullName>External_Service_Error_Alert</fullName>
        <ccEmails>donherod@quickenloans.com</ccEmails>
        <description>External Service Error Alert</description>
        <protected>false</protected>
        <senderAddress>ormssupport@onereverse.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/External_Service_Error</template>
    </alerts>
</Workflow>
