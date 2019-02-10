public without sharing class RelationshipsMethods {
    
    //Key = npe4__RelatedContact__c + npe4__Contact__c
    //ChildKey__c,  npe4__Status__c,  Organization__c , npe4__Type__c, Date__c, npe4__RelatedContact__c, npe4__Contact__c
    
    /***
*   @gusgunn
*   Created in caseTrack on 10/18/17 Novo
* 	
***/
    Private static RecordType rTFamilyInteraction = [SELECT Id, Name FROM recordType WHERE Name = 'Family Case' AND sObjectType = 'Case' LIMIT 1];
    Private static RecordType rTProfInteraction = [SELECT Id, Name FROM recordType WHERE Name = 'Professional Case' AND sObjectType = 'Case' LIMIT 1];
    public static Boolean testingException = false;
    
    public Static Boolean RRunOnce = True;
    
    @AuraEnabled
    public static void getEnterRelationshipTrack(List <Case> newListIn){   
        //Check that newList is a mapped list wth all keys in same list
        System.debug(' If RelationshipsnewListIn >0 Send  To Relationships getMakeKeys' + newListIn);
        Map <String, List<Case>>  returnedKeys = getMakeKeys(newListIn);
          System.debug(' if returnedRelationshipsMap>0 Send  To Relationships getMakeKeys' + returnedKeys);
        if (returnedKeys.size() > 0){
            
            System.debug(' if returnedRelationshipsKeys>0 Send  To getRelTrack');
            
            List <npe4__Relationship__c> upsertList = getRelTrack(returnedKeys);
            getSaveNewRecords(upsertList); 
        }
    }
    

    
    public static Map<String, List <Case>> getMakeKeys(List <Case> newListIn){
        
        System.debug('getMakeKeys'  +  newListIn.size() );
        
        Map <String, List<Case>> casesMapList = new Map <String, List<Case>>();
        
        Map<String, String> newKeysMap = new Map <String, String>();
        
        for(Case a: newListIn){
            
            /*** 
* For now just write it if there is an 001 Org listed. 
* These cases all have children listed as per above
* Make Key for Child & Professional's Org
* **/
            
            String Key = string.ValueOf(a.ContactID) + string.ValueOf( a.Family__Child__c);
            newKeysMap.put(key, key);
            
            // If the key has already been added to the Map
            if (casesMapList.containsKey(key)){
                System.debug('found dupe Relationship key');
                
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
    
    
    public static List <npe4__Relationship__c> getRelTrack(Map <String, List <Case>> newListIn){
        //Map <String, List<npe4__Relationship__c>> allNewConsentCases = new  Map <String, List<npe4__Relationship__c>>();
        List <npe4__Relationship__c>  RelationshipsToUpsertList = new List <npe4__Relationship__c>();
        
        //FInd all existing Records
        
        Map <String, npe4__Relationship__c> existingKeys = new Map <String, npe4__Relationship__c>();
        List<npe4__Relationship__c> findExisitng = [SELECT Id, Name, Key__c,  npe4__Status__c,  
                                                    Organization__c , npe4__Type__c, Date__c, npe4__RelatedContact__c, 
                                                    npe4__Contact__c
                                                    FROM npe4__Relationship__c
                                                    WHERE Key__c IN :newListIn.keyset()
                                                    
                                                   ];
        
        //Right now actually using findExisitng in loop below, not Map
        for(npe4__Relationship__c rT: findExisitng){
            existingKeys.put(rT.Key__c, rT);
            System.debug('FoundExisting Relationship? = ' + existingKeys);
        }
        
        Date todaysDate = system.today();
        Boolean newRecord;
        for (String key: newListIN.Keyset()){
            newRecord = True;
            
            npe4__Relationship__c r = new npe4__Relationship__c();
            
            
            
            for(npe4__Relationship__c ex: findExisitng){
                System.debug('Relationship  ex.Key__c' + ex.Key__c);
                System.debug('Relationship Key__c' + Key);
                
                if( key == ex.Key__c) {
                    newRecord = false;
                    r.id = ex.id; 
                    r.Date__c = ex.Date__c;
                    r.Organization__c = ex.Organization__c;
                    
                    
                    System.debug('Load Relationship Ex values into r' + r + '  ex.npe4__Contact__c=  ' + ex.npe4__Contact__c);
                    
                    System.debug('Relationship R.id & ex.id = ' + r.id );
                    System.debug('newRecord in path = ' + newRecord);
                }
            }
            Integer counter = 0;
            for (Case c: newListIN.get(key)){
             counter = counter + 1;
                System.debug('RelationshipsCounter= ' + counter);
                r.npe4__RelatedContact__c = c.ContactID;
                r.npe4__Status__c ='Current';
                
                 System.debug('npe4__Contact__c= ' + r.npe4__Contact__c);
                if(newrecord == true && Counter == 1 ){
                 r.npe4__Contact__c = c.Family__Child__c;
                }
                
                if(r.Date__c== NULL ||  r.Date__c < date.ValueOf(c.Start_Time__c.date())){
                    r.Date__c = date.ValueOf(c.Start_Time__c.date());
                    //r.First_Interaction__c = c.Id;
                    
                }
                // Get Current Org
                if(r.Organization__c == NULL && c.AccountID != NULL){
                    r.Organization__c= c.AccountID;
                    
                }
                //Get current relationship
                if(c.Relationship__c !=Null ){
                    r.npe4__Type__c = c.Relationship__c;
                    
                }
                
            }
            
            System.debug('newrecord true? = ' + newrecord);
            RelationshipsToUpsertList.add(r);   
        }
        //Join all related into one record and add household
        return RelationshipsToUpsertList;
    }
    
    
    
    public static Map<Integer, List<sObject>> getSaveNewRecords(List<npe4__Relationship__c> upsertList){
        Map<Integer, List<sObject>> indexToObjects = new Map<Integer, List<SObject>>();
        Integer isIndex =0;
        if (upsertList.size() !=Null &&  RRunOnce == true){
            
            indexToObjects.put(isIndex, upsertList); 
            isIndex = isIndex + 1;
            
            
            Integer startingIndex = 0;
           
            System.enqueueJob(new WorkerUpsert(indexToObjects, startingIndex));
             RRunOnce = false;
        }
        Return indexToObjects;
        
        
    }
   
 }