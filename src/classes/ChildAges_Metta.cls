public class ChildAges_Metta {

    public Date dateFrom {get; set;}

    public Date dateTo {get; set;}
    
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
   
    private String pmpVar ='PMP' + '%';
    
    private Map<ID,ID> parentsHH  =  new Map<ID,ID>();
  
    private Set<String> ageDone = new Set<String>();
    
    
    
    public ChildAges_Metta(){
        
    }        
    

    public PageReference startGenerateBoard() {
        
        
        if (dateFrom != null && dateTo != null) {
            if (dateTo >= dateFrom) {
  
                generateBoard();
                
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
    
    
    
   
    private void generateBoard() {
        
        dateFromSelected = (Integer.valueof(DateFrom.year()));
        dateFromSecond = (Integer.valueof(DateFrom.year() + 1));
        Q1Ends = date.newInstance(dateFromSelected, 9, 30 );
        Q2Ends = date.newInstance(dateFromSelected, 12, 31 );
        Q3Ends = date.newInstance(dateFromSecond, 3, 31 );
        Q4Ends = date.newInstance(dateFromSecond, 6, 30 );
        System.debug('Q1Ends= ' +  Q1Ends + ' Q2Ends= ' + Q2Ends + ' Q3Ends= ' + Q3Ends + ' Q4Ends= ' + Q4Ends );
     
        initializeBoard();
        runBoard();
    }
    private void initializeBoard(){
        setConMaster.clear();
        setConPrior.clear();
        setConCurrent.clear();
        setConPrior2.clear();
        setConCurrent2.clear();
        setConPrior8.clear();
        setConCurrent8.clear();
        setConCurrent18.clear();
        setConPrior18.clear();
        setConCurrentNoAge.clear();
        setConPriorNoAge.clear();
    }
    
  
    private void runboard() {
        
        GenerateKids8(); 
       
        GenerateKids2();
        GenerateKids13_17();
        
        GenerateKids18_24();
        GenerateKidsNoAge();
            
    }
    
    private void GenerateKidsNoAge() {   
        
        // YTD: No Age or above 24 yrs YTD
        List<case> limitCurrentConInteractions =[SELECT Family__Child__r.LastName, Family__Child__c
                                                 //, ContactID__r.Lastname
                                                 FROM case
                                                 WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                 
                                                 AND (AgeMonthCaseTime__c = NULL OR AgeMonthCaseTime__c >299)
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
            //setConPrior.add(cur.Family__Child__c);
            
        }
        
        // get kids  listed in Events YTD
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                     FROM campaignMember
                                                     WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                     
                                                     AND (AgeMonthsAtCampaign__c = NULL OR AgeMonthsAtCampaign__c >299)
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
         
            
            
        }
                
    } 
    private void GenerateKids18_24() {   
        
        // YTD:
        List<case> limitCurrentConInteractions =[SELECT Family__Child__r.LastName, Family__Child__c
                                                
                                                 FROM case
                                                 WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                 And AgeMonthCaseTime__c>=216 AND AgeMonthCaseTime__c <=299
                                                 AND AgeMonthCaseTime__c != NULL
                                                 AND Call_Type__c != 'Left Message 1'
                                                 AND Call_Type__c != 'Left Message 2'
                                                 AND Call_Type__c != '# disconnected'
                                                 AND Call_Type__c != 'No answering machine'
                                                 AND Call_Type__c != 'Sent UTC Letter'  
                                                 
                                                 AND Family__Child__r.LastName !='Neale'
                                                 AND Family__Child__r.LastName !='test'
                                                 AND Family__Child__c Not In:setConPrior
                                                 AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:pmpVar)  ];
        
        for(case cur: limitCurrentConInteractions){
            setConCurrent18.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        
        // get kids  listed in Events YTD
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                     FROM campaignMember
                                                     WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                     And AgeMonthsAtCampaign__c>=216 AND AgeMonthsAtCampaign__c <=299
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
        System.debug('setConCurrent Size 18-24  ' + setConCurrent.size());
         System.debug('setConprior  18-24 yrs Size =' + setConPrior.size());
        
    } 
    
    private void GenerateKids13_17() {   
        
        // YTD: get kids between 13 through 17, listed in interactions, YTD
        List<case> limitCurrentConInteractions =[SELECT Family__Child__r.LastName, Family__Child__c
                                                 //, ContactID__r.Lastname
                                                 FROM case
                                                 WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                 And AgeMonthCaseTime__c>=156 AND AgeMonthCaseTime__c <=215
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
        
        // get kids  listed in Events YTD
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                     FROM campaignMember
                                                     WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                     And AgeMonthsAtCampaign__c>=156 AND AgeMonthsAtCampaign__c <=215
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
        System.debug('setConCurrent Size 13-17  ' + setConCurrent.size());
         System.debug('setConprior  13 yrs Size =' + setConPrior.size());
        
    } 
    //   
    private void GenerateKids2(){
        // YTD: get kids between 3 through 12 years, listed in interactions, YTD
        List<case> limitCurrentConInteractions2 =[SELECT Family__Child__c,Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=36 AND AgeMonthCaseTime__c <=155
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
        System.debug('setConCurrent2 Size after GK2 Events- 6-11 =' + setConCurrent2.size());
        // YTD: get kids between 3 -12, listed in Events, YTD
        List<campaignMember> limitCurContactEvents2 =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=36 AND AgeMonthsAtCampaign__c <=155
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
        
    }
    
   
    private void GenerateKids8(){
        // get kids 0, listed in interactions, YTD
        List<case> limitCurrentConInteractions8 =[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <=35
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
        
        
        // get kids 0 thru 2listed in Events, report month requested
        List<campaignMember> limitCurContactEvents8 =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=0 AND AgeMonthsAtCampaign__c <=35
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
        //AND (campaign.Type Like: 'Clinic' OR  campaign.Type Like: 'Conference' OR campaign.Type Like: 'IRC Conference'  OR campaign.Type Like: 'IRC Workshop' OR campaign.Type Like: 'Other Agency Training' OR campaign.Type Like:'Parent Panel' OR campaign.Type Like:'PMP Training' OR campaign.Type Like:'PPW' OR campaign.Type Like:'Workshop'  Or  campaign.Type Like:'%Playgroup%' OR campaign.Type Like: 'Support Group')];
        
        for(campaignMember cm: limitCurContactEvents8){
            setConCurrent8.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        System.debug('setConCurrent8  0  thru 2 yrs Size =' + setConCurrent8.size());
    }
    
    
  
     public List<ExWrapperX> getGenerateAge18_24(){  
        
        // Curent Q Totals  = FYTD - Prior Q
        list<ExWrapperX> age1QueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange1 =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent18
                                          AND Birthdate != NULL
                                          
                                          Group By RecordTypeID];
 
        for(AggregateResult a: ageRange1){
            
            
            age1QueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));
            //setConPrior.add(a.ID);  
        }
        System.debug('age - # of IDs after ageRange 9+ query runs' + ageRange1.size() + ' setconprior= ' + setconprior.size());
        return age1QueryTotals; 
        
    }
    
    
    
    
    
    public List<ExWrapperX> getGenerateAge3_17(){  
        
        // Curent Q Totals  = FYTD - Prior Q
        list<ExWrapperX> age1QueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange1 =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent
                                          AND Birthdate != NULL
                                          
                                          Group By RecordTypeID];
        System.debug('age - # of IDs after ageRange 9 -17 query runs' + ageRange1.size());
        
        
        
        for(AggregateResult a: ageRange1){
            
            
            age1QueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));
            //setConPrior.add(a.ID);  
        }
        System.debug('age - # of IDs after ageRange 9+ query runs' + ageRange1.size() + ' setconprior= ' + setconprior.size());
        return age1QueryTotals; 
        
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
   
            age1QueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));
        }
        System.debug('age - # of IDs after ageRange null+ query runs' + ageRange1.size() + ' setconprior= ' + setconprior.size());
        return age1QueryTotals; 
        
    }
    
    //  ************************************
    
   
    
    // ****************************************
    
    public List<ExWrapperX> getGenerateAge2(){  
        list<ExWrapperX> age6QueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange6 =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent2
                                          AND Birthdate != NULL
                                          
                                          Group By RecordTypeID];
        System.debug('age - # of IDs after ageRange 2 yr query runs' + ageRange6.size());
        for(AggregateResult a: ageRange6){
            
            age6QueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));  
            setConPrior.add(a.ID);
        }
        System.debug('age - # of IDs after ageRange 2 query runs' + ageRange6.size() + ' setconprior= ' + setconprior.size());
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
            
            age6QueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));
            
        }
        System.debug('age - # of IDs after ageRange 0 query runs' + ageRange6 + ' setconprior= ' + setconprior);
        return age6QueryTotals; 
    }
    
    
    /*******************************************************************
* Wrapper 
*******************************************************************/
    
    
    public class ExWrapperX {
        
        //public String ag1 {get; set;}
        public Integer C1 {get; set;}
        
        
        
        public ExWrapperX( Integer num){
           // a1 =str;
            C1 =num;
            
            
        }         
        
    }
}