public with sharing class accountsListforAura {
    
    @AuraEnabled
    public static PaginationResult accListData(Integer pageSize, Integer pageNumber,String searchKeyword) {
        PaginationResult result = new PaginationResult();
        System.debug('searchKeyword' +searchKeyword);
        
            Integer offset = Math.max(0, (pageNumber - 1) * pageSize);
            System.debug('offset value: ' + offset);

            //to search records
            String searchQuery = '%'+ String.escapeSingleQuotes(searchKeyword) +'%';

            String queryCount = 'SELECT COUNT() FROM Account WHERE Name LIKE :searchQuery';
            String query = 'SELECT Id,Name FROM Account WHERE  Name LIKE :searchQuery ORDER BY Name ASC LIMIT :pageSize OFFSET :offset';

            Integer totalCount = Database.countQuery(queryCount);
            System.debug('total records: ' + totalCount);
            
            List<Account> accList = Database.query(query);
            System.debug('number of records: ' + accList.size());
            System.debug('account list: ' + accList);
            
            result.accounts = accList;
            result.totalCount = totalCount;
            return result;
    }

    @AuraEnabled
    public static string deleteRecord(String recordId){
        System.debug('deleting record... '+recordId);
        String result = '';
        try {
            Database.DeleteResult sr =  Database.delete(recordId);
            if (sr.isSuccess()) {
                result = sr.getId();
            }else {
                system.debug('Error');
                //result = sr.getErrors().toString();
            }
        }catch(exception de){
            result = de.getMessage();
        }
       
        return result;
    }

    public class PaginationResult {
        @AuraEnabled public List<Account> accounts { get; set; }
        @AuraEnabled public Integer totalCount { get; set; }
    }
}