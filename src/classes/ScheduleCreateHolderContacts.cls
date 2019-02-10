global class ScheduleCreateHolderContacts implements schedulable{

	global void execute(SchedulableContext sc){
  		Database.executeBatch(new UpdateTicketHoldersBatch());
	}
}