public class InteractionDispatcher {  
    
    public static Boolean testingException = false;
    private static Set<Id> processedCases = new Set<Id>();
    private static Map<Id, Case> interactionMap = new Map<Id, Case>();
    public static void handleTrigger(TriggerOperation operationType, List<Case> newList, list<Case> oldList, householdUpdater householdUpdates){
        updateHouseholdFirstLasts(newList, householdUpdates);
    }
    
    public static void updateHouseholdFirstLasts (List<Case> listIn, householdUpdater householdUpdates){ 
        Map<Id, RecordType> interactionRecordTypes =RecordTypes.getRecordTypes('Case');
        InteractionRecordTypeFilter.sortAllInteractionsByRecordType(interactionRecordTypes, listIn);
                system.debug('***************************in upateHH first 2 methods called');
        for (Case cas: listIn){
            interactionMap.put(cas.Family__Household__c, cas);
                   system.debug('************************in loop for : ' + cas.Family__Household__c);
            processedCases.add(cas.Id);
        }
                system.debug('************************ran loop');
        List <npo02__Household__c> households = InteractionSelector.getHouseholdInteractions(interactionMap);
        processHouseholdFRSInteractions(households, householdUpdates);
       // processHouseholdSWInteractions(households, householdUpdates);
       // processHouseholdIntakeSurveys(households, householdUpdates);
       // processProfessionalInteractions(households, householdUpdates);
        
    }
    
    public static void processHouseholdFRSInteractions(List <npo02__Household__c> households, householdUpdater householdUpdates){
        Map<Id, Case> frsCaseMap = InteractionRecordTypeFilter.getFamiliyInteractionsMap();
        if(frsCaseMap.size()>0){
            system.debug('************************ frsCaseMap size : ' + frsCaseMap.size());
            
            for(npo02__Household__c h : households) {
                if(frsCaseMap.containsKey(h.ID)) {
                    npo02__Household__c toUpdate = householdUpdates.getHousehold(h.id);
                    if (h.Most_Recent_Household_Interaction__c ==  NULL 
                        || h.Most_Recent_Household_Interaction__c < frsCaseMap.get(h.ID).Start_Time__c.date()){
                            toUpdate.Most_Recent_Household_Interaction__c = frsCaseMap.get(h.ID).Start_Time__c.date();
                            toUpdate.Most_Recent_HH_Interaction_Call_Type__c = frsCaseMap.get(h.ID).Call_Type__c;
                            System.Debug('*************** most recent hh interaction: ' + h.Most_Recent_Household_Interaction__c ); 
                        } 
                    if(h.First_Interaction__c == NULL || h.First_Interaction__c > frsCaseMap.get(h.ID).Start_Time__c.date()){
                        toUpdate.First_Interaction__c = frsCaseMap.get(h.ID).Start_Time__c.date();
                    }
                    if(h.Last_Intake__c ==  NULL || h.Last_Intake__c < interactionMap.get(h.ID).Start_Time__c.date()){
                toUpdate.Last_Intake__c = frsCaseMap.get(h.ID).Start_Time__c.date();
            } 
            if(h.First_Intake__c == NULL || h.First_Intake__c > interactionMap.get(h.ID).Start_Time__c.date()){
                    toUpdate.First_Intake__c = frsCaseMap.get(h.ID).Start_Time__c.date();
            }
                }
            }
        }
    }
    
     public static void processHouseholdSWInteractions(List <npo02__Household__c> households, householdUpdater householdUpdates){
        Map<Id, Case> SWCaseMap = InteractionRecordTypeFilter.getSWFamilyAssessmentsMap();
        if(SWCaseMap.size()>0){
        for(npo02__Household__c h : households){
            npo02__Household__c toUpdate = householdUpdates.getHousehold(h.id);
            if (h.Most_Recent_SW_HH_Interaction__c ==  NULL 
                    || h.Most_Recent_SW_HH_Interaction__c < swCaseMap.get(h.ID).Start_Time__c.date()){
                        toUpdate.Most_Recent_SW_HH_Interaction__c = swCaseMap.get(h.ID).Start_Time__c.date();
                    } 
            if(h.First_SW_HH_Interaction__c == NULL || h.First_SW_HH_Interaction__c > swCaseMap.get(h.ID).Start_Time__c.date()){
                    toUpdate.First_SW_HH_Interaction__c = swCaseMap.get(h.ID).Start_Time__c.date();
                }
            }
                
         }
   }
   public static void processHouseholdIntakeSurveys(List <npo02__Household__c> households, householdUpdater householdUpdates){
        Map<Id, Case> intakeSurveyCaseMap = InteractionRecordTypeFilter.getIntakeSurveysMap();
        if(intakeSurveyCaseMap.size()>0){
        for(npo02__Household__c h : households){
            npo02__Household__c toUpdate = householdUpdates.getHousehold(h.id);
            if (h.Most_Recent_Intake_Survey__c ==  NULL 
                    || h.Most_Recent_Intake_Survey__c < interactionMap.get(h.ID).Start_Time__c.date()){
                        toUpdate.Most_Recent_Intake_Survey__c = interactionMap.get(h.ID).Start_Time__c.date();
                    } 
            if(h.First_Intake_Survey__c == NULL || h.First_Intake_Survey__c > interactionMap.get(h.ID).Start_Time__c.date()){
                    toUpdate.First_Intake_Survey__c = interactionMap.get(h.ID).Start_Time__c.date();
            }
        }
      }
    }

