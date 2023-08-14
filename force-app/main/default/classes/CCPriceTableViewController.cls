public without sharing class CCPriceTableViewController {

    @AuraEnabled(cacheable = true)
    public static List<String> getMaterials(String tiposDeArquivos){
	  
        List <String> tiposDeArquivosList = new List <String>();
        User currentUser;
        String products;
        List <String> productList = new List<String>();
        List <Documento_Relacionado__c> docRelList = new List<Documento_Relacionado__c>();
        

        if(!String.isBlank(tiposDeArquivos)){
            tiposDeArquivosList = tiposDeArquivos.split(',');
        }

        if(User.SObjectType.getDescribe().isAccessible() && 
            Schema.SObjectType.User.fields.Produtos__c.isAccessible() &&
            Schema.SObjectType.User.fields.Id.isAccessible() ){

            currentUser = [Select Produtos__c from User where id =:UserInfo.getUserId()];
            products = currentUser.Produtos__c;

        } else{
            System.debug('Permission Issue: User Query');
            System.debug(User.SObjectType.getDescribe().isAccessible());
            System.debug(Schema.SObjectType.User.fields.Produtos__c.isAccessible());
            System.debug(Schema.SObjectType.User.fields.Id.isAccessible());
            
        }
        
        if(!String.isBlank(products)){
            productList = products.split(',');
        }

        return getDocumentoRelacionadoList(tiposDeArquivosList,productList);

        
    }

	@AuraEnabled(cacheable = true)
    public static List<String> getValidity(String nomeDoArquivo, String tiposDeArquivos){
        List <String> tiposDeArquivosList = new List<String>();
        List <String> listVigencias;
        Set <String> setVigencias = new Set<String>();
        User currentUser;
        String products;

        currentUser = [Select Produtos__c from User where id =:UserInfo.getUserId()];

        products = currentUser.Produtos__c;

        List <String> productList = new List<String>();
        

        if(!String.isBlank(products)){
            productList = products.split(',');
        }

        if(!String.isBlank(tiposDeArquivos)){
            tiposDeArquivosList = tiposDeArquivos.split(',');
        }

        System.debug('Nome do Arquivo: ' + nomeDoArquivo);
        System.debug('Produtos: ' + productList);
        System.debug('Tipo de Arquivo: ' + tiposDeArquivosList);
        
        for(Documento_Relacionado__c vigencia : [Select Periodo__c from Documento_Relacionado__c 
                                                 where Name =: nomeDoArquivo and 
                                                 Material__c IN: productList and
                                                 Tipo_de_Arquivo__c IN: tiposDeArquivosList order by Periodo__c asc]){
            setVigencias.add(vigencia.Periodo__c);  
        }

        listVigencias = new List<String>(setVigencias);
        
        return listVigencias;  
    }

	@AuraEnabled(cacheable = true)
    public static List<Documento_Relacionado__c> downloadFile(String nomeDoArquivo, String periodo, String tiposDeArquivos){
        List <String> tiposDeArquivosList = new List<String>();
        List <Documento_Relacionado__c> docsRelacionadosList = new List<Documento_Relacionado__c>();
        User currentUser;
        String products;
        
        currentUser = [Select Produtos__c from User where id =:UserInfo.getUserId()];
        
        products = currentUser.Produtos__c;
        String downloadURL;

        List <String> productList = new List<String>();
        
        if(!String.isBlank(products)){
            productList = products.split(',');
        }

        if(!String.isBlank(tiposDeArquivos)){
            tiposDeArquivosList = tiposDeArquivos.split(',');
        }

        
        if(!productList.isEmpty()){
            docsRelacionadosList = [Select Arquivo__c from Documento_Relacionado__c where
                                   Name =: nomeDoArquivo and
                                   Periodo__c =: periodo and
                                   Material__c IN: productList and
                                   Tipo_de_Arquivo__c IN: tiposDeArquivosList];
        }

    	return docsRelacionadosList;
    }

    private static List<String> getDocumentoRelacionadoList(List <String> tiposDeArquivosList,
                                                                List <String> productList)
    {
        DateTime today = DateTime.now();
        List <Documento_Relacionado__c> docRelList = new List <Documento_Relacionado__c>();
        Set <String> docRelNameSet = new Set <String>();
        List <String> docRelNameList = new List <String>();

        if(Documento_Relacionado__c.SObjectType.getDescribe().isAccessible() && 
            Schema.SObjectType.Documento_Relacionado__c.fields.Name.isAccessible() &&
            Schema.SObjectType.Documento_Relacionado__c.fields.Id.isAccessible() &&
            Schema.SObjectType.Documento_Relacionado__c.fields.Material__c.isAccessible() &&
            Schema.SObjectType.Documento_Relacionado__c.fields.Tipo_de_Arquivo__c.isAccessible()
            ){
                if(!productList.isEmpty() && !tiposDeArquivosList.isEmpty()){
                    
                    docRelList = [SELECT id, Name,Documento_Executivo__r.Data_Inicio_Publicacao__c 
                                                        FROM Documento_Relacionado__c 
                                                        WHERE Material__c IN: productList 
                                                        AND Tipo_de_Arquivo__c IN: tiposDeArquivosList
                                 						AND (Documento_Executivo__r.Data_Inicio_Publicacao__c = null
                                 						OR Documento_Executivo__r.Data_Inicio_Publicacao__c <= today)];
                    
                    for(Documento_Relacionado__c doc : docRelList ){
                    	docRelNameSet.add(doc.Name);
                    }
                        
                    
                } else{
                    System.debug('Empty Parameters - Product or File Type');    
                }
                
            } else{
                System.debug('Permission Issue: Query Documento Relacionado');
            }

        	
            docRelNameList.addAll(docRelNameSet);
			
            return docRelNameList;
    }

}