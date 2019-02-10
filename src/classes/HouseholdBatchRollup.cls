global class HouseholdBatchRollup implements 
Database.Batchable<sObject>, Database.Stateful {
    // Lightworks
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'Select ID, Number_In_Household__c from npo02__Household__c where Number_In_Household__c = NULL'
        ); // limit 200?
    }
    
    global void execute(Database.BatchableContext bc, List<npo02__Household__c> scope){
        // process each batch of records
        Set <npo02__Household__c> accountsUpdate = new Set <npo02__Household__c>();
        List<Contact> Conts = [Select ID, npo02__Household__r.ID from Contact Where npo02__Household__r.ID IN : scope];
        System.debug('scope size = ' + scope.size());
        for(npo02__Household__c i : scope){
            System.Debug('Household ID = ' + i.ID);
            Integer total = 0;
            if(i.ID != NULL) {
                npo02__Household__c a = new npo02__Household__c();
                for(Contact c : conts) {
                    system.debug(c.npo02__Household__c + ' Contact HH');
                    if(c.npo02__Household__r.ID == i.ID & c.npo02__Household__r.ID!= NULL ) {
                        total = total + 1;
                        System.Debug('Total' + total);    
                    }
                }
                a.id = i.ID;
                a.Number_In_Household__c = total;
                
                accountsUpdate.add(a);
                 System.debug('accountsUpdate From loop' + accountsUpdate);
                // increment the instance member counter
                recordsProcessed = recordsProcessed + 1;
            }
        }
        System.debug('accountsUpdate From method' + accountsUpdate);
        if(accountsUpdate.size()>0){
            List<npo02__Household__c> toUpdate = new List<npo02__Household__c>(accountsUpdate);
            update toUpdate;  
        }
        
    }
    
    
    
    
    global void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + ' records processed. Shazam!');
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
                            JobItemsProcessed,
                            TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob
                            WHERE Id = :bc.getJobId()];
        // call some utility to send email
        //EmailManager.sendMessage(job, recordsProcessed);
    }    
    
}



/*

List <npo02__Household__c> accountsUpdate = new List <npo02__Household__c>();
List<npo02__Household__c> lstAccount = [select id, Number_In_Household__c , (select id from npo02__Contacts__r  ) from npo02__Household__c where id in :accountIDs ];
List<Contact> Conts = [Select ID, npo02__Household__r.ID from Contact Where npo02__Household__r.ID IN : accountIDs];

for(npo02__Household__c i : lstAccount){
Integer total = 0;
if(i.ID != NULL) {
npo02__Household__c a = new npo02__Household__c();
for(Contact c : conts) {

if(c.npo02__Household__c == i.ID & c.npo02__Household__c!= NULL ) {
total = total + 1;
System.Debug('Total' + total);    
}
}
a.id = i.ID;
a.Number_In_Household__c = total;

accountsUpdate.add(a);
}
}
System.debug('accountsUpdate From method' + accountsUpdate.size());
if(accountsUpdate.size()>0){
update accountsUpdate;  
}

}


*/