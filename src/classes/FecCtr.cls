public class FecCtr{
    /*******************************************************
* 9-18-17 SFCD Casetrack 
* Interactions Only 
* Kids aged 3 through 21
* For FEC- Joe Goyos
*  @ggunn
*******************************************************/
    
    // Date From to VF
    public Date dateFrom {get; set;}
    
    // Date To
    public Date dateTo {get; set;}
    
    /*
//public Date priorMonthEnd;
public Date Q1Ends;
public Date Q2Ends; 
public Date Q3Ends; 
public Date Q4Ends; 
public Date PriorQuarterEnds;*/
    
    public Integer FYBSelected;
    Public Integer FYBSecond;
    
    // SetConMaster collects all the contacts for current Quarter
    
    private Set<String> setConMasterHH = new Set<String>();
    private Set<String> setConMasterProf = new Set<String>();
    private Set<ID> setConMasterChild = new Set<ID>();
    private Set<String> setConMasterCG = new Set<String>();
    
  
    private String pmpVar ='PMP' + '%';
    private static RecordType rTProfInteraction = [SELECT Id, Name FROM recordType WHERE Name = 'Professional Case' AND sObjectType = 'Case' LIMIT 1];
    private static RecordType rTFamInteraction = [SELECT Id, Name FROM recordType WHERE Name = 'Family Case' AND sObjectType = 'Case' LIMIT 1];
    
    
    public FecCtr(){
        //setConMaster.clear();
        Date DefaultDateTo = date.newinstance(2017, 6, 30);
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
    
    
    
    // generate the dashboard
    private void generateBoard() {
        System.Debug('datefrom & dateTo = ' + dateFrom + ' ' + dateTo);
        // MUST SELECT Real Q1 to work
        FYBSelected = (Integer.valueof(DateFrom.year()));
        FYBSecond = (Integer.valueof(DateFrom.year() + 1));
     
        InitializeBoard();
        TagContacts();
    }
    
    private void InitializeBoard() { 
        setConMasterCG.clear();
        setConMasterChild.clear();
        setConMasterHH.clear();
        setConMasterProf.clear();
   
        
    }
    
    private void TagContacts() {   
        // find interactions that included 3- 22 yr olds prof & fam)
        List<case> limitContactInteractions =[SELECT ID, ContactID, contact.Lastname, contact.recordTypeID, Family__Household__c, 
                                              contact.npo02__Household__c, Family__Child__c, Family__Child__r.LastName, recordTypeID
                                              FROM case
                                              WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                              AND AgeMonthCaseTime__c > 35
                                              AND AgeMonthCaseTime__c < 264
                                              AND Call_Type__c != 'Left Message 1'
                                              AND Call_Type__c != 'Left Message 2'
                                              AND Call_Type__c != '# disconnected'
                                              AND Call_Type__c != 'No answering machine'
                                              AND Call_Type__c != 'Sent UTC Letter'     
                                              AND Family__Child__r.LastName !='Neale'
                                              AND Family__Child__r.LastName !='test'
                                              AND contact.Lastname !='Neale'
                                              AND contact.Lastname !='test'
                                              AND Created_by_CM__c = false
                                             ];
        for(case c: limitContactInteractions){
            //If family Interaction, get caregiver, HH, Child
            if (c.RecordTypeID == rTFamInteraction.Id ){
                setConMasterChild.add(c.Family__Child__c); 
                setConMasterHH.add(c.Family__Household__c);
                setConMasterCG.add(c.ContactID);
            }Else{
                // Else its a pmp so dont get that contact
                setConMasterChild.add(c.Family__Child__c); 
                setConMasterHH.add(c.Family__Household__c);
            }
        }
        
        
        
        //Seperate out non PMP prof interactions
        List<case> limitProfContactInteractions =[SELECT ID, ContactID, contact.Lastname, contact.recordTypeID, Family__Household__c, Call_Type__c,
                                                  contact.npo02__Household__c, Family__Child__c, Family__Child__r.LastName, recordTypeID
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  AND AgeMonthCaseTime__c > 35
                                                  AND AgeMonthCaseTime__c < 264
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Call_Type__c != 'Sent UTC Letter'     
                                                  AND Family__Child__r.LastName !='Neale'
                                                  AND Family__Child__r.LastName !='test'
                                                  AND contact.Lastname !='Neale'
                                                  AND contact.Lastname !='test'
                                                  AND Created_by_CM__c = false
                                                  AND RecordTypeID =: rTProfInteraction.Id
                                                  AND ( Not Call_Type__c LIKE 'PMP%' )];
        
        // Count these- as kid or household is listed on Prof int- not cg
        // Can do so for family interactions as it's more common for FRS to leave off the child from the record, so we miss many interactions that way.
        
        for(case c: limitProfContactInteractions){
            setConMasterProf.add(c.ContactID);
            
            
            
        }
    }
    
    // Find all other family household interactions of those families for count(in case child not entered in some)
    
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
        Integer Blanks = 0;
        for(AggregateResult arList: Kids){
            If (String.valueOf(arList.get('aa')) != NULL){
                        NewName =   String.valueOf(arList.get('aa'));
                
            } Else IF (String.valueOf(arList.get('aa'))== NULL && Blanks == 0){
                NewName ='Unknown-Blank '; 
                Blanks+=1;
                
                }Else{
                                NewName ='Total' ;                   
                }
            
            kTotals.add(new arWrapperX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));    
        }
        //System.debug('# of rows after Kids query runs' + kTotals.size());
        //System.debug('*****Kids + Total after Kids query runs' + kTotals);
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
        Integer Blanks =0;
        for (AggregateResult arList : genAggregateResult) { 
             If (String.valueOf(arList.get('aa')) != NULL){
                        NewName =   String.valueOf(arList.get('aa'));
                
            } Else IF (String.valueOf(arList.get('aa'))== NULL && Blanks == 0){
                NewName ='Unknown-Blank '; 
                Blanks+=1;
                
                }Else{
                                NewName ='Total' ;                   
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
         Integer Blanks = 0;
        for (AggregateResult arList : genAggregateResult) { 
            
           If (String.valueOf(arList.get('aa')) != NULL){
                        NewName =   String.valueOf(arList.get('aa'));
                
            } Else IF (String.valueOf(arList.get('aa'))== NULL && Blanks == 0){
                NewName ='Unknown-Blank '; 
                Blanks+=1;
                
                }Else{
                                NewName ='Total' ;                   
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
                    } Else  If (str.contains('Unknown')) {
                        NewName ='Unknown';
                        Unknown = Unknown + 1;
                        RaceMap8.put(NewName, Unknown);
                        // Break;
                        // 
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
    
     public List<arWrapperX> getGenerateKidLanguage() {
        
        // get count Language at the contact level
        list<arWrapperX> LanguagePQueryTotals = new List <arWrapperX>();
        List<AggregateResult> LanguagePAggregateResult = 
            [select  Family__Primary_Language__c aa, Count_Distinct (ID) bb                  
             From contact
             WHERE ID IN: setConMasterChild 
             group by Rollup (Family__Primary_Language__c) ];
        
        
        String NewName ='';
          Integer Blanks = 0;
        for (AggregateResult arList : LanguagePAggregateResult) { 
            If (String.valueOf(arList.get('aa')) != NULL){
                        NewName =   String.valueOf(arList.get('aa'));
                
            } Else IF (String.valueOf(arList.get('aa'))== NULL && Blanks == 0){
                NewName ='Unknown-Blank '; 
                Blanks+=1;
                
                }Else{
                                NewName ='Total' ;                   
                }
            LanguagePQueryTotals.add(new arWrapperX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));     
        }
        return LanguagePQueryTotals;
    }   
    // Total Kids By Eth
    public List<arWrapperX> getGenerateParentEth(){  
        list<arWrapperX> kTotals = new List <arWrapperX>();
        List<AggregateResult> Kids = [select  family__Ethnicity__c aa, Count_Distinct (id) bb                    
                                      From contact
                                      WHERE ID IN: setConMasterCG
                                      group by Rollup (family__Ethnicity__c) ];
        
        String NewName ='';
        Integer Blanks = 0;
        for(AggregateResult arList: Kids){
            If (String.valueOf(arList.get('aa')) != NULL){
                        NewName =   String.valueOf(arList.get('aa'));
                
            } Else IF (String.valueOf(arList.get('aa'))== NULL && Blanks == 0){
                NewName ='Unknown-Blank '; 
                Blanks+=1;
                
                }Else{
                                NewName ='Total' ;                   
                }
            
            kTotals.add(new arWrapperX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));    
        }
      
        return kTotals; 
    }
     
        
    public List<arWrapperX> getGenerateParentRace(){
       
        list<arWrapperX> RaceQueryTotals = new List <arWrapperX>();
        List<Contact> RaceList = 
            [select  Family__Race__c , ID              
             From contact
             WHERE ID IN: setConMasterCG 
             
            ];
        
        //String[] regions = bsc.Region__c.split(';');
        List <String> allRace;
        String NewName ='';
        Map<String,Integer> RaceMap = new Map<String,Integer>();  // Native Am
        Map<String,Integer> RaceMap0 = new Map<String,Integer>(); // Native Al
        Map<String,Integer> RaceMap1 = new Map<String,Integer>(); // AF Am/Black
        Map<String,Integer> RaceMap2 = new Map<String,Integer>(); // Asian
        Map<String,Integer> RaceMap10 = new Map<String,Integer>(); // Filipino
        Map<String,Integer> RaceMap3 = new Map<String,Integer>(); // PI
        Map<String,Integer> RaceMap4 = new Map<String,Integer>(); // MultiEth
        Map<String,Integer> RaceMap5 = new Map<String,Integer>(); // Middle Eastern
        Map<String,Integer> RaceMap6 = new Map<String,Integer>(); // White
        Map<String,Integer> RaceMap7 = new Map<String,Integer>(); // Declined
        Map<String,Integer> RaceMap8 = new Map<String,Integer>(); // Unknown
        Map<String,Integer> RaceMap9 = new Map<String,Integer>(); // Other
        
        Integer Filipino = 0;
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
                     } Else If (str.contains('Filipino')) {
                        NewName ='Filipino';
                        Filipino = Filipino + 1;
                        RaceMap10.put(NewName, Filipino);
                        // Break;
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
                    } Else  If (str.contains('Unknown')) {
                        NewName ='Unknown';
                        Unknown = Unknown + 1;
                        RaceMap8.put(NewName, Unknown);
                        // Break;
                        // 
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
        RaceQueryTotals.add(new arWrapperX(String.valueOf(raceMap10), (Integer.valueOf(Hold))));
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
    public List<arWrapperX> getGenerateParentLanguage() {
        
        // get count Language at the contact level
        list<arWrapperX> LanguagePQueryTotals = new List <arWrapperX>();
        List<AggregateResult> LanguagePAggregateResult = 
            [select  Family__Primary_Language__c aa, Count_Distinct (ID) bb                  
             From contact
             WHERE ID IN: setConMasterCG 
             group by Rollup (Family__Primary_Language__c) ];
        
        
        String NewName ='';
         Integer Blanks = 0;
        for (AggregateResult arList : LanguagePAggregateResult) { 
            If (String.valueOf(arList.get('aa')) != NULL){
                        NewName =   String.valueOf(arList.get('aa'));
                
            } Else IF (String.valueOf(arList.get('aa'))== NULL && Blanks == 0){
                NewName ='Unknown-Blank '; 
                Blanks+=1;
                
                }Else{
                                NewName ='Total' ;                   
                }
            LanguagePQueryTotals.add(new arWrapperX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));     
        }
        return LanguagePQueryTotals;
    }   
    
      
    public List<arWrapperX> getGenerateParentRT() {
        
        // get count Language at the contact level
        list<arWrapperX> LanguagePQueryTotals = new List <arWrapperX>();
        List<AggregateResult> LanguagePAggregateResult = 
            [select  RecordType.Name aa, Count_Distinct (ID) bb                  
             From contact
             WHERE ID IN: setConMasterCG 
             group by Rollup (RecordType.Name) ];
        
        
        String NewName ='';
         Integer Blanks = 0;
        for (AggregateResult arList : LanguagePAggregateResult) { 
          If(String.valueOf(arList.get('aa'))==NULL){
                NewName ='Total'; 
            } ELSE{
                //All Newname tagged already
                NewName = (String.valueOf(arList.get('aa')));  
                
            }
            LanguagePQueryTotals.add(new arWrapperX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));     
        }
        return LanguagePQueryTotals;
    }
    
    
    public List<arWrapperX> getGenerateHHTotals() {
        
        // get count number of households 
        list<arWrapperX> QueryTotals = new List <arWrapperX>();
        List<AggregateResult> AggrResult = 
            [select  NewIntakeNeeded_R__c aa, Count_Distinct (ID) bb                
             From npo02__Household__c
             WHERE ID IN: setConMasterHH 
             group by Rollup ( NewIntakeNeeded_R__c) ];
        
        
        String NewName ='';
         Integer Blanks = 0;
        for (AggregateResult arList : AggrResult) { 
             If(String.valueOf(arList.get('aa'))==NULL){
                NewName ='Total'; 
            } ELSE{
                //All Newname tagged already
                NewName = (String.valueOf(arList.get('aa')));  
                
            }
            
            QueryTotals.add(new arWrapperX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));     
        }
        return QueryTotals;
    }   
    
    public List<arWrapperX> getGenerateFamiliyIntTotalsTotals() {
        
        // get count number of households 
        list<arWrapperX> QueryTotals = new List <arWrapperX>();
        List<AggregateResult> AggrResult =  [select  RecordType.Name aa, Count_Distinct (ID) bb         
                                             FROM Case
                                             WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                             AND Call_Type__c != 'Left Message 1'
                                             AND Call_Type__c != 'Left Message 2'
                                             AND Call_Type__c != '# disconnected'
                                             AND Call_Type__c != 'No answering machine'
                                             AND Call_Type__c != 'Sent UTC Letter'     
                                             AND Family__Child__r.LastName !='Neale'
                                             AND Family__Child__r.LastName !='test'
                                             AND ContactID in :setConMasterCG
                                             AND contact.Lastname !='Neale'
                                             AND contact.Lastname !='test'
                                             
                                             AND (RecordTypeID =: rTFamInteraction.Id  ) 
                                             group by Rollup (RecordType.Name) ];
        
        
        String NewName ='';
         Integer Blanks = 0;
        for (AggregateResult arList : AggrResult) { 
              If(String.valueOf(arList.get('aa'))==NULL){
                NewName ='Total'; 
            } ELSE{
                //All Newname tagged already
                NewName = (String.valueOf(arList.get('aa')));  
                
            }
            
            QueryTotals.add(new arWrapperX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));     
        }
        return QueryTotals;
    }   
    
    public List<arWrapperX> getGenerateFamiliyIntWithAgeLimitTotals() {
        
        // get count number of households 
        list<arWrapperX> QueryTotals = new List <arWrapperX>();
        List<AggregateResult> AggrResult =  [select  RecordType.Name aa, Count_Distinct (ID) bb         
                                             FROM Case
                                             WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                              AND AgeMonthCaseTime__c > 35
                                              AND AgeMonthCaseTime__c < 264
                                             AND Call_Type__c != 'Left Message 1'
                                             AND Call_Type__c != 'Left Message 2'
                                             AND Call_Type__c != '# disconnected'
                                             AND Call_Type__c != 'No answering machine'
                                             AND Call_Type__c != 'Sent UTC Letter'     
                                             AND Family__Child__r.LastName !='Neale'
                                             AND Family__Child__r.LastName !='test'
                                             //AND ContactID in :setConMasterCG
                                             AND contact.Lastname !='Neale'
                                             AND contact.Lastname !='test'
                                             
                                             AND (RecordTypeID =: rTFamInteraction.Id  Or Call_Type__c LIKE 'PMP%' ) 
                                             group by Rollup (RecordType.Name) ];
       
                                            
        
        
        String NewName ='';
         Integer Blanks = 0;
        for (AggregateResult arList : AggrResult) { 
  If(String.valueOf(arList.get('aa'))==NULL){
                NewName ='Total'; 
            } ELSE{
                //All Newname tagged already
                NewName = (String.valueOf(arList.get('aa')));  
                
            }
            QueryTotals.add(new arWrapperX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));     
        }
        return QueryTotals;
    }   
    
    public List<arWrapperX> getGenerateProfTotals() {
        
        // get count number of households 
        list<arWrapperX> QueryTotals = new List <arWrapperX>();
        List<AggregateResult> AggrResult = 
            [select Family__Primary_Language__c  aa, Count_Distinct (ID) bb                
             From contact
             WHERE ID IN: setConMasterProf 
             group by Rollup (Family__Primary_Language__c) ];
        
        
        String NewName ='';
         Integer Blanks = 0;
        for (AggregateResult arList : AggrResult) { 
            If (String.valueOf(arList.get('aa')) != NULL){
                        NewName =   String.valueOf(arList.get('aa'));
                
            } Else IF (String.valueOf(arList.get('aa'))== NULL && Blanks == 0){
                NewName ='Unknown-Blank '; 
                Blanks+=1;
                
                }Else{
                                NewName ='Total' ;                   
                }
            QueryTotals.add(new arWrapperX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));     
        }
        return QueryTotals;
    }   
    
    
    public List<arWrapperX> getGenerateProfIntTotals() {
        
        // get count number of households 
        list<arWrapperX> QueryTotals = new List <arWrapperX>();
        List<AggregateResult> AggrResult = 
            [select RecordType.Name   aa, Count_Distinct (ID) bb                
             FROM Case
             WHERE ContactID IN: setConMasterProf
             AND start_time__c >= :dateFrom 
             AND start_time__c <= :dateTo
             AND AgeMonthCaseTime__c > 35
             AND AgeMonthCaseTime__c < 263
             AND Call_Type__c != 'Left Message 1'
             AND Call_Type__c != 'Left Message 2'
             AND Call_Type__c != '# disconnected'
             AND Call_Type__c != 'No answering machine'
             AND Call_Type__c != 'Sent UTC Letter'     
             AND Family__Child__r.LastName !='Neale'
             AND Family__Child__r.LastName !='test'
             AND contact.Lastname !='Neale'
             AND contact.Lastname !='test'
             AND RecordTypeID =: rTProfInteraction.Id
             AND ( Not Call_Type__c LIKE 'PMP%' )
                 group by Rollup (RecordType.Name) ];
        
        
        String NewName ='';
         Integer Blanks = 0;
        for (AggregateResult arList : AggrResult) { 
             If(String.valueOf(arList.get('aa'))==NULL){
                NewName ='Total'; 
            } ELSE{
                //All Newname tagged already
                NewName = (String.valueOf(arList.get('aa')));  
                
            }
            
            QueryTotals.add(new arWrapperX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));     
        }
        return QueryTotals;
    }   
    
     public List<arWrapperX> getGenerateProfCallTypeTotals() {
        
        // get count number of households 
        list<arWrapperX> QueryTotals = new List <arWrapperX>();
        List<AggregateResult> AggrResult = 
            [select Call_Type__c   aa, Count_Distinct (ID) bb                
             FROM Case
             WHERE ContactID IN: setConMasterProf
             AND start_time__c >= :dateFrom 
             AND start_time__c <= :dateTo
             AND AgeMonthCaseTime__c > 35
             AND AgeMonthCaseTime__c < 263
             AND Call_Type__c != 'Left Message 1'
             AND Call_Type__c != 'Left Message 2'
             AND Call_Type__c != '# disconnected'
             AND Call_Type__c != 'No answering machine'
             AND Call_Type__c != 'Sent UTC Letter'     
             AND Family__Child__r.LastName !='Neale'
             AND Family__Child__r.LastName !='test'
             AND contact.Lastname !='Neale'
             AND contact.Lastname !='test'
             AND RecordTypeID =: rTProfInteraction.Id
             AND ( Not Call_Type__c LIKE 'PMP%' )
                 group by Rollup (Call_Type__c) ];
        
        
        String NewName ='';
          Integer Blanks = 0;
        for (AggregateResult arList : AggrResult) { 
            If(String.valueOf(arList.get('aa'))==NULL){
                NewName ='Total'; 
            } ELSE{
                //All Newname tagged already
                NewName = (String.valueOf(arList.get('aa')));  
                
            }
            
            QueryTotals.add(new arWrapperX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));     
        }
        return QueryTotals;
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