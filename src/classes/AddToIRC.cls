public class AddToIRC {
    
    
    
    /**********
* @gusgunn
* 3/2/18
* Novo Jan18 SB
**************/
    
    
    /****************
*TODO
* added IRC CM fields- need own VF with vegetarian
* added session fileds to pull for irc
* added contact IRC fields
* added ishidden=false for campaigns
* 
* 
* 
* 
* 
* **/
    
    //jQuery   
    public String searchString {get;set;}
    public List<Campaign> con {get;set;}
    // End j
    
    public Boolean interp {get;set;}
    public String status {get;set;}
    public String spec {get;set;}
    public String aboutChild {get;set;}
    public String ChildcareRequest {get;set;}
    public String setChildcareNumber {get;set;}
    public String FoodChoice {get;set;}
    public String interpreterLanguage;
    Private static Campaign IRCMainCampaign = [select Id from Campaign where IRCMain__c = true LIMIT 1];
     Private static Campaign IRCTotalsCampaign = [select Id from Campaign where IRCTotals__c = true LIMIT 1];
    public Contact ParticipantContact {get; set;} //Contact record returned based on Id (pid) query parameter from custom button
    public String ParticipantId {get;set;}  //Value of Query parameter pid      
    
    public list<addtocampaigns_Wrapper> Campaign_List =new list<addtocampaigns_Wrapper>(); //List of campaign records to be used for selection
    public Boolean SubmitDisabled {get;set;}  //[Submit] button and [Select All] button can be used just ones 
    public AddtoCampaignsSetting__c  mySetting {get; set;} //Custom Setting for logged user    
    private String soqlToExecute;
    
    
    Public String ParticipantParentPhone {get; set;} 
    
    public AddToIRC(ApexPages.StandardController controller) {
        mySetting=AddtoCampaignsSetting__c.getInstance();//Custom Setting Definitions
        //get Participant data from Lead or Contact
        searchString='';
        System.debug('searchString= ' + searchString);
        doQuery();
        ParticipantId=System.currentPageReference().getParameters().get('pid');
        getParticipant();
        getCampaign_List();
    }
    
    
    // Private String queryString - get capmaign details based on searchbox;
    public void doQuery(){
        
        String  queryString = searchString+'%';
        system.debug('queryString= ' +queryString);
        soqlToExecute = 'Select Id, Name, StartDate,EndDate, Type, Status, ParentId, RecordTypeId FROM Campaign WHERE Name like :queryString LIMIT 199';
        con = [Select Id, Session__c, IRCMain__c, IRCTotals__c, Name, Start_Date_Time__c, Presentation_Language__c, Target_Audience__c, Number_of_adult_spots_remaining__c, Number_of_child_spots_remaining__c, Maximum_Capacity_Children__c,Maximum_Capacity_Adults__c,Language_Interpreter_Services__c, Type, Status, ParentId, RecordTypeId FROM Campaign WHERE Name like :queryString AND isHidden__c = false  AND Session__c !=Null  AND Start_Date_Time__c>= Last_month Order BY Start_Date_Time__c DESC LIMIT 199 ];
        /*   */
        System.debug('con=' + con);
        
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('Family Attendee','Family Attendee'));
        options.add(new SelectOption('Professional Attendee','Professional Attendee'));
        options.add(new SelectOption('Community Member','Community Member'));
        options.add(new SelectOption('Waitlist Adult','Waitlist Adult'));
        options.add(new SelectOption('Presenter','Presenter'));
        options.add(new SelectOption('Facilitator','Facilitator'));
        options.add(new SelectOption('Exhibitor','Exhibitor'));
        options.add(new SelectOption('Interpreter','Interpreter'));
        options.add(new SelectOption('Caregiver','Caregiver (for Childcare Only)'));
        return options;
    }
    
    public String getStatus() {
        return Status;
    }
    public Boolean getInterp(){
        return Interp;
    }
    
    public void setInterpReq(Boolean i) {
        System.debug('Int req? ' + i);
        this.Interp = i;
    }
    
    
    //Special Accommodations Information    InterpreterLanguage
    public String getSpec(){
        return spec;  
    }
    
    public void setSpec(String sp) {
        this.spec = sp;
    }
    
    public void setStatus(String Stats) {
        this.Status = Stats;
    } 
    
    
    
    
    public String getFoodChoice() {
        return Foodchoice;
    }
    
    public void setFoodchoice(String food) {
        this.Foodchoice = food;
    } 
    
    
    
    public String getParentphoneNum() {
        return ParticipantParentPhone;
    } 
     
    
    public List<addtocampaigns_Wrapper> getCampaign_List() {
        
        //get list for campaign selection 
        if (Campaign_List.Size()==0){
            for (Campaign camp: con){
                Campaign_List.add(new addtocampaigns_Wrapper(camp));
                
                //process contact campaign member records
                for (CampaignMember CM :ParticipantContact.CampaignMembers){
                    if (CM.CampaignId==camp.Id && Campaign_List.Size()>0){
                        //disable check box on visual force page 
                        Campaign_List[Campaign_List.size()-1].disabled=true;
                        break;
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
            //Query Contact
            ParticipantContact=new Contact();  
            ParticipantContact=[Select 
                                c.Name, 
                                c.npo02__Household__c,
                                c.LastName, 
                                c.IsDeleted, 
                                c.Id, 
                                c.FirstName, 
                                c.recordTypeID,
                                c.Phone, 
                                c.MobilePhone, 
                                c.Family__Primary_language__c,
                                c.birthdate,
                                c.Childcare_Special_Considerations__c,
                                c.Account.Name,
                                c.Family_Role__c,
                                c.Family__Professional__c,
                                c.Email,
                                c.IRC_FoodChoice__c,
                                c.CCSpotsNumber__c,
                                c.aChild__c,
                                c.Childcare_Request__c,
                                c.Parent_of_child_w_special_needs__c,
                                c.Family__Gender__c, 
                                c.Family__Ethnicity__c, 
                                c.Family__Race__c,
                                c.MailingPostalCode,
                                c.Hispanic_Latino_please_specify__c,
                                
                                (Select Id, 
                                 CampaignId 
                                 From CampaignMembers
                                 where IsDeleted=false 
                                 order by CreatedDate DESC )
                                From Contact c
                                where c.Id=:ParticipantId  
                               ];
        }
        return;
    }
    
    List <Contact> ContactUpdates = new List <contact>();
    Integer b =0;
    public void  getUpdates(){
        b+=b;
        System.debug('b' +b);
        if (ContactUpdates.size()==0){
            System.Debug('EnterGetUpdates');
            Contact CG = new Contact();
            /*  getParentphoneNum();


if( ParticipantParentPhone == ''){
CG.Id =ParticipantContact.Childcare_Primary_Contact__c;
}ELSE{
CG.Id =ParticipantContact.Childcare_Primary_Contact__c;
CG.MobilePhone = ParticipantParentPhone;
}
ContactUpdates.add(CG); */
            ContactUpdates.add(ParticipantContact);
            // System.Debug('ParticipantParentPhone' + ParticipantParentPhone);
            System.Debug('ContactUpdates' + ContactUpdates.size());
        }Else{
            
        }
        return;
        
    }
    
    
    public PageReference GoToParticipant() {
        //[Back] button setting 
        PageReference pageRef=new PageReference('/'+ParticipantId);
        pageRef.setRedirect(true);
        return pageRef; 
    }
    
    public PageReference Submit() {
        
        
        //[Submit] button logic
        PageReference pageRef;
        getUpdates();
        update ContactUpdates;
        
        
        //list for insert campaign members
        list<CampaignMember> Insert_CampaignMembers = new list<CampaignMember>();
        //iteration throught offered campaigns and generate campaign member records
        for (addtocampaigns_Wrapper camp: Campaign_List){
            //if main only is not selected add the contacts food etc choices to the totals campaign
            if ( camp.camp.IRCMain__c == True && camp.disabled == false && camp.checked == false){
                CampaignMember CM = new CampaignMember();
                CM.CampaignId=IRCTotalsCampaign.Id;
                CM.IRC_Food_Preference__c = ParticipantContact.IRC_FoodChoice__c;
                CM.Request_Childcare__c = ParticipantContact.Childcare_Request__c;
                CM.IRCNumberChildcare__c = ParticipantContact.CCSpotsNumber__c;
                CM.aboutChild__c = ParticipantContact.aChild__c;
                
                    
               
                if(Status==NULL|| Status == 'Family Attendee'){
                    cm.Status='Family Attendee';
                }Else{
                    CM.Status = Status;
                }
                
                
                //CM.Parent_Caregiver__c = ParticipantContact.Childcare_Primary_Contact__c;
                CM.Registration_Status__c ='Registered';
                CM.Special_Accommodations_Information__c = ParticipantContact.Childcare_Special_Considerations__c;
                
                if(Interp!=false){
                    CM.Interpreter_Service_Language__c = ParticipantContact.Family__Primary_language__c;
                }else{
                    CM.Interpreter_Service_Required__c = false;
                    CM.Interpreter_Service_Language__c = '';
                }
                
                
                
                
                //contact campaign member
                CM.ContactId=ParticipantId;  
                
                
                //add to the list for insert
                Insert_CampaignMembers.add(CM);
                
                
            }
            
            if (camp.checked){
                CampaignMember CM = new CampaignMember();
                System.debug('AddToCampaignsLoop');
                //CampaignMember CM = new CampaignMember();
                CM.CampaignId=camp.camp.Id;
                
                if (camp.camp.IRCMain__c == true){
                    
                CM.IRC_Food_Preference__c = ParticipantContact.IRC_FoodChoice__c;
                CM.Request_Childcare__c = ParticipantContact.Childcare_Request__c;
                CM.IRCNumberChildcare__c = ParticipantContact.CCSpotsNumber__c;
                CM.aboutChild__c = ParticipantContact.aChild__c;
                CM.IRC_Main_Event_Only__c=true;
                }else{}
                
                if(Status==NULL|| Status == 'Family Attendee'){
                    cm.Status='Family Attendee';
                }Else{
                    CM.Status = Status;
                }
                
                
                //CM.Parent_Caregiver__c = ParticipantContact.Childcare_Primary_Contact__c;
                CM.Registration_Status__c ='Registered';
                CM.Special_Accommodations_Information__c = ParticipantContact.Childcare_Special_Considerations__c;
                
                if(Interp!=false){
                    CM.Interpreter_Service_Language__c = ParticipantContact.Family__Primary_language__c;
                }else{
                    CM.Interpreter_Service_Required__c = false;
                    CM.Interpreter_Service_Language__c = '';
                }
                
                
                
                
                //contact campaign member
                CM.ContactId=ParticipantId;  
                
                
                //add to the list for insert
                Insert_CampaignMembers.add(CM);
                
            }
            
        }
        
        
        
        
        //if anything was selected execute DML 
        if (Insert_CampaignMembers.size()>0){
            try{
                upsert (Insert_CampaignMembers);
                SubmitDisabled=true;
                //Success message to end user
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 
                                                              ' ('+ 'Added To '+ Insert_CampaignMembers.size().format() + ' Campaigns' + ').');
                ApexPages.addMessage(msg);
            } catch (DMLException e){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 
                                                              mySetting.message_Error__c + e);
                ApexPages.addMessage(msg);
                SendErrorMessage.getErrors(e);
            }
        }else {
            //Validation Message to end user
            
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING, 
                                                          'Please Select At Leat One Campaign' );
            ApexPages.addMessage(msg);
        }
        
        return pageRef; 
    }
    public PageReference SelectAll() {
        //[Select All] button logic
        PageReference pageRef;
        //itterate throught offered campaigns and sellect all that aren't in use already
        for (addtocampaigns_Wrapper camp: Campaign_List){
            if (camp.disabled==false){
                camp.checked=true;
            }
        }
        return pageRef; 
    }
    public PageReference FilterSetting() {
        //[Back] button setting 
        PageReference pageRef=new PageReference('/apex/addtocampaigns_listviewfilter');
        pageRef.setRedirect(true);
        return pageRef; 
    }
    
}