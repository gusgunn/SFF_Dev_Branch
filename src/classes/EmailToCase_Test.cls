@isTest
Public Class EmailToCase_Test {

  public static testMethod void testCopyEmailMessagesToCaseComments()
    {
        Contact c = new Contact(Lastname='Fred', FirstName='Jones');
        insert c;
        Case c1 = new Case(Subject='blah', Add_5_Mins_to_Start_Time_For_End_Time__c= 5, Call_Type__c = 'Contact', Origin ='Email', contactId= c.Id);
        insert c1;
        
        List<EmailMessage> emails = new List<EmailMessage>();
        emails.add(new EmailMessage(ParentId=c1.Id,FromAddress='yo@yo.com',FromName='Yo',Subject='Subject',TextBody='TextBody',ToAddress='to@to.com'));
        emails.add(new EmailMessage(ParentId=c1.Id,FromAddress='yo@yo.com',FromName='Yo',Subject='Subject',HtmlBody='<b>HtmlBody</b><i>more</i>',ToAddress='to@to.com'));
        insert emails;
        
        List<CaseComment> comments = [select Id,CommentBody from CaseComment where ParentId=:c1.Id];
        System.assert(comments.size()==2);
        
        for (CaseComment comment:comments) {
            System.debug(comment.CommentBody);
            System.assert(comment.CommentBody!=null && comment.CommentBody!='');
        }
    }
}