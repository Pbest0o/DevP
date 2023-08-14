import { LightningElement,wire,api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import getMaterials from '@salesforce/apex/CCPriceTableViewController.getMaterials';
import getValidity from '@salesforce/apex/CCPriceTableViewController.getValidity';
import downloadFile from '@salesforce/apex/CCPriceTableViewController.downloadFile';

export default class PriceTableView extends NavigationMixin(LightningElement) {
    
    @api tiposDeArquivosParam;
    selectedMaterial;
    materialsMap;
    materials;
    errorGetMaterials;
    validity;
    downloadFileList;
    multipleDownloadFiles = false;
    fileName;
    disabledPeriodo = true;
    disabledConsultar = true;
    


    @wire(getMaterials,{tiposDeArquivos: '$tiposDeArquivosParam' }) 
    material({ error, data }) {
        if (data) {
            this.materials = data;
        } else if (error) {
            this.errorGetMaterials = error;
        }
    }

    selectValidity(event){

        if(event.target.value == ''){
            this.disabledPeriodo = true;
            this.disabledConsultar = true;
            this.template.querySelector("select[data-my-id=periodo]").value = '';
        } else{
            getValidity({nomeDoArquivo : event.target.value, tiposDeArquivos: this.tiposDeArquivosParam}).then((result) =>{
                this.multipleDownloadFiles = false;
                this.validity = result;
                this.disabledPeriodo = false;
            }
            ).catch((error) =>{
                
            });
        }
        
    }

    actionDownloadFile(event){
        this.fileName = this.template.querySelector("select[data-my-id=arquivos]").value;
        
        downloadFile({nomeDoArquivo: this.template.querySelector("select[data-my-id=arquivos]").value, 
                    periodo: this.template.querySelector("select[data-my-id=periodo]").value,
                    tiposDeArquivos: this.tiposDeArquivosParam}).then((result) => {

                        

                        if(result.length == 1){
                            const config = {
                                type: 'standard__webPage',
                                attributes: {
                                    url: result[0].Arquivo__c
                                }
                            };
                            this[NavigationMixin.Navigate](config);
                        } else if(result.length > 1){
                            console.log('Mais de um arquivo');
                            this.multipleDownloadFiles = true;
                            this.downloadFileList = result;
                        }
                        
                        
                        
                    }).catch((error) => {
                        console.log('donwload error');
                    });

                }

        changeValidity(event){
            if(event.target.value == ''){
                this.disabledConsultar = true;
            } else{
                this.multipleDownloadFiles = false;
                this.disabledConsultar = false;
            }
            
            
        }
    
}