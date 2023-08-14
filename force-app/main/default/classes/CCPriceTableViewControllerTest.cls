@isTest
public class CCPriceTableViewControllerTest {
	
    @isTest
    public static void testGetMaterials() {
        // Test data setup
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User testUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.comCCPRiceTableView', Produtos__c = 'Product1,Product2');
         
        insert testUser;
        
		User thisUser = [SELECT Id FROM User WHERE Alias = 'standt'];
        
        Id psID = [Select id from PermissionSet where Name = 'Canal_Cliente_UX_CMI'].get(0).Id;
        
        PermissionSetAssignment psa = new PermissionSetAssignment (PermissionSetId = psID, AssigneeId = thisUser.id);
        insert psa;
        
        System.runAs (thisUser) {
            Tipo_Arquivo__c tipoArq1 = new Tipo_Arquivo__c(Name = 'TipoArq1');
            insert tipoArq1;
            Id tipoArqId = [Select id from Tipo_Arquivo__c limit 1].get(0).Id;
            
            Documento_Executivo__c docExe1 = new Documento_Executivo__c(Name = 'TestDoc1', Tipo_Arquivo__c = tipoArqId);
            insert docExe1;
            Id docExeId = [Select id from Documento_Executivo__c limit 1].get(0).Id;
            
            System.debug('Data de criação ' + [Select Data_Inicio_Publicacao__c from Documento_Executivo__c].get(0).Data_Inicio_Publicacao__c);
            
            Documento_Relacionado__c docRel1 = new Documento_Relacionado__c(Name = 'TestDoc1', Material__c = 'Product1', Documento_Executivo__c = docExeId);
            Documento_Relacionado__c docRel2 = new Documento_Relacionado__c(Name = 'TestDoc2', Material__c = 'Product2', Documento_Executivo__c = docExeId);
            insert new List<Documento_Relacionado__c>{ docRel1, docRel2 };
    
            // Test the getMaterials method
            Test.startTest();
            List <String> result = CCPriceTableViewController.getMaterials(String.valueOf(tipoArqId).substring(0, 15));
            Test.stopTest();
    
            // Assert the results
            System.assertEquals(2, result.size());
        }
    }
    

    
    @isTest
    public static void testGetValidity() {
        // Test data setup
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User testUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.comCCPRiceTableView', Produtos__c = 'Product1,Product2');
         
        insert testUser;
        
		User thisUser = [SELECT Id FROM User WHERE Alias = 'standt'];
        
        Id psID = [Select id from PermissionSet where Name = 'Canal_Cliente_UX_CMI'].get(0).Id;
        
        PermissionSetAssignment psa = new PermissionSetAssignment (PermissionSetId = psID, AssigneeId = thisUser.id);
        insert psa;
        
        System.runAs (thisUser) {

            Tipo_Arquivo__c tipoArq1 = new Tipo_Arquivo__c(Name = 'TipoArq1');
            insert tipoArq1;
            Id tipoArqId = [Select id from Tipo_Arquivo__c limit 1].get(0).Id;
            
            Documento_Executivo__c docExe1 = new Documento_Executivo__c(Name = 'TestDoc1', Tipo_Arquivo__c = tipoArqId);
            insert docExe1;
            Id docExeId = [Select id from Documento_Executivo__c limit 1].get(0).Id;
            
            System.debug('Data de criação ' + [Select Data_Inicio_Publicacao__c from Documento_Executivo__c].get(0).Data_Inicio_Publicacao__c);
            
            Documento_Relacionado__c docRel1 = new Documento_Relacionado__c(Name = 'TestDoc1', Material__c = 'Product1', Documento_Executivo__c = docExeId);
            Documento_Relacionado__c docRel2 = new Documento_Relacionado__c(Name = 'TestDoc2', Material__c = 'Product2', Documento_Executivo__c = docExeId);
            insert new List<Documento_Relacionado__c>{ docRel1, docRel2 };
    
            // Test the getValidity method
            Test.startTest();
            List<String> result = CCPriceTableViewController.getValidity('TestDoc1',String.valueOf(tipoArqId).substring(0, 15) );
            Test.stopTest();
    
            System.assertEquals(1, result.size());
            
        }
    }
    
    @isTest
    public static void testDownloadFile() {
        // Test data setup
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User testUser = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.comCCPRiceTableView', Produtos__c = 'Product1,Product2');
         
        insert testUser;
        
		User thisUser = [SELECT Id FROM User WHERE Alias = 'standt'];
        
        Id psID = [Select id from PermissionSet where Name = 'Canal_Cliente_UX_CMI'].get(0).Id;
        
        PermissionSetAssignment psa = new PermissionSetAssignment (PermissionSetId = psID, AssigneeId = thisUser.id);
        insert psa;
        
        System.runAs (thisUser){

            Tipo_Arquivo__c tipoArq1 = new Tipo_Arquivo__c(Name = 'TipoArq1');
            insert tipoArq1;
            Id tipoArqId = [Select id from Tipo_Arquivo__c limit 1].get(0).Id;
            
            Documento_Executivo__c docExe1 = new Documento_Executivo__c(Name = 'TestDoc1', Tipo_Arquivo__c = tipoArqId,
                                                                        Inicio_Vigencia__c=Date.today(),Fim_Vigencia__c = Date.today()+1);
            insert docExe1;
            Id docExeId = [Select id from Documento_Executivo__c limit 1].get(0).Id;
            
            System.debug('Data de criação ' + [Select Data_Inicio_Publicacao__c from Documento_Executivo__c].get(0).Data_Inicio_Publicacao__c);
            
            Documento_Relacionado__c docRel1 = new Documento_Relacionado__c(Name = 'TestDoc1', Material__c = 'Product1', Documento_Executivo__c = docExeId);
            Documento_Relacionado__c docRel2 = new Documento_Relacionado__c(Name = 'TestDoc2', Material__c = 'Product2', Documento_Executivo__c = docExeId);
            insert new List<Documento_Relacionado__c>{ docRel1, docRel2 };
                
            String periodo = [Select Periodo__c from Documento_Relacionado__c where name='TestDoc1'].get(0).Periodo__c;
    
            // Test the downloadFile method
            Test.startTest();
            List<Documento_Relacionado__c> result = CCPriceTableViewController.downloadFile('TestDoc1', periodo, String.valueOf(tipoArqId).substring(0, 15));
            Test.stopTest();
    
            System.assertEquals(1, result.size());
            }
    }
	
}