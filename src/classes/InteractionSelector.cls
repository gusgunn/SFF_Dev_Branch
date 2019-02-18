public class InteractionSelector {
    
    
    public static List<npo02__Household__c> getHouseholdInteractions(Map<Id, Case> interactionMap){
                system.debug('*********in selector:  get hh interactions');
        List <npo02__Household__c> householdInteractions = [SELECT Id, Most_Recent_Household_Interaction__c, First_Interaction__c,
                                                            Last_Intake__c, First_Intake__c, Most_Recent_HH_Interaction_Call_Type__c, 
                                                            First_Family_Assessment__c, Most_Recent_Family_Assessment__c, 
                                                            First_Intake_Survey__c, Most_Recent_Intake_Survey__c,
                                                            Most_Recent_SW_HH_Interaction__c, First_SW_HH_Interaction__c
                                                            FROM npo02__Household__c
                                                            Where Id =: interactionMap.keySet()];
        return householdInteractions;
    }   
    
    public static List<Contact> getContactInteractions(Map<ID, Case> casesMap){
        List <Contact> contactInteractionsList = [ SELECT ID, Last_Interaction_Date__c, First_Interaction__c
                                                  FROM Contact
                                                  Where ID =: casesMap.keyset()
                                                  Order By Last_Interaction_Date__c DESC];
        
        System.Debug('Contact Last Int Date= ' + contactInteractionsList[0].Last_Interaction_Date__c);
        return contactInteractionsList;
    }
    
    
    //System.debug('HH= ' + hd.size());
    /*
String query = 'SELECT ' +  interactionTypeFields + ' FROM npo02__Household__c WHERE Id = ' + Where ID =: cases.keyset();
npo02__Household__c[] hhs = Database.query(query); */
}