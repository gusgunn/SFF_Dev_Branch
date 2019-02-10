public class FECAgeCtr {

public Date dateFrom {get; set;}

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
    private Set<String> setConPrior = new Set<String>();
	private Set<String> setConCurrent3_5 = new Set<String>();
    
    private Set<String> setConCurrent6_11 = new Set<String>();
    
    private Set<String> setConCurrent12_14 = new Set<String>();
    
    private Set<String> setConCurrent15_18 = new Set<String>();
    
    private Set<String> setConCurrent19_21 = new Set<String>();
   

    Private String pmpVar ='PMP' + '%';
    
    private Map<ID,ID> parentsHH  =  new Map<ID,ID>();
   
    private Map<ID,ID> parentsHHPrior =  new Map<ID,ID>();
    private Set<String> ageDone = new Set<String>();
    
    
    
    public FECAgeCtr(){
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
        
        dateFromSelected = (Integer.valueof(DateFrom.year()));
        dateFromSecond = (Integer.valueof(DateFrom.year() + 1));
  
        initializeBoard();
        runBoard();
    }
    private void initializeBoard(){
         setConMaster.clear();
        setConPrior.clear();
        //setConCurrent.clear();
       
        setConCurrent3_5.clear();
        
        setConCurrent6_11.clear();
      
        setConCurrent12_14.clear();
  
        setConCurrent15_18.clear();
        
        setConCurrent19_21.clear();
      
       
        
        
    }
    
    // set dashboard values to zero in preparation for generation
    private void runboard() {
       
        GenerateKids3_5(); 
        GenerateKids6_11();
        GenerateKids12_14();
        GenerateKids15_18();
        GenerateKids19_21();
      
     
            
    }
    
 
    private void GenerateKids19_21() {   
        
    
        List<case> limitCurrentConInteractions =[SELECT Family__Child__r.LastName, Family__Child__c
                                                 //, ContactID__r.Lastname
                                                 FROM case
                                                 WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                 And AgeMonthCaseTime__c>=228 AND AgeMonthCaseTime__c <=263
                                                 AND AgeMonthCaseTime__c != NULL
                                                 AND Call_Type__c != 'Left Message 1'
                                                 AND Call_Type__c != 'Left Message 2'
                                                 AND Call_Type__c != '# disconnected'
                                                 AND Call_Type__c != 'No answering machine'
                                                 AND Call_Type__c != 'Sent UTC Letter'  
                                                
                                                 AND Family__Child__r.LastName !='Neale'
                                                 AND Family__Child__r.LastName !='test'
                                                 AND Family__Child__c Not In:setConPrior
                                                 AND Created_by_CM__c = false
                                                ];
        
        for(case cur: limitCurrentConInteractions){
            setConCurrent19_21.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            setConMaster.add(cur.Family__Child__c);
            
        }
        
    } 
    
    private void GenerateKids15_18() {   
         List<case> limitCurrentConInteractions =[SELECT Family__Child__r.LastName, Family__Child__c
                                                 //, ContactID__r.Lastname
                                                 FROM case
                                                 WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                 And AgeMonthCaseTime__c>=180 AND AgeMonthCaseTime__c <=227
                                                 AND AgeMonthCaseTime__c != NULL
                                                 AND Call_Type__c != 'Left Message 1'
                                                 AND Call_Type__c != 'Left Message 2'
                                                 AND Call_Type__c != '# disconnected'
                                                 AND Call_Type__c != 'No answering machine'
                                                 AND Call_Type__c != 'Sent UTC Letter'  
                                                 
                                                 AND Family__Child__r.LastName !='Neale'
                                                 AND Family__Child__r.LastName !='test'
                                                 AND Family__Child__c Not In:setConPrior
                                                AND Created_by_CM__c = false
                                                 ];
        
        for(case cur: limitCurrentConInteractions){
            setConCurrent15_18.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            setConMaster.add(cur.Family__Child__c);
            
        }
      
    } 
    
    
    
    private void GenerateKids12_14(){
        // YTD: get kids between 6 through 8 years, listed in interactions, YTD
        List<case> limitCurrentConInteractions2 =[SELECT Family__Child__c,Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=144 AND AgeMonthCaseTime__c <=179
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Call_Type__c != 'Sent UTC Letter' 
                                                  AND Family__Child__c NOT IN: setConPrior
                                                  AND Family__Child__r.LastName !='Neale'
                                                  AND Family__Child__r.LastName !='test'
                                                  AND Created_by_CM__c = false  
                                                 ];
        
        for(case cur: limitCurrentConInteractions2){
            setConCurrent12_14.add(cur.Family__Child__c);
            setConPrior.add(Cur.Family__Child__c);
            setConMaster.add(cur.Family__Child__c);
            
            
            
        }
    }
    
    
    // 6   
    private void GenerateKids6_11(){
        // YTD: get kids between 6 through 8 years, listed in interactions, YTD
        List<case> limitCurrentConInteractions2 =[SELECT Family__Child__c,Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=72 AND AgeMonthCaseTime__c <=143
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Call_Type__c != 'Sent UTC Letter' 
                                                  AND Family__Child__c NOT IN: setConPrior
                                                  AND Family__Child__r.LastName !='Neale'
                                                  AND Family__Child__r.LastName !='test'
                                                   AND Created_by_CM__c = false
                                                  //AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:'PMP Initial' OR Call_Type__c LIKE:'PMP 2 mo' OR Call_Type__c LIKE:'pmp contact')  
                                                   ];
        
        for(case cur: limitCurrentConInteractions2){
            setConCurrent6_11.add(cur.Family__Child__c);
            setConPrior.add(Cur.Family__Child__c);
            setConMaster.add(cur.Family__Child__c);
            
            
            
        }
       
    } 
    
    //   **************************************************************************************
    
    
    //  *************************************
    private void GenerateKids3_5(){
        // get kids 3 listed in interactions, YTD
        List<case> limitCurrentConInteractions5 =[SELECT Family__Child__c, Family__Child__r.LastName
                                                  FROM case
                                                  WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                  And AgeMonthCaseTime__c>=36 AND AgeMonthCaseTime__c <=71
                                                  AND AgeMonthCaseTime__c != NULL
                                                  AND Call_Type__c != 'Left Message 1'
                                                  AND Call_Type__c != 'Left Message 2'
                                                  AND Call_Type__c != '# disconnected'
                                                  AND Call_Type__c != 'No answering machine'
                                                  AND Call_Type__c != 'Sent UTC Letter'         
                                                  AND Family__Child__r.LastName !='Neale'
                                                  AND Family__Child__r.LastName !='test'
                                                   AND Created_by_CM__c = false
                                                  //And Family__Child__c NOT IN: setConPrior
                                                 // AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:'PMP Initial' OR Call_Type__c LIKE:'PMP 2 mo' OR Call_Type__c LIKE:'pmp contact')  
                                                 ];
        
        for(case cur: limitCurrentConInteractions5){
            setConCurrent3_5.add(cur.Family__Child__c);
            setConPrior.add(cur.Family__Child__c);
            setConMaster.add(cur.Family__Child__c);
            
        }
       
    }
    
    //   ****************************************************** 
 
  
    // Generate output begins
    //  ***********************************  /
  
    
    public List<ExWrapperX> getGenerateAge19_21(){
        
        list<ExWrapperX> QueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent19_21
                                          AND Birthdate != NULL
                                          
                                          Group By RecordTypeID];
 
        for(AggregateResult a: ageRange){
            
            
            QueryTotals.add(new ExWrapperX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz'))))); 
             
        }
   
        return QueryTotals; 
        
    }
    
    
    
    
    
    public List<ExWrapperX> getGenerateAge15_18(){ 
        
        // 
        list<ExWrapperX> QueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent15_18
                                          AND Birthdate != NULL
                                          
                                          Group By RecordTypeID];
       
        
        
        for(AggregateResult a: ageRange){
            
            
            QueryTotals.add(new ExWrapperX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz'))))); 
              
        }
      
        return QueryTotals; 
        
    }
    //  ************************************
   
     public List<ExWrapperX> getGenerateAge12_14(){ 
        list<ExWrapperX> QueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent12_14
                                          AND Birthdate != NULL
                                          
                                          Group By RecordTypeID];
     
        for(AggregateResult a: ageRange){
            
            QueryTotals.add(new ExWrapperX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));   
             
        }
      
        return QueryTotals; 
    }
     public List<ExWrapperX> getGenerateAge6_11(){  
        list<ExWrapperX> QueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent6_11
                                          AND Birthdate != NULL
                                          
                                          Group By RecordTypeID];
        System.debug('age - # of IDs after ageRange 6 query runs' + ageRange.size());
        for(AggregateResult a: ageRange){
            
            QueryTotals.add(new ExWrapperX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));   
           
        }
       
        return QueryTotals; 
    }
    
    public List<ExWrapperX> getGenerateAge3_5(){  
        list<ExWrapperX> QueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent3_5 
                                          AND Birthdate != NULL
                                          
                                          Group By RecordTypeID];
       
        for(AggregateResult a: ageRange){
            
          QueryTotals.add(new ExWrapperX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));   
           
        }
       
        return QueryTotals; 
    }
    
   
/*******************************************************/
     public List<ExWrapperX> getGenerateIntTotal() {
        
        // get count Language 
        list<ExWrapperX> QueryTotals = new List <ExWrapperX>();
        List<AggregateResult> AggrResult = 
            [select  Family__Primary_Language__c aa, Count_Distinct (ID) bb                 
             From contact
             WHERE ID IN: SetConMaster 
             group by Rollup (Family__Primary_Language__c) ];
      
        
        String NewName ='';
        for (AggregateResult arList : AggrResult) { 
            If(String.valueOf(arList.get('aa'))==NULL){
                NewName ='Total'; 
            } ELSE{
                NewName = (String.valueOf(arList.get('aa')));  
                
            }
   
           QueryTotals.add(new ExWrapperX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));     
        }
        return QueryTotals;
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