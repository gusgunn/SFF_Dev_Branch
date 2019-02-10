public without sharing class Worker implements Queueable 
{
    public static Boolean testingException = false;
    Map<Integer, List<sObject>> indexToObjectUpdates;
    Integer index;
    
    public Worker(Map<Integer, List<sObject>> indexToObjectUpdates, Integer index)
    {
        this.indexToObjectUpdates = indexToObjectUpdates;
        this.index = index;
    }
    
    public void execute(QueueableContext context) 
    {
        System.Debug('index = ' + index);
        if (!indexToObjectUpdates.containsKey(index))
            return;
        
        System.debug('Worker executing on index: ' + index);
        System.debug('Worker indexToObjectUpdates= ' +  indexToObjectUpdates);
        try {
           // if (!testingException) 
                update indexToObjectUpdates.get(index);
       // else throw new DmlException();
        
            } catch (Exception e){
                
                SendErrorMessage.getErrors(e);
            }
        
        System.debug(indexToObjectUpdates.get(index));
        System.debug('Enqueueing index: ' + (index + 1));
        
        Integer nextIndex = index + 1;
        if (indexToObjectUpdates.containsKey(nextIndex))
            
            try{
                
                System.enqueueJob(new Worker(indexToObjectUpdates, nextIndex));
                
            } catch (Exception e){
                
                SendErrorMessage.getErrors(e);
            }
    }   
    
}