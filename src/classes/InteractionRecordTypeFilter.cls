public with sharing class InteractionRecordTypeFilter {

	public static Boolean testingException = false;

	public Map<Id, RecordType> InteractionRecordType (String recordTypeName){ 
		
		Map<Id, RecordType> recordTypesList = [SELECT Id, Name FROM recordType WHERE sObjectType =:recordTypeName ];
	
		RecordType rTFamilyInteraction = [SELECT Id, Name FROM recordType WHERE Name = 'Family Case' AND sObjectType = 'Case' LIMIT 1];
	    RecordType rTProfInteraction = [SELECT Id, Name FROM recordType WHERE Name = 'Professional Case' AND sObjectType = 'Case' LIMIT 1];
	    RecordType rTIntakeSurvey = [SELECT Id, Name FROM recordType WHERE Name = 'Intake Survey' AND sObjectType = 'Case' LIMIT 1];
	    RecordType rTSwFAF = [SELECT Id, Name FROM recordType WHERE Name = 'SW Family Assessment' AND sObjectType = 'Case' LIMIT 1]; //Family_Assessment
	    RecordType rTSfin = [SELECT Id, Name FROM recordType WHERE Name = 'Inclusion Interaction' AND sObjectType = 'Case' LIMIT 1];//Inclusion_Interaction
	    Profile SW = [SELECT Id, Name from Profile where name ='SFCD Social Worker' LIMIT 1];
		}
	}							

}