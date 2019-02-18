public with sharing class InteractionRecordTypeFilter {

	public static Boolean testingException = false;
	//make private if can
	public static Map<Id, Case> SWfamilyAssessmentsMap = new Map<Id, Case>();
    public static Map<Id, Case> intakeSurveysMap = new Map<Id, Case>();
    public static Map<Id, Case> professionalInteractionsOboMap = new Map<Id, Case>();
    public static Map<Id, Case> familyInteractionsMap = new Map<Id, Case>();
	public static Map<Id, Case> SFINInteractionsMap = new Map<Id, Case>();
	public static List <Case> professionalAndChildsRelationshipsList = new List <Case>();
	private static RecordType rTFamilyInteraction;
    private static RecordType rTProffessionalInteraction; 
    private static RecordType rTIntakeSurvey;
    private static RecordType rTSWfamilyAssessment; 
    private static RecordType rTSfin;

	public static void getFamiliyInteractionRecordType (Map<Id, RecordType> interactionRecordTypes, List<Case> listIn){ 	
       rTFamilyInteraction = [SELECT Id, Name FROM recordType WHERE Name = 'Family Case' AND sObjectType = 'Case' LIMIT 1];
	}
	public static void getSWfamilyAssessmentRecordType (Map<Id, RecordType> interactionRecordTypes, List<Case> listIn){ 	
       rtSWfamilyAssessment = [SELECT Id, Name FROM recordType WHERE Name = 'SW Family Assessment' AND sObjectType = 'Case' LIMIT 1]; 
	}
	public static void getProffessionalInteractionRecordType (Map<Id, RecordType> interactionRecordTypes, List<Case> listIn){ 	
       rTProffessionalInteraction = [SELECT Id, Name FROM recordType WHERE Name = 'Professional Case' AND sObjectType = 'Case' LIMIT 1];
	}
	public static void getIntakeSurveyRecordType (Map<Id, RecordType> interactionRecordTypes, List<Case> listIn){ 	
       rTIntakeSurvey = [SELECT Id, Name FROM recordType WHERE Name = 'Intake Survey' AND sObjectType = 'Case' LIMIT 1];
	}
	public static void getSFINRecordType (Map<Id, RecordType> interactionRecordTypes, List<Case> listIn){ 	
       rTSfin = [SELECT Id, Name FROM recordType WHERE Name = 'Inclusion Interaction' AND sObjectType = 'Case' LIMIT 1];
	}

	public static Map<Id, Case> getSWFamilyAssessmentsMap(){
		return SWfamilyAssessmentsMap;
	}
	public static Map<Id, Case> getIntakeSurveysMap(){
		return intakeSurveysMap;
	}
	public static Map<Id, Case> getProfessionalInteractionsOboMap(){
		return professionalInteractionsOboMap;
	}
	public static Map<Id, Case> getFamiliyInteractionsMap(){
		return familyInteractionsMap;
	}
	public static Map<Id, Case> getSFINInteractionsMap(){
		return SFINInteractionsMap;
	}
    public static List<Case> getProfessionalAndChildsRelationshipsList(){
		return professionalAndChildsRelationshipsList;
	}
    
	
	public static void sortAllInteractionsByRecordType (Map<Id, RecordType> interactionRecordTypes, List<Case> listIn){  
        system.debug('**************************sortAllInteractionsByRecordType');
	for (case cas: listIn){
		for (recordType rt: interactionRecordTypes.values()){
			if(rt.Name == 'SW Family Assessment' && interactionRecordTypes.containsKey(cas.recordtypeID)){
				      SWfamilyAssessmentsMap.put(cas.Id, cas);
					  continue;
				  } else if(rt.Name == 'Intake Survey' && interactionRecordTypes.containsKey(cas.recordtypeID)){
						  intakeSurveysMap.put(cas.Id, cas);
						  continue;
			            } else if(rt.Name == 'Professional Case' && interactionRecordTypes.containsKey(cas.recordtypeID)){
								Boolean caseHasChild = (cas.Family__Child__c != NULL && string.valueOf( cas.Family__Child__c)!='');
								Boolean casehasHousehold = (cas.Family__Household__c != NULL); 
								Boolean caseNotPMP = (!cas.Call_Type__c.contains('PMP'));
                                Boolean caseIsNotInternalSFCD = (cas.AccountId != '001G000001kuowUIAQ'); 
								    If(caseNotPMP && casehasHousehold && caseHasChild && caseIsNotInternalSFCD){
									professionalInteractionsOboMap.put(cas.Id, cas);
                                    professionalAndChildsRelationshipsList.add(cas);
								    }
									continue;
								} else if(rt.Name == 'Family Case' && interactionRecordTypes.containsKey(cas.recordtypeID)){
											familyInteractionsMap.put(cas.Id, cas);
											continue;
										    } else if(rt.Name == 'Inclusion Interaction' && interactionRecordTypes.containsKey(cas.recordtypeID)){
													SFINInteractionsMap.put(cas.Id, cas);
											}

									
									
		    }

									}
	
	}
							}	/*
	for (recordType rt: interactionRecordTypes.values(){
		if(rt.Name == 'SW Family Assessment'){
           for (case cas: listIn){
			   if (interactionRecordTypes.containsKey(cas.recordtypeID) {
				   familyAssessments.put(cas);
			    }
		   }
		
		} else if(rt.Name == 'Intake Survey'){
			for (case cas: listIn){
				if (interactionRecordTypes.containsKey(cas.recordtypeID){
					intakeSurveys.put(cas);
			    }
		    }
	    } else if(rt.Name == 'Professional Case'){
			for (case cas: listIn){
				if (interactionRecordTypes.containsKey(cas.recordtypeID){
					professionalInteractions.put(cas);
			    }
		    }
	    } else if(rt.Name == 'Family Case'){
			for (case cas: listIn){
				if (interactionRecordTypes.containsKey(cas.recordtypeID){
					familyInteractions.put(cas);
			    }
		    }
	    }
    for (case cas: listIn){
		 if (interactionRecordTypes.containsKey(cas.recordtypeID)
        if(cas.recordtypeID == rTSwFAF.Id){

            familyAssessments.put(cas);
        } else if(cas.recordtypeID == rTIntakeSurvey.Id){
            intakeSurveys.put(cas);
        } else if (cas.recordtypeID == rTSfin.Id){
            SFINInteraction.put(cas); 
        } else {
            Boolean caseHasChild = (cas.Family__Child__c != NULL && string.ValueOf( cas.Family__Child__c)!='');
            Boolean casehasHousehold = (cas.Family__Household__c != NULL);
            Boolean caseIsProfessional = (cas.recordtypeID == rTProfInteraction.Id);
            Boolean caseNotPMP = (!cas.Call_Type__c.contains('PMP'));
            Boolean caseIsFamily = (cas.recordtypeID == rTFamilyInteraction.Id);
            If(caseIsProfessional && caseNotPMP && caseHasChild){
                professionalInteractions.put(cas);
            } else if(caseIsFamily){
                familyInteractions.put(cas); 
            }else{
                System.debug('no relevant recordType +  call type' + cas.recordtypeID + ' ' + cas.Call_Type__c); 
            }
        }  
    }
    if (familyAssessments.size()>0){
        processFamiliyAssessments(familyAssessments);
    }
    if (intakeSurveys.size()>0) {
        processIntakeSurveys(intakeSurveys);
    }
    if (familyInteractions.size()>0){
        processFamiliyInteractions(familyInteractions);
            System.debug ('Family Int Selcted');
    }
    if (professionalInteractions.size()>0){
        processProfessionalInteractions(professionalInteractions);
        System.debug ('pof Int Selected');
    }

	}	
						

}*/