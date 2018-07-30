@isTest
public with sharing class AttachmentResponseTest {
    
    @isTest
    public static void AttachmentResponseMethodTest()
    {
        AttachmentResponse AttRes = new AttachmentResponse();
        AttRes.Id = '00P0q000000UZnHEAW';
        AttRes.DocName = 'Dtest';
        AttRes.CreatedDate = '20170707';
        AttRes.UploadedBy = 'Drush';
        System.assertEquals(AttRes.DocName, 'Dtest');
    }

}