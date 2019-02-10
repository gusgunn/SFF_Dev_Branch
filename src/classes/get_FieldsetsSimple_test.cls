@isTest
/***********
* 9/4/18 Novo phoneline
* GG
***********/

private class get_FieldsetsSimple_test {

    
     @isTest 
    static void testFetchFieldsetApiNames(){
        String objectName = 'Contact';
        String fieldSetName = 'Default';
        get_FieldsetsSimple.getFieldSetMember(objectName, fieldSetName);   
    }
}