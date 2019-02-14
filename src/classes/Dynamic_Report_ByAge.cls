public class Dynamic_Report_ByAge {

    public Date dateFrom {get; set;}
    public Date dateTo {get; set;}
    
    public Integer dateFromSelected;
    Public Integer dateFromSecond;
    
    private Set<Id> childAgeNullorOverAgeIdSet= new Set<Id>();
    private Set<Id> childAge0Set = new Set<Id>();
    private Set<Id> childAge1Set = new Set<Id>();
    private Set<Id> childAge2Set = new Set<Id>();
    private Set<Id> childAge3Set = new Set<Id>();
    private Set<Id> childAge4Set = new Set<Id>();
    private Set<Id> childAge5Set = new Set<Id>();
    private Set<Id> childAge6Set = new Set<Id>();
    private Set<Id> childAge7Set = new Set<Id>();
    private Set<Id> childAge8Set = new Set<Id>();
    private Set<Id> childAge9Set = new Set<Id>();
    private Set<Id> childAge12Set = new Set<Id>();
    
    private Set<Id> setConMaster = new Set<Id>();
    private Set<Id> priorAgeRangeSet18 = new Set<Id>();
    private Set<String> setConCurrent18 = new Set<String>();
    private Set<Id> priorAgeNullorOverAgeIdSet = new  Set<Id>();
    private Set<String> priorAgeRangeSetNoAge = new Set<String>();
    private Set<String> setConCurrentNoAge = new Set<String>();
    
    private Set<String> priorAgeRangeSet = new Set<String>();
    private Set<String> setConCurrent = new Set<String>(); 
    
    private Set<Id> childAge0to71IdSet = new Set<Id>();
    private Set<String> setConCurrent2 = new Set<String>();
    
    private Set<String> priorAgeRangeSet3 = new Set<String>();
    private Set<String> setConCurrent3 = new Set<String>();
    
    
    private Set<String> priorAgeRangeSet4 = new Set<String>();
    private Set<String> setConCurrent4 = new Set<String>();
    
    private Set<String> priorAgeRangeSet5 = new Set<String>();
    private Set<String> setConCurrent5 = new Set<String>();
    
    private Set<String> priorAgeRangeSet6 = new Set<String>();
    private Set<String> setConCurrent6 = new Set<String>();
    
    private Set<String> priorAgeRangeSet7 = new Set<String>();
    private Set<String> setConCurrent7 = new Set<String>();
    
    private Set<String> priorAgeRangeSet8 = new Set<String>();
    private Set<String> setConCurrent8 = new Set<String>();
    
    public RecordType rtFamilyInteraction = [Select Id, Name from RecordType where Name = 'Family Case' AND sObjectType = 'Case' limit 1];
    public RecordType rtProfessionalInteraction = [Select Id, Name from RecordType where Name = 'Professional Case' AND sObjectType = 'Case' limit 1];
    
    Private String pmpVar ='PMP' + '%';
    
    public Dynamic_Report_ByAge(){
        
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
        initializeBoard();
        runBoard();
    }
    private void initializeBoard(){
        
        
    }
    
    private void runboard() { 
        Set <Id> getPriorAgeNullorOverAge = GenerateKids(null, 299);
        priorAgeNullorOverAgeIdSet.addAll(getPriorAgeNullorOverAge);
        
        Set <Id> getAgeNullorOverAge = GenerateKids(null, 299);
        childAgeNullorOverAgeIdSet.addAll(getAgeNullorOverAge);
        
        Set <Id> getAge0 = GenerateKids(0, 11);
        childAge0Set.addAll(getAge0);
        
        Set <Id> getAge1 = GenerateKids(12, 23);
        childAge1Set.addAll(getAge1);
              
        Set <Id> getAge2 = GenerateKids(24, 35);
        childAge2Set.addAll(getAge2);
        
        Set <Id> getAge3 = GenerateKids(36, 47);
        childAge3Set.addAll(getAge3);
        
        Set <Id> getAge4 = GenerateKids(48, 59);
        childAge4Set.addAll(getAge4);
        
        Set <Id> getAge5 = GenerateKids(60, 71);
        childAge5Set.addAll(getAge5);
        
        Set <Id> getAge6 = GenerateKids(72, 83);
        childAge6Set.addAll(getAge6);
        
        Set <Id> getAge7 = GenerateKids(84, 95);
        childAge7Set.addAll(getAge7);
        
        Set <Id> getAge8 = GenerateKids(96, 107);
        childAge8Set.addAll(getAge8);
        
        Set <Id> getAge9 = GenerateKids(108, 119);
        childAge9Set.addAll(getAge9);
        
        Set <Id> getAge12 = GenerateKids(124, 215);
        childAge12Set.addAll(getAge12);     
    }
    
    private Set<Id> GenerateKids(Integer beginAgeRange, Integer endAgeRange ) {   
        Set<Id> ageRangeSet= new Set<Id>();
        List<case> limitCurrentConInteractions =[SELECT Id,  Family__Child__c
                                                 FROM case
                                                 WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                 AND ( AgeMonthCaseTime__c =:beginAgeRange OR AgeMonthCaseTime__c > :endAgeRange)
                                                 AND Call_Type__c != 'Left Message 1'
                                                 AND Call_Type__c != 'Left Message 2'
                                                 AND Call_Type__c != '# disconnected'
                                                 AND Call_Type__c != 'No answering machine'
                                                 AND Call_Type__c != 'Sent UTC Letter'  
                                                 AND Family__Child__r.LastName !='Neale'
                                                 AND Family__Child__r.LastName !='test'
                                                 AND Family__Child__c Not In:priorAgeRangeSet
                                                 AND Family__Child__c !=Null
                                                 AND (RecordTypeId = :rtFamilyInteraction.Id OR Call_Type__c LIKE:pmpVar)  ];
        
        for(case c: limitCurrentConInteractions){
            ageRangeSet.add(c.Family__Child__c);
            priorAgeRangeSet.add(c.Family__Child__c);
            
        }
        return ageRangeSet;
        
    }
    // get kids  listed in Events YTD
    // 
    private Set<Id> GenerateKidsYTD (Integer beginAgeRange, Integer endAgeRange ) { 
        Set<Id> ageRangeSet= new Set<Id>();
        List<campaignMember> limitCurContactEvents =[SELECT ContactId, AgeMonthsAtCampaign__c
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
                                                     AND ContactId NOT IN: priorAgeRangeSet
                                                     // AND (NOT campaign.Name Like '%Childcare%')
                                                     AND (NOT campaign.Name Like '%Cancelled%')
                                                     AND (NOT campaign.Name Like '%No Show%')
                                                     AND (NOT campaign.Name Like '%Postponed%')
                                                    ];
        
        for(campaignMember cm: limitCurContactEvents){
            
            ageRangeSet.add(cm.ContactId);
            priorAgeRangeSet.add(cm.ContactId);
            
            
        }
        return ageRangeSet;
        
    } 
    

    public List<ExWrapperX> getGenerateAgeNoAge(){  
        
        // Curent Q Totals  = FYTD - Prior Q
        list<ExWrapperX> age1QueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange1 =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : childAgeNullorOverAgeIdSet
                                          Group By RecordTypeID];
        
        for(AggregateResult a: ageRange1){
            
            age1QueryTotals.add(new ExWrapperX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));  
        }
        System.debug('age - # of IDs after ageRange null+ query runs' + ageRange1.size() + ' priorAgeRangeSet= ' + priorAgeRangeSet.size());
        return age1QueryTotals; 
        
    }
    
    public List<ExWrapperX> getGenerateAge8(){  
        
        // Curent Q Totals  = FYTD - Prior Q
        list<ExWrapperX> age1QueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange1 =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : childAge0Set
                                          AND Birthdate != NULL
                                          
                                          Group By RecordTypeID];
        
        for(AggregateResult a: ageRange1){
            
            
            age1QueryTotals.add(new ExWrapperX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz'))))); 
            //priorAgeRangeSet.add(a.ID);  
        }
        System.debug('age - # of IDs after ageRange 9+ query runs' + ageRange1.size() + ' priorAgeRangeSet= ' + priorAgeRangeSet.size());
        return age1QueryTotals; 
        
    }
    
    
    
    
    
    public List<ExWrapperX> getGenerateAge7(){  
        
        // Curent Q Totals  = FYTD - Prior Q
        list<ExWrapperX> age1QueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange1 =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : childAge9Set
                                          AND Birthdate != NULL
                                          
                                          Group By RecordTypeID];
        System.debug('age - # of IDs after ageRange 9 -17 query runs' + ageRange1.size());
        
        
        
        for(AggregateResult a: ageRange1){
            
            
            age1QueryTotals.add(new ExWrapperX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz'))))); 
            //priorAgeRangeSet.add(a.ID);  
        }
        System.debug('age - # of IDs after ageRange 9+ query runs' + ageRange1.size() + ' priorAgeRangeSet= ' + priorAgeRangeSet.size());
        return age1QueryTotals; 
        
    }
    //  ************************************
    
    public List<ExWrapperX> getGenerateAge6(){  
        list<ExWrapperX> age2QueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange2 =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : childAge6Set
                                          AND Birthdate != NULL
                                          
                                          Group By RecordTypeID];
        System.debug('age - # of IDs after ageRange 6 - 8 query runs' + ageRange2.size());
        for(AggregateResult a: ageRange2){
            
            age2QueryTotals.add(new ExWrapperX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));   
            //priorAgeRangeSet.add(a.ID); 
        }
        System.debug('age - # of IDs after ageRange 6 query runs' + ageRange2.size() + ' priorAgeRangeSet= ' + priorAgeRangeSet.size());
        return age2QueryTotals; 
    }
    
    // ***********************************
    
    public List<ExWrapperX> getGenerateAge5(){  
        list<ExWrapperX> age3QueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange3 =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : childAge5Set
                                          AND Birthdate != NULL
                                          
                                          Group By RecordTypeID];
        System.debug('age - # of IDs after ageRange 5 yrs query runs' + ageRange3.size());
        for(AggregateResult a: ageRange3){
            
            age3QueryTotals.add(new ExWrapperX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz'))))); 
            //priorAgeRangeSet.add(a.ID);
        }
        System.debug('age - # of IDs after ageRange 5 query runs' + ageRange3.size() + ' priorAgeRangeSet= ' + priorAgeRangeSet.size());
        return age3QueryTotals; 
    }
    
    //  ***********************************************************
    //  return ageR4      
    
    public List<ExWrapperX> getGenerateAge4(){  
        list<ExWrapperX> age4QueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange4 =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : childAge4Set
                                          AND Birthdate != NULL
                                          
                                          Group By RecordTypeID ];
        System.debug('age - # of IDs after ageRange4 query runs' + ageRange4.size());
        for(AggregateResult a: ageRange4){
            
            age4QueryTotals.add(new ExWrapperX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz'))))); 
            //priorAgeRangeSet.add(a.ID);
        }
        System.debug('age - # of IDs after ageRange 4 query runs' + ageRange4.size() + ' priorAgeRangeSet= ' + priorAgeRangeSet.size());
        return age4QueryTotals; 
    }
    
    // ****************************************
    // retern Age 3
    public List<ExWrapperX> getGenerateAge3(){  
        list<ExWrapperX> age5QueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange5 =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : childAge3Set
                                          AND Birthdate != NULL
                                          
                                          Group By RecordTypeID ];
        System.debug('age - # of IDs after ageRange 3yrs query runs' + ageRange5.size());
        for(AggregateResult a: ageRange5){
            
            age5QueryTotals.add(new ExWrapperX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));  
            //priorAgeRangeSet.add(a.ID);
        }
        System.debug('age - # of IDs after ageRange 3 query runs' + ageRange5.size() + ' priorAgeRangeSet= ' + priorAgeRangeSet.size());
        return age5QueryTotals; 
    }
    
    // ****************************************
    
    public List<ExWrapperX> getGenerateAge2(){  
        list<ExWrapperX> age6QueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange6 =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : childAge2Set
                                          AND Birthdate != NULL
                                          
                                          Group By RecordTypeID];
        System.debug('age - # of IDs after ageRange 2 yr query runs' + ageRange6.size());
        for(AggregateResult a: ageRange6){
            
            age6QueryTotals.add(new ExWrapperX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));  
            priorAgeRangeSet.add(a.ID);
        }
        System.debug('age - # of IDs after ageRange 2 query runs' + ageRange6.size() + ' priorAgeRangeSet= ' + priorAgeRangeSet.size());
        return age6QueryTotals; 
    }
    
    public List<ExWrapperX> getGenerateAge1(){  
        list<ExWrapperX> age6QueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange6 =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : childAge1Set
                                          AND Birthdate != NULL
                                          
                                          Group By RecordTypeID];
        System.debug('age - # of IDs after ageRange 1yr query runs' + ageRange6.size());
        for(AggregateResult a: ageRange6){
            
            age6QueryTotals.add(new ExWrapperX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));   
            //priorAgeRangeSet.add(a.ID);
        }
        System.debug('age - # of IDs after ageRange 1 query runs' + ageRange6 + ' priorAgeRangeSet= ' + priorAgeRangeSet);
        return age6QueryTotals; 
    }
    
    public List<ExWrapperX> getGenerateAge0(){  
        list<ExWrapperX> age6QueryTotals = new List <ExWrapperX>();
        List<AggregateResult> ageRange6 =[SELECT RecordTypeID  ln, Count_Distinct(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : childAge0Set
                                          AND Birthdate != NULL
                                          
                                          Group By RecordTypeID];
        
        for(AggregateResult a: ageRange6){
            
            age6QueryTotals.add(new ExWrapperX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));
            
        }
        System.debug('age - # of IDs after ageRange 0 query runs' + ageRange6 + ' priorAgeRangeSet= ' + priorAgeRangeSet);
        return age6QueryTotals; 
    }
    
    
    /*******************************************************************
* Wrapper 
*******************************************************************/
    
    
    public class ExWrapperX {
        public String ag1 {get; set;}
        public Integer C1 {get; set;} 
        public ExWrapperX(String str, Integer num){
            ag1 =str;
            c1 =num;
            
            
        }         
        
    }
}