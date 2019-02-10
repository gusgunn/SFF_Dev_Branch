trigger EmailToCaseComments on EmailMessage (before insert) 
{

  List<CaseComment> comments = new List<CaseComment>();
  for (EmailMessage message : trigger.new) {
    comments.add(new CaseComment(
      IsPublished = true,
    
      ParentId    = message.ParentId,
      
      CommentBody = message.Subject + '\n' +  message.FromName + '\n' + message.TextBody));
  }
  
    INSERT comments;
}