public class LeadTriggerHandler {
    
    //when source = web rating = 'cold' else 'hot'
    public static void onLeadSource(List<Lead> ldList){
        for(Lead ld:ldList){
            if(ld.LeadSource == 'web'){
                ld.Rating = 'cold';
            }else{
                ld.Rating = 'hot';
            }
        }
    }
}