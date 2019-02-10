@IsTest
public class HouseholdMergeEmailBatch_Test {
    // RunAs Acton Or MergeSwitch__c= True!!
    @testSetup 
    static void setup() {
        
      List<npo02__Household__c> accts = new List<npo02__Household__c>();
        
        
        for(Integer i=0;i<100;i++) {
            npo02__Household__c av = new npo02__Household__c(Name='Family-u' + i,
                                                             npo02__MailingPostalCode__c ='');
            
            accts.add(av);
        }
        
        
        
        System.debug(accts.size() + ' Number of Accts');
        insert accts;
        
        
        // For each account just inserted, add 10 adult contacts
        List<Contact> cons = new List<Contact>();
        for (Integer j=0;j<99;j++) {
            npo02__Household__c acctv = accts[j];            
            
            cons.add(new Contact(firstname='fred'+ j,
                                 lastname='duf'+ j ,
                                 RecordTypeID ='012G0000000qhDM',
                                 email = 'abcde@abcde.com',
                                 MergeSwitch__c =True,
                                 npo02__Household__c=acctv.Id
                                ));
            
        }
        // Insert all contacts for all accounts
        insert cons;
        
        
        
        
        List<npo02__Household__c> accts2 = new List<npo02__Household__c>();
        for(Integer i=0;i<100;i++) {
            
            npo02__Household__c a = new npo02__Household__c(Name='Family-u' + i,
                                                            npo02__MailingPostalCode__c ='');
            
            accts2.add(a);
        }
        insert accts2;
        
        // For each account just inserted, add 10 adult contacts
        List<Contact> cons3 = new List<Contact>();
        for (Integer j=0;j<1;j++) {
            npo02__Household__c acctc = accts2[j];
            
            
            cons3.add(new Contact(firstname='NewRecord-'+ j,
                                  lastname='Atende'+ j ,
                                  //RecordTypeID ='012G0000000qhDM',
                                  email = 'abcde@abcde.com',
                                  npo02__Household__c=acctc.Id
                                  
                                 ));
            
        }
        insert cons3;
        
     /*   // For each account just inserted, add 10 adult contacts
        List<Contact> cons2 = new List<Contact>();
        for (Integer j=0;j<1;j++) {
            npo02__Household__c acctg = accts2[j];
            
            
            cons2.add(new Contact(firstname='CMS2-'+ j,
                                  lastname='Atendee2'+ j ,
                                  //RecordTypeID ='012G0000000qhDM',
                                  email = 'abcde@abcde.com'
                                  
                                  
                                 ));
            
        }
        // Insert all contacts for all accounts
        insert cons2;*/
        
        
        
        
        
        
      /*  List<MergeRecord__c> mergeStat = new  List<MergeRecord__c>();
        for(Integer m=0;m<10;M++) {
            
            npo02__Household__c AccM = accts2[m];
            npo02__Household__c  AccS =accts[m];
            mergeStat.add(new MergeRecord__c( MasterHH__c  = AccM.ID, HHtoMerge__c = AccS.ID));
            
            
        }
        insert mergeStat;*/
        
    }
    static testmethod void test() {
        Test.startTest();
        
        HouseholdMatchEmailBatch hcb = new HouseholdMatchEmailBatch();
        Id batchId = Database.executeBatch(hcb);
        
        
        Test.stopTest();
        // npo02__Household__c ACC = [select Number_In_Household__c from npo02__Household__c where id = :a.id ];
        // System.assertEquals(ACC.Number_In_Household__c,1);
    }
    
    
}