@isTest
public class MultiLevelNavigationMenuControllerTest {
    @isTest
    static void testCheckCustomPermissions() {
        List<String> permissions = new List<String>{'permission1', 'permission2'};
        Map<String, Boolean> expectedResults = new Map<String, Boolean>{'permission1' => true, 'permission2' => false};
        Set<String> keysExpectedResults = expectedResults.keySet();

        Test.startTest();
        Map<String, Boolean> actualResults = MultiLevelNavigationMenuController.checkCustomPermissions(permissions);
        Set<String> keysActualdResults = actualResults.keySet();

        Test.stopTest();
        System.assertEquals(keysExpectedResults, keysActualdResults);
    }
    
    @isTest
    static void testGetMenuId() {
        String menuName = 'menuName';
        ccnavmenus__Menu__c menu = new ccnavmenus__Menu__c(Name = menuName);
        insert menu;
        Test.startTest();
        Id actualResult = MultiLevelNavigationMenuController.getMenuId(menuName);
        Test.stopTest();
        System.assertEquals(menu.Id, actualResult);
    }
}