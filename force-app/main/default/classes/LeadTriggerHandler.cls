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
    // Prevent creation of leads with duplicate email addresses
    public static void duplicateEmail(List<Lead> ldList) {
        // Step 1: Collect all email addresses from the incoming lead list, ensuring no null values
        Set<String> leadEmails = new Set<String>();
        for (Lead ld : ldList) {
            if (ld.Email != null) {
                leadEmails.add(ld.Email.toLowerCase()); // Use lowercase to ensure case-insensitive comparison
            }
        }

        // Step 2: Query existing leads with matching email addresses
        List<Lead> existingLeads = [SELECT Email FROM Lead WHERE Email IN :leadEmails];
        Set<String> existingEmails = new Set<String>();
        for (Lead existingLead : existingLeads) {
            existingEmails.add(existingLead.Email.toLowerCase());
        }

        // Step 3: Check for duplicates and add errors
        for (Lead ld : ldList) {
            if (ld.Email != null && existingEmails.contains(ld.Email.toLowerCase())) {
                ld.Email.addError('Duplicate email exists');
            }
        }
}

}