/*Auother :  Abhijeet Deshmukh */
public class AccountHandler {
    public static void beforeupdate(List<Account> acclist , Map<Id,Account> oldmap){
        if(!acclist.isEmpty()){
            System.debug('The Accountlist:'+acclist);
            for(Account acc : acclist){
                if(acc.Industry == 'Agriculture' && acc.Type == 'Prospect'){
                    if((oldmap.get(acc.Id).Ownership != acc.Ownership)&& acc.Ownership =='Private'){
                        acc.adderror('You cant chnage the ownership'); 
                    }
                }
            }
        }
    }
    public static void afterupdate (List <Account> acclist , Map <Id, Account> oldmap){
        Map<Id,String> accountmap = new Map<Id,String>();
        if(!acclist.isEmpty()){
            for(Account acc : acclist){
                if(acc.Website !=null && (oldmap.get(acc.Id).Website != acc.Website)){
                    Accountmap.put(acc.Id , acc.Website);  
                }
            }
        }
        if(!accountmap.isEmpty()){
            List<Contact> updateContactList = new List<Contact>();
            List<Contact> ConList =[Select id, description, AccountId  from Contact where AccountId IN :accountmap.keyset()];
            if(!ConList.isEmpty()){
                for(Contact con : ConList){
                    con.description = accountmap.get(con.AccountId);
                    updateContactList.add(con);
                }
            }
            try{
                if(!updateContactList.isEmpty()){
                    update updateContactList;
                }
            }
            catch (DmlException e) {
                System.debug('Error: ' + e.getMessage());
            }
        }
    }
    public static void ContactCreation(List<Account> acclist){
        List<Contact> Conlistnew = new List<Contact>();
        if(!acclist.isEmpty()){
            for(Account acc: acclist){
                for(Integer i = 0 ; i< acc.N_Contacts__c ;i++){
                    Contact con = new contact();
                    con.LastName = acc.Name;
                    con.AccountId = acc.Id;
                    Conlistnew.add(con);
                }
            }
        }
        try{
            if(!Conlistnew.isEmpty()){
                insert Conlistnew;
            }
        }
        catch(DmlException e){
            System.debug('Error: ' + e.getMessage());
        }
    }
    public static void Contactupdate(List<Account> acclist , Map <Id,Account> oldmap){
        Map<Id,Account> accmap = new Map<Id,Account>();
        if(!acclist.isEmpty()){
            for(Account acc: acclist){
                if(acc.Phone != null && (acc.Phone != oldmap.get(acc.Id).Phone)){
                    accmap.put(acc.Id , acc);
                }
            }
        }
        if(!accmap.isEmpty()){
            List<Contact> updateContactList = new List<Contact>();
            for(Contact con:[select id, AccountId,Phone from contact where AccountId IN : accmap.keyset()]){
                if(accmap.containskey(con.AccountId)){
                    con.Phone = accmap.get(con.AccountId).Phone;
                    updateContactList.add(con);
                }
            }
            try{
                if(!updateContactList.isEmpty()){
                    update updateContactList;
                }
            }
            catch(DMLException e){
                System.debug('The exception:'+e.getmessage());
            }
        }
    }
    public static void AccountValidation(List<Account> acclist, Map<Id, Account> oldmap) {
    Set<String> accountNames = new Set<String>();

    // Collect account names that have been changed
    if (!acclist.isEmpty()) {
        for (Account acc : acclist) {
            if (acc.Name != null &&  (oldmap == null ||acc.Name != oldmap.get(acc.Id)?.Name)) {
                accountNames.add(acc.Name);
            }
        }
    }

    if (!accountNames.isEmpty()) {
        // Query existing accounts with the same names
        Map<String, Account> existingAccounts = new Map<String, Account>();
        for (Account acc : [SELECT Id, Name FROM Account WHERE Name IN :accountNames]) {
            existingAccounts.put(acc.Name, acc);
        }

        // Validate against existing accounts
        for (Account acc : acclist) {
            if (existingAccounts.containsKey(acc.Name)) {
                acc.addError('An account with this name already exists. Please use a different name.');
            }
        }
    }
}
    public static void ContactCreationlatest(List <Account> acclist , Map<Id,Account> oldmap){
        list<Contact> conlist = new list<Contact>();
        if(!acclist.isEmpty()){
            for(Account acc : acclist){
                if(acc.Create_Contact__c != null && acc.Create_Contact__c == true && (oldmap == null || acc.Create_Contact__c != oldmap.get(acc.Id).Create_Contact__c)){
                    Contact con = new Contact ();
                    con.LastName = acc.name;
                    con.AccountId = acc.Id;
                    conlist.add(con);
                }
            }
        }
        try{
            if(!conlist.isEmpty()){
                insert conlist;
            }
        }
        catch(DmlException e){
            System.debug('The exception:'+ e.getmessage());
        }
    } 

}