public class CPRC_Zip_Language {
    
    /*******************************************************
4-26-18
f4 -SFCD - copy to split out =zips SaveAs CPRC Zip
GG


*******************************************************/
    
    
    public Date dateFrom {get; set;}
    public Date dateTo {get; set;}
    private Set<String> setConMasterCG = new Set<String>();
    private String pmpVar ='PMP' + '%';
    
    public CPRC_Zip_Language(){
        
        
        date DefaultDateTo = system.today();
        
        date defaultDateFrom = system.today().addDays(-365);
        dateTo = defaultDateTo;
        dateFrom = defaultDateFrom;
        
    }
    
    public PageReference startGenerateBoard() {
        
        
        if (dateFrom != null && dateTo != null) {
            if (dateTo >= dateFrom) {
                
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
        
        InitializeBoard();
        TagContacts();
    }
    private void InitializeBoard() { 
        setConMasterCG.clear();
        
    }
    
    private void TagContacts() {   
        
        
        List<campaignMember> limitCurContactEvents =[SELECT contactID,  Status
                                                     FROM campaignMember
                                                     WHERE campaign.Start_Date_Time__c > :dateFrom AND campaign.Start_Date_Time__c <= :dateTo
                                                     
                                                     AND contact.name !='Neale'
                                                     AND contact.name !='test'
                                                     AND No_Show__c = false
                                                     AND Status = 'Family Attendee'
                                                     
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
                                                          OR campaign.Type = 'Screening - Oral'
                                                          OR campaign.Type LIKE '%Playgroup%')
                                                     AND (NOT campaign.Name Like '%Childcare%')
                                                     AND (NOT campaign.Name Like '%Cancelled%')
                                                     AND (NOT campaign.Name Like '%No Show%')
                                                     AND (NOT campaign.Name Like '%Postponed%')
                                                    ];
        
        for(campaignMember cm: limitCurContactEvents){
            setConMasterCG.add(cm.contactID);
        }
        
        
        
        List<case> limitContactInteractions =[SELECT contactID, contact.recordTypeID, Family__Household__c, contact.npo02__Household__c, Family__Child__r.LastName
                                              FROM case
                                              WHERE start_time__c > :dateFrom AND start_time__c <= :dateTo
                                              AND Call_Type__c != 'Left Message 1'
                                              AND Call_Type__c != 'Left Message 2'
                                              AND Call_Type__c != '# disconnected'
                                              AND Call_Type__c != 'No answering machine'
                                              AND Call_Type__c != 'Sent UTC Letter'     
                                              AND Family__Child__r.LastName !='Neale'
                                              AND Family__Child__r.LastName !='test'
                                              AND contact.Lastname !='Neale'
                                              AND contact.Lastname !='test'
                                              AND (RecordTypeID = '012G0000000qhDK') ];
        for(case c: limitContactInteractions){
            setConMasterCG.add(c.contactID);
            
        }
        System.debug('setConMastergg Size =  ' + setConMasterCG.size());
    }
    
    
    /***********************************************************/
    
    
    public List<arWrapperX> getGenerateZipAll() { 
        list<arWrapperX> zipQueryTotals = new List <arWrapperX>();
        List<AggregateResult> ZipAggregateResult = 
            [select  Family__Primary_Language__c aa, Count_Distinct (ID) bb                     
             From Contact
             WHERE id IN: setconMasterCG
             AND   (  Family__Primary_Language__c = 'Spanish' 
                    OR Family__Primary_Language__c = 'Cantonese' 
                    OR Family__Primary_Language__c = 'Mandarin'
                    OR MailingPostalCode = '94110' 
                    OR MailingPostalCode = '94124'
                    OR MailingPostalCode = '94108'
                    OR MailingPostalCode = '94103'
                    OR MailingPostalCode = '94102'
                    OR MailingPostalCode = '94134'
                    OR MailingPostalCode = '94115' )  
             group by rollup (Family__Primary_Language__c)];
        
        String NewName= '';
        for (AggregateResult arList : ZipAggregateResult) { 
            
            If(String.valueOf(arList.get('aa'))==NULL){
                NewName ='Total'; 
            } ELSE{
                NewName = (String.valueOf(arList.get('aa')));  
                
            }
            zipQueryTotals.add(new arWrapperX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));    
        }
        return zipQueryTotals;
        
    }        
    
    
    public List<arWrapperX> getGenerateZipLow() { 
        list<arWrapperX> zipQueryTotals = new List <arWrapperX>();
        List<AggregateResult> ZipAggregateResult = 
            [select  Family__Primary_Language__c aa, Count_Distinct (ID) bb                     
             From Contact
             WHERE id IN: setconMasterCG
             AND   (NOT Family__Primary_Language__c Like'Spanish') 
             AND  (NOT Family__Primary_Language__c Like'Cantonese' )
             AND (NOT Family__Primary_Language__c LIKE 'Mandarin')
             AND ( MailingPostalCode = '94110' 
             OR MailingPostalCode = '94124'
             OR MailingPostalCode = '94108'
             OR MailingPostalCode = '94103'
             OR MailingPostalCode = '94102'
             OR MailingPostalCode = '94134'
             OR MailingPostalCode = '94115' )  
             group by rollup (Family__Primary_Language__c)];
        
        String NewName= '';
        for (AggregateResult arList : ZipAggregateResult) { 
            
            If(String.valueOf(arList.get('aa'))==NULL){
                NewName ='Total'; 
            } ELSE{
                NewName = (String.valueOf(arList.get('aa')));  
                
            }
            zipQueryTotals.add(new arWrapperX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));    
        }
        return zipQueryTotals;
        
    }        
    
    
    // get low income Zip
    
    public List<arWrapperX> getGenerateZipSpanish() { 
        list<arWrapperX> zipQueryTotals = new List <arWrapperX>();
        List<AggregateResult> ZipAggregateResult = 
            [select  Family__Primary_Language__c aa, Count_Distinct (ID) bb                     
             From Contact
             WHERE id IN: setconMasterCG
             AND  Family__Primary_Language__c = 'Spanish' 
             
             group by rollup (Family__Primary_Language__c)];
        
        String NewName= '';
        for (AggregateResult arList : ZipAggregateResult) { 
            
            If(String.valueOf(arList.get('aa'))==NULL){
                NewName ='Total'; 
            } ELSE{
                NewName = (String.valueOf(arList.get('aa')));  
                
            }
            zipQueryTotals.add(new arWrapperX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));    
        }
        return zipQueryTotals;
        
    }        
    
    
    public List<arWrapperX> getGenerateZipChinese() { 
        list<arWrapperX> zipQueryTotals = new List <arWrapperX>();
        List<AggregateResult> ZipAggregateResult = 
            [select  Family__Primary_Language__c aa, Count_Distinct (ID) bb                     
             From Contact
             WHERE id IN: setconMasterCG
             AND  (Family__Primary_Language__c = 'Cantonese' OR Family__Primary_Language__c = 'Mandarin')
          
             group by rollup (Family__Primary_Language__c)];
        
        String NewName= '';
        for (AggregateResult arList : ZipAggregateResult) { 
            
            If(String.valueOf(arList.get('aa'))==NULL){
                NewName ='Total'; 
            } ELSE{
                NewName = (String.valueOf(arList.get('aa')));  
                
            }
            zipQueryTotals.add(new arWrapperX(String.valueOf(NewName), (Integer.valueOf(arList.get('bb')))));    
        }
        return zipQueryTotals;
        
    }        
    
    
    
    
    /*******************************************************************
* Wrapper 
*******************************************************************/
    
    
    public class arWrapperX {
        
        public String a1 {get; set;}
        public Integer b1 {get; set;}
        
        public arWrapperX(String str, Integer num){
            a1 =str;
            b1 = num;
            
            
            
        }
    }
}