public class UCSFRept {
    
    
    // Date From
    // public Date dateFrom {get; set;}
    
    // Date To
    public Date dateTo {get; set;}
    
    //prior month
    public Date priorMonthEnd {get; set;}
    
    //Current ESP FY begins
    
    public Date FYB = date.newInstance(2015, 7, 1 );
    
    //prior year
    public String yearSelected {get; set;}
    
    
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
    
    private Set<String> setConCurrent9 = new Set<String>();
    
    
    
    
    
    // private Set<String> setConPriorR = new Set<String>();
    // private Set<String> setConCurrentR = new Set<String>();
    
    private Map<ID,ID> espKidHH  =  new Map<ID,ID>();
    Private String pmpVar ='PMP' + '%';
    private Map<ID,ID> parentsHH  =  new Map<ID,ID>();
    private Map<ID,ID> espKidHHPrior =  new Map<ID,ID>();
    private Map<ID,ID> parentsHHPrior =  new Map<ID,ID>();
    private Set<String> ageDone = new Set<String>();
    //Private String raceVarA ='Asian';
    
    public UCSFRept(){
        
        // set initial value
    }
    
    // start EIS Dashboard generation
    public PageReference startGenerateEISDashboard() {
        date pm = date.newInstance(2015, 7, 1);
        integer mymonth = 7;
        integer lastMonth = 1;
        integer yearChosen = 15;
        if (dateTo != null) {
            if (dateTo >= FYB) {
                
                // myMonth = selected date to
                //myMonth = dateto.month();
                // lastMonth = month before selected dateTo
                // lastMonth = myMonth -1; 
                //priorMonth = selected dateTo - first day of month -1 day
                //date pm = dateto.toStartOfMonth()-1;
                // date priorMonthYear = year(dateto.toStartOfMonth()-1);
                //this.priorMonthEnd = pm; 
                //system.debug(priorMonthEnd);
                //system.debug(pm);
                this.yearSelected = (String.valueof(yearChosen));    
                
                //Generate after declare
                generateEISDashboard();
                
                
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
    private void initializeEISDashboard() {
        
        // TODO: initialize controller values to zero
        
    }
    
    
    // generate the dashboard
    private void generateEISDashboard() {
        initializeEISDashboard();
        GenerateKids(); 
        
        GenerateKids7();
        
    } 
    
    private void GenerateKids() {   
        
        // get kids between 0 & 35 Months, listed in interactions, YT Prior month
        List<case> limitContactInteractions =[SELECT Child_Person_with_Disability_ID__c
                                              FROM case
                                              WHERE start_time__c >= :FYB AND start_time__c <= :priorMonthEnd
                                              And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <=35
                                              //AND AgeMonthCaseTime__c !=NULL
                                              AND (RecordTypeID = '012G0000000qhDK' OR  Call_Type__c LIKE:pmpVar) ];
        for(case c: limitContactInteractions){
            setConPrior.add(c.Child_Person_with_Disability_ID__c);
        }
        
        // get kids between 0 & 35 Months, listed in Events
        List<campaignMember> limitContactEvents =[SELECT contactID
                                                  FROM campaignMember
                                                  WHERE Event_Date__c >= :FYB AND Event_Date__c <= :priorMonthEnd
                                                  And AgeMonthsAtCampaign__c>=0 AND AgeMonthsAtCampaign__c <=35];
        for(campaignMember cm: limitContactEvents){
            setConPrior.add(cm.contactID);
        }
        System.debug('setConCurrent Size =  ' + setConPrior.size());
        System.debug('setConPrior Size =' + setConCurrent.size());
        
        /**************************
* pull out unduplicated kids for YTD  
* ***********************************************/
        
        // get kids between 0 & 5 Months, listed in interactions, YTD
        List<case> limitCurrentConInteractions =[SELECT Child_Person_with_Disability_ID__c
                                                 FROM case
                                                 WHERE start_time__c >= :FYB AND start_time__c <= :dateTo
                                                 And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <=35
                                                 //AND AgeMonthCaseTime__c != NULL
                                                 AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:pmpVar)  ];
        
        for(case cur: limitCurrentConInteractions){
            setConCurrent.add(cur.Child_Person_with_Disability_ID__c);
        }
        
        // get kids between 0 & 5 Months, listed in Events YTD
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                     FROM campaignMember
                                                     WHERE Event_Date__c >= :FYB AND Event_Date__c <= :dateTo
                                                     And AgeMonthsAtCampaign__c>=0 AND AgeMonthsAtCampaign__c <=35];
        
        for(campaignMember cm: limitCurContactEvents){
            setConCurrent.add(cm.contactID);
        }
        
    } 
    
    

//   3 to 5 Yrs Prior
private void GenerateKids7() {
    // CURRENT get kids between 36+ Months, listed in interactions, YTD
    List<case> limitCurrentConInteractions7 =[SELECT Child_Person_with_Disability_ID__c
                                              FROM case
                                              WHERE start_time__c >= :FYB AND start_time__c <= :dateTo
                                              And AgeMonthCaseTime__c>=36 AND AgeMonthCaseTime__c <=71
                                              //AND AgeMonthCaseTime__c != NULL
                                              AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:'PMP Initial' OR Call_Type__c LIKE:'PMP 2 mo' OR Call_Type__c LIKE:'pmp contact')   ];
    
    for(case cur: limitCurrentConInteractions7){
        setConCurrent7.add(cur.Child_Person_with_Disability_ID__c);
    }
    
    // get kids between 36+ Months, listed in Events, report month requested
    List<campaignMember> limitCurContactEvents7 =[SELECT contactID, AgeMonthsAtCampaign__c
                                                  FROM campaignMember
                                                  WHERE Event_Date__c >= :FYB AND Event_Date__c <= :dateTo
                                                  And AgeMonthsAtCampaign__c>=36 
                                                  AND AgeMonthsAtCampaign__c <=71
                                                  AND Status = 'Child Attendee'];
    
    for(campaignMember cm: limitCurContactEvents7){
        setConCurrent7.add(cm.contactID);
        System.debug('setConCurrent7 Size ' + setConCurrent7.size());
    }
}

// Generate output begins
//  ***********************************  
public List<ExWrapperX> getGenerateAge1(){  
    list<ExWrapperX> age1QueryTotals = new List <ExWrapperX>();
    List<AggregateResult> ageRange1 =[SELECT family__Gender__c ln, Count(ID) kidz
                                      FROM Contact
                                      WHERE ID IN : setConCurrent
                                      
                                      Group By family__Gender__c];
    System.debug('age - # of IDs after ageRange1 query runs' + ageRange1.size());
    for(AggregateResult a: ageRange1){
        
        String.valueOf(a.get('ln'));
        
        age1QueryTotals.add(new ExWrapperX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));    
        
    }
    return age1QueryTotals; 
}
//  ************************************


