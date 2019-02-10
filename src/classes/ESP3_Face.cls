public class ESP3_Face {

    // Date From
        public Date dateFrom {get; set;}
        
        // Date To
        public Date dateTo {get; set;}
        
        //prior month
        public date priorMonthEnd {get; set;}
        
        //Current ESP FY begins
        
        public date FYB = date.newInstance(2015, 7, 1 );
        
        //prior year
        public String yearSelected {get; set;}
        
        
        public ESP3_Face(){
            
            // set initial value
            
            
            
        }
        
        // start EIS Dashboard generation
        public PageReference startGenerateEISDashboard() {
            //date pm = date.newInstance(2015, 7, 1);
            integer mymonth = 7;
            integer lastMonth = 1;
            integer yearChosen = 15;
            if (dateFrom != null && dateTo != null) {
                if (dateTo >= dateFrom) {
                    
                    // myMonth = selected date to
                    //myMonth = dateto.month();
                    // lastMonth = month before selected dateTo
                    // lastMonth = myMonth -1; 
                    //priorMonth = selected dateTo - first day of month -1 day
                    date pm = dateto.toStartOfMonth()-1;
                    // date priorMonthYear = year(dateto.toStartOfMonth()-1);
                    this.priorMonthEnd = pm; 
                    system.debug(priorMonthEnd);
                    system.debug(pm);
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
        
        private Set<String> setConPriorF = new Set<String>();
        private Set<String> setConCurrentF = new Set<String>(); 
        private Set<String> setConCurD = new Set<String>(); 
   
        private Map<ID,ID> espKidHH  =  new Map<ID,ID>();
        private Map<ID,ID> parentsHH  =  new Map<ID,ID>();
        private Map<ID,ID> espKidHHPrior =  new Map<ID,ID>();
        private Map<ID,ID> parentsHHPrior =  new Map<ID,ID>();
        private Set<String> FaceDone = new Set<String>();

        Private String pmpVar ='PMP' + '%';
        
        // generate the dashboard
        private void generateEISDashboard() {
            initializeEISDashboard();
            GenerateKids();
        } 
        
        private void GenerateKids() {   
            
            // get kids between 0 & 35 Months, listed in interactions, YT Prior month
            List<case> limitContactInteractions =[SELECT Child_Person_with_Disability_ID__c
                                                  FROM case
                                                  WHERE start_time__c >= :FYB AND start_time__c <= :priorMonthEnd
                                                  And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <=35 
                                                  AND AgeMonthCaseTime__c !=NULL
                                                  AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:'PMP Initial' OR Call_Type__c LIKE:'PMP 2 mo' OR Call_Type__c LIKE:'pmp contact') ];
            for(case c: limitContactInteractions){
                setConPriorF.add(c.Child_Person_with_Disability_ID__c);
            }
            
            // get kids between 0 & 35 Months, listed in Events
            List<campaignMember> limitContactEvents =[SELECT contactID
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :FYB AND Event_Date__c <= :priorMonthEnd
                                                      And AgeMonthsAtCampaign__c>=0 AND AgeMonthsAtCampaign__c <=35
                                                      AND  AgeMonthsAtCampaign__c !=NULL];

            for(campaignMember cm: limitContactEvents){
                setConPriorF.add(cm.contactID);
            }
            //Get current Month all for duplicated all contact
             // get kids between 0 & 35 Months, listed in interactions, YT Prior month
            List<case> limitContactInteractionsD =[SELECT Child_Person_with_Disability_ID__c
                                                  FROM case
                                                  WHERE start_time__c >= :DateFrom AND start_time__c <= :DateTo
                                                  And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <=35 
                                                  AND AgeMonthCaseTime__c !=NULL
                                                  AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:'PMP Initial' OR Call_Type__c LIKE:'PMP 2 mo' OR Call_Type__c LIKE:'pmp contact')  ];
            for(case c: limitContactInteractionsD){
                setConCurD.add(c.Child_Person_with_Disability_ID__c);
            }
            
            // get kids between 0 & 35 Months, listed in Events
            List<campaignMember> limitContactEventsD =[SELECT contactID
                                                      FROM campaignMember
                                                      WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :DateTo
                                                      And AgeMonthsAtCampaign__c>=0 AND AgeMonthsAtCampaign__c <=35
                                                      AND  AgeMonthsAtCampaign__c !=NULL];

            for(campaignMember cm: limitContactEventsD){
                setConCurD.add(cm.contactID);
            }
            
            
            
         
            // Make map of all kids in prior month -with HH ID as key
            List<Contact> kHH = [SELECT npo02__Household__r.ID, ID
                                 FROM contact
                                 WHERE id IN: setconPriorF];
            
            for (contact k: kHH){
                espKidHHPrior.put(k.npo02__Household__r.ID, k.id );
            }
            
            
            /**************************
* pull out unduplicated kids for YTD  
* ***********************************************/
            
            // get kids between 0 & 35 Months, listed in interactions, YTD
            List<case> limitCurrentConInteractions =[SELECT Child_Person_with_Disability_ID__c
                                                     FROM case
                                                     WHERE start_time__c >= :FYB AND start_time__c <= :dateTo
                                                     And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <=35 
                                                     AND AgeMonthCaseTime__c != NULL
                                                     AND Origin LIKE : 'In-person'
                                                     AND (RecordTypeID = '012G0000000qhDK' OR Call_Type__c LIKE:'PMP Initial' OR Call_Type__c LIKE:'PMP 2 mo' OR Call_Type__c LIKE:'pmp contact') ]; 
            
            for(case cur: limitCurrentConInteractions){
                setConCurrentF.add(cur.Child_Person_with_Disability_ID__c);
            }
            
            // get kids between 0 & 35 Months, listed in Events, report month requested
            List<campaignMember> limitCurContactEvents =[SELECT contactID, AgeMonthsAtCampaign__c
                                                         FROM campaignMember
                                                         WHERE Event_Date__c >= :FYB AND Event_Date__c <= :dateTo
                                                         And AgeMonthsAtCampaign__c>=0 AND AgeMonthsAtCampaign__c <=35
                                                         AND AgeMonthsAtCampaign__c !=NULL];
            
            
            //AND (RecordTypeID = 'put excusions here' OR (RecordTypeID ='and here' AND Call_Type__c LIKE 'here*')) 
            
            for(campaignMember cm: limitCurContactEvents){
                setConCurrentF.add(cm.contactID);
            }
            
            
            // For households -Make map of all kids in current month -with HH ID as key
            List<Contact> kHHCurrent = [SELECT npo02__Household__r.ID, ID
                                        FROM contact
                                        WHERE id IN: setconCurrentF];
            
            for (contact k: kHHCurrent){
                espKidHH.put(k.npo02__Household__r.ID, k.id );
            }
            System.Debug(espKidHH.size());
            //generateParentsHouseHold();
            
            // end kids
        }
        
        /*************************************
* generate Face to FAce set -use id string instead of ex_contact__c
******************************************/
        public List<ExwrapperF> getGenerateFaceInt() {
            
            // get current count Face dateTo. Limit SetCon
            list<ExwrapperF> FaceQueryTotals = new List <ExwrapperF>();
            List<AggregateResult> FaceAggregateResult = 
                [select  Origin eth, Count_Distinct (Child_Person_with_Disability_ID__c) ContactCNT                    
                 From Case
                 WHERE Child_Person_with_Disability_ID__c IN: setConCurrentF
                 AND Child_Person_with_Disability_ID__c  NOT IN : setConPriorF
                 group by Rollup (Origin) ];
            System.debug('setConPriorF= ' + setConPriorF);
            System.debug('setConCurD= '+ setConCurrentF);
            
            for (AggregateResult arList : FaceAggregateResult) { 
                
                //String.valueOf(arList.get('eth'));
                setConPriorF.add(arList.ID);
                FaceQueryTotals.add(new ExWrapperF(String.valueOf(arList.get('eth')), (Integer.valueOf(arList.get('ContactCNT')))));     
            }
            return FaceQueryTotals;
        }	
        
           public List<ExwrapperF> getGenerateFaceEv() {
            
            // get current count Face dateTo. Limit SetCon
            list<ExwrapperF> FaceEvQueryTotals = new List <ExwrapperF>();
            List<AggregateResult> FaceEvAggregateResult = 
                [select  campaign.type eth2, Count_Distinct (contactID) ContactCNT2                    
                 From campaignMember
                 WHERE contactID IN: setConCurrentF
                 AND contactID  NOT IN : setConPriorF
                 
                 group by Rollup (campaign.type) ];
            System.debug('prior = ' + setConPriorF);
            System.debug('currD = ' + setConCurD);
                System.debug('YTD = ' + setConCurrentF);
            
            for (AggregateResult arList : FaceEvAggregateResult) { 
                
                //String.valueOf(arList.get('eth2'));
                
                FaceEvQueryTotals.add(new ExWrapperF(String.valueOf(arList.get('eth2')), (Integer.valueOf(arList.get('ContactCNT2')))));     
            }
            return FaceEvQueryTotals;
        }	
          
    
    
     public List<ExwrapperF> getGenerateFaceIntD() {
            
            // get current count Face dateTo. Limit SetCon
            list<ExwrapperF> FaceDQueryTotals = new List <ExwrapperF>();
            List<AggregateResult> FaceDAggregateResult = 
                [select  Origin eth, Count(Child_Person_with_Disability_ID__c) ContactCNT                    
                 From Case
                 WHERE Child_Person_with_Disability_ID__c IN: setConCurD
                 
                 group by Rollup (Origin) ];
            System.debug('setCurD ' + setConCurD);
            System.debug('setConCurrentF= '+ setConCurrentF);
            
            for (AggregateResult arList : FaceDAggregateResult) { 
                
                //String.valueOf(arList.get('eth'));
                
                FaceDQueryTotals.add(new ExWrapperF(String.valueOf(arList.get('eth')), (Integer.valueOf(arList.get('ContactCNT')))));     
            }
            return FaceDQueryTotals;
        }	
        
           public List<ExwrapperF> getGenerateFaceEvD() {
            
            // get current count Face dateTo. Limit SetCon
            list<ExwrapperF> FaceEvDQueryTotals = new List <ExwrapperF>();
            List<AggregateResult> FaceEvDAggregateResult = 
                [select  campaign.type eth2, Count(contactID) ContactCNT2                    
                 From campaignMember
                 WHERE contactID IN: setConCurD
                 
                 
                 group by Rollup (campaign.type) ];
            
            System.debug('current Dup = ' + setConCurD);
            
            for (AggregateResult arList : FaceEvDAggregateResult) { 
                
                //String.valueOf(arList.get('eth2'));
                     System.debug('current Dup = ' + setConCurD);
                FaceEvDQueryTotals.add(new ExWrapperF(String.valueOf(arList.get('eth2')), (Integer.valueOf(arList.get('ContactCNT2')))));     
            }
            return FaceEvDQueryTotals;
        }	
    
    /*******************************************************************
* Wrapper 
* Encapsulates Results
*******************************************************************/
    
    
    public  class ExWrapperF {
        public String face {get; set;}
        public Integer ConTactDistinctF {get; set;}
       
        public String FE {get; set;}
        public Integer ConTactDistinctFE {get; set;}
        
        public String faceD {get; set;}
        public Integer ConTactDistinctD {get; set;}
       
        public String FD {get; set;}
        public Integer ConTactDistinctFD {get; set;}
     
        
        
        public ExWrapperF(string str, Integer num)
        {
            Face=str;
            ConTactDistinctF =num;
            FE = str;
            ConTactDistinctFE = num;
            FaceD=str;
            ConTactDistinctD =num;
            FD = str;
            ConTactDistinctFD = num;
          
        }
    }
}