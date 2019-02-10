@isTest
public class TestCTRL_CreateHolderContact
{
    public TestMethod static void TestCreateHolderContact()
    {
        // Create Account For Opportunity
        Account objAcc = new Account();
        objAcc.Name = 'TestAcc';
        insert objAcc;
        //Checking Assertion
        system.assertNotEquals(objAcc,null);
        
        //Opportunity For Tickets custom Object
        Opportunity objOpportunity = new Opportunity();
        objOpportunity.Name = 'TestOpp1';
        objOpportunity.Account = objAcc;
        objOpportunity.CloseDate = date.today()+2;
        objOpportunity.StageName = 'Posted';
        insert objOpportunity;
        //Checking Assertion
        system.assertNotEquals(objOpportunity,null);
        
        //Create Object for HouseHold
        npo02__Household__c objHouseHold = new npo02__Household__c ();
        objHouseHold.Name = 'TestHouseHold';
        insert objHouseHold;
         //Checking Assertion
        system.assertNotEquals(objHouseHold,null);
        
        //Create Contact For Purchaser
        Contact objPurchaser = new Contact ();
        objPurchaser.FirstName = 'FPurchaser';
        objPurchaser.LastName = 'LPurchaser';
        objPurchaser.MobilePhone = '1234567890';
        objPurchaser.npo02__Household__c = objHouseHold.id;
        insert objPurchaser;
        //Checking Assertion
        system.assertNotEquals(objPurchaser,null);
        
        //Create Contact For TicketHolder
        Contact objTHolder = new Contact ();
        objTHolder.FirstName = 'FTHolder';
        objTHolder.LastName = 'LTHolder';
        objTHolder.MobilePhone = '1234567890';
        objTHolder.npo02__Household__c = objHouseHold.id;
        insert objTHolder;
        
        //sbxe1__Ticket__c ObjTicket = new sbxe1__Ticket__c();
    }
}