public class MultiLevelNavigationMenuController {

    @AuraEnabled
    public static Map<String, Boolean> checkCustomPermissions(List<String> permissions) {
        Map<String, Boolean> permissionResults = new Map<String, Boolean>();
        for (String permission : permissions) {
            permissionResults.put(permission, FeatureManagement.checkPermission(permission));
        }
        return permissionResults;
    }
    
    @AuraEnabled
    public static Id getMenuId(String menuName) {
        String query = 'SELECT Id FROM ccnavmenus__Menu__c WHERE Name = :menuName LIMIT 1';
        ccnavmenus__Menu__c menu = Database.query(query);
        if (menu != null) {
            return menu.Id;
        } else {
            return null;
        }
    }
}