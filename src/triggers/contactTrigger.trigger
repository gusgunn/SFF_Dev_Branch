trigger contactTrigger on Contact  (before insert, after insert, before update, after update, before delete, after delete) {

    HouseholdUpdater householdUpdater = new HouseholdUpdater();

    // What happens when you change the order of these two triggers handlers?
    if (trigger.operationType == TriggerOperation.AFTER_INSERT)
    {
       // SomeLogicClassForContact.handleTrigger(trigger.new, householdUpdater);
    }

    if(trigger.operationType == TriggerOperation.AFTER_INSERT ||
        trigger.operationType == TriggerOperation.AFTER_UPDATE ||
        trigger.operationType == TriggerOperation.AFTER_DELETE)
    {
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