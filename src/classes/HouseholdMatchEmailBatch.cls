global class HouseholdMatchEmailBatch implements 
Database.Batchable<sObject>, Database.Stateful {
    // 6/6/17 Lightworks
    // Batch to find matches based on email OR MergeSwitch__c for semi-manual sweep into Selected list
    
    // instance member to retain state across transactions
    global Integer recordsProcessed = 0;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([SELECT Id, npo02__Household__r.ID, Name, Account.name, Email 
                                         FROM Contact WHERE Email !=NULL 
                                         AND ( MergeSwitch__c = True OR CreatedBy.name = 'ActOn' )
                                         AND InHHMergeTable__c= False 
                                         AND OrgName__c ='One-to-One Individual' LIMIT 2000] );
        
    }
    
    global void execute(Database.BatchableContext bc, List<Contact> scope){
        // process each batch of records
        Map<ID, Contact> hhKeys  = new Map <ID, Contact>();
        Map<String, Contact> masterKeys  = new Map <String, Contact>();
        Map<String, ID> createKeys   = new Map <String, ID>();
        List<MergeRecord__c> addToMergeTable = new List <MergeRecord__c>();
        List<npo02__Household__c> updateHouseholds = new List <npo02__Household__c>();
        
        System.Debug(scope.size() +'  =Scope ');
        for (Contact c: scope){
            if(c.Name == c.Account.Name){
                hhKeys.put(c.npo02__Household__r.ID, c);
                masterKeys.put(c.Email, c );
            }
            
        }
        List <Contact> findMatches = [ SELECT Id, Email, FirstName, LastName, npo02__Household__r.ID, HomePhone, 
                                      MailingPostalCode, Family__Primary_Language__c, OrgName__c
                                      FROM Contact
                                      WHERE Email in: masterKeys.keyset()
                                      AND npo02__Household__r.ID NOT in: hhKeys.keyset()
                                      AND MergeSwitch__c = False
                                      And OrgName__c = 'One-to-One Individual'
									  AND InHHMergeTable__c = False
                                      LIMIT 190
                                     ];
        
        for(Contact m: findMatches ){
            if(m.npo02__Household__r.ID!=Null){
                createKeys.put(m.email, m.npo02__Household__c);
                System.Debug(createKeys + 'createKeys');
                // createKeys.put(m.email, m);
            }
        }
        Map<String, String> DedupeMatches = new Map<String,String>();
        Set<String> keys = createKeys.keySet();
        Set<ID> MasterToBeHH = new Set<ID>();
        
        // key = unique emails
        // Dedupe HH
        For (String emailKey: keys) { 
            String hhKey = String.valueOF(createKeys.get(emailKey ));
            DedupeMatches.put(hhKey, emailKey);   
            MasterToBeHH.add(hhKey);
            System.debug(MasterToBeHH + 'MasterToBeHH');
        }
        
        List <Contact> ListMatches = new List <Contact> ();
        //masterKeys = Master email key
        for(Contact aR: masterKeys.values()) {
            
            for(ID E: MasterToBeHH) {
                //for(Contact E: createKeys.values()) {
                // If they arent in same household already, and email matches
                System.debug(E + 'E');
                if( (E != NULL && aR.npo02__Household__r.ID != E) && (aR.email != Null && aR.email == String.valueOF(DedupeMatches.get(e )))) {
                    System.Debug( String.valueOF(DedupeMatches.get(e )) + ' String.valueOF(DedupeMatches.get(e ))');
                    MergeRecord__c NewMergeRecord  = new MergeRecord__c();
                    //Make list of HH to merge, and their matched HH, to be inserted into Mergetable
                    // MergeRecord__c NewMergeRecord  = new MergeRecord__c();
                    
                    //Not created by acton is master
                    NewMergeRecord.MasterHH__c = E;
                    System.debug(NewMergeRecord.MasterHH__c + ' MasterHH');
                    NewMergeRecord.HHtoMerge__c = aR.npo02__Household__r.ID; 
                    addToMergeTable.add(NewMergeRecord);
                }
                
            }
            recordsProcessed = recordsProcessed + 1;
            
            
        }
        
        
        
        
        if (addToMergeTable.size()>0){
            Try{
                insert addToMergeTable;
                System.debug(addToMergeTable.size() + ' Dupe Household added to merge table' + addToMergeTable);
            } catch (DmlException ex) {
                System.debug(ex.getMessage());
            }
        } ELSE{
            //No Addl Contacts
        }
        Set <ID> toMergeSet = new Set<ID>();
        List<npo02__Household__c> DupeHouseholdUpdates = new List<npo02__Household__c>();
        List<npo02__Household__c> HouseholdUpdates = new List<npo02__Household__c>();
        // Query Merge Table for Master && toMerge
        // Update HH Fields with best options
        List <MergeRecord__c> HouseholdDetails = [SELECT MasterHH__c, MasterHH__r.ID, MasterHH__r.npo02__MailingPostalCode__c,
                                                  MasterHH__r.npo02__HouseholdEmail__c, MasterHH__r.npo02__HouseholdPhone__c , 
                                                  MasterHH__r.Mailing_Language__c , MasterHH__r.Postal_Mailing_Opt_Out__c,
                                                  MasterHH__r.npo02__Informal_Greeting__c, MasterHH__r.npo02__Formal_Greeting__c, 
                                                  MasterHH__r.Do_not_include_in_Annual_Report__c, MasterHH__r.First_Intake__c, MasterHH__r.Last_Intake__c,
                                                  
                                                  HHtoMerge__c, HHtoMerge__r.ID,  HHtoMerge__r.npo02__MailingPostalCode__c, 
                                                  HHtoMerge__r.npo02__HouseholdEmail__c, HHtoMerge__r.npo02__HouseholdPhone__c , 
                                                  HHtoMerge__r.Mailing_Language__c , HHtoMerge__r.Postal_Mailing_Opt_Out__c,
                                                  HHtoMerge__r.npo02__Informal_Greeting__c, HHtoMerge__r.npo02__Formal_Greeting__c, 
                                                  HHtoMerge__r.Do_not_include_in_Annual_Report__c, HHtoMerge__r.Last_Intake__c, HHtoMerge__r.First_Intake__c
                                                  FROM  MergeRecord__c
                                                  WHERE mergeStatus__c = false
                                                 ];
        
        System.debug(HouseholdDetails.size() + ' =HouseholdDetails size');
        List<MergeRecord__c> mergeStat = new  List<MergeRecord__c>();
        for(MergeRecord__c h : HouseholdDetails){
            if(h.HHtoMerge__r.ID != Null && h.MasterHH__r.ID !=Null){
                // one for Master HH updates & one for dup HH tag only 
                // always tag both master & dupe HH records & MergeTable record
                npo02__Household__c mergeHouseholds = new npo02__Household__c();
                npo02__Household__c dupeHouseholdsTag = new npo02__Household__c();
                
                dupeHouseholdsTag.ID = h.HHtoMerge__r.ID;
                
                toMergeSet.Add(dupeHouseholdsTag.ID);
                
                mergeHouseholds.ID = h.MasterHH__r.ID;
                mergeHouseholds.inMergeTable__c = True;
                
                h.mergeStatus__c = True;
                mergeStat.add(h);
                
                Integer mergeNotEmpty = 0;
                
                if((h.MasterHH__r.npo02__MailingPostalCode__c == NULL ||h.MasterHH__r.npo02__MailingPostalCode__c =='Declined' || h.MasterHH__r.npo02__MailingPostalCode__c == 'Unknown')
                   && (h.HHtoMerge__r.npo02__MailingPostalCode__c !=NULL || h.HHtoMerge__r.npo02__MailingPostalCode__c !='Declined' || h.HHtoMerge__r.npo02__MailingPostalCode__c != 'Unknown')){    
                       mergeHouseholds.npo02__MailingPostalCode__c = h.HHtoMerge__r.npo02__MailingPostalCode__c;
                       mergeNotEmpty ++;
                   }
                if((h.MasterHH__r.npo02__HouseholdEmail__c == NULL ||h.MasterHH__r.npo02__HouseholdEmail__c =='Declined' || h.MasterHH__r.npo02__HouseholdEmail__c == 'Unknown')
                   && (h.HHtoMerge__r.npo02__HouseholdEmail__c !=NULL || h.HHtoMerge__r.npo02__HouseholdEmail__c !='Declined' || h.HHtoMerge__r.npo02__HouseholdEmail__c != 'Unknown')){
                       mergeHouseholds.npo02__HouseholdEmail__c = h.HHtoMerge__r.npo02__HouseholdEmail__c; 
                       mergeNotEmpty ++;
                   }
                if((h.MasterHH__r.npo02__HouseholdPhone__c == NULL ||h.MasterHH__r.npo02__HouseholdPhone__c =='Declined' || h.MasterHH__r.npo02__HouseholdPhone__c == 'Unknown')
                   && (h.HHtoMerge__r.npo02__HouseholdPhone__c !=NULL || h.HHtoMerge__r.npo02__HouseholdPhone__c !='Declined' || h.HHtoMerge__r.npo02__HouseholdPhone__c != 'Unknown')){ 
                       mergeHouseholds.npo02__HouseholdPhone__c = h.HHtoMerge__r.npo02__HouseholdPhone__c;
                       mergeNotEmpty = mergeNotEmpty+1;
                   }
                if((h.MasterHH__r.Mailing_Language__c == NULL ||h.MasterHH__r.Mailing_Language__c =='Declined' || h.MasterHH__r.Mailing_Language__c == 'Unknown')
                   && (h.HHtoMerge__r.Mailing_Language__c !=NULL || h.HHtoMerge__r.Mailing_Language__c !='Declined' || h.HHtoMerge__r.Mailing_Language__c != 'Unknown')){
                       mergeHouseholds.Mailing_Language__c  = h.HHtoMerge__r.Mailing_Language__c;
                       mergeNotEmpty ++;
                   }
                if((h.MasterHH__r.Postal_Mailing_Opt_Out__c == False )
                   && (h.HHtoMerge__r.Postal_Mailing_Opt_Out__c =True ))  {
                       mergeHouseholds.Postal_Mailing_Opt_Out__c = h.HHtoMerge__r.Postal_Mailing_Opt_Out__c;
                       mergeNotEmpty ++;
                   }
                if((h.MasterHH__r.npo02__Informal_Greeting__c == NULL ||h.MasterHH__r.npo02__Informal_Greeting__c =='Declined' || h.MasterHH__r.npo02__Informal_Greeting__c == 'Unknown')
                   && (h.HHtoMerge__r.npo02__Informal_Greeting__c !=NULL || h.HHtoMerge__r.npo02__Informal_Greeting__c !='Declined' || h.HHtoMerge__r.npo02__Informal_Greeting__c != 'Unknown')){  
                       mergeHouseholds.npo02__Informal_Greeting__c = h.HHtoMerge__r.npo02__Informal_Greeting__c;
                       mergeNotEmpty ++;
                   }
                if((h.MasterHH__r.npo02__Formal_Greeting__c == NULL ||h.MasterHH__r.npo02__Formal_Greeting__c =='Declined' || h.MasterHH__r.npo02__Formal_Greeting__c == 'Unknown')
                   && (h.HHtoMerge__r.npo02__Formal_Greeting__c !=NULL || h.HHtoMerge__r.npo02__Formal_Greeting__c !='Declined' || h.HHtoMerge__r.npo02__Formal_Greeting__c != 'Unknown')){
                       mergeHouseholds.npo02__Formal_Greeting__c = h.HHtoMerge__r.npo02__Formal_Greeting__c;
                       mergeNotEmpty ++;
                   }
                if((h.MasterHH__r.Do_not_include_in_Annual_Report__c == False )
                   && (h.HHtoMerge__r.Do_not_include_in_Annual_Report__c ==True)){
                       mergeHouseholds.Do_not_include_in_Annual_Report__c = h.HHtoMerge__r.Do_not_include_in_Annual_Report__c;
                       mergeNotEmpty ++;
                   }
                if((h.MasterHH__r.First_Intake__c == NULL )
                   && (h.HHtoMerge__r.First_Intake__c !=NULL)){
                       mergeHouseholds.First_Intake__c = h.HHtoMerge__r.First_Intake__c;
                       mergeNotEmpty ++;
                   }
                if((h.MasterHH__r.First_Intake__c != NULL 
                    && h.HHtoMerge__r.First_Intake__c !=NULL) && (h.MasterHH__r.First_Intake__c>h.HHtoMerge__r.First_Intake__c )){
                        mergeHouseholds.First_Intake__c = h.HHtoMerge__r.First_Intake__c;
                        mergeNotEmpty ++;
                    }
                if((h.MasterHH__r.Last_Intake__c == NULL )
                   && (h.HHtoMerge__r.Last_Intake__c !=NULL)){
                       mergeHouseholds.Last_Intake__c = h.HHtoMerge__r.Last_Intake__c;
                       mergeNotEmpty ++;
                   }
                if((h.MasterHH__r.Last_Intake__c != NULL 
                    && h.HHtoMerge__r.Last_Intake__c !=NULL) && (h.MasterHH__r.Last_Intake__c< h.HHtoMerge__r.Last_Intake__c )){
                        mergeHouseholds.Last_Intake__c = h.HHtoMerge__r.Last_Intake__c;
                        mergeNotEmpty ++;
                    }
                System.debug('mergeNotEmpty ' + mergeNotEmpty);
                
                
                System.Debug(mergeHouseholds + 'mergeHouseholds' );
                HouseholdUpdates.add(mergeHouseholds);
            }
            System.debug(HouseholdUpdates.size() +'  households to update');
            if (HouseholdUpdates.size()>0){
                Try{
                    System.debug(HouseholdUpdates.size() + ' households Status to update');
                    update HouseholdUpdates;
                    
                    
                } catch (DmlException exz) {
                    System.debug(exz.getMessage());
                }
            } 
            
            System.debug(mergeStat.size() +'  mergeStat to update');
            if (mergeStat.size()>0){
                Try{
                    System.debug(mergeStat.size() + ' MergeStats to update');
                    update mergeStat;
                    
                } catch (DmlException exz) {
                    System.debug(exz.getMessage());
                }
            } ELSE{
                //No Addl Contacts
            }
            for (ID x : toMergeSet){
                npo02__Household__c dupeHouseholdsList = new npo02__Household__c();
                dupeHouseholdsList.ID = x;
                dupeHouseholdsList.inMergeTable__c = True;
                dupeHouseholdUpdates.add(dupeHouseholdsList);
            
            }
            System.debug(dupeHouseholdUpdates.size() +'  dupeHouseholdUpdates to update');
            if (dupeHouseholdUpdates.size()>0){
                Try{
                    System.debug(dupeHouseholdUpdates.size() + ' dupeHouseholdUpdates Status to update');
                    update dupeHouseholdUpdates;
                    
                    
                } catch (DmlException exz) {
                    System.debug(exz.getMessage());
                }
            } 
            
            
        }
        
    } 
    global void finish(Database.BatchableContext bc){
        System.debug(recordsProcessed + ' records processed. Shazam!');
        AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors, JobItemsProcessed,
                          TotalJobItems, CreatedBy.Email
                          from AsyncApexJob where Id =:BC.getJobId()];
        
        
        
        // Send an email to the Apex job's submitter notifying of job completion.  
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {a.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
        mail.setSubject('Match Merge Batch ' + a.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +
                              ' batches with '+ a.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
    
}