public without sharing class FamilyReferralTracks {
    
    
    /*****
     * 8/27/18 SFCD 
     * chnegd LM comparaison to date so that edited records wont repopulate
*  
*  GG
* Wait until after phoneline catchup: to limit find existing to last 90 days!
* Add new fields to object
*  
*****/
    
    public static boolean noRepeats = false;
    public static Integer Count =0;
    private static RecordType rTFamilyInteraction = [SELECT Id, Name FROM recordType WHERE Name = 'Family Case' AND sObjectType = 'Case' LIMIT 1];
    
    public static void sortCases(List<Case> newList){
        count +=1;
        List<Case>  findReferrals = new List <Case>();
        // Check if it is an  family int, and get hh if it is
        for (Case cas: newList){
            if(cas.RecordTypeId == rTFamilyInteraction.Id){
                findReferrals.add(cas);
                System.debug('1.  findReferrals= ' + findReferrals);
            }
            if(findReferrals.size()>0){
                Map <String, List<Case>>  returnedReferralsMap = getMakeKeys(findReferrals);
                List<ReferralTracking__c> upsertList = getEnterReferralTrack(returnedReferralsMap);// send to Referral Layer
                
                if(upsertList.size() >0){
                getSaveNewRecords(upsertList); 
                }
                
            }
            
        }
    }
    
    // Check if key exists - This processing only happens if it exists- UPDATE (use WORKEr)so 
    public static List <ReferralTracking__c> getEnterReferralTrack(Map <String, List <Case>> newListIn){   
        //Check that newList is a mapped list wth all keys in same list
        
        List <ReferralTracking__c>  UpsertReferralsList = new List <ReferralTracking__c>();
        
        //Do I want later try to add all to one record in map?..
        Map <String, List<ReferralTracking__c>> allNewReferralActions = new  Map <String, List<ReferralTracking__c>>();
        Map <String, ReferralTracking__c> existingKeys = new Map <String, ReferralTracking__c>();
        List<ReferralTracking__c> findExisitng = [SELECT Id, Household_Referred__c, Referral_Received_From__c, Child_Referred__c,  Assigned_To__c,
                                                  CbxReferral_Confirmed__c, CbxContact_Confirmation_Sent__c,cbxLeft_Message_1__c, cbxLeft_Message_2__c,
                                                  W1_IntID__c, M1_IntID__c, UTC_IntID__c,
                                                  CbxReferral_Update__c, cbxIntake__c,cbxOne_Month_Followup__c, cbxOne_Week_Followup__c,  cbxSent_UTC__c,  //Referral_Case,
                                                  UTC_Professional_Notify__c, InteractionReference__c, Initial_Interaction_Date__c, Date_On_Referral_Form__c,
                                                  Date_Referral_Received__c,  Date_Contact_Confirmation_Sent__c, Date_UTC_to_Prof__c,Referral_Organization__c,
                                                  x1Interaction_Link__c, x2Interaction_Link__c, x3Interaction_Link__c, x4Interaction_Link__c,
                                                  x5Interaction_Link__c, x6Interaction_Link__c, date_Update_Sent__c, LM1_IntID__c, LM2_IntID__c,
                                                  date_Sent_UTC__c, date_Left_Message_1__c, date_Left_Message_2__c
                                                  FROM ReferralTracking__c
                                                  WHERE Household_Referred__c IN :newListIn.keyset()
                                                  AND Household_Referred__c != NULL
                                                  //AND Date_Referral_Received__c >= LAST_N_Days:365
                                                 ];
        
        
        //Household is key
        Date todaysDate = system.today();
        Boolean newRecord;
        
        for(ReferralTracking__c ex: findExisitng){
            //CasSFID?
            String key = ex.Household_Referred__c;
            System.debug('Household_Referred__c' + Key);
            
            //list of cases per HH
            for (Case c: newListIN.get(key)){
                System.debug('Found Match- existing Family in Referral Track Record' );
                System.debug('count=  ' + count);
                System.debug('Child Is' + c.Family__Child__c);
                System.debug('***Call_Type Is '  + c.Call_Type__c);
                System.debug('Date_Referral_Received__c  & Start_Time__c =  ' + ex.Date_Referral_Received__c  + c.Start_Time__c);
              /*  pull intake in from household
               * if( ex.cbxIntake__c == false && c.Call_Type__c == 'Intake'){
                    ex.cbxIntake__c  = true;
                    ex.intakeId__c = c.Id;
                    ex.date_Intake__c = date.ValueOf(c.Start_Time__c.date());
                    ex.intake_Owner__c = c.OwnerID; 
				
                    
                } */
                if(ex.cbxOne_Week_Followup__c == false && c.Call_Type__c =='FRS 1 wk' ){
                    ex.cbxOne_Week_Followup__c= true;
                    ex.date_One_Week_Followup__c= date.ValueOf(c.Start_Time__c.date()); 
                    ex.W1_IntID__c = c.Id;
                    ex.one_week_Origin__c = c.Origin;
                    ex.one_Week_Owner__c = c.OwnerID;
                    ex.one_week_Caregiver__c = c.ContactID;
                    ex.one_week_Child__c = c.Family__Child__c;
                    
                }else if(ex.cbxOne_Month_Followup__c == false  && c.Call_Type__c =='FRS 1 mo'){
                    ex.cbxOne_Month_Followup__c= true;
                    ex.date_One_Month_Followup__c  = date.ValueOf(c.Start_Time__c.date()); 
                    ex.M1_IntID__c = c.Id;
                    ex.one_Month_Origin__c = c.Origin;
                    ex.one_Month_Owner__c = c.OwnerId;
                    ex.one_Month_Caregiver__c =  c.ContactID;
                    ex.one_Month_Child__c = c.Family__Child__c;
                    
                }else if(ex.LM1_IntID__c == null  
                         && (c.Call_Type__c =='Left Message 1' || c.Call_Type__c =='Left Message 2' 
                             || c.Call_Type__c =='# disconnected' || c.Call_Type__c =='No answering machine')){ 
                    ex.cbxLeft_Message_1__c = true;
                    ex.date_Left_Message_1__c = date.ValueOf(c.Start_Time__c.date()); 
                    ex.LM1_IntID__c = c.Id;
                    ex.Left_Message_1_Owner__c = c.OwnerID; 
                    System.debug('lm1');
                 
                }else if(ex.date_Left_Message_2__c == null && ex.LM2_IntID__c == null &&  ex.date_Left_Message_1__c != null 
                         && ex.date_Left_Message_1__c < date.ValueOf(c.Start_Time__c.date())
                               && (c.Call_Type__c =='Left Message 1' || c.Call_Type__c =='Left Message 2' 
                             || c.Call_Type__c =='# disconnected' || c.Call_Type__c =='No answering machine')){
                    ex.cbxLeft_Message_2__c = true;
                    ex.date_Left_Message_2__c = date.ValueOf(c.Start_Time__c.date()); 
                    ex.LM2_IntID__c =c.Id;
                    ex.Left_Message_2_Owner__c = c.OwnerId; 
                    
                }else if(ex.cbxSent_UTC__c == false && c.Call_Type__c == 'Sent UTC Letter'){
                    ex.cbxSent_UTC__c = true;
                    ex.date_Sent_UTC__c = date.ValueOf(c.Start_Time__c.date());
                    ex.UTC_IntID__c = c.Id;
                    ex.UTC_Owner__c = c.OwnerId; 
                    
                }else if (c.Id != ex.x1Interaction_Link__c && c.Id != ex.x2Interaction_Link__c && c.Id != ex.x3Interaction_Link__c &&
                          c.Id != ex.x4Interaction_Link__c && c.Id != ex.x5Interaction_Link__c && c.Id != ex.x6Interaction_Link__c && 
                          c.Id != ex.UTC_IntID__c && c.Id != ex.LM2_IntID__c && c.Id != ex.LM1_IntID__c && c.Id != ex.M1_IntID__c && 
                          c.Id != ex.W1_IntID__c ) {
                              
                              if(ex.x1Interaction_Link__c == null) {
                                  ex.x1lastInteractionCallType__c = c.Call_Type__c;
                                  ex.x1lastInteractionDate__c = date.ValueOf(c.Start_Time__c.Date());
                                  System.debug('c.Id= ' + c.Id);
                                  ex.x1Interaction_Link__c =c.Id;
                                  ex.x1lastInteractionOrigin__c = c.Origin; 
                                  
                              }else if (ex.x2Interaction_Link__c == null) {
                                  ex.x2lastInteractionCallType__c = c.Call_Type__c;
                                  ex.x2lastInteractionDate__c = date.ValueOf(c.Start_Time__c.Date());
                                  ex.x2Interaction_Link__c =c.Id; 
                                  ex.x2lastInteractionOrigin__c = c.Origin;
                                  
                              }else if (ex.x3Interaction_Link__c == null) {
                                  ex.x3lastInteractionCallType__c = c.Call_Type__c;
                                  ex.x3lastInteractionDate__c = date.ValueOf(c.Start_Time__c.Date());
                                  ex.x3Interaction_Link__c = c.Id; 
                                  ex.x3lastInteractionOrigin__c = c.Origin;    
                                  
                              }else if (ex.x4Interaction_Link__c == null) {
                                  ex.x4lastInteractionCallType__c = c.Call_Type__c;
                                  ex.x4lastInteractionDate__c = date.ValueOf(c.Start_Time__c.Date());
                                  ex.x4Interaction_Link__c = c.Id; 
                                  ex.x4lastInteractionOrigin__c = c.Origin; 
                                  
                              }else if (ex.x5Interaction_Link__c == null) {
                                  ex.x5lastInteractionCallType__c = c.Call_Type__c;
                                  ex.x5lastInteractionDate__c = date.ValueOf(c.Start_Time__c.Date());
                                  ex.x5Interaction_Link__c = c.Id;
                                  ex.x5lastInteractionOrigin__c = c.Origin; 
                                  
                              }else if (ex.x6Interaction_Link__c == null) {
                                  ex.x6lastInteractionCallType__c = c.Call_Type__c;
                                  ex.x6lastInteractionDate__c = date.ValueOf(c.Start_Time__c.Date());
                                  ex.x6Interaction_Link__c = c.Id; 
                                  ex.x6lastInteractionOrigin__c = c.Origin;
                              }
                          }
                
                UpsertReferralsList.add(ex);
                
            } 
        }
        return UpsertReferralsList;
    } 
    
    
    // Make Map/List of actions with keys
    public static Map<String, List <Case>> getMakeKeys(List <Case> newListIn){
        
        System.debug('2. getMakeKeys(List <Case> newListIn)= '  +  newListIn.size() );
        Map <String, Case> ActionKeyMap = new Map <String, Case>();
        Map <String, List<Case>> CaseMapList = new Map <String, List<Case>>();
        
        Map<String, String> newKeysSet = new Map <String, String>();
        for(Case a: newListIn){
            //Match on househole
            String Key = string.ValueOf(a.Family__Household__c);
            newKeysSet.put(key, key);
            System.debug('a.Family__Household__c' + a.Family__Household__c);
            
            //If the key has already been added to the Map
            if (CaseMapList.containsKey(a.Family__Household__c)){
                System.debug('found dupe key');
                
                CaseMapList.get(a.Family__Household__c).add(a);
                
                
                System.debug('get(key).add(a);' + a.Family__Household__c + CaseMapList.size());
                System.debug('.   keyset= ' + CaseMapList.keyset());
                System.debug('.  CaseMapList sfter dupe found values= ' + CaseMapList.values().size());
                
            } else {
                
                // make new entry in Map for userID with that first account as item [0]
                //Making 2 here (in different ways) to test next step map of list 
                //CaseMapList.put(a.Family__Household__c, new List<Case>{a});
                CaseMapList.put(key, new List<Case>{a});
                /* System.debug('.  CaseMapList single  values= ' + CaseMapList.values().size());
System.debug('.  CaseMapList after new entry= ' + CaseMapList.size());*/
                
            }
        }
        return CaseMapList;
    }
    
    
    
    
    public static Map<Integer, List<sObject>> getSaveNewRecords(List<ReferralTracking__c> upsertList){
        Map<Integer, List<sObject>> indexToObjects = new Map<Integer, List<SObject>>();
        Integer isIndex =0;
        if (upsertList.size() >0){
            
                indexToObjects.put(isIndex, upsertList); 
                isIndex = isIndex + 1;
            
        
        Integer startingIndex = 0;
        
        System.enqueueJob(new Worker(indexToObjects, startingIndex));
        }
        Return indexToObjects;
            

    }
}