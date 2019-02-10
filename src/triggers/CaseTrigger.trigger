trigger CaseTrigger on Case (after insert, after update) {
   
        if ((Trigger.isInsert  && Trigger.isAfter || Trigger.isUpdate && Trigger.isAfter) ) {
            if (CheckRecursionCase.runOnce()){
                InteractionDispatcher.getInteractionRecordType(trigger.new);
                FamilyReferralTracks.sortCases(trigger.new);
        }
    }
}