public List<ExWrapperX> getGenerateAge7(){  
    list<ExWrapperX> age7QueryTotals = new List <ExWrapperX>();
    List<AggregateResult> ageRange7 =[SELECT family__Gender__c ln, Count(ID) kidz
                                      FROM Contact
                                      WHERE ID IN : setConCurrent7
                                      
                                      Group By family__Gender__c];
    System.debug('age - # of IDs after ageRange7 query runs' + ageRange7.size());
    for(AggregateResult a: ageRange7){
        
        String.valueOf(a.get('ln'));
        
        age7QueryTotals.add(new ExWrapperX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));    
    }
    return age7QueryTotals; 
}


/*******************************************************************
* Wrapper 
* Encapsulates Results
*******************************************************************/


public class ExWrapperX {
    
    public String ag1 {get; set;}
    public Integer ConTactDistinctag1 {get; set;}
    public String ag2 {get; set;}
    public Integer ConTactDistinctag2 {get; set;}
    public String ag3 {get; set;}
    public Integer ConTactDistinctag3 {get; set;}
    public String ag4 {get; set;}
    public Integer ConTactDistinctag4 {get; set;}
    public String ag5 {get; set;}
    public Integer ConTactDistinctag5 {get; set;}
    public String ag6 {get; set;}
    public Integer ConTactDistinctag6 {get; set;}
    public String ag7 {get; set;}
    public Integer ConTactDistinctag7 {get; set;}
    public String ag8 {get; set;}
    public Integer ConTactDistinctag8 {get; set;}
    public String ag9 {get; set;}
    public Integer ConTactDistinctag9 {get; set;}
    
    
    public ExWrapperX(String str, Integer num){
        
        
        ag1 =str;
        ConTactDistinctag1=num;
        ag2 =str;
        ConTactDistinctag2=num;
        ag3 =str;
        ConTactDistinctag3=num;
        ag4 =str;
        ConTactDistinctag4=num;
        ag5 =str;
        ConTactDistinctag5=num;
        ag6 =str;
        ConTactDistinctag6=num;
        ag7 =str;
        ConTactDistinctag7=num;
        ag8 =str;
        ConTactDistinctag8=num;
        ag9 =str;
        ConTactDistinctag9=num;        
        
        
    }         
    
}
}