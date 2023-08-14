public without sharing class PriceAlertsController {

    @AuraEnabled(cacheable=true)
    public static List<String> getDocumentosExecutivosAtualizados(String tiposDeArquivos) {
  
        User currentUser;
        String products;
        List <String> tiposDeArquivosList = new List <String>();
        List <String> productList = new List<String>();
        DateTime yesterday = DateTime.now().addDays(-1);
        List <Documento_Relacionado__c> docRelList;

        if(User.SObjectType.getDescribe().isAccessible() && 
            Schema.SObjectType.User.fields.Produtos__c.isAccessible() &&
            Schema.SObjectType.User.fields.Id.isAccessible() ){
            currentUser = [Select Produtos__c from User where id =:UserInfo.getUserId()];
        } else{
            System.debug('Permission Issue: Query User');
        }
        
        products = currentUser.Produtos__c;

        if(!String.isBlank(products)){
            productList = products.split(',');
        }

        if(!String.isBlank(tiposDeArquivos)){
            tiposDeArquivosList = tiposDeArquivos.split(',');
        }

        if(Documento_Relacionado__c.SObjectType.getDescribe().isAccessible() && 
            Schema.SObjectType.Documento_Relacionado__c.fields.Name.isAccessible() &&
            Schema.SObjectType.Documento_Relacionado__c.fields.Id.isAccessible() &&
            Schema.SObjectType.Documento_Relacionado__c.fields.Material__c.isAccessible() &&
            Schema.SObjectType.Documento_Relacionado__c.fields.Tipo_de_Arquivo__c.isAccessible() &&
            Documento_Executivo__c.SObjectType.getDescribe().isAccessible() &&
            Schema.SObjectType.Documento_Executivo__c.fields.Data_Inicio_Publicacao__c.isAccessible()
            ){
                docRelList = [SELECT id, Name,Documento_Executivo__r.Data_Inicio_Publicacao__c,CreatedDate FROM Documento_Relacionado__c 
                                                        WHERE Material__c IN: productList 
                                                        AND Tipo_de_Arquivo__c IN: tiposDeArquivosList];
            } else{
                System.debug('Permission Issue: Query Documento Relacionado');
                System.debug(Documento_Relacionado__c.SObjectType.getDescribe().isAccessible());
            System.debug(Schema.SObjectType.Documento_Relacionado__c.fields.Name.isAccessible());
            System.debug(Schema.SObjectType.Documento_Relacionado__c.fields.Id.isAccessible());
            System.debug(Schema.SObjectType.Documento_Relacionado__c.fields.Material__c.isAccessible());
            System.debug(Schema.SObjectType.Documento_Relacionado__c.fields.Tipo_de_Arquivo__c.isAccessible());
            System.debug(Documento_Executivo__c.SObjectType.getDescribe().isAccessible());
            System.debug(Schema.SObjectType.Documento_Executivo__c.fields.Data_Inicio_Publicacao__c.isAccessible());
                
                
            }
        
        Set<String> docRelNamesSet = new Set<String>();

        for(Documento_Relacionado__c doc : docRelList){

            if(doc.Documento_Executivo__r.Data_Inicio_Publicacao__c != null && doc.Documento_Executivo__r.Data_Inicio_Publicacao__c > yesterday){
                docRelNamesSet.add(doc.Name);
            } else if(doc.Documento_Executivo__r.Data_Inicio_Publicacao__c == null && doc.CreatedDate > yesterday){
                docRelNamesSet.add(doc.Name);
            }

        }

        List<String> docRelNamesList = new List<String>();

        docRelNamesList.addAll(docRelNamesSet);

        return docRelNamesList;


        /*
        DateTime yesterday = DateTime.now().addDays(-1);
        List<Documento_Executivo__c> documentos = [SELECT Id, Name, LastModifiedDate 
                                                  FROM Documento_Executivo__c 
                                                  WHERE LastModifiedDate > :yesterday]; 
        
        Set<String> names = new Set<String>();
        List<String> namesList = new List<String>();

        
        for (Documento_Executivo__c docs : documentos){
        	names.add(docs.Name);    
        }
        
        namesList.addAll(names);
        return namesList;

        */

        
    }
}