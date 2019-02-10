public class ReferralTrackingCheckout {

    // 10-22_18 ReferralTr - Novo
 
    public Date dateFrom {get; set;}
    public Date dateTo {get; set;}
    public List<SelectOption> pickUsers { get; set; }
    
    public Id pickUser { get; set; }
    public Date Q1Ends;
    public Date Q2Ends; 
    public Date Q3Ends; 
    public Date Q4Ends; 
    public Date PriorQuarterEnds;
    public Integer FYBSelected;
    public Integer FYBSecond;
    public Id usr { get; set; }
    public String searchString {get;set;}
    public List <ReferralTracking__c>  soqlToExecute {get;set;}
    public list <Issue__c> issuesToExecute {get;set;}
    
    public Map<String, Issue__c> issueMapCon = new Map <String, Issue__c>();
    private Map <String, ReferralTracking__c> ReferralProf = new  Map <String, ReferralTracking__c>();
    private Map <String, ReferralTracking__c> ReferralChild = new  Map <String, ReferralTracking__c>();
    private Map <String, ReferralTracking__c>  findChildPermissions = new Map <String, ReferralTracking__c> ();
    private Map <String, ReferralTracking__c> findOrgPermissions = new Map <String, ReferralTracking__c> ();
    private String pmpVar ='PMP' + '%';
    private Set <String> filteredIds = new Set <String>();
    
    
    public ReferralTrackingCheckout(){
        searchString='';
        doQuery();
        date DefaultDateTo = system.today();
        date defaultDateFrom = system.today().addDays(-90);
        dateTo = defaultDateTo;
        dateFrom = defaultDateFrom;
       // this.usr = [SELECT Id FROM User WHERE Id = : UserInfo.getUserId()];
    }
    
    public PageReference startGenerateBoard() {
        if (dateFrom != null && dateTo != null) {
            if (dateTo >= dateFrom) {
                generateBoard();
               // runFRSboard();
                getGenerateRTs();
                                getOpenIssues();
   
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
    
   /* public voide runFRSBoard() {
        getUser();
        setUser();
       // return usr.Id;
       
        
    }*/
    
    private void generateBoard() {
        FYBSelected = (Integer.valueof(DateFrom.year()));
        FYBSecond = (Integer.valueof(DateFrom.year() + 1));
        Q1Ends = date.newInstance(FYBSelected, 9, 30 );
        Q2Ends = date.newInstance(FYBSelected, 12, 31 );
        Q3Ends = date.newInstance(FYBSecond, 3, 31 );
        Q4Ends = date.newInstance(FYBSecond, 6, 30 );
        System.debug('Q1Ends= ' +  Q1Ends + ' Q2Ends= ' + Q2Ends + ' Q3Ends= ' + Q3Ends + ' Q4Ends= ' + Q4Ends );
            
    }
    
    public List<SelectOption> getpickU() {
        List<SelectOption> staff = new List<SelectOption>();
       // pickUsers.add(new System.SelectOption('-- Select FRS / SW--', '-- Select FRS / SW--'));

        for (User users : [SELECT Id, Name FROM User 
                           WHERE  user.IsActive = True 
                           AND (UserRole.Name = 'SFCD Family Resource' OR IncludeInFRSDashBoard__c=true)
                           ORDER BY Name])
            staff.add(new SelectOption(users.Id, users.Name)); 
        return staff;
    }
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('All','All'));
        options.add(new SelectOption('IA','IA'));
        return options;
    }

    
    public Id getUser() {
        //system.debug('pickUser ' + pickUser)
        return usr;
    }
    
    public void setUser(Id u) {
        system.debug('u ' + u);
        this.usr= u;
        
    }  
    
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
          
                filteredReferrals.add(c);
                   
        }

        for (ReferralTracking__c rtList : filteredReferrals) { 
            filteredIds.add(rtList.ID);
           
        }
               return filteredReferrals;   
    }  
    
/******************
 * FRC Dashboards
 ******************/
    
    public List<ReferralTracking__c> getGenerateFRCs() {

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
                                                   Household_Referred__r.OwnerId =: usr
                                                   OR Household_Referred__r.Household_SFIN_Coach__r.Id =: usr)
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
  
    public List<Issue__c> getOpenIssues() {
       
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
                                     Issue_Contact__r.npo02__Household__r.OwnerID =: usr
                                     OR Issue_Contact__r.npo02__Household__r.Household_SW__r.ID =: usr
                                     OR Issue_Contact__r.npo02__Household__r.Household_SFIN_Coach__r.ID =: usr
                                 )
                                ];
        for(Issue__c i: Issues){
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
                             WHERE (npo02__Household__r.OwnerID =: usr
                                    OR npo02__Household__r.Household_SW__r.ID =: usr
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