<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_to_AE_at_Loan_Level_for_a_new_note</fullName>
        <description>Email to AE at Loan Level for a new note</description>
        <protected>false</protected>
        <recipients>
            <field>Email_of_AE_for_Loan__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>ormssupport@onereverse.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Email_to_AE_on_anew_portal_note_on_laon</template>
    </alerts>
    <alerts>
        <fullName>Email_to_PCS_at_Loan_Level_for_a_new_note</fullName>
        <description>Email to PCS at Loan Level for a new note</description>
        <protected>false</protected>
        <recipients>
            <field>Email_of_PCS_at_Loan_Level__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Email_to_PCS_on_anew_portal_note_on_laon</template>
    </alerts>
    <alerts>
        <fullName>Email_to_PCS_at_Partner_Level_for_a_new_note</fullName>
        <description>Email to PCS at Partner Level for a new note</description>
        <protected>false</protected>
        <recipients>
            <field>Email_of_PCS_at_Partner_Level__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Email_to_PCS_on_anew_portal_note_on_laon</template>
    </alerts>
    <alerts>
        <fullName>Notify_Loan_officer_of_New_portal_NoteOfficer</fullName>
        <description>Notify Loan Officer of New portal Note</description>
        <protected>false</protected>
        <recipients>
            <field>Loan_Officer_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>ormssupport@onereverse.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Keep/Business_Individuals_notification_when_Notes_value_changes</template>
    </alerts>
    <alerts>
        <fullName>Notify_Loan_processor_of_New_portal_Note</fullName>
        <description>Notify Loan processor of New portal Note</description>
        <protected>false</protected>
        <recipients>
            <field>Loan_Processor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Keep/Business_Individuals_notification_when_Notes_value_changes</template>
    </alerts>
</Workflow>
