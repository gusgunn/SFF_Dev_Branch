public class AgeByYear_Cls {

// Winter17  6/2-17

 
    
    public Date dateFrom {get; set;}
//public Date dateFrom {get; set;}
    
    // Date To
    public Date dateTo {get; set;}
    /*
    //public Date priorMonthEnd;
    public Date Q1Ends;
    public Date Q2Ends; 
    public Date Q3Ends; 
    public Date Q4Ends; 
    public Date PriorQuarterEnds;*/
    
    public Integer dateFromSelected;
    Public Integer dateFromSecond;
    
    
    private Set<String> setConPrior = new Set<String>();
    private Set<String> setConCurrent0 = new Set<String>();
    private Set<String> setConCurrent1 = new Set<String>();
    private Set<String> setConCurrent2 = new Set<String>();
    private Set<String> setConCurrent3 = new Set<String>();
    private Set<String> setConCurrent4 = new Set<String>();
    private Set<String> setConCurrent5 = new Set<String>();
    private Set<String> setConCurrent6 = new Set<String>();
    private Set<String> setConCurrent7 = new Set<String>();
    private Set<String> setConCurrent8 = new Set<String>();
    private Set<String> setConCurrent9 = new Set<String>(); 
    private Set<String> setConCurrent10 = new Set<String>(); 
    private Set<String> setConCurrent11 = new Set<String>(); 
    private Set<String> setConCurrent12 = new Set<String>(); 
    private Set<String> setConCurrent13 = new Set<String>();
    private Set<String> setConCurrent14 = new Set<String>(); 

    
    
    Private String pmpVar ='PMP' + '%';

    
  
    public AgeByYear_Cls(){

        Date DefaultDateTo = date.newinstance(2016, 1, 31);
        Date DefaultDateFrom = date.newinstance(2016, 1, 1);
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
    
    
    
    // generate the dashboard
    private void generateBoard() {
        
        dateFromSelected = (Integer.valueof(DateFrom.year()));
        dateFromSecond = (Integer.valueof(DateFrom.year() + 1));
       /*  Q1Ends = date.newInstance(dateFromSelected, 9, 30 );
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
        }*/
        initializeBoard();
        runBoard();
    }

    private void initializeBoard(){
    setConPrior.clear();
    setConCurrent0.clear();
    setConCurrent1.clear();
    setConCurrent2.clear();
    setConCurrent3.clear();
    setConCurrent4.clear();
    setConCurrent5.clear();
    setConCurrent6.clear();
    setConCurrent7.clear();
    setConCurrent8.clear();
    setConCurrent9.clear();
    setConCurrent10.clear();
    setConCurrent11.clear();
    setConCurrent12.clear();
    setConCurrent13.clear(); 
    setConCurrent14.clear(); 
  
    }
    
    
    private void runboard() {
        
    GenerateKids0();
    GenerateKids1();
    GenerateKids2();
    GenerateKids3();
    GenerateKids4();
    GenerateKids5();
    GenerateKids6();
    GenerateKids7();
    GenerateKids8();
    GenerateKids9(); 
    GenerateKids10(); 
    GenerateKids11(); 
    GenerateKids12(); 
    GenerateKids13(); 
    GenerateKids14(); 
   
            
    }

      private void GenerateKids0(){
        // get kids  listed in interactions, YTD
        List<case> limitCurrentConInteractions=[SELECT Family__Child__c, Family__Child__r.LastName
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
        
        for(case cur: limitCurrentConInteractions){
            setConCurrent0.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        
        
        // get kids 0 listed in Events
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
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
       
        
        for(campaignMember cm: limitCurContactEvents){
            setConCurrent0.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
       System.debug('setConCurrent 0 yrs Size =' + setConCurrent0.size());
    }
    
    private void GenerateKids1(){
        // get kids  listed in interactions, YTD
        List<case> limitCurrentConInteractions=[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=12 AND AgeMonthCaseTime__c <= 23
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Call_Type__c != 'Sent UTC Letter' 
                                                  AND Family__Child__r.LastName !='Neale'
                                                  AND Family__Child__r.LastName !='test'
                                                  AND Family__Child__c NOT IN: setConPrior
                                                  AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:'PMP Initial' OR Call_Type__c LIKE:'PMP 2 mo' OR Call_Type__c LIKE:'pmp contact')   ];
        
        for(case cur: limitCurrentConInteractions){
            setConCurrent1.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        
        
        // get kids 1 listed in Events
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=12 AND AgeMonthsAtCampaign__c <=23
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
            setConCurrent1.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        System.debug('setConCurrent 1 yrs Size =' + setConCurrent1.size());
    }
   
   private void GenerateKids2(){
        // get kids  listed in interactions, YTD
        List<case> limitCurrentConInteractions=[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=24 AND AgeMonthCaseTime__c <=35
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Call_Type__c != 'Sent UTC Letter' 
                                                  AND Family__Child__r.LastName !='Neale'
                                                  AND Family__Child__r.LastName !='test'
                                                  AND Family__Child__c NOT IN: setConPrior
                                                  AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:'PMP Initial' OR Call_Type__c LIKE:'PMP 2 mo' OR Call_Type__c LIKE:'pmp contact')   ];
        
        for(case cur: limitCurrentConInteractions){
            setConCurrent2.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        
        
        // get kids 2 listed in Events
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=24 AND AgeMonthsAtCampaign__c <=35
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
            setConCurrent2.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
      System.debug('setConCurrent 2yrs Size =' + setConCurrent2.size());
    }
     
  private void GenerateKids3(){
        // get kids  listed in interactions, YTD
        List<case> limitCurrentConInteractions=[SELECT Family__Child__c, Family__Child__r.LastName
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
                                                  AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:'PMP Initial' OR Call_Type__c LIKE:'PMP 2 mo' OR Call_Type__c LIKE:'pmp contact')   ];
        
        for(case cur: limitCurrentConInteractions){
            setConCurrent3.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        
        
        // get kids 3 listed in Events
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
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
       
        
        for(campaignMember cm: limitCurContactEvents){
            setConCurrent3.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        System.debug('setConCurrent 3 yrs Size =' + setConCurrent3.size());
    }
    
private void GenerateKids4(){
        // get kids  listed in interactions, YTD
        List<case> limitCurrentConInteractions=[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=48 AND AgeMonthCaseTime__c <=59
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Call_Type__c != 'Sent UTC Letter' 
                                                  AND Family__Child__r.LastName !='Neale'
                                                  AND Family__Child__r.LastName !='test'
                                                  AND Family__Child__c NOT IN: setConPrior
                                                  AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:'PMP Initial' OR Call_Type__c LIKE:'PMP 2 mo' OR Call_Type__c LIKE:'pmp contact')   ];
        
        for(case cur: limitCurrentConInteractions){
            setConCurrent4.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        
        
        // get kids 4 listed in Events
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
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
       
        
        for(campaignMember cm: limitCurContactEvents){
            setConCurrent4.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        System.debug('setConCurrent 4 yrs Size =' + setConCurrent4.size());
    }
    
    private void GenerateKids5(){
        // get kids  listed in interactions, YTD
        List<case> limitCurrentConInteractions=[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=60 AND AgeMonthCaseTime__c <=71
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Call_Type__c != 'Sent UTC Letter' 
                                                  AND Family__Child__r.LastName !='Neale'
                                                  AND Family__Child__r.LastName !='test'
                                                  AND Family__Child__c NOT IN: setConPrior
                                                  AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:'PMP Initial' OR Call_Type__c LIKE:'PMP 2 mo' OR Call_Type__c LIKE:'pmp contact')   ];
        
        for(case cur: limitCurrentConInteractions){
            setConCurrent5.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        
        
        // get kids 5 listed in Events
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=60 AND AgeMonthsAtCampaign__c <=71
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
            setConCurrent5.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        System.debug('setConCurrent 5 yrs Size =' + setConCurrent5.size());
    }
    private void GenerateKids6(){
        // get kids  listed in interactions, YTD
        List<case> limitCurrentConInteractions=[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=72 AND AgeMonthCaseTime__c <=83
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Call_Type__c != 'Sent UTC Letter' 
                                                  AND Family__Child__r.LastName !='Neale'
                                                  AND Family__Child__r.LastName !='test'
                                                  AND Family__Child__c NOT IN: setConPrior
                                                  AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:'PMP Initial' OR Call_Type__c LIKE:'PMP 2 mo' OR Call_Type__c LIKE:'pmp contact')   ];
        
        for(case cur: limitCurrentConInteractions){
            setConCurrent6.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        
        
        // get kids 6 listed in Events
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=72 AND AgeMonthsAtCampaign__c <=83
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
            setConCurrent6.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        System.debug('setConCurrent 6 yrs Size =' + setConCurrent6.size());
    }
    private void GenerateKids7(){
        // get kids  listed in interactions, YTD
        List<case> limitCurrentConInteractions=[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=84 AND AgeMonthCaseTime__c <=95
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Call_Type__c != 'Sent UTC Letter' 
                                                  AND Family__Child__r.LastName !='Neale'
                                                  AND Family__Child__r.LastName !='test'
                                                  AND Family__Child__c NOT IN: setConPrior
                                                  AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:'PMP Initial' OR Call_Type__c LIKE:'PMP 2 mo' OR Call_Type__c LIKE:'pmp contact')   ];
        
        for(case cur: limitCurrentConInteractions){
            setConCurrent7.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        
        
        // get kids 7 listed in Events
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=84 AND AgeMonthsAtCampaign__c <=95
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
            setConCurrent7.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        System.debug('setConCurrent 7 yrs Size =' + setConCurrent7.size());
    }
    
    private void GenerateKids8(){
        // get kids  listed in interactions, YTD
        List<case> limitCurrentConInteractions=[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=96 AND AgeMonthCaseTime__c <=107
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Call_Type__c != 'Sent UTC Letter' 
                                                  AND Family__Child__r.LastName !='Neale'
                                                  AND Family__Child__r.LastName !='test'
                                                  AND Family__Child__c NOT IN: setConPrior
                                                  AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:'PMP Initial' OR Call_Type__c LIKE:'PMP 2 mo' OR Call_Type__c LIKE:'pmp contact')   ];
        
        for(case cur: limitCurrentConInteractions){
            setConCurrent8.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        
        
        // get kids 8 listed in Events
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=96 AND AgeMonthsAtCampaign__c <=107
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
            setConCurrent8.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        System.debug('setConCurrent 8 yrs Size =' + setConCurrent8.size());
    }
    private void GenerateKids9(){
        // get kids  listed in interactions, YTD
        List<case> limitCurrentConInteractions=[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>= 108 AND AgeMonthCaseTime__c <=119
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Call_Type__c != 'Sent UTC Letter' 
                                                  AND Family__Child__r.LastName !='Neale'
                                                  AND Family__Child__r.LastName !='test'
                                                  AND Family__Child__c NOT IN: setConPrior
                                                  AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:'PMP Initial' OR Call_Type__c LIKE:'PMP 2 mo' OR Call_Type__c LIKE:'pmp contact')   ];
        
        for(case cur: limitCurrentConInteractions){
            setConCurrent9.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        
        
        // get kids 9 listed in Events
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=108 AND AgeMonthsAtCampaign__c <=119
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
            setConCurrent9.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        System.debug('setConCurrent 9 yrs Size =' + setConCurrent9 .size());
    }
    
private void GenerateKids10(){
        // get kids  listed in interactions, YTD
        List<case> limitCurrentConInteractions=[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=120 AND AgeMonthCaseTime__c <=131
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Call_Type__c != 'Sent UTC Letter' 
                                                  AND Family__Child__r.LastName !='Neale'
                                                  AND Family__Child__r.LastName !='test'
                                                  AND Family__Child__c NOT IN: setConPrior
                                                  AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:'PMP Initial' OR Call_Type__c LIKE:'PMP 2 mo' OR Call_Type__c LIKE:'pmp contact')   ];
        
        for(case cur: limitCurrentConInteractions){
            setConCurrent10.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        
        
        // get kids 10 listed in Events
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=120 AND AgeMonthsAtCampaign__c <=131
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
            setConCurrent10.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        System.debug('setConCurrent 10 yrs Size =' + setConCurrent10.size());
    }

    private void GenerateKids11(){
        // get kids  listed in interactions, YTD
        List<case> limitCurrentConInteractions=[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=132 AND AgeMonthCaseTime__c <=143
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Call_Type__c != 'Sent UTC Letter' 
                                                  AND Family__Child__r.LastName !='Neale'
                                                  AND Family__Child__r.LastName !='test'
                                                  AND Family__Child__c NOT IN: setConPrior
                                                  AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:'PMP Initial' OR Call_Type__c LIKE:'PMP 2 mo' OR Call_Type__c LIKE:'pmp contact')   ];
        
        for(case cur: limitCurrentConInteractions){
            setConCurrent11.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        
        
        // get kids 11 listed in Events
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=132 AND AgeMonthsAtCampaign__c <=143
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
            setConCurrent11.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        System.debug('setConCurrent 11 yrs Size =' + setConCurrent11.size());
    }
    
    private void GenerateKids12(){
        // get kids  listed in interactions, YTD
        List<case> limitCurrentConInteractions=[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=144 AND AgeMonthCaseTime__c <=155
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Call_Type__c != 'Sent UTC Letter' 
                                                  AND Family__Child__r.LastName !='Neale'
                                                  AND Family__Child__r.LastName !='test'
                                                  AND Family__Child__c NOT IN: setConPrior
                                                  AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:'PMP Initial' OR Call_Type__c LIKE:'PMP 2 mo' OR Call_Type__c LIKE:'pmp contact')   ];
        
        for(case cur: limitCurrentConInteractions){
            setConCurrent12.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        
        
        // get kids 12 listed in Events
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=144 AND AgeMonthsAtCampaign__c <=155
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
            setConCurrent12.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        System.debug('setConCurrent 12 yrs Size =' + setConCurrent12 .size());
    }
    
    private void GenerateKids13(){
        // get kids  listed in interactions, YTD
        List<case> limitCurrentConInteractions=[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=156 AND AgeMonthCaseTime__c <=167
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Call_Type__c != 'Sent UTC Letter' 
                                                  AND Family__Child__r.LastName !='Neale'
                                                  AND Family__Child__r.LastName !='test'
                                                  AND Family__Child__c NOT IN: setConPrior
                                                  AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:'PMP Initial' OR Call_Type__c LIKE:'PMP 2 mo' OR Call_Type__c LIKE:'pmp contact')   ];
        
        for(case cur: limitCurrentConInteractions){
            setConCurrent13.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        
        
        // get kids 13 listed in Events
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=156 AND AgeMonthsAtCampaign__c <=167
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
            setConCurrent13.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        System.debug('setConCurrent 13yrs Size =' + setConCurrent13.size());
    }
    private void GenerateKids14(){
        // get kids  listed in interactions, YTD
        List<case> limitCurrentConInteractions=[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=168 AND AgeMonthCaseTime__c <=179
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Call_Type__c != 'Sent UTC Letter' 
                                                  AND Family__Child__r.LastName !='Neale'
                                                  AND Family__Child__r.LastName !='test'
                                                  AND Family__Child__c NOT IN: setConPrior
                                                  AND Family__Child__c NOT IN: setConPrior
                                                  AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:'PMP Initial' OR Call_Type__c LIKE:'PMP 2 mo' OR Call_Type__c LIKE:'pmp contact')   ];
        
        for(case cur: limitCurrentConInteractions){
            setConCurrent14.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        
        
        // get kids 14 listed in Events
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=168 AND AgeMonthsAtCampaign__c <=179
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
            setConCurrent14.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        System.debug('setConCurrent 14 yrs Size =' + setConCurrent14.size());
    }
    
 

    
/*********************************************************************
* Output
*******************************************************************/    
    public List<ExWrapperX> getGenerateKids0(){  
        list<ExWrapperX> ageQueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent0
                                          AND Birthdate != NULL
                                          Group By RecordTypeID];
 
        for(AggregateResult a: ageRange){   
            ageQueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));
        }
        return ageQueryTotals; 
    }
    
   public List<ExWrapperX> getGenerateKids1(){  
        list<ExWrapperX> ageQueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent1
                                          AND Birthdate != NULL
                                          Group By RecordTypeID];
 
        for(AggregateResult a: ageRange){   
            ageQueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));
        }
        return ageQueryTotals; 
    }
    
   public List<ExWrapperX> getGenerateKids2(){  
        list<ExWrapperX> ageQueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent2
                                          AND Birthdate != NULL
                                          Group By RecordTypeID];
 
        for(AggregateResult a: ageRange){   
            ageQueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));
        }
        return ageQueryTotals; 
    }
    
 public List<ExWrapperX> getGenerateKids3(){  
        list<ExWrapperX> ageQueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent3
                                          AND Birthdate != NULL
                                          Group By RecordTypeID];
 
        for(AggregateResult a: ageRange){   
            ageQueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));
        }
        return ageQueryTotals; 
    }
    
     public List<ExWrapperX> getGenerateKids4(){  
        list<ExWrapperX> ageQueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent4
                                          AND Birthdate != NULL
                                          Group By RecordTypeID];
 
        for(AggregateResult a: ageRange){   
            ageQueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));
        }
        return ageQueryTotals; 
    }
     public List<ExWrapperX> getGenerateKids5(){  
        list<ExWrapperX> ageQueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent5
                                          AND Birthdate != NULL
                                          Group By RecordTypeID];
 
        for(AggregateResult a: ageRange){   
            ageQueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));
        }
        return ageQueryTotals; 
    }
    
     public List<ExWrapperX> getGenerateKids6(){  
        list<ExWrapperX> ageQueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent6
                                          AND Birthdate != NULL
                                          Group By RecordTypeID];
 
        for(AggregateResult a: ageRange){   
            ageQueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));
        }
        return ageQueryTotals; 
    }
    
     public List<ExWrapperX> getGenerateKids7(){  
        list<ExWrapperX> ageQueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent7
                                          AND Birthdate != NULL
                                          Group By RecordTypeID];
 
        for(AggregateResult a: ageRange){   
            ageQueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));
        }
        return ageQueryTotals; 
    }
    
     public List<ExWrapperX> getGenerateKids8(){  
        list<ExWrapperX> ageQueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent8
                                          AND Birthdate != NULL
                                          Group By RecordTypeID];
 
        for(AggregateResult a: ageRange){   
            ageQueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));
        }
        return ageQueryTotals; 
    }
     public List<ExWrapperX> getGenerateKids9(){  
        list<ExWrapperX> ageQueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent9
                                          AND Birthdate != NULL
                                          Group By RecordTypeID];
 
        for(AggregateResult a: ageRange){   
            ageQueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));
        }
        return ageQueryTotals; 
    }
    
     public List<ExWrapperX> getGenerateKids10(){  
        list<ExWrapperX> ageQueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent10
                                          AND Birthdate != NULL
                                          Group By RecordTypeID];
 
        for(AggregateResult a: ageRange){   
            ageQueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));
        }
        return ageQueryTotals; 
    }
    
     public List<ExWrapperX> getGenerateKids11(){  
        list<ExWrapperX> ageQueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent11
                                          AND Birthdate != NULL
                                          Group By RecordTypeID];
 
        for(AggregateResult a: ageRange){   
            ageQueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));
        }
        return ageQueryTotals; 
    }
    
     public List<ExWrapperX> getGenerateKids12(){  
        list<ExWrapperX> ageQueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent12
                                          AND Birthdate != NULL
                                          Group By RecordTypeID];
 
        for(AggregateResult a: ageRange){   
            ageQueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));
        }
        return ageQueryTotals; 
    }
    
     public List<ExWrapperX> getGenerateKids13(){  
        list<ExWrapperX> ageQueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent13
                                          AND Birthdate != NULL
                                          Group By RecordTypeID];
 
        for(AggregateResult a: ageRange){   
            ageQueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));
        }
        return ageQueryTotals; 
    }
     public List<ExWrapperX> getGenerateKids14(){  
        list<ExWrapperX> ageQueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent14
                                          AND Birthdate != NULL
                                          Group By RecordTypeID];
 
        for(AggregateResult a: ageRange){   
            ageQueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));
        }
        return ageQueryTotals; 
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