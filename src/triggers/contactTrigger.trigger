trigger ContactTrigger on Contact  (before insert, after insert, before update, after update, before delete, after delete) {
    
 HouseholdUpdater householdUpdater = new HouseholdUpdater();
   

    
    if(trigger.operationType == TriggerOperation.AFTER_INSERT ||
       trigger.operationType == TriggerOperation.AFTER_UPDATE ||
       trigger.operationType == TriggerOperation.AFTER_DELETE){
               system.debug('**********************in contact trigger all');
           ContactsInHouseholdCount.handleTrigger(trigger.operationType, trigger.new, trigger.old, householdUpdater);
       }
     
     if (trigger.operationType == TriggerOperation.AFTER_INSERT){
        ContactsInHouseholdCount.handleTrigger(trigger.operationType, trigger.new, trigger.old, householdUpdater);
    }
    
       
  List<ITriggerExtension> dyanmicTriggers = TriggerExtensionSupport.getTriggerClasses('Contact');
    for(ITriggerExtension trig: dyanmicTriggers)
    {
        trig.HandleTrigger(trigger.operationType, trigger.new, trigger.old, 
                           trigger.newMap, trigger.oldMap);
    }
    
    householdUpdater.updateHouseholds();
    
}