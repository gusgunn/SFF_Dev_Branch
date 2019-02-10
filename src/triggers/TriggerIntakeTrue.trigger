trigger TriggerIntakeTrue on Case (before insert, before update) {

   if ((Trigger.isInsert  && Trigger.isAfter || Trigger.isUpdate && Trigger.isAfter) && checkRecurs.runOnce()){
 	System.debug('nope');
    }
   
}