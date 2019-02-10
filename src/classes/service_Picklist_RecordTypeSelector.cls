public class service_Picklist_RecordTypeSelector {
    private class PicklistRecordTypeServiceException extends Exception {}
    @AuraEnabled
    public static Map<Id, String> recordtypemap {get;set;}
    
    @AuraEnabled        
    public static Map<Id, String> getRecordTypeMap(String objectName){
        recordtypemap = new Map<Id, String>();  
        system.debug('in rt s');
        try {
            Object objType = ((SObject)Type.forName(objectName).newInstance()).getSObjectType();
            String objTypeName = String.ValueOf(objType);
            System.debug('objType: ' + objType);
            System.debug(objectName + ' vs ' + objTypeName);
            if (objectName == null || string.isBlank(objectName) || objTypeName != objectName) {
                
                throw new PicklistRecordTypeServiceException('No such Object.');
            }
            
            List<Schema.RecordTypeInfo> recordtypes = Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfos(); 
            for(RecordTypeInfo rt : recordtypes){
                if(rt.getName() != 'Master' && rt.getName().trim() !='')
                    recordtypemap.put(rt.getRecordTypeId(), rt.getName());
            }
        } catch (Exception e) {
            throw new AuraHandledException('Failed to retrieve recordTypes for  ' + objectName + '.: ' + e.getMessage());
        }
        
        system.debug('recordTypeMap --> ' + recordtypemap);
        return recordtypemap;
        
    }
    
}