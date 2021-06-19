trigger InstanceTrigger on Instance__c (after insert, after update, after delete) {
    if(Trigger.isAfter){
        if(Trigger.isInsert)
            InstanceTriggerHandler.InsertInstance(Trigger.new);

        if(Trigger.isUpdate)
            InstanceTriggerHandler.UpdateInstance(Trigger.newMap, Trigger.oldMap);

        if(Trigger.isDelete)
            InstanceTriggerHandler.DeleteInstance(Trigger.old);
    }
}