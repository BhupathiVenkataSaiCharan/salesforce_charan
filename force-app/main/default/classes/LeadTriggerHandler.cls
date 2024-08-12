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

    // chekc for duplicate records in lead based on email and name

    public static void checkDuplicateNameEmail(List<Lead> ldList){

        List<Lead> existingLeads = [SELECT Id,LastName,Email FROM Lead WHERE Email != null];
        Set<String> names = new Set<String>();
        Set<String> emails = new Set<String>();

        for(Lead ld : existingLeads){
            names.add(ld.LastName);
            emails.add(ld.Email);
        }

        for(Lead ld : ldList){
            if(names.contains(ld.LastName) || emails.contains(ld.Email)){
                ld.addError('Duplicate value exists');
            }
        }
    }

}