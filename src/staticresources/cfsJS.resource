
    window.cfsExecuteAction = function (action) {
		var p = new Promise(
			$A.getCallback(function (resolve, reject) {
				action.setCallback(this, function (response) {
					var responseState = response.getState();    
                	if (responseState == "SUCCESS") {
                    	resolve(response.getReturnValue());
                	} 
                    else if (responseState == 'ERROR') {
						var errors = response.getError();
						var message = errors;
						if (errors && Array.isArray(errors) && errors.length > 0) {
							message = '';
							for (var i = 0; i < errors.length; i++) {
								message += errors[i].message + ' ';
							}
						}
						reject(message)}
                    });
					$A.enqueueAction(action);
			}));
        return p;
    }
	
	window.cfsLog = function (message) {
		console.error(message);
	}
	
	window.cfsRefreshView = function () {
		$A.get('e.force:refreshView').fire();
	}

	window.cfsToast = function (title, message, resultType) {
		var resultsToast = $A.get("e.force:showToast");
        resultsToast.setParams ({
			"title": title,
            "message": message,
            "type": resultType
        });
        resultsToast.fire();
	}

   	window.cfsNavigateTo =  function(recordId) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId
        });
        navEvt.fire();
    }
