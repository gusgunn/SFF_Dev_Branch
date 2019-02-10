global class UpdateTicketHoldersBatch implements Database.Batchable<sObject>{

	global Database.QueryLocator start(Database.BatchableContext BC){
		
		DateTime PastDateTime = datetime.now().addDays(-14);
        
        String Query = 'SELECT Id, Is_ticket_holder_in_your_household__c, Name, sbxe1__sbx_FirstName__c, sbxe1__sbx_LastName__c,' + 
                       ' sbxe1__sbx_FullName__c, sbxe1__sbx_TicketPurchaserContact__c, sbxe1__sbx_TicketPurchaserContact__r.firstname, sbxe1__sbx_TicketPurchaserContact__r.lastname, sbxe1__sbx_Campaign__c, sbxe1__sbx_TicketHolderContact__c,' +
                       ' sbxe1__sbx_TicketType__c, sbxe1__sbx_Email__c, sbxe1__sbx_TicketPurchaserContact__r.npo02__Household__c from sbxe1__Ticket__c where CreatedDate > :PastDateTime';
        System.debug('qXX'+Query);
        return Database.getQueryLocator(Query);
    }
    
    global void execute(Database.BatchableContext BC,list<sbxe1__Ticket__c> scope){
    	
    	Boolean flag=false;
	    map<Id,list<Contact>> householdtocontactsmap= new Map<Id,list<Contact>>();
	    list<Contact> lstTicketPurchaser = new list<Contact>();
	    list<Contact> lstcontacts = new list<Contact>();
	    list<Contact> lstPotentialTicketHolder = new list<Contact>();  
	    list<Contact> lstTicketHolder = new list<Contact>();
	    list<npo02__Household__c> lstHouseholds = new list<npo02__Household__c>();
	    list<CampaignMember> lstcampaignmember = new list<CampaignMember>();
	    list<String> lstIds = new list<String>();
	    map<Id,Id> mapTicketIdandTicketPurchaserId = new map<Id,Id>(); 
	    map<Id,list<Contact>> mapTicketIdandTicketHolder = new map<Id,list<Contact>>();
	    map<Id,Id> mapTicketIdandHouseholder = new map<Id,Id>();
	    list<Contact> lstContactToInsert = new list<Contact>();
	    list<String> lstTicketHolderEmails = new list<String>();
	    list<Contact> lstAllContacts = [SELECT Id, Email, FirstName, LastName FROM Contact LIMIT 50000];
	    map<String, Contact> mapAllContacts = new map<String, Contact>();
	    
	    for(sbxe1__Ticket__c everyticket:scope){
			mapTicketIdandTicketPurchaserId.put(everyticket.sbxe1__sbx_TicketPurchaserContact__c,everyticket.Id);
			lstTicketHolderEmails.add(everyticket.sbxe1__sbx_Email__c);
		}
		
		for(Contact c:lstAllContacts){
			mapAllContacts.put(c.email+c.firstname+c.lastname,c);
		}
	        
		lstTicketPurchaser = [select Id, npo02__Household__c from Contact where Id IN:mapTicketIdandTicketPurchaserId.keyset()];
		system.debug('##lstTicketPurchaser.size: ' + lstTicketPurchaser.size());
		
		
		for(Contact con : lstTicketPurchaser){
			mapTicketIdandHouseholder.put(mapTicketIdandTicketPurchaserId.get(con.Id),con.npo02__Household__c);
		}
		
		lstPotentialTicketHolder = [select Id, npo02__Household__c, FirstName, LastName, Name from Contact where npo02__Household__c IN :mapTicketIdandHouseholder.values()];
	    system.debug('lstPotentialTicketHolder.size: ' + lstPotentialTicketHolder.size());
	      
	    for(Contact purchaser : lstTicketPurchaser){
	    	list<Contact> householdMembers = new list<Contact>();
	    	for(Contact holder : lstPotentialTicketHolder){
	    		system.debug('##purchaser ID: ' + purchaser.id);
	    		system.debug('##Potential Holder ID: ' + holder.id);
	    		if(holder.npo02__Household__c == purchaser.npo02__Household__c)
	    			householdMembers.add(holder);
	    	}
	    	system.debug('##HouseholdMembers.size: ' + householdmembers.size());
	    	mapTicketIdandTicketHolder.put(mapTicketIdandTicketPurchaserId.get(purchaser.Id),householdMembers);
	    }
	        
	    for(sbxe1__Ticket__c everyticket:scope){
	    	system.debug('##mapTicketIdandTicketHolder.get(everyticket.Id): ' + mapTicketIdandTicketHolder.get(everyticket.Id));
			householdtocontactsmap.put(everyticket.Id,mapTicketIdandTicketHolder.get(everyticket.Id)); 
			system.debug('##householdtocontactsmap.get(everyticket.Id): ' + householdtocontactsmap.get(everyticket.Id));
		}
		
	    system.debug('##Housholdtocontactsmap.size: ' + householdtocontactsmap.size());
	    
	    RecordType child = [select id,RecordType.name from RecordType where name='Child/Person with Disability'];
	    RecordType adult = [select Id,RecordType.name from RecordType where name='Adult'];
	    
	    for(sbxe1__Ticket__c everyticket:scope){
	    	flag=false;
	        //Checking if TicketHolder field is left blank
	        if(everyticket.sbxe1__sbx_TicketHolderContact__c == null){
	        	system.debug('##Enters ticket holder Contact is null' + everyticket);
	        	
	            //if 'Is ticket holder in your household' field is checked
	            if(everyticket.Is_ticket_holder_in_your_household__c==true){
	            	system.debug('##Enters Is_ticket_holder_in_your_household__c==true' + everyticket);
	            	system.debug('##2Housholdtocontactsmap.size: ' + householdtocontactsmap.size());
	            	system.debug('##Housholdtocontactsmap.keyset: ' + householdtocontactsmap.keyset());
	                list<Contact> lstofcontacts = new list<Contact>();
	                system.debug('##2householdtocontactsmap.get(everyticket.id): ' + householdtocontactsmap.get(everyticket.Id));
	                system.debug('##Everyticket.Id: ' + everyticket.id);
	                if(householdtocontactsmap.containsKey(everyticket.Id))
	                	lstofcontacts = householdtocontactsmap.get(everyticket.Id);
	                system.debug('##lstofcontacts: ' + lstofcontacts);
	                	
	                if(everyticket.sbxe1__sbx_TicketPurchaserContact__r.firstname == everyticket.sbxe1__sbx_FirstName__c &&
	                   everyticket.sbxe1__sbx_TicketPurchaserContact__r.lastname == everyticket.sbxe1__sbx_LastName__c){
	                	everyticket.sbxe1__sbx_TicketHolderContact__c = everyticket.sbxe1__sbx_TicketPurchaserContact__c;
	                	flag=true;
	                	system.debug('purchaser is holder');
	                }else
	                	
	                if(lstofcontacts != null){
	                	system.debug('##lstofcontacts.size: ' + lstofcontacts.size());
		                for(Contact c: lstofcontacts){
		                	
		                    // Check if the 'First Name' and 'Last Name' fields of the ticket matches with that of any Contact in the same household as the Ticket Purchaser
		                    if(c.FirstName == everyticket.sbxe1__sbx_FirstName__c && c.LastName == everyticket.sbxe1__sbx_LastName__c){
		                    	system.debug('##ENters First Name and Last Name fields of the ticket matches');
		                        
		                        //Update 'Ticket Holder' field
		                        everyticket.sbxe1__sbx_TicketHolderContact__c = c.Id;
		                        flag=true;
		                        break;
		                    }
		                }
	                }
	                
	                 //If the 'First Name' and 'Last Name' fields do not match with the contacts in the household
	                 if(flag==false){
	                    system.debug('##Enters Flag is false where first name and last names do not match');
	                    
                        //Create a new Contact with the first name and last name as that entered in the 'First Name' and 'Last Name' fields of the ticket
                        Contact newcontact = new Contact();
                        
                        newcontact.npo02__Household__c = everyticket.sbxe1__sbx_TicketPurchaserContact__r.npo02__Household__c;
                        newcontact.FirstName = everyticket.sbxe1__sbx_FirstName__c;
                        newcontact.LastName = everyticket.sbxe1__sbx_LastName__c;
                        newcontact.email = everyticket.sbxe1__sbx_Email__c;
                        newcontact.soapbox_ticket_id__c = everyticket.id;
                        
                        //Set the new Contact's record type
                        if(everyticket.sbxe1__sbx_TicketType__c=='Child Attendee')
                             newcontact.RecordTypeId= child.Id;                        
                        else if (everyticket.sbxe1__sbx_TicketType__c=='Family Attendee' || everyticket.sbxe1__sbx_TicketType__c=='Professional Attendee')
                             newcontact.RecordTypeId= adult.Id; 
                        lstContactToInsert.add(newcontact);
                        system.debug('##new Contact: ' + newcontact);
                        
                        //everyticket.sbxe1__sbx_TicketHolderContact__c = newcontact.Id;
                        system.debug('##every ticket: ' + everyticket);
					}
	            }
	            
	            //if 'Is ticket holder in your household' field is not checked
	            else{
	            	system.debug('##Enters ticket holder in household false ' + everyticket);
	                list<Contact> lstofcontacts = new list<Contact>();
	                
	                //system.debug('##lstofcontacts.size: ' + householdtocontactsmap.get(everyticket.Id).size());
	                
	                if(householdtocontactsmap.containsKey(everyticket.Id))
	                	lstofcontacts = householdtocontactsmap.get(everyticket.Id);
	                if(lstofcontacts != null){ 
		                for(Contact c: lstofcontacts){
		                    // Check if the 'First Name' and 'Last Name' fields of the ticket matches with that of any Contact in the same household as the Ticket Purchaser
		                    if(c.FirstName == everyticket.sbxe1__sbx_FirstName__c && c.LastName == everyticket.sbxe1__sbx_LastName__c){
		                    	system.debug('##Enters first name and last name matches in the the holder in household false ');
		                        
		                        //Update 'Ticket Holder' field
		                        everyticket.sbxe1__sbx_TicketHolderContact__c = c.Id;
		                        flag=true;
		                        break;
		                    }  
		                }
	                }
	                
	                //If the 'First Name' and 'Last Name' fields do not match with the contacts in the household
	                if(mapAllContacts.containsKey(everyticket.sbxe1__sbx_Email__c+everyticket.sbxe1__sbx_FirstName__c+everyticket.sbxe1__sbx_LastName__c)){
	                	everyticket.sbxe1__sbx_TicketHolderContact__c = mapAllContacts.get(everyticket.sbxe1__sbx_Email__c+everyticket.sbxe1__sbx_FirstName__c+everyticket.sbxe1__sbx_LastName__c).Id;
	                }
	                else
	                //If the 'First Name' and 'Last Name' fields do not match with the contacts in the household or any other contacts in SF
	                if(flag==false){
	                    system.debug('##Enters flag false in the the holder in household false ');
                        
                        //Create a new Contact with the first name and last name as that entered in the 'First Name' and 'Last Name' fields of the ticket
                        Contact newcontact = new Contact();
                        newcontact.FirstName = everyticket.sbxe1__sbx_FirstName__c;
                        newcontact.LastName = everyticket.sbxe1__sbx_LastName__c;
                        newcontact.email = everyticket.sbxe1__sbx_Email__c;
                        newcontact.Soapbox_Ticket_Id__c = everyticket.id;
                        
                        //Set the new Contact's record type as the 'Ticket Type' field entered
                        if(everyticket.sbxe1__sbx_TicketType__c=='Child Attendee')
                             newcontact.RecordTypeId= child.Id;                        
                        else if (everyticket.sbxe1__sbx_TicketType__c=='Family Attendee' || everyticket.sbxe1__sbx_TicketType__c=='Professional Attendee')
                             newcontact.RecordTypeId= adult.Id; 
                        lstContactToInsert.add(newcontact);
                        system.debug('##new Contact info: ' + newcontact);
					}
	            }
	        }
	        system.debug('everyticket.sbxe1__sbx_TicketHolderContact__c ' + everyticket.sbxe1__sbx_TicketHolderContact__c );
	    }
	    
	    
	    insert lstContactToInsert;
	    
	    //create a list of all ticket ids in batch to match up Holder Contacts with their proper tickets
	    for(sbxe1__Ticket__c everyticket : scope){
	    	lstIds.add(everyticket.Id);
	    }
	    
	    lstTicketHolder = [select Id, Name, soapbox_ticket_id__c, CreatedDate from Contact where soapbox_ticket_id__c IN: lstIds];
    	
    	for(sbxe1__Ticket__c everyticket : scope){
    		for(Contact contacts : lstTicketHolder){
    			system.debug('##ticket holder name: ' + everyticket.sbxe1__sbx_FullName__c);
    			system.debug('##Contact name: ' + contacts.Name);
    			if(everyticket.id == contacts.soapbox_ticket_id__c)
    				everyticket.sbxe1__sbx_TicketHolderContact__c = contacts.Id;
    		}
    	}
    	
    	update scope;
    }
    
    global void finish(Database.BatchableContext BC){
    }
}