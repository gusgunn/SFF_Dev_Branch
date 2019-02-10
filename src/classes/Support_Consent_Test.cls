@isTest
public class Support_Consent_Test {
    
    @TestSetup
    static void testSetup(){
        DataForTest.createProfCasesForOneFamily(1);
        
    }
    
    @isTest 
    static void getDatatableDataLoad(){
        List<Case> cases = [select Id, AccountId, Family__Household__c FROM case LIMIT 1];
        String hhId = String.ValueOf(cases[0].Family__Household__c);
        Support_Consent.getDatatableData(hhId);
        List<Consent__c> consentUpdates = [select Id, Organization__c  FROM Consent__c WHERE Household__c=: hhId LIMIT 1];
        System.AssertEquals(consentUpdates[0].Organization__c , cases[0].AccountId);
    }
     @isTest 
    static void getUpdateDatatableSuccess(){
         date BDate = date.newInstance(2011, 7, 1);
        List<Case> cases = [select Id, Start_time__c FROM case LIMIT 1];
        List<Consent__c> consents = [select Id, Household__c, Verbal_Consent_Date__c FROM Consent__c LIMIT 1];
        consents[0].Verbal_Consent_Date__c = BDate;
        Support_Consent.updateDatatable(consents);
        List<Consent__c> consentUpdates = [select Id, Verbal_Consent_Date__c FROM Consent__c WHERE Id=: consents[0].Id LIMIT 1];
		System.AssertEquals(date.ValueOF(consentUpdates[0].Verbal_Consent_Date__c), BDate);
    }
    
     @isTest 
    static void getUpdateDatatableValidationError(){
        date BDate = date.newInstance(2011, 7, 1);
        List<Case> cases = [select Id, Start_time__c FROM case LIMIT 1];
        List<Consent__c> consents = [select Id, Household__c, Written_Consent_Date__c, First_Written_Consent_Date__c FROM Consent__c LIMIT 1];
        consents[0].Written_Consent_Date__c = BDate;
        consents[0].First_Written_Consent_Date__c = date.ValueOF(cases[0].Start_time__c );
        Try{
        Support_Consent.updateDatatable(consents);
        } catch(dmlexception e) {

           
            System.assert( e.getDmlMessage(0).contains('response {code=error'));
        }
    }  
}