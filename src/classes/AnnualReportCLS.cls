public class AnnualReportCLS{
    
    
    // //April_17 6/2/17
    // 
    
    // *******************************************************
    
    
    // *******************************************************
    
    
    // Add Date From to VF
    public Date dateFrom {get; set;}
    //public Date FYB {get; set;}
    
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
    // private Set<String> setConMasterProf = new Set<String>();
    private Set<ID> setConMasterChild = new Set<ID>();
   
    
    private Set<String> setConIntCG = new Set<String>();
    private Set<String> setConIntHH = new Set<String>();
    private Set<String> setConIntChild = new Set<String>();
    private Set<String> setConIntOboHH = new Set<String>();
    // private Set<String> setConIntPMP = new Set<String>();
    // private Set<String> setConIntProf = new Set<String>();
    
    private Set<String> setConCampCG = new Set<String>();
    private Set<String> setConCampHH = new Set<String>();
    private Set<String> setConCampChild = new Set<String>();
    private Set<String> setConCampChildEv = new Set<String>();
    //private Set<String> setConCampProf = new Set<String>();
    
    private Map<ID,ID> espKidHH  =  new Map<ID,ID>();
    Private String pmpVar ='PMP' + '%';
    
    
    
    public AnnualReportCLS(){
        
        
        
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
        System.Debug('datefrom & dateTo = ' + dateFrom + ' ' + dateTo);
        // MUST SELECT Real Q1 to work
        FYBSelected = (Integer.valueof(DateFrom.year()));
        FYBSecond = (Integer.valueof(DateFrom.year() + 1));
        Q1Ends = date.newInstance(FYBSelected, 9, 30 );
        Q2Ends = date.newInstance(FYBSelected, 12, 31 );
        Q3Ends = date.newInstance(FYBSecond, 3, 31 );
        Q4Ends = date.newInstance(FYBSecond, 6, 30 );
        System.debug('Q1Ends= ' +  Q1Ends + ' Q2Ends= ' + Q2Ends + ' Q3Ends= ' + Q3Ends + ' Q4Ends= ' + Q4Ends );
     /*   If (dateTo <= Q1Ends){
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
        } */
        InitializeBoard();
        TagContacts();
    }
    
    private void InitializeBoard() { 
        setConMasterCG.clear();
        setConMasterHH.clear();
        // setConMasterProf.clear();
        setConMasterChild.clear();
        setConIntCG.clear();
        setConIntHH.clear();
        setConIntChild.clear();
        setConIntOboHH.clear();
        // setConIntPMP.clear();
        //  setConIntProf.clear();
        
        setConCampCG.clear();
        setConCampHH.clear();
        setConCampChild.clear();
        // setConCampProf.clear();
        
        
    }
    
    private void TagContacts() {   
        
        //Get All Households And
        // MAke workflow to tag, Or formula or custom metadatatype
        // Run rollups by recordtype to get kids and adults and family members
        // Seperate Master and Object specific sets for CareGivers, Households, Professionals and Children
        
        List<campaignMember> limitCurContactEvents =[SELECT contactID,  Status
                                                     FROM campaignMember
                                                     WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                     
                                                     AND contact.name !='Neale'
                                                     AND contact.name !='test'
                                                     AND No_Show__c = false
                                                     AND  Status = 'Child Attendee'
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
                                                           OR campaign.Type = 'Workshop'
                                                          OR campaign.Type LIKE '%Playgroup%')
                                                     //AND (NOT campaign.Name Like '%Childcare%')
                                                     AND (NOT campaign.Name Like '%Cancelled%')
                                                     AND (NOT campaign.Name Like '%No Show%')
                                                     AND (NOT campaign.Name Like '%Postponed%')
                                                    ];
        
        for(campaignMember cm: limitCurContactEvents){
            
           setConCampChildEv.add(cm.contactID);
            setConMasterChild.add(cm.contactID);
            
            //setConMasterHH.add(cm.contact.npo02__Household__c);
        } 
        
            List<campaignMember> limitCurContactEduEvents =[SELECT contactID,  Status
                                                     FROM campaignMember
                                                     WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                     
                                                     AND contact.name !='Neale'
                                                     AND contact.name !='test'
                                                     AND No_Show__c = false
                                                     AND  Status = 'Child Attendee'
                                                     AND (campaign.Type = 'Clinic' 
                                                          OR campaign.Type = 'Conference'
                                                         // OR campaign.Type = 'Family Event'
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
            
            setConCampChild.add(cm.contactID);
            
            
            //setConMasterHH.add(cm.contact.npo02__Household__c);
        }
        
        //System.debug('setConCampChild Size -  =  ' + setConCampChild.size());
        //System.debug('setConMasterChild Camps Size =  ' + setConMasterChild.size());
        
        
        //Family Interactions
        List<case> limitContactInteractions =[SELECT ID, contact.Lastname, contact.recordTypeID, Family__Household__c, 
                                              contact.npo02__Household__c, Family__Child__c, Family__Child__r.LastName
                                              FROM case
                                              WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                              
                                              AND Call_Type__c != 'Left Message 1'
                                              AND Call_Type__c != 'Left Message 2'
                                              AND Call_Type__c != '# disconnected'
                                              AND Call_Type__c != 'No answering machine'
                                              AND Call_Type__c != 'Sent UTC Letter'     
                                              AND Family__Child__r.LastName !='Neale'
                                              AND Family__Child__r.LastName !='test'
                                              AND contact.Lastname !='Neale'
                                              AND contact.Lastname !='test'
                                              AND (RecordTypeID = '012G0000000qhDK' OR  Call_Type__c LIKE: pmpVar ) 
                                             ];
        for(case c: limitContactInteractions){
            //setConMasterCG.add(c.ID);
            // setConMasterHH.add(c.contact.npo02__Household__c);
            // setConIntCG.add(c.ID);
            //  setConIntHH.add(c.contact.npo02__Household__c);
            setConIntChild.add(c.Family__Child__c);
            // System.debug('setConIntChild  - R.ID =  ' + c.Family__Child__R.ID);
            // System.debug('Family__Child__c =  ' + c.Family__Child__c);
            setConMasterChild.add(c.Family__Child__c);
            
            
        }
       /* System.debug('setConIntChild Size - R.ID =  ' + setConIntChild.size());
        System.debug('setConMasterChild Size =  ' + setConMasterChild.size());
        System.debug('setConIntChild  - R.ID =  ' + setConIntChild);
        System.debug('setConMasterChild =  ' + setConMasterChild);*/
    } 
    
    /*******************************************************************
* Generate output begins
*******************************************************************/
    
    // Total Kids By Eth
    public List<arWrapperX> getGenerateTotalKids(){  
        list<arWrapperX> kTotals = new List <arWrapperX>();
        List<AggregateResult> Kids = [select  family__Ethnicity__c aa, Count_Distinct (id) bb                    
                                      From contact
                                      WHERE ID IN: setConMasterChild
                                      group by Rollup (family__Ethnicity__c) ];
        
        String NewName ='';
        for(AggregateResult arList: Kids){
            If(String.valueOf(arList.get('aa'))==NULL){
                NewName ='Total'; 
            } ELSE{
                NewName = (String.valueOf(arList.get('aa')));  
                
            }
            
            kTotals.add(new arWrapperX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));    
        }
        System.debug('# of rows after Kids query runs' + kTotals.size());
        System.debug('*****Kids + Total after Kids query runs' + kTotals);
        return kTotals; 
    }
    
    
    
    // Gender
    public List<arWrapperX> getGenerateGen() { 
        list<arWrapperX> genQueryTotals = new List <arWrapperX>();
        List<AggregateResult> genAggregateResult = 
            [select  family__Gender__c aa, Count_Distinct (id) bb                    
             From contact
             WHERE ID IN:setConMasterChild
             group by Rollup (family__Gender__c)];
        
        String NewName ='';
        for (AggregateResult arList : genAggregateResult) { 
            
            If(String.valueOf(arList.get('aa'))==NULL){
                NewName ='Total'; 
            } ELSE{
                NewName = (String.valueOf(arList.get('aa')));  
                
            }
            
            genQueryTotals.add(new arWrapperX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));    
        }
        return genQueryTotals;
    }   
    
     public List<arWrapperX> getGenerateGenInt() { 
        list<arWrapperX> genQueryTotals = new List <arWrapperX>();
        List<AggregateResult> genAggregateResult = 
            [select  family__Gender__c aa, Count_Distinct (id) bb                    
             From contact
             WHERE ID IN:setConIntChild
             group by Rollup (family__Gender__c)];
        
        String NewName ='';
        for (AggregateResult arList : genAggregateResult) { 
            
            If(String.valueOf(arList.get('aa'))==NULL){
                NewName ='Total'; 
            } ELSE{
                NewName = (String.valueOf(arList.get('aa')));  
                
            }
            
            genQueryTotals.add(new arWrapperX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));    
        }
        return genQueryTotals;
    }   
    
     public List<arWrapperX> getGenerateGenCamp() { 
        list<arWrapperX> genQueryTotals = new List <arWrapperX>();
        List<AggregateResult> genAggregateResult = 
            [select  family__Gender__c aa, Count_Distinct (id) bb                    
             From contact
             WHERE ID IN:setConcampChild
             group by Rollup (family__Gender__c)];
        
        String NewName ='';
        for (AggregateResult arList : genAggregateResult) { 
            
            If(String.valueOf(arList.get('aa'))==NULL){
                NewName ='Total'; 
            } ELSE{
                NewName = (String.valueOf(arList.get('aa')));  
                
            }
            
            genQueryTotals.add(new arWrapperX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));    
        }
        return genQueryTotals;
    }   
    
    
        // Disability- Fed
    public List<arWrapperX> getGenerateFedDis() { 
        list<arWrapperX> genQueryTotals = new List <arWrapperX>();
        List<AggregateResult> genAggregateResult = 
            [select  Family__Primary_Diagnostic_Category__c aa, Count_Distinct (id) bb                    
             From contact
             WHERE ID IN:setConMasterChild
             group by Rollup (Family__Primary_Diagnostic_Category__c)];
        
        String NewName ='';
        for (AggregateResult arList : genAggregateResult) { 
            
            If(String.valueOf(arList.get('aa'))==NULL){
                NewName ='Total'; 
            } ELSE{
                NewName = (String.valueOf(arList.get('aa')));  
                
            }
            
            genQueryTotals.add(new arWrapperX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));    
        }
        return genQueryTotals;
    }   

     public List<arWrapperX> getGenerateFedDisCamp() { 
        list<arWrapperX> genQueryTotals = new List <arWrapperX>();
        List<AggregateResult> genAggregateResult = 
            [select  Family__Primary_Diagnostic_Category__c aa, Count_Distinct (id) bb                    
             From contact
             WHERE ID IN:setConcampChild
             group by Rollup (Family__Primary_Diagnostic_Category__c)];
        
        String NewName ='';
        for (AggregateResult arList : genAggregateResult) { 
            
            If(String.valueOf(arList.get('aa'))==NULL){
                NewName ='Total'; 
            } ELSE{
                NewName = (String.valueOf(arList.get('aa')));  
                
            }
            
            genQueryTotals.add(new arWrapperX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));    
        }
        return genQueryTotals;
    }   
    
     public List<arWrapperX> getGenerateFedDisInt() { 
        list<arWrapperX> genQueryTotals = new List <arWrapperX>();
        List<AggregateResult> genAggregateResult = 
            [select  Family__Primary_Diagnostic_Category__c aa, Count_Distinct (id) bb                    
             From contact
             WHERE ID IN:setConIntChild
             group by Rollup (Family__Primary_Diagnostic_Category__c)];
        
        String NewName ='';
        for (AggregateResult arList : genAggregateResult) { 
            
            If(String.valueOf(arList.get('aa'))==NULL){
                NewName ='Total'; 
            } ELSE{
                NewName = (String.valueOf(arList.get('aa')));  
                
            }
            
            genQueryTotals.add(new arWrapperX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));    
        }
        return genQueryTotals;
    }   
    
    
        
    public List<arWrapperX> getGenerateRace(){
        System.debug('setConMasterChild' +  setConMasterChild.size());
        list<arWrapperX> RaceQueryTotals = new List <arWrapperX>();
        List<Contact> RaceList = 
            [select  Family__Race__c , ID              
             From contact
             WHERE ID IN: setConMasterChild 
            ];
        System.debug('Line 275 raceList' +  setConMasterChild.size());
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
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap0), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap1), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap2), (Integer.valueOf(Hold)))); 
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap3), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap4), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap5), (Integer.valueOf(Hold)))); 
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap6), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap7), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap8), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap9), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new arWrapperX(String.valueOf(Total), (Integer.valueOf(count))));
        
        return RaceQueryTotals;
        
    }
    
    public List<arWrapperX> getGenerateRaceInt(){
        System.debug('setConIntChild' +  setConIntChild.size());
        list<arWrapperX> RaceQueryTotals = new List <arWrapperX>();
        List<Contact> RaceList = 
            [select  Family__Race__c , ID              
             From contact
             WHERE ID IN: setConIntChild 
            ];
        System.debug('Line 275 raceList' +  setConMasterChild.size());
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
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap0), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap1), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap2), (Integer.valueOf(Hold)))); 
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap3), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap4), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap5), (Integer.valueOf(Hold)))); 
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap6), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap7), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap8), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap9), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new arWrapperX(String.valueOf(Total), (Integer.valueOf(count))));
        
        return RaceQueryTotals;
        
    }
    
     public List<arWrapperX> getGenerateRaceCamp(){
        System.debug('setConCampChild' +  setConCampChild.size());
        list<arWrapperX> RaceQueryTotals = new List <arWrapperX>();
        List<Contact> RaceList = 
            [select  Family__Race__c , ID              
             From contact
             WHERE ID IN: setConCampChild 
            ];
        System.debug('Line 275 raceList' +  setConMasterChild.size());
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
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap0), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap1), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap2), (Integer.valueOf(Hold)))); 
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap3), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap4), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap5), (Integer.valueOf(Hold)))); 
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap6), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap7), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap8), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap9), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new arWrapperX(String.valueOf(Total), (Integer.valueOf(count))));
        
        return RaceQueryTotals;
        
    }
    
    /*******************************************************************
* Wrapper 
*******************************************************************/
    
    
    public class arWrapperX {
        
        public String a1 {get; set;}
        public Integer C1 {get; set;}
        public String a2 {get; set;}
        public Integer C2 {get; set;}
        public String a3{ get; set;}
        public Integer C3 {get; set;}
        public String a4 {get; set;}
        public Integer C4 {get; set;}
        public String a5 {get; set;}
        public Integer C5 {get; set;}
        public String a6 {get; set;}
        
        public arWrapperX(String str, Integer num){
            a1 =str;
            C1=num;
            a2 =str;
            C2=num;
            a3 =str;
            C3=num;
            a4 =str;
            C4=num;
            a5 =str;
            C5=num;
            a6 =str;
            
        }
    }
}