public class AgeByYear15Up {

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
    private Set<String> setConCurrent14 = new Set<String>(); 
    private Set<String> setConCurrent15 = new Set<String>(); 
    private Set<String> setConCurrent16 = new Set<String>();
    private Set<String> setConCurrent17 = new Set<String>();
    private Set<String> setConCurrent18 = new Set<String>(); 
    private Set<String> setConCurrent19 = new Set<String>();
    private Set<String> setConCurrent20 = new Set<String>(); 
    private Set<String> setConCurrent21 = new Set<String>();
    private Set<String> setConCurrent22 = new Set<String>(); 
    private Set<String> setConCurrent23 = new Set<String>(); 
    private Set<String> setConCurrent24 = new Set<String>();
    private Set<String> setConCurrent25 = new Set<String>(); 
    private Set<String> setConCurrent26 = new Set<String>();    
    private Set<String> setConCurrentNoAge = new Set<String>();    

    Private String pmpVar ='PMP' + '%';
 

    public AgeByYear15Up(){
     
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

    setConCurrent14.clear(); 
    setConCurrent15.clear();
    setConCurrent16.clear();
    setConCurrent17.clear();
    setConCurrent18.clear(); 
    setConCurrent19.clear();
    setConCurrent20.clear(); 
    setConCurrent21.clear();
    setConCurrent22.clear();
    setConCurrent23.clear();
    setConCurrent24.clear();
    setConCurrent25.clear();
    setConCurrent26.clear(); 
    setConCurrentNoAge.clear();
    }
    
    
    private void runboard() {
    GenerateKids14(); 
    
    GenerateKids15(); 
    GenerateKids16();
    GenerateKids17();
    GenerateKids18(); 
    GenerateKids19();
    GenerateKids20(); 
    GenerateKids21();
    GenerateKids22(); 
    GenerateKids23(); 
    GenerateKids24();
    GenerateKids25(); 
    GenerateKids26(); 
    GenerateKidsNoAge(); 
   
            
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
    
   
    private void GenerateKids15(){
        // get kids  listed in interactions, YTD
        List<case> limitCurrentConInteractions=[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=180 AND AgeMonthCaseTime__c <=191
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
            setConCurrent15.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        
        
        // get kids 15 listed in Events
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=180 AND AgeMonthsAtCampaign__c <=191
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
            setConCurrent15.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        //System.debug('setConCurrentyrs Size =' + setConCurrent.size());
    }
    
private void GenerateKids16(){
        // get kids  listed in interactions, YTD
        List<case> limitCurrentConInteractions=[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=192 AND AgeMonthCaseTime__c <=203
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
            setConCurrent16.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        
        
        // get kids 16 listed in Events
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=192 AND AgeMonthsAtCampaign__c <=203
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
            setConCurrent16.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        //System.debug('setConCurrentyrs Size =' + setConCurrent.size());
    }

    private void GenerateKids17(){
        // get kids  listed in interactions, YTD
        List<case> limitCurrentConInteractions=[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=204 AND AgeMonthCaseTime__c <=215
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
            setConCurrent17.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        
        
        // get kids17listed in Events
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=204 AND AgeMonthsAtCampaign__c <=215
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
            setConCurrent17.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        //System.debug('setConCurrentyrs Size =' + setConCurrent.size());
    }
    
     private void GenerateKids18(){
        // get kids  listed in interactions, YTD
        List<case> limitCurrentConInteractions=[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=216 AND AgeMonthCaseTime__c <=227
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
            setConCurrent18.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        
        
        // get kids 18 listed in Events
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=216 AND AgeMonthsAtCampaign__c <=227
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
            setConCurrent18.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        //System.debug('setConCurrent18yrs Size =' + setConCurrent18.size());
    }
    
     private void GenerateKids19(){
        // get kids  listed in interactions, YTD
        List<case> limitCurrentConInteractions=[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=228 AND AgeMonthCaseTime__c <=239
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
            setConCurrent19.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        
        
        // get kids 19 listed in Events
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=228 AND AgeMonthsAtCampaign__c <=239
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
            setConCurrent19.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        //System.debug('setConCurrent19yrs Size =' + setConCurrent19.size());
    }
     private void GenerateKids20(){
        // get kids  listed in interactions, YTD
        List<case> limitCurrentConInteractions=[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=240 AND AgeMonthCaseTime__c <=251
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
            setConCurrent20.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        
        
        // get kids 20 listed in Events
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=240 AND AgeMonthsAtCampaign__c <=251
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
            setConCurrent20.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        //System.debug('setConCurrent20yrs Size =' + setConCurrent20.size());
    }
    
    
     private void GenerateKids21(){
        // get kids  listed in interactions, YTD
        List<case> limitCurrentConInteractions=[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=252 AND AgeMonthCaseTime__c <=263
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
            setConCurrent21.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        
        
        // get kids 21 listed in Events
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=252 AND AgeMonthsAtCampaign__c <=263
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
            setConCurrent21.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        //System.debug('setConCurrent21yrs Size =' + setConCurrent21.size());
    }
    
     private void GenerateKids22(){
        // get kids  listed in interactions, YTD
        List<case> limitCurrentConInteractions=[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>= 264 AND AgeMonthCaseTime__c <=275
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
            setConCurrent22.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        
        
        // get kids 22 listed in Events
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=264 AND AgeMonthsAtCampaign__c <=275
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
            setConCurrent22.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        //System.debug('setConCurrent22yrs Size =' + setConCurrent22.size());
    }
    
     private void GenerateKids23(){
        // get kids  listed in interactions, YTD
        List<case> limitCurrentConInteractions=[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=276 AND AgeMonthCaseTime__c <=287
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
            setConCurrent23.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        
        
        // get kids 23 listed in Events
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=276 AND AgeMonthsAtCampaign__c <=287
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
            setConCurrent23.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        //System.debug('setConCurrent23yrs Size =' + setConCurren2323.size());
    }
    
     private void GenerateKids24(){
        // get kids  listed in interactions, YTD
        List<case> limitCurrentConInteractions=[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=288 AND AgeMonthCaseTime__c <=299
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
            setConCurrent24.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        
        
        // get kids 24 listed in Events
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=288 AND AgeMonthsAtCampaign__c <=299
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
            setConCurrent24.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        //System.debug('setConCurrent24yrs Size =' + setConCurrent24.size());
    }
    
     private void GenerateKids25(){
        // get kids  listed in interactions, YTD
        List<case> limitCurrentConInteractions=[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=300 AND AgeMonthCaseTime__c <=311
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
            setConCurrent25.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        
        
        // get kids 25 listed in Events
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=300 AND AgeMonthsAtCampaign__c <=311
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
            setConCurrent25.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        //System.debug('setConCurrent25yrs Size =' + setConCurrent25.size());
    }
    
     private void GenerateKids26(){
        // get kids  listed in interactions, YTD
        List<case> limitCurrentConInteractions=[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=312 AND AgeMonthCaseTime__c <=323
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
            setConCurrent26.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        
        
        // get kids 26listed in Events
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>= 312 AND AgeMonthsAtCampaign__c <=323
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
            setConCurrent26.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        //System.debug('setConCurrent26yrs Size =' + setConCurrent26.size());
    }
    
     private void GenerateKidsNoAge(){
        // get kids  listed in interactions, YTD
        List<case> limitCurrentConInteractions=[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And (AgeMonthCaseTime__c>= 27
                                                  OR AgeMonthCaseTime__c = NULL)
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
            setConCurrentNoAge.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            
        }
        
        
        // get kids X listed in Events
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And (AgeMonthsAtCampaign__c>=27 
                                                      OR AgeMonthsAtCampaign__c = NULL)
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
            setConCurrentNoAge.add(cm.contactID);
            setConPrior.add(cm.contactID);
            
            
        }
        //System.debug('setConCurrentNoAge Size =' + setConCurrentNoAge.size());
    }
    
    
   

    
/*********************************************************************
* Output
*******************************************************************/    
 
    
     public List<ExWrapperX> getGenerateKids15(){  
        list<ExWrapperX> ageQueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent15
                                          AND Birthdate != NULL
                                          Group By RecordTypeID];
 
        for(AggregateResult a: ageRange){   
            ageQueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));
        }
        return ageQueryTotals; 
    }
    
     public List<ExWrapperX> getGenerateKids16(){  
        list<ExWrapperX> ageQueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent16
                                          AND Birthdate != NULL
                                          Group By RecordTypeID];
 
        for(AggregateResult a: ageRange){   
            ageQueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));
        }
        return ageQueryTotals; 
    }
    
     public List<ExWrapperX> getGenerateKids17(){  
        list<ExWrapperX> ageQueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent17
                                          AND Birthdate != NULL
                                          Group By RecordTypeID];
 
        for(AggregateResult a: ageRange){   
            ageQueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));
        }
        return ageQueryTotals; 
    }
    
 public List<ExWrapperX> getGenerateKids18(){  
        list<ExWrapperX> ageQueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent18
                                          AND Birthdate != NULL
                                          Group By RecordTypeID];
 
        for(AggregateResult a: ageRange){   
            ageQueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));
        }
        return ageQueryTotals; 
    }
     public List<ExWrapperX> getGenerateKids19(){  
        list<ExWrapperX> ageQueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent19
                                          AND Birthdate != NULL
                                          Group By RecordTypeID];
 
