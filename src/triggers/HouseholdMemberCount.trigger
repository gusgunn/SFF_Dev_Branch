trigger HouseholdMemberCount on Contact (after insert, after update, after delete) {
    //Lightworks
    //diSABLE FOR ACTON
    Set <ID> fAcc = new Set <ID>();
    Set <ID> fAccDeleted = new Set <ID>();
    if (trigger.isAfter && trigger.isInsert) {
     	/*for(contact a : trigger.New) {
                if(a.npo02__Household__c != NULL){
                fAcc.add(a.npo02__Household__c);
            }
        }
    }
    
    if (trigger.isAfter && trigger.isUpdate) {
        
        for(contact a : trigger.Old) {
            //if(a.npo02__Household__c != NULL){
            //if(trigger.old !=trigger.new) -- a.npo02__Household__c.ID
           	 fAcc.add(a.npo02__Household__c);
            //}
        }
    
        
            for(contact a : trigger.New) {
                 if(a.npo02__Household__c != NULL){
                    fAcc.add(a.npo02__Household__c);
             }
        }
    }
    HouseHoldMethods.countContacts(fAcc); 
    
    if(trigger.isAfter && trigger.isDelete){
         for(contact a : trigger.Old) {
            if(a.npo02__Household__c != NULL){
            //if(trigger.old !=trigger.new) -- a.npo02__Household__c.ID
           	 fAccDeleted.add(a.npo02__Household__c);
            }
         }
        
    }
    HouseHoldMethods.countContactsDeleted(fAccDeleted); */
    }
}