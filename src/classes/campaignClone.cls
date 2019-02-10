public class campaignClone {
    
    //2_23_18  Jan18 Novo
    //@gusgunn
    
    public String campaignName {get; set;}
    
    public  String FormCreated {get; set;}
    
    public  DateTime startDateTime {get; set;}
    public  DateTime endDateTime {get; set;}
    public  Integer repeats {get; set;}
    public String clonedCampaign;
    public String clonedCampaignId;
    public String templateSelected {get; set;}
    public String returnedId;
    public Integer maxAdults {get; set;}
    public Integer maxChildren {get; set;}
    public  Integer owned {get; set;}
    public static string editFormID;
    public Static Integer counter =1;
    
    Private static RecordType Program = [Select Id, Name from RecordType where Name = 'Program Campaign' limit 1];
    Private static RecordType Childcare = [Select Id, Name from RecordType where Name = 'Childcare' limit 1];
    
    /*   Private static RecordType Conference = [Select Id, Name from RecordType where Name = 'Conference/Event' limit 1];
Private static RecordType Other = [Select Id, Name from RecordType where Name = 'Other' limit 1];
Private static RecordType SFIN = [Select Id, Name from RecordType where Name = 'SFIN' limit 1];
Private static RecordType Volunteer = [Select Id, Name from RecordType where Name = 'Volunteer' limit 1];
Private static RecordType Deflt = [Select Id, Name from RecordType where Name = 'Default' limit 1]; */
    
    private ApexPages.StandardController sc;
    private campaign myCampaign;
    
    public campaignClone(ApexPages.StandardController sc){
        System.debug('Childcare' + Childcare);
        maxAdults=5;
        maxChildren=5;
        
        
        this.myCAmpaign = (campaign)sc.getRecord();
        System.debug('myCAmpaign=' + myCAmpaign.id);
        
        
        // CloneTemplateToCreateForm();
        this.sc = sc;
        templateSelected = System.currentPageReference().getParameters().get('pid');
        // System.debug('templateSelected' + templateSelected);
        // System.debug('sc= ' + sc);
        
    }
    
    public  Campaign CloneTemplateToCreateForm(){
        String soqlForClone = CloneUtils.getCreatableFieldsSOQL('Campaign', templateSelected);
        //pull al fields desired from template
        Campaign cloneReturned = (Campaign)Database.query(soqlForClone);
        //System.debug('Clone Returned key fields= ' + cloneReturned.F2F__Community_Services__c  + ' & id = ' + cloneReturned.id);
        Campaign clonedRecord = cloneReturned.clone(false, true,false,false);
        //   System.debug('Clone Record key fields= ' + clonedRecord.F2F__Community_Services__c  + ' & id = ' + clonedRecord.id);
        
        return clonedRecord;
        
    }
    
    
    
    public void CloneCampaignSeries (){
        
        //add topics etc to templates
        
        List<Campaign> createClones = new  List<Campaign>();
        String mycampaignID = myCampaign.Id;
        
        String soqlForClone = CloneUtils.getCreatableFieldsSOQL('Campaign', myCAmpaignId);
        Campaign campaignToClone = (Campaign)Database.query(soqlForClone);
        
        
        List<Campaign> deleteCloneOriginal = new List <Campaign>();
        clonedCampaignId = campaignToClone.id;
        deleteCloneOriginal.add(campaignToClone);
        
        
        TimeZone tz = UserInfo.getTimeZone();
        // System.debug('UserInfo= ' + tz);
        Integer currentTz;
        Integer beginZone;
        beginZone =  tz.getOffset(campaignToClone.Start_Date_Time__c);
        // System.debug('tz.getOffset(campaignToClone.Start_Date_Time__c);' + tz.getOffset(campaignToClone.Start_Date_Time__c));
        
        //Offset: -25200000 Offset: -28800000
        Integer  dst = (-25200000);
        Integer winter = (-28800000);
        Integer fallBack = (-1) ;
        Integer springForward = 1 ;
        
        if(beginZone == dst){
            
            //Starts in DST
            // dont add 1 hour
            // and fallback when currentZone= winter (offset ==  -28800000)
        }
        for (Integer j=0;j<campaignToClone.Repeats__c;j++) {
            
            Integer startWeekPlus = 7 * Integer.valueOf(j);
            DateTime starts =  campaignToClone.Start_Date_Time__c.addDays(startWeekPlus);
            
            Integer endWeekPlus = 7 * Integer.valueOf(j);
            DateTime ends =  campaignToClone.end_Date_Time__c.addDays(endWeekPlus);
            
            //process dst in own method
            // System.debug('***Starts = ' + starts  );
            if (beginZone != dst && tz.getOffset(starts) == dst){
                //  System.debug( '****************** DST************' );
                //  System.debug( starts.addhours(-1) );
                starts = starts.addhours(-1);
                ends = ends.addhours(-1);
                //   System.debug('***Starts = ' + starts  );
            }else  if (beginZone == dst && tz.getOffset(starts) != dst){
                starts = starts.addhours(1);
                ends = ends.addhours(1);
            }
            
            //   System.debug('tz.getOffset: -25200000 Offset: -28800000   =  ' + tz.getOffset(starts));
            
            Campaign cCopy = campaignToClone.clone(false,true);
            
            cCopy.Name= campaignToClone.SeriesName__c + ' - '+ String.valueOf(starts.date().format()) ;
            cCopy.isActive = True;
            cCopy.OwnerID = campaignToClone.OwnerID;
            cCopy.Start_Date_Time__c = starts;
            cCopy.End_Date_Time__c = ends;
            cCopy.Repeats__c = NULL;
            cCopy.isTemplate__c = false;
            System.debug('Childcare' + Childcare);
            if(campaignToClone.CampaignRecordType__c.contains('Program' )){
                System.debug('enter program record type');
                cCopy.recordTypeID = Program.Id;
            }Else
                if(campaignToClone.CampaignRecordType__c.contains('Childcare')){
                    System.debug('Childcare' + Childcare);
                    cCopy.recordTypeID = Childcare.Id;
                    System.debug('cCopy.recordTypeID' + cCopy.recordTypeID);
                    /*  } Else
if(campaignToClone.CampaignRecordType__c.contains('Conference/Event')){
cCopy.recordTypeID = Conference.Id;

} Else
if(campaignToClone.CampaignRecordType__c.contains('Other')){
cCopy.recordTypeID = Other.Id;

} Else
if(campaignToClone.CampaignRecordType__c.contains('SFIN')){
cCopy.recordTypeID = SFIN.Id;

} Else
if(campaignToClone.CampaignRecordType__c.contains('Default')){
cCopy.recordTypeID = Deflt.Id;

} Else
if(campaignToClone.CampaignRecordType__c.contains('Volunteer')){
cCopy.recordTypeID = Volunteer.Id; */
                }Else{
                    System.debug('enter no record type');
                }
            
            createClones.add(cCopy);
            
        }
        System.debug(createClones.size());
        try{
            insert createClones;
            delete deleteCloneOriginal;
            //Add success msg here
        }catch  (exception e) {
            //Add Error msg here
        }
        
        
        
    }
    public void createForm(){
        String soqlForClone = CloneUtils.getCreatableFieldsSOQL('Campaign', templateSelected);
        Campaign cloneReturned = (Campaign)Database.query(soqlForClone);
        System.debug('Clone Returned key fields= ' + cloneReturned.F2F__Community_Services__c  + ' & id = ' + cloneReturned.id);
        Campaign clonedRecord = cloneReturned.clone(false, true,false,false);
        System.debug('Clone Record key fields= ' + clonedRecord.F2F__Community_Services__c  + ' & id = ' + clonedRecord.id);
        insert clonedRecord;
        returnedID = clonedRecord.id;
        editFormID = clonedRecord.id;
        
        
    }
    
    public PageReference cloneTemplate(){
        createForm ();
        System.debug(returnedID + 'returnedID');
        PageReference myVFPage = new PageReference('/apex/CampaignCloneFormVF');
        myVFPage.setRedirect(true);
        myVFPage.getParameters().put('Id', returnedID);
        return myVFPage;
    }
    
    public PageReference cloneChildcareTemplate(){
        createForm ();
        System.debug(returnedID + 'returnedID');
        PageReference myVFPage = new PageReference('/apex/CampaignCloneChildcareVF');
        myVFPage.setRedirect(true);
        myVFPage.getParameters().put('Id', returnedID);
        return myVFPage;
    }
    
    
    public PageReference doClone(){
        update myCampaign;
        CloneCampaignSeries();
        PageReference pageRef = new PageReference('/701/o');
        return pageRef;
    }
    
    
}