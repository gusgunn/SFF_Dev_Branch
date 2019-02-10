@isTest
public class addToCampaigns_Wrapper_Test {
    static testMethod void myUnitTest() {
   
      addtocampaigns_Wrapper w = new addtocampaigns_Wrapper();
      System.assertEquals(w.checked,false);
 
      addtocampaigns_Wrapper w2 = new addtocampaigns_Wrapper(new Campaign(name='Test1'));
      System.assertEquals(w2.camp.name,'Test1');
      System.assertEquals(w2.checked,false);
    }
}