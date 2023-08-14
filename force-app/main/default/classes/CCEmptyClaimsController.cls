public with sharing class CCEmptyClaimsController {
    
    @AuraEnabled(cacheable = true)
    public static Case getClaims(){
        return [Select id from Case where Status <> 'Cancelada' and Status <> 'Closed' Limit 1];
    }


}