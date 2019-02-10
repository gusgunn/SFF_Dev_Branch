public class PivotMakeTable {
    
    // make POC Table entires and pivot table entries ONE YEAR AT A Time
    public static void addToTable() {
        // list<WrapperPOCW> pWrapper = new List <WrapperPOCW>();
        
        String pmpVar ='PMP' + '%';
        String SFCD  ='%' + 'SFCD' + '%';
        Date ThisRowYear = date.newInstance(2013, 7, 1 );
        Date ThisRowYearEnds = date.newInstance(2014, 6, 30 );
        Map<ID, String> setConCurrent = new Map<ID, String>();
        List<POC__c> setMaster = new List<POC__c>(); 
        List <PivotTable__c> allRows = new List<PivotTable__c>();
        
        
        //Put All Mentors in the bucket
        List<Contact> limitContactInteractionsAll =[SELECT FirstName, LastName, ID
                                                    FROM contact
                                                   	WHERE RecordTypeID !='012G0000000qhDN'
                                                    AND dev__c = TRUE];
        //WHERE Mentor__c != true];
        //LIMIT 5];                                           
        
        
        for(contact c: limitContactInteractionsAll){
            setConCurrent.put(c.id, c.lastName + c.firstName);
        }
        
        System.debug('setConCurrent Size ' + setConCurrent.size());
        
        List <Case> cases = new List <Case>();  
        
        //Add Event or Interaction ID as string for next time
        List<case> limitContactInteractions =[SELECT ContactID, Start_Time__c, Origin, Call_Type__c, CaseNumber
                                              //add id as text
                                              FROM case
                                              Where ContactID IN : setConCurrent.keyset()
                                              AND start_time__c >= :ThisRowYear AND start_time__c <= :ThisRowYearEnds
                                              AND start_time__c !=NULL
                                              AND (NOT account.Name LIKE '%SFCD%')
                                              AND On_behalf_of__c =false
                                              AND Call_Type__c !=NULL
                                              AND ContactID !=NULL
                                              AND (RecordTypeID = '012G0000000qhDK' OR  Call_Type__c LIKE:pmpVar)
                                              ORDER By Start_Time__c ASC];
        for(case x: limitContactInteractions){
            POC__c recordP = new POC__c();
            recordP.person__c = x.ContactID;
            recordP.POC_Date__c = x.Start_Time__c.date();
            recordP.POC_Type__c = x.Origin;
            recordP.POC_Detail__c = x.Call_Type__c.left(8);
            recordP.CMS_FYB__c = ThisRowYear;
            recordP.pointer__c = x.CaseNumber;
            setMaster.add(recordP);
            System.debug('setMaster Size after cases ' + setMaster.size());
        }
        
        List<campaignMember> limitContactEvents =[SELECT contactID, campaign.type, campaign.Start_Date_Time__c, campaign.Name, CampaignId
                                                  FROM campaignMember
                                                  WHERE Event_Date__c >= :ThisRowYear AND Event_Date__c <= :ThisRowYearEnds
                                                  AND  Event_Date__c !=NULL
                                                  AND ContactID IN : setConCurrent.keyset()
                                                  AND (NOT campaign.Name Like '%Childcare%')
                                                  AND (NOT campaign.Name Like '%Cancelled%')
                                                  AND (NOT campaign.Name Like '%No Show%')
                                                  AND (NOT campaign.Name Like '%Postponed%')
                                                  AND 	No_Show__c = False
                                                  //Status = 'Family Attendee'
                                                  ORDER By campaign.Start_Date_Time__c ASC];                                          
        
        for(campaignMember cm: limitContactEvents){
            POC__c recordE = new POC__c();
            recordE.person__c = cm.ContactID;
            recordE.POC_Date__c = cm.campaign.Start_Date_Time__c.date();
            recordE.POC_Type__c = cm.campaign.type;
            recordE.POC_Detail__c = cm.campaign.name.left(8);
            recordE.CMS_FYB__c = ThisRowYear;
            recordE.pointer__c = cm.CampaignId;
            setMaster.add(recordE);
            System.debug('setMaster Size after Events ' + setMaster.size());
        }
        
        if(setMaster.size() > 0){
            Insert setMaster;
        }Else{
            System.debug('setMaster is empty');
        }
        
        
    }
    //Execute Anon
    //PivotMakeTable.addToTable();
    //PivotMakeRows.addPivotRows();
    /*List<poc__c> p =[ SELECT Name
FROM POC__C 
WHERE name !=null];
delete p;*/
    
}