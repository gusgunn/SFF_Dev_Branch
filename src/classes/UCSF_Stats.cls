public class UCSF_Stats {


/***********************
 *
 * if too many queries then break up into 2 reports
 * fix  PL to calc best langage from household. 
 * zip to copy from adult household member
 */

     
    // Date From
    public Date dateFrom {get; set;}
    
    // Date To
    public Date dateTo {get; set;}
    
    //prior QUARTER
   public date priorMonthEnd = date.newInstance(2016, 6, 30 );
    
    
    //Current ESP FY begins
    
    public date FYB = date.newInstance(2015, 7, 1 );
    
    //prior year
    public String yearSelected {get; set;}
   
    
    public UCSF_Stats(){
        
        // set initial value
        
        
        
    }
    
    // start EIS Dashboard generation
    public PageReference startGenerateEISDashboard() {
        //date pm = date.newInstance(2016, 7, 1);
        integer mymonth = 7;
        integer lastMonth = 1;
        integer yearChosen = 15;
        if (dateFrom != null && dateTo != null) {
            if (dateTo >= dateFrom) {
              
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
     
    private Set<String> setConALL = new Set<String>();
    private Set<String> setConAge2 = new Set<String>();
    private Set<String> setConCurrent = new Set<String>(); 
    private Map<ID,ID> espKidHH  =  new Map<ID,ID>();
    private Map<ID,ID> parentsHH  =  new Map<ID,ID>();
    Private String pmpVar ='PMP' + '%';
    
    // generate the dashboard
    private void generateEISDashboard() {
        initializeEISDashboard();
        GenerateKids();
    } 
   
    private void GenerateKids() {   
  
  
        
	 	/**************************
	 	 * pull out unduplicated kids for YTD  
	 	 * ***********************************************/
        
	 	 // get kids between 0 & 35 Months, listed in interactions, YTD
	 	 // 
        List<case> limitCurrentConInteractions =[SELECT Child_Person_with_Disability_ID__c
                                              FROM case
                                              WHERE start_time__c >= :FYB AND start_time__c <= :dateTo
                                              And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <=35
                                              AND AgeMonthCaseTime__c != NULL
                                              AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:pmpVar)  ];
       
        for(case cur: limitCurrentConInteractions){
            setConCurrent.add(cur.Child_Person_with_Disability_ID__c);
             setConAll.add(cur.Child_Person_with_Disability_ID__c);
        }
        
        // setConCurrent - get kids between 0 & 35 Months, listed in Events, report month requested
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                  FROM campaignMember
                                                  WHERE Event_Date__c >= :FYB AND Event_Date__c <= :dateTo
                                                  And AgeMonthsAtCampaign__c>=0 AND AgeMonthsAtCampaign__c <=35
                                                  AND AgeMonthsAtCampaign__c !=NULL];
                                             
                                                  
        //AND (RecordTypeID = 'put excusions here' OR (RecordTypeID ='and here' AND Call_Type__c LIKE 'here*')) 
        
        for(campaignMember cm: limitCurContactEvents){
            setConCurrent.add(cm.contactID);
            setConAll.add(cm.contactID);
        }
           

        // For households -Make map of all kids 0-2 -with HH ID as key
        List<Contact> kHHCurrent = [SELECT npo02__Household__r.ID, ID
                             FROM contact
                             WHERE id IN: setconCurrent];
        
        for (contact k: kHHCurrent){
            espKidHH.put(k.npo02__Household__r.ID, k.id );
        }
 		System.Debug(espKidHH.size());
        
        
        // get kids between 36 & 71 Months, listed in interactions, YT Prior month
        List<case> limitContactInteractions2 =[SELECT Child_Person_with_Disability_ID__c
                                              FROM case
                                              WHERE start_time__c >= :FYB AND start_time__c <= :DateTO
                                              And AgeMonthCaseTime__c>=36 AND AgeMonthCaseTime__c <=71
                                              AND AgeMonthCaseTime__c !=NULL
                                               AND Child_Person_with_Disability_ID__c Not IN : SetConCurrent
                                              AND (RecordTypeID = '012G0000000qhDK' OR  Call_Type__c LIKE:pmpVar) ];
        for(case c: limitContactInteractions2){
            setConAge2.add(c.Child_Person_with_Disability_ID__c);
            setConAll.add(c.Child_Person_with_Disability_ID__c);
        }
        
        // get kids between 36 & 71 Months, listed in Events
        List<campaignMember> limitContactEvents2 =[SELECT contactID
                                                  FROM campaignMember
                                                  WHERE Event_Date__c >= :FYB AND Event_Date__c <= :DateTO
                                                  And AgeMonthsAtCampaign__c>=36 AND AgeMonthsAtCampaign__c <=71
                                                  AND  AgeMonthsAtCampaign__c !=NULL
                                                  AND contactID Not IN : SetConCurrent];
                                               
        for(campaignMember cm: limitContactEvents2){
            setConAge2.add(cm.contactID);
            setConAll.add(cm.contactID);
        }
        
        // Make map of all kids 3 to 5 -with HH ID as key
        List<Contact> kHH = [SELECT npo02__Household__r.ID, ID
                             FROM contact
                             WHERE id IN: setConAge2];
        
        for (contact k: kHH){
            espKidHH.put(k.npo02__Household__r.ID, k.id );
        }
	      
       
      
        generateParentsHouseHold();
        
        
        // end kids
    }
    
    // Pull Parents for  with espKidHHPrior. HouseholdID is the matched key
    private void generateParentsHouseHold(){
        List<Contact> Parents = [SELECT npo02__Household__r.ID, ID
                                      FROM contact
                                      WHERE recordtypeID ='012G0000000qhDM'
                                      AND npo02__Household__r.ID IN: espKidHH.keyset()];
        
        
        /*   Flip it- Use parent contactID  as key, HH ID as value. 
			* This will add all adults if there is more than 1.
			* On distinct count, pick the one that speaks other than english if there is a choice
			* (since there is no primary if both use services). */
        
        for (contact p: Parents){
            parentsHH.put( p.id, p.npo02__Household__r.ID );
            System.Debug(parentsHH.size());
        }
 
   
        // Pull Parents for current YT  with espKidHH (which has already been deduped)

        List<Contact> ParentsC = [SELECT npo02__Household__r.ID, ID, Family__Primary_Language__c
                                 FROM contact
                                 WHERE recordtypeID ='012G0000000qhDM'
                                 AND npo02__Household__r.ID IN: espKidHH.keyset()];
        
        
        for (contact cy: ParentsC){
            parentsHH.put(cy.id, cy.npo02__Household__r.ID );
           
        }     
        // now we have a list from prior & current but there can be more than 1 parent per household
    } 
    
   
   
    public List<exwrapper> getGenerateParentLanguage() {
        
        // get current count Language dateTo. Limit 
        list<exwrapper> LanguageQueryTotals = new List <exwrapper>();
        List<AggregateResult> LanguageAggregateResult = 
            [select  Family__Primary_Language__c l, Count_Distinct (HouseholdID__c) hh                    
             From contact
             WHERE ID IN: parentsHH.keyset()
            
             group by Rollup (Family__Primary_Language__c) ];
       System.debug(parentsHH.size());
        
        for (AggregateResult arList : LanguageAggregateResult) { 
            String tname='';
            if(String.valueOf(arList.get('l'))==NULL){
                tname='Total';
            }else{
                String.valueOf(arList.get('l'));
            }       
            LanguageQueryTotals.add(new ExWrapper(String.valueOf(arList.get('l')), (Integer.valueOf(arList.get('hh')))));     
        }
        return LanguageQueryTotals;
    }	
  
 
    
    
    

    /*************************************
     * generate Ethnicity set -use id string instead of ex_contact__c
	 ******************************************/
    public List<exwrapper> getGenerateEthnicity() {
        
        // get 0 - 2
        list<exwrapper> ethnicityQueryTotals = new List <exwrapper>();
        List<AggregateResult> EthnicityAggregateResult = 
            [select  family__Ethnicity__c eth, Count_Distinct (id) ContactCNT                    
             From contact
             WHERE ID IN: setConCurrent
         
             group by Rollup (family__Ethnicity__c) ];
        System.debug(setConAge2);
        System.debug(setConCurrent);
        
        for (AggregateResult arList : EthnicityAggregateResult) { 
            
                String.valueOf(arList.get('eth'));
                   
            ethnicityQueryTotals.add(new ExWrapper(String.valueOf(arList.get('eth')), (Integer.valueOf(arList.get('ContactCNT')))));     
        }
        return ethnicityQueryTotals;
    }	
    
    // get 3 to 5 yr olds
    public List<exwrapper> getGenerateEthnicityP() {
        list<exwrapper> ethnicityQueryTotalsPrior = new List <exwrapper>();
        
        
        List<AggregateResult> PriorEthnicityAggregateResult = 
            [select family__Ethnicity__c ethP, Count_Distinct (Id) ContactCNTP                    
             From contact
             WHERE ID IN : setConAge2
             group by Rollup (family__Ethnicity__c)];
        
        for (AggregateResult arPList : priorEthnicityAggregateResult) { 
            /*	String xname='';
if(String.valueOf(arPList.get('ethP'))==NULL){
xname='Total';
}else{  */
            String.valueOf(arPList.get('ethP'));
            
            ethnicityQueryTotalsPrior.add(new ExWrapper(String.valueOf(arPList.get('ethP')), (Integer.valueOf(arPList.get('ContactCNTP')))));    
        }
        
        return ethnicityQueryTotalsPrior;
    }
    
    
    // get count YTD Ethnicity dateTo
    public List<exwrapper> getGenerateEthnicityYTD() {
        list<exwrapper> ethnicityQueryTotalsYtd = new List <exwrapper>(); 
        List<AggregateResult> YTDEthnicityAggregateResult = 
            [select  family__Ethnicity__c ethYtd, Count_Distinct (Id) ContactCNTytd                    
             From contact
             WHERE ID in :setConALL
             
             
             group by Rollup (family__Ethnicity__c) 
            ];
        
        for (AggregateResult arYList : ytdEthnicityAggregateResult) { 
            /*	String xname='';
if(String.valueOf(arYList.get('ethYtd'))==NULL){
xname='Total';
}else{  */
            String.valueOf(arYList.get('ethYtd'));
            
            ethnicityQueryTotalsYtd.add(new ExWrapper(String.valueOf(arYList.get('ethYtd')), (Integer.valueOf(arYList.get('ContactCNTytd')))));
        }
        
        return ethnicityQueryTotalsYtd;
    }  
   
   

    /*******************************************************************
    * Wrapper 
    * Encapsulates Results
    *******************************************************************/
    
    
    public with sharing class ExWrapper {
        public String Ethnicities {get; set;}
        public Integer ConTactDistinct {get; set;}
        public String EthnicitiesP {get; set;}
        public Integer ConTactDistinctP {get; set;}
        public String EthnicitiesYtd {get; set;}
        public Integer ConTactDistinctYtd {get; set;}
        
        public String Race {get; set;}
        public Integer ConTactDistinctR {get; set;}
        public String RaceP {get; set;}
        public Integer ConTactDistinctRP {get; set;}
        public String RaceYtd {get; set;}
        public Integer ConTactDistinctRYtd {get; set;}
        
        public String Zip {get; set;}
        public Integer ConTactDistinctZ {get; set;}
        public String ZipP {get; set;}
        public Integer ConTactDistinctZP {get; set;}
        public String ZipYtd {get; set;}
        public Integer ConTactDistinctZYtd {get; set;}
        
        public String ZipU {get; set;}
        public Integer ConTactDistinctZU {get; set;}
        public String ZipPUP {get; set;}
        public Integer ConTactDistinctZPUP {get; set;}
        public String ZipUYtd {get; set;}
        public Integer ConTactDistinctZUYtd {get; set;}
        
        public String ZipF {get; set;}
        public Integer ConTactDistinctZF {get; set;}
        public String ZipPF {get; set;}
        public Integer ConTactDistinctZPF {get; set;}
        public String ZipYtdF {get; set;}
        public Integer ConTactDistinctZYtdF {get; set;}
        
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
        
        public String lC {get; set;}
        public Integer hhC {get; set;}
        public String lP {get; set;}
        public Integer hhP {get; set;}
        public String lYTD {get; set;}
        public Integer hhYTD {get; set;}
        
        
        public ExWrapper(string str, Integer num)
        {
            Ethnicities=str;
            ConTactDistinct =num;
            EthnicitiesP = str;
            ConTactDistinctP = num;
            EthnicitiesYtd = str;
            ConTactDistinctYtd = num;
            
            Race =str;
            ConTactDistinctR =num;
            RaceP = str;
            ConTactDistinctRP=num;
            RaceYTD=str;
            ConTactDistinctRYtd=num;
            
            
            Zip =str;
            ConTactDistinctZ=num;
            ZipP = str;
            ConTactDistinctZP=num;
            ZipYTD=str;
            ConTactDistinctZYtd=num;
            
            ZipF =str;
            ConTactDistinctZF=num;
            ZipPF = str;
            ConTactDistinctZPF=num;
            ZipYTDF=str;
            ConTactDistinctZYtdF=num;
            
            ZipU =str;
            ConTactDistinctZU=num;
            ZipPUP = str;
            ConTactDistinctZPUP=num;
            ZipUYTD=str;
            ConTactDistinctZUYtd=num;
            
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
            
            lC =str;
            hhC =num;
            lP =str;
            hhP =num;
            lYTD =str;
            hhYTD =num;
       
        }  
        
    }
}