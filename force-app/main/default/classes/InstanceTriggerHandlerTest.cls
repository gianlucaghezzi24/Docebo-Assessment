@isTest public class InstanceTriggerHandlerTest {
	@isTest static void test(){
        Account acc = new Account(Name = 'DOCEBO');
        insert acc;
        Id recordType = Schema.SObjectType.Instance__c.getRecordTypeInfosByName().get('Standard Instance').getRecordTypeId();
        Instance__c ins1 = new Instance__c(Name = 'test 1', RecordTypeId = recordType, Account__c = acc.Id, Licenses__c = 3);
        insert ins1;
        acc = [SELECT Id, Total_Licenses__c FROM Account WHERE ID =: acc.Id];
        system.assertEquals(3, acc.Total_Licenses__c);
        Instance__c ins2 = new Instance__c(Name = 'test 2', RecordTypeId = recordType, Account__c = acc.Id, Licenses__c = 5);
        insert ins2;
        acc = [SELECT Id, Total_Licenses__c FROM Account WHERE ID =: acc.Id];
        system.assertEquals(8, acc.Total_Licenses__c);
        ins1.Licenses__c = 6;
        update ins1;
        acc = [SELECT Id, Total_Licenses__c FROM Account WHERE ID =: acc.Id];
        system.assertEquals(11, acc.Total_Licenses__c);
        delete ins2;
        acc = [SELECT Id, Total_Licenses__c FROM Account WHERE ID =: acc.Id];
        system.assertEquals(6, acc.Total_Licenses__c);
    }
}