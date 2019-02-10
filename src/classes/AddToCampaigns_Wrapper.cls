public class AddToCampaigns_Wrapper {
 
	public String message{ get; set; } //success message
	public Boolean checked{ get; set; } //check box for selection
	public Boolean disabled {get; set;} //if member is already part of campaign selection check box is disabled 
    public Campaign camp { get; set;}   //Campaign record returned as part of dataset
   
 
    public addtocampaigns_Wrapper(){
     campaign  camp = new Campaign();
        checked = false;
        disabled = false;
        message='';
    }
 	
 	public addtocampaigns_Wrapper(Campaign c){
        camp = c;
        checked = false;
        disabled = false;
        message='';
        
    }
}