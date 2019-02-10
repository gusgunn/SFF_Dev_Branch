public class ESP_Stats1 {
    
    // *******************************************************Ethnicity, Zip Gender & parent Language
   
 
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
    
    // SetConCurrent IS dateFrom to FYTD (report end date)
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
    
    private Set<String> setConPrior9 = new Set<String>();
    private Set<String> setConCurrent9 = new Set<String>();
    
    
    private Map<ID,ID> espKidHH  =  new Map<ID,ID>();
    Private String pmpVar ='PMP' + '%';
    
    private Map<ID,ID> parentsHH  =  new Map<ID,ID>();
    private Map<ID,ID> espKidHHPrior =  new Map<ID,ID>();
    private Map<ID,ID> parentsHHPrior =  new Map<ID,ID>();
    private Set<String> ageDone = new Set<String>();
    
    public ESP_Stats1(){
        setConMaster.clear();
        setConPrior.clear();
        setConCurrent.clear();
        setConPrior2.clear();
        setConCurrent2.clear();
        setConPrior3.clear();
        setConCurrent3.clear();
        setConPrior4.clear();
        setConCurrent4.clear();
        setConPrior5.clear();
        setConCurrent5.clear();
        setConPrior6.clear();
        setConCurrent6.clear();
        setConPrior7.clear();
        setConCurrent7.clear();
        setConPrior8.clear();
        setConCurrent8.clear();
        setConPrior9.clear();
        setConCurrent9.clear(); 
        
        // set initial value
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
        
        GenerateKids();
    }
    
    
    
    private void GenerateKids() {   
        
        // PRIOR: get kids between 0 & 35 Months, listed in interactions, YT Prior month
        List<case> limitContactInteractions =[SELECT Child_Person_with_Disability_ID__c
                                              FROM case
                                              WHERE start_time__c >= :dateFrom AND start_time__c <= :PriorQuarterEnds
                                              And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <=35
                                              AND AgeMonthCaseTime__c !=NULL
                                              AND Call_Type__c != 'Left Message 1'
                                              AND Call_Type__c != 'Left Message 2'
                                              AND Child_Person_with_Disability_ID__c !='Neale'
                                              AND Child_Person_with_Disability_ID__c !='test'
                                              AND (RecordTypeID = '012G0000000qhDK' OR  Call_Type__c LIKE:pmpVar) ];
        for(case c: limitContactInteractions){
            setConPrior.add(c.Child_Person_with_Disability_ID__c);
            
        }
        
        // PRIOR: get kids between 0 & 35 Months, listed in Events
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
            setConPrior.add(cm.contactID);
            
        }
       
        
        /**************************
* pull out unduplicated kids for YTD  
* ***********************************************/
        
        // YTD: get kids between 0 & 35 Months, listed in interactions, YTD
        List<case> limitCurrentConInteractions =[SELECT Child_Person_with_Disability_ID__c
                                                 FROM case
                                                 WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                 And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <36
                                                 AND AgeMonthCaseTime__c != NULL
                                                 AND Call_Type__c != 'Left Message 1'
                                                 AND Call_Type__c != 'Left Message 2'
                                                 AND Child_Person_with_Disability_ID__c !='Neale'
                                                 AND Child_Person_with_Disability_ID__c !='test'
                                                 AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:pmpVar)  ];
        
        for(case cur: limitCurrentConInteractions){
            setConCurrent.add(cur.Child_Person_with_Disability_ID__c);
        }
        
        // get kids between 0 & 35 Months, listed in Events YTD
        List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                     FROM campaignMember
                                                     WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
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
        
        for(campaignMember cm: limitCurContactEvents){
            setConCurrent.add(cm.contactID);
            
        }
        
        
        // For households -Make map of all kids in current month -with HH ID as key
        // Make map of all kids in prior month -with HH ID as key
        List<Contact> kHH = [SELECT npo02__Household__r.ID, ID
                             FROM contact
                             WHERE id IN: setconPrior];
        
        for (contact k: kHH){
            espKidHHPrior.put(k.npo02__Household__r.ID, k.id );
        }
        
        List<Contact> kHHCurrent = [SELECT npo02__Household__r.ID, ID
                                    FROM contact
                                    WHERE id IN: setconCurrent];
        
        for (contact k: kHHCurrent){
            espKidHH.put(k.npo02__Household__r.ID, k.id );
        }
        System.Debug(espKidHH.size());
        generateParentsHouseHold();
        
        // end kids
    }
    
    // Pull Parents for prior YT prior out with espKidHHPrior. HouseholdID is the matched key
    private void generateParentsHouseHold(){
        List<Contact> ParentsPrior = [SELECT npo02__Household__r.ID, ID
                                      FROM contact
                                      WHERE recordtypeID ='012G0000000qhDM'
                                      AND npo02__Household__r.ID IN: espKidHHPrior.keyset()];
        
        
        /*   Flip it- Use parent contactID  as key, HH ID as value. 
* This will add all adults if there is more than 1.
* On distinct count, pick the one that speaks other than english if there is a choice
* (since there is no primary if both use services). */
        
        for (contact p: ParentsPrior){
            parentsHHPrior.put( p.id, p.npo02__Household__r.ID );
            System.Debug(parentsHHPrior.size());
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
    
    
    /********************************
* also need checkbox on household = true if kid <35 months
* add query for parent attending event or having interaction without child listed/particiapating
* generate Parent Primary Language with espKidsHH.keyset 
* this will test setConPrior interactions & events
* count_distinct -limit parents to one 
* test, then take both parents and parse to select best languange option 
*   ********************************
* todo: Choose parent as primary for language
* List<String> PL = new List <String> ();
* 
* PL = 'Unknown'
* for (contact cont:parentsHH ){
if cont.Family__Primary_Language__c != NULL
OR cont.Family__Primary_Language__c !='Unknown'
AND PL = 'English'
PL = cont.Family__Primary_Language__c;
}
* countMatches
* 
* 
* 
* 
******************************************************/
    
    
    public List<exwrapper> getGenerateParentLanguage() {
        
        // get current count Language dateTo. 
        // For Q1 dont back out setConPrior
        list<exwrapper> LanguageQueryTotals = new List <exwrapper>();
        List<AggregateResult> LanguageAggregateResult = 
            [select  Family__Primary_Language__c l, Count_Distinct (HouseholdID__c) hh                    
             From contact
             WHERE ID IN: parentsHH.keyset()
             AND ID NOT IN: parentsHHPrior.keyset()
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
    
    public List<exwrapper> getGenerateParentLanguageP() {
        
        // get count Language Prior. Limit 
        list<exwrapper> LanguagePQueryTotals = new List <exwrapper>();
        List<AggregateResult> LanguagePAggregateResult = 
            [select  Family__Primary_Language__c l, Count_Distinct (HouseholdID__c) hh                    
             From contact
             WHERE ID IN: parentsHHPrior.keyset() 
             group by Rollup (Family__Primary_Language__c) ];
        System.debug(parentsHHprior.size());
        
        for (AggregateResult arList : LanguagePAggregateResult) { 
            
            String.valueOf(arList.get('l'));
            
            LanguagePQueryTotals.add(new ExWrapper(String.valueOf(arList.get('l')), (Integer.valueOf(arList.get('hh')))));     
        }
        return LanguagePQueryTotals;
    }   
    //This will count all languages in household but each HH only counts as 1***
    public List<exwrapper> getGenerateParentLanguageYtd() {
        // get current count Language YTD  
        list<exwrapper> LanguageYTDQueryTotals = new List <exwrapper>();
        List<AggregateResult> LanguageYtdAggregateResult = 
            [select  Family__Primary_Language__c l, Count_Distinct (HouseholdID__c) hh                    
             From contact
             WHERE ID IN: parentsHH.keyset()
             group by Rollup (Family__Primary_Language__c) ];
        System.debug(parentsHH.size());
        
        for (AggregateResult arList : LanguageYTDAggregateResult) { 
            /*String tname='';
if(String.valueOf(arList.get('l'))==NULL){
tname='Total';
}else{*/
            String.valueOf(arList.get('l'));
            //  }       
            LanguageYTDQueryTotals.add(new ExWrapper(String.valueOf(arList.get('l')), (Integer.valueOf(arList.get('hh')))));     
        }
        return LanguageYTDQueryTotals;
    }   
    
    
    
    
    /*************************************
* generate Ethnicity set -use id string instead of ex_contact__c
******************************************/
    public List<exwrapper> getGenerateEthnicity() {
        
        // get current count Ethnicity dateTo. Limit SetCon
        list<exwrapper> ethnicityQueryTotals = new List <exwrapper>();
        List<AggregateResult> EthnicityAggregateResult = 
            [select  family__Ethnicity__c eth, Count_Distinct (id) ContactCNT                    
             From contact
             WHERE ID IN: setConCurrent
             AND ID  NOT IN : setConPrior
             group by Rollup (family__Ethnicity__c) ];
        
        
        for (AggregateResult arList : EthnicityAggregateResult) { 
            
            String.valueOf(arList.get('eth'));
            
            ethnicityQueryTotals.add(new ExWrapper(String.valueOf(arList.get('eth')), (Integer.valueOf(arList.get('ContactCNT')))));     
        }
        return ethnicityQueryTotals;
    }   
    
    // get count priorMonth Ethnicity priorMonthEnd
    public List<exwrapper> getGenerateEthnicityP() {
        list<exwrapper> ethnicityQueryTotalsPrior = new List <exwrapper>();
        
        
        List<AggregateResult> PriorEthnicityAggregateResult = 
            [select family__Ethnicity__c ethP, Count_Distinct (Id) ContactCNTP                    
             From contact
             WHERE ID IN : setConPrior
             group by Rollup (family__Ethnicity__c)];
        
        for (AggregateResult arPList : priorEthnicityAggregateResult) { 
            /*  String xname='';
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
             WHERE ID in :setConCurrent
             group by Rollup (family__Ethnicity__c) 
            ];
        
        for (AggregateResult arYList : ytdEthnicityAggregateResult) { 
            /*  String xname='';
if(String.valueOf(arYList.get('ethYtd'))==NULL){
xname='Total';
}else{  */
            String.valueOf(arYList.get('ethYtd'));
            
            ethnicityQueryTotalsYtd.add(new ExWrapper(String.valueOf(arYList.get('ethYtd')), (Integer.valueOf(arYList.get('ContactCNTytd')))));
        }
        
        return ethnicityQueryTotalsYtd;
    }  
    
    /*  ***************************************** 
*   Get Gender */
    
    
    public List<exwrapper> getGenerateGenC() { 
        //Current
        // Q1 do not back out setConPrior for Current Q
        
        list<exwrapper> genCQueryTotals = new List <exwrapper>();
        List<AggregateResult> genCAggregateResult = 
            [select  family__Gender__c zpM, Count (id) ContactCNTzpM                    
             From contact
             WHERE ID IN:setConCurrent
             AND ID NOT IN: setConPrior
             group by Rollup (family__Gender__c)];
        
        
        for (AggregateResult arRList : genCAggregateResult) { 
            
            String.valueOf(arRList.get('zpM'));
            
            genCQueryTotals.add(new ExWrapper(String.valueOf(arRList.get('zpM')), (Integer.valueOf(arRList.get('ContactCNTzpM')))));    
        }
        return genCQueryTotals;
    }   
    
    //Prior
    public List<exwrapper> getGenerateGenP() { 
        list<exwrapper> GenPQueryTotals = new List <exwrapper>();
        List<AggregateResult> genPAggregateResult = 
            [select  family__Gender__c zpF, Count (id) ContactCNTzpF                    
             From contact
             WHERE ID IN :setConPrior
             group by Rollup (family__Gender__c)];
        
        
        for (AggregateResult arRList : genPAggregateResult) { 
            String tname='';
            if(String.valueOf(arRList.get('zpF'))==NULL){
                tname='Total';
            }else{
                String.valueOf(arRList.get('zpF'));
            }       
            GenPQueryTotals.add(new ExWrapper(String.valueOf(arRList.get('zpF')), (Integer.valueOf(arRList.get('ContactCNTzpF')))));    
        }
        return GenPQueryTotals;
    }
    // Gender YTD
    public List<exwrapper> getGenerateGenYTD() { 
        list<exwrapper> GenYTDQueryTotals = new List <exwrapper>();
        List<AggregateResult> genYTDAggregateResult = 
            [select  family__Gender__c zpF, Count(id) ContactCNTzpF                    
             From contact
             WHERE ID IN : setConCurrent
             
             group by Rollup (family__Gender__c)];
        
        
        for (AggregateResult arRList : genYTDAggregateResult) { 
            String tname='';
            if(String.valueOf(arRList.get('zpF'))==NULL){
                tname='Total';
            }else{
                String.valueOf(arRList.get('zpF'));
            }       
            GenYTDQueryTotals.add(new ExWrapper(String.valueOf(arRList.get('zpF')), (Integer.valueOf(arRList.get('ContactCNTzpF')))));    
        }
        return GenYTDQueryTotals;
    }
    /**********************  End Gender */
    
    
    // get New Zip
    public List<exwrapper> getGenerateZipF() { 
        
        //Current
        list<exwrapper> zipFQueryTotals = new List <exwrapper>();
        List<AggregateResult> ZipFAggregateResult = 
            [select  npo02__Household__r.npo02__MailingPostalCode__c zpF, Count(id) ContactCNTzpF                    
             From contact
             WHERE ID IN: setconCurrent
             AND ID NOT IN: setConPrior
             group by Rollup (npo02__Household__r.npo02__MailingPostalCode__c)];
        
        
        for (AggregateResult arRList : ZipFAggregateResult) { 
            String tname='';
            if(String.valueOf(arRList.get('zpF'))==NULL){
                tname='Total';
            }else{
                
                String.valueOf(arRList.get('zpF'));
            }   
            zipFQueryTotals.add(new ExWrapper(String.valueOf(arRList.get('zpF')), (Integer.valueOf(arRList.get('ContactCNTzpF')))));    
        }
        return zipFQueryTotals;
    }
    //Prior
    
    public List<exwrapper> getGenerateZipFP() { 
        list<exwrapper> ZipFPQueryTotals = new List <exwrapper>();
        List<AggregateResult> ZipFPAggregateResult = 
            [select  npo02__Household__r.npo02__MailingPostalCode__c zpF, Count(id) ContactCNTzpF                    
             From contact
             WHERE ID IN : setconPrior
             
             group by Rollup (npo02__Household__r.npo02__MailingPostalCode__c)];
        
        
        for (AggregateResult arRList : ZipFPAggregateResult) { 
            String tname='';
            if(String.valueOf(arRList.get('zpF'))==NULL){
                tname='Total';
            }else{
                String.valueOf(arRList.get('zpF'));
            }       
            ZipFPQueryTotals.add(new ExWrapper(String.valueOf(arRList.get('zpF')), (Integer.valueOf(arRList.get('ContactCNTzpF')))));    
        }
        return ZipFPQueryTotals;
    }
    //YTD Zip
    
    public List<exwrapper> getGenerateZipFYTD() { 
        list<exwrapper> ZipFYTDQueryTotals = new List <exwrapper>();
        List<AggregateResult> ZipFYTDAggregateResult = 
            [select  npo02__Household__r.npo02__MailingPostalCode__c zpF, Count(id) ContactCNTzpF                    
             From contact
             WHERE ID IN : setConCurrent
             
             group by Rollup (npo02__Household__r.npo02__MailingPostalCode__c)];
        
        
        for (AggregateResult arRList : ZipFYTDAggregateResult) { 
            String tname='';
            if(String.valueOf(arRList.get('zpF'))==NULL){
                tname='Total';
            }else{
                String.valueOf(arRList.get('zpF'));
            }       
            ZipFYTDQueryTotals.add(new ExWrapper(String.valueOf(arRList.get('zpF')), (Integer.valueOf(arRList.get('ContactCNTzpF')))));    
        }
        return ZipFYTDQueryTotals;
    }
    
    /******************
* End Zip 
********************/
    //Generate Race FYTD
    public List<ExWrapper> getGenerateRaceYTD(){
        System.debug('setConCurrent' +  setConCurrent.size());
        list<ExWrapper> RaceQueryTotals = new List <ExWrapper>();
        List<Contact> RaceList = 
            [select  Family__Race__c , ID              
             From contact
             WHERE ID IN: setConCurrent 
            ];
        System.debug('Line 275 raceList' +  setConCurrent.size());
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
                if (RaceTally.size()>1 ) {
                    NewName ='Multiracial/Multiethnic';
                    Multi = Multi + 1;
                    RaceMap4.put(NewName, Multi);  
                    // Break;
                  
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
                    } Else If (str.contains('Multi')) {
                        NewName ='Multiracial/Multiethnic';
                        Multi = Multi + 1;
                        RaceMap4.put(NewName, Multi);
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
                
            }  Else{
                NewName ='Unknown';
                Unknown = Unknown + 1;
                RaceMap8.put(NewName, Unknown);
            }   
            
        }
        
        // System.debug('Count= ' + allRace + '  NewName= ' + Newname); // need to add each item to allrace for total
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap0), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap1), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap2), (Integer.valueOf(Hold)))); 
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap3), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap4), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap5), (Integer.valueOf(Hold)))); 
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap6), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap7), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap8), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap9), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new ExWrapper(String.valueOf(Total), (Integer.valueOf(count))));
        
        return RaceQueryTotals;
        
    }
    
    //Generate Race Prior
    public List<ExWrapper> getGenerateRaceP(){
        System.debug('setConCurrent' +  setConCurrent.size());
        list<ExWrapper> RaceQueryTotals = new List <ExWrapper>();
        List<Contact> RaceList = 
            [select  Family__Race__c , ID              
             From contact
             WHERE ID IN: setConPrior 
            ];
        
        // List <String> allRace;
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
                
            }  Else{
                NewName ='Unknown';
                Unknown = Unknown + 1;
                RaceMap8.put(NewName, Unknown);
            } 
            
        }
        
        
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap0), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap1), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap2), (Integer.valueOf(Hold)))); 
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap3), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap4), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap5), (Integer.valueOf(Hold)))); 
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap6), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap7), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap8), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap9), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new ExWrapper(String.valueOf(Total), (Integer.valueOf(count))));
        
        return RaceQueryTotals;
        
    }
    //Generate Race CurrentQ
    public List<ExWrapper> getGenerateRace(){
        System.debug('setConCurrent' +  setConCurrent.size());
        list<ExWrapper> RaceQueryTotals = new List <ExWrapper>();
        List<Contact> RaceList = 
            [select  Family__Race__c , ID              
             From contact
             WHERE ID IN: setConCurrent
             AND ID NOT IN: setConPrior 
            ];
        
        //List <String> allRace;
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
                    
                    System.Debug('************** NewName= ' + NewName);
                    
                    
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
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap0), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap1), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap2), (Integer.valueOf(Hold)))); 
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap3), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap4), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap5), (Integer.valueOf(Hold)))); 
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap6), (Integer.valueOf(Hold))));  
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap7), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap8), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new ExWrapper(String.valueOf(raceMap9), (Integer.valueOf(Hold))));
        RaceQueryTotals.add(new ExWrapper(String.valueOf(Total), (Integer.valueOf(count))));
        
        return RaceQueryTotals;
        
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
        
        public String GenderC {get; set;}
        public Integer ConTactDistinctG {get; set;}
        public String GenderP {get; set;}
        public Integer ConTactDistinctGP {get; set;}
        public String GenderYtd {get; set;}
        public Integer ConTactDistinctGYtd {get; set;}
        
        public String Race {get; set;}
        public Integer ConTactDistinctR {get; set;}
        public String RaceP {get; set;}
        public Integer ConTactDistinctRP {get; set;}
        public String RaceYtd {get; set;}
        public Integer ConTactDistinctRYtd {get; set;}
        
        
        public String ZipF {get; set;}
        public Integer ConTactDistinctZF {get; set;}
        public String ZipPF {get; set;}
        public Integer ConTactDistinctZPF {get; set;}
        public String ZipYtdF {get; set;}
        public Integer ConTactDistinctZYtdF {get; set;}
        
        
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
            
            
            GenderP =str;
            ConTactDistinctG=num;
            GenderC = str;
            ConTactDistinctGP=num;
            GenderYTD=str;
            ConTactDistinctGYtd=num;
            
            ZipF =str;
            ConTactDistinctZF=num;
            ZipPF = str;
            ConTactDistinctZPF=num;
            ZipYTDF=str;
            ConTactDistinctZYtdF=num;
            
            
            
            lC =str;
            hhC =num;
            lP =str;
            hhP =num;
            lYTD =str;
            hhYTD =num;
            
        }  
        
    }
}