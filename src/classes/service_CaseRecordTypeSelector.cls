public class service_CaseRecordTypeSelector {

    Public String recordTypeId ;
    
    public static RecordType selectRecordType(String recordTypeName){
    recordTypeName=recordTypeName;   
    recordType recordTypeId;
    RecordType Family =  [SELECT Id, Name FROM recordType WHERE Name = 'Family Case' AND sObjectType = 'Case' LIMIT 1];
    RecordType Professional = [SELECT Id, Name FROM recordType WHERE Name = 'Professional Case' AND sObjectType = 'Case' LIMIT 1];
    RecordType Intakesurvey = [SELECT Id, Name FROM recordType WHERE Name = 'Intake Survey' AND sObjectType = 'Case' LIMIT 1];
    RecordType SW = [SELECT Id, Name FROM recordType WHERE Name = 'SW Family Assessment' AND sObjectType = 'Case' LIMIT 1];
    return recordTypeId;
    }
}