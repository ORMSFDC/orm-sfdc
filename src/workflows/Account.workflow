<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata"><alerts>
        <fullName>Email_Alert_to_AE_when_CRA_status_of_partner_changes</fullName>
        <description>Email Alert to AE when CRA status of partner changes</description>
        <protected>false</protected>
        <recipients>
            <field>Account_Executive_Name__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/AE_notification_when_CRA_value_changes</template>
    </alerts><alerts>
        <fullName>QLMS_AE_App_Sent_notification_email</fullName>
        <description>QLMS AE App Sent notification email</description>
        <protected>false</protected>
        <recipients>
            <field>QLMS_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AE_Notification_Emails/QLMS_AE_App_Sent_notification</template>
    </alerts><alerts>
        <fullName>QLMS_AE_Approved_notification_email</fullName>
        <description>QLMS AE Approved notification email</description>
        <protected>false</protected>
        <recipients>
            <field>QLMS_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AE_Notification_Emails/QLMS_AE_Approved_notification</template>
    </alerts><alerts>
        <fullName>QLMS_AE_Denied_notification_email</fullName>
        <description>QLMS AE Denied notification email</description>
        <protected>false</protected>
        <recipients>
            <field>QLMS_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AE_Notification_Emails/QLMS_AE_Denied_notification</template>
    </alerts><alerts>
        <fullName>QLMS_AE_In_Process_notification_email</fullName>
        <description>QLMS AE In Process notification email</description>
        <protected>false</protected>
        <recipients>
            <field>QLMS_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>AE_Notification_Emails/QLMS_AE_In_Process_notification</template>
    </alerts><fieldUpdates>
        <fullName>App_Processed_Date</fullName>
        <description>When Lead Status is Approved</description>
        <field>App_Processed__c</field>
        <formula>TODAY()</formula>
        <name>App Processed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>App_Received_Date</fullName>
        <field>App_Received__c</field>
        <formula>TODAY()</formula>
        <name>App Received Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>NMLS_Expiration_Date</fullName>
        <description>Auto Update NMLS expiration date to 12/31 of every year</description>
        <field>Company_NMLS_ID_Expiration_Date__c</field>
        <formula>DATE( YEAR( TODAY() ), 12, 31)</formula>
        <name>NMLS Expiration Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Update_App_Sent_Date_Field</fullName>
        <field>App_Sent__c</field>
        <formula>Today()</formula>
        <name>Update App Sent Date Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Update_Date</fullName>
        <field>Lead_status_change_date__c</field>
        <formula>Today()</formula>
        <name>Update Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>update_QLMS_email</fullName>
        <description>The QLMS_Email__c field is updated on Account</description>
        <field>QLMS_Email__c</field>
        <formula>QLMS_Account_Executive__r.Email__c</formula>
        <name>update QLMS email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates><rules>
        <fullName>App Processed</fullName>
        <actions>
            <name>App_Processed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When Lead is Approved</description>
        <formula>AND(ISPICKVAL(Partner_Lead_Status__c, 'Approved') , Not(ISPICKVAL(PRIORVALUE(Partner_Lead_Status__c),"Approved")))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules><rules>
        <fullName>App Received</fullName>
        <actions>
            <name>App_Received_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When Lead Status is InProcess</description>
        <formula>AND( ISPICKVAL(Partner_Lead_Status__c, 'Processing') , Not(ISPICKVAL(PRIORVALUE(Partner_Lead_Status__c),"Processing")))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules><rules>
        <fullName>Auto Update NMLS ID Expiration Date</fullName>
        <actions>
            <name>NMLS_Expiration_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Company_NMLS_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Auto-populate NMLS ID expiration date - 12/31 of each year</description>
        <triggerType>onAllChanges</triggerType>
    </rules><rules>
        <fullName>QLMS Email update</fullName>
        <actions>
            <name>update_QLMS_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Partner_Lead_Status__c</field>
            <operation>equals</operation>
            <value>New,Prospect,App Sent,Processing,Not Interested,Approved,Denied</value>
        </criteriaItems>
        <description>This workflow is to update QLMS Email field on Account, so that this field can be used for Email Alerts on Account</description>
        <triggerType>onAllChanges</triggerType>
    </rules><rules>
        <fullName>When Status App Sent</fullName>
        <actions>
            <name>Update_App_Sent_Date_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND( ISPICKVAL(Partner_Lead_Status__c, 'App Sent') ,  Not(ISPICKVAL(PRIORVALUE(Partner_Lead_Status__c),"App Sent")))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules></Workflow>