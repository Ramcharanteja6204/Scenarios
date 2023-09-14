trigger UpdateAccFieldOnConDML on Contact (after insert,after update,after delete,after undelete) {
    Set<Id> accIds = new Set<Id>();
    if (Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) {
        for (Contact contact : Trigger.new) {
            if(contact.AccountId != Null){
                accIds.add(contact.AccountId);
            }
        }
    }
    if (Trigger.isDelete) {
        for (Contact contact : Trigger.old) {
            if(contact.AccountId != Null){
                accIds.add(contact.AccountId);
            }
        }
    }
    List<Account> accountsToUpdate = new List<Account>();
    Map<Id, Integer> accountIdToConMap = new Map<Id, Integer>();
    for (AggregateResult result : [SELECT AccountId, COUNT(Id) contactCount
                                        FROM Contact
                                        WHERE AccountId IN :accIds
                                        GROUP BY AccountId]) {
            Id accountId = (Id)result.get('AccountId');
            Integer contactCount = (Integer)result.get('contactCount');
            accountIdToConMap.put(accountId, contactCount);
        }
    for(Id acId : accountIdToConMap.keySet()){
        Account ac = new Account();
        ac.Id = acId;
        ac.Number_Of_Contacts__c = accountIdToConMap.get(acId)!=Null?accountIdToConMap.get(acId):0;
        accountsToUpdate.add(ac);
    }
    if(!accountsToUpdate.isEmpty()){
        upsert accountsToUpdate;
    }
}