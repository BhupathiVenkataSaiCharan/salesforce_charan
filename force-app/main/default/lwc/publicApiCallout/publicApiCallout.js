import { LightningElement, track } from 'lwc';

export default class PublicApiCallout extends LightningElement {
    @track data;
    endpoint = 'https://7wd3dznw-3000.inc1.devtunnels.ms/';          //my api url
    // endpoint = 'https://www.boredapi.com/api/activity';                 //url from scenarios blog
    @track isLoading = false;

    showAPIData() {
        this.isLoading = true;
        this.makePostApiCall();
    }

    async makePostApiCall() {
        try {
            const response = await fetch(this.endpoint, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json'
                }
            });

            if (response.ok) {
                const responseData = await response.json();
                console.log('Success:', responseData);
                this.data = responseData;
                this.isLoading = false;
            } else {
                console.error('Error:', response.statusText);
                this.isLoading = false;
            }
        } catch (error) {
            console.error('Error:', error);
            this.isLoading = false;
        }
    }
}
