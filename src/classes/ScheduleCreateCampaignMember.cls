global class ScheduleCreateCampaignMember implements Schedulable{
	
	global void execute(SchedulableContext sc){
  		Database.executeBatch(new CreateCampaignMemberBatchable());
	}
}