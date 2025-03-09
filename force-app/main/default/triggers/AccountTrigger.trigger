trigger AccountTrigger on Account (before update ,after update , after insert,before insert) {
    if( trigger.isbefore && trigger.isupdate){
        AccountHandler.beforeupdate(trigger.new , trigger.oldmap);
    }
    if( trigger.isafter && trigger.isupdate){
        AccountHandler.afterupdate(trigger.new , trigger.oldmap);
    }
    if( trigger.isafter && (trigger.isupdate || trigger.isinsert)){
        AccountHandler.ContactCreation(trigger.new);
    }
    if( trigger.isafter && trigger.isupdate){
        AccountHandler.Contactupdate(trigger.new , trigger.oldmap);
    }
    if( trigger.isafter && trigger.isupdate){
        AccountHandler.Contactupdate(trigger.new , trigger.oldmap);
    }
    if( trigger.isbefore && (trigger.isupdate || trigger.isinsert)){
        AccountHandler.AccountValidation(trigger.new , trigger.oldmap);
    }
    if( trigger.isafter && (trigger.isupdate || trigger.isinsert)){
        AccountHandler.ContactCreationlatest(trigger.new,trigger.oldmap);
    }
}