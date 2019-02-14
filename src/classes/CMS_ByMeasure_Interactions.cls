public class CMS_ByMeasure_Interactions {

    public Date dateFrom {get; set;}
    public Date dateTo {get; set;} 
    public String reportType {get; set;}
    public List<SelectOption> selectReport { get; set; }
    private Date Q1Ends;
    private Date Q2Ends; 
    private Date Q3Ends; 
    private Date Q4Ends; 
    private Date PriorQuarterEnds;
    private Integer FYBSelected;
    private Integer FYBSecond;
    private Integer priorQuarterContactCount;
    private String pmpVar ='PMP' + '%';
    
    public CMS_ByMeasure_Interactions(){
        priorQuarterContactCount =0;
        Date DefaultDateTo = date.newinstance(2018, 9, 30);
        Date DefaultDateFrom = date.newinstance(2018, 7, 1);
        DateTo=DefaultDateTo;
        DateFrom = DefaultDateFrom;
        reportType ='Default';
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
        FYBSelected = (Integer.valueof(DateFrom.year()));
        FYBSecond = (Integer.valueof(DateFrom.year() + 1));
        Q1Ends = date.newInstance(FYBSelected, 9, 30 );
        Q2Ends = date.newInstance(FYBSelected, 12, 31 );
        Q3Ends = date.newInstance(FYBSecond, 3, 31 );
        Q4Ends = date.newInstance(FYBSecond, 6, 30 );
        System.debug('Q1Ends= ' +  Q1Ends + ' Q2Ends= ' + Q2Ends + ' Q3Ends= ' + Q3Ends + ' Q4Ends= ' + Q4Ends );
        If (dateTo <= Q1Ends){
            priorQuarterEnds = DateFrom.addDays(-1);
            System.debug('----------------------> ' + dateTo);
        }Else If (dateTo <= Q2Ends){
                priorQuarterEnds = Q1Ends;
                System.debug('----------------------> ' + dateTo);
            }Else If (dateTo <= Q3Ends){
                    priorQuarterEnds = Q2Ends; 
                }Else{
                    priorQuarterEnds = Q3Ends;
                }   
        
        System.debug('priorquarterEnds= ' + priorQuarterEnds);
        runBoard(dateFrom, dateTo, priorQuarterEnds, reportType);
    }
    
    public List<SelectOption> selectReport() {
        List<SelectOption> selections = new List<SelectOption>();
      
/* ******need to offer report categories- list of CMSFYE etc
        for (User users : [SELECT Id, Name FROM User 
                           WHERE  user.IsActive = True 
                           AND (UserRole.Name = 'SFCD Family Resource' OR IncludeInFRSDashBoard__c=true)
                           ORDER BY Name])
            selections.add(new SelectOption(users.Id, users.Name)); */
        return selections;
    }
    
    
    private void runBoard(Date dateFrom, Date dateTo, Date priorQuarterEnds, String reportType) {
          CMS_FYE__mdt measure = [select Id, MasterLabel, youngestAge__c, 
                                oldestAge__c, createdByCM__c, HMG__c, CMS_Name__c, Target_Duplicated_Contacts__c,
                                Target_Unduplicated_Contacts__c, Target_Unduplicated_Meetings__c,includePMP__c, 
                                InteractionId__c, Measure_Number__c, Total__c
                                FROM CMS_FYE__mdt WHERE DeveloperName = :reportType LIMIT 1
                               ];
 
        GeneratePriorUnduplicated(dateFrom, dateTo, priorQuarterEnds, measure);    
    }
    
    /***********************************************************************/
    
    private void GeneratePriorUnduplicated(Date dateFrom, Date dateTo, Date priorQuarterEnds, CMS_FYE__mdt measure){
       	Set<String> priorQuarterContactList = new set <String>();
        List<Case> priorQuarterContactInteractions = [SELECT ContactID
                                                      FROM Case
                                                      WHERE start_time__c >= :dateFrom AND start_time__c <= :priorQuarterEnds
                                                      And AgeMonthCaseTime__c>=:measure.youngestAge__c AND AgeMonthCaseTime__c <=:measure.oldestAge__c
                                                      AND AgeMonthCaseTime__c != NULL
                                                      AND Call_Type__c != 'Left Message 1'
                                                      AND Call_Type__c != 'Left Message 2'
                                                      AND Call_Type__c != '# disconnected'
                                                      AND Call_Type__c != 'Sent UTC Letter'
                                                      AND Call_Type__c != 'No Answer Machine'
                                                      AND Contact.LastName !='Neale'
                                                      AND Contact.LastName !='test'
                                                      AND Created_by_CM__c =:measure.createdByCM__c
                                                      AND CMSQ__c !=NULL
                                                      AND (RecordTypeID =:measure.InteractionId__c OR  Call_Type__c LIKE:pmpVar) 
                                                      AND CMS_Name__c =:measure.CMS_Name__c
                                                     ];              
        
        for (Case arList : priorQuarterContactInteractions) { 
            priorQuarterContactList.add(arList.ContactID);
            System.debug('priorQuarterContactList------------------------------> ' + priorQuarterContactList);
        }  
        priorQuarterContactCount= priorQuarterContactList.size();
  		
    }
    
    public  List <CMSWrapper> getInteractionCounts(){
        CMS_FYE__mdt measure  = [select Id, MasterLabel, youngestAge__c, 
                                oldestAge__c, createdByCM__c, HMG__c, CMS_Name__c, Target_Duplicated_Contacts__c,
                                Target_Unduplicated_Contacts__c, Target_Unduplicated_Meetings__c,includePMP__c, 
                                InteractionId__c, Measure_Number__c, Total__c
                                FROM CMS_FYE__mdt WHERE DeveloperName = :reportType LIMIT 1
                               ];
         System.debug('measure------------------------------> ' + measure);
      
        List<AggregateResult>ContactInteractions =[SELECT CMSQ__c Qnames, Count(ID) ints, Count(ContactID) 
                                                   ContactsD, Count_Distinct(ContactID) ContactsU, 
                                                   Count(Family__Child__c) KidD, 
                                                   SUM(Total_Minutes_Spent__c) Mins
                                                   FROM case
                                                   WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                   And AgeMonthCaseTime__c>=:measure.youngestAge__c AND AgeMonthCaseTime__c <=:measure.oldestAge__c
                                                   AND AgeMonthCaseTime__c != NULL
                                                   AND Call_Type__c != 'Left Message 1'
                                                   AND Call_Type__c != 'Left Message 2'
                                                   AND Call_Type__c != '# disconnected'
                                                   AND Call_Type__c != 'Sent UTC Letter'
                                                   AND Call_Type__c != 'No Answer Machine'
                                                   AND Contact.LastName !='Neale'
                                                   AND Contact.LastName !='test'
                                                   AND Created_by_CM__c =:measure.createdByCM__c
                                                   AND CMSQ__c !=NULL
                                                   AND (RecordTypeID =:measure.InteractionId__c OR  Call_Type__c LIKE:pmpVar) 
                                                   AND CMS_Name__c =:measure.CMS_Name__c
                                                   GROUP BY ROLLUP(CMSQ__c) ];    
        
        List<CMSWrapper> results = processQueryResults(measure, ContactInteractions);
        return results;
        
    }
    
    
        private List <CMSWrapper> processQueryResults(CMS_FYE__mdt measure, List<AggregateResult> ContactInteractions){       
        List<CMSWrapper> QueryTotals = new LIST <CMSWrapper>();
        String UndupedFYResult ='N/A';
        String NewName ='';
        Integer NewTargC= Integer.ValueOf(measure.Target_Unduplicated_Meetings__c);
        Integer NewTargD= Integer.ValueOf(measure.Target_Duplicated_Contacts__c);
        Integer NewTargU=Integer.ValueOf(measure.Target_Unduplicated_Contacts__c);
        Integer TotalMins =0;
        Integer CurrentQ = ContactInteractions.size()-1;
        Integer UnDupeAllTotal =0; 
        Integer UndupedQTotal =0;
        System.debug('ContactInteractions------------------------------> ' + ContactInteractions);
        for (AggregateResult arList : ContactInteractions) { 
            If(String.valueOf(arList.get('Qnames'))==null){
                System.debug(currentQ + ' currentQ' + ' And c= ' + NewTargC + 'd= '+ NewTargD + 'u= '+ NewTargU );
                NewTargD =(CurrentQ * NewTargD);
                NewTargU =(CurrentQ * NewTargU);
                NewName ='Total'; 
                UnDupeAllTotal = Integer.valueOf(arList.get('ContactsU'));
                UndupedQTotal =  (UnDupeAllTotal - priorQuarterContactCount);
                UndupedFYResult = (String.valueOf(UndupedQTotal));
            }ELSE{ 
                NewName = (String.valueOf(arList.get('Qnames')));
            }
            If(String.valueOf(arList.get('Mins'))!=null){
                TotalMins = (Integer.valueOf(arList.get('Mins')));
            } Else {
                
            }
            
            QueryTotals.add(new CMSWrapper(String.valueOf(NewName), Integer.valueOf(TotalMins),
                                           Integer.valueOf(arList.get('ints')), 
                                           Integer.valueOf(arList.get('ContactsU')),
                                           Integer.valueOf(UndupedQTotal), String.valueOf(UndupedFYResult),
                                           String.valueOf(NewName), String.valueOf(NewName),Integer.valueOf(NewTargC),
                                           Integer.valueOf(NewTargD), Integer.valueOf(NewTargU)));
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