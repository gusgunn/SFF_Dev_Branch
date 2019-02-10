public class get_FieldsetsSimple {

    /* @gusgunn 9-4-18
     * keep it simple
     * */
    
   @AuraEnabled 
    public static List<String> getFieldSetMember(String objectName , String fieldSetName){
        System.debug('FieldsetName--> ' + fieldSetName);
        System.debug('objectName--> ' + objectName);
        List<String> fieldlNameList = new List<String>();
        Schema.SObjectType sObj = Schema.getGlobalDescribe().get(objectName);
        
        for(Schema.FieldSetMember fieldMember : sObj.getDescribe().fieldSets.getMap().get(fieldSetName).getFields()){
       		   fieldlNameList.add(fieldMember.getFieldPath());
            
               }
            System.debug('#### fieldlNameList '+fieldlNameList);
            return fieldlNameList;
        }
        
}