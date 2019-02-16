public class InteractionUpdater {
	    
    Map<Id, Case> casesToUpdate = new Map<Id, Case>();
    
    public Case getCase(Id caseId){
 
        Case targetCase = casesToUpdate.get(caseId);
        if(targetCase == null){
            targetCase = new Case(Id = caseId);
            casesToUpdate.put(caseID, targetCase);
        }
        return targetCase;
    }

    public void updateCases(){
        if(casesToUpdate.size()>0) update casesToUpdate.values();
    }

}