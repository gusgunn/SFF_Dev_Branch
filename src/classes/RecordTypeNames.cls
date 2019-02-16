public with sharing class RecordTypeNames {
	
	public static  Map<Id, RecordType> RecordTypeNames(String recordTypeName){
		return Map<Id, RecordType> recordTypesList = [SELECT Id, Name FROM recordType WHERE sObjectType =:recordTypeName ];
	}
}