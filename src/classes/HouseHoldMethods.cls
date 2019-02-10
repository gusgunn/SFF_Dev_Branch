global class HouseHoldMethods {
    
    
    @future 
    public static void countContacts(Set <ID> accountIDs){
        //System.Debug('accountIDs In' + accountIDs());
        
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
    
    
     @future 
    public static void countContactsDeleted(Set <ID> accountIDs){
        //System.Debug('accountIDs In' + accountIDs());
        
        List <npo02__Household__c> accountsUpdate = new List <npo02__Household__c>();
         List<npo02__Household__c> lstAccount = [select id, Number_In_Household__c , (select id from npo02__Contacts__r  ) from npo02__Household__c where id in :accountIDs ];
        List<Contact> Conts = [Select ID, npo02__Household__r.ID from Contact Where npo02__Household__r.ID IN : accountIDs];
        
        for(npo02__Household__c i : lstAccount){
            Integer total = 0;
            if(i.ID != NULL) {
            npo02__Household__c a = new npo02__Household__c();
            for(Contact c : conts) {
                
                if(c.npo02__Household__c == i.ID  ) {
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
}
/*For each Account ID passed to the method, 
* count the number of Contact records associated to it 
* and update the 'Number_of_Contacts__c' field with this value.

public class AccountProcessor 
{
  @future
  public static void countContacts(Set<id> setId) 
  {
      List<Account> lstAccount = [select id,Number_of_Contacts__c , (select id from contacts ) from account where id in :setId ];
      for( Account acc : lstAccount )
      {
          List<Contact> lstCont = acc.contacts ;
          
          acc.Number_of_Contacts__c = lstCont.size();
      }
      update lstAccount;
  }
}
*/