        for(AggregateResult a: ageRange){   
            ageQueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));
        }
        return ageQueryTotals; 
    }
    
     public List<ExWrapperX> getGenerateKids20(){  
        list<ExWrapperX> ageQueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent20
                                          AND Birthdate != NULL
                                          Group By RecordTypeID];
 
        for(AggregateResult a: ageRange){   
            ageQueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));
        }
        return ageQueryTotals; 
    }
    
     public List<ExWrapperX> getGenerateKids21(){  
        list<ExWrapperX> ageQueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent21
                                          AND Birthdate != NULL
                                          Group By RecordTypeID];
 
        for(AggregateResult a: ageRange){   
            ageQueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));
        }
        return ageQueryTotals; 
    }
    
     public List<ExWrapperX> getGenerateKids22(){  
        list<ExWrapperX> ageQueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent22
                                          AND Birthdate != NULL
                                          Group By RecordTypeID];
 
        for(AggregateResult a: ageRange){   
            ageQueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));
        }
        return ageQueryTotals; 
    }
    
     public List<ExWrapperX> getGenerateKids23(){  
        list<ExWrapperX> ageQueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent23
                                          AND Birthdate != NULL
                                          Group By RecordTypeID];
 
        for(AggregateResult a: ageRange){   
            ageQueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));
        }
        return ageQueryTotals; 
    }
    
     public List<ExWrapperX> getGenerateKids24(){  
        list<ExWrapperX> ageQueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent24
                                          AND Birthdate != NULL
                                          Group By RecordTypeID];
 
        for(AggregateResult a: ageRange){   
            ageQueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));
        }
        return ageQueryTotals; 
    }
    
     public List<ExWrapperX> getGenerateKids25(){  
        list<ExWrapperX> ageQueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent25
                                          AND Birthdate != NULL
                                          Group By RecordTypeID];
 
        for(AggregateResult a: ageRange){   
            ageQueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));
        }
        return ageQueryTotals; 
    }
     
      public List<ExWrapperX> getGenerateKids26(){  
        list<ExWrapperX> ageQueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent26
                                          AND Birthdate != NULL
                                          Group By RecordTypeID];
 
        for(AggregateResult a: ageRange){   
            ageQueryTotals.add(new ExWrapperX(Integer.valueOf(a.get('kidz'))));
        }
        return ageQueryTotals; 
    }
    
     public List<ExWrapperX> getGenerateKidsNoAge(){  
        list<ExWrapperX> ageQueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrentNoAge
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