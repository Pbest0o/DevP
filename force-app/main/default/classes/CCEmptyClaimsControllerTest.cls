@isTest
public class CCEmptyClaimsControllerTest {
    
	@isTest
    public static void getClaimsTest(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        
        User testUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.comCCPRiceTableView', Produtos__c = 'Product1,Product2');
         
        insert testUser;
        
		User thisUser = [SELECT Id FROM User WHERE Alias = 'standt'];
        
        System.runAs (thisUser) {
        	Case c = new Case(Type='Consulta',Subject='test@test.com',Description='Test Description');
        	insert c;
            
            // Test the getMaterials method
            Test.startTest();
            Case result = CCEmptyClaimsController.getClaims();
            Test.stopTest();
    
            // Assert the results
            System.assertEquals(true, result <> null);
        }
        
        
        
    }

}