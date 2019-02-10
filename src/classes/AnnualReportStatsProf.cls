public class AnnualReportStatsProf {
    
    // Winter17  sandbox: 2/19/2017
    
    // *******************************************************
    
    
    // *******************************************************
    
    
    // Add Date From to VF
    public Date dateFrom {get; set;}
   // public Date FYB {get; set;}
    
    // Date To
    public Date dateTo {get; set;}
    
    //public Date priorMonthEnd;
    public Date Q1Ends;
    public Date Q2Ends; 
    public Date Q3Ends; 
    public Date Q4Ends; 
    public Date PriorQuarterEnds;
    
    public Integer FYBSelected;
    Public Integer FYBSecond;
    
    // SetConMaster collects all the contacts for current Quarter
    private Set<String> setConMasterCG = new Set<String>();
    private Set<String> setConMasterHH = new Set<String>();
    private Set<String> setConMasterProf = new Set<String>();
    private Set<String> setConMasterChild = new Set<String>();
    
    
    private Set<String> setConIntCG = new Set<String>();
    private Set<String> setConIntHH = new Set<String>();
    private Set<String> setConIntChild = new Set<String>();
    private Set<String> setConIntOboHH = new Set<String>();
    private Set<String> setConIntPMP = new Set<String>();
    private Set<String> setConIntProf = new Set<String>();
    
    private Set<String> setConCampCG = new Set<String>();
    private Set<String> setConCampHH = new Set<String>();
    private Set<String> setConCampChild = new Set<String>();
    private Set<String> setConCampProf = new Set<String>();
    
    private Map<ID,ID> espKidHH  =  new Map<ID,ID>();
    Private String pmpVar ='PMP' + '%';
    
    
    
    public AnnualReportStatsProf(){
        
        
        
    }
    
    // start board generation
    public PageReference startGenerateBoard() {
        
        
        if (dateFrom != null && dateTo != null) {
            if (dateTo >= dateFrom) {
                //Generate after declare
                generateBoard();
                
            } else {
                // display custom page message
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Date To must be greater than or equal to Date From!');
                ApexPages.addMessage(myMsg);
            }
        } else {
            // display custom page message
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You must select a Date From and a Date To!');
            ApexPages.addMessage(myMsg);
        }
        return null;
    }
    
    
    
    // generate the dashboard
    private void generateBoard() {
     /*   // TagContacts(); 
        FYBSelected = (Integer.valueof(DateFrom.year()));
        FYBSecond = (Integer.valueof(DateFrom.year() + 1));
        Q1Ends = date.newInstance(FYBSelected, 9, 30 );
        Q2Ends = date.newInstance(FYBSelected, 12, 31 );
        Q3Ends = date.newInstance(FYBSecond, 3, 31 );
        Q4Ends = date.newInstance(FYBSecond, 6, 30 );
        System.debug('Q1Ends= ' +  Q1Ends + ' Q2Ends= ' + Q2Ends + ' Q3Ends= ' + Q3Ends + ' Q4Ends= ' + Q4Ends );
        If (dateTo <= Q1Ends){
            PriorQuarterEnds = DateFrom;
        }Else{
            If (dateTo <= Q2Ends){
                PriorQuarterEnds = Q1Ends;
            }Else{
                If (dateTo <= Q3Ends){
                    PriorQuarterEnds = Q2Ends; 
                }Else{
                    PriorQuarterEnds = Q3Ends;
                }   
            } 
        }
        System.debug('priorquarterEnds= ' + PriorQuarterEnds);*/
        // runBoard();
        // AnnualReportCls();
        InitializeBoard();
        TagContacts();
    }
    private void InitializeBoard() { 
        
        setConMasterProf.clear();
        setConIntOboHH.clear();
        setConIntProf.clear();
        setConCampProf.clear();
     
    }
    
    private void TagContacts() {   
        
        //Get All Households And
        // MAke workflow to tag, Or formula or custom metadatatype
        // Run rollups by recordtype to get kids and adults and family members
        // Seperate Master and Object specific sets for CareGivers, Households, Professionals and Children
        
        List<campaignMember> limitCurContactEvents =[SELECT contactID, Status
                                                     FROM campaignMember
                                                     WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                     ////And AgeMonthsAtCampaign__c>=0 AND AgeMonthsAtCampaign__c <=35
                                                     //AND AgeMonthsAtCampaign__c !=NULL
                                                     AND contact.name !='Neale'
                                                     AND contact.name !='test'
                                                     AND No_Show__c = false
                                                     AND Status = 'Professional Attendee'  
                                                     AND (campaign.Type = 'Clinic' 
                                                          OR campaign.Type = 'Conference'
                                                          //OR campaign.Type = 'Family Event'
                                                          OR campaign.Type = 'IRC Conference'
                                                          OR campaign.Type = 'IRC Workshop'
                                                          OR campaign.Type = 'Mini-Tech Lab'
                                                          OR campaign.Type = 'Outreach'
                                                          OR campaign.Type = 'Parent Panel'
                                                          OR campaign.Type = 'Parent Team'
                                                          OR campaign.Type = 'PMP Training'
                                                          OR campaign.Type = 'PPW'
                                                          OR campaign.Type = 'Workshop'
                                                          OR campaign.Type LIKE '%Playgroup%')
                                                     AND (NOT campaign.Name Like '%Childcare%')
                                                     AND (NOT campaign.Name Like '%Cancelled%')
                                                     AND (NOT campaign.Name Like '%No Show%')
                                                     AND (NOT campaign.Name Like '%Postponed%')
                                                     
                                                    ];
        
        for(campaignMember cm: limitCurContactEvents){
            
            setConCampProf.add(cm.contactID); 
            setConMasterProf.add(cm.contactID);            
        }
        
        //Prof Interactions
        List<case> limitProfInteractions =[SELECT ContactID, contact.recordTypeID, Family__Household__c, Child_Person_with_Disability_ID__c
                                           FROM case
                                           WHERE start_time__c > :dateFrom AND start_time__c <= :dateTo
                                           // And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <=5
                                           //AND AgeMonthCaseTime__c !=NULL
                                           AND Call_Type__c != 'Left Message 1'
                                           AND Call_Type__c != 'Left Message 2'
                                           AND Call_Type__c != '# disconnected'
                                           AND Call_Type__c != 'No answering machine'
                                           AND Call_Type__c != 'Sent UTC Letter'        
                                           AND On_behalf_of__c = FALSE
                                           AND Child_Person_with_Disability_ID__c =NULL
                                           AND contact.name !='Neale'
                                           AND contact.name !='test'
                                           AND RecordTypeID != '012G0000000qhDK' 
                                           AND (NOT Call_Type__c LIKE:pmpVar) ];
        
        for(case c: limitProfInteractions){
            setConMasterProf.add(c.ContactID); 
            setConIntProf.add(c.ContactID); 
            
            
        }
        
        System.debug('setConMasterProf Size =  ' + setConMasterProf.size());
    }
    
    /*******************************************************************
* Generate output begins
*******************************************************************/
    
    public List<arWrapperX> getGenerateOrgProfessionals() {
        
        // get count Language
        list<arWrapperX> LanguagePQueryTotals = new List <arWrapperX>();
        List<AggregateResult> LanguagePAggregateResult = 
            [select  Account.name aa, Count_Distinct (ID) bb, Count(accountID) cc
             From contact
             WHERE ID IN: setConMasterProf 
             group by Rollup (Account.name) ];
        //System.debug(setConMasterHH.size());
        
        String NewName ='';
        for (AggregateResult arList : LanguagePAggregateResult) { 
            If(String.valueOf(arList.get('aa'))==NULL){
                NewName ='Total'; 
            } ELSE{
                
                NewName = (String.valueOf(arList.get('aa')));    
            }
 
            LanguagePQueryTotals.add(new arWrapperX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));     
        }
        return LanguagePQueryTotals;
    }   
    
     public List<arWrapperX> getGenerateAllProfessionals() {
        
        // get count Language
        list<arWrapperX> LanguagePQueryTotals = new List <arWrapperX>();
        List<AggregateResult> LanguagePAggregateResult = 
            [select  Family__Primary_Language__c aa, Count_Distinct (ID) bb, Count(accountID) cc
             From contact
             WHERE ID IN: setConMasterProf 
             group by Rollup (Family__Primary_Language__c) ];
        //System.debug(setConMasterHH.size());
        
        String NewName ='';
        for (AggregateResult arList : LanguagePAggregateResult) { 
            If(String.valueOf(arList.get('aa'))==NULL){
                NewName ='Total'; 
            } ELSE{
                
                NewName = (String.valueOf(arList.get('aa')));    
            }
 
            LanguagePQueryTotals.add(new arWrapperX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));     
        }
        return LanguagePQueryTotals;
    }   
    
     public List<arWrapperX> getGenerateProIntTotals() {
        
        // get count Language 
        list<arWrapperX> LanguagePQueryTotals = new List <arWrapperX>();
        List<AggregateResult> LanguagePAggregateResult = 
            [select  Family__Primary_Language__c aa, Count_Distinct (ID) bb                 
             From contact
             WHERE ID IN: setConIntProf 
             group by Rollup (Family__Primary_Language__c) ];
      
        
        String NewName ='';
        for (AggregateResult arList : LanguagePAggregateResult) { 
            If(String.valueOf(arList.get('aa'))==NULL){
                NewName ='Total'; 
            } ELSE{
                NewName = (String.valueOf(arList.get('aa')));  
                
            }
            
            
            
            LanguagePQueryTotals.add(new arWrapperX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));     
        }
        return LanguagePQueryTotals;
    }   
    
    public List<arWrapperX> getGenerateProEvents() {
        
        // get count Language
        list<arWrapperX> LanguagePQueryTotals = new List <arWrapperX>();
        List<AggregateResult> LanguagePAggregateResult = 
            [select  campaign.Type aa, Count_Distinct (ContactID) bb             
             FROM campaignMember
             WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
             
             AND contact.name !='Neale'
             AND contact.name !='test'
             AND No_Show__c = false
             AND Status = 'Professional Attendee'  
             AND (campaign.Type = 'Clinic' 
                  OR campaign.Type = 'Conference'
                  OR campaign.Type = 'Family Event'
                  OR campaign.Type = 'IRC Conference'
                  OR campaign.Type = 'IRC Workshop'
                  OR campaign.Type = 'Mini-Tech Lab'
                  OR campaign.Type = 'Outreach'
                  OR campaign.Type = 'Parent Panel'
                  OR campaign.Type = 'Parent Team'
                  OR campaign.Type = 'PMP Training'
                  OR campaign.Type = 'PPW'
                  OR campaign.Type = 'Workshop'
                  OR campaign.Type LIKE '%Playgroup%')
             AND (NOT campaign.Name Like '%Childcare%')
             AND (NOT campaign.Name Like '%Cancelled%')
             AND (NOT campaign.Name Like '%No Show%')
             AND (NOT campaign.Name Like '%Postponed%')
             group by Rollup (campaign.Type) ];
       
        String NewName ='';
        for (AggregateResult arList : LanguagePAggregateResult) { 
            If(String.valueOf(arList.get('aa'))==NULL){
                NewName ='Total'; 
            } ELSE{
                NewName = (String.valueOf(arList.get('aa')));  
                
            }
            
            
            LanguagePQueryTotals.add(new arWrapperX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));     
        }
        return LanguagePQueryTotals;
    }   
    
     public List<arWrapperX> getGenerateProEduCampTotals() {
        
        // get count Language 
        list<arWrapperX> LanguagePQueryTotals = new List <arWrapperX>();
        List<AggregateResult> LanguagePAggregateResult = 
            [select  Family__Primary_Language__c aa, Count_Distinct (ID) bb                 
             From contact
             WHERE ID IN: setConCampProf 
             group by Rollup (Family__Primary_Language__c) ];
      
        
        String NewName ='';
        for (AggregateResult arList : LanguagePAggregateResult) { 
            If(String.valueOf(arList.get('aa'))==NULL){
                NewName ='Total'; 
            } ELSE{
                NewName = (String.valueOf(arList.get('aa')));  
                
            }
            
            
            
            LanguagePQueryTotals.add(new arWrapperX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));     
        }
        return LanguagePQueryTotals;
    }   
    
    
    
    /*******************************************************************
* Wrapper 
*******************************************************************/
    
    
    public class arWrapperX {
        
        public String a1 {get; set;}
        public Integer C1 {get; set;}
        
        
        public arWrapperX(String str, Integer num){
            a1 =str;
            C1=num;
            
        }
    }
}