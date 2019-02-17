trigger CaseTrigger on Case (before insert, after insert, before update, after update, before delete, after delete) {
   
   
   HouseholdUpdater householdUpdater = new HouseholdUpdater(); 
   InteractionUpdater interactionUpdates = new InteractionUpdater ();

 
    
    if(trigger.operationType == TriggerOperation.AFTER_INSERT ||
       trigger.operationType == TriggerOperation.AFTER_UPDATE){
      //     InteractionDispatcher.getInteractionRecordType(trigger.new);
      //FamilyReferralTracks.sortCases(trigger.new);
      
      InteractionDispatcher.handleTrigger(trigger.operationType, trigger.new, trigger.old, householdUpdater);
       }
    
   // this deals with the updater after all processing has been done    
    List<ITriggerExtension> dyanmicTriggers = TriggerExtensionSupport.getTriggerClasses('Case');
    for(ITriggerExtension trig: dyanmicTriggers){
        trig.HandleTrigger(trigger.operationType, trigger.new, trigger.old, 
                           trigger.newMap, trigger.oldMap);
    }
    // or worker or hh updater
    householdUpdater.updateHouseholds();
   
           
     
}