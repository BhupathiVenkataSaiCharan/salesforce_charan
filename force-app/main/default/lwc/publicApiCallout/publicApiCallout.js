import { LightningElement, track } from 'lwc';

export default class PublicApiCallout extends LightningElement {
    @track data;
    endpoint = 'https://h9qp3tzr-3001.inc1.devtunnels.ms/';
    // endpoint = 'https://www.boredapi.com/api/activity';        
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
                // Handle the response data here
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
