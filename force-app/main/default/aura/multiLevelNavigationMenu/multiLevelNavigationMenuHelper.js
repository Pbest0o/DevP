({
	init : function(component, event, helper) {
        var permissionsToCheck = ['Usuario_Gas', 'Usuario_CMI'];

        var action = component.get("c.checkCustomPermissions");
        action.setParams({
            permissions: permissionsToCheck
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var permissionResults = response.getReturnValue();
                console.log("SUCCESS checkCustomPermissions");

                if (permissionResults['Usuario_Gas'] && permissionResults['Usuario_CMI']) {
                    helper.queryMenuId(component, 'Canal Cliente - CMI + Gás');
                } else if (!permissionResults['Usuario_Gas'] && !permissionResults['Usuario_CMI']) {
                    helper.queryMenuId(component, 'Canal Cliente - CMI + Gás');
                } else if (permissionResults['Usuario_Gas'] && !permissionResults['Usuario_CMI']){
                    helper.queryMenuId(component, 'Canal Cliente - Gás');

                } else if (permissionResults['Usuario_CMI'] && !permissionResults['Usuario_Gas']){
                    helper.queryMenuId(component, 'Canal Cliente - CMI');

                } else {
                   helper.queryMenuId(component, 'Canal Cliente - CMI');
                }

            } else {
                var errors = response.getError();
                //console.log('erros' + errors);
            }
        });
        $A.enqueueAction(action);
    },

    queryMenuId: function(component, menuName) {
        var action = component.get("c.getMenuId");
        action.setParams({
            menuName: menuName
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var menuId = response.getReturnValue();
                console.log("menu Id: " + menuId);
                component.set("v.menuId", menuId);
            } else {
                var errors = response.getError();
                //console.log('errors' + errors);
            }
        });
        $A.enqueueAction(action);
    }
})