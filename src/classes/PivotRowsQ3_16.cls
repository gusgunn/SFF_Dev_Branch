public class PivotRowsQ3_16 {
  
   //Integer yy, Integer MM, Integer DD, Integer eYY,  Integer eMM, Integer eDD, integer Q 
    public static void addPivotRows() {
        
        String pmpVar ='PMP' + '%';
        Date ThisRowYear = date.newInstance(2015, 7, 1 );
        Date ThisRowYearEnds = date.newInstance(2016, 6, 30 );
        Map<ID, String> setConCurrent = new Map<ID, String>();
        List<POC__c> setMaster = new List<POC__c>(); 
        Set<String> oID = new SET <String>();
        List <PivotTable__c> allRows = new List<PivotTable__c>();
        //Add datae PAram later
        //Date qBegins = Date.newInstance(yy, mm, dd);
        //Date qEnds = Date.newInstance(eYy, eMm, eDd);
        //System.debug('qEnds' + qEnds + 'qBegins' + qBegins);
        
        //Put All POCS in the bucket
        System.debug('setConCurrent Size ' + setConCurrent.size());
        
        //Change to make one row per quarter
        List<POC__c> OrderSetMaster = [SELECT person__c, POC_Date__c,  POC_Type__c, POC_Detail__c, CMS_FYB__c
                                       FROM POC__c 
                                       WHERE POC_Date__c >= 2016-01-01 AND POC_Date__c <= 2016-03-31
                                       
                                       ORDER BY POC_Date__c ASC ];
        for(POC__c p:OrderSetMaster){
            oID.add(p.person__c);
        }
         List<Contact> limitContactInteractionsAll =[SELECT FirstName, LastName, ID
                                                    FROM contact
                                                    WHERE dev__c = TRUE
                                                    AND ID IN: oID ];
        
        //WHERE Mentor__c = True];
        for(contact c: limitContactInteractionsAll){
            setConCurrent.put(c.id, c.lastName + c.firstName);
        }
          
        String conVert ='';
        
        List<PivotTable__c> pivotRows = new List <PivotTable__c>();
         List<PivotTable__c> pivotRowUpdates = new List <PivotTable__c>();
        // For every contact in currentSet, add person to a row in PivotTable
        for (ID con: setConCurrent.keyset()){
            Integer iter = 1;
            PivotTable__c wp = new PivotTable__c(); 
            conVert = con;
            wp.personId__c = conVert; 
            wp.Person__c = con;
            wp.year_begins__c = ThisRowYear;
            wp.POC__c = 3;
            
            system.debug('person= ' + wp.person__c);
            
            //need to order setMaster asc
            for(POC__c s: OrderSetMaster){
                //while (Iter <=2) {
                if(wp.person__c !=NULL && wp.person__c == s.person__c){
                    
                    //Integer POCNumber;
                    STRING rowPOCtype = 'type' + iter + '__c' ;
                    
                    Integer POCYear = s.POC_Date__c.year();
                    Integer POCMonth = s.POC_Date__c.Month();
                    STRING POCDATE = String.valueOf(POCYear) + '/' + String.valueOf(POCMonth) ;
                    
                    wp.put(rowPOCtype, s.POC_Type__c + ' - '  + s.POC_Detail__c + ' - ' +  POCDATE);
                    wp.Q_Total__c = iter;
                    system.debug(rowPOCtype);
                    iter +=1;
                }
                                
            }
            
            pivotRows.add(wp);
            System.debug('row' + pivotRows);
            system.debug('iter' + iter); 
        }
        if (pivotRows.size() >0){
        Insert pivotRows;
        }ELSE
            System.debug('No pivotRows');
                
    }
}