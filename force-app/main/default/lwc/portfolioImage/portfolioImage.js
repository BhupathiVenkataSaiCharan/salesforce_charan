import { LightningElement } from 'lwc';
import image from '@salesforce/resourceUrl/test_img';           //to get image from static resource

export default class PortfolioImage extends LightningElement {

    testimg = image;        //binding image from static resource

}