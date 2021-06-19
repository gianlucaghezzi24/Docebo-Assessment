public class InstanceTriggerHandler {
    
    public static void insertInstance(List<Instance__c> new_List){
        List<Id> acc_List = new List<Id>();
        Map<Id,Account> acc_Map = new Map<Id,Account>();
        List<Account> toUpdate_List = new List<Account>();
		
        //creo una lista di AccountId per orgni Instance
        for(Instance__c newIns : new_List)
            acc_List.add(newIns.Account__c);

        //associo ogni AccountId all'oggetto Account
        for(Account a : [SELECT Id, Total_Licenses__c FROM Account WHERE Id =: acc_List])
            acc_Map.put(a.Id, a);

        //recupero l'Account associato ad ogni Instance, modifico Total_Licenses__c e faccio l'update dell'Account
        for(Instance__c newIns : new_List){            
            if(newIns.Type__c == 'Standard Instance'){
                Account acc = acc_Map.get(newIns.Account__c);
    
                if(acc.Total_Licenses__c == null)
                    acc.Total_Licenses__c = 0;
                
                acc.Total_Licenses__c += newIns.Licenses__c;
                toUpdate_List.add(acc);
            }
        }
        update toUpdate_List;
    }
    
    //per gestire l'update utilizzo le mappe in modo da calcolare la differenza tra il vecchio e il nuovo valore di Licenses__c della stessa Instance
    public static void updateInstance(Map<Id,Instance__c> new_Map, Map<Id,Instance__c> old_Map){
        List<Id> acc_List = new List<Id>();
        Map<Id,Account> acc_Map = new Map<Id,Account>();
        List<Account> toUpdate_List = new List<Account>();
		
        for(Instance__c newIns : new_Map.values())
            acc_List.add(newIns.Account__c);

        for(Account a : [SELECT Id, Total_Licenses__c FROM Account WHERE Id =: acc_List])
            acc_Map.put(a.Id, a);
        
        //recupero l'Account e l'Instance vecchia associati ad ogni Instance nuova, calcolo la differenza tra il vecchio e il nuovo valore di Licenses__c, modifico Total_Licenses__c e faccio l'update dell'Account
        for(Instance__c newIns : new_Map.values()){
        	if(newIns.Type__c == 'Standard Instance'){
                Account acc = acc_Map.get(newIns.Account__c);
                Instance__c oldIns = old_Map.get(newIns.Id);
                Decimal oldLicenses = oldIns.Licenses__c;
                
                if(acc.Total_Licenses__c == null)
                    acc.Total_Licenses__c = 0;
                
                if(oldLicenses == null)
                    oldLicenses = 0;
                
                Decimal delta = newIns.Licenses__c - oldLicenses;
                acc.Total_Licenses__c += delta;
                toUpdate_List.add(acc);
            }            
        }        
        update toUpdate_List;
    }

    public static void deleteInstance(List<Instance__c> new_List){
        List<Id> acc_List = new List<Id>();
        Map<Id,Account> acc_Map = new Map<Id,Account>();
        List<Account> toUpdate_List = new List<Account>();
		
        for(Instance__c newIns : new_List)
            acc_List.add(newIns.Account__c);

        for(Account a : [SELECT Id, Total_Licenses__c FROM Account WHERE Id =: acc_List])
            acc_Map.put(a.Id, a);

        for(Instance__c newIns : new_List){
            if(newIns.Type__c == 'Standard Instance'){
                Account acc = acc_Map.get(newIns.Account__c);
                
                acc.Total_Licenses__c -= newIns.Licenses__c;
                toUpdate_List.add(acc);
            }
        }
        update toUpdate_List;
    }
}