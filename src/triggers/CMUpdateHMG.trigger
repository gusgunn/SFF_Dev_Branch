trigger CMUpdateHMG on CampaignMember (before insert, before update) {
    
     
    Map<String, CampaignMember> cmMap = new Map<String, CampaignMember>();
    for(campaignMember cm: trigger.new){
        if (cm.Flag__c == true){
            cmMap.put(cm.ContactId, cm);
            
        }
        
    List<Contact> Up = new list <Contact>();   
    List <Contact> con = [SELECT ID, HMG__c
                         FROM Contact
                         WHERE Contact.ID
                         IN :cmMap.keyset()
                         LIMIT 400];
        
        if (con.size()>0){
        For(Contact c: con){
            if (c.HMG__c==False){
            c.HMG__c =True;
             up.add(c);  
            }
        }
        Update up;
        
        }   
        
   }    
}