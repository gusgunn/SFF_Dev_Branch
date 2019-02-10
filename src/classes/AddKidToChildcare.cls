public  class AddKidToChildcare {
   
    /**********
     * @gusgunn
     * 9/7/17
     * SFCD
    /***************9-3-17
*Novo
*GetSet Parent phone
*****************/
    
    /************* 8-27-17 good
*Novo 
* 
*/
    //jQuery   
    public String searchString {get;set;}
    public List<Campaign> con {get;set;}
    // End j
    
    public Boolean interp {get;set;}
    public String status {get;set;}
    public Boolean specialAccomodations;
    public String interpreterLanguage;
    public String favorites;
    public String other;
    public String soothe;
    public String allergies;
    public String allergiesdescription;
    public String Diagnosis_1;
    
    public Contact ParticipantContact {get; set;} //Contact record returned based on Id (pid) query parameter from custom button
    public string ParticipantId {get;set;}  //Value of Query parameter pid      
    
    public list<addtocampaigns_Wrapper> Campaign_List =new list<addtocampaigns_Wrapper>(); //List of campaign records to be used for selection
    public Boolean SubmitDisabled {get;set;}  //[Submit] button and [Select All] button can be used just ones 
    public AddtoCampaignsSetting__c  mySetting {get; set;} //Custom Setting for logged user    
    
    
    // Childcare_Primary_Contact
    public Contact ParticipantParent {get; set;}  
    Public String ParticipantParentPhone {get; set;} 
    
    public AddKidToChildcare(ApexPages.StandardController controller) {
        mySetting=AddtoCampaignsSetting__c.getInstance();//Custom Setting Definitions
        //get Participant data from Lead or Contact
        
        searchString='';
        System.debug('searchString= ' + searchString);
        doQuery();
        //get list for campaign selection 
        //getCampaign_List();
        ParticipantId=System.currentPageReference().getParameters().get('pid');
        getParticipant();
        getCampaign_List();
    }
    
    
    // Private String queryString - get capmaign details based on searchbox;
    public void doQuery(){
        String  queryString = searchString+'%';
        system.debug('queryString= ' +queryString);
        con = [Select Id, Name, Start_Date_Time__c, Number_of_child_spots_remaining__c, Maximum_Capacity_Children__c,Presentation_Language__c, Language_Interpreter_Services__c, Type, Status, ParentId, RecordTypeId FROM Campaign WHERE Name like :queryString  AND RecordTypeID = '012G0000000s0We' AND Start_Date_Time__c>= Last_month Order BY Start_Date_Time__c DESC LIMIT 199 ];     
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('Child','Child'));
        options.add(new SelectOption('Waitlist Childcare','Waitlist Childcare'));
        return options;
    }
    
    public String getStatus() {
        return Status;
    }
    public Boolean getInterp(){
        return Interp;
    }
    public Boolean getSpec(){
        return SpecialAccomodations;  
    }
    
    public void setInterpReq(Boolean i) {
        System.debug('Int req? ' + i);
        this.Interp = i;
    }
    
    
    
    public void setSpec(Boolean spec) {
        this.SpecialAccomodations = spec;
    } 
    
    
    public void setStatus(String Stats) {
        this.Status = Stats;
    } 
    
    
    
    /*
public String getFavorites() {
return Favorites;
}

public void setFavorites(String fav) {
this.Favorites = fav;
} 

*/
    
    public String getParentphoneNum() {
        return ParticipantParentPhone;
    } 
    
    public void setParentphoneNum(String phoneNum) {
        if (phoneNum !=Null){
            this.ParticipantParentPhone = phoneNum;
        } 
    }
    
    public Contact getParentCaregiver() {
        System.debug('getParent= ' + ParticipantParent);
        return ParticipantParent;
        
    }     
    
    public void setParentCaregiver(Contact c) {
        System.debug('getParent= ' + ParticipantParent);
        this.ParticipantParent =c;
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
                                c.Child_requires_1_on_1_care__c,
                                c.Childcare_Special_Considerations__c, 
                                c.Childcare_Favorites__c, 
                                c.Childcare_best_way_to_soothe__c,
                                c.Food_Allergies__c, 
                                c.Food_Allergies_Description__c, 
                                c.Food_Allergy_Typical_Reactions__c,
                                c.Describe_type_s_of_seizure_disorder__c, 
                                c.Child_has_a_seizure_disorder__c,
                                c.Childcare_Primary_Contact__c ,
                                c.Childcare_Primary_Contact__r.MobilePhone, 
                                c.ChildcarePrimaryContactPhone__c,
                                c.Family__Primary_language__c,
                                c.birthdate,
                                c.Account.Name,
                                c.Family__Diagnosis_1_Group__c,
                                c.Family__Diagnosis_1__c,
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
            getParentphoneNum();
            
            
            if( ParticipantParentPhone == ''){
                CG.Id =ParticipantContact.Childcare_Primary_Contact__c;
            }ELSE{
                CG.Id =ParticipantContact.Childcare_Primary_Contact__c;
                CG.MobilePhone = ParticipantParentPhone;
            }
            ContactUpdates.add(CG);
            ContactUpdates.add(ParticipantContact);
            System.Debug('ParticipantParentPhone' + ParticipantParentPhone);
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
            
            if (camp.checked){
                System.debug('AddToCampaignsLoop');
                CampaignMember CM = new CampaignMember();
                CM.CampaignId=camp.camp.Id;
                
                if(Status==NULL|| Status =='Child'){
                    cm.Status='Child';
                }Else{
                    CM.Status = 'Waitlist Childcare';
                }
                
                
                CM.Parent_Caregiver__c = ParticipantContact.Childcare_Primary_Contact__c;
                CM.Registration_Status__c ='Registered';
                
                
                if(Interp!=false){
                    CM.Interpreter_Service_Language__c = ParticipantContact.Family__Primary_language__c;
                }else{
                    CM.Interpreter_Service_Required__c = false;
                    CM.Interpreter_Service_Language__c = null;
                }
                
                if(SpecialAccomodations==true){
                    CM.Special_Accommodations__c = true;
                    CM.Special_Accommodations_Information__c = ParticipantContact.Childcare_Special_Considerations__c;
                } else {
                    CM.Special_Accommodations__c = false;
                    
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
                insert (Insert_CampaignMembers);
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