@istest
public class actionGGRC_Test {
    
    
    @testSetup static void setup() {
        
        DataForTest.testSetupCoreObjects();
        List<Issue__c> issue = [SELECT Id, Type_of_Issue__c, Caller_Name__c, Issue_Contact__c FROM Issue__c ];
        System.assertEquals(1, issue.size() );
        String extActionId= DataForTest.actionExternalRT.Id;
        
        Action__c testAction = new Action__c(recordTypeId = extActionId, Caller_Name__c = issue[0].Caller_Name__c, Child_Name__c = issue[0].Issue_Contact__c,
                                             Action_Status__c = 'Pending', Referral_Date__c = date.Today(), 
                                             issues__c = issue[0].Id, Issue_Type__c = 'AAC',  Action_Detail_Type_External_Referral__c= 'GGRC POS Assessment');
        insert testAction;
        Action__c testAction2 = new Action__c(recordTypeId = DataForTest.actionExternalRT.Id, Caller_Name__c = issue[0].Caller_Name__c, Child_Name__c = issue[0].Issue_Contact__c,
                                              Action_Status__c = 'Pending', Referral_Date__c = date.Today(), 
                                              issues__c = issue[0].Id, Issue_Type__c = 'Behavior',  Action_Detail_Type_External_Referral__c= 'Request ISFP Meeting');
        
        insert testAction2;
        List<Action__c> a2 = [SELECT Id FROM Action__c LIMIT 1 ];
        System.assertEquals(1, a2.size() );
        
    	 Action__c testActionNonExternalReferral = new Action__c(recordTypeId = DataForTest.actionRT.Id, Caller_Name__c = issue[0].Caller_Name__c, Child_Name__c = issue[0].Issue_Contact__c,
                                              Action_Status__c = 'Pending', Referral_Date__c = date.Today(), 
                                              issues__c = issue[0].Id, Issue_Type__c = 'Behavior',  Action_Detail_Type_Internal_Referral__c= 'Behavior Support Group');
        
        insert testActionNonExternalReferral;
        List<Action__c> a3 = [SELECT Id FROM Action__c LIMIT 1 ];
        System.assertEquals(1, a3.size() );
    }
    
    @isTest 
    static void testGGRCTrue(){
        List<Action__c> actions =[SELECT GGRC_Pos__c, Action_Detail_Type_External_Referral__c FROM Action__c  ];
        for( Action__c a: actions) {
            if(a.Action_Detail_Type_External_Referral__c!= Null && a.Action_Detail_Type_External_Referral__c.contains('GGRC POS') ){
                System.assertEquals( true, a.GGRC_Pos__c);
                System.assertEquals(  'GGRC POS Assessment', a.Action_Detail_Type_External_Referral__c);
            } else if(a.Action_Detail_Type_External_Referral__c!= Null && a.Action_Detail_Type_External_Referral__c != Null){
                System.assertEquals( false, a.GGRC_Pos__c);
                System.assertEquals(  'Request ISFP Meeting', a.Action_Detail_Type_External_Referral__c);
            } Else{
                 System.assertEquals(  Null, a.Action_Detail_Type_External_Referral__c);

            }
            
        }
    }
    
    @isTest 
    static void testUncheckGGRCAndRunOnce(){
        action__c a  =[SELECT Id, GGRC_Pos__c, Action_Detail_Type_External_Referral__c 
                       FROM Action__c 
                       WHERE Action_Detail_Type_External_Referral__c= 'GGRC POS Assessment' 
                       LIMIT 1 ];
        a.Action_Detail_Type_External_Referral__c='Request ISFP Meeting';
         test.startTest(); 
        update a;
        
        action__c u  = [SELECT Id, GGRC_Pos__c, Action_Detail_Type_External_Referral__c FROM Action__c WHERE Id =:a.Id ];
        System.assertEquals( false, u.GGRC_Pos__c); 
        
        u.Action_Detail_Type_External_Referral__c = 'GGRC POS Training';
        update u;
        test.stopTest();
        
        Action__c ranOnce = [SELECT Id, GGRC_Pos__c FROM Action__c WHERE Id =:u.Id ];
        System.assertEquals(false, ranOnce.GGRC_Pos__c );
        
    }
    @isTest 
    static void testUpdateGGRC(){
        Action__c u =[SELECT GGRC_Pos__c, Action_Status__c, Action_Detail_Type_External_Referral__c 
                      FROM Action__c  WHERE GGRC_Pos__c=false 
                      AND Action_Detail_Type_External_Referral__c!=Null
                      LIMIT 1];
       
        u.Action_Detail_Type_External_Referral__c = 'GGRC POS Training';
       
        test.startTest(); 
        update u;
        test.stopTest();
      
        Action__c t = [SELECT Id, GGRC_Pos__c FROM Action__c WHERE Id =:u.Id ];
        System.assertEquals(true, t.GGRC_Pos__c ); 
        
    }
    
}