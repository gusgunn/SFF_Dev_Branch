public class HouseholdUpdater {
    
    Map<ID, npo02__Household__c> householdsToUpdate = new Map<Id, npo02__Household__c>();
    
    public npo02__Household__c getHousehold(Id householdId){
 
        npo02__Household__c targetHousehold = householdsToUpdate.get(householdId);
        if(targetHousehold == null){
            targetHousehold = new npo02__Household__c(Id = householdId);
            householdsToUpdate.put(householdID, targetHousehold);
        }
        return targetHousehold;
    }

    public void updatehouseholds(){
        if(householdsToUpdate.size()>0) update householdsToUpdate.values();
    }

}