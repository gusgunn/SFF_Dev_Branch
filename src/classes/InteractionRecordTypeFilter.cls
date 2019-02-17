public with sharing class InteractionRecordTypeFilter {

	public static Boolean testingException = false;

	public static List<Case> SWfamilyAssessmentsList = new List<Case>();
    public static List<Case> intakeSurveysList = new List<Case>();
    public static List<Case> professionalInteractionsList = new List<Case>();
    public static List<Case> familyInteractionsList = new List<Case>();
	public static List<Case> SFINInteractionsList = new List<Case>();

	private static RecordType rTFamilyInteraction;
    private static RecordType rTProffessionalInteraction; 
    private static RecordType rTIntakeSurvey;
    private static RecordType rTSWfamilyAssessment; 
    private static RecordType rTSfin;

	public static void getFamiliyInteractionRecordType (Map<Id, RecordType> interactionRecordTypes, List<Case> listIn){ 	
       rTFamilyInteraction = [SELECT Id, Name FROM recordType WHERE Name = 'Family Case' AND sObjectType = 'Case' LIMIT 1];
	}
	public static void getSWfamilyAssessmentRecordType (Map<Id, RecordType> interactionRecordTypes, List<Case> listIn){ 	
       SWfamilyAssessment = [SELECT Id, Name FROM recordType WHERE Name = 'SW Family Assessment' AND sObjectType = 'Case' LIMIT 1]; 
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

	public static getPamilyAssessmentsList(){
		return familyAssessmentsList;
	}
	public static getPntakeSurveysListList(){
		returnintakeSurveysList;
	}
	public static getProfessionalInteractionsList(){
		return professionalInteractionsList;
	}
	public static getFamiliyInteractionsList(){
		return familyInteractionsList;
	}
	public static getSFINInteractionsList(){
		return SFINInteractionsList;
	}
	
	public static void sortAllInteractionsByRecordType (Map<Id, RecordType> interactionRecordTypes, List<Case> listIn){  
	for (case cas: listIn){
		for (recordType rt: interactionRecordTypes.values(){
			if(rt.Name == 'SW Family Assessment'){
				  if (interactionRecordTypes.containsKey(cas.recordtypeID) {
				      familyAssessmentsList.add(cas);
				  } else if(rt.Name == 'Intake Survey'){
					  if (interactionRecordTypes.containsKey(cas.recordtypeID){
						  intakeSurveysList.add(cas);
			            } else if(rt.Name == 'Professional Case'){
							if (interactionRecordTypes.containsKey(cas.recordtypeID){
								Boolean caseHasChild = (cas.Family__Child__c != NULL && string.valueOf( cas.Family__Child__c)!='');
								Boolean casehasHousehold = (cas.Family__Household__c != NULL); //
								Boolean caseNotPMP = (!cas.Call_Type__c.contains('PMP'));
								If(caseNotPMP && casehasHousehold && caseHasChild){
									professionalInteractionsList.add(cas);
									} else if(rt.Name == 'Family Case'){
										if (interactionRecordTypes.containsKey(cas.recordtypeID){
											familyInteractionsList.add(cas);
										    } else if(rt.Name == 'Inclusion Interaction'){
												if (interactionRecordTypes.containsKey(cas.recordtypeID){
													SFINInteractionsList.add(cas);
												} else {
														//not using this interaction record type
											}

									
									
		    }

									}
	
	}
							}	/*
	for (recordType rt: interactionRecordTypes.values(){
		if(rt.Name == 'SW Family Assessment'){
           for (case cas: listIn){
			   if (interactionRecordTypes.containsKey(cas.recordtypeID) {
				   familyAssessments.add(cas);
			    }
		   }
		
		} else if(rt.Name == 'Intake Survey'){
			for (case cas: listIn){
				if (interactionRecordTypes.containsKey(cas.recordtypeID){
					intakeSurveys.add(cas);
			    }
		    }
	    } else if(rt.Name == 'Professional Case'){
			for (case cas: listIn){
				if (interactionRecordTypes.containsKey(cas.recordtypeID){
					professionalInteractions.add(cas);
			    }
		    }
	    } else if(rt.Name == 'Family Case'){
			for (case cas: listIn){
				if (interactionRecordTypes.containsKey(cas.recordtypeID){
					familyInteractions.add(cas);
			    }
		    }
	    }
    for (case cas: listIn){
		 if (interactionRecordTypes.containsKey(cas.recordtypeID)
        if(cas.recordtypeID == rTSwFAF.Id){

            familyAssessments.add(cas);
        } else if(cas.recordtypeID == rTIntakeSurvey.Id){
            intakeSurveys.add(cas);
        } else if (cas.recordtypeID == rTSfin.Id){
            SFINInteraction.add(cas); 
        } else {
            Boolean caseHasChild = (cas.Family__Child__c != NULL && string.ValueOf( cas.Family__Child__c)!='');
            Boolean casehasHousehold = (cas.Family__Household__c != NULL);
            Boolean caseIsProfessional = (cas.recordtypeID == rTProfInteraction.Id);
            Boolean caseNotPMP = (!cas.Call_Type__c.contains('PMP'));
            Boolean caseIsFamily = (cas.recordtypeID == rTFamilyInteraction.Id);
            If(caseIsProfessional && caseNotPMP && caseHasChild){
                professionalInteractions.add(cas);
            } else if(caseIsFamily){
                familyInteractions.add(cas); 
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