@isTest
public class Support_CaseDisplay_Test {
 
     @testSetup static void testSetupCoreObjects() {
        contact c = new contact();
        c.Firstname = 'joe';
        c.Lastname = 'joe';
        insert c;
         
        case i = new case();
        i.ContactId = c.Id;
        i.Call_Type__c = 'Contact'; 
        i.Origin = 'In-person';
        i.Status = 'Open';
        i.Start_time__c = system.now();
        i.Add_5_Mins_to_Start_Time_For_End_Time__c = 5;
        system.debug('Now= ' + system.now());
        insert i;
         
        CaseComment cc = new CaseComment();
         cc.ParentId=i.Id;
         cc.CommentBody='This is not a test';
         insert cc;
         
        
     }
         
    @isTest 
    static void testGetCaseComments(){
       List<Case> i =[SELECT id FROM Case LIMIT 1];
       String caseId = string.ValueOf(i[0].Id);
       Support_CaseDisplay.getCaseComments(caseId);
       System.assertEquals(1, i.size());
    }
    
      @isTest 
    static void testgetCaseAllComments(){
       List<Contact> i =[SELECT Id FROM Contact];
       String kidId =String.ValueOf(i[0].Id);
       Support_CaseDisplay.getCaseAllComments(kidId);
      //ystem.assertEquals(1, i.size());
    }
    @isTest 
    static void testAddSimpleNewCaseComment(){
       Case i =[SELECT id FROM Case LIMIT 1];
       String caseId = string.ValueOf(i.Id);
       String commentBody = 'New comment';
       String caseCommentId='';
       Support_CaseDisplay.addCaseComment(caseId, commentBody, caseCommentId);
       List<CaseComment> cc = [SELECT ParentId, CommentBody FROM CaseComment LIMIT 1];
       System.assertEquals(1, cc.size());   
    }
     @isTest 
    static void testAppendTextToCurrentCaseComment(){
       Case i =[SELECT id FROM Case LIMIT 1];
       String caseId = string.ValueOf(i.Id);
       String commentBody = 'New comment';
       String caseCommentId='';
       Support_CaseDisplay.addCaseComment(caseId, commentBody, caseCommentId);

        
       List<CaseComment> cc = [SELECT Id, CommentBody FROM CaseComment];
       commentBody += commentBody;
       caseCommentId = cc[0].id;
      
       
       Support_CaseDisplay.addCaseComment(caseId, commentBody, caseCommentId);
     
       List<CaseComment> cc2 = [SELECT Id, CommentBody FROM CaseComment];
       System.assertEquals(2, cc2.size());
       
       
    }
    
  
}