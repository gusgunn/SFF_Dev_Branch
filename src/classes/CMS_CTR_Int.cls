public class CMS_CTR_Int {

    public Date dateFrom {get; set;}
    public Date dateTo {get; set;}
    public Date Q1Ends;
    public Date Q2Ends; 
    public Date Q3Ends; 
    public Date Q4Ends; 
    public Date PriorQuarterEnds;
    
    public Integer FYBSelected;
    Public Integer FYBSecond;
    
    private Set<String> setConMaster = new Set<String>();
    
    Private String pmpVar ='PMP' + '%';
    public integer es_FSUndupeFY =0;
    public integer es_IAUndupeFY =0;
    public integer es6UndupeFY =0;
    public integer es_IASWUndupeFY =0;
    public integer es_SW8UndupeFY =0; 
    public integer esFSProviderUndupeFY =0;
    public integer esIAProviderUndupeFY =0;
    
    
    
    public CMS_CTR_Int(){
        setConMaster.clear();
        Date DefaultDateTo = date.newinstance(2016, 9, 30);
        Date DefaultDateFrom = date.newinstance(2016, 7, 1);
        DateTo=DefaultDateTo;
        DateFrom = DefaultDateFrom;
        
        
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
    
    private void runBoard() {
        //clearTags();
        GenerateES_FSUndupe();
        GenerateES_IAUndupe();
        GenerateES_SW8Undupe();
        GenerateES_6Undupe();
        GenerateES_IASWUndupe();
        GenerateFSProviderUndupe();
      
 
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
        runBoard();
        
    }
    
        
    
    /***********************************************************************/
    //Prior
     private  void GenerateES_IAUndupe(){
        
}

  private  void GenerateES_IASWUndupe(){
        set<String> PriorContactCount = new set <String>();
        List<Case>ContactInteractions =[SELECT ContactID
       									 FROM Case
                                                     WHERE start_time__c >= :dateFrom AND start_time__c <= :PriorQuarterEnds
                                                     And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <72
                                                     AND AgeMonthCaseTime__c !=NULL
                                                     AND Call_Type__c != 'Left Message 1'
                                                     AND Call_Type__c != 'Left Message 2'
                                                     AND Call_Type__c != '# disconnected'
                                                     AND Call_Type__c != 'Sent UTC Letter'
                                                     AND Call_Type__c != 'No Answer Machine'
                                                     AND Contact.LastName !='Neale'
                                                     AND Contact.LastName !='test'
                                                     AND Created_by_CM__c = True
                                                     AND CMSQ__c !=NULL
                                                     AND (RecordTypeID = '012G0000000qhDK' OR  Call_Type__c LIKE:pmpVar) 
                                                     AND FAmily__Child__r.HMG__c =true
                                                     ];      


    for (Case arList : ContactInteractions) { 
        PriorContactCount.add(arList.ContactID);
    }
    es_IASWUndupeFY = PriorContactCount.size();

}

 private  void GenerateES_FSUndupe(){
        set<String> PriorContactCount = new set <String>();
        List<Case>ContactInteractions =[SELECT   ContactID 
                                                     FROM case
                                                     WHERE start_time__c >= :dateFrom AND start_time__c <= :PriorQuarterEnds
                                                     And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <216
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
                                                     AND CMS_Name__c != 'ES7'
                                                     ];  

    for (Case arList : ContactInteractions) { 
        PriorContactCount.add(arList.ContactID);
    }
    es_FSUndupeFY = PriorContactCount.size();

}   
// Feldman ES7
 private  void GenerateES_6Undupe(){
        set<String> PriorContactCount = new set <String>();
        List<Case>ContactInteractions =[SELECT  ContactID 
                                                     FROM case
                                                     WHERE start_time__c >= :dateFrom AND start_time__c <= :PriorQuarterEnds
                                                     And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <216
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
                                                     AND CMS_Name__c = 'ES7'
                                                  ];      

        for (Case arList : ContactInteractions) { 
        PriorContactCount.add(arList.ContactID);
    }
    es6UndupeFY = PriorContactCount.size();

}  

 private  void GenerateES_SW8Undupe(){
       set<String> PriorContactCount = new set <String>();
        List<Case>ContactInteractions =[SELECT  ContactID
                                                     FROM case
                                                     WHERE start_time__c >= :dateFrom AND start_time__c <= :PriorQuarterEnds
                                                     And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <216
                                                     AND AgeMonthCaseTime__c !=NULL
                                                     AND Call_Type__c != 'Left Message 1'
                                                     AND Call_Type__c != 'Left Message 2'
                                                     AND Call_Type__c != '# disconnected'
                                                     AND Call_Type__c != 'Sent UTC Letter'
                                                     AND Call_Type__c != 'No answering machine'
                                                     AND Contact.LastName !='Neale'
                                                     AND Contact.LastName !='test'
                                                     AND Created_by_CM__c = True
                                                     AND (RecordTypeID = '012G0000000qhDK' OR  Call_Type__c LIKE:pmpVar) 
                                                     AND FAmily__Child__r.HMG__c !=true
                                                    ];   

for (Case arList : ContactInteractions) { 
        PriorContactCount.add(arList.ContactID);
    }
    es_SW8UndupeFY = PriorContactCount.size();

}    

 private  void GenerateFSProviderUndupe(){
       set<String> PriorContactCount = new set <String>();
        List<Case>ContactInteractions =[SELECT  ContactID
                                                     FROM case
                                                     WHERE start_time__c >= :dateFrom AND start_time__c <= :PriorQuarterEnds
                                                     And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <216
                                                     AND AgeMonthCaseTime__c !=NULL
                                                     AND Call_Type__c != 'Left Message 1'
                                                     AND Call_Type__c != 'Left Message 2'
                                                     AND Call_Type__c != '# disconnected'
                                                     AND Call_Type__c != 'No answering machine'
                                                     AND Call_Type__c != 'Sent UTC Letter'
                                                     AND Call_Type__c != 'No answering machine'
                                                     AND Contact.LastName !='Neale'
                                                     AND Contact.LastName !='test'
                                                     
                                                     AND RecordTypeID = '012G0000000qhDL'  
                                                     AND   (NOT Call_Type__c LIKE :pmpVar) 
                                                                 AND (NOT Account.Name LIKE: '%SFCD%')
                                                    
                                                      ];      

         for (Case arList : ContactInteractions) { 
                PriorContactCount.add(arList.ContactID);
            }
        esFSProviderUndupeFY = PriorContactCount.size();

} 

 private  void GenerateIAProviderUndupe(){
      
}   

 /*  Interactions **************************/
 
// HMG SW
    public List <CMSWrapper> getIASWInteractions(){
        List<CMSWrapper> QueryTotals = new LIST <CMSWrapper>();
        List<AggregateResult>ContactInteractions =[SELECT CMSQ__c Qnames, Count(ID) ints, Count(ContactID)  ContactsD, Count_Distinct(ContactID) ContactsU, 
                                                     Count(Family__Child__c) KidD, 
                                                     SUM(Total_Minutes_Spent__c) Mins
                                                     FROM case
                                                     WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                     And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <72
                                                     AND AgeMonthCaseTime__c !=NULL
                                                     AND Call_Type__c != 'Left Message 1'
                                                     AND Call_Type__c != 'Left Message 2'
                                                     AND Call_Type__c != '# disconnected'
                                                     AND Call_Type__c != 'Sent UTC Letter'
                                                     AND Call_Type__c != 'No answering machine'
                                                     AND Contact.LastName !='Neale'
                                                     AND Contact.LastName !='test'
                                                     AND Created_by_CM__c = True
                                                     AND CMSQ__c !=NULL
                                                     AND (RecordTypeID = '012G0000000qhDK' OR  Call_Type__c LIKE:pmpVar) 
                                                     AND FAmily__Child__r.HMG__c =true
                                                     GROUP BY ROLLUP(CMSQ__c) ];      
        
        
        
        String NewName ='';
        Integer NewTargC=1;
        Integer NewTargD=50;
        Integer NewTargU=10;
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
                System.Debug(' UnDupeAllTotal & es_IASWUndupeFY  ' + UnDupeAllTotal +' ' + es_IASWUndupeFY);
                UndupedQTotal =  UnDupeAllTotal - es_IASWUndupeFY;
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
            System.debug('IA Cases= ' + ContactInteractions);
        }
        return QueryTotals;
    }  
    
    /*****************************************************/
    //ES  FRS Uses CMSQuarterCase_Is workflow to pop quarter for aggregate rollups
    public List <CMSWrapper> getFRSInteractions(){
        List<CMSWrapper> QueryTotals = new LIST <CMSWrapper>();
        List<AggregateResult>ContactInteractions =[SELECT CMSQ__c Qnames, Count(ID) ints, Count(ContactID)  ContactsD, Count_Distinct(ContactID) ContactsU, 
                                                     Count(Family__Child__c) KidD, 
                                                     SUM(Total_Minutes_Spent__c) Mins
                                                     FROM case
                                                     WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                     And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <216
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
                                                      AND CMS_Name__c != 'ES7'
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
                System.Debug(' UnDupeAllTotal & es_FSUndupeFY  ' + UnDupeAllTotal +' ' + es_FSUndupeFY);
                UndupedQTotal =  UnDupeAllTotal - es_FSUndupeFY;
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
            
            System.debug('IA Cases= ' + ContactInteractions);
        }
        return QueryTotals;
    }  
    
    /**********************************************/
    
    //ES Advocacy- FRS Uses CMSQuarterCase_Is workflow to pop quarter for aggregate rollups
    public List <CMSWrapper> getES6Interactions(){
        List<CMSWrapper> QueryTotals = new LIST <CMSWrapper>();
        List<AggregateResult>ContactInteractions =[SELECT CMSQ__c Qnames, Count(ID) ints, Count(ContactID)  ContactsD, Count_Distinct(ContactID) ContactsU, 
                                                     Count(Family__Child__c) KidD, 
                                                     SUM(Total_Minutes_Spent__c) Mins
                                                     FROM case
                                                     WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                     And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <216
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
                                                     AND CMS_Name__c = 'ES7'
                                                     GROUP BY ROLLUP(CMSQ__c) ];      

        String NewName ='';
        Integer NewTargC=1;
        Integer NewTargD=100;
        Integer NewTargU=75;
        Integer TotalMins =0;
        Integer CurrentQ = ContactInteractions.size()-1; Integer UnDupeAllTotal =0; //FORM Total  Row
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
                System.Debug(' UnDupeAllTotal & es6UndupeFY  ' + UnDupeAllTotal +' ' + es6UndupeFY);
                UndupedQTotal =  UnDupeAllTotal - es6UndupeFY;
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
            System.debug('IA Cases= ' + ContactInteractions);
        }
        return QueryTotals;
    }  
    
    
    /*****************************************************/
    //ES  FRS Uses CMSQuarterCase_Is workflow to pop quarter for aggregate rollups
    public List <CMSWrapper> getFS_SWInteractions(){
        List<CMSWrapper> QueryTotals = new LIST <CMSWrapper>();
        List<AggregateResult>ContactInteractions =[SELECT CMSQ__c Qnames, Count(ID) ints, Count(ContactID)  ContactsD, Count_Distinct(ContactID) ContactsU, 
                                                     Count(Family__Child__c) KidD, 
                                                     SUM(Total_Minutes_Spent__c) Mins
                                                     FROM case
                                                     WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                     And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <216
                                                     AND AgeMonthCaseTime__c !=NULL
                                                     AND Call_Type__c != 'Left Message 1'
                                                     AND Call_Type__c != 'Left Message 2'
                                                     AND Call_Type__c != '# disconnected'
                                                     AND Call_Type__c != 'Sent UTC Letter'
                                                     AND Call_Type__c != 'No answering machine'
                                                     AND Contact.LastName !='Neale'
                                                     AND Contact.LastName !='test'
                                                     AND Created_by_CM__c = True
                                                     AND CMSQ__c !=NULL
                                                     AND (RecordTypeID = '012G0000000qhDK' OR  Call_Type__c LIKE:pmpVar) 
                                                     AND FAmily__Child__r.HMG__c !=true
                                                     GROUP BY ROLLUP(CMSQ__c) ];      
        
        
        
        String NewName ='';
        Integer NewTargC=1;
        Integer NewTargD=8;
        Integer NewTargU=8;
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
                System.Debug(' UnDupeAllTotal & es_SW8UndupeFY  ' + UnDupeAllTotal +' ' + es_SW8UndupeFY);
                UndupedQTotal =  UnDupeAllTotal - es_SW8UndupeFY;
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
    
    
    /*****************************************************/
    //ES  FRS Uses CMSQuarterCase_Is workflow to pop quarter for aggregate rollups
    public List <CMSWrapper> getFRSProviderInteractions(){
        List<CMSWrapper> QueryTotals = new LIST <CMSWrapper>();
        List<AggregateResult>ContactInteractions =[SELECT CMSQ__c Qnames, Count(ID) ints, Count(ContactID)  ContactsD, Count_Distinct(ContactID) ContactsU, 
                                                     Count(Family__Child__c) KidD, Count(Family__Household__c) hh,
                                                     SUM(Total_Minutes_Spent__c) Mins
                                                     FROM case
                                                     WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                     And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <216
                                                     AND AgeMonthCaseTime__c !=NULL
                                                     AND Call_Type__c != 'Left Message 1'
                                                     AND Call_Type__c != 'Left Message 2'
                                                     AND Call_Type__c != '# disconnected'
                                                     AND Call_Type__c != 'Sent UTC Letter'
                                                     AND Call_Type__c != 'No answering machine'
                                                     AND Contact.LastName !='Neale'
                                                     AND Contact.LastName !='test'
                                                     AND Created_by_CM__c != True
                                                     AND RecordTypeID = '012G0000000qhDL'  
                                                     AND   (NOT Call_Type__c LIKE :pmpVar) 
                                                     AND CMS_Name__c != 'ES7'
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
                System.Debug(' UnDupeAllTotal & esFSProviderUndupeFY  ' + UnDupeAllTotal +' ' + esFSProviderUndupeFY);
                UndupedQTotal =  UnDupeAllTotal - esFSProviderUndupeFY;
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
        }
        return QueryTotals;
    }  


        
       
   

    /*******************************************************************
* Wrapper 

*******************************************************************/
    
    
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
        
        public CMSWrapper(String str, Integer numC,Integer numD, Integer numU, Integer tar, String txt, String dte, String cLk, Integer tarC, Integer tarD, Integer tarU ) {
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