/* Created By : Lister Technologies
 * Created On : 05/09/2014
 * Purpose    : To create holder contact based on the household
 */
trigger CreateHolderContact on sbxe1__Ticket__c (before insert) {


    Boolean flag=false;
    Map<Id,List<Contact>> householdtocontactsmap= new Map<Id,List<Contact>>();
    List<Contact> lstTicketPurchaser = new List<Contact>();
    List<Contact> lstcontacts = new List<Contact>();   
    List<CampaignMember> lstcampaignmember = new List<CampaignMember>();
    map<Id,Id> mapTicketIdandTicketPurchaserId = new map<Id,Id>(); 
    map<Id,List<Contact>> mapTicketIdandTicketHolder = new map<Id,List<Contact>>();
    map<Id,Id> mapTicketIdandHouseholder = new map<Id,Id>();
    List<Contact> lstContactToInsert = new List<Contact>();
    
    system.debug('####Trigger.new' +  trigger.new);
    
    for(sbxe1__Ticket__c everyticket:trigger.new)
        {
            mapTicketIdandTicketPurchaserId.put(everyticket.sbxe1__sbx_TicketPurchaserContact__c,everyticket.Id);
        }
        
        lstTicketPurchaser = [select Id,npo02__Household__c from contact where Id in:mapTicketIdandTicketPurchaserId.keyset()];
        for(contact con : lstTicketPurchaser)
        {
                mapTicketIdandTicketHolder.put(mapTicketIdandTicketPurchaserId.get(con.Id),[select Id,npo02__Household__c,FirstName,LastName,Name from contact where npo02__Household__c=: con.npo02__Household__c]);
                mapTicketIdandHouseholder.put(mapTicketIdandTicketPurchaserId.get(con.Id),con.npo02__Household__c);
        }
        
    for(sbxe1__Ticket__c everyticket:trigger.new)
        {
                householdtocontactsmap.put(everyticket.Id,mapTicketIdandTicketHolder.get(everyticket.Id)); 
        }
    
    RecordType child = [select id,RecordType.name from RecordType where name='Child/Person with Disability'];
    RecordType adult = [select Id,RecordType.name from RecordType where name='Adult'];
    for(sbxe1__Ticket__c everyticket:trigger.new)
    {
        flag=false;
        //Checking if TicketHolder field is left blank
        if(everyticket.sbxe1__sbx_TicketHolderContact__c == null)
        {
        system.debug('##Enters ticket holder contact is null' + everyticket);
            //if 'Is ticket holder in your household' field is checked
            if(everyticket.Is_ticket_holder_in_your_household__c==true)
            {
            system.debug('##Enters Is_ticket_holder_in_your_household__c==true' + everyticket);
                List<Contact> lstofcontacts = new List<Contact>();
                if(householdtocontactsmap.get(everyticket.Id) != null)
	                	lstofcontacts = householdtocontactsmap.get(everyticket.Id);
	                	
	            if(lstofcontacts != null)
	            {
	                for(Contact c: lstofcontacts)
	                {
	                    // Check if the 'First Name' and 'Last Name' fields of the ticket matches with that of any contact in the same household as the Ticket Purchaser
	                    if(c.FirstName == everyticket.sbxe1__sbx_FirstName__c && c.LastName == everyticket.sbxe1__sbx_LastName__c)
	                    {
	                    system.debug('##ENters First Name and Last Name fields of the ticket matches');
	                        //Update 'Ticket Holder' field
	                        everyticket.sbxe1__sbx_TicketHolderContact__c = c.Id;
	                        flag=true;
	                        break;
	                    }
	                }
	            }
                 //If the 'First Name' and 'Last Name' fields do not match with the contacts in the household
                 if(flag==false)
                    {
                    system.debug('##Enters Flag is false where first name and last names do not match');
                        //Create a new contact with the first name and last name as that entered in the 'First Name' and 'Last Name' fields of the ticket
                        Contact newcontact = new Contact();
                        
                        newcontact.npo02__Household__c = mapTicketIdandHouseholder.get(everyticket.Id);
                        newcontact.FirstName = everyticket.sbxe1__sbx_FirstName__c;
                        newcontact.LastName = everyticket.sbxe1__sbx_LastName__c;
                        //Set the new contact's record type
                        if(everyticket.sbxe1__sbx_TicketType__c=='Child Attendee')
                             newcontact.RecordTypeId= child.Id;                        
                        else if (everyticket.sbxe1__sbx_TicketType__c=='Family Attendee' || everyticket.sbxe1__sbx_TicketType__c=='Professional Attendee')
                             newcontact.RecordTypeId= adult.Id; 
                        lstContactToInsert.add(newcontact);
                        everyticket.sbxe1__sbx_TicketHolderContact__c = newcontact.Id;

                    }
            }
            //if 'Is ticket holder in your household' field is not checked
            else
            {
            system.debug('##Enters ticket holder in household false ' + everyticket);
                List<Contact> lstofcontacts = new List<Contact>();
                lstofcontacts = householdtocontactsmap.get(everyticket.Id);
                for(Contact c: lstofcontacts)
                {
                    // Check if the 'First Name' and 'Last Name' fields of the ticket matches with that of any contact in the same household as the Ticket Purchaser
                    if(c.FirstName == everyticket.sbxe1__sbx_FirstName__c && c.LastName == everyticket.sbxe1__sbx_LastName__c)
                    {
                    system.debug('##Enters first name and last name matches in the the holder in household false ');
                        //Update 'Ticket Holder' field
                        everyticket.sbxe1__sbx_TicketHolderContact__c = c.Id;
                        flag=true;
                        break;
                    }
                    
                }
                //If the 'First Name' and 'Last Name' fields do not match with the contacts in the household
                if(flag==false)
                    {
                    system.debug('##Enters flag false in the the holder in household false ');
                        //Create a new contact with the first name and last name as that entered in the 'First Name' and 'Last Name' fields of the ticket
                        Contact newcontact = new Contact();
                        newcontact.npo02__Household__c = mapTicketIdandHouseholder.get(everyticket.Id);
                        newcontact.FirstName = everyticket.sbxe1__sbx_FirstName__c;
                        newcontact.LastName = everyticket.sbxe1__sbx_LastName__c;
                        //Set the new contact's record type as the 'Ticket Type' field entered
                        if(everyticket.sbxe1__sbx_TicketType__c=='Child Attendee')
                             newcontact.RecordTypeId= child.Id;                        
                        else if (everyticket.sbxe1__sbx_TicketType__c=='Family Attendee' || everyticket.sbxe1__sbx_TicketType__c=='Professional Attendee')
                             newcontact.RecordTypeId= adult.Id; 
                        lstContactToInsert.add(newcontact);
                        everyticket.sbxe1__sbx_TicketHolderContact__c = newcontact.Id;
                    }
            }
        }
        system.debug('everyticket.sbxe1__sbx_TicketHolderContact__c ' + everyticket.sbxe1__sbx_TicketHolderContact__c );
    }
    insert lstContactToInsert;
   
     

    
    
}