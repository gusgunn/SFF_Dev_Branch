trigger HouseholdMemberCount on Contact (after insert, after update, after delete) {
    if (Trigger.isUpdate  && Trigger.isAfter){
    }
    
}