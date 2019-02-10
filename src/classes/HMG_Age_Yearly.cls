public class HMG_Age_Yearly {
    
    // V3F2 Novo 5/7/18
    
    
    public Date dateFrom {get; set;}
    public Date dateTo {get; set;}
    
    public Integer to11 {get; set;}
    public Integer to23  {get; set;}
    public Integer to35 {get; set;}
    public Integer to47 {get; set;}
    public Integer to59 {get; set;}
    public Integer to71 {get; set;}
    public Integer TotalIntake {get; set;}
    public Integer Allto11 {get; set;}
    public Integer Allto23  {get; set;}
    public Integer Allto35 {get; set;}
    public Integer Allto47 {get; set;}
    public Integer Allto59 {get; set;}
    public Integer Allto71 {get; set;}
    public Integer TotalAll {get; set;}
    public Integer Intto11 {get; set;}
    public Integer Intto23  {get; set;}
    public Integer Intto35 {get; set;}
    public Integer Intto47 {get; set;}
    public Integer Intto59 {get; set;}
    public Integer Intto71 {get; set;}
    public Integer TotalInt {get; set;}
    
    private static RecordType rChild = [SELECT Id, Name FROM recordType WHERE Name = 'Child/Person with Disability' AND sObjectType = 'Contact' LIMIT 1];
    private static RecordType rTProfInteraction = [SELECT Id, Name FROM recordType WHERE Name = 'Professional Case' AND sObjectType = 'Case' LIMIT 1];
       public Set<String> setConHasKids = new Set<String>();
    public Set<String> setConEvents = new Set<String>();
    public Set<String> setConIaKids = new Set<String>();
    public Set<String> setConMasterHH = new Set<String>();
    private Set<String> setConPrior = new Set<String>();
    private Set<String> setConMaster = new Set<String>(); 
    private Set<String> setConMasterCG = new Set<String>();
    private Set<String> setConPriorCG = new Set<String>();
    private Set<String> setConMasterIntHH = new Set<String>();
    
    private Set<String> setConCurrent1 = new Set<String>();
    
    private Set<String> setConCurrent2 = new Set<String>();
    
    private Set<String> setConCurrent3 = new Set<String>();
    
    private Set<String> setConCurrent4 = new Set<String>();
    
    private Set<String> setConCurrent5 = new Set<String>();
    
    private Set<String> setConCurrent6 = new Set<String>();
    
    private Set<String> setConCurrentMaster = new Set<String>();
    private Set<String> setConMasterPrior = new Set<String>();
    
    
    
    private String pmpVar ='PMP' + '%';
    
    
    public HMG_Age_Yearly(){
        setConCurrentMaster.clear();
        setConEvents.clear();
        setConIaKids.clear();
        setConMasterHH.clear();
        setConMasterPrior.clear();
        setConMaster.clear();
        setConCurrent1.clear();
        setConCurrent2.clear();
        setConCurrent3.clear();
        setConCurrent4.clear();
        setConCurrent5.clear();
        setConCurrent6.clear();
        setConPriorCG.clear();
        setConMasterCG.clear();
        setConMasterIntHH.clear();
        setConHasKids.clear();
        Date DefaultDateTo = date.newinstance(2018, 12, 31);
        Date DefaultDateFrom = date.newinstance(2018, 1, 1);
        DateTo=DefaultDateTo;
        DateFrom = DefaultDateFrom;
        to11=0;
        to23=0;
        to35=0;
        to47=0;
        to59=0;
        to71=0;
        TotalIntake=0;
        Allto11=0;
        Allto23=0;
        Allto35=0;
        Allto47=0;
        Allto59=0;
        Allto71=0;
        TotalAll=0;
        Intto11=0;
        Intto23=0;
        Intto35=0;
        Intto47=0;
        Intto59=0;
        Intto71=0;
        TotalInt=0;
        
        
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
        System.Debug('datefrom & dateTo = ' + dateFrom + ' ' + dateTo); setConCurrentMaster.clear();
        setConEvents.clear();
        setConIaKids.clear();
        setConMasterHH.clear();
        setConMasterPrior.clear();
        setConMaster.clear();
        setConCurrent1.clear();
        setConCurrent2.clear();
        setConCurrent3.clear();
        setConCurrent4.clear();
        setConCurrent5.clear();
        setConCurrent6.clear();
        setConPriorCG.clear();
        setConMasterCG.clear();
        setConMasterIntHH.clear();
        setConHasKids.clear();
        to11=0;
        to23=0;
        to35=0;
        to47=0;
        to59=0;
        to71=0;
        TotalIntake=0;
        Allto11=0;
        Allto23=0;
        Allto35=0;
        Allto47=0;
        Allto59=0;
        Allto71=0;
        TotalAll=0;
        Intto11=0;
        Intto23=0;
        Intto35=0;
        Intto47=0;
        Intto59=0;
        Intto71=0;
        TotalInt=0;
        generateEISDashboard();
    }
    
    
    
    // generate the dashboard
    private void generateEISDashboard() {
        getHouseholdsWithIAKids();
        getHouseholdsWithContact();
        GenerateKids(); 
        GenerateKids2(); 
        GenerateKids3(); 
        GenerateKids4(); 
        GenerateKids5(); 
        GenerateKids6();
        
        
        
    } 
    public void  getHouseholdsWithIAKids(){
        System.debug('&&&&&  Enter getHouseholdsWithIAKids  ***************');
        List<Contact>Contacts =[SELECT ID, npo02__Household__r.Id , Birthdate,Family__Age_in_Months__c
                                FROM Contact
                                WHERE Family__Age_in_Months__c <= 300
                                AND npo02__Household__c !=NULL
                                AND Birthdate!=NULL
                               ];
        for(Contact c: Contacts){
            /*   Integer age = c.BirthDate.monthsBetween(dateTo);
System.debug('######## agein months= ' + age);
Boolean monthsBetween = false;

if(age <72){
//monthsBetween = c.BirthDate.monthsBetween(dateTo) <72){



}*/
            System.debug('setConIaKids= ' + setConHasKids);
            setConHasKids.add(c.npo02__Household__r.Id); 
        }
        
        
      
        return;
    }
    
    public void  getHouseholdsWithContact(){
        Set<String> FindHouseholdsWithInts = new Set <String>();
        List<Case>ContactInteractions =[SELECT ContactID, contact.npo02__Household__r.Id, Call_Type__c, Family__Child__r.npo02__Household__r.Id
                                        FROM Case
                                        WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                       // AND Call_Type__c = 'Intake'
                                        AND contact.npo02__Household__r.Id IN :setConHasKids
                                        AND Contact.LastName !='Neale'
                                        AND Contact.LastName !='test'
                                        AND  Family__Household__c !=NULL
                                        AND ((NOT RecordTypeID =:rTProfInteraction.Id)  OR Call_Type__c LIKE:pmpVar)  ];
        
        
        for (Case arList : ContactInteractions) { 
            if(arList.call_Type__c =='Intake'){
                setConMasterIntHH.add(arList.contact.npo02__Household__r.Id );
                //setConMasterHH.add(arList.contact.npo02__Household__r.Id );
                setConMaster.add(arList.contact.npo02__Household__r.Id );
            } else if (arList.call_Type__c.contains('PMP')){
               // setConMasterHH.add(arList.Family__Child__r.npo02__Household__r.Id );
                //setConMaster = int only
                setConMaster.add(arList.Family__Child__r.npo02__Household__r.Id );
            } else if (!arList.call_Type__c.contains('PMP')){
               // setConMasterHH.add(arList.contact.npo02__Household__r.Id );
                setConMaster.add(arList.contact.npo02__Household__r.Id );
            }
        }
        
        
        List<Contact>ContactIntakes =[SELECT ID, npo02__Household__r.Id , Birthdate,Family__Age_in_Months__c
                                      FROM Contact
                                      WHERE Family__Age_in_Months__c <= 300
                                      AND npo02__Household__r.Id in: setConMasterIntHH
                                      AND Birthdate!=NULL
                                      // AND RecordType.Id =: rChild.Id
                                     ];
        
        
        for(Contact c: ContactIntakes){
            Integer age = c.BirthDate.monthsBetween(dateTo);
            Integer ageBefore = c.BirthDate.monthsBetween(dateFrom);
            System.debug('######## agein months= ' + age);
            Boolean monthsBetween = false;
            
            if(age!=Null && age <12  ){
                to11 = to11+1;
                TotalIntake+=1;
            }else if (age>11 && age <24 ){
                to23= to23 + 1;
                TotalIntake+=1;
            }else if (age>23 && age <36 ){
                to35=to35+1;
                TotalIntake+=1;
            }else if (age>35 && age <48 ){
                to47=to47+1;
                TotalIntake+=1;
            }else if (age>47 && age <60 ){
                to59=to59+1;
                TotalIntake+=1;
            }else if (age>59 && age <72 ){
                to71=to71+1;
                TotalIntake+=1;
            }else {
                // too old
            }
        }   
        
          List<Contact>ContactInter =[SELECT ID, npo02__Household__r.Id , Birthdate,Family__Age_in_Months__c
                                  FROM Contact
                                  WHERE Family__Age_in_Months__c <= 300
                                  AND npo02__Household__r.Id in: setConMaster
                                  AND Birthdate!=NULL
                                  // AND RecordType.Id =: rChild.Id
                                 ];
        
        
        for(Contact ci: ContactInter){
            Integer ageInt = ci.BirthDate.monthsBetween(dateTo);
            System.debug('######## age in months= ' + ageInt);
            Boolean monthsBetween = false;
             if(ageInt!=Null && ageInt <72 ){
                setConIaKids.add(ci.npo02__Household__r.Id);
             }else{}
            
            if(ageInt!=Null && ageInt <12 ){
                Intto11+=1;
                TotalInt+=1;
            }else if (ageInt>11 && ageInt <24 ){
                Intto23+=1;
                TotalInt+=1;
            }else if (ageInt>23 && ageInt <36 ){
                Intto35+=1;
                TotalInt+=1;
            }else if (ageInt>35 && ageInt <48 ){
                Intto47+=1;
                TotalInt+=1;
            }else if (ageInt>47 && ageInt <60 ){
                Intto59+=1;
                TotalInt+=1;
            }else if (ageInt>59 && ageInt <72 ){
                Intto71+=1;
                TotalInt+=1;
            }else {
                // too old
            }
        }
        
       
        
        
          List<campaignMember> limitContactEvents =[SELECT contact.npo02__Household__r.Id
                                                  FROM campaignMember
                                                  WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                  
                                                  AND contact.name !='Neale'
                                                  AND contact.name !='test'
                                                  AND No_Show__c = false
                                                  
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
                                                       OR campaign.Type = 'Support Group'
                                                       OR campaign.Type LIKE '%Playgroup%')
                                                  AND contact.npo02__Household__c !=NULL
                                                  AND contact.npo02__Household__r.Id IN :setConIAKids
                                                  AND (NOT campaign.Name Like '%Childcare%')
                                                  AND (NOT campaign.Name Like '%Cancelled%')
                                                  AND (NOT campaign.Name Like '%No Show%')
                                                  AND (NOT campaign.Name Like '%Postponed%')];
        
        
        for(campaignMember cm: limitContactEvents){
            
            setConMasterHH.add(cm.contact.npo02__Household__r.Id);
          
        }
        
         List<Contact>ContactAll =[SELECT ID, npo02__Household__r.Id , Birthdate,Family__Age_in_Months__c
                                  FROM Contact
                                  WHERE Family__Age_in_Months__c <= 300
                                  AND npo02__Household__r.Id in: setConMasterHH
                                   
                                  AND Birthdate!=NULL
                                  // AND RecordType.Id =: rChild.Id
                                 ];
        
        for(Contact co: ContactAll){
            Integer ageAll = co.BirthDate.monthsBetween(dateTo);
            System.debug('######## agein months= ' + ageAll);
            Boolean monthsBetween = false;
            
            
            if(ageAll!=Null && ageAll <12 ){
                Allto11+=1;
                TotalAll+=1;
            }else if (ageAll>11 && ageAll <24 ){
                Allto23+=1;
                TotalAll+=1;
            }else if (ageAll>23 && ageAll <36 ){
                Allto35+=1;
                TotalAll+=1;
            }else if (ageAll>35 && ageAll <48 ){
                Allto47+=1;
                TotalAll+=1;
            }else if (ageAll>47 && ageAll <60 ){
                Allto59+=1;
                TotalAll+=1;
            }else if (ageAll>59 && ageAll <72 ){
                Allto71+=1;
                TotalAll+=1;
            }else {
                // too old
            }
        }   
        
  
        return;
    }   
    /*get kids between 0 & 11 Months, listed in interactions, YTD*/
    private void GenerateKids() {   
        List<case> limitCurrentConInteractions =[SELECT Family__Child__r.Id, ContactID, call_Type__c
                                                 FROM Case
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
                                                 
                                                 AND ((NOT RecordTypeID =:rTProfInteraction.Id)  OR Call_Type__c LIKE:pmpVar)  ];
        
        for(case c: limitCurrentConInteractions){
            
            setConCurrent1.add(c.Family__Child__r.Id);
            setConCurrentMaster.add(c.Family__Child__r.Id);
            setConMasterCG.add(c.ContactID);
        }
        
    } 
    
    /*************** get kids between 12 & 23 Months, listed in interactions, YTD */ 
    private void GenerateKids2() {   
        
        List<case> limitCurrentConInteractions2 =[SELECT Family__Child__r.Id, ContactID, Call_Type__c
                                                  FROM Case
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
                                                  AND ((NOT RecordTypeID =:rTProfInteraction.Id)  OR Call_Type__c LIKE:pmpVar)  ];
        
        for(case cur: limitCurrentConInteractions2){
            setConCurrent2.add(cur.Family__Child__r.Id);
            setConCurrentMaster.add(cur.Family__Child__r.Id);
            setConMasterCG.add(cur.ContactID);
            System.debug('setConCurrent2 Size after GK2 Events- 6-23 =' + setConCurrent2.size());
        }
        
    } 
    
    /************ get kids between 24 & 35 Months, listed in interactions, YTD ***/
    private void GenerateKids3(){
        List<case> limitCurrentConInteractions3 =[SELECT Family__Child__r.Id, ContactID, Call_Type__c
                                                  FROM Case
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
                                                  AND ((NOT RecordTypeID =:rTProfInteraction.Id)  OR Call_Type__c LIKE:pmpVar)  ];
        
        for(case c: limitCurrentConInteractions3){
            setConCurrent3.add(c.Family__Child__r.Id);
            setConCurrentMaster.add(c.Family__Child__r.Id);
            setConMasterCG.add(c.ContactID);
        }
        system.debug('setconCurrent3 after events and interactions= ' + setConCurrent3);  
    }
    
    /************get kids between 36-47 Months, listed in interactions, YTD**********/
    private void GenerateKids4(){ 
        List<case> limitCurrentConInteractions4 =[SELECT Family__Child__r.Id, ContactID, Call_Type__c
                                                  FROM Case
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
                                                  AND ((NOT RecordTypeID =:rTProfInteraction.Id)  OR Call_Type__c LIKE:pmpVar)  ];
        
        for(case c: limitCurrentConInteractions4){
            setConCurrent4.add(c.Family__Child__r.Id);
            setConCurrentMaster.add(c.Family__Child__r.Id);
            setConMasterCG.add(c.ContactID);
            
        }  
    }
    
    /****************get kids between 48-59 Months, listed in interactions, YTD ***********/    
    private void GenerateKids5(){
        List<case> limitCurrentConInteractions5 =[SELECT Family__Child__r.Id, ContactID, Call_Type__c
                                                  FROM Case
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
                                                  AND ((NOT RecordTypeID =:rTProfInteraction.Id)  OR Call_Type__c LIKE:pmpVar)  ];
        
        for(case c: limitCurrentConInteractions5){
            setConCurrent5.add(c.Family__Child__r.Id);
            setConCurrentMaster.add(c.Family__Child__r.Id);
            setConMasterCG.add(c.ContactID);
        }
        
    }
    
    /***************** get kids between 60-71 Months, listed in interactions, YTD ******************/
    private void GenerateKids6() {
        List<case> limitCurrentConInteractions6 =[SELECT Family__Child__r.Id, ContactID, Call_Type__c
                                                  FROM Case
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
                                                  AND ((NOT RecordTypeID =:rTProfInteraction.Id)  OR Call_Type__c LIKE:pmpVar)  ];
        
        for(case c: limitCurrentConInteractions6){
            
            setConCurrent6.add(c.Family__Child__r.Id);
            setConCurrentMaster.add(c.Family__Child__r.Id);
            setConMasterCG.add(c.ContactID);
        }
        
    }
    
    
    
    /***************Generate output ********************/
    
    /***Age1**/
    public List<ExWrapperEX> getGenerateAge1(){  
        list<ExWrapperEX> age1QueryTotals = new List <ExWrapperEX>();
        List<AggregateResult> ageRange1 =[SELECT RecordTypeID  ln, Count(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent1
                                          AND Birthdate != NULL
                                          Group By RecordTypeID];
        System.debug('age - # of IDs after ageRange1 query runs' + ageRange1.size());
        
        
        
        for(AggregateResult a: ageRange1){
            
            String.valueOf(a.get('ln'));
            
            age1QueryTotals.add(new ExWrapperEX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));    
            
        }
        
        return age1QueryTotals; 
        
    }
    
    /******************return age2*****************/
    public List<ExWrapperEX> getGenerateAge2(){  
        list<ExWrapperEX> age2QueryTotals = new List <ExWrapperEX>();
        List<AggregateResult> ageRange2 =[SELECT RecordTypeID  ln, Count(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent2
                                          And ID NOT IN : setConCurrent1
                                          AND Birthdate != NULL
                                          Group By RecordTypeID];
        System.debug('age - # of IDs after ageRange2 query runs' + ageRange2.size());
        for(AggregateResult a: ageRange2){
            
            String.valueOf(a.get('ln'));
            
            age2QueryTotals.add(new ExWrapperEX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));    
        }
        return age2QueryTotals; 
    }
    
    /*******************Return age 3****************/
    public List<ExWrapperEX> getGenerateAge3(){  
        list<ExWrapperEX> age3QueryTotals = new List <ExWrapperEX>();
        List<AggregateResult> ageRange3 =[SELECT RecordTypeID  ln, Count(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent3
                                          And ID NOT IN : setConCurrent2
                                          AND Birthdate != NULL
                                          Group By RecordTypeID];
        System.debug('age - # of IDs after ageRange3 query runs' + ageRange3.size());
        for(AggregateResult a: ageRange3){
            
            String.valueOf(a.get('ln'));
            
            age3QueryTotals.add(new ExWrapperEX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));    
        }
        return age3QueryTotals; 
    }
    
    /*****************return ageR4  ****************************/
    
    
    public List<ExWrapperEX> getGenerateAge4(){  
        list<ExWrapperEX> age4QueryTotals = new List <ExWrapperEX>();
        List<AggregateResult> ageRange4 =[SELECT RecordTypeID  ln, Count(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent4
                                          AND Birthdate != NULL
                                          Group By RecordTypeID ];
        System.debug('age - # of IDs after ageRange4 query runs' + ageRange4.size());
        for(AggregateResult a: ageRange4){
            
            String.valueOf(a.get('ln'));
            
            age4QueryTotals.add(new ExWrapperEX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));    
        }
        return age4QueryTotals; 
    }
    
    /********* retern Age 5 */
    public List<ExWrapperEX> getGenerateAge5(){  
        list<ExWrapperEX> age5QueryTotals = new List <ExWrapperEX>();
        List<AggregateResult> ageRange5 =[SELECT RecordTypeID  ln, Count(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent5
                                          AND Birthdate != NULL
                                          Group By RecordTypeID ];
        System.debug('age - # of IDs after ageRange5 query runs' + ageRange5.size());
        for(AggregateResult a: ageRange5){
            
            String.valueOf(a.get('ln'));
            
            age5QueryTotals.add(new ExWrapperEX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));    
        }
        return age5QueryTotals; 
    }
    
    /****** return age6 *******/
    public List<ExWrapperEX> getGenerateAge6(){  
        list<ExWrapperEX> age6QueryTotals = new List <ExWrapperEX>();
        List<AggregateResult> ageRange6 =[SELECT RecordTypeID  ln, Count(ID) kidz
                                          FROM Contact
                                          WHERE ID IN : setConCurrent6
                                          AND Birthdate != NULL
                                          Group By RecordTypeID];
        System.debug('age - # of IDs after ageRange6 query runs' + ageRange6.size());
        for(AggregateResult a: ageRange6){
            
            String.valueOf(a.get('ln'));
            
            age6QueryTotals.add(new ExWrapperEX(String.valueOf(a.get('ln')), (Integer.valueOf(a.get('kidz')))));    
        }
        return age6QueryTotals; 
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
            ];
        
        for (Contact arList : aggResult) {
            
            
            queryTotals.add(new ExWrapperEX(String.valueOf(arList.ID), (Integer.valueOf(arList.Family__Age__c))));     
        }
        return queryTotals;
        
    }
    
    // intOly
    public List<ExWrapperEX> getInt() {  
        list<ExWrapperEX> queryTotals = new List <ExWrapperEX>();
        List<Contact> aggResult = 
            [select  ID, Family__Age__c               
             From contact
             WHERE ID IN: setConMaster
            ];
        
        for (Contact arList : aggResult) {
            
            
            queryTotals.add(new ExWrapperEX(String.valueOf(arList.ID), (Integer.valueOf(arList.Family__Age__c))));     
        }
        return queryTotals;
        
    }
    public List<ExWrapperEX> getIntake() {  
        list<ExWrapperEX> queryTotals = new List <ExWrapperEX>();
        List<Contact> aggResult = 
            [select  ID, Family__Age__c               
             From contact
             WHERE ID IN: setConMasterIntHH
            ];
        
        for (Contact arList : aggResult) {
            
            
            queryTotals.add(new ExWrapperEX(String.valueOf(arList.ID), (Integer.valueOf(arList.Family__Age__c))));     
        }
        return queryTotals;
        
    }
    public List<ExWrapperEX> getAllEventInt() {  
        list<ExWrapperEX> queryTotals = new List <ExWrapperEX>();
        List<Contact> aggResult = 
            [select  ID, Family__Age__c               
             From contact
             WHERE ID IN: setConMasterHH
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