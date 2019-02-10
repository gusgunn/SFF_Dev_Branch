({
	handelSearchKeyChange: function(component, event, getLabel) {
        var getInputkeyWord = component.find('inputName').get('v.value');
        console.log('getLabel' + getLabel);
        if (getInputkeyWord.length > 3) {
            
            var appEvent = $A.get("e.c:evt_SearchKeyChange");
            
            appEvent.setParams({"searchKey": getInputkeyWord,
                               "field" : component.get('v.field')
                              });
        	appEvent.fire();
    	
   		 }else  if(getInputkeyWord.length === 0) {
           
          var compEvent = component.getEvent("resetOne");
            
            compEvent.setParams({
                               "field" : getLabel
                              });
        	compEvent.fire();
         }else{
             console.log('searchString in between');
         }
 
 	},
    
})