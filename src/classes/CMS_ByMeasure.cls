public class CMS_ByMeasure {

    
    public Date dateFrom {get; set;}
    public Date dateTo {get; set;}
    public Date Q1Ends;
    public Date Q2Ends; 
    public Date Q3Ends; 
    public Date Q4Ends; 
    public Date PriorQuarterEnds;
    public Integer FYBSelected;
    public Integer FYBSecond;
    private Set<String> setConMaster = new Set<String>();
    
    public integer FS_FRS =0;
    public integer FS_SW =0;
    public integer FS_Advocacy =0;
    public integer HMG =0; 
    public integer FS_Providers =0;
    public integer Measure1 = 0;
    public static Integer counter=0;
    
    
    public CMS_ByMeasure(){
        setConMaster.clear();
        Date DefaultDateTo = date.newinstance(2018, 9, 30);
        Date DefaultDateFrom = date.newinstance(2018, 7, 1);
        DateTo=DefaultDateTo;
        DateFrom = DefaultDateFrom;
        counter =counter+1;
        System.debug('counter = :' + counter);
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
    
    private Static void runBoard(Date DateFrom, Date DateTo) {
        List<CMS_FYE__mdt> measures  =[select Id, MasterLabel, youngestAge__c, 
                                       oldestAge__c, createdByCM__c, HMG__c, CMS_Name__c, 
                                       includePMP__c, interactionType__c, Measure_Number__c, Total__c
                                       FROM CMS_FYE__mdt WHERE developername='FYE2019'];
        for(CMS_FYE__mdt measure: measures){
            Integer youngestAge = Integer.ValueOf(measure.youngestAge__c);
            Integer oldestAge = Integer.ValueOf(measure.oldestAge__c);
            String CMS_Name = measure.CMS_Name__c;
            Boolean createdByCM = measure.createdByCM__c;
            Boolean HMG = measure.HMG__c;
            String IncludePMP = measure.IncludePMP__c;
            Integer Measure_Number = Integer.ValueOf(measure.Measure_Number__c);
            Integer Total = Integer.ValueOf(measure.Total__c);
            String interactionType = measure.interactionType__c;
            
            if (Measure_Number == 1) {
                Integer getMeasure1 = GenerateUnduplicated(dateFrom, dateTo, youngestAge, oldestAge, CMS_Name, createdByCM, HMG, IncludePMP, Measure_Number, Total, interactionType);
                
            }else    if (measure.Measure_Number__c == 2) {
                Integer getMeasure2 = GenerateUnduplicated(dateFrom, dateTo, youngestAge, oldestAge, CMS_Name, createdByCM, HMG, IncludePMP, Measure_Number, Total, interactionType);
                
            }else    if (measure.Measure_Number__c == 3) {
                Integer getMeasure3 = GenerateUnduplicated(dateFrom, dateTo, youngestAge, oldestAge, CMS_Name, createdByCM, HMG, IncludePMP, Measure_Number, Total, interactionType);
                
            }else   if (measure.Measure_Number__c == 4) {
                Integer getMeasure4 = GenerateUnduplicated(dateFrom, dateTo, youngestAge, oldestAge, CMS_Name, createdByCM, HMG, IncludePMP, Measure_Number, Total, interactionType);
                
            }else   if (measure.Measure_Number__c == 5) {
                Integer getMeasure5 = GenerateUnduplicated(dateFrom, dateTo, youngestAge, oldestAge, CMS_Name, createdByCM, HMG, IncludePMP, Measure_Number, Total, interactionType);
                
            }else   if (measure.Measure_Number__c == 6) {
                Integer getMeasure6 = GenerateUnduplicated(dateFrom, dateTo, youngestAge, oldestAge, CMS_Name, createdByCM, HMG, IncludePMP, Measure_Number, Total, interactionType);
                
            }else   if (measure.Measure_Number__c == 7) {
                Integer getMeasure7 = GenerateUnduplicated(dateFrom, dateTo, youngestAge, oldestAge, CMS_Name, createdByCM, HMG, IncludePMP, Measure_Number, Total, interactionType);
                
            }else  if (measure.Measure_Number__c == 8) {
                Integer getMeasure8 = GenerateUnduplicated(dateFrom, dateTo, youngestAge, oldestAge, CMS_Name, createdByCM, HMG, IncludePMP, Measure_Number, Total, interactionType);
                
            }else   if (measure.Measure_Number__c == 9) {
                Integer getMeasure9 = GenerateUnduplicated(dateFrom, dateTo, youngestAge, oldestAge, CMS_Name, createdByCM, HMG, IncludePMP, Measure_Number, Total, interactionType);
                
            }else if   (measure.Measure_Number__c == 10) {
                Integer getMeasure10 = GenerateUnduplicated(dateFrom, dateTo, youngestAge, oldestAge, CMS_Name, createdByCM, HMG, IncludePMP, Measure_Number, Total, interactionType);
                
            }else {
                System.debug('no more measures to count');
            }
            
        }
    }
    
    private void generateBoard() {
        FYBSelected = (Integer.valueof(DateFrom.year()));
        FYBSecond = (Integer.valueof(DateFrom.year() + 1));
        Q1Ends = date.newInstance(FYBSelected, 9, 30 );
        Q2Ends = date.newInstance(FYBSelected, 12, 31 );
        Q3Ends = date.newInstance(FYBSecond, 3, 31 );
        Q4Ends = date.newInstance(FYBSecond, 6, 30 );
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
        
        System.debug('priorquarterEnds= ' + PriorQuarterEnds);
        runBoard(dateFrom, dateTo);
    }
    
    /***********************************************************************/
    
    private Static Integer GenerateUnduplicated(DateTime dateFrom, DateTime dateTo, Integer youngestAge, Integer oldestAge, 
                                                String CMS_Name, Boolean HMG, Boolean createdByCM, 
                                                String IncludePMP, Integer Measure_Number, Integer Total, 
                                                String interactionType){
                                                String pmpVar ='PMP' + '%';
                                                Set<String> contactCount = new set <String>();
                                                Integer measureCounter =0;
                                                 List<Case>contactInteractions =[SELECT ContactID
                                                                                    FROM Case
                                                                                    WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                                                    And AgeMonthCaseTime__c>=:youngestAge AND AgeMonthCaseTime__c <=:oldestAge
                                                                                    AND AgeMonthCaseTime__c != NULL
                                                                                    AND Call_Type__c != 'Left Message 1'
                                                                                    AND Call_Type__c != 'Left Message 2'
                                                                                    AND Call_Type__c != '# disconnected'
                                                                                    AND Call_Type__c != 'Sent UTC Letter'
                                                                                    AND Call_Type__c != 'No Answer Machine'
                                                                                    AND Contact.LastName !='Neale'
                                                                                    AND Contact.LastName !='test'
                                                                                    AND Created_by_CM__c =:createdByCM
                                                                                    AND CMSQ__c !=NULL
                                                                                    AND (RecordTypeID =:interactionType OR  Call_Type__c LIKE:pmpVar) 
                                                                                    AND CMS_Name__c =:CMS_Name
                                                                                   ];      
                                                    
                                                    
                                                    for (Case arList : contactInteractions) { 
                                                        contactCount.add(arList.ContactID);
                                                    }
                                                    
                                                    measureCounter = contactCount.size();
                                                    return measureCounter;
                                                }
    
    
    /****************************/
    //ES  FRS Uses CMSQuarterCase_Is workflow to pop quarter for aggregate rollups
    public List <CMSWrapper> getFRSInteractions(){
        String pmpVar ='PMP' + '%';
        List<CMSWrapper> QueryTotals = new LIST <CMSWrapper>();
        List<AggregateResult>ContactInteractions =[SELECT CMSQ__c Qnames, Count(ID) ints, Count(ContactID)  
                                                   ContactsD, Count_Distinct(ContactID) ContactsU, 
                                                   Count(Family__Child__c) KidD, 
                                                   SUM(Total_Minutes_Spent__c) Mins
                                                   FROM case
                                                   WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                   And AgeMonthCaseTime__c>=72 AND AgeMonthCaseTime__c <216
                                                   AND AgeMonthCaseTime__c !=NULL
                                                   AND Call_Type__c != 'Left Message 1'
                                                   AND Call_Type__c != 'Left Message 2'
                                                   AND Call_Type__c != '# disconnected'
                                                   AND Call_Type__c != 'Sent UTC Letter'
                                                   AND Call_Type__c != 'No answering machine'
                                                   AND Contact.LastName !='Neale'
                                                   AND Contact.LastName !='test'
                                                   AND Created_by_CM__c = False
                                                   AND CMSQ__c !=NULL
                                                   AND (RecordTypeID = '012G0000000qhDK' OR  Call_Type__c LIKE:pmpVar) 
                                                   AND CMS_Name__c = 'FS_FRS'
                                                   GROUP BY ROLLUP(CMSQ__c) ];      
        
        
        
        String NewName ='';
        Integer NewTargC=1;
        Integer NewTargD=100;
        Integer NewTargU=75;
        Integer TotalMins =0;
        Integer CurrentQ = ContactInteractions.size()-1;
        Integer UnDupeAllTotal =0; //FORM Total  Row
        Integer UndupedQTotal =0;
        String UndupedFYResult ='N/A';
        
        for (AggregateResult arList : ContactInteractions) { 
            // All Must have  a Q and a target value right now
            
            If(String.valueOf(arList.get('Qnames'))==null){
                System.debug(currentQ + ' currentQ' + ' And c= ' + NewTargC + 'd= '+ NewTargD + 'u= '+ NewTargU );
                
                NewTargD =(CurrentQ * NewTargD);
                NewTargU =(CurrentQ * NewTargU);
                NewName ='Total'; 
                UnDupeAllTotal = (Integer.valueOf(arList.get('ContactsU')));
                
                UndupedQTotal =  UnDupeAllTotal;// - es_FSUndupeFY;
                System.Debug('UndupedQTotal ' + UndupedQTotal);
                UndupedFYResult = (String.valueOf(UndupedQTotal));
            }ELSE{ 
                NewName = (String.valueOf(arList.get('Qnames')));
            }
            If(String.valueOf(arList.get('Mins'))!=null){
                TotalMins = (Integer.valueOf(arList.get('Mins')));
            } Else {
                TotalMins =0;
            }
            
            QueryTotals.add(new CMSWrapper(String.valueOf(NewName), Integer.valueOf(TotalMins),
                                           Integer.valueOf(arList.get('ints')), 
                                           Integer.valueOf(arList.get('ContactsU')),
                                           Integer.valueOf(UndupedQTotal), String.valueOf(UndupedFYResult),
                                           String.valueOf(NewName), String.valueOf(NewName),Integer.valueOf(NewTargC),
                                           Integer.valueOf(NewTargD), Integer.valueOf(NewTargU)));
            // System.debug('NoList= ' + ES1NoListQueryTotals.size())
            System.debug('IA Cases= ' + ContactInteractions);
        }
        return QueryTotals;
    }  
    
    
    /*******************************************************************/
    
    public with sharing class CMSWrapper {
        public String ES {get; set;}
        public Integer CampsC {get; set;}
        public Integer ConTactD1 {get; set;}
        public Integer ConTactDistinctU1 {get; set;}
        public Integer Target1 {get; set;}
        public String cString {get; set;}
        public String cDte {get; set;}
        public String campLink {get; set;}
        public Integer TargetC {get; set;}
        public Integer TargetU {get; set;}
        public Integer TargetD {get; set;}
        
        public CMSWrapper(String str, Integer numC,Integer numD, 
                          Integer numU, Integer tar, String txt, 
                          String dte, String cLk, Integer tarC, 
                          Integer tarD, Integer tarU ){
                              ES=str;
                              CampsC =numC;
                              ConTactD1 =numD;
                              ConTactDistinctU1 =numU;
                              Target1 = tar;
                              cString=txt;
                              cDte=dte;
                              campLink=cLk;
                              TargetC=tarC;
                              TargetD=tarD;
                              TargetU=tarU;
                              
                              
                          }  
        
    }
}