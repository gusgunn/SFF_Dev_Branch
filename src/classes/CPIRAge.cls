public class CPIRAge {
    
    // z 11/6/17 
    //Seperate ages
    
    public Date dateFrom {get; set;}
    
    
    // Date To
    public Date dateTo {get; set;}
    
    
    public Integer dateFromSelected;
    public Integer dateFromSecond;
    
    private Set<String> setConIntHH = new Set<String>();
    private Set<String> setConCampHH = new Set<String>();
    private Set<String> setConMaster = new Set<String>();
    private String pmpVar ='PMP' + '%';
    private static RecordType rtChildContact = [Select Id, Name from RecordType where Name = 'Child/Person With Disability'  and SobjectType = 'Contact' limit 1];
    
    public CPIRAge(){
        Date DefaultDateTo = date.newinstance(2017, 9, 30);
        Date DefaultDateFrom = date.newinstance(2016, 10, 1);
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
        /* Q1Ends = date.newInstance(dateFromSelected, 9, 30 );
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
        //  setConMaster.clear();
        setConCampHH.clear();
        setConIntHH.clear();
        
        
    }
    
    
    private void runboard() {
        
        GenerateCampHH();
        GenerateCaseHH();
        
    }
    private void GenerateCampHH() { 
        
        List<campaignMember> limitCurContactEvents =[SELECT contactID,  Status, contact.npo02__Household__c
                                                     FROM campaignMember
                                                     WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                     
                                                     AND contact.name !='Neale'
                                                     AND contact.name !='test'
                                                     AND No_Show__c = false
                                                     AND  (Status Like '%Child%' OR Status = 'Family Attendee')
                                                     AND (campaign.Type = 'Clinic' 
                                                          OR campaign.Type = 'Conference'
                                                          //OR campaign.Type = 'Family Event'
                                                          OR campaign.Type = 'IRC Conference'
                                                          OR campaign.Type = 'IRC Workshop'
                                                          OR campaign.Type = 'Mini-Tech Lab'
                                                          // OR campaign.Type = 'Outreach'
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
            
            
            setConCampHH.add(cm.contact.npo02__Household__c);
            System.debug('******hh camp size = ' +  setConCampHH);
            
            
        } 
        
    }
    private void GenerateCaseHH() { 
        List<case> limitContactInteractions =[SELECT ID, contact.Lastname, contact.recordTypeID, Family__Household__c, 
                                              Family__Child__c, Family__Child__r.LastName, contact.npo02__Household__c
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
            
            setConIntHH.add(c.contact.npo02__Household__c);
            
            setConIntHH.add(c.Family__Household__c);
            
            
            
        }
        
    }
    /* Ages
* Null
*   263+
And AgeMonthCaseTime__c>=180 AND AgeMonthCaseTime__c <=263
And AgeMonthCaseTime__c>=144 AND AgeMonthCaseTime__c <=179 
And AgeMonthCaseTime__c>=72 AND AgeMonthCaseTime__c <=143
And AgeMonthCaseTime__c>=36 AND AgeMonthCaseTime__c <=71
And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <=35*/
    
    // Generate output begins
    //  ***********************************  
    public List<ExWrapperX> getGenerateAgeCamp(){  
        
        list<ExWrapperX> ageQueryTotals = new List <ExWrapperX>();
        List<Contact> ageRange =[SELECT RecordTypeID, Id, Birthdate , npo02__Household__c
                                 FROM Contact
                                 WHERE npo02__Household__c IN :setConCampHH
                                 AND RecordTypeID =:rtChildContact.ID
                                ];
        System.debug('agerange= ' + ageRange.size() + ' setConCampHH= ' + setConCampHH.size());
        Integer setAge0 =0;
        Integer setAge1 =0;
        Integer setAge2 =0;
        Integer setAge3 =0;
        Integer setAge4 =0;
        Integer setAge5 =0;
        Integer setAge6 =0;
        Integer setAge7 =0;
        Integer setAgeTotal =0;
        
       
         for(Contact c: ageRange){
            setAgeTotal = setAgeTotal + 1;
            Integer age =0;
            
            if (c.BirthDate != NULL){
                age = c.BirthDate.monthsBetween(dateTo);
                System.debug('######## Intage in months= ' + age);
                
            }            
            if(c.BirthDate == NULL){
                setAge0 = setAge0+1;
        
            }else if (age < 36){
                setAge1 = setAge1 +1;
                
            }else if (age < 72){
                setAge2 = setAge2 +1;
                
            }else if (age < 144){
                setAge3 = setAge3 +1;
                
            }else if (age < 180){
                setAge4 = setAge4 +1;   
                
            }else if (age < 228){
                setAge5 = setAge5 +1; 
                
            }else if (age < 264){
                setAge6 = setAge6 +1; 
                
                //21+ 
            }else {
                setAge7 = setAge7 +1;    
            }
            
        }  
        ageQueryTotals.add(new ExWrapperX(Integer.valueOf(setAge0), Integer.valueOf(setAge1), Integer.valueOf(setAge2),
                                          Integer.valueOf(setAge3), Integer.valueOf(setAge4), Integer.valueOf(setAge5), 
                                          Integer.valueOf(setAge6), Integer.valueOf(setAge7), Integer.valueOf(setAgeTotal))); 
        
        
        
        return ageQueryTotals; 
        
    }
    
    public List<ExWrapperX> getGenerateAgeInt(){  
        
        list<ExWrapperX> ageQueryTotals = new List <ExWrapperX>();
        List<Contact> ageRange =[SELECT RecordTypeID, Id, Birthdate , npo02__Household__c
                                 FROM Contact
                                 WHERE npo02__Household__c IN :setConIntHH
                                 AND RecordTypeID =:rtChildContact.ID
                                ];
        
        System.debug('agerange' + ageRange.size() + ' setConIntHH= ' + setConIntHH.size());
        Integer setAge0 =0;
        Integer setAge1 =0;
        Integer setAge2 =0;
        Integer setAge3 =0;
        Integer setAge4 =0;
        Integer setAge5 =0;
        Integer setAge6 =0;
        Integer setAge7 =0;
        Integer setAgeTotal =0;
        
        for(Contact c: ageRange){
            setAgeTotal = setAgeTotal + 1;
            Integer age =0;
            
            if (c.BirthDate != NULL){
                age = c.BirthDate.monthsBetween(dateTo);
                System.debug('######## Intage in months= ' + age);
                
            }            
            if(c.BirthDate == NULL){
                setAge0 = setAge0+1;
                
            }else if (age < 36){
                setAge1 = setAge1+1;
                
            }else if (age < 72){
                setAge2 = setAge2+1;
                
            }else if (age < 144){
                setAge3 = setAge3+1;
                
            }else if (age < 180){
                setAge4 = setAge4+1;   
                
            }else if (age < 228){
                setAge5 = setAge5+1; 
                
            }else if (age < 264){
                setAge6 = setAge6+1; 
                
                //21+ 
            }else {
                setAge7 = setAge7+1;    
            }
            
        }  
        ageQueryTotals.add(new ExWrapperX(Integer.valueOf(setAge0), Integer.valueOf(setAge1), Integer.valueOf(setAge2),
                                          Integer.valueOf(setAge3), Integer.valueOf(setAge4), Integer.valueOf(setAge5), 
                                          Integer.valueOf(setAge6), Integer.valueOf(setAge7), Integer.valueOf(setAgeTotal))); 
        
        
        System.debug('ageQueryTotals' + ageQueryTotals.size() );
        return ageQueryTotals; 
        
    }
    
    
    /*******************************************************************
* Wrapper 
*******************************************************************/
    
    
    public class ExWrapperX {
        
        //public String ag0 {get; set;}
        public Integer C0 {get; set;}
        //       public String ag1 {get; set;}
        public Integer C1 {get; set;}
        //         public String ag2 {get; set;}
        public Integer C2 {get; set;}
        //        public String ag3 {get; set;}
        public Integer C3 {get; set;}
        //        public String ag4 {get; set;}
        public Integer C4 {get; set;}
        //        public String ag5 {get; set;}
        public Integer C5 {get; set;}
        //      public String ag6 {get; set;}
        public Integer C6 {get; set;}
        public Integer C7 {get; set;}
        public Integer Total {get; set;}
        
        
        
        public ExWrapperX(//String str0, 
            Integer num0, 
            //String str1, 
            Integer num1, 
            //  String str2, 
            Integer num2, 
            // String str3, 
            Integer num3, 
            // String str4, 
            Integer num4, 
            // String str5, 
            Integer num5,
            // String str5, 
            Integer num6,
            Integer num7,
            Integer numT){
                // ag0 =str0;
                C0 =num0;
                // ag1 =str1;
                C1 =num1;
                // ag2 =str2;
                C2 =num2;
                //  ag3 =str3;
                C3 =num3;
                //  ag4 =str4;
                C4 =num4;
                //  ag5 =str5;
                C5 =num5;
                // ag6 =str6;
                C6 =num6;
                C7 =num7;
                Total=numT;
                
                
            }         
        
    }
}