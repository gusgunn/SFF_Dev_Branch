public class HouseholdUpdater {
    
    Map<ID, npo02__Household__c> householdsToUpdate = new Map<Id, npo02__Household__c>();

    public npo02__Household__c getHousehold(Id householdId){
        System.debug('get household householdId'  + householdId);
        npo02__Household__c targethousehold = householdsToUpdate.get(householdId);
        if(targethousehold == null){
            targethousehold = new npo02__Household__c(Id = householdId);
            householdsToUpdate.put(householdID, targethousehold);
        }
        return targethousehold;
    }

    public void updatehouseholds(){
        if(householdsToUpdate.size()>0) update householdsToUpdate.values();
    }

}