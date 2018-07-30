@isTest
public with sharing class DocResponseTest {
    
    @isTest
    public static void DocResponseMethodTest()
    {
        DocResponse DocRes = new DocResponse();
        DocRes.Id = '00P0q000000UZnHEAW';
        DocRes.DocTitle = 'Test Doc Title';
        DocRes.UploaderName = 'Drush';
        DocRes.CreatedDate = '20170707';
        System.assertEquals(DocRes.DocTitle, 'Test Doc Title');
    }

}