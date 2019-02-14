public class MetaData_Report {

    public List<SelectOption> measureOptions { get; set; }
    
    public Id measure { get; set; }
    
    public sObject sObjectToBind {get;set;}
    public List<String> listObjectFields {get;set;}
    

    
    public List<SelectOption> getMeasures() {
        List<SelectOption>  measures = new List<SelectOption>();
        
        for (CMS_FYE__mdt options : [select Id, MasterLabel
                                      FROM CMS_FYE__mdt Limit 10
                                     ])
            measures.add(new SelectOption(options.Id, options.MasterLabel)); 
        
        
        return measures;
        
    }
    public PageReference findSelected()   {
        system.debug('measure ' + this.measure);
        return null;
    }   
    
    
    public Id getMeasure() {
        //system.debug('pickUser ' + pickUser)
        return Measure;
    }
    
    public void setMeasure(Id u) {
        system.debug('u ' + u);
        this.measure = u;
        
    }  
    
    public static Boolean checkObjectType(String objectname) {
        List<CMS_FYE__mdt> measures = [select Id, MasterLabel FROM CMS_FYE__mdt Limit 20
                                      ];
        system.debug('measures ' + measures);
        SObjectType objToken = Schema.getGlobalDescribe().get(objectname);
        Schema.SObjectType sObj = Schema.getGlobalDescribe().get(objectName);
        System.debug('sObj ' + sObj);
        String selectedObject = objectname;
        Map<String, Schema.SObjectType> gdMap = Schema.getGlobalDescribe();
        Schema.Describesobjectresult dsr = gdMap.get(selectedObject).getDescribe();
        Map<String, Schema.SObjectField> fieldMap = dsr.fields.getMap();
        
       
        List<SelectOption> soList = new List<SelectOption>();
        for(String key : fieldMap.keySet()) {
            soList.add(new SelectOption(key, key)); //.replace('__mdt', '').replace('_', ' ')));
        }
        system.debug('soList ' + soList);
        /*
objToken measure = [select Id, MasterLabel, youngestAge__c, 
oldestAge__c, createdByCM__c, HMG__c, CMS_Name__c, Target_Duplicated_Contacts__c,
Target_Unduplicated_Contacts__c, Target_Unduplicated_Meetings__c,includePMP__c, 
InteractionId__c, Measure_Number__c, Total__c
FROM CMS_FYE__mdt WHERE DeveloperName = :reportType LIMIT 1
];*/
        
        if(objToken  != null && objToken.getDescribe().isCustom()) {
            return true;
        } else {
            return false;
        }
    }
}

/*public static List<SObject> createBookingMapping(Booking book) {
List<SObject> bookingObjects = new List<SObject>();
SObject bookingObject;
List<Booking_Mapping__mdt> mappings = getActiveBookingRecords();
Map<String, Object> bookingMap;

for(Booking_Mapping__mdt m : mappings) {
bookingMap = deserializeMapping(m);
bookingObject = Schema.getGlobalDescribe().get(m.API_Name__c).newSObject();
Schema.SobjectType bookingObjType = bookingObject.getSObjectType();
Map<String, Schema.SObjectField> bookingObjectFieldMap = bookingObjType.getDescribe().fields.getMap();
for(String s : bookingMap.keyset()) {
Object val = (Object)book.get((String)bookingMap.get(s));
assignFieldVal(bookingObjectFieldMap, bookingObject, s, val);
}
bookingObjects.add(bookingObject);
}
return bookingObjects;
}*/