trigger ActionTrigger on Action__c (before insert, before update, after insert, after update){
   
    if ( trigger.isInsert  && trigger.isBefore  && actionGGRC.noRepeats ==false) {
        
       actionGGRC.checkGGRConInsert(trigger.new);
     }
        
      if (trigger.isUpdate  && trigger.isBefore && actionGGRC.noRepeats ==false) {
        
       actionGGRC.checkGGRConUpdate(trigger.new, trigger.oldMap);
     }
   
   
    if ((trigger.isInsert  && trigger.isAfter || trigger.isUpdate && trigger.isAfter) ) {
        
        if (CheckRecursionActions.runOnce()){
            
            actionMethods.sortActions(trigger.new);
        }
    }
}