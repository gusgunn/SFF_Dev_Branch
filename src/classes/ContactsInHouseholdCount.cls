public class ContactsInHouseholdCount {
    
    public static void handleTrigger(TriggerOperation operationType, List<Contact> newList, list<Contact> oldList, HouseholdUpdater updater){
        Set<ID> householdIds = new Set<ID>();
        
        if( operationType == TriggerOperation.AFTER_UPDATE || 
           operationType == TriggerOperation.AFTER_INSERT){
               for(Contact c: newList){
                   if(c.npo02__Household__c!=null && c.npo02__Household__c.getSObjectType()==Schema.npo02__Household__c.SObjectType) 

                       householdIds.add(c.npo02__Household__c);
               }
           }
        if( operationType == TriggerOperation.AFTER_UPDATE ||  
           operationType == TriggerOperation.AFTER_DELETE) {
               for(Contact c: oldList){
                   if(c.npo02__Household__c!=null && c.npo02__Household__c.getSObjectType()==Schema.npo02__Household__c.SObjectType) 
                       householdIds.add(c.npo02__Household__c);
               }
               
           }
        
        List<npo02__Household__c> households = [Select ID, Number_In_Household__c from npo02__Household__c where ID in :householdIds];
        
        List<AggregateResult> contacts = [SELECT Count(ID) items, npo02__Household__c 
                                          FROM Contact 
                                          WHERE npo02__Household__c in :householdIds 
                                          Group BY npo02__Household__c];
        Map<ID, Integer> contactCounts = new Map<ID, Integer>();
        
        for(AggregateResult ar: contacts){
            contactCounts.put((Id)ar.get('npo02__Household__c'), (Integer)ar.get('items'));
        }
        
        for(npo02__Household__c h: households){
            if(h.Number_In_Household__c != contactCounts.get(h.Id)){
                npo02__Household__c toUpdate = updater.getHousehold(h.id);
                toUpdate.Number_In_Household__c = contactCounts.get(h.id);
            }
        }
        
    }
    
}