           /*  contact last int date
            * 
        System.debug('interactionMap =' + interactionMap);
        if(interactionMap.size()>0){
            List <Contact> conInteractions = InteractionSelector.getContactInteractions(interactionMap);
            Set<ID> keys = interactionMap.keySet();
            //for (ID k: keys) { 
            for(Contact c: conInteractions){
                Contact UpdateCon = new Contact();
                Boolean conUpdated = false;
                if(interactionMap.containsKey(c.ID) )
                    UpdateCon.ID = c.id; 
                if(c.Last_Interaction_Date__c ==  NULL || c.Last_Interaction_Date__c < interactionMap.get(c.ID).Start_Time__c.date()){
                    System.debug('interactionMap.get(k)= ' + interactionMap.get(c.ID).Start_Time__c.date());
                    System.Debug('Contact ID & Date = ' + c +  '  ' + UpdateCon.Last_Interaction_Date__c);
                    UpdateCon.Last_Interaction_Date__c = interactionMap.get(c.ID).Start_Time__c.date();
                    conUpdated = True;
                }
                if(c.First_Interaction__c == NULL || c.First_Interaction__c > interactionMap.get(c.ID).Start_Time__c.date()){
                    UpdateCon.First_Interaction__c = interactionMap.get(c.ID).Start_Time__c.date();
                    conUpdated = True;
                } 
                if(conUpdated == true) interactionList.add(UpdateCon);  
            }   
        }
        System.debug('Interaction Date List= ' + interactionList.size());        
        return interactionList;
    } 
    */
    
    public static void processProfessionalAndChildsRelationshipsList(List <npo02__Household__c> households, householdUpdater householdUpdates){
       List<Case> profChildRelationshipsList = InteractionRecordTypeFilter.getprofessionalAndChildsRelationshipsList();
        if(profChildRelationshipsList.size()>0){
            RelationshipsMethods.getEnterRelationshipTrack(profChildRelationshipsList);
        }
    }
    
    @AuraEnabled
    public static void processProfessionalInteractions(List <npo02__Household__c> households, householdUpdater householdUpdates){
  /*     // Map<Id, Case> profOBOCaseMap = InteractionRecordTypeFilter.getProfessionalInteractionsOboMap();
       List<Case> profChildRelationshipsList = InteractionRecordTypeFilter.getProfessionalAndChildsRelationshipsList();
        
            if(profChildRelationshipsList.size()>0){
              //  RelationshipsMethods.getEnterRelationshipTrack(findNeedConsents);
              Map <String, List<Case>>  returnedNeedConsentsMap = getMakeKeys(profChildRelationshipsList);
                
                if (returnedNeedConsentsMap.keySet().size() > 0){
                    System.debug(' if returnedNeedConsentsMap>0 Send  To Consent');
                    ConsentMethods.getEnterConsentTrack(returnedNeedConsentsMap); 
                }
            }
        }
        
    }
    /*
    public static Map<String, List <Case>> getMakeKeys(List <Case> profChildRelationshipsList){
     /*   System.debug('getMakeKeys'  +  profChildRelationshipsList.size() );
        Map <String, List<Case>> casesMapList = new Map <String, List<Case>>();
        Map<String, String> newKeysMap = new Map <String, String>();
        for(Case a: profChildRelationshipsList){
            
            /*** 
* For now just write it if there is an 001 Org listed. 
* These cases all have children listed as per above
* Make Key for Child & Professional's Org

            
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
    } */
    }
}