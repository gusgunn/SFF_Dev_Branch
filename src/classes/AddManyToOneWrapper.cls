public class AddManyToOneWrapper {

//variables used for creating add to Contact record  
	public String message{ get; set; } //success message
	public Boolean checked{ get; set; } //check box for selection
	public Boolean disabled {get; set;} //if member is already part of campaign selection check box is disabled 
    public Contact con { get; set;}   //Contact record returned as part of dataset
    public String status { get; set; } //CM status chosen
    public String special {get;set;}
    public Boolean interp {get;set;}
    public Integer rowNum {get;set;}
   
    
   
 
    public AddManyToOneWrapper(){
    	//constructor without passed parameters
     Contact  con = new Contact();
        checked = false;
        disabled = false;
        message='';
        interp = false;
        status = '';
        special = '';
  		rowNum = 0;
    
        
    }
 	
 	public AddManyToOneWrapper(Contact c, Integer rowCounter){
 		//constructor with passed parameters
        con = c;
        checked = false;
        disabled = false;
        message='';
        interp = false;
        status ='';
        special = '';
        this.rowNum = rowCounter;
        
    }
}