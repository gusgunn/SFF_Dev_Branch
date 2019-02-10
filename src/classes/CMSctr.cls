public class CMSctr {
    //On Sublime Novo 
    // Move ES4 6 & 7- all workshops & ES8 (& Add outreach?- All Joe) -    phoneline -put with I&r 
    // // And Childcare and all other ES.
    //Add 11 definitions for kid tracking
    //add clear and tag contacts
    //remember pmp interactions are going to FRS and FS as regular interactions
    // Winter17  sandbox & SublimeNovo: 5-10-17
    //Done
    // Uploads: default on targets, workflow for CMSQ DONE
    // Formulas for CMS_Name__c   DOne on interations
    // Need To Set Targets- Done- Workflow-can be changed ** Will null pointer without targets
    //  need CMSNAme?? Test ** Will null pointer without
    // Need to make lookup for activity codes
    
    
    
    // TAG with setcon. Can use 1 query for all events excpt child attendee (And childcare?) And 1 for all interactions
    
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
    public integer es1UndupeFY =0;
    public integer es2UndupeFY =0;
    public integer es3UndupeFY =0;
    public integer es3k5UndupeFY =0;
    public integer es3k6UndupeFY =0;
    
    
    public CMSctr(){
        setConMaster.clear();
        Date DefaultDateTo = date.newinstance(2016, 9, 30);
        Date DefaultDateFrom = date.newinstance(2016, 7, 1);
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
        //clearTags();
        getGenerateES1Undupe();
        getGenerateES2Undupe();
        getGenerateES3Undupe();
        getGenerateES3K5Undupe();
        getGenerateES3K6Undupe();
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
    
    /**********************************/
    // Generate prior
    //     /*********************************/
    //es1 unduplicated fy
   private  void getGenerateES1Undupe() {
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
                                                    AND campaign.CMSName__c ='ES1'
                                                   // GROUP BY rollup(campaign.CMSQ__c)
                                                   ]; 

        for (campaignmember c : PriorContacts) {
            PriorContactCount.add(c.contact.id);
           
           } 
          es1UndupeFY = PriorContactCount.size();
            
        
    }   

    private  void getGenerateES2Undupe() {
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
                                                    AND campaign.CMSName__c ='ES2'
                                                   // GROUP BY rollup(campaign.CMSQ__c)
                                                   ]; 

        for (campaignmember c : PriorContacts) {
            PriorContactCount.add(c.contact.id);
           
           } 
          es2UndupeFY = PriorContactCount.size();   
        
    }   
    private  void getGenerateES3Undupe() {
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
                                                    AND campaign.CMSName__c ='ES3'
                                                   // GROUP BY rollup(campaign.CMSQ__c)
                                                   ]; 

        for (campaignmember c : PriorContacts) {
            PriorContactCount.add(c.contact.id);
           
           } 
          es3UndupeFY = PriorContactCount.size();
            
        
    }   
    private  void getGenerateES3K5Undupe() {
        set<String> PriorContactCount = new set <String>();
        List <campaignmember> PriorContacts = [SELECT   contact.ID              
                                                    FROM campaignmember
                                                    WHERE Event_Date__c >= :dateFrom  AND Event_Date__c <= :PriorQuarterEnds
                                                    AND No_Show__c = false
                                                    AND Status = 'Child Attendee'
                                                    And AgeMonthsAtCampaign__c < 72
                                                    ANd AgeMonthsAtCampaign__c != NULL
                                                    AND (campaign.status = 'Completed' OR campaign.status = 'Data In Except Survey' )
                                                    AND (NOT campaign.Name Like '%Childcare%')
                                                    AND (NOT campaign.Name Like '%Cancelled%')
                                                    AND (NOT campaign.Name Like '%No Show%')
                                                    AND (NOT campaign.Name Like '%Postponed%')
                                                    AND campaign.Project_or_Funder__c INCLUDES ('Family Support')
                                                    AND campaign.CMSName__c ='ES3'
                                                   // GROUP BY rollup(campaign.CMSQ__c)
                                                   ]; 

        for (campaignmember c : PriorContacts) {
            PriorContactCount.add(c.contact.id);
           
           } 
          es3K5UndupeFY = PriorContactCount.size();
            
        
    }   

 private  void getGenerateES3K6Undupe() {
        set<String> PriorContactCount = new set <String>();
        List <campaignmember> PriorContacts = [SELECT   contact.ID              
                                                    FROM campaignmember
                                                    WHERE Event_Date__c >= :dateFrom  AND Event_Date__c <= :PriorQuarterEnds
                                                    AND No_Show__c = false
                                                    AND Status = 'Child Attendee'
                                                    And AgeMonthsAtCampaign__c < 216
                                                    ANd AgeMonthsAtCampaign__c > 71
                                                    AND (campaign.status = 'Completed' OR campaign.status = 'Data In Except Survey' )
                                                    AND (NOT campaign.Name Like '%Childcare%')
                                                    AND (NOT campaign.Name Like '%Cancelled%')
                                                    AND (NOT campaign.Name Like '%No Show%')
                                                    AND (NOT campaign.Name Like '%Postponed%')
                                                    AND campaign.Project_or_Funder__c INCLUDES ('Family Support')
                                                    AND campaign.CMSName__c ='ES3'
                                                   // GROUP BY rollup(campaign.CMSQ__c)
                                                   ]; 

        for (campaignmember c : PriorContacts) {
            PriorContactCount.add(c.contact.id);
           
           } 
          es3K6UndupeFY = PriorContactCount.size();
            
        
    }   
    /*************************************
* generate ES set -use id string instead of ex_contact__c
******************************************/
    public List<CMSWrapper> getGenerateES1() {
        
        // get current count ES dateTo. Limit SetCon
        list<CMSWrapper> ESQueryTotals = new List <CMSWrapper>();
        List<AggregateResult> ESAggregateResult = [SELECT  campaign.CMSQ__c Qnames,  Count_Distinct(campaign.id) cmID, 
                                                    Count(contactId) DupeContactCNT , Count_Distinct(contactId) ContactCNT, 
                                                    Max(campaign.Campaign_Target__c) targC, 
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
                                                    AND campaign.CMSName__c ='ES1'
                                                    GROUP BY rollup(campaign.CMSQ__c)
                                                   ]; 
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
                System.Debug(' unduplicated contacts total ' + Integer.valueOf(arList.get('ContactCNT')));
                UnDupeAllTotal = (Integer.valueOf(arList.get('ContactCNT')));
                System.Debug('UnDupeAllTotal & es1UndupeFY  ' + UnDupeAllTotal +' ' + es1UndupeFY);
                UndupedQTotal =  UnDupeAllTotal - es1UndupeFY;
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
        
        System.debug('ES1= ' + ESQueryTotals.size()); 
        System.debug('ES1= ' + ESQueryTotals);
        return ESQueryTotals;
        
    }   


    
    // ES2
    public List<CMSWrapper> getGenerateES2() {
        
        // get current count ES dateTo. Limit SetCon
        list<CMSWrapper> ESQueryTotals = new List <CMSWrapper>();
        List<AggregateResult> ESAggregateResult = [SELECT  campaign.CMSQ__c Qnames,  Count_Distinct(campaign.id) cmID, Count(contactId) DupeContactCNT ,
                                                    Count_Distinct(contactId) ContactCNT, Max(campaign.Campaign_Target__c) targC, 
                                                    Max(campaign.Duplicated_Target__c) targD, Max(campaign.Unduplicated_Target__c) targU                
                                                    FROM campaignmember
                                                    WHERE campaign.Start_Date_Time__c >= :dateFrom  AND campaign.Start_Date_Time__c  <= :dateTo
                                                    AND No_Show__c = false
                                                    AND Status = 'Family Attendee'
                                                    AND (campaign.status = 'Completed' OR campaign.status = 'Data In Except Survey' )
                                                    AND (NOT campaign.Name Like '%Childcare%')
                                                    AND (NOT campaign.Name Like '%Cancelled%')
                                                    AND (NOT campaign.Name Like '%No Show%')
                                                    AND (NOT campaign.Name Like '%Postponed%')
                                                    AND campaign.Project_or_Funder__c INCLUDES ('Family Support')
                                                    AND campaign.CMSName__c ='ES2'
                                                    GROUP BY rollup(campaign.CMSQ__c)
                                                   ]; 
        
        String NewName ='';
        Integer NewTargC=1;
        Integer NewTargD=1;
        Integer NewTargU=1;
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
                System.Debug('Line 191: unduplicated contacts total ' + Integer.valueOf(arList.get('ContactCNT')));
                UnDupeAllTotal = (Integer.valueOf(arList.get('ContactCNT')));
                System.Debug('Line 193: UnDupeAllTotal & es2UndupeFY  ' + UnDupeAllTotal +' ' + es2UndupeFY);
                UndupedQTotal =  UnDupeAllTotal - es2UndupeFY;
                System.Debug('Line 195: UndupedQTotal ' + UndupedQTotal);
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
        System.debug('ES2= ' + ESQueryTotals.size()); 
        System.debug('ES2= ' + ESQueryTotals);
        return ESQueryTotals;
        
    }   
    
    // ES3
    public List<CMSWrapper> getGenerateES3() {
        
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
                                                    AND campaign.CMSName__c ='ES3'
                                                    GROUP BY rollup(campaign.CMSQ__c)
                                                   ]; 
        System.Debug('*******************ESAggregateResult= '+ ESAggregateResult.size());
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
                System.Debug('Line 191: unduplicated contacts total ' + Integer.valueOf(arList.get('ContactCNT')));
                UnDupeAllTotal = (Integer.valueOf(arList.get('ContactCNT')));
                System.Debug('Line 193: UnDupeAllTotal & es3UndupeFY  ' + UnDupeAllTotal +' ' + es3UndupeFY);
                UndupedQTotal =  UnDupeAllTotal - es3UndupeFY;
                System.Debug('Line 195: UndupedQTotal ' + UndupedQTotal);
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
        System.debug('ES3= ' + ESQueryTotals.size()); 
        System.debug('ES3= ' + ESQueryTotals);
        return ESQueryTotals;
        
    } 
    
    // ES3
    public List<CMSWrapper> getGenerateES3Kids5() {
        
        // get current count ES dateTo. Limit SetCon
        list<CMSWrapper> ESQueryTotals = new List <CMSWrapper>();
        List<AggregateResult> ESAggregateResult = [SELECT  campaign.CMSQ__c Qnames,  Count_Distinct(campaign.id) cmID, Count(contactId) DupeContactCNT ,
                                                    Count_Distinct(contactId) ContactCNT, Max(campaign.Campaign_Target__c) targC, 
                                                    Max(campaign.Duplicated_Target__c) targD, Max(campaign.Unduplicated_Target__c) targU                
                                                    FROM campaignmember
                                                    WHERE Event_Date__c >= :dateFrom  AND Event_Date__c <= :dateTo
                                                    AND No_Show__c = false
                                                    AND Status = 'Child Attendee'
                                                    AND AgeMonthsAtCampaign__c < 72
                                                    AND AgeMonthsAtCampaign__c != NULL
                                                    AND (campaign.status = 'Completed' OR campaign.status = 'Data In Except Survey' )
                                                    AND (NOT campaign.Name Like '%Childcare%')
                                                    AND (NOT campaign.Name Like '%Cancelled%')
                                                    AND (NOT campaign.Name Like '%No Show%')
                                                    AND (NOT campaign.Name Like '%Postponed%')
                                                    AND campaign.Project_or_Funder__c INCLUDES ('Family Support')
                                                    AND campaign.CMSName__c ='ES3'
                                                    GROUP BY rollup(campaign.CMSQ__c)
                                                   ]; 
        System.Debug('*******************ESAggregateResult= '+ ESAggregateResult.size());
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
                System.Debug('Line 191: unduplicated contacts total ' + Integer.valueOf(arList.get('ContactCNT')));
                UnDupeAllTotal = (Integer.valueOf(arList.get('ContactCNT')));
                System.Debug('Line 193: UnDupeAllTotal & es3k5UndupeFY  ' + UnDupeAllTotal +' ' + es3k5UndupeFY);
                UndupedQTotal =  UnDupeAllTotal - es3k5UndupeFY;
                System.Debug('Line 195: UndupedQTotal ' + UndupedQTotal);
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
        System.debug('ES3= ' + ESQueryTotals.size()); 
        System.debug('ES3= ' + ESQueryTotals);
        return ESQueryTotals;
        
    } 
    
    // ES3 6 - 17
    public List<CMSWrapper> getGenerateES3Kids6() {
        
        // get current count ES dateTo. Limit SetCon
        list<CMSWrapper> ESQueryTotals = new List <CMSWrapper>();
        List<AggregateResult> ESAggregateResult = [SELECT  campaign.CMSQ__c Qnames,  Count_Distinct(campaign.id) cmID, Count(contactId) DupeContactCNT ,
                                                    Count_Distinct(contactId) ContactCNT, Max(campaign.Campaign_Target__c) targC, 
                                                    Max(campaign.Duplicated_Target__c) targD, Max(campaign.Unduplicated_Target__c) targU                
                                                    FROM campaignmember
                                                    WHERE Event_Date__c >= :dateFrom  AND Event_Date__c <= :dateTo
                                                    AND No_Show__c = false
                                                    AND Status = 'Child Attendee'
                                                    AND AgeMonthsAtCampaign__c < 215
                                                    AND AgeMonthsAtCampaign__c > 71
                                                    AND AgeMonthsAtCampaign__c != NULL
                                                    AND (campaign.status = 'Completed' OR campaign.status = 'Data In Except Survey' )
                                                    AND (NOT campaign.Name Like '%Childcare%')
                                                    AND (NOT campaign.Name Like '%Cancelled%')
                                                    AND (NOT campaign.Name Like '%No Show%')
                                                    AND (NOT campaign.Name Like '%Postponed%')
                                                    AND campaign.Project_or_Funder__c INCLUDES ('Family Support')
                                                    AND campaign.CMSName__c ='ES3'
                                                    GROUP BY rollup(campaign.CMSQ__c)
                                                   ]; 
        System.Debug('*******************ES3KidAggregateResult= '+ ESAggregateResult.size());
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
                System.Debug('Line 191: unduplicated contacts total ' + Integer.valueOf(arList.get('ContactCNT')));
                UnDupeAllTotal = (Integer.valueOf(arList.get('ContactCNT')));
                System.Debug('Line 193: UnDupeAllTotal & es3K6UndupeFY  ' + UnDupeAllTotal +' ' + es3K6UndupeFY);
                UndupedQTotal =  UnDupeAllTotal - es3K6UndupeFY;
                System.Debug('Line 195: UndupedQTotal ' + UndupedQTotal);
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
        System.debug('ES3= ' + ESQueryTotals.size()); 
        System.debug('ES3= ' + ESQueryTotals);
        return ESQueryTotals;
        
    } 
 
    
    /*************************************************** */
    // get List Of ES1 Campaigns that feed the Board 
    
    public List<CMSWrapper> getGenerateES1List() {
        list<CMSWrapper> ES1ListQueryTotals = new List <CMSWrapper>();
        List<Campaign> ES1List = [SELECT  name,  Number_of_Minutes__c,  TotalCareGiversAttended__c, TotalChildrenAttended__c, 
                                  TotalCommunityMembersAttendedCMS__c, TotalProfessionalsAttendedCMS__c, Number_of_Parent_Family_Evaluations__c, 
                                  Start_Date_Time__c, ID         
                                  FROM campaign
                                  //Current Quarter only
                                  WHERE Start_Date_Time__c > :PriorQuarterEnds  AND Start_Date_Time__c <= :dateTo
                                  // AND No_Show__c = false
                                  //AND Status = 'Family Attendee'
                                  AND (campaign.status = 'Completed' OR campaign.status = 'Data In Except Survey' )
                                  AND (NOT Name Like '%Childcare%')
                                  AND (NOT Name Like '%Cancelled%')
                                  AND (NOT Name Like '%No Show%')
                                  AND (NOT campaign.Name Like '%Postponed%')
                                  AND Project_or_Funder__c INCLUDES ('Family Support')
                                  
                                  AND CMSName__c ='ES1'
                                  //GROUP BY name
                                  ORDER BY name ASC 
                                 ];
        
        
        for (Campaign arList : ES1List) { 
            
            //String.valueOf(arList.get('Qnames'));
            Integer Target = 6;
            ES1ListQueryTotals.add(new CMSWrapper(arList.Name,  Integer.valueOf(arList.TotalCareGiversAttended__c ), Integer.valueOf(arList.TotalCareGiversAttended__c), 
                                                  Integer.valueOf(arList.Number_of_Parent_Family_Evaluations__c), Integer.valueOf(arList.TotalCareGiversAttended__c),
                                                  String.valueOf(arList.Start_Date_Time__c.date()), String.valueOf(arList.Start_Date_Time__c.date()), String.valueOf(arList.ID),
                                                  Integer.valueOf(arlist.TotalCareGiversAttended__c), Integer.valueOf(arList.TotalCareGiversAttended__c), Integer.valueOf(arList.TotalCareGiversAttended__c)));
            
        }
        return ES1ListQueryTotals;
    }   
    // get List Of ES1 Campaigns that are not on the Board 
    
    public List<CMSWrapper> getGenerateES1NoList() {
        list<CMSWrapper> ES1NoListQueryTotals = new List <CMSWrapper>();
        List<campaign> ES1NoList = [SELECT Name,  Start_Date_Time__c, Number_of_Minutes__c, Unduplicated_Campaign__c, TotalCareGiversAttended__c, status, ID,TotalChildrenAttended__c
                                    //  *****************current Quarter only
                                    FROM campaign
                                    WHERE Start_Date_Time__c > :PriorQuarterEnds  AND Start_Date_Time__c <= :dateTo
                                    AND campaign.status != 'Completed' 
                                    AND campaign.status != 'Data In Except Survey' 
                                    AND (NOT Name Like '%Childcare%')
                                    AND Project_or_Funder__c INCLUDES ('Family Support')
                                    AND CMSName__c ='ES1'
                                    ORDER BY campaign.status Desc
                                   ];
        
        
        for (campaign arList : ES1NoList) { 
            
            
            Integer Intfill = 1;
            ES1NoListQueryTotals.add(new CMSWrapper(arList.Name,  Integer.valueOf(arList.Number_of_Minutes__c ),Integer.valueOf(arList.Number_of_Minutes__c), 
                                                    Integer.valueOf(arList.Unduplicated_Campaign__c), Integer.valueOf(arList.TotalCareGiversAttended__c),
                                                    String.valueOf(arList.status), String.valueOf(arList.Start_Date_Time__c.date()), String.valueOf(arList.ID),
                                                    Integer.valueOf(arlist.TotalChildrenAttended__c), Integer.valueOf(arList.TotalChildrenAttended__c), Integer.valueOf(arList.TotalChildrenAttended__c)));
            System.debug('NoList= ' + ES1NoListQueryTotals.size()); 
            System.debug('NoList= ' + ES1NoListQueryTotals);
        }
        return ES1NoListQueryTotals;
    }    
    /********************************************************** 
*/
    
    
    //Campains By status
    public List<CMSWrapper> getGenerateES1Pie() {
        list<CMSWrapper> ES1PieQueryTotals = new List <CMSWrapper>();
        List<campaign> ES1PieLists = [SELECT CMSQ__c,  name, Start_Date_Time__c, Number_of_Minutes__c, Unduplicated_Campaign__c, TotalChildrenAttended__c, status, ID,
                                      Campaign_Target__c, Duplicated_Target__c, Unduplicated_Target__c 
                                      FROM campaign
                                      WHERE Start_Date_Time__c > :PriorQuarterEnds  AND Start_Date_Time__c <= :dateTo
                                      //AND (campaign.status != 'Completed')
                                      AND Project_or_Funder__c INCLUDES ('Family Support')
                                      AND CMSName__c ='ES1'       
                                      ORDER BY status 
                                     ];
        
        
        for (campaign arList : ES1PieLists) { 
            Integer Target = 0;
            ES1PieQueryTotals.add(new CMSWrapper(String.valueOf('Q' + arList.CMSQ__c),  Integer.valueOf(arList.Number_of_Minutes__c ),Integer.valueOf(arList.TotalChildrenAttended__c), 
                                                 Integer.valueOf(arList.Unduplicated_Campaign__c), Integer.valueOf(arList.TotalChildrenAttended__c),
                                                 arList.name, String.valueOf(arList.Start_Date_Time__c.date()), String.valueOf(arList.ID),(Integer.valueOf(arList.Campaign_Target__c)),
                                                 (Integer.valueOf(arList.Duplicated_Target__c)), (Integer.valueOf(arList.Unduplicated_Target__c))));
            // System.debug('NoList= ' + ES1NoListQueryTotals.size()); 
            System.debug('Pie= ' + ES1PieQueryTotals);
        }
        return ES1PieQueryTotals;
    }   
    
    
    /*******************************************************************

/*************************************************** */
    // get List Of ES2 Campaigns that feed the Board 
    
    public List<CMSWrapper> getGenerateES2List() {
        list<CMSWrapper> ES2ListQueryTotals = new List <CMSWrapper>();
        List<Campaign> ES2List = [SELECT  name,  Number_of_Minutes__c,  TotalCareGiversAttended__c, Number_of_Parent_Family_Evaluations__c, 
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
                                  
                                  AND CMSName__c ='ES2'
                                  //GROUP BY name
                                  ORDER BY name ASC 
                                 ];
        
        
        for (Campaign arList : ES2List) { 
            Integer Target = 6;
            ES2ListQueryTotals.add(new CMSWrapper(arList.Name,  Integer.valueOf(arList.TotalCareGiversAttended__c ), Integer.valueOf(arList.TotalCareGiversAttended__c), 
                                                  Integer.valueOf(arList.Number_of_Parent_Family_Evaluations__c), Integer.valueOf(arList.TotalCareGiversAttended__c),
                                                  String.valueOf(arList.Start_Date_Time__c.date()), String.valueOf(arList.Start_Date_Time__c.date()), String.valueOf(arList.ID),
                                                  Integer.valueOf(arlist.TotalCareGiversAttended__c), Integer.valueOf(arList.TotalCareGiversAttended__c), Integer.valueOf(arList.TotalCareGiversAttended__c)));
            
        }
        return ES2ListQueryTotals;
    }   
    // get List Of ES2 Campaigns that are not on the Board 
    
    public List<CMSWrapper> getGenerateES2NoList() {
        list<CMSWrapper> ES2NoListQueryTotals = new List <CMSWrapper>();
        List<campaign> ES2NoList = [SELECT Name,  Start_Date_Time__c, TotalCareGiversAttended__c, Number_of_Minutes__c, Unduplicated_Campaign__c, NumberOfContacts, status, ID,TotalChildrenAttended__c
                                    // Current Quarter only
                                    FROM campaign
                                    WHERE Start_Date_Time__c > :PriorQuarterEnds  AND Start_Date_Time__c <= :dateTo
                                    AND campaign.status != 'Completed'
                                    AND campaign.status != 'Data In Except Survey' 
                                    AND (NOT Name Like '%Childcare%')
                                    AND Project_or_Funder__c INCLUDES ('Family Support')
                                    AND CMSName__c ='ES2'
                                    ORDER BY campaign.status Desc
                                   ];
        
        
        for (campaign arList : ES2NoList) { 
            
            
            Integer Target = 0;
            ES2NoListQueryTotals.add(new CMSWrapper(arList.Name,  Integer.valueOf(arList.Number_of_Minutes__c ),Integer.valueOf(arList.Number_of_Minutes__c), 
                                                    Integer.valueOf(arList.Unduplicated_Campaign__c), Integer.valueOf(arList.TotalCareGiversAttended__c),
                                                    String.valueOf(arList.status), String.valueOf(arList.Start_Date_Time__c), String.valueOf(arList.ID),
                                                    Integer.valueOf(arlist.TotalChildrenAttended__c), Integer.valueOf(arList.TotalChildrenAttended__c), Integer.valueOf(arList.TotalChildrenAttended__c)));
            System.debug('NoList= ' + ES2NoListQueryTotals.size()); 
            System.debug('NoList= ' + ES2NoListQueryTotals);
        }
        return ES2NoListQueryTotals;
    }   
    //Campains By status
    public List<CMSWrapper> getGenerateES2Pie() {
        list<CMSWrapper> ES2PieQueryTotals = new List <CMSWrapper>();
        List<campaign> ES2PieLists = [SELECT CMSQ__c,  name, Start_Date_Time__c, Number_of_Minutes__c, Unduplicated_Campaign__c, TotalChildrenAttended__c, status, ID,
                                      Campaign_Target__c, Duplicated_Target__c, Unduplicated_Target__c 
                                      FROM campaign
                                      WHERE Start_Date_Time__c > :PriorQuarterEnds  AND Start_Date_Time__c <= :dateTo
                                      //AND (campaign.status != 'Completed')
                                      AND Project_or_Funder__c INCLUDES ('Family Support')
                                      AND CMSName__c ='ES2'       
                                      ORDER BY status 
                                     ];
        
        
        for (campaign arList : ES2PieLists) { 
            Integer Target = 0;
            ES2PieQueryTotals.add(new CMSWrapper(String.valueOf('Q' + arList.CMSQ__c),  Integer.valueOf(arList.Number_of_Minutes__c ),Integer.valueOf(arList.TotalChildrenAttended__c), 
                                                 Integer.valueOf(arList.Unduplicated_Campaign__c), Integer.valueOf(arList.TotalChildrenAttended__c),
                                                 arList.name, String.valueOf(arList.Start_Date_Time__c.date()), String.valueOf(arList.ID),(Integer.valueOf(arList.Campaign_Target__c)),
                                                 (Integer.valueOf(arList.Duplicated_Target__c)), (Integer.valueOf(arList.Unduplicated_Target__c))));
            // System.debug('NoList= ' + ES1NoListQueryTotals.size()); 
            System.debug('Pie2= ' + ES2PieQueryTotals);
        }
        return ES2PieQueryTotals;
    }   
    /********************************************************************************/
    // get List Of ES3 Campaigns that feed the Board 
    
    public List<CMSWrapper> getGenerateES3List() {
        list<CMSWrapper> ES3ListQueryTotals = new List <CMSWrapper>();
        List<Campaign> ES3List = [SELECT  name,  Number_of_Minutes__c,  TotalCareGiversAttended__c, Number_of_Parent_Family_Evaluations__c, 
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
                                  
                                  AND CMSName__c ='ES3'
                                  //GROUP BY name
                                  ORDER BY name ASC 
                                 ];
        
        
        for (Campaign arList : ES3List) { 
            Integer Target = 6;
            ES3ListQueryTotals.add(new CMSWrapper(arList.Name,  Integer.valueOf(arList.TotalCareGiversAttended__c ), Integer.valueOf(arList.TotalCareGiversAttended__c), 
                                                  Integer.valueOf(arList.Number_of_Parent_Family_Evaluations__c), Integer.valueOf(arList.TotalCareGiversAttended__c),
                                                  String.valueOf(arList.Start_Date_Time__c.date()), String.valueOf(arList.Start_Date_Time__c.date()), String.valueOf(arList.ID),
                                                  Integer.valueOf(arlist.TotalCareGiversAttended__c), Integer.valueOf(arList.TotalCareGiversAttended__c), Integer.valueOf(arList.TotalCareGiversAttended__c)));
            
        }
        return ES3ListQueryTotals;
    }   
    
    /*************************************************************************/
    // get List Of ES3 Campaigns that are not on the Board 
    
    public List<CMSWrapper> getGenerateES3NoList() {
        list<CMSWrapper> ESNoListQueryTotals = new List <CMSWrapper>();
        List<campaign> ESNoList = [SELECT Name,  Start_Date_Time__c, TotalCareGiversAttended__c, Number_of_Minutes__c, Unduplicated_Campaign__c, NumberOfContacts, status, ID,TotalChildrenAttended__c
                                   // Current Quarter only
                                   FROM campaign
                                   WHERE Start_Date_Time__c > :PriorQuarterEnds  AND Start_Date_Time__c <= :dateTo
                                   AND (campaign.status != 'Completed')
                                   AND (campaign.status != 'Data In Except Survey' )
                                   AND (NOT Name Like '%Childcare%')
                                   AND Project_or_Funder__c INCLUDES ('Family Support')
                                   AND CMSName__c ='ES3'
                                   ORDER BY campaign.status Desc
                                  ];
        
        
        for (campaign arList : ESNoList) { 
            
            
            Integer Target = 0;
            ESNoListQueryTotals.add(new CMSWrapper(arList.Name,  Integer.valueOf(arList.Number_of_Minutes__c ),Integer.valueOf(arList.Number_of_Minutes__c), 
                                                   Integer.valueOf(arList.Unduplicated_Campaign__c), Integer.valueOf(arList.TotalCareGiversAttended__c),
                                                   String.valueOf(arList.status), String.valueOf(arList.Start_Date_Time__c), String.valueOf(arList.ID),
                                                   Integer.valueOf(arlist.TotalChildrenAttended__c), Integer.valueOf(arList.TotalChildrenAttended__c), Integer.valueOf(arList.TotalChildrenAttended__c)));
            System.debug('NoList= ' + ESNoListQueryTotals.size()); 
            System.debug('NoList= ' + ESNoListQueryTotals);
        }
        return ESNoListQueryTotals;
    }   
    //Campains By status ES3
    public List<CMSWrapper> getGenerateES3Pie() {
        list<CMSWrapper> ES3PieQueryTotals = new List <CMSWrapper>();
        List<campaign> ES3PieLists = [SELECT CMSQ__c,  name, Start_Date_Time__c, Number_of_Minutes__c, Unduplicated_Campaign__c, TotalChildrenAttended__c, status, ID,
                                      Campaign_Target__c, Duplicated_Target__c, Unduplicated_Target__c 
                                      FROM campaign
                                      WHERE Start_Date_Time__c > :PriorQuarterEnds  AND Start_Date_Time__c <= :dateTo
                                      //AND (campaign.status != 'Completed')
                                      AND Project_or_Funder__c INCLUDES ('Family Support')
                                      AND CMSName__c ='ES3'       
                                      ORDER BY status 
                                     ];
        
        
        for (campaign arList : ES3PieLists) { 
            Integer Target = 0;
            ES3PieQueryTotals.add(new CMSWrapper(String.valueOf('Q' + arList.CMSQ__c),  Integer.valueOf(arList.Number_of_Minutes__c ),Integer.valueOf(arList.TotalChildrenAttended__c), 
                                                 Integer.valueOf(arList.Unduplicated_Campaign__c), Integer.valueOf(arList.TotalChildrenAttended__c),
                                                 arList.name, String.valueOf(arList.Start_Date_Time__c.date()), String.valueOf(arList.ID),(Integer.valueOf(arList.Campaign_Target__c)),
                                                 (Integer.valueOf(arList.Duplicated_Target__c)), (Integer.valueOf(arList.Unduplicated_Target__c))));
            // System.debug('NoList= ' + ES1NoListQueryTotals.size()); 
            System.debug('Pie3= ' + ES3PieQueryTotals);
        }
        return ES3PieQueryTotals;
    }   
    
    
   
    /********************************************************************************/
   
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
    /*
// get List Of FS Campaigns that are not on the Board 

public List<CMSWrapper> getGenerateUnAss() {
list<CMSWrapper> UnAssQueryTotals = new List <CMSWrapper>();
List<campaign> UnAss = [SELECT Name, Start_Date_Time__c, Number_of_Minutes__c, status, Project_or_Funder__c,
ID,TotalChildrenAttended__c, IsActive, OwnerID,  CMSName__c,
NumberOfContacts, Presentation_Language__c, Family__Total_Professional_Campaign_Members__c
// Current Quarter only
FROM campaign
WHERE Start_Date_Time__c >: PriorQuarterEnds AND Start_Date_Time__c <= :dateTo 
// AND (campaign.status != 'Completed')
AND Project_or_Funder__c INCLUDES ('Family Support')
AND CMSName__c = ''
ORDER BY campaign.status Desc
];


for (campaign arList : UnAss) { 


Integer Intfill = 1;
UnAssQueryTotals.add(new CMSWrapper(arList.Name,  Integer.valueOf(arList.Start_Date_Time__c.date()),Integer.valueOf(arList.Number_of_Minutes__c), 
Integer.valueOf(arList.Unduplicated_Campaign__c), Integer.valueOf(arList.Start_Date_Time__c.date()),
String.valueOf(arList.status), String.valueOf(arList.CMSName__c), String.valueOf(arList.ID),
Integer.valueOf(arlist.TotalChildrenAttended__c), Integer.valueOf(arList.TotalChildrenAttended__c), Integer.valueOf(arList.TotalChildrenAttended__c)));
System.debug('UnAss= ' + UnAssQueryTotals.size()); 
System.debug('UnAss= ' + UnAssQueryTotals);
}
return UnAssQueryTotals;  
}    */ 

    
    
    
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