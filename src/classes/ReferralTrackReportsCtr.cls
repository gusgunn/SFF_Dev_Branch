public class ReferralTrackReportsCtr {
    // 9-19_18 ReferralTr - SFCD
    
    
    // Change date to past quarter or last 3 months OR date d = system.today().addDays(-90);
    // Date Quarter = [Select StartDate From Period Where type = 'Quarter' and StartDate = THIS_FISCAL_QUARTER].StartDate;
    
    /********** ********************
*
* ***********************************/
    
    /******
* TODO Remove  FIRST FIVE REPORTS
* A
* *************/
    
    
    public Date dateFrom {get; set;}
    public Date dateTo {get; set;}
    
    /* Selector determines which VFpage is calling 
* (IA, Referral DB Or FRS dashboard) */
    public String selector { get; set; }
    
    public List<SelectOption> pickUsers { get; set; }
    //public SelectOption pickUser { get; set; }
    
    public Date Q1Ends;
    public Date Q2Ends; 
    public Date Q3Ends; 
    public Date Q4Ends; 
    public Date PriorQuarterEnds;
    public Integer FYBSelected;
    public Integer FYBSecond;
    public User usr;
    public String searchString {get;set;}
    public List <ReferralTracking__c>  soqlToExecute {get;set;}
    public list <Issue__c> issuesToExecute {get;set;}
    
    //IA Duplicated count
    public Integer kidDupeCount { get; set; }
    public Integer profDupeCount { get; set; }
    public Integer CBO  { get; set; }
    public Integer childCare { get; set; }
    public Integer FRC { get; set; }
    public Integer health { get; set; }
    public Integer mental { get; set; }
    public Integer c { get; set; }
    public Integer social { get; set; }
    public Integer other { get; set; }
    public Integer intTotals { get; set; }
    
    //IA Deduped Orgs count
    Public Map <String, Integer> countOrgsUn { get; set; }
    public Integer CBOUn  { get; set; }
    public Integer childCareUn { get; set; }
    public Integer FRCUn { get; set; }
    public Integer healthUn { get; set; }
    public Integer mentalUn { get; set; }
    public Integer cUn { get; set; }
    public Integer socialUn { get; set; }
    public Integer otherUn { get; set; }
    public Integer sizeUn { get; set; }
    
    /*****************************
* For  First Five Reports
* Make Set of Professionals to get Total Interactions in time frame with Each Prof
* Make Map of Prof(key) & their Orgs for Org Category using Interactions
* Make Set of Kids for count of kids
**********/
    public Set <String> countProfessionals = new Set <String>();
    public Map <String, String> countOrgs = new Map <String, String> ();
    public Set <String> countKids = new Set <String>();
    public Map <String, String> countDupeOrgs = new Map <String, String> ();
    public Map<String, String> usersMap = new Map <String, String>();
    public Map<String, Issue__c> issueMapCon = new Map <String, Issue__c>();
    
    private Map <String, ReferralTracking__c> ReferralProf = new  Map <String, ReferralTracking__c>();
    private Map <String, ReferralTracking__c> ReferralChild = new  Map <String, ReferralTracking__c>();
    private Map <String, ReferralTracking__c>  findChildPermissions = new Map <String, ReferralTracking__c> ();
    private Map <String, ReferralTracking__c> findOrgPermissions = new Map <String, ReferralTracking__c> ();
    private String pmpVar ='PMP' + '%';
    private Set <String> filteredIds = new Set <String>();
    
    
    public ReferralTrackReportsCtr(){
        searchString='';
        System.debug('searchString= ' + searchString);
        doQuery();
        kidDupeCount= 0;
        profDupeCount=0;
        intTotals=0;
        date DefaultDateTo = system.today();
        date defaultDateFrom = system.today().addDays(-90);
        dateTo = defaultDateTo;
        dateFrom = defaultDateFrom;
        pickUsers = new List<SelectOption>();
        // selectedUsers = new List<User>();
        for (User users : [SELECT ID, Name FROM User ORDER BY Name])
            pickUsers.add(new SelectOption(users.Id, users.Name));
        
    }
    
    public PageReference startGenerateBoard() {
        if (dateFrom != null && dateTo != null) {
            if (dateTo >= dateFrom) {
                generateBoard(); 
                getGenerateRTs();
                
                if (selector !=NULL){
                    getDupeOrgCats();
                    getOrgCats() ;
                }   
                
            } else {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Date To must be greater than or equal to Date From!');
                ApexPages.addMessage(myMsg);
            }
        } else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You must select a Date From and a Date To!');
            ApexPages.addMessage(myMsg);
        }
        return null;
    }
    
    private void runFRSBoard() {
        getOpenIssues();
        usr = [SELECT Id FROM User WHERE Id = : UserInfo.getUserId()];  
       //  UserName = ,
    }
    
    private void generateBoard() {
        countProfessionals.clear();
        CBO=0;
        childCare=0;
        frc=0;
        hEALTH=0;
        MENTAL=0;
        C=0;
        SOCIAL=0;
        OTHER=0;
        countOrgs.Clear();
        countKids.Clear();
        countDupeOrgs.Clear();
        kidDupeCount= 0;
        profDupeCount=0;
        intTotals=0;
        FYBSelected = (Integer.valueof(DateFrom.year()));
        FYBSecond = (Integer.valueof(DateFrom.year() + 1));
        Q1Ends = date.newInstance(FYBSelected, 9, 30 );
        Q2Ends = date.newInstance(FYBSelected, 12, 31 );
        Q3Ends = date.newInstance(FYBSecond, 3, 31 );
        Q4Ends = date.newInstance(FYBSecond, 6, 30 );
        System.debug('Q1Ends= ' +  Q1Ends + ' Q2Ends= ' + Q2Ends + ' Q3Ends= ' + Q3Ends + ' Q4Ends= ' + Q4Ends );
        
        if (selector == NULL){
            runFRSboard();
        }   
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All','All'));
        options.add(new SelectOption('IA','IA'));
        return options;
    }
    
    public String getSelector() {
        return selector;
    }
    
    public void setSelector(String s) {
        this.selector = s;
    } 
    
    /*    public SelectOption setAssignedTo(SelectOption Stats) {
this.pickUser = Stats;
} 

public User getUser() {

return pickUser;
}

public void setUser(User u) {
this.pickUser = u;
} */   // Private String queryString - Filter list based on searchbox;
    public  void doQuery(){
        String  queryString = searchString+'%';
        soqlToExecute = [Select ID, Referral_Received_From__r.LastName, Child_Referred__r.LastName, 
                         Referral_Organization__r.Name, Assigned_To__r.FirstName, Household_Referred__r.Name, 
                         Household_Referred__r.First_Intake__c, Household_Referred__r.Owner.Name,  Child_Referred__r.Owner.Name,
                         Household_Referred__r.Household_SW__r.Name, Household_Referred__r.Household_SFIN_Coach__r.Name 
                         FROM ReferralTracking__c
                         WHERE ID IN :filteredIDs 
                         AND (Assigned_To__r.LastName like :queryString 
                              OR Household_Referred__r.Name like :queryString 
                              OR  Referral_Organization__r.Name like :queryString 
                              OR  Child_Referred__r.LastName like :queryString 
                              OR  Child_Referred__r.Owner.Name like :queryString 
                              OR  Household_Referred__r.Household_SW__r.Name like :queryString 
                              OR  Household_Referred__r.Owner.Name like :queryString 
                              OR Household_Referred__r.Household_SFIN_Coach__r.Name like :queryString 
                              
                              OR Referral_Received_From__r.LastName like :queryString )
                         LIMIT 49 ];
        
        issuesToExecute =[SELECT ID, Name, Caller_Name__R.Account.Name,  
                          Issue_Contact__r.npo02__Household__R.name, Issue_Contact__c 
                          FROM Issue__c
                          WHERE Issue_Contact__r.npo02__Household__r.Name like :queryString 
                          OR Caller_Name__R.Account.Name  like :queryString
                          OR Caller_Name__R.Name  like :queryString
                          OR Issue_Contact__r.Name like :queryString
                          OR Name like :queryString
                          LIMIT 49];
        
    }
    
    public List<ReferralTracking__c> getGenerateRTs() {
       // List<ReferralTracking__c> findReferralPermissions = new List <ReferralTracking__c>();
       //  List <ReferralTracking__c>  UpsertReferralsList = new List <ReferralTracking__c>();

        /* User selectedUser = new User();       
if(pickUser!=Null){
User s = pickUser;
}*/
        
        
        //list to exclude non IA if selector == IA
        List<ReferralTracking__c> filteredReferrals = new List<ReferralTracking__c>();
        
        Map <String, List<ReferralTracking__c>> allNewReferralActions = new  Map <String, List<ReferralTracking__c>>();
        Map <String, ReferralTracking__c> existingKeys = new Map <String, ReferralTracking__c>();
        List<ReferralTracking__c> Referrals = [SELECT Id, Name, Key__c, Referral_Received_From__c, Referral_Received_From__r.LastName, 
                                               Child_Referred__c, Child_Referred__r.LastName, Child_Referred__r.Birthdate,  Assigned_To__c, 
                                               Household_Referred__c, Date_On_Referral_Form__c, Owner.Alias, Owner.Name, LM1_IntID__c, LM2_IntID__c,
                                               Referral_Action__c, ActionUpdateReference__c, Permission_Received__c, Referral_Received_From__r.AccountID,
                                               Permission_Date__c, Referral_Organization__c, Referral_Organization__r.Parent.Name, Referral_Organization__r.Phone, 
                                               ActionReference__c, Referral_Received_From__r.Phone, Referral_Received_From__r.email,
                                               Cbx_Referral_Received__c, CbxReferral_Confirmed__c, CbxContact_Confirmation_Sent__c, CbxReferral_Update__c, 
                                               UTC_Professional_Notify__c, InteractionReference__c, Initial_Interaction_Date__c, date_Contact_Conf_Sent__c,
                                               Date_Referral_Received__c,  Date_Contact_Confirmation_Sent__c, Date_TYSent__c, date_Update_Sent__c, 
                                               Household_Referred__r.Household_SFIN_Coach__r.Id, Household_Referred__r.Last_Intake__c, Date_UTC_to_Prof__c, 
                                               Date_Update__c, CompletedCGSucess__c, Completed_Prof_Notification__c, Track_Complete__c,
                                               Household_Referred__r.First_Intake__c, Household_Referred__r.Owner.Name,  Household_Referred__r.Household_SW__r.Name,
                                               Household_Referred__r.OwnerID, Household_Referred__r.Household_SW__r.Id, Child_Referred__r.Owner.Name
                                               FROM ReferralTracking__c
                                               WHERE ((Initial_Interaction_Date__c >= :DateFrom AND Initial_Interaction_Date__c <= :dateTo)
                                                      OR (Date_Referral_Received__c >= :DateFrom AND Date_Referral_Received__c <= :dateTo)
                                                      OR (Date_TYSent__c >= :DateFrom AND Date_TYSent__c <= :dateTo))
                                               AND (NOT Referral_Received_From__r.LastName Like '%Neale%')
                                               AND (NOT Referral_Received_From__r.LastName Like '%Test%')
                                               AND (NOT Child_Referred__r.LastName Like '%Test%')
                                               AND (NOT Child_Referred__r.LastName Like '%Neale%')
                                               ORDER BY ReferralTracking__c.Household_Referred__r.Owner.Name Desc];
        
        /* If need IA agegroup, use that fileter. Else use all */
        for (ReferralTracking__c c : Referrals) { 
            if (selector == 'IA' && c.Child_Referred__r.Birthdate !=NULL){
                Integer age = c.Child_Referred__r.Birthdate.monthsBetween(dateTo);
                System.debug('######## again months= ' + age);
                Boolean monthsBetween = false;
                
                if(age <72){
                    //monthsBetween = c.Child_Referred__r.BirthDate.monthsBetween(dateTo) <72){
                    filteredReferrals.add(c);
                } else {
                    //dont need that kid
                }
                
            } else if (c.Child_Referred__r.Birthdate !=NULL) {
                filteredReferrals.add(c);
            } else{
                
            }       
        }
        
        kidDupeCount = 0;
        profDupeCount = 0;
        Integer OrgCount =0;
        for (ReferralTracking__c rtList : filteredReferrals) { 
            filteredIds.add(rtList.ID);
            
            ReferralProf.put(rtList.Referral_Received_From__c, rTList); 
            ReferralChild.put(rtList.Child_Referred__c, rTList);
            
            findChildPermissions.put(rtList.Child_Referred__c, rTList);
            findOrgPermissions.put(rtList.Referral_Organization__c, rTList);
            
            kidDupeCount = kidDupeCount+1;
            profDupeCount = profDupeCount+1;
            countProfessionals.add(rtList.Referral_Received_From__c);
            CountDupeOrgs.put(rtList.Referral_Received_From__c, rtList.Referral_Organization__c);
            countKids.add(rtList.Child_Referred__c);
            countOrgs.put( rtList.Referral_Received_From__c, rtList.Referral_Organization__c );  
            
        }
        OrgCount =OrgCount+1;
        if (countOrgs.keySet()!=Null){
            for ( String c: countOrgs.keySet()){
                
            }
            
        }
        System.debug('countOrgs.keySet()' + countOrgs.keySet());
        System.debug('rTs= ' + Referrals.size()); 
        System.debug('rTs= ' + Referrals);
        return filteredReferrals;   
    }  
    
    /* Use Filtered ReferralList to create all Sets to get totals */
    
    public Integer getTotalUndupeP() {
        Integer Undupe =0;
        for (String p: countProfessionals){
            Undupe = Undupe +1;
        }
        return Undupe;
        
    }
    
    public Integer getTotalUndupeK() {
        Integer Undupe =0;
        for (String p: countKids){
            Undupe = Undupe +1;
        }
        return Undupe;
        
    }
    
    public List<Case> getDupeOrgCats() {
        List<Case> filteredInteractions = new List <Case>();
        
        // This will be All interactions for the professional Org- Not just referrals
        
        List <Case> OrgTypes = [SELECT ID, ContactID, AccountID, Account.Name, Family__Child__r.Birthdate,
                                HMG_OBO_CBO__c, HMG_OBO_ChildCare__c, HMG_OBO_FRC__c, Start_Time__c,
                                HMG_OBO_HealthCare__c, HMG_OBO_Mental_Health__c, 
                                HMG_OBO_Other__c, HMG_OBO_PArt_C__c, HMG_OBO_Social_Services__c
                                FROM Case
                                WHERE ContactID IN :countDupeOrgs.keySet()
                                And Start_Time__c >= :dateFrom AND Start_Time__c <= :dateTo
                               ];
        
        System.debug('Dupe OrgTypes' + OrgTypes.size());
        CBO =0;
        childCare =0;
        FRC =0;
        health = 0;
        mental = 0;
        c = 0;
        social = 0;
        other = 0;
        intTotals = 0;
        
        for (Case p: OrgTypes){
            if (selector == 'IA' && p.Family__Child__r.Birthdate!=NULL){
                Integer age = p.Family__Child__r.Birthdate.monthsBetween(dateTo);
                System.debug('######## again months= ' + age);
                Boolean monthsBetween = false;
                
                if(age <72){
                    //monthsBetween = p.Family__Child__r.Birthdate.monthsBetween(dateTo) <72){
                    filteredInteractions.add(p);
                } else {
                    //dont need that kid
                }
                
            } else if (p.Family__Child__r.Birthdate!=NULL) {
                filteredInteractions.add(p);
            } else{
                
            }
        }
        
        for (case p: filteredInteractions ) { 
            intTotals = intTotals +1;
            if(p.HMG_OBO_CBO__c==True){
                CBO = CBO +1;
            } else if (p.HMG_OBO_ChildCare__c==True ){
                childCare = childCare +1;
            } else if(p.HMG_OBO_FRC__c==True){
                FRC = FRC +1;
            } else if (p.HMG_OBO_HealthCare__c==True){
                health = health +1;    
            } else if (p.HMG_OBO_Mental_Health__c==True){
                mental = mental +1;
            } else if (p.HMG_OBO_PArt_C__c == True){
                c = c +1;
            } else if (p.HMG_OBO_Social_Services__c== True){
                social = social +1;
            } else 
                other = other + 1;
        }
        
        return filteredInteractions;
        
    }
    
    /**
* Unduplicated Agency
* */
    
    public List<Case> getOrgCats() {
        List<Case> filteredInteractions = new List <Case>();
        // Better to Query On contact. Put checkboxes on Org
        Set <String> cboS = new Set <String>();
        Set <String> chS = new Set <String>();
        Set <String> frcS = new Set <String>();
        Set <String> hS = new Set <String>();
        Set <String> mhS = new Set <String>();
        Set <String> cS = new Set <String>();
        Set <String> socS = new Set <String>();
        Set <String> otS = new Set <String>();
        Set <String> totProfS = new Set <String>();
        // Map<String, Case> DedupedOrgs = new Map<String, Case>();
        
        // This will be All interactions for the ContactID that are OBO in time frame- Not just referrals
        //  But not good as prof might change orgs
        List <Case> OrgTypes = [SELECT ID, ContactID, AccountID, Account.Name,Family__Child__r.Birthdate,
                                HMG_OBO_CBO__c, HMG_OBO_ChildCare__c, HMG_OBO_FRC__c, Start_Time__c,
                                HMG_OBO_HealthCare__c, HMG_OBO_Mental_Health__c, 
                                HMG_OBO_Other__c, HMG_OBO_PArt_C__c, HMG_OBO_Social_Services__c
                                FROM Case
                                WHERE ContactID IN :countOrgs.keySet()
                                AND (Family__Child__c !=NULL OR On_behalf_of__c=true)
                                And Start_Time__c >= :DateFrom AND Start_Time__c <= :dateTo];
        
        
        
        // count each ORG contact ID and how many disctinct contacts here are
        
        System.debug('Deduped OrgTypes' + OrgTypes.size());
        CBOUn = 0;
        childCareUn =0;
        FRCUn =0;
        healthUn = 0;
        mentalUn = 0;
        cUn = 0;
        socialUn = 0;
        otherUn = 0;
        sizeUn=0;
        for (Case p: OrgTypes){
            if (selector == 'IA' && p.Family__Child__r.Birthdate!=NULL){
                Integer age = p.Family__Child__r.Birthdate.monthsBetween(dateTo);
                System.debug('######## again months= ' + age);
                Boolean monthsBetween = false;
                
                if(age <72){
                    //monthsBetween = p.Family__Child__r.Birthdate.monthsBetween(dateTo) <72){
                    filteredInteractions.add(p);
                } else {
                    //dont need that kid
                }
                
            } else if (p.Family__Child__r.Birthdate!=NULL) {
                filteredInteractions.add(p);
            } else{
                
            }
        }
        
        for (case p: filteredInteractions ) {      
            totProfS.add(p.ContactId);
            System.debug('deduped Org entry');
            if(p.HMG_OBO_CBO__c==True){
                cboS.add(p.ContactId);
            } else if (p.HMG_OBO_ChildCare__c==True ){
                chS.add(p.ContactId);
            } else if(p.HMG_OBO_FRC__c==True){
                frcS.add(p.ContactId);
            } else if (p.HMG_OBO_HealthCare__c==True){
                hS.add(p.ContactId);   
            } else if (p.HMG_OBO_Mental_Health__c==True){
                mhS.add(p.ContactId);
            } else if (p.HMG_OBO_PArt_C__c == True){
                cS.add(p.ContactId);
            } else if (p.HMG_OBO_Social_Services__c== True){
                socS.add(p.ContactId);
            } else 
                otS.add(p.ContactId);
        }
        CBOUn = cboS.size();
        childCareUn = chS.size();
        FRCUn = frcS.size();
        healthUn = hS.size();
        mentalUn = mhS.size();
        cUn = cS.size();
        socialUn = socS.size();
        otherUn = otS.size();
        sizeUn = totProfS.size();
        return filteredInteractions;
        
    }
    
    /******************
* FRC Dashboards
* *********************/
    
    public List<ReferralTracking__c> getGenerateFRCs() {
       // list<ReferralTracking__c> findReferralPermissions = new List <ReferralTracking__c>();
       // List <ReferralTracking__c>  UpsertReferralsList = new List <ReferralTracking__c>();
        
        User usr1 = new USER();
        usr1 = [SELECT Id FROM User WHERE Id = : UserInfo.getUserId()];
        
        Map <String, List<ReferralTracking__c>> allNewReferralActions = new  Map <String, List<ReferralTracking__c>>();
        Map <String, ReferralTracking__c> existingKeys = new Map <String, ReferralTracking__c>();
        List<ReferralTracking__c> Referrals = [SELECT Id, Name, Key__c, Referral_Received_From__c, Child_Referred__c,  Assigned_To__c, Household_Referred__c,
                                               Referral_Action__c, ActionUpdateReference__c, Permission_Received__c, Referral_Received_From__r.AccountID,
                                               Permission_Date__c, Referral_Organization__c, ActionReference__c, LM1_IntID__c, LM2_IntID__c,
                                               Cbx_Referral_Received__c, CbxReferral_Confirmed__c, CbxContact_Confirmation_Sent__c, CbxReferral_Update__c, 
                                               UTC_Professional_Notify__c, InteractionReference__c, CompletedCGSucess__c, Completed_Prof_Notification__c, 
                                               Track_Complete__c, Household_Referred__r.First_Intake__c, Household_Referred__r.Last_Intake__c,  
                                               Household_Referred__r.Owner.Name, Household_Referred__r.OwnerId, Household_Referred__r.Household_SW__c,
                                               Household_Referred__r.Household_SW__r.Name, Household_Referred__r.Household_SW__r.Id, 
                                               Household_Referred__r.Household_SFIN_Coach__c, Household_Referred__r.Household_SFIN_Coach__r.Id, 
                                               Household_Referred__r.Household_SFIN_Coach__r.Name, Child_Referred__r.Owner.Name, Child_Referred__r.OwnerId,
                                               Date_Referral_Received__c, date_Contact_Conf_Sent__c, date_Contact_Confirmation_Sent__c,  Date_On_Referral_Form__c,
                                               date_Intake__c, date_Left_Message_1__c, date_Left_Message_2__c, date_One_Month_Followup__c, 
                                               date_One_Week_Followup__c, date_Referral_Confirmed__c, date_Sent_UTC__c, date_TYSent__c, date_Two_Week_Followup__c, 
                                               date_UTC_to_Prof__c, date_Update_Sent__c, date_Update__c, one_Month_Caregiver__c, one_Month_Origin__c, x1lastInteractionDate__c, 
                                               x2lastInteractionDate__c, x3lastInteractionDate__c, x5lastInteractionDate__c, x6lastInteractionDate__c, x4lastInteractionDate__c, 
                                               Initial_Interaction_Date__c 
                                               FROM ReferralTracking__c
                                               WHERE ((Initial_Interaction_Date__c >= :DateFrom AND Initial_Interaction_Date__c <= :dateTo)
                                                      OR (Date_Referral_Received__c >= :DateFrom AND Date_Referral_Received__c <= :dateTo)
                                                      OR (Date_TYSent__c >= :DateFrom AND Date_TYSent__c <= :dateTo))
                                               AND (
                                                    Household_Referred__r.OwnerId =: usr1.Id
                                                    OR Household_Referred__r.Household_SFIN_Coach__r.Id =: usr1.Id)
                                                  //  OR Household_Referred__r.Household_SW__c =: usr1.Id)
                                               ORDER BY Household_Referred__r.Owner.Name Desc];
        
        for (ReferralTracking__c rtList : Referrals) { 
            ReferralProf.put(rtList.Referral_Received_From__c, rTList); 
            ReferralChild.put(rtList.Child_Referred__c, rTList);
            
            findChildPermissions.put(rtList.Child_Referred__c, rTList);
            findOrgPermissions.put(rtList.Referral_Organization__c, rTList);
        }
        System.debug('rTs= ' + Referrals.size()); 
        System.debug('rTs= ' + Referrals);
        return Referrals;   
    }  
    //Get Contacts With Open Issues 
    //Caller_Name__r.First_Intake__c, 
    
    public List<Issue__c> getOpenIssues() {
        User usr1 = new USER();
        usr1 = [SELECT Id FROM User WHERE Id = : UserInfo.getUserId()];
        List<Issue__c> openIss = new List <Issue__c>();
        List<Issue__c> Issues=  [SELECT Id,  Name ,  Caller_Name__c , Status__c , Opened_Date__c , Issue_Contact__r.Id,
                                 Issue_Contact__r.npo02__Household__r.OwnerID, Issue_Contact__r.npo02__Household__r.Owner.Alias,
                                 Issue_Contact__c , Type_of_Issue__c , Issue_Contact__r.npo02__Household__c, Issue_Contact__r.OwnerID,
                                 Issue_Contact__r.Owner.Alias, Caller_Name__R.Account.Name, Caller_Name__R.Name,
                                 Issue_Contact__r.First_Interaction__c,   Issue_Contact__r.Last_Interaction_Date__c, 
                                 Issue_Contact__r.npo02__Household__r.Name, Issue_Contact__r.npo02__Household__r.Last_Intake__c,
                                 Issue_Contact__r.npo02__Household__r.Most_Recent_Household_Interaction__c,
                                 Issue_Contact__r.npo02__Household__r.First_Interaction__c,  Issue_Contact__r.npo02__Household__r.First_Intake__c, 
                                 Issue_Contact__r.npo02__Household__r.Owner.Name,  Issue_Contact__r.npo02__Household__r.Household_SW__r.Name
                                 FROM Issue__c
                                 WHERE (Opened_Date__c  >= :dateFrom AND Opened_Date__c <= :dateTo)
                                 AND Status__c !='Closed'
                                 //AND Status__c !='Archived'
                                 AND (
                                      Issue_Contact__r.npo02__Household__r.OwnerID =: usr1.Id
                                      OR Issue_Contact__r.npo02__Household__r.Household_SW__r.ID =: usr1.Id
                                      OR Issue_Contact__r.npo02__Household__r.Household_SFIN_Coach__r.ID =: usr1.Id
                                     )
                                ];
        //Add Contcats with Open Issues into Maps
        for(Issue__c i: Issues){
            // System.debug('Issue Contact= ' + i.Issue_Contact__c);
            // System.debug('Issue Caller_Name__c= ' + i.Caller_Name__c);
            /*  for(Related_Issue__c r : i.Related_Issues__r){
System.debug('CaseOwner= ' + r.Case__r.Owner.ID );
usersMap.put(r.Case__r.Owner.ID, r.Case__r.Owner.ID );
} */
            issueMapCon.put(i.Issue_Contact__r.Id, i);
        }
        return Issues;
    }
    
    public List<contact>  getContactsOpenIssues(){
        User usr1 = new USER();
        usr1 = [SELECT Id FROM User WHERE Id = : UserInfo.getUserId()];
        
        List<Contact> cons =[SELECT Id, npo02__Household__r.Most_Recent_Household_Interaction__c, recordType.name, Contact_Social_Worker__r.Name, 
                             Contact_Social_Worker__r.Id, npo02__Household__r.Household_SFIN_Coach__r.Id, 
                             npo02__Household__r.First_Interaction__c, npo02__Household__r.Owner.Alias,
                             npo02__Household__r.Last_Intake__c, npo02__Household__r.First_Intake__c, Last_Interaction_Date__c,Owner.alias,
                             OwnerID, First_Interaction__c, FirstName, LastName, npo02__Household__c, Name,Owner.Name,
                             npo02__Household__r.NeedIntake_Survey__c, npo02__Household__r.Most_Recent_Intake_Survey__c,
                             npo02__Household__r.Household_SW__r.Name, npo02__Household__r.owner.Name, npo02__Household__r.Household_SW__r.ID, 
                             npo02__Household__r.Most_Recent_HH_Interaction_Call_Type__c, npo02__Household__r.First_Family_Assessment__c,
                             npo02__Household__r.Most_Recent_SW_HH_Interaction__c, npo02__Household__r.First_SW_HH_Interaction__c,
                             npo02__Household__r.Most_Recent_Family_Assessment__c, npo02__Household__r.First_Intake_Survey__c 
                             FROM Contact
                             WHERE (npo02__Household__r.OwnerID =: usr1.Id
                                    OR npo02__Household__r.Household_SW__r.ID =: usr1.Id
                                   )
                             AND  ID IN: issueMapCon.keyset() ];
        
        return Cons;
    }
    
    public  Void getReferralCase(){
        List<Case> firstCase = [SELECT ID, ContactID, Family__Child__c, Start_Time__c
                                FROM CASE
                                WHERE Family__Child__c IN :ReferralChild.keySet()
                                AND ContactID IN :ReferralProf.keySet()
                                Order By Start_Time__c Desc
                                Limit 1];
        
        
    }
}