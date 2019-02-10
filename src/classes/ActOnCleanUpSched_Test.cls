@isTest
private class ActOnCleanUpSched_Test {
  @isTest static void testMethod6() {
        String s ='s';
        ActOnCleanUpScheduled.ve(s);
            }
    
    @isTest static void testMethod1() {
        String s ='s';
        ActOnHHFindDupeBatch.ve(s);
            }
    
    @isTest static void testMethod3() {
        String s ='s';
        HouseHoldMergeDupeChecked.ve(s);
            }
    
    
    
   /*
    public static String CRON_EXP = '0 0 1 * * ?';

    static testmethod void testScheduledJob() {
    // Dummy CRON expression: midnight on March 15.
    // Because this is a test, job executes
    // immediately after Test.stopTest().

        List<Contact> contacts = new List<Contact>();
        //List<Account> accounts = new List<Account>();
        // insert 200 Contacts
        for (Integer i=0;i<200;i++) {
            contacts.add(new Contact(LastName='Contact '+i, C2__c ='irc2017' ));
        }
        insert contacts;
  
        // Get the IDs of the opportunities we just inserted
        Map<Id, Contact> ContactsMap = new Map<Id, Contact>(Contacts);
        List<Id> ContactsIds = new List<Id>(ContactsMap.keySet());

        Test.startTest();
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTest',
            							CRON_EXP, 
            							new ActOnCleanUpScheduled()); 
		List<Contact> ld = [SELECT Id from Contact where C2__c != null and id in :ContactsIds];
        System.assertEquals(200,ld.size(),'all there');

        // Verify the scheduled job has not run yet.
        
        List<Task> lt = [SELECT Id 
            FROM Task 
            WHERE WhatId IN :ContactsIds];
        System.assertEquals(0, lt.size(), 'Tasks exist before job has run');
        // Stopping the test will run the job synchronously
        Test.stopTest();
        
     

    }*/
}