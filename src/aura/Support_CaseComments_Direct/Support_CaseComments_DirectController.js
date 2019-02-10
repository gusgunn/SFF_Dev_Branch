({
    doInit: function(component, event, helper) {
         let comment =   component.get('v.newComment');
        if(comment.length>1){
            component.set('v.update', true);
        }
    },
    
    handleCountComment: function(component, event, helper) {
        let comment =   component.get('v.newComment');
        helper.handleAddComment(component, event, helper, comment)
        
        if(comment.length>3998){
            component.set('v.newComment', ""); 
            component.set('v.newCommentId', "");
        }
        
    },
    cancel: function(component, event, helper) {
         component.set('v.newComment', "") ;
        //refresh component to reset
    },
    
    
})