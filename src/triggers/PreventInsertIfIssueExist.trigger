trigger PreventInsertIfIssueExist on Issue__c (before insert)
{
    IssuesUtility.PreventIssueInsertion(Trigger.New);
}