﻿<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata"><alerts>
        <fullName>Loan_Denied_or_Withdrawn</fullName>
        <ccEmails>ORMSVendor@onereverse.com</ccEmails>
        <description>Loan Denied or Withdrawn</description>
        <protected>false</protected>
        <senderAddress>ormssupport@onereverse.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Loan_Status_Denied_or_Withdrawn</template>
    </alerts><alerts>
        <fullName>Loan_Waiting_for_Full_Package_Alert</fullName>
        <ccEmails>ORMSVendor@onereverse.com</ccEmails>
        <description>Loan Waiting for Full Package Alert</description>
        <protected>false</protected>
        <senderAddress>ormssupport@onereverse.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Loan_Status_Waiting_for_Full_Package</template>
    </alerts><alerts>
        <fullName>ReOS_Email_Alert_Loan</fullName>
        <ccEmails>team-reos-dev@reosapp.io</ccEmails>
        <description>ReOS Email Alert Loan</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>reOS_Email_Templates/reOS_Email_Alert_Loan</template>
    </alerts><fieldUpdates>
        <fullName>Extend_Application_Time</fullName>
        <field>Extend_Application_Time__c</field>
        <literalValue>1</literalValue>
        <name>Extend Application Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>Update_Loan_Date</fullName>
        <field>Loan_Status_Change_Date__c</field>
        <formula>Today()</formula>
        <name>Update Loan Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates><fieldUpdates>
        <fullName>uncheck_IsActive_checkbox</fullName>
        <field>IsActiveFlag__c</field>
        <literalValue>0</literalValue>
        <name>uncheck IsActive checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates><rules>
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
    </rules><rules>
        <fullName>Waiting for Full Package Extend Application</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Loan_New__c.LoanStatus__c</field>
            <operation>equals</operation>
            <value>Waiting for Full Package</value>
        </criteriaItems>
        <description>if Loan stays in this status for 30 days, set extend application time to true</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Extend_Application_Time</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Loan_New__c.Loan_Status_Change_Date__c</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules></Workflow>