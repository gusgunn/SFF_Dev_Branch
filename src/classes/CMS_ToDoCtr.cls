public class CMS_ToDoCtr {
    
    public Date dateFrom {get; set;}
    public Date dateTo {get; set;}
    public Date Q1Ends;
    public Date Q2Ends; 
    public Date Q3Ends; 
    public Date Q4Ends; 
    public Date PriorQuarterEnds;
    public Integer TagContactsReturn;
    public Integer FYBSelected;
    public Integer FYBSecond;
    private Set<String> setConMaster = new Set<String>();
    Private String pmpVar ='PMP' + '%';
    
    public CMS_ToDoCtr(){
        setConMaster.clear();
        Date DefaultDateFrom = date.newinstance(2018, 7, 1);
        Date DefaultDateTo = date.newinstance(2018, 9, 30);
        DateTo=DefaultDateTo;
        DateFrom = DefaultDateFrom;
        PriorQuarterEnds =DefaultDateFrom;        
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
        setConMaster.clear();
        clearTag();
        
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
        runboard();
        
        
        
    }
    
    public static void clearTag() {
        
        List <Contact> newContacts = new List <Contact>();  
        List <Contact> ClearAdditionalContacts = new List <Contact>(); 
        
        ClearAdditionalContacts = [SELECT ID 
                                   FROM Contact
                                   WHERE CMS_Tag__c = True
                                   OR CMS_TAG_Events__c = True
                                   OR CMS_TAG_Campaign__c = True
                                   LIMIT 200];
        
        for(contact ac: ClearAdditionalContacts) {
            System.debug('1');
            ac.CMS_Tag__c = False;
            ac.CMS_TAG_Campaign__c = False;
            ac.CMS_TAG_Events__c=False;
            newContacts.add(ac);
        }
        System.debug(newContacts.size()  + 'number');
        update newContacts;
        
        
    }
    
    public  void MakeTagContacts() { 
        //clearTag();
        
        
        
        List<campaignMember> limitCurContactEvents =[SELECT contactID
                                                     FROM campaignMember
                                                     WHERE Event_Date__c > :PriorQuarterEnds AND Event_Date__c <= :dateTo
                                                     // Put in safeguard for current Quarter only?
                                                     AND (NOT contact.name  Like '%Neale%')
                                                     AND (NOT contact.name  Like '%Test%')
                                                     AND No_Show__c = false
                                                     AND (NOT campaign.Name Like '%Cancelled%')
                                                     AND (NOT campaign.Name Like '%No Show%')
                                                     AND (NOT campaign.Name Like '%Postponed%')
                                                     //Limit children to only the ES that count them. 
                                                     //That means some may be uploaded that are not in age groups that have targets
                                                     AND ((((Status = 'Family Attendee') OR (Status Like 'Child%'  
                                                                                             
                                                                                             AND AgeMonthsAtCampaign__c <= 215
                                                                                             AND AgeMonthsAtCampaign__c != NULL)) 
                                                           // OR ((campaign.CMSName__c = 'ES4' OR campaign.CMSName__c ='ES3')
                                                           //  AND Status = 'Child Attendee' 
                                                           AND (campaign.status = 'Completed' OR campaign.status = 'Data In Except Survey' ) 
                                                           // Adding in chidren from childcare
                                                           
                                                           
                                                           AND campaign.Project_or_Funder__c INCLUDES ('Family Support')
                                                           //need to add in family events
                                                           AND campaign.CMSName__c != NULL)
                                                          OR (campaign.name Like '%Childcare%'
                                                              AND AgeMonthsAtCampaign__c < 216
                                                              AND AgeMonthsAtCampaign__c != NULL))
                                                     
                                                    ];
        
        for(campaignMember cm: limitCurContactEvents){
            setConMaster.add(cm.contactID);        
        }
        
        List<case> limitContactInteractions =[SELECT ID, contactID
                                              FROM case
                                              WHERE start_time__c > :PriorQuarterEnds AND start_time__c <= :dateTo
                                              And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <=215
                                              AND AgeMonthCaseTime__c !=NULL
                                              AND Call_Type__c != 'Left Message 1'
                                              AND Call_Type__c != 'Left Message 2'
                                              AND Call_Type__c != 'Disconected'
                                              AND Call_Type__c != 'Sent UTC Letter'
                                              AND Contact.Name !='Neale'
                                              AND Contact.Name !='test'
                                              // unwanted professional records should be filtered out in CMS_Name formula already
                                              AND (RecordTypeID = '012G0000000qhDK' OR  Call_Type__c LIKE:pmpVar) 
                                              
                                              AND CMS_Name__c != 'x'
                                              AND CMS_Name__c != NULL
                                             ];
        
        for(case c: limitContactInteractions){
            setConMaster.add(c.contactID);        
        }
        System.debug('setConMaster Size  with int and camp =  ' + setConMaster.size());
        
    }
    public  void  TagContacts() { 
        MakeTagContacts();
        UpdateContacts();
    }
    
    Public void UpdateContacts(){
        List <Contact> tagContactsList = new List <Contact>();
        
        List<Contact> FindCurrentCMSContacts= [SELECT ID, CMS_Tag__c
                                               FROM Contact
                                               WHERE ID IN: SetConMaster];
        
        for(contact tc: FindCurrentCMSContacts) {
            contact c = new contact();
            c.Id=tc.Id;
            c.CMS_Tag__c = TRUE;
            tagContactsList.add(c);
        }
        System.debug(tagContactsList.size());
        IF (tagContactsList.size()>0){
            //Database.SaveResult[] srList = 
            Database.update(tagContactsList, false);
            
        }
    }
    
    /*************************************************** */
    public List <CMSTodoWrapper> getGenerateTagTotals() {
        
        
        // get current count ES dateTo. Limit SetCon
        list<CMSTodoWrapper> tagQueryTotals = new List <CMSTodoWrapper>();
        tagQueryTotals.clear();
        List<AggregateResult> tagAggregateResult = [SELECT recordTypeId  Qnames,  Count_Distinct(id) cmID//, Count(recordTypeId) DupeContactCNT ,
                                                    //Count_Distinct(recordTypeId) ContactCNT    Family__Contact_Record_Type__c           
                                                    FROM contact
                                                    WHERE CMS_Tag__c = True
                                                    GROUP BY rollup(recordTypeId)];
        
        String NewName ='';
        Integer NewTargC=0;
        Integer NewTargD=0;
        Integer NewTargU=0;
        Integer CurrentQ = tagAggregateResult.size()-1;
        for (AggregateResult arList : tagAggregateResult) { 
            If(String.valueOf(arList.get('Qnames'))==null){
                System.debug(currentQ + ' currentQ' + ' And c= ' + NewTargC + 'd= '+ NewTargD + 'u= '+ NewTargU );
                
                NewName ='Total'; 
                System.debug(currentQ + ' currentQ   ' + '  c= ' + NewTargC + '  d= '+ NewTargD + '  u= '+ NewTargU );
                
            }ELSE{
                If(String.valueOf(arList.get('Qnames'))=='012G0000000qhDMIAY'){
                    NewName='Adult';
                }Else{
                    NewName='Child'; 
                }
                
                
            } 
            
            tagQueryTotals.add(new CMSTodoWrapper(String.valueOf(NewName), String.valueOf(NewName),
                                                  String.valueOf(NewName), String.valueOf(NewName),String.valueOf(NewName), 
                                                  String.valueOf(NewName), String.valueOf(NewName),String.valueOf(NewName), String.valueOf(NewName),
                                                  Integer.valueOf(arList.get('cmID')), Integer.valueOf(NewTargD), Integer.valueOf(NewTargU), 
                                                  Integer.valueOf(NewTargC), Integer.valueOf(NewTargD), Integer.valueOf(NewTargU),
                                                  Integer.valueOf(NewTargC), Integer.valueOf(NewTargD), Integer.valueOf(NewTargU)));  
            
        }
        
        System.debug('tagTotal= ' + tagQueryTotals.size()); 
        return tagQueryTotals;
        
    }    
    
    public void GenerateUnAssigned() {
        GenerateUnAssigned();
    }
    public List<CMSTodoWrapper> getGenerateUnAss() {
        list<CMSTodoWrapper> UnAssQueryTotals = new List <CMSTodoWrapper>();
        List<campaign> UnAss = [SELECT Name, Start_Date_Time__c, ID, Project_or_Funder__c,
                                Owner.Name, CMSName__c, Presentation_Language__c, CMSQ__C, 
                                Number_of_Parent_Family_Evaluations__c, TotalCareGiversAttended__c, IsActive,
                                TotalChildrenAttended__c, 
                                Number_of_Minutes__c,  status
                                
                                
                                FROM campaign
                                WHERE Start_Date_Time__c >:PriorQuarterEnds AND Start_Date_Time__c <= :dateTo // 
                                
                                AND (NOT Status Like '%Cancelled%')
                                AND (NOT Name Like '%No Show%')
                                AND (NOT Name Like '%Postponed%')
                                AND (NOT Parent.status  Like '%Cancelled%')
                                AND (
                                    
                                    //is family support & no cms name & not childcare
                                    (Project_or_Funder__c INCLUDES ('%Family Support%')  AND CMSName__c = NULL ) 
                                    
                                    OR (Project_or_Funder__c INCLUDES ('%Family Support%') AND CMSName__c !=NULL AND campaign.status != 'Completed'  )
                                    // or is cmsName & not childcare and not family support
                                    OR  (CMSName__c != NULL AND CampaignRecordType__c !='Childcare' AND (NOT Project_or_Funder__c INCLUDES ('%Family Support%')))
                                    //or no cmsName & not childcare
                                    OR  (CMSName__c = NULL AND CampaignRecordType__c !='Childcare' AND Status != 'Completed' AND Project_or_Funder__c = '%Family Support%')
                                    OR (Project_or_Funder__c = Null )
                                    OR (CampaignRecordType__c ='Childcare' AND (NOT Project_or_Funder__c INCLUDES ('%Family Support%')))
                                    OR (CampaignRecordType__c ='Childcare' AND status != 'Completed')
                                    OR (CampaignRecordType__c ='Childcare' AND status != 'Data In Except Survey' )
                                   
                                )
                                
                                ORDER BY campaign.CampaignRecordType__c, campaign.status 
                               ];
        
        for (campaign arList : UnAss) { 
            String  NewName = 'txt';
            Integer Intfill = 1;
            Integer Target = 6;
            UnAssQueryTotals.add(new CMSTodoWrapper(String.valueOf(arList.Name),  String.valueOf(arList.Start_Date_Time__c.date()),(String.valueOf(arList.ID)), 
                                                    String.valueOf(arList.status),String.valueOf(arList.Project_or_Funder__c), String.valueOf(arList.CMSName__c), 
                                                    String.valueOf(arList.Presentation_Language__c),String.valueOf(arList.CMSQ__C), String.valueOf(arList.Owner.Name),
                                                    
                                                    Integer.valueOf(arList.TotalCareGiversAttended__c), Integer.valueOf(arList.TotalChildrenAttended__c), 
                                                    Integer.valueOf(arList.TotalCareGiversAttended__c),Integer.valueOf(arList.Number_of_Parent_Family_Evaluations__c), 
                                                    Integer.valueOf(arList.Number_of_Minutes__c), Integer.valueOf(Target),  
                                                    Integer.valueOf(Target),  Integer.valueOf(Target), Integer.valueOf(Target)));  
        }
        System.debug('UnAss= ' + UnAssQueryTotals.size()); 
        System.debug('UnAss= ' + UnAssQueryTotals);
        return UnAssQueryTotals;     
    }  
    
    
    /*******************************************************************


*******************************************************************/
    
    
    public with sharing class CMSTodoWrapper {
        public String ES {get; set;}
        public String cDte {get; set;}
        public String campLink {get; set;}
        public String cString1 {get; set;}
        public String cString2 {get; set;}
        public String cString3 {get; set;}
        public String cString4 {get; set;}
        public String cString5 {get; set;}
        public String cString6 {get; set;}
        
        public Integer Int1 {get; set;}
        public Integer Int2 {get; set;}
        public Integer INt3 {get; set;}
        public Integer Int4 {get; set;}
        public Integer Int5 {get; set;}
        public Integer Int6 {get; set;}
        
        public Integer TargetC {get; set;}
        public Integer TargetU {get; set;}
        public Integer TargetD {get; set;}
        
        public CMSTodoWrapper(String strName, String dte, String cLk, String txt1,  String txt2, String txt3, String txt4, String txt5, String txt6, 
                              Integer num1,Integer num2, Integer num3, Integer num4, Integer num5, Integer num6, 
                              Integer tarC, Integer tarD, Integer tarU ) {
                                  ES=strName;
                                  cDte=dte;
                                  campLink =cLk;
                                  cString1=txt1;
                                  cString2=txt2;
                                  cString3=txt3;
                                  cString4=txt4;
                                  cString5=txt5;
                                  cString6=txt6;
                                  Int1=num1;
                                  Int2 =num2;
                                  Int3 =num3;
                                  Int4 =num4;
                                  Int5 =num5;
                                  Int6=num6;
                                  TargetC=tarC;
                                  TargetD=tarD;
                                  TargetU=tarU;
                                  
                              }  
        
    }
}