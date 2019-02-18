trigger CaseTrigger on Case (after insert, after update) {
   householdUpdater houseHoldUpdates = new householdUpdater();
        if ((Trigger.isInsert  && Trigger.isAfter || Trigger.isUpdate && Trigger.isAfter) ) {
            if (CheckRecursionCase.runOnce()){
                        system.debug('****************in caseTrigger');
                InteractionDispatcher.handleTrigger(trigger.operationType, trigger.new, trigger.old, householdUpdates);
               // FamilyReferralTracks.sortCases(trigger.new);
        }
    }
    houseHoldUpdates.updatehouseholds();
}