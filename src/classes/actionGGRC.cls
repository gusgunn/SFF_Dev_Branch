public class actionGGRC {
    
    
    public static boolean noRepeats = false;
    public static Integer Count =0;
    
    public static List<Action__c> checkGGRConInsert(List<Action__c> newList){
        for(Action__c a : newList){
            if (a.Action_Detail_Type_External_Referral__c != Null && a.Action_Detail_Type_External_Referral__c.contains('GGRC POS')){
                a.GGRC_Pos__c = true;
            }
        }
        noRepeats = true;
        return newList;
    }
    
    public static List<Action__c> checkGGRConUpdate(List<Action__c> newList, Map<ID, Action__c> oldAction){
        if(oldAction != Null){
            for(Action__c a : newList){
                if (a.Action_Detail_Type_External_Referral__c != Null && a.Action_Detail_Type_External_Referral__c.contains('GGRC POS')){
                    
                    Boolean oldBox =  oldAction.get(a.Id).GGRC_Pos__c;
                    if(oldBox == false) a.GGRC_Pos__c=true;
                } else if (a.Action_Detail_Type_External_Referral__c != Null && !a.Action_Detail_Type_External_Referral__c.contains('GGRC POS') && oldAction.get(a.Id).GGRC_Pos__c == true){
                    a.GGRC_Pos__c=false;
                }
            }
        }
        noRepeats = true;
        return newList;   
    }
    
}