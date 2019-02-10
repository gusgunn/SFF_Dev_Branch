public class Support_CaseDisplay {
    
    @AuraEnabled
    public static List<CaseComment> getCaseComments(String caseId) {
        List<CaseComment> caseComments = 
            [SELECT Id, ParentId, IsPublished, CommentBody, CreatedDate, CreatedBy.Name, LastModifiedDate, LastModifiedById FROM CaseComment 
             where parentId=:caseId order by CreatedDate desc];
        
        return caseComments;        
    }
    
    @AuraEnabled
    public static List<CaseComment> getCaseAllComments(String kidId) {
        List<CaseComment> caseComments = new List<CaseComment>();
        List<Case> cases = [Select 
                            (Select Id, ParentId, IsPublished, CommentBody, CreatedBy.Name, CreatedDate, SystemModstamp, LastModifiedDate, LastModifiedById, IsDeleted 
                             From Case.CaseComments) 
                            From Case 
                            Where Family__Child__c =: kidId order by CreatedDate desc];
        
        for(Case c : cases){
            for(CaseComment comm : c.CaseComments){
                caseComments.add(comm);
                System.debug(comm.CommentBody);
            }
        }
        return caseComments;        
    }
    
    @AuraEnabled
    public static CaseComment addCaseComment(String caseId, String commentBody, String caseCommentId) {
        
        if(!String.isBlank(caseCommentId)) {
            CaseComment caseCommentExists = 
                [SELECT Id, ParentId, IsPublished, CommentBody, CreatedDate, CreatedBy.Name, LastModifiedDate, LastModifiedById FROM CaseComment 
                 where Id=:caseCommentId LIMIT 1];
            
            caseCommentExists.commentBody = commentBody;
            upsert caseCommentExists;
            return caseCommentExists; 
            
        }else{ 
            CaseComment caseComment = new CaseComment(ParentId=caseId, CommentBody=commentBody);
            insert caseComment;
            return caseComment; 
        }
        
        
    }    
}