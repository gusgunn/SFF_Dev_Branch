public class AnnualReportAge_Int {

    
    
    // Winter17 has 1_17BKP
    // Use this as Q1- Rewrite test for Q2 and beyond
    // Date From
    // public Date dateFrom {get; set;}
    
    public Date dateFrom {get; set;}
//public Date dateFrom {get; set;}
    
    // Date To
    public Date dateTo {get; set;}
    
    //public Date priorMonthEnd;
    public Date Q1Ends;
    public Date Q2Ends; 
    public Date Q3Ends; 
    public Date Q4Ends; 
    public Date PriorQuarterEnds;
    
    public Integer dateFromSelected;
    Public Integer dateFromSecond;
    
    
    private Set<String> setConMaster = new Set<String>();
   private Set<String> setConPrior18 = new Set<String>();
    private Set<String> setConCurrent18 = new Set<String>();
    
    private Set<String> setConPriorNoAge = new Set<String>();
    private Set<String> setConCurrentNoAge = new Set<String>();
    
    private Set<String> setConPrior = new Set<String>();
    private Set<String> setConCurrent = new Set<String>(); 
    
    private Set<String> setConPrior2 = new Set<String>();
    private Set<String> setConCurrent2 = new Set<String>();
    
    private Set<String> setConPrior3 = new Set<String>();
    private Set<String> setConCurrent3 = new Set<String>();
    
    
    private Set<String> setConPrior4 = new Set<String>();
    private Set<String> setConCurrent4 = new Set<String>();
    
    private Set<String> setConPrior5 = new Set<String>();
    private Set<String> setConCurrent5 = new Set<String>();
    
    private Set<String> setConPrior6 = new Set<String>();
    private Set<String> setConCurrent6 = new Set<String>();
    
    private Set<String> setConPrior7 = new Set<String>();
    private Set<String> setConCurrent7 = new Set<String>();
    
    private Set<String> setConPrior8 = new Set<String>();
    private Set<String> setConCurrent8 = new Set<String>();
     private Set<String> setConCurrent7yrs = new Set<String>();
     private Set<String> setConCurrent8yrs = new Set<String>();
    private Set<String> setConPrior8Yrs = new Set<String>();
    private Set<String> setConPrior7yrs = new Set<String>();
    
    
    //private Map<ID,ID> espKidHH  =  new Map<ID,ID>();
    Private String pmpVar ='PMP' + '%';
    
    private Map<ID,ID> parentsHH  =  new Map<ID,ID>();
    private Map<ID,ID> espKidHHPrior =  new Map<ID,ID>();
    private Map<ID,ID> parentsHHPrior =  new Map<ID,ID>();
    private Set<String> ageDone = new Set<String>();
    
    
    
    public AnnualReportAge_Int(){
        
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
        
        dateFromSelected = (Integer.valueof(DateFrom.year()));
        dateFromSecond = (Integer.valueof(DateFrom.year() + 1));
        Q1Ends = date.newInstance(dateFromSelected, 9, 30 );
        Q2Ends = date.newInstance(dateFromSelected, 12, 31 );
        Q3Ends = date.newInstance(dateFromSecond, 3, 31 );
        Q4Ends = date.newInstance(dateFromSecond, 6, 30 );
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
                System.debug('priorquarterEnds= ' + PriorQuarterEnds);
            } 
        }
        initializeBoard();
        runBoard();
    }
    private void initializeBoard(){
         setConMaster.clear();
        setConPrior.clear();
        setConCurrent.clear();
        setConPrior2.clear();
        setConCurrent2.clear();
        setConPrior3.clear();
        setConCurrent3.clear();
        setConPrior4.clear();
        setConCurrent4.clear();
        setConPrior5.clear();
        setConCurrent5.clear();
        setConPrior6.clear();
        setConCurrent6.clear();
        setConPrior7.clear();
        setConCurrent7.clear();
        setConPrior8.clear();
        setConCurrent8.clear();
        setConCurrent18.clear();
        setConCurrentNoAge.clear();
        
        setConCurrent8yrs.clear();
        setConCurrent7yrs.clear();
        setConPrior8yrs.clear();
        setConPrior7yrs.clear();
    }
    
    // set dashboard values to zero in preparation for generation
    private void runboard() {
        
        GenerateKids8(); 
        GenerateKids7(); 
        GenerateKids6(); 
        GenerateKids5(); 
        GenerateKids4(); 
        GenerateKids3();
        GenerateKids2();
        GenerateKids7yrs();
        GenerateKids8yrs();
        GenerateKids();
        GenerateKids18_22();
        GenerateKidsNoAge();
            
    }
    
    private void GenerateKidsNoAge() {   
        
        // YTD: get kids between 9 through 17, listed in interactions, YTD
        List<case> limitCurrentConInteractions =[SELECT Family__Child__r.LastName, Family__Child__c
                                                 //, ContactID__r.Lastname
                                                 FROM case
                                                 WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                 
                                                 AND (AgeMonthCaseTime__c = NULL OR AgeMonthCaseTime__c >275)
                                                 AND Call_Type__c != 'Left Message 1'
                                                 AND Call_Type__c != 'Left Message 2'
                                                 AND Call_Type__c != '# disconnected'
                                                 AND Call_Type__c != 'No answering machine'
                                                 AND Call_Type__c != 'Sent UTC Letter'  
                                                 // AND conatctID__r.Lastname !='Neale'
                                                 //AND contact !='test'
                                                 AND Family__Child__r.LastName !='Neale'
                                                 AND Family__Child__r.LastName !='test'
                                                 AND Family__Child__c Not In:setConPrior
                                                 AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:pmpVar)  ];
        
        for(case cur: limitCurrentConInteractions){
            setConCurrentNoAge.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        
       /* // get kids  listed in Events YTD
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                     FROM campaignMember
                                                     WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                     
                                                     AND (AgeMonthsAtCampaign__c = NULL OR AgeMonthsAtCampaign__c >275)
                                                     AND contact.name !='Neale'
                                                     AND contact.name !='test'
                                                     AND campaign.Type !='SFIN'
                                                     AND No_Show__c = false
                                                     AND Status = 'Child Attendee'
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
                                                     AND contactID NOT IN: setConPrior
                                                    // AND (NOT campaign.Name Like '%Childcare%')
                                                     AND (NOT campaign.Name Like '%Cancelled%')
                                                     AND (NOT campaign.Name Like '%No Show%')
                                                     AND (NOT campaign.Name Like '%Postponed%')
                                                    ];
        
        for(campaignMember cm: limitCurContactEvents){
            
            setConCurrentNoAge.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        System.debug('setConCurrent Size NoAge  ' + setConCurrent.size());
         System.debug('setConprior  NoAge Size =' + setConPrior.size());
        
    } 
*/
    }
    private void GenerateKids18_22() {   
        
        // YTD: get kids between 9 through 17, listed in interactions, YTD
        List<case> limitCurrentConInteractions =[SELECT Family__Child__r.LastName, Family__Child__c
                                                 //, ContactID__r.Lastname
                                                 FROM case
                                                 WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                 And AgeMonthCaseTime__c>=216 AND AgeMonthCaseTime__c <=275
                                                 AND AgeMonthCaseTime__c != NULL
                                                 AND Call_Type__c != 'Left Message 1'
                                                 AND Call_Type__c != 'Left Message 2'
                                                 AND Call_Type__c != '# disconnected'
                                                 AND Call_Type__c != 'No answering machine'
                                                 AND Call_Type__c != 'Sent UTC Letter'  
                                                 // AND conatctID__r.Lastname !='Neale'
                                                 //AND contact !='test'
                                                 AND Family__Child__r.LastName !='Neale'
                                                 AND Family__Child__r.LastName !='test'
                                                 AND Family__Child__c Not In:setConPrior
                                                 AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:pmpVar)  ];
        
        for(case cur: limitCurrentConInteractions){
            setConCurrent18.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        /*
        // get kids  listed in Events YTD
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                     FROM campaignMember
                                                     WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                     And AgeMonthsAtCampaign__c>=216 AND AgeMonthsAtCampaign__c <=275
                                                     AND AgeMonthsAtCampaign__c !=NULL
                                                     AND contact.name !='Neale'
                                                     AND contact.name !='test'
                                                     AND No_Show__c = false
                                                     AND Status = 'Child Attendee'
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
                                                     AND contactID NOT IN: setConPrior
                                                     //AND (NOT campaign.Name Like '%Childcare%')
                                                     AND (NOT campaign.Name Like '%Cancelled%')
                                                     AND (NOT campaign.Name Like '%No Show%')
                                                     AND (NOT campaign.Name Like '%Postponed%')
                                                    ];
        
        for(campaignMember cm: limitCurContactEvents){
            
            setConCurrent18.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        System.debug('setConCurrent Size 18-22  ' + setConCurrent.size());
         System.debug('setConprior  18-22 yrs Size =' + setConPrior.size());
        */
    } 
    
    private void GenerateKids() {   
        
        // YTD: get kids between 9 through 17, listed in interactions, YTD
        List<case> limitCurrentConInteractions =[SELECT Family__Child__r.LastName, Family__Child__c
                                                 //, ContactID__r.Lastname
                                                 FROM case
                                                 WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                 And AgeMonthCaseTime__c>=108 AND AgeMonthCaseTime__c <=215
                                                 AND AgeMonthCaseTime__c != NULL
                                                 AND Call_Type__c != 'Left Message 1'
                                                 AND Call_Type__c != 'Left Message 2'
                                                 AND Call_Type__c != '# disconnected'
                                                 AND Call_Type__c != 'No answering machine'
                                                 AND Call_Type__c != 'Sent UTC Letter'  
                                                 // AND conatctID__r.Lastname !='Neale'
                                                 //AND contact !='test'
                                                 AND Family__Child__r.LastName !='Neale'
                                                 AND Family__Child__r.LastName !='test'
                                                 AND Family__Child__c Not In:setConPrior
                                                 AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:pmpVar)  ];
        
        for(case cur: limitCurrentConInteractions){
            setConCurrent.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        /*
        // get kids  listed in Events YTD
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                     FROM campaignMember
                                                     WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                     And AgeMonthsAtCampaign__c>=108 AND AgeMonthsAtCampaign__c <=215
                                                     AND AgeMonthsAtCampaign__c !=NULL
                                                     AND contact.name !='Neale'
                                                     AND contact.name !='test'
                                                     AND No_Show__c = false
                                                     AND Status = 'Child Attendee'
                                                     AND contactID NOT IN: setConPrior
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
                                                     //AND (NOT campaign.Name Like '%Childcare%')
                                                     AND (NOT campaign.Name Like '%Cancelled%')
                                                     AND (NOT campaign.Name Like '%No Show%')
                                                     AND (NOT campaign.Name Like '%Postponed%')
                                                    ];
        
        for(campaignMember cm: limitCurContactEvents){
            
            setConCurrent.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        System.debug('setConCurrent Size 9-17  ' + setConCurrent.size());
         System.debug('setConprior  9 yrs Size =' + setConPrior.size());
        */
    } 
    
    
    
    private void GenerateKids8yrs(){
        // YTD: get kids between 6 through 8 years, listed in interactions, YTD
        List<case> limitCurrentConInteractions2 =[SELECT Family__Child__c,Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=96 AND AgeMonthCaseTime__c <=107
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Call_Type__c != 'Sent UTC Letter' 
                                                  AND Family__Child__c NOT IN: setConPrior
                                                  AND Family__Child__r.LastName !='Neale'
                                                  AND Family__Child__r.LastName !='test'
                                                  AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:'PMP Initial' OR Call_Type__c LIKE:'PMP 2 mo' OR Call_Type__c LIKE:'pmp contact')   ];
        
        for(case cur: limitCurrentConInteractions2){
            setConCurrent8yrs.add(cur.Family__Child__c);
            setConPrior.add(Cur.Family__Child__c);
            
            
            
        }
    }
    
    private void GenerateKids7yrs(){
        // YTD: get kids between 6 through 8 years, listed in interactions, YTD
        List<case> limitCurrentConInteractions2 =[SELECT Family__Child__c,Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=84 AND AgeMonthCaseTime__c <=95
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Call_Type__c != 'Sent UTC Letter' 
                                                  AND Family__Child__c NOT IN: setConPrior
                                                  AND Family__Child__r.LastName !='Neale'
                                                  AND Family__Child__r.LastName !='test'
                                                  AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:'PMP Initial' OR Call_Type__c LIKE:'PMP 2 mo' OR Call_Type__c LIKE:'pmp contact')   ];
        
        for(case cur: limitCurrentConInteractions2){
            setConCurrent7yrs.add(cur.Family__Child__c);
            setConPrior.add(Cur.Family__Child__c);
            
            
            
        }
    }
    
    // 6   
    private void GenerateKids2(){
        // YTD: get kids between 6 through 8 years, listed in interactions, YTD
        List<case> limitCurrentConInteractions2 =[SELECT Family__Child__c,Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=72 AND AgeMonthCaseTime__c <=83
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Call_Type__c != 'Sent UTC Letter' 
                                                  AND Family__Child__c NOT IN: setConPrior
                                                  AND Family__Child__r.LastName !='Neale'
                                                  AND Family__Child__r.LastName !='test'
                                                  AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:'PMP Initial' OR Call_Type__c LIKE:'PMP 2 mo' OR Call_Type__c LIKE:'pmp contact')   ];
        
        for(case cur: limitCurrentConInteractions2){
            setConCurrent2.add(cur.Family__Child__c);
            setConPrior.add(Cur.Family__Child__c);
            
            
            
        }
        /*
        System.debug('setConCurrent2 Size after GK2 Events- 6-11 =' + setConCurrent2.size());
        // YTD: get kids between 6 -8, listed in Events, YTD
        List<campaignMember> limitCurContactEvents2 =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=72 AND AgeMonthsAtCampaign__c <=96
                                                      AND AgeMonthsAtCampaign__c !=NULL
                                                      AND contact.name !='Neale'
                                                      AND contact.name !='test'
                                                      AND No_Show__c = false
                                                      AND Status = 'Child Attendee'
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
                                                      AND contactID NOT IN: setConPrior
                                                      //AND (NOT campaign.Name Like '%Childcare%')
                                                      AND (NOT campaign.Name Like '%Cancelled%')
                                                      AND (NOT campaign.Name Like '%No Show%')
                                                      AND (NOT campaign.Name Like '%Postponed%')
                                                     ];
        
        for(campaignMember cm: limitCurContactEvents2){
            setConCurrent2.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        System.debug('setConCurrent2 size  6-8 yrs' + setConCurrent2.size());
       */ 
    } 
    
    //   **************************************************************************************
    private void GenerateKids3(){
        // get kids between 5 listed in interactions, YTD
        List<case> limitCurrentConInteractions3 =[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=60 AND AgeMonthCaseTime__c <=71
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Call_Type__c != 'Sent UTC Letter'
                                                  AND Family__Child__c NOT IN: setConPrior
                                                  AND Family__Child__r.LastName !='Neale'
                                                  AND Family__Child__r.LastName !='test'
                                                  AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:'PMP Initial' OR Call_Type__c LIKE:'PMP 2 mo' OR Call_Type__c LIKE:'pmp contact')  ];
        
        for(case cur: limitCurrentConInteractions3){
            setConCurrent3.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        /*
        system.debug('setconCurrent3 after events and interactions= ' + setConCurrent3);
        
        // get kids 5 year, listed in Events, YTD
        List<campaignMember> limitCurContactEvents3 =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=60 AND AgeMonthsAtCampaign__c <=71
                                                      AND AgeMonthsAtCampaign__c !=NULL
                                                      AND contact.name !='Neale'
                                                      AND contact.name !='test'
                                                      AND No_Show__c = false
                                                      AND Status = 'Child Attendee'
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
                                                      AND contactID NOT IN: setConPrior
                                                      //AND (NOT campaign.Name Like '%Childcare%')
                                                      AND (NOT campaign.Name Like '%Cancelled%')
                                                      AND (NOT campaign.Name Like '%No Show%')
                                                      AND (NOT campaign.Name Like '%Postponed%')
                                                     ];
        //(campaign.Type Like: 'Clinic' OR  campaign.Type Like: 'Conference' OR campaign.Type Like: 'IRC Conference'  OR campaign.Type Like: 'IRC Workshop' OR campaign.Type Like: 'Other Agency Training' OR campaign.Type Like:'Parent Panel' OR campaign.Type Like:'PMP Training' OR campaign.Type Like:'PPW' OR campaign.Type Like:'Workshop'  Or  campaign.Type Like:'%Playgroup%' OR campaign.Type Like: 'Support Group')];
        
        for(campaignMember cm: limitCurContactEvents3){
            setConCurrent3.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        System.debug('setConCurrent3 5 years ' + setConCurrent3.size());
*/
    }
    
    //  ********************************************************************
    private void GenerateKids4(){
        // get kids 4 listed in interactions, YTD
        List<case> limitCurrentConInteractions4 =[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=48 AND AgeMonthCaseTime__c <=59 
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Call_Type__c != 'Sent UTC Letter'         
                                                  AND Family__Child__c NOT IN: setConPrior
                                                  AND Family__Child__r.LastName !='Neale'
                                                  AND Family__Child__r.LastName !='test'
                                                  AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:'PMP Initial' OR Call_Type__c LIKE:'PMP 2 mo' OR Call_Type__c LIKE:'pmp contact')  ];
        
        for(case cur: limitCurrentConInteractions4){
            setConCurrent4.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        /*
        // get kids between 4, listed in Events, YTD
        List<campaignMember> limitCurContactEvents4 =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=48 AND AgeMonthsAtCampaign__c <=59
                                                      AND AgeMonthsAtCampaign__c !=NULL
                                                      AND contact.name !='Neale'
                                                      AND contact.name !='test'
                                                      AND No_Show__c = false
                                                      AND Status = 'Child Attendee'
                                                      AND contactID NOT IN: setConPrior
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
                                                      //AND (NOT campaign.Name Like '%Childcare%')
                                                      AND (NOT campaign.Name Like '%Cancelled%')
                                                      AND (NOT campaign.Name Like '%No Show%')
                                                      AND (NOT campaign.Name Like '%Postponed%')
                                                     ];
        //AND (campaign.Type Like: 'Clinic' OR  campaign.Type Like: 'Conference' OR campaign.Type Like: 'IRC Conference'  OR campaign.Type Like: 'IRC Workshop' OR campaign.Type Like: 'Other Agency Training' OR campaign.Type Like:'Parent Panel' OR campaign.Type Like:'PMP Training' OR campaign.Type Like:'PPW' OR campaign.Type Like:'Workshop'  Or  campaign.Type Like:'%Playgroup%' OR campaign.Type Like: 'Support Group')];
        
        for(campaignMember cm: limitCurContactEvents4){
            setConCurrent4.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        System.debug('setConCurrent4Size  4' + setConCurrent4.size());
       */ 
    } 
    
    //  *************************************
    private void GenerateKids5(){
        // get kids 3 listed in interactions, YTD
        List<case> limitCurrentConInteractions5 =[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=36 AND AgeMonthCaseTime__c <=47 
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Call_Type__c != 'Sent UTC Letter'         
                                                  AND Family__Child__r.LastName !='Neale'
                                                  AND Family__Child__r.LastName !='test'
                                                  AND Family__Child__c NOT IN: setConPrior
                                                  AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:'PMP Initial' OR Call_Type__c LIKE:'PMP 2 mo' OR Call_Type__c LIKE:'pmp contact')  ];
        
        for(case cur: limitCurrentConInteractions5){
            setConCurrent5.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        /*
        // get kids 3 listed in Events, report month requested
        List<campaignMember> limitCurContactEvents5 =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=36 AND AgeMonthsAtCampaign__c <=47
                                                      AND AgeMonthsAtCampaign__c !=NULL
                                                      AND contact.name !='Neale'
                                                      AND contact.name !='test'
                                                      AND No_Show__c = false
                                                      AND Status = 'Child Attendee'
                                                      AND contactID NOT IN: setConPrior
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
                                                      //AND (NOT campaign.Name Like '%Childcare%')
                                                      AND (NOT campaign.Name Like '%Cancelled%')
                                                      AND (NOT campaign.Name Like '%No Show%')
                                                      AND (NOT campaign.Name Like '%Postponed%')
                                                     ]; 
        //AND (campaign.Type Like: 'Clinic' OR  campaign.Type Like: 'Conference' OR campaign.Type Like: 'IRC Conference'  OR campaign.Type Like: 'IRC Workshop' OR campaign.Type Like: 'Other Agency Training' OR campaign.Type Like:'Parent Panel' OR campaign.Type Like:'PMP Training' OR campaign.Type Like:'PPW' OR campaign.Type Like:'Workshop'  Or  campaign.Type Like:'%Playgroup%' OR campaign.Type Like: 'Support Group')];
        
        for(campaignMember cm: limitCurContactEvents5){
            setConCurrent5.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        System.debug('setConCurrent5  3 yrs Size =' + setConCurrent5.size());
         System.debug('setConprior  3 yrs Size =' + setConPrior.size());
*/
    }
    
    //   ****************************************************** 
    private void GenerateKids6(){
        // get kids 2 listed in interactions, YTD
        List<case> limitCurrentConInteractions6 =[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=24 AND AgeMonthCaseTime__c <=35
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Call_Type__c != 'Sent UTC Letter'         
                                                  AND Family__Child__c NOT IN: setConPrior
                                                  AND Family__Child__r.LastName !='Neale'
                                                  AND Family__Child__r.LastName !='test'
                                                  AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:'PMP Initial' OR Call_Type__c LIKE:'PMP 2 mo' OR Call_Type__c LIKE:'pmp contact')   ];
        
        for(case cur: limitCurrentConInteractions6){
            setConCurrent6.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        
        /*
        // get kids 3 listed in Events, report month requested
        List<campaignMember> limitCurContactEvents6 =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=24 AND AgeMonthsAtCampaign__c <=35
                                                      AND AgeMonthsAtCampaign__c !=NULL
                                                      AND contact.name !='Neale'
                                                      AND contact.name !='test'
                                                      AND No_Show__c = false
                                                      AND Status = 'Child Attendee'
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
                                                      AND contactID NOT IN: setConPrior
                                                      //AND (NOT campaign.Name Like '%Childcare%')
                                                      AND (NOT campaign.Name Like '%Cancelled%')
                                                      AND (NOT campaign.Name Like '%No Show%')
                                                      AND (NOT campaign.Name Like '%Postponed%')
                                                     ]; 
        //AND (campaign.Type Like: 'Clinic' OR  campaign.Type Like: 'Conference' OR campaign.Type Like: 'IRC Conference'  OR campaign.Type Like: 'IRC Workshop' OR campaign.Type Like: 'Other Agency Training' OR campaign.Type Like:'Parent Panel' OR campaign.Type Like:'PMP Training' OR campaign.Type Like:'PPW' OR campaign.Type Like:'Workshop'  Or  campaign.Type Like:'%Playgroup%' OR campaign.Type Like: 'Support Group')];
        
        for(campaignMember cm: limitCurContactEvents6){
            setConCurrent6.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        System.debug('setConCurrent6  2 yrs Size =' + setConCurrent6.size());
*/
    }
    
    private void GenerateKids7(){
        // get kids 1 listed in interactions, YTD
        List<case> limitCurrentConInteractions7 =[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=12 AND AgeMonthCaseTime__c <=23
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Call_Type__c != 'Sent UTC Letter' 
                                                  AND Family__Child__c NOT IN: setConPrior
                                                  AND Family__Child__r.LastName !='Neale'
                                                  AND Family__Child__r.LastName !='test'
                                                  AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:'PMP Initial' OR Call_Type__c LIKE:'PMP 2 mo' OR Call_Type__c LIKE:'pmp contact')   ];
        
        for(case cur: limitCurrentConInteractions7){
            setConCurrent7.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
        }
        
        /*
        // get kids 1 listed in Events, report month requested
        List<campaignMember> limitCurContactEvents7 =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=12 AND AgeMonthsAtCampaign__c <=23
                                                      AND AgeMonthsAtCampaign__c !=NULL
                                                      AND contact.name !='Neale'
                                                      AND contact.name !='test'
                                                      AND No_Show__c = false
                                                      AND Status = 'Child Attendee'
                                                      AND contactID NOT IN: setConPrior
                                                      AND (NOT campaign.Name Like '%Childcare%')
                                                      AND (NOT campaign.Name Like '%Cancelled%')
                                                      AND (NOT campaign.Name Like '%No Show%')
                                                      AND (NOT campaign.Name Like '%Postponed%')
                                                     ]; 
        //AND (campaign.Type Like: 'Clinic' OR  campaign.Type Like: 'Conference' OR campaign.Type Like: 'IRC Conference'  OR campaign.Type Like: 'IRC Workshop' OR campaign.Type Like: 'Other Agency Training' OR campaign.Type Like:'Parent Panel' OR campaign.Type Like:'PMP Training' OR campaign.Type Like:'PPW' OR campaign.Type Like:'Workshop'  Or  campaign.Type Like:'%Playgroup%' OR campaign.Type Like: 'Support Group')];
        
        for(campaignMember cm: limitCurContactEvents7){
            setConCurrent7.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        System.debug('setConCurrent7  1 yrs Size =' + setConCurrent7.size());
          System.debug('setConprior  1 yrs Size =' + setConPrior.size());
*/
    } 
    
    private void GenerateKids8(){
        // get kids 0, listed in interactions, YTD
        List<case> limitCurrentConInteractions8 =[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <=11
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Call_Type__c != 'Sent UTC Letter' 
                                                  AND Family__Child__r.LastName !='Neale'
                                                  AND Family__Child__r.LastName !='test'
                                                  AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:'PMP Initial' OR Call_Type__c LIKE:'PMP 2 mo' OR Call_Type__c LIKE:'pmp contact')   ];
        
        for(case cur: limitCurrentConInteractions8){
            setConCurrent8.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
            
        }
        
        /*
        // get kids 0 listed in Events, report month requested
        List<campaignMember> limitCurContactEvents8 =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=0 AND AgeMonthsAtCampaign__c <=11
                                                      AND AgeMonthsAtCampaign__c !=NULL
                                                      AND contact.name !='Neale'
                                                      AND contact.name !='test'
                                                      AND No_Show__c = false
                                                      AND Status = 'Child Attendee'
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
                                                      //AND (NOT campaign.Name Like '%Childcare%')
                                                      AND (NOT campaign.Name Like '%Cancelled%')
                                                      AND (NOT campaign.Name Like '%No Show%')
                                                      AND (NOT campaign.Name Like '%Postponed%')
                                                     ]; 
        
        
        for(campaignMember cm: limitCurContactEvents8){
            setConCurrent8.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        System.debug('setConCurrent8  0 yrs Size =' + setConCurrent8.size());
 */
    }
    
   
    // Generate output begins
    //  ***********************************  
    public List<ExWrapperX> getGenerateAgeNoAge(){  
        
        // Curent Q Totals  = FYTD - Prior Q
        list<ExWrapperX> age1QueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange1 =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrentNoAge
                                          Group By RecordTypeID];
   
        for(AggregateResult a: ageRange1){
   
            age1QueryTotals.add(new ExWrapperX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));  
        }
        System.debug('age - # of IDs after ageRange null+ query runs' + ageRange1.size() + ' setconprior= ' + setconprior.size());
        return age1QueryTotals; 
        
    }
    
     public List<ExWrapperX> getGenerateAge18_22(){  
        
        // Curent Q Totals  = FYTD - Prior Q
        list<ExWrapperX> age1QueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange1 =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent18
                                          AND Birthdate != NULL
                                          
                                          Group By RecordTypeID];
 
        for(AggregateResult a: ageRange1){
            
            
            age1QueryTotals.add(new ExWrapperX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz'))))); 
            //setConPrior.add(a.ID);  
        }
        System.debug('age - # of IDs after ageRange 9+ query runs' + ageRange1.size() + ' setconprior= ' + setconprior.size());
        return age1QueryTotals; 
        
    }
    
    
    
    
    
    public List<ExWrapperX> getGenerateAge9_17(){  
        
        // Curent Q Totals  = FYTD - Prior Q
        list<ExWrapperX> age1QueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange1 =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent
                                          AND Birthdate != NULL
                                          
                                          Group By RecordTypeID];
        System.debug('age - # of IDs after ageRange 9 -17 query runs' + ageRange1.size());
        
        
        
        for(AggregateResult a: ageRange1){
            
            
            age1QueryTotals.add(new ExWrapperX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz'))))); 
            //setConPrior.add(a.ID);  
        }
        System.debug('age - # of IDs after ageRange 9+ query runs' + ageRange1.size() + ' setconprior= ' + setconprior.size());
        return age1QueryTotals; 
        
    }
    //  ************************************
    //  8 yrs olds
     public List<ExWrapperX> getGenerateAge8(){  
        list<ExWrapperX> age2QueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange2 =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent8yrs
                                          AND Birthdate != NULL
                                          
                                          Group By RecordTypeID];
        System.debug('age - # of IDs after ageRange 6 query runs' + ageRange2.size());
        for(AggregateResult a: ageRange2){
            
            age2QueryTotals.add(new ExWrapperX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));   
            //setConPrior.add(a.ID); 
        }
        System.debug('age - # of IDs after ageRange 6 query runs' + ageRange2.size() + ' setconprior= ' + setconprior.size());
        return age2QueryTotals; 
    }
     public List<ExWrapperX> getGenerateAge7(){  
        list<ExWrapperX> age2QueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange2 =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent7yrs
                                          AND Birthdate != NULL
                                          
                                          Group By RecordTypeID];
        System.debug('age - # of IDs after ageRange 6 query runs' + ageRange2.size());
        for(AggregateResult a: ageRange2){
            
            age2QueryTotals.add(new ExWrapperX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));   
            //setConPrior.add(a.ID); 
        }
        System.debug('age - # of IDs after ageRange 6 query runs' + ageRange2.size() + ' setconprior= ' + setconprior.size());
        return age2QueryTotals; 
    }
    
    public List<ExWrapperX> getGenerateAge6(){  
        list<ExWrapperX> age2QueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange2 =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent2
                                          AND Birthdate != NULL
                                          
                                          Group By RecordTypeID];
        System.debug('age - # of IDs after ageRange 6 query runs' + ageRange2.size());
        for(AggregateResult a: ageRange2){
            
            age2QueryTotals.add(new ExWrapperX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));   
            //setConPrior.add(a.ID); 
        }
        System.debug('age - # of IDs after ageRange 6 query runs' + ageRange2.size() + ' setconprior= ' + setconprior.size());
        return age2QueryTotals; 
    }
    
    // ***********************************
    
    public List<ExWrapperX> getGenerateAge5(){  
        list<ExWrapperX> age3QueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange3 =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent3
                                          AND Birthdate != NULL
                                          
                                          Group By RecordTypeID];
        System.debug('age - # of IDs after ageRange 5 yrs query runs' + ageRange3.size());
        for(AggregateResult a: ageRange3){
            
            age3QueryTotals.add(new ExWrapperX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz'))))); 
            //setConPrior.add(a.ID);
        }
        System.debug('age - # of IDs after ageRange 5 query runs' + ageRange3.size() + ' setconprior= ' + setconprior.size());
        return age3QueryTotals; 
    }
    
    //  ***********************************************************
    //  return ageR4      
    
    public List<ExWrapperX> getGenerateAge4(){  
        list<ExWrapperX> age4QueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange4 =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent4
                                          AND Birthdate != NULL
                                          
                                          Group By RecordTypeID ];
        System.debug('age - # of IDs after ageRange4 query runs' + ageRange4.size());
        for(AggregateResult a: ageRange4){
            
            age4QueryTotals.add(new ExWrapperX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz'))))); 
            //setConPrior.add(a.ID);
        }
        System.debug('age - # of IDs after ageRange 4 query runs' + ageRange4.size() + ' setconprior= ' + setconprior.size());
        return age4QueryTotals; 
    }
    
    // ****************************************
    // retern Age 3
    public List<ExWrapperX> getGenerateAge3(){  
        list<ExWrapperX> age5QueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange5 =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent5
                                          AND Birthdate != NULL
                                          
                                          Group By RecordTypeID ];
        System.debug('age - # of IDs after ageRange 3yrs query runs' + ageRange5.size());
        for(AggregateResult a: ageRange5){
            
            age5QueryTotals.add(new ExWrapperX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));  
            //setConPrior.add(a.ID);
        }
        System.debug('age - # of IDs after ageRange 3 query runs' + ageRange5.size() + ' setconprior= ' + setconprior.size());
        return age5QueryTotals; 
    }
    
    // ****************************************
    
    public List<ExWrapperX> getGenerateAge2(){  
        list<ExWrapperX> age6QueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange6 =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent6
                                          AND Birthdate != NULL
                                          
                                          Group By RecordTypeID];
        System.debug('age - # of IDs after ageRange 2 yr query runs' + ageRange6.size());
        for(AggregateResult a: ageRange6){
            
            age6QueryTotals.add(new ExWrapperX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));  
            setConPrior.add(a.ID);
        }
        System.debug('age - # of IDs after ageRange 2 query runs' + ageRange6.size() + ' setconprior= ' + setconprior.size());
        return age6QueryTotals; 
    }
    
    public List<ExWrapperX> getGenerateAge1(){  
        list<ExWrapperX> age6QueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange6 =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent7
                                          AND Birthdate != NULL
                                          
                                          Group By RecordTypeID];
        System.debug('age - # of IDs after ageRange 1yr query runs' + ageRange6.size());
        for(AggregateResult a: ageRange6){
            
            age6QueryTotals.add(new ExWrapperX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));   
            //setConPrior.add(a.ID);
        }
        System.debug('age - # of IDs after ageRange 1 query runs' + ageRange6 + ' setconprior= ' + setconprior);
        return age6QueryTotals; 
    }
    
    public List<ExWrapperX> getGenerateAge0(){  
        list<ExWrapperX> age6QueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange6 =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent8
                                          AND Birthdate != NULL
                                          
                                          Group By RecordTypeID];
        
        for(AggregateResult a: ageRange6){
            
            age6QueryTotals.add(new ExWrapperX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));
            
        }
        System.debug('age - # of IDs after ageRange 0 query runs' + ageRange6 + ' setconprior= ' + setconprior);
        return age6QueryTotals; 
    }
     public List<ExWrapperX> getGenerateIntTotal() {
        
        // get count Language 
        list<ExWrapperX> LanguageKQueryTotals = new List <ExWrapperX>();
        List<AggregateResult> LanguageKAggregateResult = 
            [select  Family__Primary_Language__c aa, Count_Distinct (ID) bb                 
             From contact
             WHERE ID IN: setConPrior 
             group by Rollup (Family__Primary_Language__c) ];
      
        
        String NewName ='';
        for (AggregateResult arList : LanguageKAggregateResult) { 
            If(String.valueOf(arList.get('aa'))==NULL){
                NewName ='Total'; 
            } ELSE{
                NewName = (String.valueOf(arList.get('aa')));  
                
            }
   
            LanguageKQueryTotals.add(new ExWrapperX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));     
        }
        return LanguageKQueryTotals;
    }
    
    /*******************************************************************
* Wrapper 
*******************************************************************/
    
    
    public class ExWrapperX {
        
        public String ag1 {get; set;}
        public Integer C1 {get; set;}
        
        
        
        public ExWrapperX(String str, Integer num){
            ag1 =str;
            C1 =num;
            
            
        }         
        
    }
}