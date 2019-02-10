public class ManageIssuesController
{    
    public String InteractionId { get; set; }
    public List<Issue__c> IssueOnInteraction { get; set; }
    public List<Case> lstCase { get; set; }
    public CreateIssue__c settings { get;set;}
    public String CreateIssueURL {get;set;}
    public List<Related_Issue__c> RelatedIssuesOnInteraction {get;set;}
    
    public ManageIssuesController()
    {
        InteractionId = ApexPages.currentPage().getParameters().get('Id');
        if(InteractionId == null || interactionId == '')
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Invalid Interaction Id, please navigate through Manage Issues' ));     
            return;
        }
        String strQuery = 'Select Id, Name,Type_of_Issue__c,Interaction_Log__c, Issue_Contact__c From Issue__c Where Status__c =\'New\' AND ';
        if(InteractionId !=null)
        {   
            lstCase = [Select Id, CaseNumber , Contact.Id, Contact.Name, Family__Child__c, Family__Child__r.Name From Case Where Id =:InteractionId LIMIT 1];
            
            if(lstCase[0].Family__Child__c != null)
            {
                strQuery +='(Interaction_Log__c = \'' + InteractionId + '\' OR Issue_Contact__c = \''+lstCase[0].Family__Child__c + '\')';
            }else{
                strQuery +='(Interaction_Log__c = \'' + InteractionId + '\' OR Caller_Name__c = \''+lstCase[0]. Contact.Id + '\')';
            }
            System.debug('-------Query '+strQuery);
            IssueOnInteraction = Database.query(strQuery);
            String strURL = LoadAndGetMergedText();
            CreateIssueURL = GetMergedText(lstCase[0], strURL);
            RelatedIssuesOnInteraction = [Select Name, Status__c, Issue__c, Issue__r.Name, Issue__r.Type_of_Issue__c, Id, Case__c From Related_Issue__c Where Case__c =:InteractionId];
            //System.debug('Related Issues On Interaction : ' + RelatedIssuesOnInteraction);
        }  
    }
    public String LoadAndGetMergedText()
    {
        settings = [Select NewIssueURL_1__c, NewIssueURL_2__c From CreateIssue__c LIMIT 1];
        String strURL = '';
        if(settings != null)
        {
            strURL = '/a0p/e';
            if(settings.NewIssueURL_1__c != '' && settings.NewIssueURL_1__c != null)
                strURL = settings.NewIssueURL_1__c;
            if(settings.NewIssueURL_2__c != '' && settings.NewIssueURL_2__c != null)
                strURL += settings.NewIssueURL_2__c;
        }
        return strURL ;
    }
  
    @RemoteAction
    public static List<ActionResult> CreateRelatedIssueSave(String[] lstIssueIds, String[] lstIdsToDel, String Interactionid )
    {  
        List<Related_Issue__c> lstRelatedIssues = new List<Related_Issue__c>(); 
         List<Issue__c> lstInteractionIds = [Select Id,interaction_log__c From Issue__c Where Id In: lstIssueIds]; 
        Map<Id, String> IssueMapWithInteraction = new Map<Id, String>();
        for(Issue__c iId: lstInteractionIds)
        {  
           IssueMapWithInteraction.put(iId.Id,iId.interaction_log__c);
        }
        
        List<Related_Issue__c> alreadyExistsRelIssue = [Select Id, Issue__c, Case__c From Related_Issue__c Where Issue__c =:lstIssueIds AND Case__c =:Interactionid ];
        Set<Id> setExistingRelIssuesId = new Set<Id> ();
        for(Related_Issue__c iId: alreadyExistsRelIssue)
        {  
            setExistingRelIssuesId.add(iId.Issue__c);
        }
        
        for (String IssueId : IssueMapWithInteraction.keySet())
         {
           if(!setExistingRelIssuesId.contains(IssueId))
           {
             Related_Issue__c relatedIssue = new Related_Issue__c(Issue__c = IssueId, Case__c = Interactionid);
             lstRelatedIssues.add(relatedIssue);
           }
        }
         
        List<Related_Issue__c> relIssues = [Select Id From Related_Issue__c Where Issue__c =:lstIdsToDel AND Case__c =: Interactionid ];
        try
        {
            Database.SaveResult[] saveresult =  Database.insert(lstRelatedIssues);
            List<ActionResult> Result = new  List<ActionResult>();
            for(Database.SaveResult sr : saveresult)
            {
                ActionResult res = new ActionResult(sr);
                Result.add(res );
            }
            /*----------------------Delete Functionality-------------------------*/
            Database.Deleteresult[] deleteResultArray = Database.delete(relIssues);
            for(Database.Deleteresult dr : deleteResultArray )
            {
                ActionResult res = new ActionResult(dr);
                Result.add(res );
            }
           
            return Result;     
        }
        catch(Exception ex)
        {
            System.debug('***' + ex);
            return null;
        }         
    }
    
    // Code for Merge Field
    
    /*
    This function merges all the merge fields in the given text using provided object and returns the
    merge data.
    */
    public static String GetMergedText( sObject objData, String strMergeString )
    {
        //Extract list of merge fields from strMergeString
        List<MergeField> listMergeFields = ExtractMergeFields( strMergeString);
        return GetMergedText( strMergeString, listMergeFields, objData);
    }
    
    /*
    This function extracts all the merge fields in the provided string and returns the set of the same.
    */
    public static List<MergeField> ExtractMergeFields( String strMergeString)
    {
        List<MergeField> listRet = new List<MergeField>();
        if( strMergeString == null || strMergeString == '')
          return listRet;
        
        Pattern p = Pattern.compile('\\{!([0-9a-zA-Z._-]+)\\}');
        Matcher m = p.matcher( strMergeString);
        Integer iCount = 0;
          while( m.find())
          {
            system.debug(m.group());
                string[] arrParts = m.group(1).split('\\.');
                system.debug(arrParts);
                if( arrParts.size() == 1 )
                  listRet.add(new MergeField('', arrParts[0]));
                else if( arrParts.size() == 2 )
                  listRet.add(new MergeField(arrParts[0], arrParts[1]));
          }
        System.debug(listRet);
        return listRet;
    }
    
    /*
    This function merges all the merge fields in the given text using provided object and returns the
    merge data.
    */
    public static String GetMergedText( String strMergeString, List<MergeField> listMergeFields, sObject objData)
    {
        Map<String,String> mapParameters = null;
        if(ApexPages.currentPage() != null )
            mapParameters = ApexPages.currentPage().getParameters();
        else
            mapParameters = new Map<String,String>();
     
        for( MergeField field : listMergeFields)
        {
            System.debug(field); 
            String strFieldValue = '';
            try
            {
                if( field.Prefix == 'interaction')
                {
                    if(field.FieldName.toLowerCase().equalsIgnoreCase('contactname'))
                    {
                        strFieldValue = ((Case)objData).Contact.Name;
                    }
                    else if(field.FieldName.toLowerCase().equalsIgnoreCase('childcontact'))
                    {
                       if(((Case)objData).Family__Child__r.Name != null)
                    	{
                        	strFieldValue = ((Case)objData).Family__Child__r.Name;
                    	}else{
                    		strFieldValue = ((Case)objData).Contact.Name;
                    	}
                    }
                    else
                    {
                        strFieldValue = GetFieldValue( objData, field.FieldName);   
                    }
                }  
                if( strFieldValue == null )
                    strFieldValue = '';
                if( field.Prefix == null || field.Prefix == '' )
                    strMergeString = strMergeString.replaceAll( '\\{!' + field.FieldName + '\\}', strFieldValue);
                else
                  strMergeString = strMergeString.replaceAll( '\\{!' + field.Prefix + '.' + field.FieldName + '\\}', strFieldValue);
            }
            catch(Exception ex)
            {
                system.debug(ex.getMessage());
            }
      }
        
        return strMergeString;
    }
    
    public static String GetFieldValue( sObject objData, String strFieldName)
    {
        return String.valueOf( objData.get( strFieldName));
    }
    
    public class MergeField
    {
      public String Prefix { get; set; }
      public String FieldName { get; set;}
      public MergeField(String Prefix, String FieldName)
      {
        this.Prefix = (Prefix != null ) ? Prefix.toLowerCase() : Prefix;
        this.FieldName = FieldName;
      }
    }
    // End Merge field code
}