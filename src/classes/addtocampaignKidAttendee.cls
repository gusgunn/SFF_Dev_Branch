public with sharing class addtocampaignKidAttendee {
    
    
    public String searchString {get;set;}
    public list<campaign> con {get;set;}
    
    public String SpecialAccomodations;
    public String Status;
    public String InterpreterLanguage;
    
    public Lead ParticipantLead {get; set;}  
    public Contact ParticipantContact {get; set;} 
    public string ParticipantId {get;set;}  
    public list<addtocampaigns_Wrapper> Campaign_List =new list<addtocampaigns_Wrapper>(); 
    public Boolean SubmitDisabled {get;set;} 
    public AddtoCampaignsSetting__c  mySetting {get; set;} 
    private String soqlToExecute;
    
    public addtocampaignKidAttendee(ApexPages.StandardController controller) {
        mySetting=AddtoCampaignsSetting__c.getInstance();
        searchString='';
        System.debug('searchString= ' + searchString);
        doQuery();
        
        ParticipantId=System.currentPageReference().getParameters().get('pid');
        getParticipant();
        getCampaign_List();
        
    }
    
    public void doQuery(){
        String  queryString = searchString+'%';
        system.debug('queryString= ' +queryString);
        soqlToExecute = 'Select Id, Name, StartDate,EndDate, Type, Status, ParentId, RecordTypeId FROM Campaign WHERE Name like :queryString LIMIT 199';
        con = [Select Id, Name, Start_Date_Time__c, Presentation_Language__c, Target_Audience__c, Number_of_adult_spots_remaining__c, Number_of_child_spots_remaining__c, Maximum_Capacity_Children__c,Maximum_Capacity_Adults__c,Language_Interpreter_Services__c, Type, Status, ParentId, RecordTypeId FROM Campaign WHERE Name like :queryString  AND RecordTypeID != '012G0000000s0We' AND Start_Date_Time__c>= Last_month Order BY Start_Date_Time__c DESC LIMIT 199 ];
        
        System.debug('con=' + con);
        
    }
    
    
    
    public String getSpec(){
        return SpecialAccomodations;  
    }
    
    public void setSpec(String spec) {
        this.SpecialAccomodations = spec;
    } 
    
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        
        
        options.add(new SelectOption('Child Attendee','Child Attendee'));
        options.add(new SelectOption('Waitlist Child','Waitlist Child'));
        
        
        return options;
    }
    
    public String getStatus() {
        return Status;
    }
    
    public void setStatus(String Stats) {
        this.Status = Stats;
    } 
    
    
    public List<SelectOption> getLangItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('NULL',''));
        options.add(new SelectOption('Spanish','Spanish'));
        options.add(new SelectOption('English','English'));
        options.add(new SelectOption('ASL','ASL'));
        options.add(new SelectOption('Arabic','Arabic'));
        options.add(new SelectOption('Farsi','Farsi'));
        options.add(new SelectOption('French','French'));
        options.add(new SelectOption('German','German'));
        options.add(new SelectOption('Greek','Greek'));
        options.add(new SelectOption('Hebrew','Hebrew'));
        options.add(new SelectOption('Hindi','Hindi'));
        options.add(new SelectOption('Italian','Italian'));
        options.add(new SelectOption('Japanese','Japanese'));
        options.add(new SelectOption('Khmer/Cambodian','Khmer/Cambodian'));
        options.add(new SelectOption('Korean','Korean'));
        options.add(new SelectOption('Laotian','Laotian'));
        options.add(new SelectOption('Mandarin','Mandarin'));
        options.add(new SelectOption('Portuguese','Portuguese'));
        options.add(new SelectOption('Russian','Russian'));
        options.add(new SelectOption('Tagalog','Tagalog'));
        options.add(new SelectOption('Toishanese','Toishanese'));
        options.add(new SelectOption('Hindi','Hindi'));
        options.add(new SelectOption('Vietnamese','Vietnamese'));
        
        return options;
    }
    
    public String getLanguage() {
        return InterpreterLanguage;
    }
    
    public void setlanguage(String lang) {
        this.InterpreterLanguage = lang;
    } 
    
    
    
    public List<addtocampaigns_Wrapper> getCampaign_List() {
        
        if (Campaign_List.Size()==0){
            
            for (Campaign camp: con){
                Campaign_List.add(new addtocampaigns_Wrapper(camp));
                if (ParticipantId.startsWith('00Q')){
                    
                    for (CampaignMember CM :ParticipantLead.CampaignMembers){
                        if (CM.CampaignId==camp.Id && Campaign_List.Size()>0){
                            
                            Campaign_List[Campaign_List.size()-1].disabled=true;
                            break;
                        }
                    }   
                }else{
                    
                    for (CampaignMember CM :ParticipantContact.CampaignMembers){
                        if (CM.CampaignId==camp.Id && Campaign_List.Size()>0){
                            
                            Campaign_List[Campaign_List.size()-1].disabled=true;
                            break;
                        }
                    }
                }
            }
        }
        System.debug('campaignListSize = ' + Campaign_List.size());
        return Campaign_List; 
    }
    
    public void getParticipant() {
        if (ParticipantContact==null ){
            
            SubmitDisabled=false;
            
            if (ParticipantId.startsWith('00Q')){
                ParticipantLead=[Select l.Street, 
                                 l.State, 
                                 l.PostalCode, 
                                 l.Phone, 
                                 l.Name, 
                                 l.LastName, 
                                 l.Id, 
                                 l.FirstName, 
                                 l.Email, 
                                 l.Country, 
                                 l.City,
                                 l.Company,
                                 (Select Id,
                                  CampaignId
                                  From CampaignMembers
                                  where IsDeleted=false  
                                  order by CreatedDate DESC  ) 
                                 From Lead l
                                 where l.Id=:ParticipantId  
                                ];
                
            }
            else if (ParticipantId.startsWith('003')){
                
                ParticipantContact=new Contact();  
                ParticipantContact=[Select 
                                    c.Name, 
                                    
                                    c.LastName, 
                                    c.IsDeleted, 
                                    c.Id, 
                                    c.FirstName, 
                                    c.recordTypeID,
                                    
                                    Family__Primary_language__c,
                                    Account.Name,
                                    (Select Id, 
                                     CampaignId 
                                     From CampaignMembers
                                     where IsDeleted=false 
                                     order by CreatedDate DESC )
                                    From Contact c
                                    where c.Id=:ParticipantId  
                                   ];
                ParticipantLead=new Lead(); 
            }
        }
        return;
    }
    public PageReference GoToParticipant() {
        
        PageReference pageRef=new PageReference('/'+ParticipantId);
        pageRef.setRedirect(true);
        return pageRef; 
    }
    public PageReference Submit() {
        
        PageReference pageRef;
        
        list<CampaignMember> Insert_CampaignMembers =new list<CampaignMember>();
        
        for (addtocampaigns_Wrapper camp: Campaign_List){
            if (camp.checked){
                
                CampaignMember CM = new CampaignMember();
                CM.CampaignId=camp.camp.Id;
                if(Status==NULL){
                    cm.Status='Child Attendee';
                }Else{
                    CM.Status = Status;
                }
                
                
                CM.Interpreter_Service_Language__c = InterpreterLanguage;
                CM.Registration_Status__c ='Registered';
                CM.Special_Accommodations_Information__c = SpecialAccomodations;
                //System.debug(cm.status + ' Status');
                if (ParticipantId.startsWith('00Q')){
                    
                    CM.LeadId=ParticipantId;
                }else{
                    
                    CM.ContactId=ParticipantId;
                }
                
                Insert_CampaignMembers.add(CM);
            }
        }
        
        if (Insert_CampaignMembers.size()>0){
            try{
                insert (Insert_CampaignMembers);
                SubmitDisabled=true;
                
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 
                                                              ' ('+ 'Added To '+ Insert_CampaignMembers.size().format() + ' Campaigns' + ').');
                ApexPages.addMessage(msg);
            } catch (DMLException e){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                              mySetting.message_Error__c + e);
                ApexPages.addMessage(msg);
            }
        }else {
            
            
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING, 
                                                          'Please Select At Leat One Campaign' );
            ApexPages.addMessage(msg);
        }
        
        return pageRef; 
    }
    public PageReference SelectAll() {
        PageReference pageRef;
        for (addtocampaigns_Wrapper camp: Campaign_List){
            if (camp.disabled==false){
                camp.checked=true;
            }
        }
        return pageRef; 
    }
    public PageReference FilterSetting() {
        PageReference pageRef=new PageReference('/apex/addtocampaigns_listviewfilter');
        pageRef.setRedirect(true);
        return pageRef; 
    }
    
}