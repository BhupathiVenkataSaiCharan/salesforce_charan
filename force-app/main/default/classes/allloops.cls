public class allloops {
	
    
    public static void addList(){
        
        List<integer> addNum = new List<integer>();
        
        for(integer x=1;x<=100;x++){
            addNum.Add(x);
            system.debug('total values inside list are' +addNum.size());
        }
        
        for(integer x=0;x<addNum.size();x++){
            system.debug('index ::: '+x + 'value ::: '+addNum.get(x));
        }
    }
    
    
    
    /*
    public static void forloop(){
        
        for(integer x=1;x<=15;x++){
            
            system.debug('forloop values === '+x);
        }
    }
    */
    
    /*
    public static void whileexm(){
        
        integer x=2;
        while(x<20)
        {
            system.debug(x);
            x++;
        }
    }
    */
    
    
    /* do-while
    public static void dowhile(){   
        
		integer x=1;
        
        do{
            system.debug(x);
            x++;
        }
        while(x<100);
    }
		*/
}