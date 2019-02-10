public class HMG {
    
    /* 11/5/17 Novo
* Set of all who had events and who had interactions By household where they have under 6 yr old Count total interactions
* Who had single intracton but no events
* Who had multiple interaction no events
* Who had multiple Interactions & an event
* Who had evnts but no interactions

*/
    
    public Date dateFrom {get; set;}
    
    public Date dateTo {get; set;}
    
    // public Date priorMonthEnd;
    public Date Q1Ends;
    public Date Q2Ends; 
    public Date Q3Ends; 
    public Date Q4Ends; 
    public Date PriorQuarterEnds;
    
    public Integer FYBSelected;
    Public Integer FYBSecond;
    
    // SetConMaster collects all the contacts for current Quarter
    public Set<String> setConMaster = new Set<String>();
    public Set<String> setConEvents = new Set<String>();
    public Set<String> setConIaKids = new Set<String>();
    // public Set<String> setConMaste = new Set<String>();
    
    private String pmpVar ='PMP' + '%';
    
    
    
    
    public HMG(){
        setConMaster.clear();
        Date DefaultDateTo = date.newinstance(2017, 9, 30);
        Date DefaultDateFrom = date.newinstance(2017, 7, 1);
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
    
    // set dashboard values to zero in preparation for generation
    private void runBoard() {
        getHouseholdsWithIAKids();
        getHouseholdsWithContact();
        
    }
    
    // generate the dashboard
    private void generateBoard() {
        
        FYBSelected = (Integer.valueof(DateFrom.year()));
        FYBSecond = (Integer.valueof(DateFrom.year() + 1));
        Q1Ends = date.newInstance(FYBSelected, 9, 30 );
        Q2Ends = date.newInstance(FYBSelected, 12, 31 );
        Q3Ends = date.newInstance(FYBSecond, 3, 31 );
        Q4Ends = date.newInstance(FYBSecond, 6, 30 );
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
            } 
        }
        System.debug('priorquarterEnds= ' + PriorQuarterEnds);
        runBoard();
        
    }
    
    
    
    /**********************************************************************

Single Interaction, No Events
Multiple Interactions/ No Events
Multiple Interactions + Events
Events Only */
    // get households who have had interactions and child under 6
    public void  getHouseholdsWithIAKids(){
        System.debug('&&&&&  Enter getHouseholdsWithIAKids  ***************');
        List<Contact>Contacts =[SELECT ID, npo02__Household__c , Birthdate,Family__Age_in_Months__c
                                FROM Contact
                                WHERE Family__Age_in_Months__c <= 300
                                AND npo02__Household__c !=NULL
                                AND Birthdate!=NULL
                               ];
        for(Contact c: Contacts){
            Integer age = c.BirthDate.monthsBetween(dateTo);
            System.debug('######## agein months= ' + age);
            Boolean monthsBetween = false;
            
            if(age <72){
                //monthsBetween = c.BirthDate.monthsBetween(dateTo) <72){
                setConIaKids.add(c.npo02__Household__c); 
                
                
                
            }
            System.debug('setConIaKids= ' + setConIaKids);
        }

        //System.debug('setConIaKids= ' + setConIaKids);   
        // Get all household events vn without kids
        List<campaignMember> limitContactEvents =[SELECT contact.npo02__Household__c
                                                  FROM campaignMember
                                                  WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                  //And AgeMonthsAtCampaign__c>=0 AND AgeMonthsAtCampaign__c <=35
                                                  //AND AgeMonthsAtCampaign__c !=NULL
                                                  AND contact.name !='Neale'
                                                  //AND contact.name !='test'
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
                                                  AND contact.npo02__Household__c IN :setConIaKids
                                                  AND (NOT campaign.Name Like '%Childcare%')
                                                  AND (NOT campaign.Name Like '%Cancelled%')
                                                  AND (NOT campaign.Name Like '%No Show%')
                                                  AND (NOT campaign.Name Like '%Postponed%')];
        
        
        for(campaignMember cm: limitContactEvents){
            setConEvents.add(cm.contact.npo02__Household__c);
            System.debug('setConEvents= ' + setConEvents);
        }
    }
    
    private void  getHouseholdsWithContact(){
        Set<String> FindHouseholdsWithInts = new Set <String>();
        List<Case>ContactInteractions =[SELECT ContactID, Family__Household__c, AgeMonthCaseTime__c
                                        FROM case
                                        WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                        And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <=71
                                        AND  AgeMonthCaseTime__c !=NULL
                                        AND Call_Type__c != 'Left Message 1'
                                        AND Call_Type__c != 'Left Message 2'
                                        AND Call_Type__c != '# disconnected'
                                        AND Call_Type__c != 'Sent UTC Letter'
                                        AND Contact.LastName !='Neale'
                                        AND Contact.LastName !='test'
                                        AND  Family__Household__c !=NULL
                                        // Do we care if they are familiy interactions- or can they be on behalf of the household?
                                       // AND (RecordTypeID = '012G0000000qhDK' OR  Call_Type__c LIKE:pmpVar) 
                                        
                                       ];   
        System.debug( ' ********************** ContactInteractions collected=' + ContactInteractions);
        for (Case arList : ContactInteractions) { 
            //Add Id's to set
            setConMaster.add(arList.Family__Household__c);
        }

        
    }   
    
    // Interactions but no events
    public List <Wrap> getAggHouseholdCases(){
        
        System.debug('******Enter getAllHouseholdCases= ' + ' setConMaster '  + setConMaster);
        List<Wrap> queryTotals = new List <Wrap>();
        List<AggregateResult> AggContactInteractions =[SELECT Family__Household__c Ids, Count(ID) num
                                                       FROM case
                                                       WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                       And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <=71
                                                       AND AgeMonthCaseTime__c !=NULL
                                                       AND Call_Type__c != 'Left Message 1'
                                                       AND Call_Type__c != 'Left Message 2'
                                                       AND Call_Type__c != '# disconnected'
                                                       AND Call_Type__c != 'Sent UTC Letter'
                                                       AND Contact.LastName !='Neale'
                                                       AND Contact.LastName !='test'
                                                       AND  Family__Household__c !=NULL
                                                       // Do we care if they are familiy interactions- or can they be on behalf of the household?
                                                       AND  Family__Household__c  IN :setConMaster
                                                       And  (Not Family__Household__c IN:setConEvents)
                                                       
                                                       //Do we care if they are familiy interactions- or can they be on behalf of the household?
                                                       //(RecordTypeID = '012G0000000qhDK' OR  Call_Type__c LIKE:pmpVar) 
                                                       Group By Family__Household__c
                                                      ];  
        
        
          Integer o = 0;
        Integer m = 0;
        for (AggregateResult arList : AggContactInteractions) { 
          
            System.debug('************** enter Loop'  );
            System.debug('***************** arList' + arList.get('Ids'));
            
            String st =  String.ValueOf(arList.get('Ids'));
            Integer inCount = Integer.ValueOf(arList.get('num'));
            If (inCount > 1){
                m=m+1;
                 System.debug('***st=' + st + '  inCount= ' + inCount);
            QueryTotals.add(new Wrap( String.ValueOf(st), Integer.ValueOf(inCount), Integer.ValueOf(o), Integer.ValueOf(m)));
            System.debug('************** QueryTotals= '  + QueryTotals);
            }Else{
             
            }
  
           
        }
        
        System.debug(' QueryTotals= ' + QueryTotals);
        return QueryTotals;    
        
    }
    
    
        // Interactions but no events
    public List <Wrap> getAggHouseholdCases1(){
        
        System.debug('******Enter getAllHouseholdCases= ' + ' setConMaster '  + setConMaster);
        List<Wrap> queryTotals = new List <Wrap>();
        List<AggregateResult> AggContactInteractions =[SELECT Family__Household__c Ids, Count(ID) num
                                                       FROM case
                                                       WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                       And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <=71
                                                       AND AgeMonthCaseTime__c !=NULL
                                                       AND Call_Type__c != 'Left Message 1'
                                                       AND Call_Type__c != 'Left Message 2'
                                                       AND Call_Type__c != '# disconnected'
                                                       AND Call_Type__c != 'Sent UTC Letter'
                                                       AND Contact.LastName !='Neale'
                                                       AND Contact.LastName !='test'
                                                       AND  Family__Household__c !=NULL
                                                       // Do we care if they are familiy interactions- or can they be on behalf of the household?
                                                       AND  Family__Household__c  IN :setConMaster
                                                       And  (Not Family__Household__c IN:setConEvents)
                                                       
                                                       //Do we care if they are familiy interactions- or can they be on behalf of the household?
                                                       //(RecordTypeID = '012G0000000qhDK' OR  Call_Type__c LIKE:pmpVar) 
                                                       Group By Family__Household__c
                                                      ];  
        
        
          Integer o = 0;
        Integer m = 0;
        for (AggregateResult arList : AggContactInteractions) { 
          
            System.debug('************** enter Loop'  );
            System.debug('***************** arList' + arList.get('Ids'));
            
            String st =  String.ValueOf(arList.get('Ids'));
            Integer inCount = Integer.ValueOf(arList.get('num'));
            If (inCount < 2){
                m=m+1;
                 System.debug('***st=' + st + '  inCount= ' + inCount);
            QueryTotals.add(new Wrap( String.ValueOf(st), Integer.ValueOf(inCount), Integer.ValueOf(o), Integer.ValueOf(m)));
            System.debug('************** QueryTotals= '  + QueryTotals);
            }Else{
             
            }
  
           
        }
        
        System.debug(' QueryTotals= ' + QueryTotals);
        return QueryTotals;    
        
    }
    // Interactions And Events
    public List <Wrap> getAggHouseholdEventsCases(){
        
        System.debug('******Enter getAllHouseholdCases= ' + ' setConMaster '  + setConMaster);
        List<Wrap> queryTotals = new List <Wrap>();
        List<AggregateResult> AggContactInteractions =[SELECT Family__Household__c Ids, Count(ID) num, Count(Interaction_Unduplicated_Count__c) hh
                                                       FROM case
                                                       WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                       And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <=71
                                                       AND AgeMonthCaseTime__c !=NULL
                                                       AND Call_Type__c != 'Left Message 1'
                                                       AND Call_Type__c != 'Left Message 2'
                                                       AND Call_Type__c != '# disconnected'
                                                       AND Call_Type__c != 'Sent UTC Letter'
                                                       AND Contact.LastName !='Neale'
                                                       AND Contact.LastName !='test'
                                                       AND  Family__Household__c !=NULL
                                                       // Do we care if they are familiy interactions- or can they be on behalf of the household?
                                                       AND  Family__Household__c  IN :setConMaster
                                                       AND  Family__Household__c IN:setConEvents
                                                       
                                                       //Do we care if they are familiy interactions- or can they be on behalf of the household?
                                                       //(RecordTypeID = '012G0000000qhDK' OR  Call_Type__c LIKE:pmpVar) 
                                                       Group By Family__Household__c
                                                      ];  
        
         Integer o = 0;
        Integer m = 0;
        System.debug('******AggContactInteractions' + AggContactInteractions);
        for (AggregateResult arList : AggContactInteractions) { 
            
            System.debug('***************** arList' + arList.get('Ids'));
            
            String st =  String.ValueOf(arList.get('Ids'));
            Integer inCount = Integer.ValueOf(arList.get('num'));
            If (inCount > 1){
                m=m+1;
          
            System.debug('***st=' + st + '  inCount= ' + inCount);
            QueryTotals.add(new Wrap( String.ValueOf(st), Integer.ValueOf(inCount), Integer.ValueOf(o), Integer.ValueOf(m)));
            System.debug('************** QueryTotals= '  + QueryTotals);
                  }Else{
            }
            
            
            
        }
        
        System.debug(' QueryTotals= ' + QueryTotals);
        return QueryTotals;    
        
    }
    
        public List <Wrap> getAggHouseholdEventsCases1(){
        
        System.debug('******Enter getAllHouseholdCases= ' + ' setConMaster '  + setConMaster);
        List<Wrap> queryTotals = new List <Wrap>();
        List<AggregateResult> AggContactInteractions =[SELECT Family__Household__c Ids, Count(ID) num, Count(Interaction_Unduplicated_Count__c) hh
                                                       FROM case
                                                       WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
                                                       And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <=71
                                                       AND AgeMonthCaseTime__c !=NULL
                                                       AND Call_Type__c != 'Left Message 1'
                                                       AND Call_Type__c != 'Left Message 2'
                                                       AND Call_Type__c != '# disconnected'
                                                       AND Call_Type__c != 'Sent UTC Letter'
                                                       AND Contact.LastName !='Neale'
                                                       AND Contact.LastName !='test'
                                                       AND  Family__Household__c !=NULL
                                                       // Do we care if they are familiy interactions- or can they be on behalf of the household?
                                                       AND  Family__Household__c  IN :setConMaster
                                                       AND  Family__Household__c IN:setConEvents
                                                       
                                                       //Do we care if they are familiy interactions- or can they be on behalf of the household?
                                                       //(RecordTypeID = '012G0000000qhDK' OR  Call_Type__c LIKE:pmpVar) 
                                                       Group By Family__Household__c
                                                      ];  
        
         Integer o = 0;
        Integer m = 0;
        System.debug('******AggContactInteractions' + AggContactInteractions);
        for (AggregateResult arList : AggContactInteractions) { 
            
            System.debug('***************** arList' + arList.get('Ids'));
            
            String st =  String.ValueOf(arList.get('Ids'));
            Integer inCount = Integer.ValueOf(arList.get('num'));
            If (inCount < 2){
                m=m+1;
          
            System.debug('***st=' + st + '  inCount= ' + inCount);
            QueryTotals.add(new Wrap( String.ValueOf(st), Integer.ValueOf(inCount), Integer.ValueOf(o), Integer.ValueOf(m)));
            System.debug('************** QueryTotals= '  + QueryTotals);
                  }Else{
            }
            
            
            
        }
        
        System.debug(' QueryTotals= ' + QueryTotals);
        return QueryTotals;    
        
    }
    
    public List <Wrap> getAggHouseholdEvents(){
        
        System.debug('******Enter getAllHouseholdCases= ' + ' setConMaster '  + setConMaster);
        List<Wrap> queryTotals = new List <Wrap>();
        List<AggregateResult> AggContactEvents =[SELECT contact.npo02__Household__c Ids, Count(ID) num
                                                  FROM campaignMember
                                                  WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                  //And AgeMonthsAtCampaign__c>=0 AND AgeMonthsAtCampaign__c <=35
                                                  //AND AgeMonthsAtCampaign__c !=NULL
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
                                                  AND contact.npo02__Household__c IN:setConEvents
                                                 AND (NOT contact.npo02__Household__c  IN :setConMaster)
                                                  AND (NOT campaign.Name Like '%Childcare%')
                                                  AND (NOT campaign.Name Like '%Cancelled%')
                                                  AND (NOT campaign.Name Like '%No Show%')
                                                  AND (NOT campaign.Name Like '%Postponed%')
                                                    //Do we care if they are familiy interactions- or can they be on behalf of the household?
                                                       //(RecordTypeID = '012G0000000qhDK' OR  Call_Type__c LIKE:pmpVar) 
                                                       Group By contact.npo02__Household__c
                                                      ];  
        Integer o = 0;
        Integer m = 0;
        
        for (AggregateResult arList : AggContactEvents) { 
            
            System.debug('***************** arList' + arList.get('Ids'));
            
            String st =  String.ValueOf(arList.get('Ids'));
            Integer inCount = Integer.ValueOf(arList.get('num'));
            If (inCount > 1){
                m=m+1;
                 System.debug('***st=' + st + '  inCount= ' + inCount);
            QueryTotals.add(new Wrap( String.ValueOf(st), Integer.ValueOf(inCount), Integer.ValueOf(o), Integer.ValueOf(m)));
            System.debug('************** QueryTotals= '  + QueryTotals);
            }Else{
                
            }
            
            
            
           
        }
        
        System.debug(' QueryTotals= ' + QueryTotals);
        return QueryTotals;    
        
    }
    
     public List <Wrap> getAggHouseholdEvents1(){
        
        System.debug('******Enter getAllHouseholdCases= ' + ' setConMaster '  + setConMaster);
        List<Wrap> queryTotals = new List <Wrap>();
        List<AggregateResult> AggContactEvents =[SELECT contact.npo02__Household__c Ids, Count(ID) num
                                                  FROM campaignMember
                                                  WHERE Event_Date__c >= :dateFrom AND Event_Date__c <= :dateTo
                                                  //And AgeMonthsAtCampaign__c>=0 AND AgeMonthsAtCampaign__c <=35
                                                  //AND AgeMonthsAtCampaign__c !=NULL
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
                                                  AND contact.npo02__Household__c IN:setConEvents
                                                 AND (NOT contact.npo02__Household__c  IN :setConMaster)
                                                  AND (NOT campaign.Name Like '%Childcare%')
                                                  AND (NOT campaign.Name Like '%Cancelled%')
                                                  AND (NOT campaign.Name Like '%No Show%')
                                                  AND (NOT campaign.Name Like '%Postponed%')
                                                    //Do we care if they are familiy interactions- or can they be on behalf of the household?
                                                       //(RecordTypeID = '012G0000000qhDK' OR  Call_Type__c LIKE:pmpVar) 
                                                       Group By contact.npo02__Household__c
                                                      ];  
        Integer o = 0;
        Integer m = 0;
        
        for (AggregateResult arList : AggContactEvents) { 
            
            System.debug('***************** arList' + arList.get('Ids'));
            
            String st =  String.ValueOf(arList.get('Ids'));
            Integer inCount = Integer.ValueOf(arList.get('num'));
            If (inCount < 2){
                m=m+1;
            System.debug('***st=' + st + '  inCount= ' + inCount);
            QueryTotals.add(new Wrap( String.ValueOf(st), Integer.ValueOf(inCount), Integer.ValueOf(o), Integer.ValueOf(m)));
            System.debug('************** QueryTotals= '  + QueryTotals);
            }Else{
                
            }
            
            
            
      
        }
        
        System.debug(' QueryTotals= ' + QueryTotals);
        return QueryTotals;    
        
    }
    /*  
public List <Wrap> getAllHouseholdCases(){

System.debug('******Enter getAllHouseholdCases= ' + ' setConMaster '  + setConMaster);
//set<String> FindHouseholdsWithInts = new set <String>();
List<Case>ContactInteractions =[SELECT Contact.npo02__Household__c, Family__Household__c, AgeMonthCaseTime__c
FROM case
WHERE start_time__c >= :dateFrom AND start_time__c <= :dateTo
//And AgeMonthCaseTime__c>=0 AND AgeMonthCaseTime__c <=71
//AND AgeMonthCaseTime__c !=NULL
AND Call_Type__c != 'Left Message 1'
AND Call_Type__c != 'Left Message 2'
AND Call_Type__c != '# disconnected'
AND Call_Type__c != 'Sent UTC Letter'
AND Contact.LastName !='Neale'
//AND Contact.LastName !='test'
// Do we care if they are familiy interactions- or can they be on behalf of the household?
AND  Contact.npo02__Household__c  IN :setConMaster

//Do we care if they are familiy interactions- or can they be on behalf of the household?
//(RecordTypeID = '012G0000000qhDK' OR  Call_Type__c LIKE:pmpVar) 

];   


System.debug ('ContactInteractions= ' + ContactInteractions);
Map <String, List<Case>> casesMapList = new Map <String, List<Case>>();

Map<String, String> newKeysMap = new Map <String, String>();
Map<String, Integer> countMap = new Map <String, Integer>();
List<Wrap> QueryTotals = new List<Wrap>();
for (Case a : ContactInteractions) { 
Integer counter =1;


System.debug('******************* Counter= ' + Counter);
String key = string.ValueOf(a.Family__Household__c) ;
newKeysMap.put(key, key);
countMap.put(key, counter);

// If the key has already been added to the Map
if (casesMapList.containsKey(key)){
System.debug('found dupe key');

casesMapList.get(key).add(a);
countMap.put(key, counter= counter + 1);
System.debug('Counter = ' + counter + 'get(key).add(a)' + key);
System.debug('.   keyset= ' + casesMapList.keyset());
System.debug('.  casesMapList sfter dupe found values= ' + casesMapList.size());

} else {
casesMapList.put(key, new List<Case>{a});
countMap.put(key, counter);
System.debug('.  no dupe in countmap. countMap.size= ' + countMap.size());   
} 
}
String hh;
Integer n;
Set <String> keys =countMap.keySet();

for( Integer i : countMap.values()){
for (String c: keys) {
if (countMap.containsKey(c))
System.debug('adding to wrapper');     
QueryTotals.add(new Wrap(String.valueOf(c), Integer.valueOf(i)));
}
}
System.debug(' Query2Totals= ' + QueryTotals);
return QueryTotals;    

}





/*******************************************************************
* Wrapper 

*******************************************************************/
    
    
    public with sharing class Wrap {
        
        public String s {get; set;}
        public Integer i {get; set;}
        public Integer o {get; set;}
        public Integer m {get; set;}
        
        public Wrap(String str, Integer num, Integer one, Integer multi){
            s=str;
            i= num;
            o = one;
            m = multi;
        }
        
        
    }
}