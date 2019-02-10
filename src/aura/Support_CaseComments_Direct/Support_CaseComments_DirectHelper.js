({
    getData : function(cmp) {
        var caseId = cmp.get("v.recordId");
		console.log('entered casecomments getData, caseId - '+ caseId); 
		       
        var action = cmp.get('c.getCaseComments');
        action.setParams({
            "caseId": caseId
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var commentslist = response.getReturnValue();

                var element;
                for (var i = 0; i < commentslist.length; i++) {
                    element = commentslist[i];
                    element.createByName = element.CreatedBy.Name;
					console.log('commentslist CreatedBy- '+ element.CreatedBy.Name);
				}                
               	
                cmp.set("v.commentsdata", commentslist);

            } else if (state === "ERROR") {
                console.log('state - '+ state);
                var errors = response.getError();
                console.error(errors);
            }
        }));
        $A.enqueueAction(action);
    },
    
     handleAddComment: function(component, event, helper, comment) {
        console.log('handleAddComment  ' + component.get("v.recordId"));
        component.get("v.newCommentId")
        
        var action = component.get("c.addCaseComment");
        action.setParams({
            "commentBody": comment,
            "caseId": component.get("v.recordId"),
            "caseCommentId" : component.get("v.newCommentId")
        });
        
     
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                  
                component.set('v.newCommentId' , response.getReturnValue().Id);
                component.set('v.update', true);
                console.log('ID', response.getReturnValue().Id)
                $A.get("e.force:refreshView").fire();
            }
            else if (state === "ERROR") {
                console.log('Problem saving comment, response state: ' + state);
            }
                else {
                    console.log('Unknown problem, response state: ' + state);
                }
        });
        
        $A.enqueueAction(action);        
    }
})