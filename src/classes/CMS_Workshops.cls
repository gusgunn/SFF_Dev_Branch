public class CMS_Workshops {
    
    //12-5-17
    //SFCD November SB
    //Changed ES6 to ES4C Case/Feldman 
    //Changed ES7 to ES6 (PMP)

    
    
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
    private Set<String> setConMaster = new Set<String>();
    Private String pmpVar ='PMP' + '%';
    public integer es4UndupeFY =0;
    public integer es4KUndupeFY =0;
    public integer es6UndupeFY =0;
    public integer es7UndupeFY =0;
    
    
    
    public CMS_Workshops(){
        setConMaster.clear();
        Date DefaultDateTo = date.newinstance(2017, 12, 31);
        Date DefaultDateFrom = date.newinstance(2017, 7, 1);
        DateTo=DefaultDateTo;
        DateFrom = DefaultDateFrom;
        
        
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
    
    // set dashboard values to zero in preparation for generation
    private void runBoard() {
        //clearTags()
        getGenerateES4Undupe();
        getGenerateES4kUndupe();
        getGenerateES6Undupe();
        getGenerateES7Undupe();
        
        // TODO: initialize controller values to zero
        //Test getTagContacts   
    }
    
    // generate the dashboard
    private void generateBoard() {
        
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
        System.debug('priorquarterEnds= ' + PriorQuarterEnds);
        runBoard();
        
    }
    /*********************/
    //Get prior undup
    
    private  void getGenerateES4Undupe() {
        set<String> PriorContactCount = new set <String>();
        List <campaignmember> PriorContacts = [SELECT   contact.ID              
                                               FROM campaignmember
                                               WHERE Event_Date__c >= :dateFrom  AND Event_Date__c <= :PriorQuarterEnds
                                               AND No_Show__c = false
                                               AND Status = 'Family Attendee'
                                               AND (campaign.status = 'Completed' OR campaign.status = 'Data In Except Survey' )
                                               AND (NOT campaign.Name Like '%Childcare%')
                                               AND (NOT campaign.Name Like '%Cancelled%')
                                               AND (NOT campaign.Name Like '%No Show%')
                                               AND (NOT campaign.Name Like '%Postponed%')
                                               AND campaign.Project_or_Funder__c INCLUDES ('Family Support')
                                               AND campaign.CMSName__c ='ES4'
                                               // GROUP BY rollup(campaign.CMSQ__c)
                                              ]; 
        
        for (campaignmember c : PriorContacts) {
            PriorContactCount.add(c.contact.id);
            
        } 
        es4UndupeFY = PriorContactCount.size();
        
        
    }   
    
    private  void getGenerateES6Undupe() {
        set<String> PriorContactCount = new set <String>();
        List <campaignmember> PriorContacts = [SELECT   contact.ID              
                                               FROM campaignmember
                                               WHERE Event_Date__c >= :dateFrom  AND Event_Date__c <= :PriorQuarterEnds
                                               AND No_Show__c = false
                                               AND Status = 'Family Attendee'
                                               AND (campaign.status = 'Completed' OR campaign.status = 'Data In Except Survey' )
                                               AND (NOT campaign.Name Like '%Childcare%')
                                               AND (NOT campaign.Name Like '%Cancelled%')
                                               AND (NOT campaign.Name Like '%No Show%')
                                               AND (NOT campaign.Name Like '%Postponed%')
                                               AND campaign.Project_or_Funder__c INCLUDES ('Family Support')
                                               AND campaign.CMSName__c ='ES4C'
                                               // GROUP BY rollup(campaign.CMSQ__c)
                                              ]; 
        
        for (campaignmember c : PriorContacts) {
            PriorContactCount.add(c.contact.id);
            
        } 
        es6UndupeFY = PriorContactCount.size();   
        
    }   
    private  void getGenerateES7Undupe() {
        set<String> PriorContactCount = new set <String>();
        List <campaignmember> PriorContacts = [SELECT   contact.ID              
                                               FROM campaignmember
                                               WHERE Event_Date__c >= :dateFrom  AND Event_Date__c <= :PriorQuarterEnds
                                               AND No_Show__c = false
                                               AND Status = 'Family Attendee'
                                               AND (campaign.status = 'Completed' OR campaign.status = 'Data In Except Survey' )
                                               AND (NOT campaign.Name Like '%Childcare%')
                                               AND (NOT campaign.Name Like '%Cancelled%')
                                               AND (NOT campaign.Name Like '%No Show%')
                                               AND (NOT campaign.Name Like '%Postponed%')
                                               AND campaign.Project_or_Funder__c INCLUDES ('Family Support')
                                               AND campaign.CMSName__c ='ES6'
                                               // GROUP BY rollup(campaign.CMSQ__c)
                                              ]; 
        
        for (campaignmember c : PriorContacts) {
            PriorContactCount.add(c.contact.id);
            
        } 
        es7UndupeFY = PriorContactCount.size();
        
        
    }   
    private  void getGenerateES4KUndupe() {
        set<String> PriorContactCount = new set <String>();
        List <campaignmember> PriorContacts = [SELECT   contact.ID              
                                               FROM campaignmember
                                               WHERE Event_Date__c >= :dateFrom  AND Event_Date__c <= :PriorQuarterEnds
                                               AND No_Show__c = false
                                               AND Status = 'Child Attendee'
                                               And AgeMonthsAtCampaign__c > 71
                                               And AgeMonthsAtCampaign__c < 216
                                               ANd AgeMonthsAtCampaign__c != NULL
                                               AND (campaign.status = 'Completed' OR campaign.status = 'Data In Except Survey' )
                                               AND (NOT campaign.Name Like '%Childcare%')
                                               AND (NOT campaign.Name Like '%Cancelled%')
                                               AND (NOT campaign.Name Like '%No Show%')
                                               AND (NOT campaign.Name Like '%Postponed%')
                                               AND campaign.Project_or_Funder__c INCLUDES ('Family Support')
                                               AND campaign.CMSName__c ='ES4'
                                               // GROUP BY rollup(campaign.CMSQ__c)
                                              ]; 
        
        for (campaignmember c : PriorContacts) {
            PriorContactCount.add(c.contact.id);
            
        } 
        es4KUndupeFY = PriorContactCount.size();
        
        
    }   
    
    
    /*************************************
* generate ES set -use id string instead of ex_contact__c
******************************************/
    //ES4
    public List<CMSWrapper> getGenerateES4() {
        
        // get current count ES dateTo. Limit SetCon
        list<CMSWrapper> ESQueryTotals = new List <CMSWrapper>();
        List<AggregateResult> ESAggregateResult = [SELECT  campaign.CMSQ__c Qnames,  Count_Distinct(campaign.id) cmID, Count(contactId) DupeContactCNT ,
                                                   Count_Distinct(contactId) ContactCNT, Max(campaign.Campaign_Target__c) targC, 
                                                   Max(campaign.Duplicated_Target__c) targD, Max(campaign.Unduplicated_Target__c) targU                
                                                   FROM campaignmember
                                                   WHERE Event_Date__c >= :dateFrom  AND Event_Date__c <= :dateTo
                                                   AND No_Show__c = false
                                                   AND Status = 'Family Attendee'
                                                   AND (campaign.status = 'Completed' OR campaign.status = 'Data In Except Survey' )
                                                   AND (NOT campaign.Name Like '%Childcare%')
                                                   AND (NOT campaign.Name Like '%Cancelled%')
                                                   AND (NOT campaign.Name Like '%No Show%')
                                                   AND (NOT campaign.Name Like '%Postponed%')
                                                   AND campaign.Project_or_Funder__c INCLUDES ('Family Support')
                                                   AND campaign.CMSName__c ='ES4'
                                                   GROUP BY rollup(campaign.CMSQ__c)
                                                  ]; 
        System.Debug('*******************ESAggregateResult= '+ ESAggregateResult.size());
        String NewName ='';
        Integer NewTargC=0;
        Integer NewTargD=0;
        Integer NewTargU=0;
        Integer TotalTarg=0;
        Integer CurrentQ = ESAggregateResult.size()-1;
        Integer UnDupeAllTotal =0; //FORM Total  Row
        Integer UndupedQTotal =0;
        String UndupedFYResult ='N/A';
        
        System.debug('ESAggregateResult.size()  & QNAME = ' + ESAggregateResult.size() + 'Qnames');
        for (AggregateResult arList : ESAggregateResult) {
            
            
            If(String.valueOf(arList.get('Qnames'))==null){
                System.debug(currentQ + ' currentQ' + ' And c= ' + NewTargC + 'd= '+ NewTargD + 'u= '+ NewTargU );
                NewTargC =( CurrentQ *  (Integer.valueOf(arList.get('targC'))));  
                NewTargD =(CurrentQ * (Integer.valueOf(arList.get('targD'))));
                NewTargU =(CurrentQ * (Integer.valueOf(arList.get('targU'))));
                NewName ='Total'; 
                //TotalTarg =
                System.Debug('Unduplicated contacts total ' + Integer.valueOf(arList.get('ContactCNT')));
                UnDupeAllTotal = (Integer.valueOf(arList.get('ContactCNT')));
                System.Debug(' UnDupeAllTotal & es4UndupeFY  ' + UnDupeAllTotal +' ' + es4UndupeFY);
                UndupedQTotal =  UnDupeAllTotal - es4UndupeFY;
                System.Debug('UndupedQTotal ' + UndupedQTotal);
                UndupedFYResult = (String.valueOf(UndupedQTotal));
                System.debug(currentQ + ' currentQ   ' + '  c= ' + NewTargC + '  d= '+ NewTargD + '  u= '+ NewTargU );   
            }ELSE{
                NewName = (String.valueOf(arList.get('Qnames')));
                NewTargC =  (Integer.valueOf(arList.get('targC')));  
                NewTargD = (Integer.valueOf(arList.get('targD')));
                NewTargU = (Integer.valueOf(arList.get('targU')));   
            }
            
            
            ESQueryTotals.add(new CMSWrapper(String.valueOf(NewName), (Integer.valueOf(arList.get('cmID'))), 
                                             (Integer.valueOf(arList.get('DupeContactCNT'))),(Integer.valueOf(arList.get('ContactCNT'))), 
                                             Integer.valueOf(UndupedQTotal), String.valueOf(UndupedFYResult),
                                             String.valueOf(NewName), String.valueOf(NewName),
                                             Integer.valueOf(NewTargC), Integer.valueOf(NewTargD), Integer.valueOf(NewTargU)));  
            
        }
        System.debug('ES4= ' + ESQueryTotals.size()); 
        System.debug('ES4= ' + ESQueryTotals);
        return ESQueryTotals;
        
    } 
    
    
    // ES4 6 - 17
    public List<CMSWrapper> getGenerateES4Kids6() {
        
        // get current count ES dateTo. Limit SetCon
        list<CMSWrapper> ESQueryTotals = new List <CMSWrapper>();
        List<AggregateResult> ESAggregateResult = [SELECT  campaign.CMSQ__c Qnames,  Count_Distinct(campaign.id) cmID, Count(contactId) DupeContactCNT ,
                                                   Count_Distinct(contactId) ContactCNT, Max(campaign.Campaign_Target__c) targC, 
                                                   Max(campaign.Duplicated_Target__c) targD, Max(campaign.Unduplicated_Target__c) targU                
                                                   FROM campaignmember
                                                   WHERE Event_Date__c >= :dateFrom  AND Event_Date__c <= :dateTo
                                                   AND No_Show__c = false
                                                   AND Status = 'Child Attendee'
                                                   AND AgeMonthsAtCampaign__c < 216
                                                   AND AgeMonthsAtCampaign__c > 71
                                                   AND AgeMonthsAtCampaign__c != NULL
                                                   AND (campaign.status = 'Completed' OR campaign.status = 'Data In Except Survey' )
                                                   AND (NOT campaign.Name Like '%Childcare%')
                                                   AND (NOT campaign.Name Like '%Cancelled%')
                                                   AND (NOT campaign.Name Like '%No Show%')
                                                   AND (NOT campaign.Name Like '%Postponed%')
                                                   AND campaign.Project_or_Funder__c INCLUDES ('Family Support')
                                                   AND campaign.CMSName__c ='ES4'
                                                   GROUP BY rollup(campaign.CMSQ__c)
                                                  ]; 
        System.Debug('*******************ES4 6 - 17AggregateResult= '+ ESAggregateResult.size());
        String NewName ='';
        Integer NewTargC=0;
        Integer NewTargD=0;
        Integer NewTargU=0;
        Integer CurrentQ = ESAggregateResult.size()-1; Integer UnDupeAllTotal =0; //FORM Total  Row
        Integer UndupedQTotal =0;
        String UndupedFYResult ='N/A';
        
        System.debug('ESAggregateResult.size()  & QNAME = ' + ESAggregateResult.size() + 'Qnames');
        for (AggregateResult arList : ESAggregateResult) {
            
            
            If(String.valueOf(arList.get('Qnames'))==null){
                System.debug(currentQ + ' currentQ' + ' And c= ' + NewTargC + 'd= '+ NewTargD + 'u= '+ NewTargU );
                NewTargC =( CurrentQ *  (Integer.valueOf(arList.get('targC'))));  
                NewTargD =(CurrentQ * (Integer.valueOf(arList.get('targD'))));
                NewTargU =(CurrentQ * (Integer.valueOf(arList.get('targU'))));
                NewName ='Total'; 
                System.Debug('Unduplicated contacts total ' + Integer.valueOf(arList.get('ContactCNT')));
                UnDupeAllTotal = (Integer.valueOf(arList.get('ContactCNT')));
                System.Debug(' UnDupeAllTotal & es4KUndupeFY  ' + UnDupeAllTotal +' ' + es4KUndupeFY);
                UndupedQTotal =  UnDupeAllTotal - es4KUndupeFY;
                System.Debug('UndupedQTotal ' + UndupedQTotal);
                UndupedFYResult = (String.valueOf(UndupedQTotal));
                System.debug(currentQ + ' currentQ   ' + '  c= ' + NewTargC + '  d= '+ NewTargD + '  u= '+ NewTargU );   
            }ELSE{
                NewName = (String.valueOf(arList.get('Qnames')));
                NewTargC =  (Integer.valueOf(arList.get('targC')));  
                NewTargD = (Integer.valueOf(arList.get('targD')));
                NewTargU = (Integer.valueOf(arList.get('targU')));   
            }
            
            
            ESQueryTotals.add(new CMSWrapper(String.valueOf(NewName), (Integer.valueOf(arList.get('cmID'))), 
                                             (Integer.valueOf(arList.get('DupeContactCNT'))),(Integer.valueOf(arList.get('ContactCNT'))), 
                                             Integer.valueOf(UndupedQTotal), String.valueOf(UndupedFYResult),
                                             String.valueOf(NewName), String.valueOf(NewName),
                                             Integer.valueOf(NewTargC), Integer.valueOf(NewTargD), Integer.valueOf(NewTargU)));  
            
        }
        System.debug('ES4 6- 17 = ' + ESQueryTotals.size()); 
        System.debug('ES4 6- 17' + ESQueryTotals);
        return ESQueryTotals;
        
    } 
    
    public List<CMSWrapper> getGenerateES6() {
        
        // get current count ES dateTo. Limit SetCon
        list<CMSWrapper> ESQueryTotals = new List <CMSWrapper>();
        List<AggregateResult> ESAggregateResult = [SELECT  campaign.CMSQ__c Qnames,  Count_Distinct(campaign.id) cmID, Count(contactId) DupeContactCNT ,
                                                   Count_Distinct(contactId) ContactCNT, Max(campaign.Campaign_Target__c) targC, 
                                                   Max(campaign.Duplicated_Target__c) targD, Max(campaign.Unduplicated_Target__c) targU                
                                                   FROM campaignmember
                                                   WHERE Event_Date__c >= :dateFrom  AND Event_Date__c <= :dateTo
                                                   AND No_Show__c = false
                                                   AND Status = 'Family Attendee'
                                                                                                     
                                                   AND (campaign.status = 'Completed' OR campaign.status = 'Data In Except Survey' )
                                                   AND (NOT campaign.Name Like '%Childcare%')
                                                   AND (NOT campaign.Name Like '%Cancelled%')
                                                   AND (NOT campaign.Name Like '%No Show%')
                                                   AND (NOT campaign.Name Like '%Postponed%')
                                                   AND campaign.Project_or_Funder__c INCLUDES ('Family Support')
                                                   AND campaign.CMSName__c ='ES4C'
                                                   GROUP BY rollup(campaign.CMSQ__c)
                                                  ]; 
        System.Debug('*******************ESAggregateResult= '+ ESAggregateResult.size());
        String NewName ='';
        Integer NewTargC=0;
        Integer NewTargD=0;
        Integer NewTargU=0;
        Integer CurrentQ = ESAggregateResult.size()-1; Integer UnDupeAllTotal =0; //FORM Total  Row
        Integer UndupedQTotal =0;
        String UndupedFYResult ='N/A';
        
        System.debug('ESAggregateResult.size()  & QNAME = ' + ESAggregateResult.size() + 'Qnames');
        for (AggregateResult arList : ESAggregateResult) {
            
            
            If(String.valueOf(arList.get('Qnames'))==null){
                System.debug(currentQ + ' currentQ' + ' And c= ' + NewTargC + 'd= '+ NewTargD + 'u= '+ NewTargU );
                NewTargC =( CurrentQ *  (Integer.valueOf(arList.get('targC'))));  
                NewTargD =(CurrentQ * (Integer.valueOf(arList.get('targD'))));
                NewTargU =(CurrentQ * (Integer.valueOf(arList.get('targU'))));
                NewName ='Total'; 
                System.Debug('Unduplicated contacts total ' + Integer.valueOf(arList.get('ContactCNT')));
                UnDupeAllTotal = (Integer.valueOf(arList.get('ContactCNT')));
                System.Debug(' UnDupeAllTotal & es6UndupeFY  ' + UnDupeAllTotal +' ' + es6UndupeFY);
                UndupedQTotal =  UnDupeAllTotal - es6UndupeFY;
                System.Debug('UndupedQTotal ' + UndupedQTotal);
                UndupedFYResult = (String.valueOf(UndupedQTotal));
                System.debug(currentQ + ' currentQ   ' + '  c= ' + NewTargC + '  d= '+ NewTargD + '  u= '+ NewTargU );   
            }ELSE{
                NewName = (String.valueOf(arList.get('Qnames')));
                NewTargC =  (Integer.valueOf(arList.get('targC')));  
                NewTargD = (Integer.valueOf(arList.get('targD')));
                NewTargU = (Integer.valueOf(arList.get('targU')));   
            }
            
            
            ESQueryTotals.add(new CMSWrapper(String.valueOf(NewName), (Integer.valueOf(arList.get('cmID'))), 
                                             (Integer.valueOf(arList.get('DupeContactCNT'))),(Integer.valueOf(arList.get('ContactCNT'))), 
                                             Integer.valueOf(UndupedQTotal), String.valueOf(UndupedFYResult),
                                             String.valueOf(NewName), String.valueOf(NewName),
                                             Integer.valueOf(NewTargC), Integer.valueOf(NewTargD), Integer.valueOf(NewTargU)));  
            
        }
        System.debug('ES6= ' + ESQueryTotals.size()); 
        System.debug('ES6= ' + ESQueryTotals);
        return ESQueryTotals;
        
    } 
    
    //ES7
    public List<CMSWrapper> getGenerateES7() {
        
        // get current count ES dateTo. Limit SetCon
        list<CMSWrapper> ESQueryTotals = new List <CMSWrapper>();
        List<AggregateResult> ESAggregateResult = [SELECT  campaign.CMSQ__c Qnames,  Count_Distinct(campaign.id) cmID, Count(contactId) DupeContactCNT ,
                                                   Count_Distinct(contactId) ContactCNT, Max(campaign.Campaign_Target__c) targC, 
                                                   Max(campaign.Duplicated_Target__c) targD, Max(campaign.Unduplicated_Target__c) targU                
                                                   FROM campaignmember
                                                   WHERE Event_Date__c >= :dateFrom  AND Event_Date__c <= :dateTo
                                                   AND No_Show__c = false
                                                   AND Status = 'Family Attendee'
                                                   AND (campaign.status = 'Completed' OR campaign.status = 'Data In Except Survey' )
                                                   AND (NOT campaign.Name Like '%Childcare%')
                                                   AND (NOT campaign.Name Like '%Cancelled%')
                                                   AND (NOT campaign.Name Like '%No Show%')
                                                   AND (NOT campaign.Name Like '%Postponed%')
                                                   AND campaign.Project_or_Funder__c INCLUDES ('Family Support')
                                                   AND campaign.CMSName__c ='ES6'
                                                   AND campaign.CMSQ__c != NULL
                                                   GROUP BY rollup(campaign.CMSQ__c)
                                                  ]; 
        System.Debug('*******************ES7AggregateResult= '+ ESAggregateResult.size());
        String NewName ='';
        Integer NewTargC=0;
        Integer NewTargD=0;
        Integer NewTargU=0;
        Integer CurrentQ = ESAggregateResult.size()-1; 
        Integer UnDupeAllTotal =0; //FORM Total  Row
        Integer UndupedQTotal =0;
        String UndupedFYResult ='N/A';
        
        System.debug('ESAggregateResult.size()  & QNAME = ' + ESAggregateResult.size() + 'Qnames');
        for (AggregateResult arList : ESAggregateResult) {
            
            
            If(String.valueOf(arList.get('Qnames'))==null){
                System.debug(currentQ + ' currentQ' + ' And c= ' + NewTargC + 'd= '+ NewTargD + 'u= '+ NewTargU );
                NewTargC =( CurrentQ *  (Integer.valueOf(arList.get('targC'))));  
                NewTargD =(CurrentQ * (Integer.valueOf(arList.get('targD'))));
                NewTargU =(CurrentQ * (Integer.valueOf(arList.get('targU'))));
                NewName ='Total'; 
                System.Debug('Unduplicated contacts total ' + Integer.valueOf(arList.get('ContactCNT')));
                UnDupeAllTotal = (Integer.valueOf(arList.get('ContactCNT')));
                System.Debug(' UnDupeAllTotal & es7UndupeFY  ' + UnDupeAllTotal +' ' + es7UndupeFY);
                UndupedQTotal =  UnDupeAllTotal - es7UndupeFY;
                System.Debug('UndupedQTotal ' + UndupedQTotal);
                UndupedFYResult = (String.valueOf(UndupedQTotal));
                System.debug(currentQ + ' currentQ   ' + '  c= ' + NewTargC + '  d= '+ NewTargD + '  u= '+ NewTargU );   
            }ELSE{
                NewName = (String.valueOf(arList.get('Qnames')));
                NewTargC =  (Integer.valueOf(arList.get('targC')));  
                NewTargD = (Integer.valueOf(arList.get('targD')));
                NewTargU = (Integer.valueOf(arList.get('targU')));   
            }
            
            
            ESQueryTotals.add(new CMSWrapper(String.valueOf(NewName), (Integer.valueOf(arList.get('cmID'))), 
                                             (Integer.valueOf(arList.get('DupeContactCNT'))),(Integer.valueOf(arList.get('ContactCNT'))), 
                                             Integer.valueOf(UndupedQTotal), String.valueOf(UndupedFYResult),
                                             String.valueOf(NewName), String.valueOf(NewName),
                                             Integer.valueOf(NewTargC), Integer.valueOf(NewTargD), Integer.valueOf(NewTargU)));  
            
        }
        System.debug('ES7= ' + ESQueryTotals.size()); 
        System.debug('ES7= ' + ESQueryTotals);
        return ESQueryTotals;
        
    } 
    
    /********************************************************************************/
    // get List Of ES4 Campaigns that feed the Board 
    
    public List<CMSWrapper> getGenerateES4List() {
        list<CMSWrapper> ESListQueryTotals = new List <CMSWrapper>();
        List<Campaign> ESList = [SELECT  name,  Number_of_Minutes__c,  TotalCareGiversAttended__c, Number_of_Parent_Family_Evaluations__c, 
                                 TotalChildrenAttended__c,      TotalCommunityMembersAttendedCMS__c, TotalProfessionalsAttendedCMS__c, Start_Date_Time__c, ID         
                                 FROM campaign
                                 //Current Quarter only
                                 WHERE Start_Date_Time__c > :PriorQuarterEnds  AND Start_Date_Time__c <= :dateTo
                                 AND (campaign.status = 'Completed' OR campaign.status = 'Data In Except Survey' )
                                 AND (NOT Name Like '%Childcare%')
                                 AND (NOT Name Like '%Cancelled%')
                                 AND (NOT Name Like '%No Show%')
                                 AND (NOT campaign.Name Like '%Postponed%')
                                 AND Project_or_Funder__c INCLUDES ('Family Support')
                                 AND CMSName__c ='ES4'
                                 //GROUP BY name
                                 ORDER BY name ASC 
                                ];
        
        
        for (Campaign arList : ESList) { 
            Integer Target = 6;
            ESListQueryTotals.add(new CMSWrapper(arList.Name,  Integer.valueOf(arList.TotalCareGiversAttended__c ), Integer.valueOf(arList.TotalCareGiversAttended__c), 
                                                 Integer.valueOf(arList.Number_of_Parent_Family_Evaluations__c), Integer.valueOf(arList.TotalCareGiversAttended__c),
                                                 String.valueOf(arList.Start_Date_Time__c.date()), String.valueOf(arList.Start_Date_Time__c.date()), String.valueOf(arList.ID),
                                                 Integer.valueOf(arlist.TotalCareGiversAttended__c), Integer.valueOf(arList.TotalCommunityMembersAttendedCMS__c), Integer.valueOf(arList.TotalProfessionalsAttendedCMS__c)));
            
        }
        return ESListQueryTotals;
    }   
    
    /*************************************************************************/
    // get List Of ES4 Campaigns that are not on the Board 
    
    public List<CMSWrapper> getGenerateES4NoList() {
        list<CMSWrapper> ESListQueryTotals = new List <CMSWrapper>();
        List<campaign> ESNoList = [SELECT Name,  Start_Date_Time__c, TotalCareGiversAttended__c, Number_of_Minutes__c, Unduplicated_Campaign__c, NumberOfContacts, status, ID,TotalChildrenAttended__c
                                   // Current Quarter only
                                   FROM campaign
                                   WHERE Start_Date_Time__c > :PriorQuarterEnds  AND Start_Date_Time__c <= :dateTo
                                   AND (campaign.status != 'Completed')
                                   AND (campaign.status != 'Data In Except Survey' )
                                   AND (NOT Name Like '%Childcare%')
                                   AND Project_or_Funder__c INCLUDES ('Family Support')
                                   AND CMSName__c ='ES4'
                                   ORDER BY campaign.status Desc
                                  ];
        
        
        for (campaign arList : ESNoList) { 
            
            
            Integer Target = 0;
            ESListQueryTotals.add(new CMSWrapper(arList.Name,  Integer.valueOf(arList.Number_of_Minutes__c ),Integer.valueOf(arList.Number_of_Minutes__c), 
                                                 Integer.valueOf(arList.Unduplicated_Campaign__c), Integer.valueOf(arList.TotalCareGiversAttended__c),
                                                 String.valueOf(arList.status), String.valueOf(arList.Start_Date_Time__c), String.valueOf(arList.ID),
                                                 Integer.valueOf(arlist.TotalChildrenAttended__c), Integer.valueOf(arList.TotalChildrenAttended__c), Integer.valueOf(arList.TotalChildrenAttended__c)));
            System.debug('NoList= ' + ESListQueryTotals.size()); 
            System.debug('NoList= ' + ESListQueryTotals);
        }
        return ESListQueryTotals;
    }   
    //Campains By status ES4
    public List<CMSWrapper> getGenerateES4Pie() {
        list<CMSWrapper> ESPieQueryTotals = new List <CMSWrapper>();
        List<campaign> ESPieLists = [SELECT CMSQ__c,  name, Start_Date_Time__c, Number_of_Minutes__c, Unduplicated_Campaign__c, TotalChildrenAttended__c, status, ID,
                                     Campaign_Target__c, Duplicated_Target__c, Unduplicated_Target__c 
                                     FROM campaign
                                     WHERE Start_Date_Time__c > :PriorQuarterEnds  AND Start_Date_Time__c <= :dateTo
                                     //AND (campaign.status != 'Completed')
                                     AND Project_or_Funder__c INCLUDES ('Family Support')
                                     AND CMSName__c ='ES4'       
                                     ORDER BY status 
                                    ];
        
        
        for (campaign arList : ESPieLists) { 
            Integer Target = 0;
            ESPieQueryTotals.add(new CMSWrapper(String.valueOf('Q' + arList.CMSQ__c),  Integer.valueOf(arList.Number_of_Minutes__c ),Integer.valueOf(arList.TotalChildrenAttended__c), 
                                                Integer.valueOf(arList.Unduplicated_Campaign__c), Integer.valueOf(arList.TotalChildrenAttended__c),
                                                arList.name, String.valueOf(arList.Start_Date_Time__c.date()), String.valueOf(arList.ID),(Integer.valueOf(arList.Campaign_Target__c)),
                                                (Integer.valueOf(arList.Duplicated_Target__c)), (Integer.valueOf(arList.Unduplicated_Target__c))));
            // System.debug('NoList= ' + ES ESListQueryTotals.size()); 
            System.debug('Pie3= ' + ESPieQueryTotals);
        }
        return ESPieQueryTotals;
    } 
    
    /********************************************************************************/
    // get List Of ES6 Campaigns that feed the Board 
    
    public List<CMSWrapper> getGenerateES6List() {
        list<CMSWrapper>  ESListQueryTotals = new List <CMSWrapper>();
        List<Campaign> ESList = [SELECT  name,  Number_of_Minutes__c,  TotalCareGiversAttended__c, Number_of_Parent_Family_Evaluations__c, 
                                 TotalChildrenAttended__c, TotalCommunityMembersAttendedCMS__c, TotalProfessionalsAttendedCMS__c, Start_Date_Time__c, ID         
                                 FROM campaign
                                 //Current Quarter only
                                 WHERE Start_Date_Time__c > :PriorQuarterEnds  AND Start_Date_Time__c <= :dateTo
                                 AND (campaign.status = 'Completed' OR campaign.status = 'Data In Except Survey' )
                                 AND (NOT Name Like '%Childcare%')
                                 AND (NOT Name Like '%Cancelled%')
                                 AND (NOT Name Like '%No Show%')
                                 AND (NOT campaign.Name Like '%Postponed%')
                                 AND Project_or_Funder__c INCLUDES ('Family Support')
                                 
                                 AND CMSName__c ='ES4C'
                                 //GROUP BY name
                                 ORDER BY name ASC 
                                ];
        
        
        for (Campaign arList : ESList) { 
            Integer Target = 6;
            ESListQueryTotals.add(new CMSWrapper(arList.Name,  Integer.valueOf(arList.TotalCareGiversAttended__c ), Integer.valueOf(arList.TotalCareGiversAttended__c), 
                                                 Integer.valueOf(arList.Number_of_Parent_Family_Evaluations__c), Integer.valueOf(arList.TotalCareGiversAttended__c),
                                                 String.valueOf(arList.Start_Date_Time__c.date()), String.valueOf(arList.Start_Date_Time__c.date()), String.valueOf(arList.ID),
                                                 Integer.valueOf(arlist.TotalCareGiversAttended__c), Integer.valueOf(arList.TotalCommunityMembersAttendedCMS__c), Integer.valueOf(arList.TotalProfessionalsAttendedCMS__c)));
            
        }
        return  ESListQueryTotals;
    }   
    
    /*************************************************************************/
    // get List Of ES6 Campaigns that are not on the Board 
    
    public List<CMSWrapper> getGenerateES6NoList() {
        list<CMSWrapper> ESListQueryTotals = new List <CMSWrapper>();
        List<Campaign> ESNoList = [SELECT Name,  Start_Date_Time__c, TotalCareGiversAttended__c,
                                   Number_of_Minutes__c, Unduplicated_Campaign__c, NumberOfContacts, status, ID, TotalChildrenAttended__c
                                   // Current Quarter only
                                   FROM campaign
                                   WHERE Start_Date_Time__c > :PriorQuarterEnds  AND Start_Date_Time__c <= :dateTo
                                   AND (campaign.status != 'Completed')
                                   AND (campaign.status != 'Data In Except Survey' )
                                   AND (NOT Name Like '%Childcare%')
                                   AND Project_or_Funder__c INCLUDES ('Family Support')
                                   AND CMSName__c ='ES4C'
                                   ORDER BY campaign.status Desc
                                  ];
        
        
        for (Campaign arList : ESNoList) { 
            
            
            Integer Target = 0;
            ESListQueryTotals.add(new CMSWrapper(arList.Name,  Integer.valueOf(arList.Number_of_Minutes__c ),Integer.valueOf(arList.Number_of_Minutes__c), 
                                                 Integer.valueOf(arList.Unduplicated_Campaign__c), Integer.valueOf(arList.TotalCareGiversAttended__c),
                                                 String.valueOf(arList.status), String.valueOf(arList.Start_Date_Time__c), String.valueOf(arList.ID),
                                                 Integer.valueOf(arlist.TotalChildrenAttended__c), Integer.valueOf(arList.TotalChildrenAttended__c), Integer.valueOf(arList.TotalChildrenAttended__c)));
            System.debug('NoList= ' + ESListQueryTotals.size()); 
            System.debug('NoList= ' + ESListQueryTotals);
        }
        return ESListQueryTotals;
    }   
    //Campains By status ES6
    public List<CMSWrapper> getGenerateES6Pie() {
        list<CMSWrapper>  ESPieQueryTotals = new List <CMSWrapper>();
        List<campaign> ESPieLists = [SELECT CMSQ__c,  name, Start_Date_Time__c, 
                                     Number_of_Minutes__c, Unduplicated_Campaign__c, TotalChildrenAttended__c, status, ID,
                                     Campaign_Target__c, Duplicated_Target__c, Unduplicated_Target__c 
                                     FROM campaign
                                     WHERE Start_Date_Time__c > :PriorQuarterEnds  AND Start_Date_Time__c <= :dateTo
                                     AND Project_or_Funder__c INCLUDES ('Family Support')
                                     AND CMSName__c ='ES4C'       
                                     ORDER BY status 
                                    ];
        
        
        for (campaign arList : ESPieLists) { 
            Integer Target = 0;
            ESPieQueryTotals.add(new CMSWrapper(String.valueOf('Q' + arList.CMSQ__c),  Integer.valueOf(arList.Number_of_Minutes__c ),Integer.valueOf(arList.TotalChildrenAttended__c), 
                                                Integer.valueOf(arList.Unduplicated_Campaign__c), Integer.valueOf(arList.TotalChildrenAttended__c),
                                                arList.name, String.valueOf(arList.Start_Date_Time__c.date()), String.valueOf(arList.ID),(Integer.valueOf(arList.Campaign_Target__c)),
                                                (Integer.valueOf(arList.Duplicated_Target__c)), (Integer.valueOf(arList.Unduplicated_Target__c))));
            
        }
        return  ESPieQueryTotals;
    } 
    
    /********************************************************************************/
    // get List Of ES7 Campaigns that feed the Board 
    
    public List<CMSWrapper> getGenerateES7List() {
        list<CMSWrapper>  ESListQueryTotals = new List <CMSWrapper>();
        List<Campaign> ESList = [SELECT  name,  Number_of_Minutes__c,  TotalCareGiversAttended__c, Number_of_Parent_Family_Evaluations__c, 
                                 TotalChildrenAttended__c, TotalCommunityMembersAttendedCMS__c, TotalProfessionalsAttendedCMS__c, Start_Date_Time__c, ID         
                                 FROM campaign
                                 //Current Quarter only
                                 WHERE Start_Date_Time__c > :PriorQuarterEnds  AND Start_Date_Time__c <= :dateTo
                                 AND (campaign.status = 'Completed' OR campaign.status = 'Data In Except Survey' )
                                 AND (NOT Name Like '%Childcare%')
                                 AND (NOT Name Like '%Cancelled%')
                                 AND (NOT Name Like '%No Show%')
                                 AND (NOT campaign.Name Like '%Postponed%')
                                 AND Project_or_Funder__c INCLUDES ('Family Support')
                                 AND CMSName__c ='ES6'
                                 ORDER BY name ASC 
                                ];
        
        
        for (Campaign arList : ESList) { 
            Integer Target = 6;
            ESListQueryTotals.add(new CMSWrapper(arList.Name,  Integer.valueOf(arList.TotalCareGiversAttended__c ), Integer.valueOf(arList.TotalCareGiversAttended__c), 
                                                 Integer.valueOf(arList.Number_of_Parent_Family_Evaluations__c), Integer.valueOf(arList.TotalCareGiversAttended__c),
                                                 String.valueOf(arList.Start_Date_Time__c.date()), String.valueOf(arList.Start_Date_Time__c.date()), String.valueOf(arList.ID),
                                                 Integer.valueOf(arlist.TotalCareGiversAttended__c), Integer.valueOf(arList.TotalCommunityMembersAttendedCMS__c), Integer.valueOf(arList.TotalProfessionalsAttendedCMS__c)));
            
        }
        return  ESListQueryTotals;
    }   
    
    /*************************************************************************/
    // get List Of ES7 Campaigns that are not on the Board 
    
    public List<CMSWrapper> getGenerateES7NoList() {
        list<CMSWrapper> ESListQueryTotals = new List <CMSWrapper>();
        List<campaign> ESNoList = [SELECT Name,  Start_Date_Time__c, TotalCareGiversAttended__c, Number_of_Minutes__c, Unduplicated_Campaign__c, NumberOfContacts, status, ID,TotalChildrenAttended__c
                                   // Current Quarter only
                                   FROM campaign
                                   WHERE Start_Date_Time__c > :PriorQuarterEnds  AND Start_Date_Time__c <= :dateTo
                                   AND (campaign.status != 'Completed')
                                   AND (campaign.status != 'Data In Except Survey' )
                                   AND (NOT Name Like '%Childcare%')
                                   AND Project_or_Funder__c INCLUDES ('Family Support')
                                   AND CMSName__c ='ES6'
                                   ORDER BY campaign.status Desc
                                  ];
        
        
        for (campaign arList : ESNoList) { 
            
            
            Integer Target = 0;
            ESListQueryTotals.add(new CMSWrapper(arList.Name,  Integer.valueOf(arList.Number_of_Minutes__c ),Integer.valueOf(arList.Number_of_Minutes__c), 
                                                 Integer.valueOf(arList.Unduplicated_Campaign__c), Integer.valueOf(arList.TotalCareGiversAttended__c),
                                                 String.valueOf(arList.status), String.valueOf(arList.Start_Date_Time__c), String.valueOf(arList.ID),
                                                 Integer.valueOf(arlist.TotalChildrenAttended__c), Integer.valueOf(arList.TotalChildrenAttended__c), 
                                                 Integer.valueOf(arList.TotalChildrenAttended__c)));
            System.debug('NoList= ' + ESListQueryTotals.size()); 
            System.debug('NoList= ' + ESListQueryTotals);
        }
        return ESListQueryTotals;
    }   
    //Campains By status ES7
    public List<CMSWrapper> getGenerateES7Pie() {
        list<CMSWrapper>  ESPieQueryTotals = new List <CMSWrapper>();
        List<campaign> ESPieLists = [SELECT CMSQ__c,  name, Start_Date_Time__c, Number_of_Minutes__c, Unduplicated_Campaign__c, TotalChildrenAttended__c, status, ID,
                                     Campaign_Target__c, Duplicated_Target__c, Unduplicated_Target__c 
                                     FROM campaign
                                     WHERE Start_Date_Time__c > :PriorQuarterEnds  AND Start_Date_Time__c <= :dateTo
                                     AND Project_or_Funder__c INCLUDES ('Family Support')
                                     AND CMSName__c ='ES6'       
                                     ORDER BY status 
                                    ];
        
        
        for (campaign arList : ESPieLists) { 
            Integer Target = 0;
            ESPieQueryTotals.add(new CMSWrapper(String.valueOf('Q' + arList.CMSQ__c),  Integer.valueOf(arList.Number_of_Minutes__c ),Integer.valueOf(arList.TotalChildrenAttended__c), 
                                                Integer.valueOf(arList.Unduplicated_Campaign__c), Integer.valueOf(arList.TotalChildrenAttended__c),
                                                arList.name, String.valueOf(arList.Start_Date_Time__c.date()), String.valueOf(arList.ID),(Integer.valueOf(arList.Campaign_Target__c)),
                                                (Integer.valueOf(arList.Duplicated_Target__c)), (Integer.valueOf(arList.Unduplicated_Target__c))));
            // System.debug('NoList= ' + ES ESListQueryTotals.size()); 
            System.debug('Pie3= ' +  ESPieQueryTotals);
        }
        return  ESPieQueryTotals;
    } 
    
    
    
    
    /********************************
* ES2 
*/ 
    public List<CMSWrapper> getGenerateESq2() {
        
        // get current count ES dateTo. Limit SetCon
        list<CMSWrapper> ESqQueryTotals = new List <CMSWrapper>();
        List<AggregateResult> ESqAggregateResult = [SELECT  campaign.CMSQ__c Qnames,  Count_Distinct(campaign.id) cmID, Count(contactId) DupeContactCNT ,
                                                    Count_Distinct(contactId) ContactCNT, Max(campaign.Campaign_Target__c) targC, 
                                                    Max(campaign.Duplicated_Target__c) targD, Max(campaign.Unduplicated_Target__c) targU                
                                                    FROM campaignmember
                                                    WHERE Event_Date__c >= :dateFrom  AND Event_Date__c <= :dateTo
                                                    AND No_Show__c = false
                                                    AND Status != 'Family Attendee'
                                                    AND (campaign.status = 'Completed' OR campaign.status = 'Data In Except Survey' )
                                                    AND (NOT campaign.Name Like '%Childcare%')
                                                    AND (NOT campaign.Name Like '%Cancelled%')
                                                    AND (NOT campaign.Name Like '%No Show%')
                                                    AND (NOT campaign.Name Like '%Postponed%')
                                                    AND campaign.Project_or_Funder__c INCLUDES ('Family Support')
                                                    // AND campaign.CMSName__c ='ES1'
                                                    GROUP BY rollup(campaign.CMSQ__c)
                                                   ]; 
        String NewName ='';
        Integer NewTargC=0;
        Integer NewTargD=0;
        Integer NewTargU=0;
        Integer CurrentQ = ESqAggregateResult.size()-1;
        System.debug('ESqAggregateResult.size()  & QNAME = ' + ESqAggregateResult.size() + 'Qnames');
        for (AggregateResult arList : ESqAggregateResult) {
            
            
            If(String.valueOf(arList.get('Qnames'))==null){
                System.debug(currentQ + ' currentQ' + ' And c= ' + NewTargC + 'd= '+ NewTargD + 'u= '+ NewTargU );
                NewTargC =( CurrentQ *  (Integer.valueOf(arList.get('targC'))));  
                NewTargD =(CurrentQ * (Integer.valueOf(arList.get('targD'))));
                NewTargU =(CurrentQ * (Integer.valueOf(arList.get('targU'))));
                NewName ='Total'; 
                System.debug(currentQ + ' currentQ   ' + '  c= ' + NewTargC + '  d= '+ NewTargD + '  u= '+ NewTargU );   
            }ELSE{
                NewName = (String.valueOf(arList.get('Qnames')));
                NewTargC =  (Integer.valueOf(arList.get('targC')));  
                NewTargD = (Integer.valueOf(arList.get('targD')));
                NewTargU = (Integer.valueOf(arList.get('targU')));   
            }
            //Integer Target = 6;
            ESqQueryTotals.add(new CMSWrapper(String.valueOf(NewName), (Integer.valueOf(arList.get('cmID'))), 
                                              (Integer.valueOf(arList.get('DupeContactCNT'))),(Integer.valueOf(arList.get('ContactCNT'))), 
                                              ((Integer.valueOf(arList.get('ContactCNT')))- 0), String.valueOf(NewName),
                                              String.valueOf(NewName), String.valueOf(NewName),
                                              Integer.valueOf(NewTargC), Integer.valueOf(NewTargD), Integer.valueOf(NewTargU)));  
            // Target not being used right now 
        }
        
        System.debug('ESq= ' + ESqQueryTotals.size()); 
        System.debug('ESq= ' + ESqQueryTotals);
        return ESqQueryTotals;
        
    }   
    
    /********************************
* ES Throwawy
*/ 
    public List<CMSWrapper> getGenerateESqw() {
        
        // get current count ES dateTo. Limit SetCon
        list<CMSWrapper> ESqQueryTotals = new List <CMSWrapper>();
        List<AggregateResult> ESqAggregateResult = [SELECT  campaign.CMSQ__c Qnames,  Count_Distinct(campaign.id) cmID, Count(contactId) DupeContactCNT ,
                                                    Count_Distinct(contactId) ContactCNT, Max(campaign.Campaign_Target__c) targC, 
                                                    Max(campaign.Duplicated_Target__c) targD, Max(campaign.Unduplicated_Target__c) targU                
                                                    FROM campaignmember
                                                    WHERE Event_Date__c >= :dateFrom  AND Event_Date__c <= :dateTo
                                                    AND No_Show__c = false
                                                    AND Status != 'Family Attendee'
                                                    //AND (campaign.status = 'Completed' OR campaign.status = 'Data In Except Survey' )
                                                    AND (NOT campaign.Name Like '%Childcare%')
                                                    AND (NOT campaign.Name Like '%Cancelled%')
                                                    AND (NOT campaign.Name Like '%No Show%')
                                                    AND (NOT campaign.Name Like '%Postponed%')
                                                    AND campaign.Project_or_Funder__c INCLUDES ('Family Support')
                                                    // AND campaign.CMSName__c ='ES1'
                                                    GROUP BY rollup(campaign.CMSQ__c)
                                                   ]; 
        String NewName ='';
        Integer NewTargC=0;
        Integer NewTargD=0;
        Integer NewTargU=0;
        Integer CurrentQ = ESqAggregateResult.size()-1;
        System.debug('ESqAggregateResult.size()  & QNAME = ' + ESqAggregateResult.size() + 'Qnames');
        for (AggregateResult arList : ESqAggregateResult) {
            
            
            If(String.valueOf(arList.get('Qnames'))==null){
                System.debug(currentQ + ' currentQ' + ' And c= ' + NewTargC + 'd= '+ NewTargD + 'u= '+ NewTargU );
                NewTargC =( CurrentQ *  (Integer.valueOf(arList.get('targC'))));  
                NewTargD =(CurrentQ * (Integer.valueOf(arList.get('targD'))));
                NewTargU =(CurrentQ * (Integer.valueOf(arList.get('targU'))));
                NewName ='Total'; 
                System.debug(currentQ + ' currentQ   ' + '  c= ' + NewTargC + '  d= '+ NewTargD + '  u= '+ NewTargU );   
            }ELSE{
                NewName = (String.valueOf(arList.get('Qnames')));
                NewTargC =  (Integer.valueOf(arList.get('targC')));  
                NewTargD = (Integer.valueOf(arList.get('targD')));
                NewTargU = (Integer.valueOf(arList.get('targU')));   
            }
            //Integer Target = 6;
            ESqQueryTotals.add(new CMSWrapper(String.valueOf(NewName), (Integer.valueOf(arList.get('cmID'))), 
                                              (Integer.valueOf(arList.get('DupeContactCNT'))),(Integer.valueOf(arList.get('ContactCNT'))), 
                                              ((Integer.valueOf(arList.get('ContactCNT')))- 0), String.valueOf(NewName),
                                              String.valueOf(NewName), String.valueOf(NewName),
                                              Integer.valueOf(NewTargC), Integer.valueOf(NewTargD), Integer.valueOf(NewTargU)));  
            // Target not being used right now 
        }
        
        System.debug('ESq= ' + ESqQueryTotals.size()); 
        System.debug('ESq= ' + ESqQueryTotals);
        return ESqQueryTotals;
        
    }   
    
    
    public List<CMSWrapper> getGenerateESq() {
        
        // get current count ES dateTo. Limit SetCon
        list<CMSWrapper> ESqQueryTotals = new List <CMSWrapper>();
        List<AggregateResult> ESqAggregateResult = [SELECT  campaign.CMSQ__c Qnames,  Count_Distinct(campaign.id) cmID, Count(contactId) DupeContactCNT ,
                                                    Count_Distinct(contactId) ContactCNT, Max(campaign.Campaign_Target__c) targC, 
                                                    Max(campaign.Duplicated_Target__c) targD, Max(campaign.Unduplicated_Target__c) targU                
                                                    FROM campaignmember
                                                    WHERE Event_Date__c >= :dateFrom  AND Event_Date__c <= :dateTo
                                                    AND No_Show__c = false
                                                    AND Status != 'Family Attendee'
                                                    //AND (campaign.status = 'Completed' OR campaign.status = 'Data In Except Survey' )
                                                    AND (NOT campaign.Name Like '%Childcare%')
                                                    AND (NOT campaign.Name Like '%Cancelled%')
                                                    AND (NOT campaign.Name Like '%No Show%')
                                                    AND (NOT campaign.Name Like '%Postponed%')
                                                    AND campaign.Project_or_Funder__c INCLUDES ('Family Support')
                                                    // AND campaign.CMSName__c ='ES1'
                                                    GROUP BY rollup(campaign.CMSQ__c)
                                                   ]; 
        String NewName ='';
        Integer NewTargC=0;
        Integer NewTargD=0;
        Integer NewTargU=0;
        Integer CurrentQ = ESqAggregateResult.size()-1;
        System.debug('ESqAggregateResult.size()  & QNAME = ' + ESqAggregateResult.size() + 'Qnames');
        for (AggregateResult arList : ESqAggregateResult) {
            
            
            If(String.valueOf(arList.get('Qnames'))==null){
                System.debug(currentQ + ' currentQ' + ' And c= ' + NewTargC + 'd= '+ NewTargD + 'u= '+ NewTargU );
                NewTargC =( CurrentQ *  (Integer.valueOf(arList.get('targC'))));  
                NewTargD =(CurrentQ * (Integer.valueOf(arList.get('targD'))));
                NewTargU =(CurrentQ * (Integer.valueOf(arList.get('targU'))));
                NewName ='Total'; 
                System.debug(currentQ + ' currentQ   ' + '  c= ' + NewTargC + '  d= '+ NewTargD + '  u= '+ NewTargU );   
            }ELSE{
                NewName = (String.valueOf(arList.get('Qnames')));
                NewTargC =  (Integer.valueOf(arList.get('targC')));  
                NewTargD = (Integer.valueOf(arList.get('targD')));
                NewTargU = (Integer.valueOf(arList.get('targU')));   
            }
            //Integer Target = 6;
            ESqQueryTotals.add(new CMSWrapper(String.valueOf(NewName), (Integer.valueOf(arList.get('cmID'))), 
                                              (Integer.valueOf(arList.get('DupeContactCNT'))),(Integer.valueOf(arList.get('ContactCNT'))), 
                                              ((Integer.valueOf(arList.get('ContactCNT')))- 0), String.valueOf(NewName),
                                              String.valueOf(NewName), String.valueOf(NewName),
                                              Integer.valueOf(NewTargC), Integer.valueOf(NewTargD), Integer.valueOf(NewTargU)));  
            // Target not being used right now 
        }
        
        System.debug('ESq= ' + ESqQueryTotals.size()); 
        System.debug('ESq= ' + ESqQueryTotals);
        return ESqQueryTotals;
        
    } 
    
    public List<CMSWrapper> getGenerateESq22() {
        
        // get current count ES dateTo. Limit SetCon
        list<CMSWrapper> ESqQueryTotals = new List <CMSWrapper>();
        List<AggregateResult> ESqAggregateResult = [SELECT  campaign.CMSQ__c Qnames,  Count_Distinct(campaign.id) cmID, Count(contactId) DupeContactCNT ,
                                                    Count_Distinct(contactId) ContactCNT, Max(campaign.Campaign_Target__c) targC, 
                                                    Max(campaign.Duplicated_Target__c) targD, Max(campaign.Unduplicated_Target__c) targU                
                                                    FROM campaignmember
                                                    //WHERE Event_Date__c >= :dateFrom  AND Event_Date__c <= :dateTo
                                                    //AND No_Show__c = false
                                                    //AND Status != 'Family Attendee'
                                                    //AND (campaign.status = 'Completed' OR campaign.status = 'Data In Except Survey' )
                                                    Where (NOT campaign.Name Like '%Childcare%')
                                                    AND (NOT campaign.Name Like '%Cancelled%')
                                                    AND (NOT campaign.Name Like '%No Show%')
                                                    AND (NOT campaign.Name Like '%Postponed%')
                                                    AND campaign.Project_or_Funder__c INCLUDES ('Family Support')
                                                    // AND campaign.CMSName__c ='ES1'
                                                    GROUP BY rollup(campaign.CMSQ__c)
                                                   ]; 
        String NewName ='';
        Integer NewTargC=0;
        Integer NewTargD=0;
        Integer NewTargU=0;
        Integer CurrentQ = ESqAggregateResult.size()-1;
        System.debug('ESqAggregateResult.size()  & QNAME = ' + ESqAggregateResult.size() + 'Qnames');
        for (AggregateResult arList : ESqAggregateResult) {
            
            
            If(String.valueOf(arList.get('Qnames'))==null){
                System.debug(currentQ + ' currentQ' + ' And c= ' + NewTargC + 'd= '+ NewTargD + 'u= '+ NewTargU );
                NewTargC =( CurrentQ *  (Integer.valueOf(arList.get('targC'))));  
                NewTargD =(CurrentQ * (Integer.valueOf(arList.get('targD'))));
                NewTargU =(CurrentQ * (Integer.valueOf(arList.get('targU'))));
                NewName ='Total'; 
                System.debug(currentQ + ' currentQ   ' + '  c= ' + NewTargC + '  d= '+ NewTargD + '  u= '+ NewTargU );   
            }ELSE{
                NewName = (String.valueOf(arList.get('Qnames')));
                NewTargC =  (Integer.valueOf(arList.get('targC')));  
                NewTargD = (Integer.valueOf(arList.get('targD')));
                NewTargU = (Integer.valueOf(arList.get('targU')));   
            }
            //Integer Target = 6;
            ESqQueryTotals.add(new CMSWrapper(String.valueOf(NewName), (Integer.valueOf(arList.get('cmID'))), 
                                              (Integer.valueOf(arList.get('DupeContactCNT'))),(Integer.valueOf(arList.get('ContactCNT'))), 
                                              ((Integer.valueOf(arList.get('ContactCNT')))- 0), String.valueOf(NewName),
                                              String.valueOf(NewName), String.valueOf(NewName),
                                              Integer.valueOf(NewTargC), Integer.valueOf(NewTargD), Integer.valueOf(NewTargU)));  
            // Target not being used right now 
        }
        
        
        return ESqQueryTotals;
        
    }   
    
    /********************************
* ES Throwawy
*/ 
    public List<CMSWrapper> getGenerateESqw2() {
        
        // get current count ES dateTo. Limit SetCon
        list<CMSWrapper> ESqQueryTotals = new List <CMSWrapper>();
        List<AggregateResult> ESqAggregateResult = [SELECT  campaign.CMSQ__c Qnames,  Count_Distinct(campaign.id) cmID, Count(contactId) DupeContactCNT ,
                                                    Count_Distinct(contactId) ContactCNT, Max(campaign.Campaign_Target__c) targC, 
                                                    Max(campaign.Duplicated_Target__c) targD, Max(campaign.Unduplicated_Target__c) targU                
                                                    FROM campaignmember
                                                    WHERE Event_Date__c >= :dateFrom  AND Event_Date__c <= :dateTo
                                                    AND No_Show__c = false
                                                    AND Status != 'Family Attendee'
                                                    //AND (campaign.status = 'Completed' OR campaign.status = 'Data In Except Survey' )
                                                    AND (NOT campaign.Name Like '%Childcare%')
                                                    AND (NOT campaign.Name Like '%Cancelled%')
                                                    AND (NOT campaign.Name Like '%No Show%')
                                                    AND (NOT campaign.Name Like '%Postponed%')
                                                    AND campaign.Project_or_Funder__c INCLUDES ('Family Support')
                                                    // AND campaign.CMSName__c ='ES1'
                                                    GROUP BY rollup(campaign.CMSQ__c)
                                                   ]; 
        String NewName ='';
        Integer NewTargC=0;
        Integer NewTargD=0;
        Integer NewTargU=0;
        Integer CurrentQ = ESqAggregateResult.size()-1;
        System.debug('ESqAggregateResult.size()  & QNAME = ' + ESqAggregateResult.size() + 'Qnames');
        for (AggregateResult arList : ESqAggregateResult) {
            
            
            If(String.valueOf(arList.get('Qnames'))==null){
                System.debug(currentQ + ' currentQ' + ' And c= ' + NewTargC + 'd= '+ NewTargD + 'u= '+ NewTargU );
                NewTargC =( CurrentQ *  (Integer.valueOf(arList.get('targC'))));  
                NewTargD =(CurrentQ * (Integer.valueOf(arList.get('targD'))));
                NewTargU =(CurrentQ * (Integer.valueOf(arList.get('targU'))));
                NewName ='Total'; 
                System.debug(currentQ + ' currentQ   ' + '  c= ' + NewTargC + '  d= '+ NewTargD + '  u= '+ NewTargU );   
            }ELSE{
                NewName = (String.valueOf(arList.get('Qnames')));
                NewTargC =  (Integer.valueOf(arList.get('targC')));  
                NewTargD = (Integer.valueOf(arList.get('targD')));
                NewTargU = (Integer.valueOf(arList.get('targU')));   
            }
            //Integer Target = 6;
            ESqQueryTotals.add(new CMSWrapper(String.valueOf(NewName), (Integer.valueOf(arList.get('cmID'))), 
                                              (Integer.valueOf(arList.get('DupeContactCNT'))),(Integer.valueOf(arList.get('ContactCNT'))), 
                                              ((Integer.valueOf(arList.get('ContactCNT')))- 0), String.valueOf(NewName),
                                              String.valueOf(NewName), String.valueOf(NewName),
                                              Integer.valueOf(NewTargC), Integer.valueOf(NewTargD), Integer.valueOf(NewTargU)));  
            // Target not being used right now 
        }
        
        System.debug('ESq= ' + ESqQueryTotals.size()); 
        System.debug('ESq= ' + ESqQueryTotals);
        return ESqQueryTotals;
        
    }   
    
    
    public List<CMSWrapper> getGenerateESq212() {
        
        // get current count ES dateTo. Limit SetCon
        list<CMSWrapper> ESqQueryTotals = new List <CMSWrapper>();
        List<AggregateResult> ESqAggregateResult = [SELECT  campaign.CMSQ__c Qnames,  Count_Distinct(campaign.id) cmID, Count(contactId) DupeContactCNT ,
                                                    Count_Distinct(contactId) ContactCNT, Max(campaign.Campaign_Target__c) targC, 
                                                    Max(campaign.Duplicated_Target__c) targD, Max(campaign.Unduplicated_Target__c) targU                
                                                    FROM campaignmember
                                                    WHERE Event_Date__c >= :dateFrom  AND Event_Date__c <= :dateTo
                                                    AND No_Show__c = false
                                                    AND Status != 'Family Attendee'
                                                    //AND (campaign.status = 'Completed' OR campaign.status = 'Data In Except Survey' )
                                                    AND (NOT campaign.Name Like '%Childcare%')
                                                    AND (NOT campaign.Name Like '%Cancelled%')
                                                    AND (NOT campaign.Name Like '%No Show%')
                                                    AND (NOT campaign.Name Like '%Postponed%')
                                                    AND campaign.Project_or_Funder__c INCLUDES ('Family Support')
                                                    // AND campaign.CMSName__c ='ES1'
                                                    GROUP BY rollup(campaign.CMSQ__c)
                                                   ]; 
        String NewName ='';
        Integer NewTargC=0;
        Integer NewTargD=0;
        Integer NewTargU=0;
        Integer CurrentQ = ESqAggregateResult.size()-1;
        System.debug('ESqAggregateResult.size()  & QNAME = ' + ESqAggregateResult.size() + 'Qnames');
        for (AggregateResult arList : ESqAggregateResult) {
            
            
            If(String.valueOf(arList.get('Qnames'))==null){
                System.debug(currentQ + ' currentQ' + ' And c= ' + NewTargC + 'd= '+ NewTargD + 'u= '+ NewTargU );
                NewTargC =( CurrentQ *  (Integer.valueOf(arList.get('targC'))));  
                NewTargD =(CurrentQ * (Integer.valueOf(arList.get('targD'))));
                NewTargU =(CurrentQ * (Integer.valueOf(arList.get('targU'))));
                NewName ='Total'; 
                System.debug(currentQ + ' currentQ   ' + '  c= ' + NewTargC + '  d= '+ NewTargD + '  u= '+ NewTargU );   
            }ELSE{
                NewName = (String.valueOf(arList.get('Qnames')));
                NewTargC =  (Integer.valueOf(arList.get('targC')));  
                NewTargD = (Integer.valueOf(arList.get('targD')));
                NewTargU = (Integer.valueOf(arList.get('targU')));   
            }
            //Integer Target = 6;
            ESqQueryTotals.add(new CMSWrapper(String.valueOf(NewName), (Integer.valueOf(arList.get('cmID'))), 
                                              (Integer.valueOf(arList.get('DupeContactCNT'))),(Integer.valueOf(arList.get('ContactCNT'))), 
                                              ((Integer.valueOf(arList.get('ContactCNT')))- 0), String.valueOf(NewName),
                                              String.valueOf(NewName), String.valueOf(NewName),
                                              Integer.valueOf(NewTargC), Integer.valueOf(NewTargD), Integer.valueOf(NewTargU)));  
            // Target not being used right now 
        }
        
        System.debug('ESq= ' + ESqQueryTotals.size()); 
        System.debug('ESq= ' + ESqQueryTotals);
        return ESqQueryTotals;
        
    } 
    
    
    
    /*******************************************************************
* Wrapper 

*******************************************************************/
    
    
    public with sharing class CMSWrapper {
        public String ES {get; set;}
        public Integer CampsC {get; set;}
        public Integer ConTactD1 {get; set;}
        public Integer ConTactDistinctU1 {get; set;}
        public Integer Target1 {get; set;}
        public String cString {get; set;}
        public String cDte {get; set;}
        public String campLink {get; set;}
        public Integer TargetC {get; set;}
        public Integer TargetU {get; set;}
        public Integer TargetD {get; set;}
        
        public CMSWrapper(String str, Integer numC,Integer numD, Integer numU, Integer tar, String txt, String dte, String cLk, Integer tarC, Integer tarD, Integer tarU ) {
            ES=str;
            CampsC =numC;
            ConTactD1 =numD;
            ConTactDistinctU1 =numU;
            Target1 = tar;
            cString=txt;
            cDte=dte;
            campLink=cLk;
            TargetC=tarC;
            TargetD=tarD;
            TargetU=tarU;
            
            
        }  
        
    }
}