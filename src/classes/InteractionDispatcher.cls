public class InteractionDispatcher {  
/***
*   @gusgunn
***/
privte static Set<Id> processedCases = new Set<Id> ();

public static Boolean testingException = false;
private static RecordType rTFamilyInteraction = [SELECT Id, Name FROM recordType WHERE Name = 'Family Case' AND sObjectType = 'Case' LIMIT 1];
private static RecordType rTProfInteraction = [SELECT Id, Name FROM recordType WHERE Name = 'Professional Case' AND sObjectType = 'Case' LIMIT 1];
private static RecordType rTIntakeSurvey = [SELECT Id, Name FROM recordType WHERE Name = 'Intake Survey' AND sObjectType = 'Case' LIMIT 1];
private static RecordType rTSwFAF = [SELECT Id, Name FROM recordType WHERE Name = 'SW Family Assessment' AND sObjectType = 'Case' LIMIT 1]; //Family_Assessment
private static RecordType rTSfin = [SELECT Id, Name FROM recordType WHERE Name = 'Inclusion Interaction' AND sObjectType = 'Case' LIMIT 1];//Inclusion_Interaction
private static Profile SW = [SELECT Id, Name from Profile where name ='SFCD Social Worker' LIMIT 1];
                                
public static void getInteractionRecordType (List<Case> listIn){ 
    Map <Id, RecordType> interactionRecordTypes =RecordTypes.getRecordTypes('Case');
    List<Case> filteredList = RecordTypeFilter.getRecordTypeNames('Case');
    List<Case> familyAssessments = new List<Case>();
    List<Case> intakeSurveys = new List<Case>();
    List<Case> SFINInteraction = new List<Case>();
    List<Case> professionalInteractions = new List<Case>();
    List<Case> familyInteractions = new List<Case>();
    
    for (case cas: filteredList){
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

// new class for each - ALL case inserts and updates go through this
// send updates to worker - but dont update right away. update on trigger after all trigger methods fire.
//include set for no repeats
public static Map<Integer, List<sObject>> processFamiliyAssessments (List<Case> filteredList){   
    Map<Integer, List<sObject>> indexToObjects = new Map<Integer, List<SObject>>();
    Integer isIndex =0;
    List<npo02__Household__c> housholdInteractionDateUpdates = LastHouseholdSWAssessments(filteredList);
    if(housholdInteractionDateUpdates.size()>0){
        indexToObjects.put(isIndex, housholdInteractionDateUpdates); 
        isIndex = isIndex + 1;
    }
    Integer startingIndex = 0;
    
    if (indexToObjects.size()>0) {
        System.enqueueJob(new Worker(indexToObjects, startingIndex));
    }else {
        //
    }
    return indexToObjects;
}

public static Map<Integer, List<sObject>> processIntakeSurveys (List<Case> filteredList){  
    Map<Integer, List<sObject>> indexToObjects = new Map<Integer, List<SObject>>();
    Integer isIndex =0;
    //send list to become a map and select hh's in keyset
    List<npo02__Household__c> housholdInteractionDateUpdates = LastHouseholdIntakeSurvey(filteredList);
    if(housholdInteractionDateUpdates.size()>0){
        indexToObjects.put(isIndex, housholdInteractionDateUpdates); 
        isIndex = isIndex + 1;
    }
    
    Integer startingIndex = 0;
    
    if (indexToObjects.size()>0) {
        System.enqueueJob(new Worker(indexToObjects, startingIndex));
    }
    return indexToObjects;
}

public static Map<Integer, List<sObject>> processFamiliyInteractions (List<Case> filteredList){         
    Map<Integer, List<sObject>> indexToObjects = new Map<Integer, List<SObject>>();
    Integer isIndex =0;
    List<npo02__Household__c> housholdInteractionDateUpdates = LastHouseholdInteractions(filteredList);
    if(housholdInteractionDateUpdates.size()>0){
        indexToObjects.put(isIndex, housholdInteractionDateUpdates); 
        isIndex = isIndex + 1;
    }
    List<Contact> contactInteractionDateUpdates = LastFamilyInteractionCaseDate(filteredList);
    if(contactInteractionDateUpdates.size()>0){
        indexToObjects.put(isIndex, contactInteractionDateUpdates); 
        isIndex = isIndex + 1;
    }
    
    Integer startingIndex = 0;
    
    if (indexToObjects.size()>0) {
        System.enqueueJob(new Worker(indexToObjects, startingIndex));
    }
    return indexToObjects;
}

public static List<Contact> LastFamilyInteractionCaseDate(list<Case> cases){
    Map<Integer, List<sObject>> indexToObjects = new Map<Integer, List<SObject>>();
    Map<ID, Case> caseMap = new Map<ID, Case>();
    List<Contact> interactionList = new List<Contact>();
    // Any Interaction- Call type not left message? Last_Interaction_Date__c
    for (case cas: cases){
        if(cas.RecordTypeId == rTFamilyInteraction.Id){
            caseMap.put(cas.ContactID, cas);
            System.Debug('Contact todays Int Date= ' + caseMap);
        }
        If(cas.Family__Child__c!=NULL ){
            caseMap.put(cas.Family__Child__c, cas);
        }
    }
    System.debug('caseMap =' + caseMap);
    if(caseMap.size()>0){
        List <Contact> conInteractions = InteractionSelector.getContactInteractions(caseMap);
        Set<ID> keys = caseMap.keySet();
        //for (ID k: keys) { 
        for(Contact c: conInteractions){
            Contact UpdateCon = new Contact();
            Boolean conUpdated = false;
            if(caseMap.containsKey(c.ID) )
                UpdateCon.ID = c.id; 
            if(c.Last_Interaction_Date__c ==  NULL || c.Last_Interaction_Date__c < caseMap.get(c.ID).Start_Time__c.date()){
                System.debug('caseMap.get(k)= ' + caseMap.get(c.ID).Start_Time__c.date());
                System.Debug('Contact ID & Date = ' + c +  '  ' + UpdateCon.Last_Interaction_Date__c);
                UpdateCon.Last_Interaction_Date__c = caseMap.get(c.ID).Start_Time__c.date();
                conUpdated = True;
            }
            if(c.First_Interaction__c == NULL || c.First_Interaction__c > caseMap.get(c.ID).Start_Time__c.date()){
                UpdateCon.First_Interaction__c = caseMap.get(c.ID).Start_Time__c.date();
                conUpdated = True;
            } 
            if(conUpdated == true) interactionList.add(UpdateCon);  
        }   
    }
    System.debug('Interaction Date List= ' + interactionList.size());        
    return interactionList;
} 

public static List<npo02__Household__c> LastHouseholdInteractions(list <case> cases){
    System.Debug('getLastHouseholdInteractions running. Size = ' + cases);
    // if SW do SW HH fields. 
    // If FRS, do FRS.
    Map<ID, Case> caseMap = new Map<ID, Case>();
    Map<ID, Case> swCaseMap = new Map<ID, Case>();
    Map<ID, Case> frsCaseMap = new Map<ID, Case>();
    List<npo02__Household__c> interactionList = new List<npo02__Household__c>();
    
    for (case cas: cases){
        caseMap.put(cas.Family__Household__c, cas); 
        
        if (cas.RecordTypeId == rTFamilyInteraction.Id && cas.Created_by_CM__c == false){
            System.debug('Case created by__>' + cas.createdBy + '  Is SW?-->' +  cas.Created_by_CM__c );
        
            frsCaseMap.put(cas.Family__Household__c, cas); 
        }else {
            swCaseMap.put(cas.Family__Household__c, cas);
        }
        
    } 
    
    List <npo02__Household__c> hhInteractions = InteractionSelector.getHouseholdInteractions(caseMap);
    System.debug('caseMap in  getHouseholdInteractions = ' + caseMap);
    
    
    for(npo02__Household__c h : hhInteractions) {
        npo02__Household__c updateHousehold = new npo02__Household__c();
        
            if(caseMap.get(h.ID).Call_Type__c =='Intake' ){
                if(h.Last_Intake__c ==  NULL || h.Last_Intake__c < caseMap.get(h.ID).Start_Time__c.date()){
                    updateHousehold.Last_Intake__c = caseMap.get(h.ID).Start_Time__c.date();
                }
                System.Debug(h.First_Intake__c );    
                if(h.First_Intake__c == NULL || h.First_Intake__c > caseMap.get(h.ID).Start_Time__c.date()){
                    updateHousehold.First_Intake__c = caseMap.get(h.ID).Start_Time__c.date();
                } 
            }
        
        if(frsCaseMap.containsKey(h.ID)) {
                updateHousehold.ID = frsCaseMap.get(h.ID).Family__Household__c;
            if (h.Most_Recent_Household_Interaction__c ==  NULL 
                || h.Most_Recent_Household_Interaction__c < frsCaseMap.get(h.ID).Start_Time__c.date()){
                    updateHousehold.Most_Recent_Household_Interaction__c = frsCaseMap.get(h.ID).Start_Time__c.date();
                    updateHousehold.Most_Recent_HH_Interaction_Call_Type__c = frsCaseMap.get(h.ID).Call_Type__c;
                    System.Debug(h.Most_Recent_Household_Interaction__c ); 
                } 
            if(h.First_Interaction__c == NULL || h.First_Interaction__c > frsCaseMap.get(h.ID).Start_Time__c.date()){
                updateHousehold.First_Interaction__c = frsCaseMap.get(h.ID).Start_Time__c.date();
            }
        }
        
            if(swCaseMap.containsKey(h.ID)) {
                updateHousehold.ID = swCaseMap.get(h.ID).Family__Household__c;
            if (h.Most_Recent_SW_HH_Interaction__c ==  NULL 
                || h.Most_Recent_SW_HH_Interaction__c < swCaseMap.get(h.ID).Start_Time__c.date()){
                    updateHousehold.Most_Recent_SW_HH_Interaction__c = swCaseMap.get(h.ID).Start_Time__c.date();
                    //updateHousehold.Most_Recent_HH_Interaction_Call_Type__c = swCaseMap.get(h.ID).Call_Type__c;
                    System.Debug(h.Most_Recent_SW_HH_Interaction__c ); 
                } 
            if(h.First_SW_HH_Interaction__c == NULL || h.First_SW_HH_Interaction__c > swCaseMap.get(h.ID).Start_Time__c.date()){
                updateHousehold.First_SW_HH_Interaction__c = swCaseMap.get(h.ID).Start_Time__c.date();
            }
        }
        interactionList.add(updateHousehold);
    }
    return interactionList;
}

@AuraEnabled
public static List<npo02__Household__c> LastHouseholdSWAssessments(list <case> cases){
    System.Debug('getLastHouseholdInteractions running. Size = ' + cases);
    //Making map here becuase need list for First and Last Interaction updates on Contact (Caregiver and child)
    Map<ID, Case> caseMap = new Map<ID, Case>();
    List<npo02__Household__c> interactionList = new List<npo02__Household__c>();
    // Any Familiy Interaction attempt inc left message = Last_Interaction_Date__c
    For (case cas: cases){
        if (cas.RecordTypeId == rTSwFAF.Id){
            caseMap.put(cas.Family__Household__c, cas); 
        }
    }
    List <npo02__Household__c> hhInteractions = InteractionSelector.getHouseholdInteractions(caseMap);
    System.debug('caseMap in  getHouseholdInteractions = ' + caseMap);
    for(npo02__Household__c h : hhInteractions) {
        npo02__Household__c updateHousehold = new npo02__Household__c();
        // find 1 match
        if(caseMap.containsKey(h.ID)) {
            
            updateHousehold.ID = caseMap.get(h.ID).Family__Household__c;
            if (h.Most_Recent_Family_Assessment__c ==  NULL 
                || h.Most_Recent_Family_Assessment__c < caseMap.get(h.ID).Start_Time__c.date()){
                    updateHousehold.Most_Recent_Family_Assessment__c = caseMap.get(h.ID).Start_Time__c.date();
                    System.Debug(h.Most_Recent_Family_Assessment__c ); 
                } 
            if(h.First_Family_Assessment__c == NULL || h.First_Family_Assessment__c > caseMap.get(h.ID).Start_Time__c.date()){
                updateHousehold.First_Family_Assessment__c = caseMap.get(h.ID).Start_Time__c.date();
            }
        }
        interactionList.add(updateHousehold);
    }
    return interactionList;
}

@AuraEnabled
public static List<npo02__Household__c> LastHouseholdIntakeSurvey(list <case> cases){
    System.Debug('getLastHouseholdInteractions running. Size = ' + cases);
    
    Map<ID, Case> caseMap = new Map<ID, Case>();
    List<npo02__Household__c> interactionList = new List<npo02__Household__c>();
    
    For (case cas: cases){
        if (cas.RecordTypeId == rTIntakeSurvey.Id){
            caseMap.put(cas.Family__Household__c, cas); 
        }
    }
    List <npo02__Household__c> hhInteractions = InteractionSelector.getHouseholdInteractions(caseMap);
    System.debug('caseMap in  getHouseholdInteractions = ' + caseMap);
    
    for(npo02__Household__c h : hhInteractions) {
        npo02__Household__c updateHousehold = new npo02__Household__c();
        
        if(caseMap.containsKey(h.ID)) {
            updateHousehold.ID = caseMap.get(h.ID).Family__Household__c;
            if (h.Most_Recent_Intake_Survey__c ==  NULL 
                || h.Most_Recent_Intake_Survey__c < caseMap.get(h.ID).Start_Time__c.date()){
                    updateHousehold.Most_Recent_Intake_Survey__c = caseMap.get(h.ID).Start_Time__c.date();
                    System.Debug(h.Most_Recent_Intake_Survey__c ); 
                } 
            if(h.First_Intake_Survey__c == NULL || h.First_Intake_Survey__c > caseMap.get(h.ID).Start_Time__c.date()){
                updateHousehold.First_Intake_Survey__c = caseMap.get(h.ID).Start_Time__c.date();
            }
        }
        interactionList.add(updateHousehold);
    }
    return interactionList;
}

@AuraEnabled
public static void processProfessionalInteractions(list <case> cases){
    
    List<Case> findNeedConsents = new List<case>();
    
    List<Consent__c> interactionList = new List<Consent__c>();
    
    // Professional records, consent per Org and Child
    String HouseholdKey = NULL;
    String key = Null;  
    //InteractionSelector.getInteractionAccounts(cases);
    For (case cas: cases){
        Boolean caseIsProfessional = (cas.recordtypeID == rTProfInteraction.Id);
        Boolean caseNotPMP = (!cas.Call_Type__c.contains('PMP'));
        Boolean caseHasChild = (cas.Family__Child__c != NULL && string.ValueOf( cas.Family__Child__c)!='');
        Boolean casehasHousehold = (cas.Family__Household__c != NULL);
        Boolean caseIsInternalSFCD = (cas.AccountId != '001G000001kuowUIAQ'); 
        If(caseIsProfessional && caseNotPMP && caseHasChild){
                System.debug(' in consents');
            findNeedConsents.add(cas);
        }
        if(findNeedConsents.size()>0){
            RelationshipsMethods.getEnterRelationshipTrack(findNeedConsents);
            Map <String, List<Case>>  returnedNeedConsentsMap = getMakeKeys(findNeedConsents);
            
            if (returnedNeedConsentsMap.keySet().size() > 0){
                System.debug(' if returnedNeedConsentsMap>0 Send  To Consent');
                ConsentMethods.getEnterConsentTrack(returnedNeedConsentsMap); 
            }
        }
    }
    
}

public static Map<String, List <Case>> getMakeKeys(List <Case> newfilteredList){
    System.debug('getMakeKeys'  +  newfilteredList.size() );
    Map <String, List<Case>> casesMapList = new Map <String, List<Case>>();
    Map<String, String> newKeysMap = new Map <String, String>();
    for(Case a: newfilteredList){
        
        /*** 
* For now just write it if there is an 001 Org listed. 
* These cases all have children listed as per above
* Make Key for Child & Professional's Org
* **/
        
        String key = string.ValueOf(a.AccountID) + string.ValueOf( a.Family__Child__c);
        newKeysMap.put(key, key);
        // If the key has already been added to the Map
        if (casesMapList.containsKey(key)){
            System.debug('found dupe key');
            casesMapList.get(key).add(a);
            System.debug('get(key).add(a);' + key +' ' + casesMapList.size());
            System.debug('.   keyset= ' + casesMapList.keyset());
            System.debug('.  casesMapList sfter dupe found values= ' + casesMapList.values().size());
        } else {
            // casesMapList.put(a.ReferralKey__c, new List<Action__c>{a});
            casesMapList.put(key, new List<Case>{a});
            
            System.debug('.  casesMapList after new entry= ' + casesMapList.size());   
        } 
    }
    return casesMapList;
} 
}