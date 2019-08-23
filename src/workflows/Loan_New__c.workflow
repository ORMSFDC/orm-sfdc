<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Loan_Denied_or_Withdrawn</fullName>
        <ccEmails>ORMSVendor@onereverse.com</ccEmails>
        <description>Loan Denied or Withdrawn</description>
        <protected>false</protected>
        <senderAddress>ormssupport@onereverse.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Loan_Status_Denied_or_Withdrawn</template>
    </alerts>
    <alerts>
        <fullName>Loan_Waiting_for_Full_Package_Alert</fullName>
        <ccEmails>ORMSVendor@onereverse.com</ccEmails>
        <description>Loan Waiting for Full Package Alert</description>
        <protected>false</protected>
        <senderAddress>ormssupport@onereverse.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Loan_Status_Waiting_for_Full_Package</template>
    </alerts>
    <alerts>
        <fullName>ReOS_Email_Alert_Loan</fullName>
        <ccEmails>team-reos-dev@reosapp.io</ccEmails>
        <description>ReOS Email Alert Loan</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>reOS_Email_Templates/reOS_Email_Alert_Loan</template>
    </alerts>
    <alerts>
        <fullName>Alert_Withdrawn_Loan_after_In_processing_before_Final_HUD_Review</fullName>
        <ccEmails>ORMSVendor@onereverse.com</ccEmails>
        <description>Alert: Withdrawn Loan after In processing, before Final HUD Review</description>
        <protected>false</protected>
        <recipients>
            <recipient>danny@onereverse.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>ormssupport@onereverse.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Revisit/Alert_Loan_Withdrawn_w_Criteria</template>
    </alerts>
    <alerts>
        <fullName>Loan_Full_Package_Received_Alert</fullName>
        <ccEmails>balasahityadeekonda@quickenloans.com</ccEmails>
        <ccEmails>MichelleLarkin@quickenloans.com</ccEmails>
        <ccEmails>MarieTaiariol@quickenloans.com</ccEmails>
        <description>Loan Full Package Received Alert</description>
        <protected>false</protected>
        <senderAddress>ormssupport@onereverse.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Loan_Status_Full_Package_Received</template>
    </alerts>
    <alerts>
        <fullName>Loan_Submitted_Awaiting_Review_Notification_to_Partner</fullName>
        <description>Loan Submitted - Awaiting Review Notification to Partner</description>
        <protected>false</protected>
        <recipients>
            <field>Related_Individual__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <recipient>shivni@orms.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>ormssupport@onereverse.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Partner_Notification_Emails/Loan_Submitted_Awaiting_Review_Notification_to_Partner</template>
    </alerts>
    <fieldUpdates>
        <fullName>Extend_Application_Time</fullName>
        <field>Extend_Application_Time__c</field>
        <literalValue>1</literalValue>
        <name>Extend Application Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>uncheck_IsActive_checkbox</fullName>
        <field>IsActiveFlag__c</field>
        <literalValue>0</literalValue>
        <name>uncheck IsActive checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Goal_Field</fullName>
        <field>Goal__c</field>
        <formula>IF(CONTAINS(Closing_Month__c,'None'),0,
IF(CONTAINS(Closing_Month__c,'June  2018'),7,
IF(CONTAINS(Closing_Month__c,'July  2018'),10,
IF(CONTAINS(Closing_Month__c,'August  2018'),10,
IF(CONTAINS(Closing_Month__c,'September  2018'),11,
IF(CONTAINS(Closing_Month__c,'October  2018'),15,
IF(CONTAINS(Closing_Month__c,'November  2018'),24,
IF(CONTAINS(Closing_Month__c,'December  2018'),22,
IF(CONTAINS(Closing_Month__c,'January  2019'),27,
IF(CONTAINS(Closing_Month__c,'February  2019'),23,
IF(CONTAINS(Closing_Month__c,'March  2019'),22, 0 )))))))))))</formula>
        <name>Update Goal Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Deactivate Loan in Sandbox status</fullName>
        <actions>
            <name>uncheck_IsActive_checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Loan_New__c.LoanStatus__c</field>
            <operation>equals</operation>
            <value>Sandbox</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>check for actual closing month</fullName>
        <actions>
            <name>Update_Goal_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Loan_New__c.Closing_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This WR is to check for the closing month and set a Goal for Loan</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
