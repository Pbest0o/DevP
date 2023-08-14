import { LightningElement , wire,api} from 'lwc';
import getDocumentosExecutivosAtualizados from '@salesforce/apex/PriceAlertsController.getDocumentosExecutivosAtualizados';


export default class PriceAlerts extends LightningElement {
		documentos = [];
		showComponent = false;

    @api tiposDeArquivosParam;
    @wire(getDocumentosExecutivosAtualizados,{tiposDeArquivos: '$tiposDeArquivosParam' })
    wiredDocumentos({ error, data }) {
        if (data) {
						console.log('data:', data);
						if (data.length == 0){
								this.showComponent = false;
						} else {
							 this.showComponent = true;
		
						}

            this.documentos = data;
        } else if (error) {
						console.log('error:', error);
            console.error(error);
        }
    }

    get namesJoinedByComma() {
        return this.documentos.map(record => record).join(', ');
    }
}