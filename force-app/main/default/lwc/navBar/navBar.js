import { LightningElement } from 'lwc';
import {NavigationMixin} from "lightning/navigation";

export default class NavBar extends NavigationMixin(LightningElement) {

    
    navigateToPages(event){
        const button=event.target;
        console.log(button.name);
        this.navigateTo(button.name)
    }
    
    
    
    navigateTo(pageName){
        this[NavigationMixin.Navigate]({
            type:'comm__namedPage',
            attributes:{
                name:pageName
            }
        });
    }

    menuClickHandler(){
        var navBarBlock=this.template.querySelector('.nav-bar');
        console.log('menuClickHandler. navBarBlock: ',navBarBlock.classList);
        // navBarBlock.classList.add('active')
        
        if(navBarBlock.classList.contains('active')){
            console.log('menu active');
            navBarBlock.classList.remove('active') 
            console.log('menuClickHandler. menuActive: ',navBarBlock.classList);
        }else{
            console.log('menu inactive');
            navBarBlock.classList.add('active')
            console.log('menuClickHandler. menuActive: ',navBarBlock.classList);
        }
    }
}