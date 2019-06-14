/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface PS_DescribeHelper3 {
    Integer countQuery(String param0);
    Database.QueryLocator getQueryLocator(String param0, Map<String,Object> param1);
    Map<String,Schema.DescribeFieldResult> getThisAllFieldsDescribe(String param0);
    Schema.DescribeFieldResult getThisFieldDescribe(Schema.ChildRelationship param0);
    Schema.DescribeFieldResult getThisFieldDescribe(String param0, Schema.SObjectField param1);
    Schema.DescribeFieldResult getThisFieldDescribe(String param0, String param1);
    String getThisFieldLabel(String param0, String param1);
    String getThisFieldType(String param0, String param1);
    Schema.DescribeSObjectResult getThisObjectDescribe(Schema.SObjectType param0);
    Schema.DescribeSObjectResult getThisObjectDescribe(String param0);
    String getThisObjectLabel(String param0);
    SObject getThisPrototypeObject(String param0);
    Boolean isThisObjectIdThisType(Id param0, String param1);
    List<SObject> query(String param0);
    List<SObject> query(String param0, Map<String,Object> param1);
}
