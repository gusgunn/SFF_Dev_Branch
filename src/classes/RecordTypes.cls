public class RecordTypes {
	public static  Map<Id, RecordType> RecordTypeNames(String recordTypeName){
        Map<Id, RecordType> recordTypesMap = new Map<Id, RecordType>([SELECT Id, Name FROM recordType WHERE sObjectType =:recordTypeName ]);
		return recordTypesMap;  
	}
}