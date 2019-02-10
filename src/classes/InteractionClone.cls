public class InteractionClone {
    
    public String idOfRec {get;set;}
    public String ClonedCase;
     //public String cCopy;
    private ApexPages.StandardController sc;
    
    public InteractionClone(ApexPages.StandardController sc){
        idOfRec =  ApexPages.currentPage().getParameters().get('id');
        this.sc = sc;
    }

    public void CloneOboInt (){
        List<Related_Issue__c> Iss = new List<Related_Issue__c>();
        Case caseToClone = [SELECT ID, Origin, Call_Type__c, Relationship_to_Child_Person_wDisability__c,  
                            Family__Child__c, Family__Household__c, On_behalf_of__c,   
                            ContactID, Add_5_Mins_to_Start_Time_For_End_Time__c FROM Case WHERE Id = : idOfRec];
        //caseToClone Start_Time__c, Call_Type__c, Development_Screening__c,
        Case cCopy = caseToClone.clone(false,true);
        // cCopy.ContactID = idOfRec.ID;
        insert cCopy;
        ClonedCase = cCopy.id;
        List<Related_Issue__c> issues = [SELECT Id, Case__c, Issue__c, Status__c, Presenting_Issue__c FROM Related_Issue__c WHERE Case__c =: caseToClone.ID];
        for(Related_Issue__c i : issues) {
            Related_Issue__c IssueCopy = i.clone(false,true);
            IssueCopy.Case__c = cCopy.Id;
            IssueCopy.Issue__c = i.Issue__c;
            Iss.add(IssueCopy);
        }
        insert Iss;
    }
    
    //new PageReference('/' + ClonedCase);
    public PageReference save() {
       PageReference detailPage = sc.save();
        if (detailPage != null) {
            // Construct URL of edit page or whatever other page you want
          //  PageReference editPage = new PageReference(detailPage.getUrl());
          //  return editPage;
          System.debug('save' + ClonedCase);
           return new PageReference( '/' + ClonedCase );
        } else { 
            System.debug('Else Save' + ClonedCase);
            return new PageReference( '/' + ClonedCase);
           // return detailPage;
        }
    }
    
   
    
   
    public PageReference doClone(){
        CloneOboInt ();
        
        return new PageReference( '/' + ClonedCase +'/e');
                                 //'/apex/InteractionClonedReturnVF?id='+ ClonedCase +'/e');
    }
   
}