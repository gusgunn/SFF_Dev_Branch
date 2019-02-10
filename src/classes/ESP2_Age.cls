public class ESP2_Age {
    /*  1/4/18 
*  Novo November17
*/
    
    public Date dateFrom {get; set;} public Date dateTo {get; set;}
    public Date Q1Ends;
    public Date Q2Ends; 
    public Date Q3Ends; 
    public Date Q4Ends; 
    public Date PriorQuarterEnds;
    public Integer dateFromSelected;
    public Integer dateFromSecond;
    
    private Set<String> setConCurrentMaster = new Set<String>();
    private Set<String> setParentMasterPrior = new Set<String>();
    private Set<String> setConMasterPrior = new Set<String>();
    private Set<String> setConCurrent1 = new Set<String>(); 
    private Set<String> setConCurrent2 = new Set<String>();
    private Set<String> setConCurrent3 = new Set<String>();
    private Set<String> setConCurrent4 = new Set<String>();
    private Set<String> setConCurrent5 = new Set<String>();
    private Set<String> setConCurrent6 = new Set<String>();
    
    private String pmpVar ='PMP' + '%';
    
    
    public ESP2_Age(){
        setParentMasterPrior.clear();
        setConCurrentMaster.clear();
        setConMasterPrior.clear();
        setConCurrent1.clear();
        setConCurrent2.clear();
        setConCurrent3.clear();
        setConCurrent4.clear();
        setConCurrent5.clear();
        setConCurrent6.clear();
      
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
        setParentMasterPrior.clear();
        setConCurrentMaster.clear();
        setConMasterPrior.clear();
        setConCurrent1.clear();
        setConCurrent2.clear();
        setConCurrent3.clear();
        setConCurrent4.clear();
        setConCurrent5.clear();
        setConCurrent6.clear();
        GenerateKids(); 
        GenerateKids2(); 
        GenerateKids3(); 
        GenerateKids4(); 
        GenerateKids5(); 
        GenerateKids6();
        
    } 
    
    private void GenerateKids() {   
        
        // PRIOR: get All kids listed in interactions, YT Prior Q
        List<case> limitContactInteractions =[SELECT Child_Person_with_Disability_ID__c, ContactID
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
        for(case c: limitContactInteractions){
            setConMasterPrior.add(c.Child_Person_with_Disability_ID__c);
            setParentMasterPrior.add(c.ContactID);
            System.debug(setConMasterPrior.size() + 'setConMasterPrior size');
        }
        
        // PRIOR: get All kids  listed in Events Prior Q
        List<campaignMember> limitContactEvents =[SELECT contactID
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
        for(campaignMember cm: limitContactEvents){
            setConMasterPrior.add(cm.contactID);
            setConMasterPrior.add(cm.contactID);   
            
        }
        
        /**************************
* pull out unduplicated kids for CurrentQ  
* ***********************************************/
        
        // CurrentQ: get kids between 0 & 5 Months, listed in interactions, CurrentQ
        List<case> limitCurrentConInteractions =[SELECT Child_Person_with_Disability_ID__c
                                                 FROM case
                                                 WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                 And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <6
                                                 AND AgeMonthCaseTime__c != NULL
                                                 AND Call_Type__c != 'Left Message 1'
                                                 AND Call_Type__c != 'Left Message 2'
                                                 AND Call_Type__c != '# disconnected'
                                                 AND Call_Type__c != 'Sent UTC Letter'
                                                 AND Call_Type__c != 'No answering machine'
                                                 AND Child_Person_with_Disability_ID__c !='Neale'
                                                 AND Child_Person_with_Disability_ID__c !='test'
                                                 AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:pmpVar)  ];
        
        for(case c: limitCurrentConInteractions){
            setConCurrent1.add(c.Child_Person_with_Disability_ID__c);
            setConCurrentMaster.add(c.Child_Person_with_Disability_ID__c);
        }
        
        // get kids between 0 & 5 Months, listed in Events CurrentQ
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                     FROM campaignMember
                                                     WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                     And AgeMonthsAtCampaign__c>=0 AND AgeMonthsAtCampaign__c <6
                                                     AND AgeMonthsAtCampaign__c !=NULL
                                                     AND contact.name !='Neale'
                                                     AND contact.name !='test'
                                                     AND No_Show__c = false
                                                     AND Status = 'Child Attendee'
                                                     AND (NOT campaign.Name Like '%Childcare%')
                                                     AND (NOT campaign.Name Like '%Cancelled%')
                                                     AND (NOT campaign.Name Like '%No Show%')
                                                     AND (NOT campaign.Name Like '%Postponed%')
                                                     AND ContactID NOT In: setConCurrentMaster
                                                     AND (campaign.Type Like: 'Clinic' 
                                                          OR  campaign.Type Like: 'Conference'
                                                          OR campaign.Type Like: 'IRC Conference'  
                                                          OR campaign.Type Like: 'IRC Workshop' 
                                                          OR campaign.Type Like: 'Other Agency Training' 
                                                          OR campaign.Type Like:'Parent Panel' 
                                                          OR campaign.Type Like:'PMP Training' 
                                                          OR campaign.Type Like:'PPW' 
                                                          OR campaign.Type Like:'Workshop'  
                                                          Or  campaign.Type Like:'%Playgroup%' 
                                                          OR campaign.Type Like: 'Support Group')];
        
        for(campaignMember cm: limitCurContactEvents){
            setConCurrent1.add(cm.contactID);
            setConCurrentMaster.add(cm.contactID);
        }
       
    } 
    // 6-11  
     
    
    private void GenerateKids2() {   
        
        // CurrentQ: get kids between 6 & 11 Months, listed in interactions, CurrentQ
        List<case> limitCurrentConInteractions2 =[SELECT Child_Person_with_Disability_ID__c
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=6 AND AgeMonthCaseTime__c <12
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'Sent UTC Letter'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Child_Person_with_Disability_ID__c !='Neale'
                                                  AND Child_Person_with_Disability_ID__c !='test'
                                                  AND Child_Person_with_Disability_ID__c NOT In: setConCurrentMaster
                                                  AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:pmpVar)  ];
        
        for(case cur: limitCurrentConInteractions2){
            setConCurrent2.add(cur.Child_Person_with_Disability_ID__c);
            setConCurrentMaster.add(cur.Child_Person_with_Disability_ID__c);
        }
        
        // CurrentQ: get kids between 6 & 11 Months, listed in Events, CurrentQ
        List<campaignMember> limitCurContactEvents2 =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=6 AND AgeMonthsAtCampaign__c <12
                                                      AND AgeMonthsAtCampaign__c !=NULL
                                                      AND contact.name !='Neale'
                                                      AND contact.name !='test'
                                                      AND No_Show__c = false
                                                      AND Status = 'Child Attendee'
                                                      AND (NOT campaign.Name Like '%Childcare%')
                                                      AND (NOT campaign.Name Like '%Cancelled%')
                                                      AND (NOT campaign.Name Like '%No Show%')
                                                      AND (NOT campaign.Name Like '%Postponed%')AND ContactID NOT In: setConCurrentMaster
                                                      AND (campaign.Type Like: 'Clinic' OR  campaign.Type Like: 'Conference' OR campaign.Type Like: 'IRC Conference'  OR campaign.Type Like: 'IRC Workshop' OR campaign.Type Like: 'Other Agency Training' OR campaign.Type Like:'Parent Panel' OR campaign.Type Like:'PMP Training' OR campaign.Type Like:'PPW' OR campaign.Type Like:'Workshop'  Or  campaign.Type Like:'%Playgroup%' OR campaign.Type Like: 'Support Group')];
        
        for(campaignMember cm: limitCurContactEvents2){
            setConCurrent2.add(cm.contactID);
            setConCurrentMaster.add(cm.contactID);
        }
        
    }
    
    //   **************************************************************************************
    
    private void GenerateKids3(){
        
        // get kids between 12 & 17 Months, listed in interactions, CurrentQ
        List<case> limitCurrentConInteractions3 =[SELECT Child_Person_with_Disability_ID__c
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=12 AND AgeMonthCaseTime__c <18
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'Sent UTC Letter'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Child_Person_with_Disability_ID__c !='Neale'
                                                  AND Child_Person_with_Disability_ID__c !='test'
                                                  AND Child_Person_with_Disability_ID__c NOT In: setConCurrentMaster
                                                  AND (RecordTypeID = '012G0000000qhDK' OR  Call_Type__c LIKE:pmpVar) ];
        
        for(case c: limitCurrentConInteractions3){
            setConCurrent3.add(c.Child_Person_with_Disability_ID__c);
            setConCurrentMaster.add(c.Child_Person_with_Disability_ID__c);
        }
        
        // get kids between 12 & 17 Months, listed in Events, CurrentQ
        List<campaignMember> limitCurContactEvents3 =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=12 AND AgeMonthsAtCampaign__c <18
                                                      AND AgeMonthsAtCampaign__c !=NULL
                                                      AND contact.name !='Neale'
                                                      AND contact.name !='test'
                                                      AND No_Show__c = false
                                                      AND Status = 'Child Attendee'
                                                      AND (NOT campaign.Name Like '%Childcare%')
                                                      AND (NOT campaign.Name Like '%Cancelled%')
                                                      AND (NOT campaign.Name Like '%No Show%')
                                                      AND (NOT campaign.Name Like '%Postponed%')
                                                      AND ContactID NOT In: setConCurrentMaster
                                                      AND (campaign.Type Like: 'Clinic' OR  campaign.Type Like: 'Conference' OR campaign.Type Like: 'IRC Conference'  OR campaign.Type Like: 'IRC Workshop' OR campaign.Type Like: 'Other Agency Training' OR campaign.Type Like:'Parent Panel' OR campaign.Type Like:'PMP Training' OR campaign.Type Like:'PPW' OR campaign.Type Like:'Workshop'  Or  campaign.Type Like:'%Playgroup%' OR campaign.Type Like: 'Support Group')];
        
        for(campaignMember cm: limitCurContactEvents3){
            setConCurrent3.add(cm.contactID);
            setConCurrentMaster.add(cm.contactID);
        }
        
    }
    //  ********************************************************************
  
    
    private void GenerateKids4(){ 
        
        // get kids between 18 & 23 Months, listed in interactions, CurrentQ
        List<case> limitCurrentConInteractions4 =[SELECT Child_Person_with_Disability_ID__c
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=18 AND AgeMonthCaseTime__c <24 
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'Sent UTC Letter'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Child_Person_with_Disability_ID__c !='Neale'
                                                  AND Child_Person_with_Disability_ID__c !='test'
                                                  AND Child_Person_with_Disability_ID__c NOT In: setConCurrentMaster
                                                  AND (RecordTypeID = '012G0000000qhDK' OR  Call_Type__c LIKE:pmpVar) ];
        
        for(case c: limitCurrentConInteractions4){
            setConCurrent4.add(c.Child_Person_with_Disability_ID__c);
            setConCurrentMaster.add(c.Child_Person_with_Disability_ID__c);
            
        }
        
        // get kids between 18 & 23 Months, listed in Events, CurrentQ
        List<campaignMember> limitCurContactEvents4 =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=18 AND AgeMonthsAtCampaign__c <24
                                                      AND AgeMonthsAtCampaign__c !=NULL
                                                      AND contact.name !='Neale'
                                                      AND contact.name !='test'
                                                      AND No_Show__c = false
                                                      AND Status = 'Child Attendee'
                                                      AND (NOT campaign.Name Like '%Childcare%')
                                                      AND (NOT campaign.Name Like '%Cancelled%')
                                                      AND (NOT campaign.Name Like '%No Show%')
                                                      AND (NOT campaign.Name Like '%Postponed%')
                                                      AND ContactID NOT In: setConCurrentMaster
                                                      AND (campaign.Type Like: 'Clinic' OR  campaign.Type Like: 'Conference' OR campaign.Type Like: 'IRC Conference'  OR campaign.Type Like: 'IRC Workshop' OR campaign.Type Like: 'Other Agency Training' OR campaign.Type Like:'Parent Panel' OR campaign.Type Like:'PMP Training' OR campaign.Type Like:'PPW' OR campaign.Type Like:'Workshop'  Or  campaign.Type Like:'%Playgroup%' OR campaign.Type Like: 'Support Group')];
        
        for(campaignMember cm: limitCurContactEvents4){
            setConCurrent4.add(cm.contactID);
            setConCurrentMaster.add(cm.contactID);
        }
        
    }
    
    //  *************************************
    private void GenerateKids5(){
        
        // get kids between 24 & 29 Months, listed in interactions, CurrentQ
        List<case> limitCurrentConInteractions5 =[SELECT Child_Person_with_Disability_ID__c
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=24 AND AgeMonthCaseTime__c <30 
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'Sent UTC Letter'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Child_Person_with_Disability_ID__c !='Neale'
                                                  AND Child_Person_with_Disability_ID__c !='test'
                                                  AND Child_Person_with_Disability_ID__c NOT In: setConCurrentMaster
                                                  AND (RecordTypeID = '012G0000000qhDK' OR  Call_Type__c LIKE:pmpVar) ];
        
        for(case c: limitCurrentConInteractions5){
            setConCurrent5.add(c.Child_Person_with_Disability_ID__c);
            setConCurrentMaster.add(c.Child_Person_with_Disability_ID__c);
        }
        
        // get kids between 24 & 29 Months, listed in Events, report month requested
        List<campaignMember> limitCurContactEvents5 =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=24 AND AgeMonthsAtCampaign__c <30
                                                      AND AgeMonthsAtCampaign__c !=NULL
                                                      AND contact.name !='Neale'
                                                      AND contact.name !='test'
                                                      AND No_Show__c = false
                                                      AND Status = 'Child Attendee'
                                                      AND (NOT campaign.Name Like '%Childcare%')
                                                      AND (NOT campaign.Name Like '%Cancelled%')
                                                      AND (NOT campaign.Name Like '%No Show%')
                                                      AND (NOT campaign.Name Like '%Postponed%')
                                                      AND ContactID NOT In: setConCurrentMaster
                                                      AND (campaign.Type Like: 'Clinic' OR  campaign.Type Like: 'Conference' OR campaign.Type Like: 'IRC Conference'  OR campaign.Type Like: 'IRC Workshop' OR campaign.Type Like: 'Other Agency Training' OR campaign.Type Like:'Parent Panel' OR campaign.Type Like:'PMP Training' OR campaign.Type Like:'PPW' OR campaign.Type Like:'Workshop'  Or  campaign.Type Like:'%Playgroup%' OR campaign.Type Like: 'Support Group')];
        
        for(campaignMember cm: limitCurContactEvents5){
            setConCurrent5.add(cm.contactID);
            setConCurrentMaster.add(cm.contactID);
        }
        
    }
    //   ******************************************************
    //   30 - 35 Prior
    
    private void GenerateKids6() {
        
        
        // get kids between 30 & 35 Months, listed in interactions, CurrentQ
        List<case> limitCurrentConInteractions6 =[SELECT Child_Person_with_Disability_ID__c
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=30 AND AgeMonthCaseTime__c <36
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'Sent UTC Letter'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Child_Person_with_Disability_ID__c !='Neale'
                                                  AND Child_Person_with_Disability_ID__c !='test'
                                                  AND Child_Person_with_Disability_ID__c NOT In: setConCurrentMaster
                                                  AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:pmpVar)  ];
        
        for(case c: limitCurrentConInteractions6){
            setConCurrent6.add(c.Child_Person_with_Disability_ID__c);
            setConCurrentMaster.add(c.Child_Person_with_Disability_ID__c);
        }
        
        // get kids between 30 & 35 Months, listed in Events, report month requested
        List<campaignMember> limitCurContactEvents6 =[SELECT contactID, AgeMonthsAtCampaign__c
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                      And AgeMonthsAtCampaign__c>=30 AND AgeMonthsAtCampaign__c <36
                                                      AND AgeMonthsAtCampaign__c != NULL
                                                      AND contact.name !='Neale'
                                                      AND contact.name !='test'
                                                      AND No_Show__c = false
                                                      AND Status = 'Child Attendee'
                                                      AND (NOT campaign.Name Like '%Childcare%')
                                                      AND (NOT campaign.Name Like '%Cancelled%')
                                                      AND (NOT campaign.Name Like '%No Show%')
                                                      AND (NOT campaign.Name Like '%Postponed%')
                                                      AND ContactID NOT In: setConCurrentMaster
                                                      AND (campaign.Type Like: 'Clinic' OR  campaign.Type Like: 'Conference' OR campaign.Type Like: 'IRC Conference'  OR campaign.Type Like: 'IRC Workshop' OR campaign.Type Like: 'Other Agency Training' OR campaign.Type Like:'Parent Panel' OR campaign.Type Like:'PMP Training' OR campaign.Type Like:'PPW' OR campaign.Type Like:'Workshop'  Or  campaign.Type Like:'%Playgroup%' OR campaign.Type Like: 'Support Group')];
        
        for(campaignMember cm: limitCurContactEvents6){
            setConCurrent6.add(cm.contactID);
            setConCurrentMaster.add(cm.contactID);
        }
        
    }
    
    
    // Generate output begins
    //  ***********************************  
    public List<ExWrapperEX> getGenerateAge1(){  
        list<ExWrapperEX> queryTotals = new List <ExWrapperEX>();
        List<AggregateResult> aggResult =[SELECT RecordTypeID  ln, Count(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent1
                                          AND Birthdate != NULL
                                          AND ID NOT IN : setConMasterPrior
                                          Group By RecordTypeID];
        
        for(AggregateResult a: aggResult){
            String.valueOf(a.get('ln'));
            queryTotals.add(new ExWrapperEX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));    
            
        }
        
        return queryTotals; 
        
    }
    //  ************************************
    
    public List<ExWrapperEX> getGenerateAge2(){  
        list<ExWrapperEX> queryTotals = new List <ExWrapperEX>();
        List<AggregateResult> aggResult =[SELECT RecordTypeID  ln, Count(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent2
                                          AND Birthdate != NULL
                                          AND ID NOT IN : setConMasterPrior
                                          Group By RecordTypeID];
        
        for(AggregateResult a: aggResult){
            String.valueOf(a.get('ln'));
            queryTotals.add(new ExWrapperEX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));    
        }
        return queryTotals; 
    }
    
    // ***********************************
    
    public List<ExWrapperEX> getGenerateAge3(){  
        list<ExWrapperEX> queryTotals = new List <ExWrapperEX>();
        List<AggregateResult> aggResult =[SELECT RecordTypeID  ln, Count(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent3
                                          AND Birthdate != NULL
                                          AND ID NOT IN : setConMasterPrior
                                          Group By RecordTypeID];
        
        for(AggregateResult a: aggResult){
            String.valueOf(a.get('ln'));
            queryTotals.add(new ExWrapperEX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));    
        }
        return queryTotals; 
    }
    
    //  ***********************************************************
    //  return ageR4      
    
    public List<ExWrapperEX> getGenerateAge4(){  
        list<ExWrapperEX> queryTotals = new List <ExWrapperEX>();
        List<AggregateResult> aggResult =[SELECT RecordTypeID  ln, Count(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent4
                                          AND Birthdate != NULL
                                          AND ID NOT IN : setConMasterPrior
                                          Group By RecordTypeID ];
        
        for(AggregateResult a: aggResult){
            String.valueOf(a.get('ln'));
            queryTotals.add(new ExWrapperEX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));    
        }
        return queryTotals; 
    }
    
    // ****************************************
    // retern Age 5
    public List<ExWrapperEX> getGenerateAge5(){  
        list<ExWrapperEX> queryTotals = new List <ExWrapperEX>();
        List<AggregateResult> aggResult =[SELECT RecordTypeID  ln, Count(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent5
                                          AND Birthdate != NULL
                                          AND ID NOT IN : setConMasterPrior
                                          Group By RecordTypeID ];
        
        for(AggregateResult a: aggResult){
            String.valueOf(a.get('ln'));
            queryTotals.add(new ExWrapperEX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));    
        }
        return queryTotals; 
    }
    
    // ****************************************
    // return ageR6
    
    public List<ExWrapperEX> getGenerateAge6(){  
        list<ExWrapperEX> queryTotals = new List <ExWrapperEX>();
        List<AggregateResult> aggResult =[SELECT RecordTypeID  ln, Count(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent6
                                          AND Birthdate != NULL
                                          AND ID NOT IN : setConMasterPrior
                                          Group By RecordTypeID];
        
        for(AggregateResult a: aggResult){
            String.valueOf(a.get('ln'));
            queryTotals.add(new ExWrapperEX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));    
        }
        return queryTotals; 
    }
    
    // Current 
    public List<ExWrapperEX> getGenerateGenC() { 
        list<ExWrapperEX> queryTotals = new List <ExWrapperEX>();
        List<AggregateResult> aggRessult = 
            [select  family__Gender__c zpM, Count (id) ContactCNTzpM                    
             From contact
             WHERE ID IN:setConCurrentMaster
             AND ID NOT IN: setConMasterPrior
             group by Rollup (family__Gender__c)];
        
for (AggregateResult arRList : aggRessult) { 
            String.valueOf(arRList.get('zpM'));
            queryTotals.add(new ExWrapperEX(String.valueOf(arRList.get('zpM')), (Integer.valueOf(arRList.get('ContactCNTzpM')))));    
        }
        return queryTotals;
    }   
    
    //Gender Prior
    public List<ExWrapperEX> getGenerateGenP() { 
        list<ExWrapperEX> queryTotals = new List <ExWrapperEX>();
        List<AggregateResult> aggResult = 
            [select  family__Gender__c zpF, Count (id) ContactCNTzpF                    
             From contact
             WHERE ID IN :setConMasterPrior
             group by Rollup (family__Gender__c)];
        
        
        for (AggregateResult arRList : aggResult) { 
            String tname='';
            if(String.valueOf(arRList.get('zpF'))==NULL){
                tname='Total';
            }else{
                String.valueOf(arRList.get('zpF'));
            }       
            queryTotals.add(new ExWrapperEX(String.valueOf(arRList.get('zpF')), (Integer.valueOf(arRList.get('ContactCNTzpF')))));    
        }
        return queryTotals;
    }
    // Gender CurrentQ
    public List<ExWrapperEX> getGenerateGenYTD() { 
        list<ExWrapperEX> queryTotals = new List <ExWrapperEX>();
        List<AggregateResult> aggRessult = 
            [select  family__Gender__c zpF, Count(id) ContactCNTzpF                    
             From contact
             WHERE ID IN : setConCurrentMaster
             OR ID IN: setConMasterPrior
             group by Rollup (family__Gender__c)];
        
        for (AggregateResult arRList : aggRessult) { 
            String tname='';
            if(String.valueOf(arRList.get('zpF'))==NULL){
                tname='Total';
            }else{
                String.valueOf(arRList.get('zpF'));
            }       
            queryTotals.add(new ExWrapperEX(String.valueOf(arRList.get('zpF')), (Integer.valueOf(arRList.get('ContactCNTzpF')))));    
        }
        return queryTotals;
    }
    /**********************  End Gender */
    
    
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