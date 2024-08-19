import { LightningElement } from 'lwc';
import headerLogo from '@salesforce/resourceUrl/headerLogo';
import background1 from '@salesforce/resourceUrl/background1';

export default class TouristForm extends LightningElement {
    headerLogo = headerLogo;
    value = 'Goa';
    tDate = '';
    tDays = '';
    tPeople = '';

    slide1 = true;
    ifGoa = false;
    ifAndaman = false;
    ifThailand = false;
    ifKorea = false;

    
    options = [
            {label : 'Goa', value : 'Goa'},
            {label : 'Andaman', value : 'Andaman'},
            {label : 'Thailand', value : 'Thailand'},
            {label : 'Korea', value : 'Korea'},
    ];

    get backgroundStyle() {
        switch (this.value) {
            case 'Goa':
              return `background-image: url(${headerLogo})`;
            case 'Andaman':
              return `background-image: url(${background1})`;
            // case 'Thailand':
            //   return `background-image: url(${THAILAND_IMAGE})`;
            // case 'Korea':
            //   return `background-image: url(${KOREA_IMAGE})`;
            // default:
            //   return `background-image: url(${BACKGROUND_IMAGE})`;
          }
    }
    
    handleChange(event){
        const name = event.target.name;
        if(name === 'place'){
            this.value = event.target.value;
            console.log('selected value is:::', this.value);
        }
        if(name === 'traveldate'){
            this.tDate = event.target.value;
            console.log('selected value is:::', this.tDate);
        }
        if(name === 'totaldays'){
            this.tDays = event.target.value;
            console.log('selected value is:::', this.tDays);
        }
        if(name === 'totalpeople'){
            this.tPeople = event.target.value;
            console.log('selected value is:::', this.tPeople);
        }
    }

    handleSubmit(event){
        event.preventDefault();
        this.slide1 = false;
        if(this.value === 'Goa'){
            this.ifGoa = true;
        }
        if(this.value === 'Andaman'){
            this.ifAndaman = true;
        }
        if(this.value === 'Thailand'){
            this.ifThailand = true;
        }
        if(this.value === 'Korea'){
            this.ifKorea = true;
        }

    }
}