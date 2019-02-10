trigger Set_Outcome_fields on Action__c (after insert, after update) {

	/*
	**This trigger runs any time an Action is created or updated and sets values for F2F Outcome fields
	**based upon the values chosen in one of three Action detail fields.  The values for the F2F fields
	**are designated by a custom object called F2F_Outcomes_Key and this trigger only updates records if
	**certain criteria are met in order to limit unnecessary API calls.
	*/
	
	//establish variables
	list<Action__c> actions = new list<Action__c>();
	list<F2F_Outcomes_Key__c> keys = new list<F2F_Outcomes_Key__c>();
	set<string> totalActionValues = new set<string>();
	set<string> indActionValues = new set<string>();
	set<string> commServ = new set<string>();
	set<string> finan = new set<string>();
	set<string> medHome = new set<string>();
	set<string> partner = new set<string>();
	set<string> screen = new set<string>();
	set<string> trans = new set<string>();
	map<id, set<string>> stringMap = new map<id, set<string>>();

	//iterate through the trigger records seeing which qualify for upsert
	for(integer i = 0; i < trigger.size; i++){
		
		if((trigger.isUpdate && trigger.old[i].Action_Detail_Type_Internal_Referral__c != trigger.new[i].Action_Detail_Type_Internal_Referral__c) ||
		   (trigger.isUpdate && trigger.old[i].Action_Detail_Type_Information__c != trigger.new[i].Action_Detail_Type_Information__c) ||
		   (trigger.isUpdate && trigger.old[i].Action_Detail_Type_External_Referral__c != trigger.new[i].Action_Detail_Type_External_Referral__c) ||
		   (trigger.isUpdate && trigger.old[i].F2F_Keys_Have_Changed__c == TRUE) ||
		   (trigger.isInsert && trigger.new[i].Action_Detail_Type_Internal_Referral__c != null) ||
		   (trigger.isInsert && trigger.new[i].Action_Detail_Type_Information__c != null) ||
		   (trigger.isInsert && trigger.new[i].Action_Detail_Type_External_Referral__c != null)
		  ){
			
			//add the record to the eventual upsert list
			actions.add(new Action__c(Id = trigger.new[i].id));
			
			//this string set contains only values matching the current record so that it can be added to a map along with the record id
			indActionValues.clear();
			if(trigger.new[i].Action_Detail_Type_Internal_Referral__c != null)
				indActionValues.addAll(trigger.new[i].Action_Detail_Type_Internal_Referral__c.split(';'));
			if(trigger.new[i].Action_Detail_Type_Information__c != null)	
				indActionValues.addAll(trigger.new[i].Action_Detail_Type_Information__c.split(';'));
			if(trigger.new[i].Action_Detail_Type_External_Referral__c != null)	
				indActionValues.addAll(trigger.new[i].Action_Detail_Type_External_Referral__c.split(';'));
			
			//add the record id and string set to the map to be referenced later
			stringMap.put(trigger.new[i].id, indActionValues);
			
			//this string list contains every value from all records so that we can select only relevant keys in the below query
			if(trigger.new[i].Action_Detail_Type_Internal_Referral__c != null)
				totalActionValues.addAll(trigger.new[i].Action_Detail_Type_Internal_Referral__c.split(';'));
			if(trigger.new[i].Action_Detail_Type_Information__c != null)
				totalActionValues.addAll(trigger.new[i].Action_Detail_Type_Information__c.split(';'));
			if(trigger.new[i].Action_Detail_Type_External_Referral__c != null)
				totalActionValues.addAll(trigger.new[i].Action_Detail_Type_External_Referral__c.split(';'));
		}
	}

	//query for only the f2f outcome records with an action detail type in the full string set
	if(actions.size() > 0 && actions != null){
		
		keys = [SELECT Id, Action_Detail_Type__c, Community_Services__c, Financing__c, Medical_Home__c, Partnering__c, Screening__c, Transition__c
				FROM F2F_Outcomes_Key__c
				WHERE Action_Detail_Type__c IN :totalActionValues
				LIMIT 50000];

		//iterate across all valid action records
		for(Action__c a : actions){
			
			//blank all values for every iteration since we will be reusing variables and rebuilding the record values.
			a.Community_services__c = null;
			a.Financing__c = null;
			a.Medical_Home__c = null;
			a.Partnering__c = null;
			a.Screening__c = null;
			a.Transition__c = null;
			commServ.clear();
			finan.clear();
			medHome.clear();
			partner.clear();
			screen.clear();
			trans.clear();
	
			//iterate across all f2f outcome keys for each valid action.  We have to use nested loops instead of a map because the keys array was
			//not available before being queried for
			for(F2F_Outcomes_Key__c k : keys){
					
				if(stringMap.get(a.id).contains(k.Action_Detail_Type__c)){
					
					//these are all sets because we want only unique values
					if(k.Community_Services__c != null)
						commServ.addAll(k.Community_Services__c.split(';'));
					if(k.Financing__c != null)
						finan.addAll(k.Financing__c.split(';'));
					if(k.Medical_Home__c != null)
						medHome.addAll(k.Medical_Home__c.split(';'));
					if(k.Partnering__c != null)
						partner.addAll(k.Partnering__c.split(';'));
					if(k.Screening__c != null)
						screen.addAll(k.Screening__c.split(';'));
					if(k.Transition__c != null)
						trans.addAll(k.Transition__c.split(';'));
				}
			}
			
			//convert the sets to lists and then join them together using semicolons so that they will display properly in multi-picklists
			if(commServ.size() > 0)
				a.Community_services__c = string.join(new list<string>(commServ), '; ');
			if(finan.size() > 0)
				a.Financing__c = string.join(new list<string>(finan), '; ');
			if(medHome.size() > 0)
				a.Medical_Home__c = string.join(new list<string>(medHome), '; ');
			if(partner.size() > 0)
				a.Partnering__c = string.join(new list<string>(partner), '; ');
			if(screen.size() > 0)
				a.Screening__c = string.join(new list<string>(screen), '; ');
			if(trans.size() > 0)
				a.Transition__c = string.join(new list<string>(trans), '; ');
			a.F2F_Keys_Have_Changed__c = FALSE;
		}

		//upsert records
		upsert actions;
	}
}