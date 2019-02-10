public class Wrapper {
  
        public Boolean aCheckBox {get;set;}
        public Boolean disabled {get; set;} //if member is already part of campaign selection check box is disabled
        public Contact aContact {get;set;}
        public String aMessage {get; set;} //success message
        public String status {get; set;} //CM status chosen
        public String aSpecial {get;set;}
        public Boolean aInterp {get;set;}
        public Integer aRowCounter {get;set;}
        
        
        public Wrapper(Integer rowCounter, Contact a, Boolean chk){
            aRowCounter = rowCounter;
            aContact = a;
            aCheckBox = chk;
            disabled = false;
            aMessage='';
            aInterp = false;
            status ='';
            aSpecial = '';
            
        }
    }