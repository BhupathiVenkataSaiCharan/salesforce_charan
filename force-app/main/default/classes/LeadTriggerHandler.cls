public class LeadTriggerHandler {
    
    // check for duplicate records in lead based on email and name

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

    // when lead source is web then rating is cold or else hot
    public static void leadSourceBasedRating(List<Lead> ldList){
        for(Lead ld : ldList){
            if(ld.LeadSource == 'Web'){
                ld.Rating = 'Cold';
            }else{
                ld.Rating = 'Hot';
            }
        }
    }

}