global class ScheduleSoapBoxCampaignMemberRemoval implements Schedulable {

	global void execute(SchedulableContext sc) {
  		Database.executeBatch(new RemoveSoapBoxCampaignMember());
	}
}