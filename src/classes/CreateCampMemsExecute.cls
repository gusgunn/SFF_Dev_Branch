global class CreateCampMemsExecute {

	webservice static void execute(){
  		Database.executeBatch(new CreateCampaignMemberBatchable());
	}
	
	webservice static void executeRemove(){
		Database.executeBatch(new RemoveSoapBoxCampaignMember());
	}
	
	webservice static void executeHolders(){
		Database.executeBatch(new UpdateTicketHoldersBatch());
	}
}