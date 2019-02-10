public class ActionMethods {
    
    
/*****
*  4_23_18 SFCD F4
*  GG
*  Fixed tracking History
*  Adding new date fields 
*  for TY and Asigned To   
*  Referral_Follow_up_Date__c = Referral TY Sent
*  Completed_Date__c = Assigned To
*****/
    
    public static boolean noRepeats = false;
    public static Integer Count =0;
    
    public static void sortActions(List<Action__c> newList){
        count +=1;
        List<Action__c>  findReferrals = new List <Action__c>();
        // Check if it is an InternalReferral & referral tracking action
        for (Action__c a: newList){
            If (a.Action_Detail_Type_Internal_Referral__c != NULL &&  
                a.Action_Detail_Type_Internal_Referral__c.contains('Referral'))
                findReferrals.add(a);
            System.debug('1.  findReferrals= ' + findReferrals);
        }
        if(findReferrals.size()!=Null){
            Map <String, List<Action__c>>  returnedReferralsMap = getMakeKeys(findReferrals);
            List<ReferralTracking__c> upsertList = getEnterReferralTrack(returnedReferralsMap);// send to Referral Layer
            getSaveNewRecords(upsertList); 
            
        }
    }
    
    
    // Check if key exists
    // Input actions, return map of ReferralTracking__c
    // Make keys for list or Referrals
    
    
    
    //New referral  record
    public static List <ReferralTracking__c> getEnterReferralTrack(Map <String, List <Action__c>> newListIn){   
        //Check that newList is a mapped list wth all keys in same list
        
        List <ReferralTracking__c>  UpsertReferralsList = new List <ReferralTracking__c>();
        
        //Do I want later try to add all to one record in map?..
        Map <String, List<ReferralTracking__c>> allNewReferralActions = new  Map <String, List<ReferralTracking__c>>();
        Map <String, ReferralTracking__c> existingKeys = new Map <String, ReferralTracking__c>();
        List<ReferralTracking__c> findExisitng = [SELECT Id, Key__c, Referral_Received_From__c, Child_Referred__c,  Assigned_To__c, Household_Referred__c,
                                                  Referral_Action__c, CbxReferral_Confirmed__c, CbxContact_Confirmation_Sent__c, CbxReferral_Update__c, 
                                                  UTC_Professional_Notify__c, InteractionReference__c, Initial_Interaction_Date__c, 
                                                  Date_Referral_Assigned__c, Date_On_Referral_Form__c,
                                                  Date_Referral_Received__c,  Date_Contact_Confirmation_Sent__c, Date_UTC_to_Prof__c,Referral_Organization__c
                                                  FROM ReferralTracking__c
                                                  WHERE Key__c IN :newListIn.keyset()
                                                 ]; //AND Date_Referral_Received__c > LAST_N_Days:90
        
        //Right now actually using findExisitng in loop below, not Map
        for(ReferralTracking__c rT: findExisitng){
            existingKeys.put(rT.Key__c, rT);
        }

        // Referral_Follow_up_Date__c = Referral TY Sent
        //Completed_Date__c = Assigned To
        Date todaysDate = system.today();
        Boolean newRecord;
        for (String key: newListIN.Keyset()){
            newRecord = True;
            
            ReferralTracking__c r = new ReferralTracking__c();
            r.key__c = key;
            
            
            
            for(ReferralTracking__c ex: findExisitng){
                System.debug('ex.Key__c' + ex.Key__c);
                System.debug('Key__c' + Key);
                
                if( key == ex.Key__c) {
                    newRecord = False;
                    r.ID = ex.id;  
                    r.Referral_Organization__c = ex.Referral_Organization__c;
                    r.Date_Referral_Assigned__c =ex.Date_Referral_Assigned__c;
                    r.InteractionReference__c = ex.InteractionReference__c ;
                    r.Household_Referred__c = ex.Household_Referred__c;
                   
                    System.debug('newRecord in false path' + newRecord);
                }
            } 
            
            //list of actions per child
            for (action__c a: newListIN.get(key)){
                System.debug('count=  ' + count);
                System.debug('newRecord' + newRecord);
                System.debug('Child Is' + a.Child_Name__c);
               
                if(a.Child_Name__c != NULL ){
                    r.Child_Referred__c = a.Child_Name__c;   
                }
                 if(a.Caller_Name__c != NULL ){
                    r.Referral_Received_From__c = a.Caller_Name__c;   
                }
                 
                System.debug('assigned to=' + a.Assigned_To__c);
                if(a.Assigned_To__c != NULL ){
                    r.Assigned_To__c = a.Assigned_To__c;   
                    
                }
				 if(a.Completed_Date__c != NULL  && r.Date_Referral_Assigned__c==NULL){
                    r.Date_Referral_Assigned__c =a.Completed_Date__c;
                }    
                
                if( r.Referral_Organization__c == NULL && a.Caller_Agency__c!=NULL && a.Caller_Agency__c.startsWith('001') ){
                    r.Referral_Organization__c = a.Caller_Agency__c;
                    
                }
                if(r.InteractionReference__c == NULL){
                    r.InteractionReference__c= a.InitialInteraction__c;
                    
                }
                
                if(r.Initial_Interaction_Date__c == NULL){
                    r.Initial_Interaction_Date__c= a.InteractionDate__c;
                }
                
                if (r.Household_Referred__c == NULL ){
                    r.Household_Referred__c = a.ChildHousehold__c;
                }
                if (a.Date_On_Referral_Form__c != NULL ){
                    r.Date_On_Referral_Form__c = a.Date_On_Referral_Form__c;
                }
               
                
                if(a.Action_Detail_Type_Internal_Referral__c.contains( 'Received Referral to SFCD')){
                    r.Referral_Action__c = a.Action_Detail_Type_Internal_Referral__c;
                    
                    r.Date_Referral_Received__c = a.Referral_Date__c;
                    r.cbx_Referral_Received__c =true;
                    r.ActionReference__c = a.ID; //orID?
                    System.debug('1 ActionReference= ' + r.ActionReference__c );
                }
                if(a.Action_Detail_Type_Internal_Referral__c.contains('Referral Thank You') && a.Referral_Follow_up_Date__c !=NULL){
                    r.cbxReferral_Confirmed__c =true;
                    r.date_TYSent__c  = a.Referral_Follow_up_Date__c;
                    r.ActionTYReference__c = a.ID;
                }
                //made contact
                if(a.Action_Detail_Type_Internal_Referral__c.contains ('Referral Contact Confirmation')){
                    r.cbxContact_Confirmation_Sent__c = True;
                    r.date_Contact_Conf_Sent__c = a.Referral_Date__c;
                    r.ActionContConfReference__c = a.ID;
                }
                
                if(a.Action_Detail_Type_Internal_Referral__c.contains ('Referral Update')){
                    r.cbxReferral_Update__c =true;
                    r.date_Update_Sent__c  = a.Referral_Date__c;
                    r.ActionUpdateReference__c = a.ID;
                }
                
                if(a.Action_Detail_Type_Internal_Referral__c.contains('Referral Contact UTC')){
                    r.UTC_Professional_Notify__c =true;
                    r.date_UTC_to_Prof__c  = a.Referral_Date__c;
                    r.ActionUTCReference__c = a.ID;
                }
            }
            
          
                UpsertReferralsList.add(r); 

           
        }
        //Join all related into one record and add household
        
        return UpsertReferralsList;
    }
    
    // Make Map/List of actions with keys
    public static Map<String, List <Action__c>> getMakeKeys(List <Action__c> newListIn){
        
        System.debug('2. getMakeKeys(List <Action__c> newListIn)= '  +  newListIn.size() );
        Map <String, Action__c> ActionKeyMap = new Map <String, Action__c>();
        Map <String, List<Action__c>> ActionsMapList = new Map <String, List<Action__c>>();
        
        Map<String, String> newKeysSet = new Map <String, String>();
        for(Action__c a: newListIn){
            String Key = string.ValueOf(a.Caller_Name__c) + string.ValueOf( a.Child_Name__c);
            newKeysSet.put(key, key);
            System.debug('a.ReferralKey__c' + a.ReferralKey__c);
            
            //If the key has already been added to the Map
            if (ActionsMapList.containsKey(a.ReferralKey__c)){
                System.debug('found dupe key');
                /****Test bulk **/       
                ActionsMapList.get(a.ReferralKey__c).add(a);
                

            } else {
               
                ActionsMapList.put(key, new List<Action__c>{a});
               
            }
            
            
        }
        
        return ActionsMapList;
    }
    
    public static void getSaveNewRecords(List<ReferralTracking__c> upsertList){
        if (upsertList.size() !=Null){
            
            
            try{
                
                upsert upsertList;
                System.debug('ActionMethods.getSaveNewRecords upsert done');
                
            } Catch (Exception e) {
                System.debug('ActionMethods.getSaveNewRecords Referral Tracking upsert error' + e );
                SendErrorMessage.getErrors(e);
                
                
                
            } 
        }
    }
}