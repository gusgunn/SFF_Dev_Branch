public class ConsentMethods {
    
    /***
     *   @gusgunn
     *   Updated in caseTrack on 10/12/18 SFCD
     * 	 Added AutoCreated checkbox to allow manula creation of consent record
     *   AutoCreated = false if manually created and process runs to check all dates- First and Most Recent
     ***/
   
    public static Boolean testingException = false;
    public Static Boolean CRunOnce = True;

    @AuraEnabled
    public static void getEnterConsentTrack(Map <String, List <Case>> newListIn){   
        //Check that newList is a mapped list wth all keys in same list
        
        List <Consent__c> upsertList = getConsentsTrack(newListIn);
        getSaveNewRecords(upsertList); 
    }
    
    public static List <Consent__c> getConsentsTrack(Map <String, List <Case>> newListIn){
        Map <String, List<Consent__c>> allNewConsentCases = new  Map <String, List<Consent__c>>();
        List <Consent__c>  consentsToUpsertList = new List <Consent__c>();
        
        //FInd all existing consentRecords
        
        Map <String, Consent__c> existingKeys = new Map <String, Consent__c>();
        List<Consent__c> findExisitng = [SELECT Id, Name, AutoCreated__c, Key__c, First_Interaction_Date__c, Most_Recent_Interaction_Date__c,
                                         First_Interaction__c, Most_Recent_Interaction__c, First_Verbal_Consent_date__c,
                                         First_Written_Consent_Date__c, Verbal_Consent_Date__c, Written_Consent_Date__c,
                                         Professional_Contact__c, Child__c,  Organization__c, Household__c
                                         FROM Consent__c
                                         WHERE Key__c IN :newListIn.keyset()
                                         
                                         ];
        
        //Right now actually using findExisitng in loop below, not Map
        for(Consent__c rT: findExisitng){
            existingKeys.put(rT.Key__c, rT);
        }
        
        Date todaysDate = system.today();
        Boolean newRecord;
        for (String key: newListIN.Keyset()){
            newRecord = True;
            
            Consent__c r = new Consent__c();
          
             
            
            for(Consent__c ex: findExisitng){
                System.debug('ex.Key__c' + ex.Key__c);
                System.debug('Key__c' + Key);
                
                if( key == ex.Key__c) {
                //if( key == ex.Name) {
                    newRecord = False;
                    r.id = ex.id;  
                    r.Most_Recent_Interaction_Date__c = ex.Most_Recent_Interaction_Date__c;
                    r.First_Interaction_Date__c =ex.First_Interaction_Date__c;
                    r.Most_Recent_Interaction__c = ex.Most_Recent_Interaction__c;
                    r.First_Interaction__c = ex.First_Interaction__c;
                    r.First_Written_Consent_Date__c = ex.First_Written_Consent_Date__c;
                    r.Written_Consent_Date__c = ex.Written_Consent_Date__c;
                    r.First_Verbal_Consent_date__c = ex.First_Verbal_Consent_date__c;
                    r.Verbal_Consent_Date__c = ex.Verbal_Consent_Date__c;
                    
                    System.debug('R.id & ex.id = ' + r.id + ' ' + ex.id);
                    System.debug('newRecord in false path' + newRecord);
                }
            }
            
            for (Case c: newListIN.get(key)){
                r.child__c = c.Family__Child__c;
                r.Professional_Contact__c = c.ContactID;
                r.Household__c = c.Family__Household__c;
                
                
                if(r.First_Interaction_Date__c == NULL ||  r.First_Interaction_Date__c > date.ValueOf(c.Start_Time__c.date())){
                    r.First_Interaction_Date__c = date.ValueOf(c.Start_Time__c.date());
                    r.First_Interaction__c = c.Id;
          
                }
                 if(r.Most_Recent_Interaction_Date__c == NULL ||  r.Most_Recent_Interaction_Date__c < c.Start_Time__c){
                    r.Most_Recent_Interaction_Date__c = c.Start_Time__c;
                    r.Most_Recent_Interaction__c = c.Id;
          
                }
                
                
                
                if(r.Organization__c == NULL && c.AccountID != NULL){
                    r.Organization__c= c.AccountID;
                    
                }
                
                if(c.Written_Consent_Date__c !=Null && (c.Written_Consent_Date__c  >  r.Written_Consent_Date__c || r.Written_Consent_Date__c == NULL )){
                    r.Written_Consent_Date__c = c.Written_Consent_Date__c;
                    
                }
                
                if(c.Written_Consent_Date__c !=Null && (c.Written_Consent_Date__c  <  r.First_Written_Consent_Date__c || r.First_Written_Consent_Date__c == NULL )){
                    r.First_Written_Consent_Date__c = c.Written_Consent_Date__c;
                    
                }
                
                if(c.Verbal_Consent_Date__c !=NULL && (c.Verbal_Consent_Date__c > r.Verbal_Consent_date__c || r.Verbal_Consent_date__c == NULL)){
                    r.Verbal_Consent_Date__c= c.Verbal_Consent_Date__c;
                    
                }
                if(c.Verbal_Consent_Date__c !=NULL && (c.Verbal_Consent_Date__c < r.First_Verbal_Consent_date__c || r.First_Verbal_Consent_date__c == NULL)){
                    r.First_Verbal_Consent_date__c = c.Verbal_Consent_Date__c ;
                    
                }
                r.AutoCreated__c = true;
            }

            System.debug('newrecord true/false? = ' + newrecord);
            consentsToUpsertList.add(r);   
        }
        //Join all related into one record and add household
        return consentsToUpsertList;
    }
    
      
    @AuraEnabled
    public static void getSaveNewRecords(List<Consent__c> upsertList){
        if (upsertList.size() !=Null){
            
            // Attempt update of users and handle
            // any errors should they occur
            try {
                 if (!testingException){
                	upsert upsertList;
                    CRunOnce = false;
                     Return;
                   
                     
                 }else {
                System.debug('Throwing Intake exception');
                throw new DmlException();   
                 }
            } catch(Exception e) {
                SendErrorMessage.getErrors(e);

            }
        }
    }
}