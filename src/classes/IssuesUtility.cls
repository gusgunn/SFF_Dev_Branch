public class IssuesUtility
{
    public static void PreventIssueInsertion(List<Issue__c> lstIssues)
    {
        List<Issue__c> lstExtingsIssues = [Select Id, Type_of_Issue__c, Status__c From Issue__c where Issue_Contact__c =:lstIssues[0].Issue_Contact__c AND Status__c = 'New'];
        System.debug('Existing---- '+lstExtingsIssues.size() );
        if(lstIssues != null && lstIssues.size() > 0)
        {        
           for(Issue__c issue : lstExtingsIssues)
           {
               if(issue.Type_of_Issue__c == lstIssues [0].Type_of_Issue__c )
               {
                   lstIssues[0].addError('Issue Type already exists for this Child');
               }
           }
        }
        return;
    }
}