public class HMG_Age {

    // Snow 12/27/17
    // Add SetConPrior to be ALL Prior in 1 query.
    // Add AlreadyAddedSet to all Current
   
    public Date dateFrom {get; set;}
    public Date dateTo {get; set;}
    public Date Q1Ends;
    public Date Q2Ends; 
    public Date Q3Ends; 
    public Date Q4Ends; 
    public Date PriorQuarterEnds;
    public Integer dateFromSelected;
    Public Integer dateFromSecond;
    
    
    
     
    //setConPrior cotains all prior Q in 1 query
     private Set<String> setConPrior = new Set<String>();
    
    // SetConMasterIS dateTo to FYTD (report end date)
    private Set<String> setConMaster = new Set<String>(); 
    
    private Set<String> setConMasterCG = new Set<String>();
    private Set<String> setConPriorCG = new Set<String>();
   
     //setConCurrent1 is Age 0-11 months
   private Set<String> setConCurrent1 = new Set<String>();
    
    //private Set<String> setConPrior2 = new Set<String>();
    private Set<String> setConCurrent2 = new Set<String>();
    
    //private Set<String> setConPrior3 = new Set<String>();
    private Set<String> setConCurrent3 = new Set<String>();
    
    
    //private Set<String> setConPrior4 = new Set<String>();
    private Set<String> setConCurrent4 = new Set<String>();
    
  //  private Set<String> setConPrior5 = new Set<String>();
    private Set<String> setConCurrent5 = new Set<String>();
    
   // private Set<String> setConPrior6 = new Set<String>();
    private Set<String> setConCurrent6 = new Set<String>();
    
   private Set<String> setConCurrentMaster = new Set<String>();
   private Set<String> setConMasterPrior = new Set<String>();
  
    
    
    Private String pmpVar ='PMP' + '%';
    
  /*private Map<ID,ID> parentsHH  =  new Map<ID,ID>();
    private Map<ID,ID> espKidHHPrior =  new Map<ID,ID>();
    private Map<ID,ID> espKidHH  =  new Map<ID,ID>();
    private Map<ID,ID> parentsHHPrior =  new Map<ID,ID>();
    private Set<String> ageDone = new Set<String>();
    private Set<String> setConCurrentR = new Set<String>();*/
    
    public HMG_Age(){
        setConCurrentMaster.clear();
        setConMasterPrior.clear();
        setConMaster.clear();
        setConPrior.clear();
        setConCurrent1.clear();
        setConCurrent2.clear();
        setConCurrent3.clear();
        setConCurrent4.clear();
        setConCurrent5.clear();
        setConCurrent6.clear();
        setConPriorCG.clear();
        setConMasterCG.clear();
        Date DefaultDateTo = date.newinstance(2017, 9, 30);
        Date DefaultDateFrom = date.newinstance(2017, 7, 1);
        DateTo=DefaultDateTo;
        DateFrom = DefaultDateFrom;
       
    }
    
    // start EIS Dashboard generation
    public PageReference startGenerateEISDashboard() {
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
        System.Debug('datefrom & dateTo = ' + dateFrom + ' ' + dateTo);
        // MUST SELECT Real Q1 to work
        dateFromSelected = (Integer.valueof(DateFrom.year()));
        dateFromSecond = (Integer.valueof(DateFrom.year() + 1));
        Q1Ends = date.newInstance(dateFromSelected, 9, 30 );
        Q2Ends = date.newInstance(dateFromSelected, 12, 31 );
        Q3Ends = date.newInstance(dateFromSecond, 3, 31 );
        Q4Ends = date.newInstance(dateFromSecond, 6, 30 );
        System.debug('Q1Ends= ' +  Q1Ends + ' Q2Ends= ' + Q2Ends + ' Q3Ends= ' + Q3Ends + ' Q4Ends= ' + Q4Ends );
        If (dateTo <= Q1Ends){
            PriorQuarterEnds = DateFrom.addDays(-1);
        }Else
            If (dateTo <= Q2Ends){
                PriorQuarterEnds = Q1Ends;
            }Else
                If (dateTo <= Q3Ends){
                    PriorQuarterEnds = Q2Ends; 
                }Else{
                    PriorQuarterEnds = Q3Ends;
                }   
              
        
        generateEISDashboard();
    }
    
    
    
    // generate the dashboard
    private void generateEISDashboard() {
         setConCurrentMaster.clear();
        setConMasterPrior.clear();
        setConMaster.clear();
        setConPrior.clear();
        setConCurrent1.clear();
        setConCurrent2.clear();
        setConCurrent3.clear();
        setConCurrent4.clear();
        setConCurrent5.clear();
        setConCurrent6.clear();
        setConPriorCG.clear();
        setConMasterCG.clear();
        GenerateKids(); 
        GenerateKids2(); 
        GenerateKids3(); 
        GenerateKids4(); 
        GenerateKids5(); 
        GenerateKids6();
        
    } 
    
    private void GenerateKids() {   
        
        // PRIOR: get All kids bfor 0 to <72 months, listed in interactions, YT Prior month
        List<case> limitContactInteractions =[SELECT Child_Person_with_Disability_ID__c, ContactID
                                              FROM case
                                              WHERE start_time__c >= :dateFrom AND start_time__c <= :PriorQuarterEnds
                                              And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <72
                                              AND AgeMonthCaseTime__c !=NULL
                                              AND Call_Type__c != 'Left Message 1'
                                              AND Call_Type__c != 'Left Message 2'
                                              AND Call_Type__c != '# disconnected'
                                              AND Call_Type__c != 'Sent UTC Letter'
                                              AND Call_Type__c != 'No answering machine'
                                              AND Child_Person_with_Disability_ID__c !='Neale'
                                              AND Child_Person_with_Disability_ID__c !='test'
                                              AND (RecordTypeID = '012G0000000qhDK' OR  Call_Type__c LIKE:pmpVar) ];
        for(case c: limitContactInteractions){
            setConPrior.add(c.Child_Person_with_Disability_ID__c);
            setConMasterPrior.add(c.Child_Person_with_Disability_ID__c);
            setConPriorCG.add(c.ContactID);
        }
        /* Take out Events
        // PRIOR: get kids between 0 & 11 Months, listed in Events
        List<campaignMember> limitContactEvents =[SELECT contactID
                                                  FROM campaignMember
                                                  WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :PriorQuarterEnds
                                                  And AgeMonthsAtCampaign__c>=0 AND AgeMonthsAtCampaign__c <12
                                                  AND AgeMonthsAtCampaign__c !=NULL
                                                  AND contact.name !='Neale'
                                                  AND contact.name !='test'
                                                  AND No_Show__c = false
                                                  AND Status = 'Child Attendee'
                                                  AND (NOT campaign.Name Like '%Childcare%')
                                                  AND (NOT campaign.Name Like '%Cancelled%')
                                                  AND (NOT campaign.Name Like '%No Show%')
                                                  AND (NOT campaign.Name Like '%Postponed%')
                                                  AND (campaign.Type Like: 'Clinic' OR  campaign.Type Like: 'Conference' OR campaign.Type Like: 'IRC Conference'  OR campaign.Type Like: 'IRC Workshop' OR campaign.Type Like: 'Other Agency Training' OR campaign.Type Like:'Parent Panel' OR campaign.Type Like:'PMP Training' OR campaign.Type Like:'PPW' OR campaign.Type Like:'Workshop'  Or  campaign.Type Like:'%Playgroup%' OR campaign.Type Like: 'Support Group')];
        for(campaignMember cm: limitContactEvents){
            setConPrior.add(cm.contactID);
            setConMasterPrior.add(cm.contactID);   
            
        }*/
     
        /**************************
* pull out unduplicated kids for YTD  
* ***********************************************/
        
        // YTD: get kids between 0 & 11 Months, listed in interactions, YTD
        List<case> limitCurrentConInteractions =[SELECT Child_Person_with_Disability_ID__c, ContactID
                                                 FROM case
                                                 WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                 And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <12
                                                 AND AgeMonthCaseTime__c != NULL
                                                 AND Call_Type__c != 'Left Message 1'
                                                 AND Call_Type__c != 'Left Message 2'
                                                 AND Call_Type__c != '# disconnected'
                                                 AND Call_Type__c != 'Sent UTC Letter'
                                                 AND Call_Type__c != 'No answering machine'
                                                 AND Child_Person_with_Disability_ID__c !='Neale'
                                                 AND Child_Person_with_Disability_ID__c !='test'
                                                 AND Child_Person_with_Disability_ID__c NOT IN : setConPrior
                                                 AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:pmpVar)  ];
        
