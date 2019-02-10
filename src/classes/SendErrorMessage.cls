public class SendErrorMessage {
 	//SendErrorMessage.getErrors(e);
    public static void getErrors(Exception e){
         Database.DMLOptions errorDMLOption = new Database.DMLOptions();
                errorDMLOption.AllowFieldTruncation = true;
                String newLine = '\n';
                String errorMessage = e.getMessage() + 
                    newLine + e.getStackTraceString();
               Database.insert(new Error__c(Message__c = errorMessage), 
                                errorDMLOption);
    }
}