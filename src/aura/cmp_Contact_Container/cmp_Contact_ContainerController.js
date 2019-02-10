({
    //Specifying progress === 100 ? clearInterval(interval) : progress + 20 increases
    //the progress value by 20% and stops the animation when the progress reaches 100%
    //The progress bar is updated every 1000 milliseconds.
    doInit:  function (component, event, helper) {
 
       var interval = setInterval($A.getCallback(function () {
            var progress = component.get('v.progress');
            component.set('v.progress', progress === 100 ? clearInterval(interval) : progress + 20);
        }), 1000);
        
    }, 

      
    selectPathStep1 : function(component,event,helper){
        component.set("v.pathStep", "1");  
    },
    selectPathStep2 : function(component,event,helper){
        component.set("v.pathStep", "2");
           
    },
    selectPathStep3 : function(component,event,helper){
      component.set("v.pathStep", "3");
     
    },
    selectPathStep4 : function(component,event,helper){
    component.set("v.pathStep", "4");
       
    },
    selectPathStep5 : function(component,event,helper){
        component.set("v.pathStep", "5");
        
    },
    selectPathStep6 : function(component,event,helper){
        component.set("v.pathStep", "6");
     
    },
    selectPathStep7 : function(component,event,helper){
        component.set("v.pathStep", "7");

    },
    selectPathStep8 : function(component,event,helper){
        component.set("v.pathStep", "8");

    },

    handleShowErrorNotice: function (component, event, helper) {
        component.find('notifLib').showNotice({
            "variant": "error",
            "title": "Error",
            "header": "Something has gone wrong!",
            "message": "Unfortunately, there was a problem updating the record.",
            closeCallback: function () {
                alert('CloseMe!');
            }
        });
    },
    
})