public without sharing class WorkerUpsert implements Queueable 
{
    public static Boolean testingException = false;
    Map<Integer, List<sObject>> indexToObjectUpdates;
    Integer index;
    
    public WorkerUpsert(Map<Integer, List<sObject>> indexToObjectUpdates, Integer index)
    {
        this.indexToObjectUpdates = indexToObjectUpdates;
        this.index = index;
    }
    
    public void execute(QueueableContext context) 
    {
        System.Debug('index = ' + index);
        if (!indexToObjectUpdates.containsKey(index))
            return;
        
        System.debug('WorkerUpsert executing on index: ' + index);
        try {
            // if (!testingException) 
            upsert indexToObjectUpdates.get(index);
            System.debug(indexToObjectUpdates.get(index));
            System.debug('WorkerUpsert Sucess on index: ' + index);
            // else throw new DmlException();
            
        } catch (Exception e){
            
            SendErrorMessage.getErrors(e);
        }
        
        
        System.debug('Enqueueing index: ' + (index + 1));
        
        Integer nextIndex = index + 1;
        if (indexToObjectUpdates.containsKey(nextIndex))
            
            try{
                
                System.enqueueJob(new WorkerUpsert(indexToObjectUpdates, nextIndex));
                System.debug(indexToObjectUpdates.get(index));
                System.debug('WorkerUpsert enqueue Sucess on index: ' + index); 
            } catch (Exception e){
                
                SendErrorMessage.getErrors(e);
            }
    }   
    
}