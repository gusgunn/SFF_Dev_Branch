public class HouseholdUpdater {
    
    Map<Id, npo02__Household__c> householdsToUpdate = new Map<Id, npo02__Household__c>();
    
    public npo02__Household__c getHousehold(Id householdId){
         system.debug('**********************in hh updater for  : ' + householdId);
        npo02__Household__c targetHousehold = householdsToUpdate.get(householdId);
        if(targetHousehold == null){
             system.debug('**********************new targetHousehold  : ' + householdId);
            targetHousehold = new npo02__Household__c(Id = householdId);
            householdsToUpdate.put(householdID, targetHousehold);
        }
        return targetHousehold;
    }

    public void updatehouseholds(){
            system.debug('**********************in update hh');
        if(householdsToUpdate.size()>0) {
                system.debug('**********************updating ' +  householdsToUpdate.values());
            update householdsToUpdate.values();
        }
    }

}