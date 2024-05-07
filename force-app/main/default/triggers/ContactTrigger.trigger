trigger ContactTrigger on Contact (before insert) {
    switch on trigger.OperationType{
        when BEFORE_INSERT{

            //to check for email and phone field duplicates

            Set<String> emailSet = new Set<String>();
            Set<String> phoneSet = new Set<String>();
            List<Contact> dupPhoneEmails=[SELECT Phone,Email from Contact where email!=null or phone!=null];
            for(Contact conRecord : dupPhoneEmails){
                emailSet.add(conRecord.Email);
            }
            for(Contact conRecord : dupPhoneEmails){
                phoneSet.add(conRecord.Phone);
            }
            for(Contact con: trigger.new){
                if(emailSet.contains(con.Email) || phoneSet.contains(con.Phone)){
                    con.addError('duplicate email or phone found');
                }
            }
        }
        when AFTER_INSERT{}
    }
}