public class CampaignCMListController {   

//Global Variables
    

	public List<CampaignMember> cms {get;set;}
    //public List<Contact> contacts {get;set;}
    

	public String searchString {get;set;}
    

	private String campID;

//only use if view on standard controller
    
    

//Constructor for standard page
    
	public CampaignCMListController (ApexPages.StandardController controller) 
    {
  
      	searchString='';
    	campID = controller.getId();
        doQuery();
    }
        
        
        
        //CONTROLLER


    
//methods for getting list of cm's
    
	public void doQuery()
    {
    
    		String queryString = '';
        
		if(searchString != null) 

//add in % in the query string
            
		queryString = searchString+'%';

        
        
//if viewing on standard controller (Campaign), add in filter for CampaignId
        
		cms = [SELECT campaignID, Registration_Status__c, id, flag__c, contact.HMG__c,contactID, contact.npe01__PreferredPhone__c, Parent_Caregiver__c, contact.AccountID, contact.RecordType.Name, contact.npo02__Household__r.name,  contact.npo02__Household__c, Name, FirstName, LastName, contact.Birthdate, contact.Email, Status, Contact.Phone, No_Show__c                  
		FROM CampaignMember 
        WHERE LastName like :queryString
        AND CampaignId = :campID    
        AND No_Show__c= false
        AND (NOT Status LIKE 'Invitation Email Sent')
		ORDER BY LastName asc
                   
		LIMIT 99];
    
	}
    
   
 //save all records that were updated
     

	public void save() 
    {
       
		update cms;
        //update contacts;
        
    
	}
	public pageReference UpdateHMG() 
    {
       update cms;
       PageReference pgref = new PageReference('/' + campID);
		
       pgref.setRedirect(true);
       return pgref;
        //update contacts;
        
    
	}

}