        for(case c: limitCurrentConInteractions){
             
            setConCurrent1.add(c.Child_Person_with_Disability_ID__c);
            // setConCurrentMaster = alreadyAdded to current Q count
            setConCurrentMaster.add(c.Child_Person_with_Disability_ID__c);
            setConMasterCG.add(c.ContactID);
        }
        /*
        // get kids between 0 & 11 Months, listed in Events YTD
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                     FROM campaignMember
                                                     WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                     And AgeMonthsAtCampaign__c>=0 AND AgeMonthsAtCampaign__c <12
                                                     AND AgeMonthsAtCampaign__c !=NULL
                                                     AND contact.name !='Neale'
                                                     AND contact.name !='test'
                                                     AND No_Show__c = false
                                                     AND Status = 'Child Attendee'
                                                     AND (NOT campaign.Name Like '%Childcare%')
                                                     AND (NOT campaign.Name Like '%Cancelled%')
                                                     AND (NOT campaign.Name Like '%No Show%')
                                                     AND (NOT campaign.Name Like '%Postponed%')
                                                     AND (campaign.Type Like: 'Clinic' OR  campaign.Type Like: 'Conference' OR campaign.Type Like: 'IRC Conference'  OR campaign.Type Like: 'IRC Workshop' OR campaign.Type Like: 'Other Agency Training' OR campaign.Type Like:'Parent Panel' OR campaign.Type Like:'PMP Training' OR campaign.Type Like:'PPW' OR campaign.Type Like:'Workshop'  Or  campaign.Type Like:'%Playgroup%' OR campaign.Type Like: 'Support Group')];
        
        for(campaignMember cm: limitCurContactEvents){
            
            setConCurrent.add(cm.contactID);
             setConCurrentMaster.add(cm.contactID);
           
            
        }
        System.debug('setConCurrent Size Should be 0=  ' + setConCurrent.size());
        System.debug('setConMaster Size Should be 0=  ' + setConMaster.size()); */
    } 
     
    // 12-23  
    private void GenerateKids2() {   
      /*  // get kids between 12 & 23 Months, listed in interactions, dateTo Prior month
        List<case> limitContactInteractions2 =[SELECT Child_Person_with_Disability_ID__c, ContactID
                                               FROM case
                                               WHERE start_time__c >= :dateFrom AND start_time__c <= :PriorQuarterEnds
                                               And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <24 
                                               AND Child_Person_with_Disability_ID__c !='Neale'
                                               AND Child_Person_with_Disability_ID__c !='test'
                                               AND Call_Type__c != 'Left Message 1'
                                               AND Call_Type__c != 'Left Message 2'
                                               AND Call_Type__c != '# disconnected'
                                               AND Call_Type__c != 'Sent UTC Letter'
                                               AND Call_Type__c != 'No answering machine'
                                               AND Child_Person_with_Disability_ID__c NOT IN:setConPrior
                                               AND AgeMonthCaseTime__c !=NULL
                                               AND (RecordTypeID = '012G0000000qhDK' OR  Call_Type__c LIKE:pmpVar) ];
        for(case c: limitContactInteractions2){
            setConPrior2.add(c.Child_Person_with_Disability_ID__c);
            setConMasterPrior.add(c.Child_Person_with_Disability_ID__c);
            setConPriorCG.add(c.ContactID);
        }
        
        
       // System.debug('setConPrior Size after GK2 Interactions- 0-23 =' + setConPrior.size());
        
        // get kids between 12 & 23 Months, PRIOR  listed in Events
        List<campaignMember> limitContactEvents2 =[SELECT contactID
                                                   FROM campaignMember
                                                   WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :PriorQuarterEnds
                                                   And AgeMonthsAtCampaign__c>=0 AND AgeMonthsAtCampaign__c <24
                                                   AND AgeMonthsAtCampaign__c !=NULL
                                                   AND contact.name !='Neale'
                                                   AND contact.name !='test'
                                                   AND No_Show__c = false
                                                   AND Status = 'Child Attendee'
                                                   AND (NOT campaign.Name Like '%Childcare%')
                                                   AND (NOT campaign.Name Like '%Cancelled%')
                                                   AND (NOT campaign.Name Like '%No Show%')
                                                   AND (NOT campaign.Name Like '%Postponed%')
                                                   AND (campaign.Type Like: 'Clinic' OR  campaign.Type Like: 'Conference' OR campaign.Type Like: 'IRC Conference'  OR campaign.Type Like: 'IRC Workshop' OR campaign.Type Like: 'Other Agency Training' OR campaign.Type Like:'Parent Panel' OR campaign.Type Like:'PMP Training' OR campaign.Type Like:'PPW' OR campaign.Type Like:'Workshop'  Or  campaign.Type Like:'%Playgroup%' OR campaign.Type Like: 'Support Group')];
        for(campaignMember cm: limitContactEvents2){
            setConPrior2.add(cm.contactID);
            setConMasterPrior.add(cm.contactID);
            System.debug('setConPrior2 Size after GK2 Events- 12-23 =' + setConPrior2.size());
        } */
          
        // YTD: get kids between 12 & 23 Months, listed in interactions, YTD
        List<case> limitCurrentConInteractions2 =[SELECT Child_Person_with_Disability_ID__c, ContactID
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=12 AND AgeMonthCaseTime__c <24
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'Sent UTC Letter'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Child_Person_with_Disability_ID__c !='Neale'
                                                  AND Child_Person_with_Disability_ID__c !='test'
                                                  AND Child_Person_with_Disability_ID__c NOT In: setConCurrentMaster
                                                  AND Child_Person_with_Disability_ID__c NOT IN : setConPrior
                                                  AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:pmpVar)  ];
        
        for(case cur: limitCurrentConInteractions2){
            setConCurrent2.add(cur.Child_Person_with_Disability_ID__c);
            setConCurrentMaster.add(cur.Child_Person_with_Disability_ID__c);
            setConMasterCG.add(cur.ContactID);
            System.debug('setConCurrent2 Size after GK2 Events- 6-23 =' + setConCurrent2.size());
        }
        /*
        // YTD: get kids between 12 & 23 Months, listed in Events, YTD
        List<campaignMember> limitCurContactEvents2 =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=12 AND AgeMonthsAtCampaign__c <24
                                                      AND AgeMonthsAtCampaign__c !=NULL
                                                      AND contact.name !='Neale'
                                                      AND contact.name !='test'
                                                      AND No_Show__c = false
                                                      AND Status = 'Child Attendee'
                                                      AND (NOT campaign.Name Like '%Childcare%')
                                                      AND (NOT campaign.Name Like '%Cancelled%')
                                                      AND (NOT campaign.Name Like '%No Show%')
                                                      AND (NOT campaign.Name Like '%Postponed%')
                                                      AND (campaign.Type Like: 'Clinic' OR  campaign.Type Like: 'Conference' OR campaign.Type Like: 'IRC Conference'  OR campaign.Type Like: 'IRC Workshop' OR campaign.Type Like: 'Other Agency Training' OR campaign.Type Like:'Parent Panel' OR campaign.Type Like:'PMP Training' OR campaign.Type Like:'PPW' OR campaign.Type Like:'Workshop'  Or  campaign.Type Like:'%Playgroup%' OR campaign.Type Like: 'Support Group')];
        
        for(campaignMember cm: limitCurContactEvents2){
            setConCurrent2.add(cm.contactID);
            setConCurrentMaster.add(cm.contactID);
            System.debug('setConCurrent2 size ' + setConCurrent2.size());
        }*/
        
    } 
    
    //   **************************************************************************************
    //   24-35 
    
    private void GenerateKids3(){
      /*  List<case> limitContactInteractions3 =[SELECT Child_Person_with_Disability_ID__c, ContactID
                                               FROM case
                                               WHERE start_time__c >= :dateFrom AND start_time__c <= :PriorQuarterEnds
                                               And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <36 
                                               AND AgeMonthCaseTime__c !=NULL
                                               AND Call_Type__c != 'Left Message 1'
                                               AND Call_Type__c != 'Left Message 2'
                                               AND Call_Type__c != '# disconnected'
                                               AND Call_Type__c != 'Sent UTC Letter'
                                               AND Call_Type__c != 'No answering machine'
                                               AND Child_Person_with_Disability_ID__c !='Neale'
                                               AND Child_Person_with_Disability_ID__c !='test'
                                               AND (RecordTypeID = '012G0000000qhDK' OR  Call_Type__c LIKE:pmpVar) ];
        for(case c: limitContactInteractions3){
            setConPrior3.add(c.Child_Person_with_Disability_ID__c);
            setConMasterPrior.add(c.Child_Person_with_Disability_ID__c);
            setConPriorCG.add(c.ContactID);
        }
       
        // get kids between 24-35 Months, listed in Events
        List<campaignMember> limitContactEvents3 =[SELECT contactID
                                                   FROM campaignMember
                                                   WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :PriorQuarterEnds
                                                   And AgeMonthsAtCampaign__c>=0 AND AgeMonthsAtCampaign__c <36
                                                   AND AgeMonthsAtCampaign__c !=NULL
                                                   AND contact.name !='Neale'
                                                   AND contact.name !='test'
                                                   AND No_Show__c = false
                                                   AND Status = 'Child Attendee'
                                                   AND (NOT campaign.Name Like '%Childcare%')
                                                   AND (NOT campaign.Name Like '%Cancelled%')
                                                   AND (NOT campaign.Name Like '%No Show%')
                                                   AND (NOT campaign.Name Like '%Postponed%')
                                                   AND (campaign.Type Like: 'Clinic' OR  campaign.Type Like: 'Conference' OR campaign.Type Like: 'IRC Conference'  OR campaign.Type Like: 'IRC Workshop' OR campaign.Type Like: 'Other Agency Training' OR campaign.Type Like:'Parent Panel' OR campaign.Type Like:'PMP Training' OR campaign.Type Like:'PPW' OR campaign.Type Like:'Workshop'  Or  campaign.Type Like:'%Playgroup%' OR campaign.Type Like: 'Support Group')];
        for(campaignMember cm: limitContactEvents3){
            setConPrior3.add(cm.contactID);
            setConMasterPrior.add(cm.contactID);
        } */
        
        // get kids between 24 & 35 Months, listed in interactions, YTD
        List<case> limitCurrentConInteractions3 =[SELECT Child_Person_with_Disability_ID__c, ContactID
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=24 AND AgeMonthCaseTime__c <36
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'Sent UTC Letter'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Child_Person_with_Disability_ID__c !='Neale'
                                                  AND Child_Person_with_Disability_ID__c !='test'
                                                  AND Child_Person_with_Disability_ID__c NOT In: setConCurrentMaster
                                                  AND Child_Person_with_Disability_ID__c NOT IN : setConPrior
                                                  AND (RecordTypeID = '012G0000000qhDK' OR  Call_Type__c LIKE:pmpVar) ];
        
        for(case c: limitCurrentConInteractions3){
            setConCurrent3.add(c.Child_Person_with_Disability_ID__c);
            setConCurrentMaster.add(c.Child_Person_with_Disability_ID__c);
            setConMasterCG.add(c.ContactID);
        }
        system.debug('setconCurrent3 after events and interactions= ' + setConCurrent3);
        /*
        // get kids between 24 & 35 Months, listed in Events, YTD
        List<campaignMember> limitCurContactEvents3 =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=24 AND AgeMonthsAtCampaign__c <36
                                                      AND AgeMonthsAtCampaign__c !=NULL
                                                      AND contact.name !='Neale'
                                                      AND contact.name !='test'
                                                      AND No_Show__c = false
                                                      AND Status = 'Child Attendee'
                                                      AND (NOT campaign.Name Like '%Childcare%')
                                                      AND (NOT campaign.Name Like '%Cancelled%')
                                                      AND (NOT campaign.Name Like '%No Show%')
                                                      AND (NOT campaign.Name Like '%Postponed%')
                                                      AND (campaign.Type Like: 'Clinic' OR  campaign.Type Like: 'Conference' OR campaign.Type Like: 'IRC Conference'  OR campaign.Type Like: 'IRC Workshop' OR campaign.Type Like: 'Other Agency Training' OR campaign.Type Like:'Parent Panel' OR campaign.Type Like:'PMP Training' OR campaign.Type Like:'PPW' OR campaign.Type Like:'Workshop'  Or  campaign.Type Like:'%Playgroup%' OR campaign.Type Like: 'Support Group')];
        
        for(campaignMember cm: limitCurContactEvents3){
            setConCurrent3.add(cm.contactID);
            setConCurrentMaster.add(cm.contactID);
            setConmMsterCG.add(c.ContactID);
            System.debug('setConCurrent3 ' + setConCurrent3.size());
        } */
        
    }
    //  ********************************************************************
    // Get kids PRIOR 36 - 47
    private void GenerateKids4(){ 
      /*  List<case> limitContactInteractions4 =[SELECT Child_Person_with_Disability_ID__c, ContactId
                                               FROM case
                                               WHERE start_time__c >= :dateFrom AND start_time__c <= :PriorQuarterEnds
                                               And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <48 
                                               AND AgeMonthCaseTime__c !=NULL
                                               AND Call_Type__c != 'Left Message 1'
                                               AND Call_Type__c != 'Left Message 2'
                                               AND Call_Type__c != '# disconnected'
                                               AND Call_Type__c != 'Sent UTC Letter'
                                               AND Call_Type__c != 'No answering machine'
                                               AND Child_Person_with_Disability_ID__c !='Neale'
                                               AND Child_Person_with_Disability_ID__c !='test'
                                               AND (RecordTypeID = '012G0000000qhDK' OR  Call_Type__c LIKE:pmpVar) ];
        for(case c: limitContactInteractions4){
            setConPrior4.add(c.Child_Person_with_Disability_ID__c);
            setConMasterPrior.add(c.Child_Person_with_Disability_ID__c);
            setConPriorCG.add(c.ContactID);
        }
        
        
        // get kids between 36-47 Months, listed in Events
        List<campaignMember> limitContactEvents4 =[SELECT contactID
                                                   FROM campaignMember
                                                   WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :PriorQuarterEnds
                                                   And AgeMonthsAtCampaign__c>=0 AND AgeMonthsAtCampaign__c <48
                                                   AND AgeMonthsAtCampaign__c !=NULL
                                                   AND contact.name !='Neale'
                                                   AND contact.name !='test'
                                                   AND No_Show__c = false
                                                   AND Status = 'Child Attendee'
                                                   AND (NOT campaign.Name Like '%Childcare%')
                                                   AND (NOT campaign.Name Like '%Cancelled%')
                                                   AND (NOT campaign.Name Like '%No Show%')
                                                   AND (NOT campaign.Name Like '%Postponed%')
                                                   AND (campaign.Type Like: 'Clinic' OR  campaign.Type Like: 'Conference' OR campaign.Type Like: 'IRC Conference'  OR campaign.Type Like: 'IRC Workshop' OR campaign.Type Like: 'Other Agency Training' OR campaign.Type Like:'Parent Panel' OR campaign.Type Like:'PMP Training' OR campaign.Type Like:'PPW' OR campaign.Type Like:'Workshop'  Or  campaign.Type Like:'%Playgroup%' OR campaign.Type Like: 'Support Group')];
        for(campaignMember cm: limitContactEvents4){
            setConPrior4.add(cm.contactID);
            setConMasterPrior.add(cm.contactID);
        }
*/
        
        
        // get kids between 36-47 Months, listed in interactions, YTD
        List<case> limitCurrentConInteractions4 =[SELECT Child_Person_with_Disability_ID__c, ContactID
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=36 AND AgeMonthCaseTime__c <48 
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'Sent UTC Letter'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Child_Person_with_Disability_ID__c !='Neale'
                                                  AND Child_Person_with_Disability_ID__c !='test'
                                                  AND Child_Person_with_Disability_ID__c NOT In: setConCurrentMaster
                                                  AND Child_Person_with_Disability_ID__c NOT IN : setConPrior
                                                  AND (RecordTypeID = '012G0000000qhDK' OR  Call_Type__c LIKE:pmpVar) ];
        
        for(case c: limitCurrentConInteractions4){
            setConCurrent4.add(c.Child_Person_with_Disability_ID__c);
            setConCurrentMaster.add(c.Child_Person_with_Disability_ID__c);
            setConMasterCG.add(c.ContactID);
            
        }
        /*
        // get kids between 36-47 Months, listed in Events, YTD
        List<campaignMember> limitCurContactEvents4 =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=36 AND AgeMonthsAtCampaign__c <48
                                                      AND AgeMonthsAtCampaign__c !=NULL
                                                      AND contact.name !='Neale'
                                                      AND contact.name !='test'
                                                      AND No_Show__c = false
                                                      AND Status = 'Child Attendee'
                                                      AND (NOT campaign.Name Like '%Childcare%')
                                                      AND (NOT campaign.Name Like '%Cancelled%')
                                                      AND (NOT campaign.Name Like '%No Show%')
                                                      AND (NOT campaign.Name Like '%Postponed%')
                                                      AND (campaign.Type Like: 'Clinic' OR  campaign.Type Like: 'Conference' OR campaign.Type Like: 'IRC Conference'  OR campaign.Type Like: 'IRC Workshop' OR campaign.Type Like: 'Other Agency Training' OR campaign.Type Like:'Parent Panel' OR campaign.Type Like:'PMP Training' OR campaign.Type Like:'PPW' OR campaign.Type Like:'Workshop'  Or  campaign.Type Like:'%Playgroup%' OR campaign.Type Like: 'Support Group')];
        
        for(campaignMember cm: limitCurContactEvents4){
            setConCurrent4.add(cm.contactID);
            setConCurrentMaster.add(cm.contactID);
            System.debug('setConCurrent4Size  18 & 23 Month' + setConCurrent4.size());
        } */
        
    }
    
    //  *************************************
    //  48-59 PRIOR
    
    private void GenerateKids5(){
      /*  List<case> limitContactInteractions5 =[SELECT Child_Person_with_Disability_ID__c, ContactID
                                               FROM case
                                               WHERE start_time__c >= :dateFrom AND start_time__c <= :PriorQuarterEnds
                                               And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <60
                                               AND AgeMonthCaseTime__c !=NULL
                                               AND Call_Type__c != 'Left Message 1'
                                               AND Call_Type__c != 'Left Message 2'
                                               AND Call_Type__c != '# disconnected'
                                               AND Call_Type__c != 'Sent UTC Letter'
                                               AND Call_Type__c != 'No answering machine'
                                               AND Child_Person_with_Disability_ID__c !='Neale'
                                               AND Child_Person_with_Disability_ID__c !='test'
                                               AND (RecordTypeID = '012G0000000qhDK' OR  Call_Type__c LIKE:pmpVar) ];
        for(case c: limitContactInteractions5){
            setConPrior5.add(c.Child_Person_with_Disability_ID__c);
            setConMasterPrior.add(c.Child_Person_with_Disability_ID__c);
            setConPriorCG.add(c.ContactID);
        }
       
        // get kids between 48-59 Months, listed in Events
        List<campaignMember> limitContactEvents5 =[SELECT contactID
                                                   FROM campaignMember
                                                   WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :PriorQuarterEnds
                                                   And AgeMonthsAtCampaign__c>=0 AND AgeMonthsAtCampaign__c <60
                                                   AND AgeMonthsAtCampaign__c !=NULL
                                                   AND contact.name !='Neale'
                                                   AND contact.name !='test'
                                                   AND No_Show__c = false
                                                   AND Status = 'Child Attendee'
                                                   AND (NOT campaign.Name Like '%Childcare%')
                                                   AND (NOT campaign.Name Like '%Cancelled%')
                                                   AND (NOT campaign.Name Like '%No Show%')
                                                   AND (NOT campaign.Name Like '%Postponed%')
                                                   AND (campaign.Type Like: 'Clinic' OR  campaign.Type Like: 'Conference' OR campaign.Type Like: 'IRC Conference'  OR campaign.Type Like: 'IRC Workshop' OR campaign.Type Like: 'Other Agency Training' OR campaign.Type Like:'Parent Panel' OR campaign.Type Like:'PMP Training' OR campaign.Type Like:'PPW' OR campaign.Type Like:'Workshop'  Or  campaign.Type Like:'%Playgroup%' OR campaign.Type Like: 'Support Group')];
        for(campaignMember cm: limitContactEvents5){
            setConPrior5.add(cm.contactID);
            setConMasterPrior.add(cm.contactID);
            
            System.debug('setConPrior5Size 48-59 Months = ' + setConPrior5.size());
        } */
        
        // get kids between 48-59 Months, listed in interactions, YTD
        List<case> limitCurrentConInteractions5 =[SELECT Child_Person_with_Disability_ID__c, ContactID
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=48 AND AgeMonthCaseTime__c <60
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'Sent UTC Letter'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Child_Person_with_Disability_ID__c !='Neale'
                                                  AND Child_Person_with_Disability_ID__c !='test'
                                                  AND Child_Person_with_Disability_ID__c NOT In: setConCurrentMaster
                                                 AND Child_Person_with_Disability_ID__c NOT IN : setConPrior
                                                  AND (RecordTypeID = '012G0000000qhDK' OR  Call_Type__c LIKE:pmpVar) ];
        
        for(case c: limitCurrentConInteractions5){
            setConCurrent5.add(c.Child_Person_with_Disability_ID__c);
            setConCurrentMaster.add(c.Child_Person_with_Disability_ID__c);
            setConMasterCG.add(c.ContactID);
        }
        /*
        // get kids between 48-59 Months, listed in Events, report month requested
        List<campaignMember> limitCurContactEvents5 =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=48 AND AgeMonthsAtCampaign__c <60
                                                      AND AgeMonthsAtCampaign__c !=NULL
                                                      AND contact.name !='Neale'
                                                      AND contact.name !='test'
                                                      AND No_Show__c = false
                                                      AND Status = 'Child Attendee'
                                                      AND (NOT campaign.Name Like '%Childcare%')
                                                      AND (NOT campaign.Name Like '%Cancelled%')
                                                      AND (NOT campaign.Name Like '%No Show%')
                                                      AND (NOT campaign.Name Like '%Postponed%')
                                                      AND (campaign.Type Like: 'Clinic' OR  campaign.Type Like: 'Conference' OR campaign.Type Like: 'IRC Conference'  OR campaign.Type Like: 'IRC Workshop' OR campaign.Type Like: 'Other Agency Training' OR campaign.Type Like:'Parent Panel' OR campaign.Type Like:'PMP Training' OR campaign.Type Like:'PPW' OR campaign.Type Like:'Workshop'  Or  campaign.Type Like:'%Playgroup%' OR campaign.Type Like: 'Support Group')];
        
        for(campaignMember cm: limitCurContactEvents5){
            setConCurrent5.add(cm.contactID);
            setConCurrentMaster.add(cm.contactID);
            System.debug('setConCurrent5 Size 48-59 Months =' + setConCurrent5.size());
        } */
        
    }
    //   ******************************************************
    //   60 - 71 Prior
    private void GenerateKids6() {
      /*  List<case> limitContactInteractions6 =[SELECT Child_Person_with_Disability_ID__c, ContactID
                                               FROM case
                                               WHERE start_time__c >= :dateFrom AND start_time__c <= :PriorQuarterEnds
                                               And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <72 
                                               AND AgeMonthCaseTime__c !=NULL
                                               AND Call_Type__c != 'Left Message 1'
                                               AND Call_Type__c != 'Left Message 2'
                                               AND Call_Type__c != '# disconnected'
                                               AND Call_Type__c != 'Sent UTC Letter'
                                               AND Call_Type__c != 'No answering machine'
                                               AND Child_Person_with_Disability_ID__c !='Neale'
                                               AND Child_Person_with_Disability_ID__c !='test'
                                               AND (RecordTypeID = '012G0000000qhDK' OR  Call_Type__c LIKE:pmpVar) ];
        for(case c: limitContactInteractions6){
            setConPrior6.add(c.Child_Person_with_Disability_ID__c);
            setConMasterPrior.add(c.Child_Person_with_Disability_ID__c);
            setConPriorCG.add(c.ContactID);
        }
       
        // get kids between 60-71 Months, listed in Events
        List<campaignMember> limitContactEvents6 =[SELECT contactID
                                                   FROM campaignMember
                                                   WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :PriorQuarterEnds
                                                   And AgeMonthsAtCampaign__c>=0 AND AgeMonthsAtCampaign__c <72
                                                   AND AgeMonthsAtCampaign__c != NULL
                                                   AND contact.name !='Neale'
                                                   AND contact.name !='test'
                                                   AND No_Show__c = false
                                                   AND Status = 'Child Attendee'
                                                   AND (NOT campaign.Name Like '%Childcare%')
                                                   AND (NOT campaign.Name Like '%Cancelled%')
                                                   AND (NOT campaign.Name Like '%No Show%')
                                                   AND (NOT campaign.Name Like '%Postponed%')
                                                   AND (campaign.Type Like: 'Clinic' OR  campaign.Type Like: 'Conference' OR campaign.Type Like: 'IRC Conference'  OR campaign.Type Like: 'IRC Workshop' OR campaign.Type Like: 'Other Agency Training' OR campaign.Type Like:'Parent Panel' OR campaign.Type Like:'PMP Training' OR campaign.Type Like:'PPW' OR campaign.Type Like:'Workshop'  Or  campaign.Type Like:'%Playgroup%' OR campaign.Type Like: 'Support Group')];
        for(campaignMember cm: limitContactEvents6){
            setConPrior6.add(cm.contactID);
            setConMasterPrior.add(cm.contactID);
            System.debug('setConPrior6 Size 60-71 Months = ' + setConPrior6.size());
            
        } */
        
        
        // get kids between 60-71 Months, listed in interactions, YTD
        List<case> limitCurrentConInteractions6 =[SELECT Child_Person_with_Disability_ID__c, ContactID
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=60 AND AgeMonthCaseTime__c <72
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'Sent UTC Letter'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Child_Person_with_Disability_ID__c !='Neale'
                                                  AND Child_Person_with_Disability_ID__c !='test'
                                                  AND Child_Person_with_Disability_ID__c NOT In: setConCurrentMaster
                                                  AND Child_Person_with_Disability_ID__c NOT IN : setConPrior
                                                  AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:pmpVar)  ];
        
        for(case c: limitCurrentConInteractions6){
            setConCurrent6.add(c.Child_Person_with_Disability_ID__c);
            setConCurrentMaster.add(c.Child_Person_with_Disability_ID__c);
            setConMasterCG.add(c.ContactID);
        }
        /*
        // get kids between 60-71 Months, listed in Events, report month requested
        List<campaignMember> limitCurContactEvents6 =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=60 AND AgeMonthsAtCampaign__c <72
                                                      AND AgeMonthsAtCampaign__c != NULL
                                                      AND contact.name !='Neale'
                                                      AND contact.name !='test'
                                                      AND No_Show__c = false
                                                      AND Status = 'Child Attendee'
                                                      AND (NOT campaign.Name Like '%Childcare%')
                                                      AND (NOT campaign.Name Like '%Cancelled%')
                                                      AND (NOT campaign.Name Like '%No Show%')
                                                      AND (NOT campaign.Name Like '%Postponed%')
                                                      AND (campaign.Type Like: 'Clinic' OR  campaign.Type Like: 'Conference' OR campaign.Type Like: 'IRC Conference'  OR campaign.Type Like: 'IRC Workshop' OR campaign.Type Like: 'Other Agency Training' OR campaign.Type Like:'Parent Panel' OR campaign.Type Like:'PMP Training' OR campaign.Type Like:'PPW' OR campaign.Type Like:'Workshop'  Or  campaign.Type Like:'%Playgroup%' OR campaign.Type Like: 'Support Group')];
        
        for(campaignMember cm: limitCurContactEvents6){
            setConCurrent6.add(cm.contactID);
            setConCurrentMaster.add(cm.contactID);
            
            System.debug('setConCurrent6 Size ' + setConCurrent6.size());
        } */
        
    }
    
    
    // Generate output begins
    //  ***********************************  
    public List<ExWrapperEX> getGenerateAge1(){  
        
        // Cureent Q Totals  = FYTD - Prior Q
        list<ExWrapperEX> age1QueryTotals = new List <ExWrapperEX>();
        List<AggregateResult> ageRange1 =[SELECT RecordTypeID  ln, Count(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent1
                                          AND Birthdate != NULL
                                          //AND ID NOT IN : setConPrior
                                          Group By RecordTypeID];
        System.debug('age - # of IDs after ageRange1 query runs' + ageRange1.size());
        
        
        
        for(AggregateResult a: ageRange1){
            
            String.valueOf(a.get('ln'));
            
            age1QueryTotals.add(new ExWrapperEX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));    
            
        }
        
        return age1QueryTotals; 
        
    }
    //  ************************************
    
    public List<ExWrapperEX> getGenerateAge2(){  
        list<ExWrapperEX> age2QueryTotals = new List <ExWrapperEX>();
        List<AggregateResult> ageRange2 =[SELECT RecordTypeID  ln, Count(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent2
                                          AND Birthdate != NULL
                                          //AND ID NOT IN: setConCurrentMaster
                                          //AND ID NOT IN: setConPrior
                                          Group By RecordTypeID];
        System.debug('age - # of IDs after ageRange2 query runs' + ageRange2.size());
        for(AggregateResult a: ageRange2){
            
            String.valueOf(a.get('ln'));
            
            age2QueryTotals.add(new ExWrapperEX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));    
        }
        return age2QueryTotals; 
    }
    
    // ***********************************
    
    public List<ExWrapperEX> getGenerateAge3(){  
        list<ExWrapperEX> age3QueryTotals = new List <ExWrapperEX>();
        List<AggregateResult> ageRange3 =[SELECT RecordTypeID  ln, Count(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent3
                                          AND Birthdate != NULL
                                          //AND ID NOT IN: setConCurrentMaster
                                          //AND ID NOT IN: setConPrior
                                          Group By RecordTypeID];
        System.debug('age - # of IDs after ageRange3 query runs' + ageRange3.size());
        for(AggregateResult a: ageRange3){
            
            String.valueOf(a.get('ln'));
            
            age3QueryTotals.add(new ExWrapperEX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));    
        }
        return age3QueryTotals; 
    }
    
    //  ***********************************************************
    //  return ageR4      
    
    public List<ExWrapperEX> getGenerateAge4(){  
        list<ExWrapperEX> age4QueryTotals = new List <ExWrapperEX>();
        List<AggregateResult> ageRange4 =[SELECT RecordTypeID  ln, Count(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent4
                                          AND Birthdate != NULL
                                          //AND ID NOT IN: setConCurrentMaster
                                          //AND ID NOT IN: setConPrior
                                          Group By RecordTypeID ];
        System.debug('age - # of IDs after ageRange4 query runs' + ageRange4.size());
        for(AggregateResult a: ageRange4){
            
            String.valueOf(a.get('ln'));
            
            age4QueryTotals.add(new ExWrapperEX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));    
        }
        return age4QueryTotals; 
    }
    
    // ****************************************
    // retern Age 5
    public List<ExWrapperEX> getGenerateAge5(){  
        list<ExWrapperEX> age5QueryTotals = new List <ExWrapperEX>();
        List<AggregateResult> ageRange5 =[SELECT RecordTypeID  ln, Count(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent5
                                          AND Birthdate != NULL
                                          //AND ID NOT IN: setConCurrentMaster
                                          //AND ID NOT IN: setConPrior
                                          Group By RecordTypeID ];
        System.debug('age - # of IDs after ageRange5 query runs' + ageRange5.size());
        for(AggregateResult a: ageRange5){
            
            String.valueOf(a.get('ln'));
            
            age5QueryTotals.add(new ExWrapperEX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));    
        }
        return age5QueryTotals; 
    }
    
    // ****************************************
    // return ageR6
    
    
    public List<ExWrapperEX> getGenerateAge6(){  
        list<ExWrapperEX> age6QueryTotals = new List <ExWrapperEX>();
        List<AggregateResult> ageRange6 =[SELECT RecordTypeID  ln, Count(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent6
                                          AND Birthdate != NULL
                                          //AND ID NOT IN: setConCurrentMaster
                                          //AND ID NOT IN: setConPrior
                                          Group By RecordTypeID];
        System.debug('age - # of IDs after ageRange6 query runs' + ageRange6.size());
        for(AggregateResult a: ageRange6){
            
            String.valueOf(a.get('ln'));
            
            age6QueryTotals.add(new ExWrapperEX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));    
        }
        return age6QueryTotals; 
    }
    
    
    public List<ExWrapperEX> getGenerateGenC() { 
        //Current
        // Q1 do not back out setConPrior for Current Q
        
        list<ExWrapperEX> genCQueryTotals = new List <ExWrapperEX>();
        List<AggregateResult> genCAggregateResult = 
            [select  family__Gender__c zpF, Count (id) ContactCNTzpF                    
             From contact
             WHERE ID IN:setConCurrentMaster
             AND ID NOT IN: setConPrior
             AND Birthdate != NULL
             group by Rollup (family__Gender__c)];
        
        
        for (AggregateResult arRList : genCAggregateResult) { 
            
             String tname='';
            if(String.valueOf(arRList.get('zpF'))==NULL){
                tname='Total';
            }else{
                tname=String.valueOf(arRList.get('zpF'));
            }       
            GenCQueryTotals.add(new ExWrapperEX(String.valueOf(tname), (Integer.valueOf(arRList.get('ContactCNTzpF')))));  
        }
        return genCQueryTotals;
    }   
    
    //Gender Prior
    public List<ExWrapperEX> getGenerateGenP() { 
        list<ExWrapperEX> GenPQueryTotals = new List <ExWrapperEX>();
        List<AggregateResult> genPAggregateResult = 
            [select  family__Gender__c zpF, Count (id) ContactCNTzpF                    
             From contact
             WHERE ID IN :setConPrior
             AND Birthdate != NULL
             group by Rollup (family__Gender__c)];
        
        
        for (AggregateResult arRList : genPAggregateResult) { 
            String tname='';
            if(String.valueOf(arRList.get('zpF'))==NULL){
                tname='Total';
            }else{
                tname=String.valueOf(arRList.get('zpF'));
            }       
            GenPQueryTotals.add(new ExWrapperEX(String.valueOf(tname), (Integer.valueOf(arRList.get('ContactCNTzpF')))));    
        }
        return GenPQueryTotals;
    }
    // Gender YTD
    public List<ExWrapperEX> getGenerateGenYTD() { 
        list<ExWrapperEX> GenYTDQueryTotals = new List <ExWrapperEX>();
        List<AggregateResult> genYTDAggregateResult = 
            [select  family__Gender__c zpF, Count(id) ContactCNTzpF                    
             From contact
             WHERE (ID IN : setConCurrentMaster
             OR ID IN : setConPrior)
             AND Birthdate != NULL
            group by Rollup (family__Gender__c)];
        
        
        for (AggregateResult arRList : genYTDAggregateResult) { 
            String tname='';
            if(String.valueOf(arRList.get('zpF'))==NULL){
                tname='Total';
            }else{
               tname= String.valueOf(arRList.get('zpF'));
            }       
            GenYTDQueryTotals.add(new ExWrapperEX(String.valueOf(tname), (Integer.valueOf(arRList.get('ContactCNTzpF')))));    
        }
        return GenYTDQueryTotals;
    }
    /**********************  End Gender */
    
    
    /**********************  Race **/
      public List<ExWrapperEX> getGenerateRace(){
        System.debug('setconMasterCG' +  setconMasterCG.size());
        list<ExWrapperEX> RaceQueryTotals = new List <ExWrapperEX>();
        List<Contact> RaceList = 
            [select  Family__Race__c , ID              
             From contact
             WHERE ID IN:setConCurrentMaster
             AND ID NOT IN: setConPrior 
             AND Birthdate != NULL
            ];
        
        //String[] regions = bsc.Region__c.split(';');
        List <String> allRace;
        String NewName ='';
        Map<String,Integer> RaceMap = new Map<String,Integer>();  // Native Am
        Map<String,Integer> RaceMap0 = new Map<String,Integer>(); // Native Al
        Map<String,Integer> RaceMap1 = new Map<String,Integer>(); // AF Am/Black
        Map<String,Integer> RaceMap2 = new Map<String,Integer>(); // Asian
        Map<String,Integer> RaceMap3 = new Map<String,Integer>(); // PI
        Map<String,Integer> RaceMap4 = new Map<String,Integer>(); // MultiEth
        Map<String,Integer> RaceMap5 = new Map<String,Integer>(); // Middle Eastern
        Map<String,Integer> RaceMap6 = new Map<String,Integer>(); // White
        Map<String,Integer> RaceMap7 = new Map<String,Integer>(); // Declined
        Map<String,Integer> RaceMap8 = new Map<String,Integer>(); // Unknown
        Map<String,Integer> RaceMap9 = new Map<String,Integer>(); // Other
        
        Integer NativeAM = 0;
        Integer NativeAl = 0;
        Integer AAm = 0;
        Integer Asian = 0;
        Integer Pacific =0;
        Integer Mid =0;
        Integer Multi =0;
        Integer White = 0;
        Integer Declined =0;
        Integer Unknown =0;
        Integer Other =0;
        Integer Count = 0;
        String Total = 'Total';
        Integer Hold =Null;
        
        for (Contact arList : RaceList) { 
            
            Count = Count + 1;
            if(arList.Family__Race__c !=NULL){
                
                Set<String> RaceTally = new Set <String>(arList.Family__Race__c.split(';'));
                NewName = Null;
                if (RaceTally.size()>1) {
                    NewName ='Multiracial/Multiethnic';
                    Multi = Multi + 1;
                    RaceMap4.put(NewName, Multi);  
                    // Break;
                    System.Debug('**************  before split NewName= ' + NewName);
                } Else  for (String str : RaceTally) {

                    if (str.contains('Native American')) {
                        NewName ='Native American';
                        NativeAM = NativeAM + 1;
                        RaceMap.put(NewName, NativeAM);
                        // Break;
                    } Else If (str.contains('Native Alaskan')) {
                        NewName ='Native Alaskan';
                        NativeAl = NativeAl + 1;
                        RaceMap0.put(NewName, NativeAl);
                        // Break;
                    } Else if (str.contains('African') || str.contains('Black')) {
                        NewName ='African American';
                        AAm = AAm + 1;
                        RaceMap1.put(NewName, AAm);
                        Break;
                    } Else If (str.contains('Asian')) {
                        NewName ='Asian';
                        Asian = Asian + 1;
                        RaceMap2.put(NewName, Asian);
                        // Break;
                    } Else If (str.contains('Pacific')) {
                        NewName ='Pacific Islander';
                        Pacific = Pacific + 1;
                        RaceMap3.put(NewName, Pacific);
                        // Break;
                        // 
                      } Else If (str.contains('Multi')) {
                        NewName ='Multiracial/Multiethnic';
                        Multi = Multi + 1;
                        RaceMap4.put(NewName, Multi);
                        // Break;  
                   
                    } Else If (str.contains('Middle')) {
                        NewName ='Middle Eastern';
                        Mid = Mid + 1;
                        RaceMap5.put(NewName, Mid);
                        // Break;
                    } Else If (str.contains('White')) {
                        NewName ='White';
                        White = White + 1;
                        RaceMap6.put(NewName, White);
                        // Break;
                    } Else If (str.contains('Declined')){
                        NewName ='Declined'; 
                        Declined = Declined + 1;
                        RaceMap7.put(NewName, Declined);
                        // Break;
                    } Else If (str.contains('Unknown')){
                        NewName ='Unknown';
                        Unknown = Unknown + 1;
                        RaceMap8.put(NewName, Unknown);
                        // Break;
                    } Else {
                        NewName ='Other';
                        Other = Other + 1;
                        RaceMap9.put(NewName, Other);
                        // Break;
                    } 
                    System.Debug('************** After All IFs NewName= ' + NewName);
                    Break;
                }   
                
                // Fix this
            }  Else{
                NewName ='Unknown';
                Unknown = Unknown + 1;
                RaceMap8.put(NewName, Unknown);
            } 
            
            
        }
        
        // System.debug('Count= ' + allRace + '  NewName= ' + Newname); // need to add each item to allrace for total
        RaceQueryTotals.add(new ExWrapperEX(String.valueOf(raceMap), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new ExWrapperEX(String.valueOf(raceMap0), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new ExWrapperEX(String.valueOf(raceMap1), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new ExWrapperEX(String.valueOf(raceMap2), (Integer.valueOf(Hold)))); 
        RaceQueryTotals.add(new ExWrapperEX(String.valueOf(raceMap3), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new ExWrapperEX(String.valueOf(raceMap4), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new ExWrapperEX(String.valueOf(raceMap5), (Integer.valueOf(Hold)))); 
        RaceQueryTotals.add(new ExWrapperEX(String.valueOf(raceMap6), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new ExWrapperEX(String.valueOf(raceMap7), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new ExWrapperEX(String.valueOf(raceMap8), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new ExWrapperEX(String.valueOf(raceMap9), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new ExWrapperEX(String.valueOf(Total), (Integer.valueOf(count))));
        
        return RaceQueryTotals;
        
    }
    
     public List<ExWrapperEX> getGenerateRaceYTD(){
        System.debug('setconMasterCG' +  setconMasterCG.size());
        list<ExWrapperEX> RaceQueryTotals = new List <ExWrapperEX>();
        List<Contact> RaceList = 
            [select  Family__Race__c , ID              
             From contact
             WHERE ID IN:setConCurrentMaster
             OR ID  IN: setConPrior 
             //AND Birthdate != NULL
            ];
        
        //String[] regions = bsc.Region__c.split(';');
        List <String> allRace;
        String NewName ='';
        Map<String,Integer> RaceMap = new Map<String,Integer>();  // Native Am
        Map<String,Integer> RaceMap0 = new Map<String,Integer>(); // Native Al
        Map<String,Integer> RaceMap1 = new Map<String,Integer>(); // AF Am/Black
        Map<String,Integer> RaceMap2 = new Map<String,Integer>(); // Asian
        Map<String,Integer> RaceMap3 = new Map<String,Integer>(); // PI
        Map<String,Integer> RaceMap4 = new Map<String,Integer>(); // MultiEth
        Map<String,Integer> RaceMap5 = new Map<String,Integer>(); // Middle Eastern
        Map<String,Integer> RaceMap6 = new Map<String,Integer>(); // White
        Map<String,Integer> RaceMap7 = new Map<String,Integer>(); // Declined
        Map<String,Integer> RaceMap8 = new Map<String,Integer>(); // Unknown
        Map<String,Integer> RaceMap9 = new Map<String,Integer>(); // Other
        
        Integer NativeAM = 0;
        Integer NativeAl = 0;
        Integer AAm = 0;
        Integer Asian = 0;
        Integer Pacific =0;
        Integer Mid =0;
        Integer Multi =0;
        Integer White = 0;
        Integer Declined =0;
        Integer Unknown =0;
        Integer Other =0;
        Integer Count = 0;
        String Total = 'Total';
        Integer Hold =Null;
        
        for (Contact arList : RaceList) { 
            
            Count = Count + 1;
            if(arList.Family__Race__c !=NULL){
                
                Set<String> RaceTally = new Set <String>(arList.Family__Race__c.split(';'));
                NewName = Null;
                if (RaceTally.size()>1) {
                    NewName ='Multiracial/Multiethnic';
                    Multi = Multi + 1;
                    RaceMap4.put(NewName, Multi);  
                    // Break;
                    System.Debug('**************  before split NewName= ' + NewName);
                } Else  for (String str : RaceTally) {

                    if (str.contains('Native American')) {
                        NewName ='Native American';
                        NativeAM = NativeAM + 1;
                        RaceMap.put(NewName, NativeAM);
                        // Break;
                    } Else If (str.contains('Native Alaskan')) {
                        NewName ='Native Alaskan';
                        NativeAl = NativeAl + 1;
                        RaceMap0.put(NewName, NativeAl);
                        // Break;
                    } Else if (str.contains('African') || str.contains('Black')) {
                        NewName ='African American';
                        AAm = AAm + 1;
                        RaceMap1.put(NewName, AAm);
                        Break;
                    } Else If (str.contains('Asian')) {
                        NewName ='Asian';
                        Asian = Asian + 1;
                        RaceMap2.put(NewName, Asian);
                        // Break;
                    } Else If (str.contains('Pacific')) {
                        NewName ='Pacific Islander';
                        Pacific = Pacific + 1;
                        RaceMap3.put(NewName, Pacific);
                        // Break;
                        // 
                      } Else If (str.contains('Multi')) {
                        NewName ='Multiracial/Multiethnic';
                        Multi = Multi + 1;
                        RaceMap4.put(NewName, Multi);
                        // Break;  
                   
                    } Else If (str.contains('Middle')) {
                        NewName ='Middle Eastern';
                        Mid = Mid + 1;
                        RaceMap5.put(NewName, Mid);
                        // Break;
                    } Else If (str.contains('White')) {
                        NewName ='White';
                        White = White + 1;
                        RaceMap6.put(NewName, White);
                        // Break;
                    } Else If (str.contains('Declined')){
                        NewName ='Declined'; 
                        Declined = Declined + 1;
                        RaceMap7.put(NewName, Declined);
                        // Break;
                    } Else If (str.contains('Unknown')){
                        NewName ='Unknown';
                        Unknown = Unknown + 1;
                        RaceMap8.put(NewName, Unknown);
                        // Break;
                    } Else {
                        NewName ='Other';
                        Other = Other + 1;
                        RaceMap9.put(NewName, Other);
                        // Break;
                    } 
                    System.Debug('************** After All IFs NewName= ' + NewName);
                    Break;
                }   
                
                // Fix this
            }  Else{
                NewName ='Unknown';
                Unknown = Unknown + 1;
                RaceMap8.put(NewName, Unknown);
            } 
            
            
        }
        
        // System.debug('Count= ' + allRace + '  NewName= ' + Newname); // need to add each item to allrace for total
        RaceQueryTotals.add(new ExWrapperEX(String.valueOf(raceMap), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new ExWrapperEX(String.valueOf(raceMap0), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new ExWrapperEX(String.valueOf(raceMap1), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new ExWrapperEX(String.valueOf(raceMap2), (Integer.valueOf(Hold)))); 
        RaceQueryTotals.add(new ExWrapperEX(String.valueOf(raceMap3), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new ExWrapperEX(String.valueOf(raceMap4), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new ExWrapperEX(String.valueOf(raceMap5), (Integer.valueOf(Hold)))); 
        RaceQueryTotals.add(new ExWrapperEX(String.valueOf(raceMap6), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new ExWrapperEX(String.valueOf(raceMap7), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new ExWrapperEX(String.valueOf(raceMap8), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new ExWrapperEX(String.valueOf(raceMap9), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new ExWrapperEX(String.valueOf(Total), (Integer.valueOf(count))));
        
        return RaceQueryTotals;
        
    }
    
    /*********End Race */
    
    /*************************** Ethnicity */
    public List<ExWrapperEX> getGenerateEthnicity() {
        
        // get count Language 
        list<ExWrapperEX> queryTotals = new List <ExWrapperEX>();
        List<AggregateResult> aggResult = 
            [select  Family__Ethnicity__c aa, Count_Distinct (ID) bb                 
             From contact
             WHERE ID IN:setConCurrentMaster
             AND ID NOT IN: setConMasterPrior
             AND Birthdate != NULL
             group by Rollup (Family__Ethnicity__c) ];
 
        String NewName ='';
        for (AggregateResult arList : aggResult) { 
            If(String.valueOf(arList.get('aa'))==NULL){
                NewName ='Total'; 
            } ELSE{
                NewName = (String.valueOf(arList.get('aa')));  
                
            }
   
            queryTotals.add(new ExWrapperEX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));     
        }
        return queryTotals;
    }   
    
     /*************************** Ethnicity YTD */
    public List<ExWrapperEX> getGenerateEthnicityYTD() {
        
        // get count Language 
        list<ExWrapperEX> queryTotals = new List <ExWrapperEX>();
        List<AggregateResult> aggResult = 
            [select  Family__Ethnicity__c aa, Count_Distinct (ID) bb                 
             From contact
             WHERE ID IN:setConCurrentMaster
             Or ID IN: setConMasterPrior
             //AND Birthdate != NULL
             group by Rollup (Family__Ethnicity__c) ];
 
        String NewName ='';
        for (AggregateResult arList : aggResult) { 
            If(String.valueOf(arList.get('aa'))==NULL){
                NewName ='Total'; 
            } ELSE{
                NewName = (String.valueOf(arList.get('aa')));  
                
            }
   
            queryTotals.add(new ExWrapperEX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));     
        }
        return queryTotals;
    }   
    /****************End Ethnicity  */
    
    
    /********************************* Parent Language begins */
    
     public List<ExWrapperEX> getGenerateParentLanguageP() {
        
        // get count Language 
        list<ExWrapperEX> queryTotals = new List <ExWrapperEX>();
        List<AggregateResult> aggResult = 
            [select  Family__Primary_Language__c aa, Count_Distinct (ID) bb                 
             From contact
             WHERE ID IN: setConPriorCG 
             
             group by Rollup (Family__Primary_Language__c) ];
      
        
        String NewName ='';
        for (AggregateResult arList : aggResult) { 
            If(String.valueOf(arList.get('aa'))==NULL){
                NewName ='Total'; 
            } ELSE{
                NewName = (String.valueOf(arList.get('aa')));  
                
            }
  
            
            queryTotals.add(new ExWrapperEX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));     
        }
        return queryTotals;
    }   
    
     public List<ExWrapperEX> getGenerateParentLanguage() {
        
        // get count Language 
        list<ExWrapperEX> queryTotals = new List <ExWrapperEX>();
        List<AggregateResult> aggResult = 
            [select  Family__Primary_Language__c aa, Count_Distinct (ID) bb                 
             From contact
             WHERE ID IN: setConMasterCG 
             AND ID NOT IN: setConPriorCG
            
             group by Rollup (Family__Primary_Language__c) ];
      
        
        String NewName ='';
        for (AggregateResult arList : aggResult) { 
            If(String.valueOf(arList.get('aa'))==NULL){
                NewName ='Total'; 
            } ELSE{
                NewName = (String.valueOf(arList.get('aa')));  
                
            }
            
            queryTotals.add(new ExWrapperEX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));     
        }
        return queryTotals;
    }   
    
    
     public List<ExWrapperEX> getGenerateParentLanguageYTD() {
        
        // get count Language 
        list<ExWrapperEX> queryTotals = new List <ExWrapperEX>();
        List<AggregateResult> aggResult = 
            [select  Family__Primary_Language__c aa, Count_Distinct (ID) bb                 
             From contact
             WHERE ID IN: setConMasterCG 
             OR ID IN: setConPriorCG
            
             group by Rollup (Family__Primary_Language__c) ];
      
        
        String NewName ='';
        for (AggregateResult arList : aggResult) { 
            If(String.valueOf(arList.get('aa'))==NULL){
                NewName ='Total'; 
            } ELSE{
                NewName = (String.valueOf(arList.get('aa')));  
                
            }
            
            
            queryTotals.add(new ExWrapperEX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));     
        }
        return queryTotals;
    }   
    /*************
     * 6 agegroups Output ID's
     * ****************/
      
    
       public List<ExWrapperEX> getAge1() {  
        list<ExWrapperEX> queryTotals = new List <ExWrapperEX>();
        List<Contact> aggResult = 
            [select  ID, Family__Age__c               
            FROM Contact
              WHERE ID IN : setConCurrent1
              AND Birthdate != NULL
             // AND ID NOT IN : setConPrior
            ];
      
          for (Contact arList : aggResult) {
              
          
         queryTotals.add(new ExWrapperEX(String.valueOf(arList.ID), (Integer.valueOf(arList.Family__Age__c))));     
        }
        return queryTotals;
      
  }
    
       public List<ExWrapperEX> getAge2() {  
        list<ExWrapperEX> queryTotals = new List <ExWrapperEX>();
        List<Contact> aggResult = 
            [select  ID, Family__Age__c               
            FROM Contact
              WHERE ID IN : setConCurrent2
              AND Birthdate != NULL
             //AND ID NOT IN: setConCurrentMaster
             // AND ID NOT IN : setConPrior
             ];
      
          for (Contact arList : aggResult) {
              
          
         queryTotals.add(new ExWrapperEX(String.valueOf(arList.ID), (Integer.valueOf(arList.Family__Age__c))));     
        }
        return queryTotals;
      
  }
    
       public List<ExWrapperEX> getAge3() {  
        list<ExWrapperEX> queryTotals = new List <ExWrapperEX>();
        List<Contact> aggResult = 
            [select  ID, Family__Age__c               
            FROM Contact
              WHERE ID IN : setConCurrent3
              AND Birthdate != NULL
             //AND ID NOT IN: setConCurrentMaster
             // AND ID NOT IN : setConPrior
             ];
      
          for (Contact arList : aggResult) {
              
          
         queryTotals.add(new ExWrapperEX(String.valueOf(arList.ID), (Integer.valueOf(arList.Family__Age__c))));     
        }
        return queryTotals;
      
  }
    
       public List<ExWrapperEX> getAge4() {  
        list<ExWrapperEX> queryTotals = new List <ExWrapperEX>();
        List<Contact> aggResult = 
            [select  ID, Family__Age__c               
            FROM Contact
              WHERE ID IN : setConCurrent4
              AND Birthdate != NULL
             //AND ID NOT IN: setConCurrentMaster
              //AND ID NOT IN : setConPrior
              ];
      
          for (Contact arList : aggResult) {
              
          
         queryTotals.add(new ExWrapperEX(String.valueOf(arList.ID), (Integer.valueOf(arList.Family__Age__c))));     
        }
        return queryTotals;
      
  }
    
       public List<ExWrapperEX> getAge5() {  
        list<ExWrapperEX> queryTotals = new List <ExWrapperEX>();
        List<Contact> aggResult = 
            [select  ID, Family__Age__c               
            FROM Contact
              WHERE ID IN : setConCurrent5
              AND Birthdate != NULL
             //AND ID NOT IN: setConCurrentMaster
             // AND ID NOT IN : setConPrior
             ];
      
          for (Contact arList : aggResult) {
              
          
         queryTotals.add(new ExWrapperEX(String.valueOf(arList.ID), (Integer.valueOf(arList.Family__Age__c))));     
        }
        return queryTotals;
      
  }
    
    
     public List<ExWrapperEX> getAge6() {  
        list<ExWrapperEX> queryTotals = new List <ExWrapperEX>();
        List<Contact> aggResult = 
            [select  ID, Family__Age__c               
            FROM Contact
              WHERE ID IN : setConCurrent6
              AND Birthdate != NULL
             //AND ID NOT IN: setConCurrentMaster
             // AND ID NOT IN : setConPrior
             ];
      
          for (Contact arList : aggResult) {
              
          
         queryTotals.add(new ExWrapperEX(String.valueOf(arList.ID), (Integer.valueOf(arList.Family__Age__c))));     
        }
        return queryTotals;
      
  }
    
    // YTD
  public List<ExWrapperEX> getAll() {  
        list<ExWrapperEX> queryTotals = new List <ExWrapperEX>();
        List<Contact> aggResult = 
            [select  ID, Family__Age__c               
             From contact
             WHERE ID IN: setConCurrentMaster
             ];
      
          for (Contact arList : aggResult) {
              
          
         queryTotals.add(new ExWrapperEX(String.valueOf(arList.ID), (Integer.valueOf(arList.Family__Age__c))));     
        }
        return queryTotals;
      
  }
    
    
    /*******************************************************************
* Wrapper 

*******************************************************************/
    
    
    public class ExWrapperEX {
        
        
        public Integer Num1 {get; set;}
        public String ag1 {get; set;}
  
       
        
        
        
        public ExWrapperEX(String str, Integer num){
            
            Num1 =num;
            ag1 =str;
    
          
            
            
        }         
        
    }
}