public class collections {
	
    public static void listCollections(){
        
        List<integer> newList = new List<integer>();
    
    	newList.add(30);
    	newList.Add(20);
    	newList.Add(10);
    	newList.Add(15);
    	newList.Add(25);
        
        system.debug('Items in the list are --- '+newList);
        
        integer size=newList.size();
        system.debug('size of the list --- '+size);
        
        integer indexval=newList.get(2);
        system.debug('number in 2nd index --- '+indexval);
    }
    
}