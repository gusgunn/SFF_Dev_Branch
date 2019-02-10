public with sharing class ActionResult 
{
    public String Id { get; set; }
    public Boolean IsSuccess { get; set; }
    public String Message {get; set; }
    public sObject SFObject { get; set; }
    public Object Data { get; set; }

    public ActionResult() {}
    
    public ActionResult( Database.Saveresult saveResult)
    {
        Id = saveResult.getId();
        IsSuccess = saveResult.isSuccess();
        Message = 'Record saved successfully!!!';
        for( Database.Error dbError : saveResult.getErrors())
        {
            Message += dbError + '\n';
        }
    }
    
    public ActionResult( Database.Deleteresult deleteResult)
    {
        Id = deleteResult.getId();
        IsSuccess = deleteResult.isSuccess();
        Message = 'Record deleted successfully!!!';
        for( Database.Error dbError : deleteResult.getErrors())
        {
            Message += dbError + '\n';
        }
    }
}