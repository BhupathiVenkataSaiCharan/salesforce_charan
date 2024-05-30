trigger practice on Account (before insert, after insert, before update, before delete) {
    switch on trigger.OperationType{
        when BEFORE_INSERT{
        //     for(Account acc:trigger.new){
        //         if(acc.Phone == null){
        //             acc.Phone.addError('phone is mandatory');
        //         }
        //     }
        }
        when AFTER_INSERT{

            // create a contact associated with account is account industry is banking

            // List<Contact> conList=new List<Contact>();
            // for(Account acc: trigger.new){
            //     if(acc.Industry=='Banking'){
            //         Contact con=new Contact(
            //         LastName=acc.Name,
            //         AccountId=acc.Id
            //         );
            //         conList.add(con);
            //     }
            // }
            // insert conList;
            
            
            
            
            //create a contact when account is created and
            
            // List<Contact> conList = new List<Contact>();
            // for(Account acc:trigger.new){
            //     Contact con=new Contact(
            //         LastName=acc.Name,
            //         Description=acc.Description
            //     );
            //     conList.add(con);
            // }
            // insert conList;

        }
        when BEFORE_UPDATE{
        //     for(Account acc:trigger.new){
        //         if(acc.Industry==null){
        //             acc.Rating='low';
        //         }
        //     }
        }
        when BEFORE_DELETE{
        //     for(Account acc: trigger.old){
        //         if(acc.Rating=='hot'){
        //             acc.addError('you cannot delete accounts with rating hot');
        //         }
        //     }
        }
    }
}