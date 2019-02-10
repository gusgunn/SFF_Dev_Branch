global class CreateCampaignMemberBatchable implements Database.Batchable<sObject>
{

	global Database.QueryLocator start(Database.BatchableContext BC){
		
		DateTime PastDateTime = datetime.now().addDays(-14);
        
        String Query = 'SELECT Id, sbxe1__sbx_Campaign__c, sbxe1__sbx_TicketHolderContact__c, sbxe1__sbx_TicketType__c, Interpreter_Service_Required__c, Interpreter_Service_Language__c, Special_Accomodations__c, Special_Accomodations_Information__c, Vegetarian__c  from sbxe1__Ticket__c where CreatedDate > :PastDateTime';
        System.debug('qXX'+Query);
        return Database.getQueryLocator(Query);
    }
    
    global void execute(Database.BatchableContext BC,list<sbxe1__Ticket__c> scope){
    	
    	set<CampaignMember> setAllCampaignMember = new set<CampaignMember>();
    	list<CampaignMember> lstAllCampaignMember = new list<CampaignMember>();
    	list<Campaign> lstTicketCampaigns = new list<Campaign>();
    	
    	for(sbxe1__Ticket__c everyticket:scope){
    		if(everyticket.sbxe1__sbx_Campaign__c != null)
    			lstTicketCampaigns.add(new Campaign(Id = everyticket.sbxe1__sbx_Campaign__c));
    	}
    	
    	list<CampaignMember> compareCampaignMembers = new list<CampaignMember>([select ContactId,
    																				   CampaignId
    																			from CampaignMember
    																			where CampaignId IN :lstTicketCampaigns]);
        
        for(sbxe1__Ticket__c everyticket:scope){
        	
	        //Checking if the TicketHolder and the Campaign fields are not empty
	        if(everyticket.sbxe1__sbx_TicketHolderContact__c!=null && everyticket.sbxe1__sbx_Campaign__c!=null){
	        	
	            //this section was deprecated because it was not effectively bulkified
	            /*list<CampaignMember> lstCampaignMembers = new list<CampaignMember>([select ContactId,
	            																		   CampaignId
	            																	from CampaignMember 
	            																	where ContactId = :everyticket.sbxe1__sbx_TicketHolderContact__c 
	            																	and CampaignId = :everyticket.sbxe1__sbx_Campaign__c]);*/
	            //To retrieve all campaign members of a particular campaign to check if the newly created ticketholder is already a member of the campaign
	            list<CampaignMember> lstCampaignMembers = new list<CampaignMember>();
	            
	            for(CampaignMember checkMember : compareCampaignMembers){
	            	if(checkMember.ContactId == everyticket.sbxe1__sbx_TicketHolderContact__c && checkMember.CampaignId == everyticket.sbxe1__sbx_Campaign__c)
	            		lstCampaignMembers.add(checkMember);
	            }
	            																	
	            if(lstCampaignMembers.isEmpty()){
	            	
	                    setAllCampaignMember.add(new CampaignMember(CampaignId=everyticket.sbxe1__sbx_Campaign__c,
	                    										    ContactId=everyticket.sbxe1__sbx_TicketHolderContact__c,
	                    										    Status=everyticket.sbxe1__sbx_TicketType__c,
	                    										    Interpreter_Service_Required__c = everyticket.Interpreter_Service_Required__c,
	                    										    Interpreter_Service_Language__c = everyticket.Interpreter_Service_Language__c,
	                    										    Special_Accommodations__c = everyticket.Special_Accomodations__c,
	                    										    Special_Accommodations_Information__c = everyticket.Special_Accomodations_Information__c,
	                    										    Vegetarian__c = everyticket.Vegetarian__c));
	            }
	            //Displaying an error the ticketholder of a campaign is already a campaign member of the particular campaign
	            /*if(setAllCampaignMembers.size()!=0)
	            {
	                everyticket.addError('Campaign Member already exists');
	            }*/
	        }
    	}
    	
    	for(CampaignMember cm : setAllCampaignMember){
    		lstAllCampaignMember.add(cm);
    	}
    	
    	insert lstAllCampaignMember;
    }
    
    global void finish(Database.BatchableContext BC){
    }
}