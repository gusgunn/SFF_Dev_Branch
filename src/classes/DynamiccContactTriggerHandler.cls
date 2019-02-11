public with sharing class DynamiccContactTriggerHandler implements ITriggerExtension {

    public void HandleTrigger(TriggerOperation operationType,
                        List<SObject> newList, List<SObject> oldList,
                        Map<ID, SObject> newMap, Map<ID, SObject> oldMap ) 
    {
        system.debug('Trigger extension was called');
    }

}