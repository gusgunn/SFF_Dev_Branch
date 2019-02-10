public with sharing class AddManyAlphaTemplate {
    /**
*  ggunn edited on 2/17/2018.
*/
    //TODO
    // DONE fix formating on text make on table2
    // -- DONE Make alpabet at top and clarify that search is only within the page
    // -- DONE fix find by household name for jump to it
    //- load 10 then allow user to select name or letter and load 200?
    // _TAke out update on process --Make this read only, collect contacts to add and then return to input/update page
    // with fresh campaign spots remaining count
    // Test remove contact

    //DONE - Fixed Colors on header
    //


    // Contact and selection set/variables
    public List<Wrapper> ContactList { get; set; }
    private Set<Id> ContactSelectedSet;
    public Integer ContactSelectedCount { get; set; }
    public String SelectedOneContact { get; set; }


    /**********Campaign stuff **/
    // public  List<CampaignMember> cms {get;set;}
    public String campaignId { get; set; }
    //  public String campaignMemberId {get;set;}
    public Campaign selectedCampaign { get; set; }
    public Boolean submitDisabled { get; set; }  //[Submit Sucessfully only once
    public Boolean processDisabled { get; set; }
    public Map <String, CampaignMember> excludedCms = new Map <String, CampaignMember>();
    private Boolean Checker;
    //  public Boolean disabled {get;set;}
    private List<CampaignMember> Insert_CampaignMembers = new List<CampaignMember>();
    public Map<Id, Wrapper> collectedContactsMap = new Map<Id, Wrapper>();

    /********************/

    /********************/
        public List <Wrapper> CollectedContactsList = new List <Wrapper>();
    public List <Contact> contactUpdates = new List <contact>();
    public List <Wrapper> reorderedContacts = new List <Wrapper>();
    public Transient Boolean recalculateSpots { get; set; }
   
    public Boolean paginationNavigationLock { get; set; }

    // selection and filter
    public List<String> AlphaList { get; set; }
    public String AlphaFilter { get; set; }
    public String SearchName { get; set; }
    public String SearchHousehold {get; set;}
    private String SaveSearchName;
    private String SaveSearchHousehold;
    private String QueryContact;

    // display sort and number
    public String RecPerPage { get; set; }
    public Integer IntPerPage { get; set; }
    public List<SelectOption> RecPerPageOption { get; set; }
    public String SortFieldSave;


    /***/
    public static RecordType rtAdultContact = [SELECT Id FROM RecordType where Name = 'Adult' and SobjectType = 'Contact' LIMIT 1];
    public static RecordType rtChildContact = [SELECT Id, Name from RecordType where Name = 'Child/Person With Disability' and SobjectType = 'Contact' limit 1];
    /***/
    public AddManyAlphaTemplate(ApexPages.StandardController controller) {
        ContactList = new List<Wrapper>();
        ContactSelectedSet = new Set<Id>();
        collectedContactsMap = new Map<Id, Wrapper>();
        paginationNavigationLock = false;
        selectedCampaign = selectedCampaign;
        // updatedAlready.clear();
        contactUpdates.clear();
        excludedCms.clear();
        checker = false;
        recalculateSpots = false;
        campaignId = System.currentPageReference().getParameters().get('pid'); // '701W0000000SuQq'; //

        getCampaignDetails(); //2
        System.debug('constructor cms');
        getCurrentCMS(); //3


        //records for page initialization
        RecPerPageOption = new List<SelectOption>();

        RecPerPageOption.add(new SelectOption('10', '10'));
        RecPerPageOption.add(new SelectOption('25', '25'));
        RecPerPageOption.add(new SelectOption('50', '50'));
        RecPerPageOption.add(new SelectOption('100', '100'));
        RecPerPageOption.add(new SelectOption('300', '300'));
        RecPerPageOption.add(new SelectOption('500', '500'));
        RecPerPageOption.add(new SelectOption('700', '700'));
        RecPerPage = '100'; //default records per page

        // initialization alpha list
        AlphaList = new List<String>{
                'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'Other', 'All'
        };
        SortFieldSave = SortField;

        // alpha filter, use page parameter or set default to all
        if (apexpages.currentPage().getParameters().get('alpha') == null) {
            AlphaFilter = 'All';
        } else {
            AlphaFilter = apexpages.currentPage().getParameters().get('alpha');
        }


        BuildQuery();
    }

    /***
* StdSetControllerContact - paging through the Contact list
***/
    public ApexPages.StandardSetController StdSetControllerContact {
        get {
            if (StdSetControllerContact == null) {
                StdSetControllerContact = new ApexPages.StandardSetController(Database.getQueryLocator(QueryContact));
                // sets the number of records in each page set
                StdSetControllerContact.setPageSize(Integer.valueOf(RecPerPage));
            }
            collectContacts();
            return StdSetControllerContact;
        }
        set;
    }

    public  Wrapper getLastOnPage() {

        return  ContactList != null  && ContactList.size() > 0 ? ContactList[Integer.valueOf(ContactList.size()) - 1] : null; //
    }

    public Integer getReccount() {
        return StdSetControllerContact.getResultSize();
    }

// returns the page number of the current page set
    public Integer getPageTotal() {
        IntPerPage = StdSetControllerContact.getResultSize() / Integer.valueOf(recPerPage) ;

        return IntPerPage != null ? IntPerPage +1 : null;
    }

    // returns the page number of the current page set
    public Integer pageNumber {
        get {
            return StdSetControllerContact.getPageNumber();
        }
        set;
    }

    // returns the first page of records
    public void first() {
        collectContacts();
        StdSetControllerContact.first();
    }

    // returns the last page of records
    public void last() {
        collectContacts();
        StdSetControllerContact.last();
    }


    // returns the PageReference of the original page, if known, or the home page.
    public void cancel() {
        StdSetControllerContact.cancel();
    }


    public void getCampaignDetails() {
        selectedCampaign = [
                Select Id, Name, Start_Date_Time__c, Number_of_child_spots_remaining__c, Checker__c,
                        Maximum_Capacity_Children__c, Presentation_Language__c, Number_of_adult_spots_remaining__c,
                        Language_Interpreter_Services__c, Type, Status, ParentId, RecordTypeId
                FROM Campaign
                WHERE ID = :campaignID
        ];
        Checker = selectedCampaign.Checker__c;
        System.debug('Exit getCampaignDetails ');
        return;
    }


    // 3
    public Map <String, CampaignMember> getCurrentCMS() {
        /* Check here if already CM member */

        System.debug('Enter getCurrentCMS & CampaignID=  ' + campaignId);
        List <CampaignMember> currentCMs = [
                SELECT Id, CampaignId, ContactID, Name
                FROM CampaignMember
                WHERE CampaignId = :campaignId
        ];

        for (CampaignMember c : currentCMs) {
            excludedCMs.put(c.ContactID, c);

        }
        System.debug('Exit getCurrentCMS and there are ' + excludedCMs.size());

        return excludedCMs;
    }


    /***
* getCurrentContactList - return an Contact list for the table
***/
    public List<Wrapper> getCurrentContactList() {

        if (reorderedContacts.size() == 0) {
            System.debug('getCurrentContactList Called at last');
            
            Integer rowCounter = 1;
            ContactList = new List<Wrapper>();
            for (Contact a : (List<Contact>) StdSetControllerContact.getRecords()) {

                ContactList.add(new Wrapper(rowCounter, a, ContactSelectedSet.contains(a.Id)));
                rowCounter += 1;
               // ContactList.add(reorderedContacts);
            }

            //process contact records ** check out original to find loop
            for (Wrapper CM : ContactList) {
                //System.debug('cm.aContact.Id = ' + cm.aContact.Id);
                if (excludedCMs.containsKey(cm.aContact.Id) && ContactList.size() > 0) {
              
                    cm.disabled = true;
                    cm.status = 'Registered';

                }

            }
        } else {

        }

        return ContactList;
    }

    /***
* UpdateContactSelectedSet - add/remove Contacts from the selected Contact id list & count
***/
    public void UpdateContactSelectedSet() {
        for (Wrapper a : ContactList) {
            if (a.aCheckBox == true) {

                ContactSelectedSet.add(a.aContact.Id);
            } else {
                if (ContactSelectedSet.contains(a.aContact.Id)) {
                    ContactSelectedSet.remove(a.aContact.Id);
                }
            }
        }
        ContactSelectedCount = ContactSelectedSet.size();
    }

    public PageReference SearchContact() {
        SaveSearchName = SearchName;
       // SaveSearchHousehold = SearchHousehold;

        BuildQuery();

        return null;
    }

    /***
* BuildQuery - build query command for list selection change
***/
    public void BuildQuery() {

        StdSetControllerContact = null;
        String QueryWhere = '';

        if (AlphaFilter == null || AlphaFilter.trim().length() == 0) {
            AlphaFilter = 'All';
        }

        QueryContact = 'SELECT Id, Name, LastName, email, MobilePhone, Birthdate, MailingPostalCode, Family__Primary_Language__c, npo02__Household__r.ID, npo02__Household__r.Name, RecordTypeID' +
                ' FROM Contact';

        if (AlphaFilter == 'Other') {
            QueryWhere = BuildWhere(QueryWhere, '(' + String.escapeSingleQuotes(SortField) + ' < \'A\' OR ' +
                    String.escapeSingleQuotes(SortField) + ' > \'Z\') AND (NOT ' +
                    String.escapeSingleQuotes(SortField) + ' LIKE \'Z%\') ');
        } else if (AlphaFilter != 'All') {
            QueryWhere = BuildWhere(QueryWhere, '(' + String.escapeSingleQuotes(SortField) + ' LIKE \'' + String.escapeSingleQuotes(AlphaFilter) + '%\')');
        }

        if (SaveSearchName != null) {
            QueryWhere = BuildWhere(QueryWhere, ' (npo02__Household__r.Name LIKE \'%' + String.escapeSingleQuotes(SaveSearchName) + '%\')');
        }
    //    if (SaveSearchHousehold != null) {
        //    QueryWhere = BuildWhere(QueryWhere, '((npo02__Household__r.Name LIKE \'%' + String.escapeSingleQuotes(SaveSearchHousehold) + '%\')))');
           
      //  }

        QueryContact += QueryWhere;
        QueryContact += ' ORDER BY ' + String.escapeSingleQuotes(SortField) + ' ' + String.escapeSingleQuotes(SortDirection) + ' LIMIT 10000';

        system.debug('QueryContact:' + QueryContact);
    }

    /***
* BuildWhere - build soql string for where criteria
***/
    public String BuildWhere(String QW, String Cond) {
        if (QW == '') {
            return ' WHERE ' + Cond;
        } else {
            return QW + ' AND ' + Cond;
        }
    }

    /***
* SortDirection - return sort direction. Default ascending(asc)
***/
    public String SortDirection {
        get {
            if (SortDirection == null) {
                SortDirection = 'asc';
            } return SortDirection;
        }
        set;
    }

    /***
* SortField - return sort by field. Default to Name
***/
    public String SortField {
        get {
            if (SortField == null) {
                SortField = 'LastName';
            } return SortField;
        }
        set;
    }

    /***
* SortToggle - toggles the sorting of query from asc<-->desc
***/
    public void SortToggle() {
        SortDirection = SortDirection.equals('asc') ? 'desc NULLS LAST' : 'asc';
        // reset alpha filter and sort sequence when sorted field is changed
        if (SortFieldSave != SortField) {
            SortDirection = 'asc';
            AlphaFilter = 'All';
            SortFieldSave = SortField;
        }
        // run the query again
        BuildQuery();
    }


    public void processSelected() {
        System.debug('enter  processSelected ContactList siz= ' + ContactList.size());
        ContactList.clear();

        System.debug('ProcessSelected ContactList siz= ' + ContactList.size());
        ContactList.addAll(reorderedContacts);
        processDisabled = true;

        System.debug('added reorderedContacts = ' + reorderedContacts.size() + ' into COntactList= ' + ContactList.size());


    }

    public void collectContacts(){
        for (Wrapper con : ContactList) {

        // if the contact is selected and their ID is not in the currentCM map
        if (con.aCheckBox == true && !collectedContactsMap.containsKey(con.aContact.id)) {
            /*******************************************************************dont want this to clear every time*/
            collectedContactsList.add(con);
            collectedContactsMap.put(con.aContact.id, con);
        }
   }
}
    public void addAllContacts(){
    for (Wrapper con : collectedContactsList) {

        // if the contact is selected and their ID is not in the currentCM map
        if (con.aCheckBox == true && !excludedCms.containsKey(con.aContact.id)) {

            reorderedContacts.add(con);
        }
    }
}

 
    // 5
    public void Submit() {
        System.debug('******************************************SUBMIT');

        paginationNavigationLock = true;
        //List <Contact> alreadyCms = new List <Contact>();

        Insert_CampaignMembers.clear();
        reorderedContacts.clear();
        collectContacts();
        addAllContacts();
        errorCheck(reorderedContacts);
        // need to check for errors here
        if(processDisabled = true) {
            getUpdates(reorderedContacts);
            //System.debug('AddToCampaignsLoop');
            System.debug('sending to ReadyToInsert');
            CreateCampaignMembers(reorderedContacts);
        }

    }
    public void errorCheck(List <Wrapper> reorderedContacts){
        for (Wrapper con : reorderedContacts) {

            if (con.aInterp == true && con.aContact.Family__Primary_language__c == null) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO,
                        ' (' + con.aContact.Name + ' Has no language listed for interpreter). ');
                ApexPages.addMessage(msg);
            } Else{
            }
        }
        
    }

    public void CreateCampaignMembers(List<Wrapper> reorderedContacts) {
        System.debug('Entering to CreateCampaignMembers' + reorderedContacts.size());
        for (Wrapper con : reorderedContacts) {
            CampaignMember CM = new CampaignMember();
            CM.CampaignId = campaignId;

            if (Checker = true) {
                cm.Added_Modified_after_Close__c = true;
            } Else {
                cm.Added_Modified_after_Close__c = false;
            }

            if (con.aSpecial != NULL) {
                CM.Special_Accommodations_Information__c = con.aSpecial;
                //CM.Special_Accommodations__c = true; // auto fills
            } Else {
                CM.Special_Accommodations_Information__c = NULL;
                //  CM.Special_Accommodations__c = false;
            }


            CM.Registration_Status__c = 'Registered';
            CM.Status = con.Status;
            if (con.aInterp == true) {
                CM.Interpreter_Service_Language__c = con.aContact.Family__Primary_language__c;
                CM.Interpreter_Service_Required__c = true;
            } else {
                CM.Interpreter_Service_Required__c = false;
            }


            //contact campaign member
            CM.ContactId = con.aContact.Id;


            //add to the list for insert
            Insert_CampaignMembers.add(CM);
        }
        InsertCampaignMembers(Insert_CampaignMembers);
    }


    public PageReference InsertCampaignMembers(List <CampaignMember> CampaignMembersToInsert) {
        PageReference pageRef;
        if (CampaignMembersToInsert.size() > 0) {
            try {

                insert (CampaignMembersToInsert);


                SubmitDisabled = true;
                recalculateSpots = true;
                //Success message to end user
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO,
                        ' (' + Insert_CampaignMembers.size().format() + ' Contact/s added). ');
                //+  alreadyCms.size().format() + ' Contacts selected who were already members and have been updated).'
                processSelected();
                ApexPages.addMessage(msg);

            } catch (DMLException e) {

                if (e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION, Adult registration for this event is full')) {

                    e.setMessage('Adult registration for this event is full. Please use the waitlist');
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));

                } else if (e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION, Child registration for this event is full')) {

                    e.setMessage('Child registration for this event is full. Please use the waitlist');
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));

                } else if (e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION, Attendee Type Must Match Contact Record Type')) {

                    e.setMessage('Please change Attendee Status and re-submit');
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));

                } else if (e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION, If interpreter service is required, please specify which language')) {

                    e.setMessage('Please select language and re-submit');
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));

                } else if (e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION, Member Status can not be null')) {

                    e.setMessage('Please select Attendee Status');
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));


                } else {


                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,
                            'Error' + e);
                    ApexPages.addMessage(msg);

                }
                SendErrorMessage.getErrors(e);
                processSelected();

            }
        } else {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING,
                    'Please Select At Leat One New Campaign Member');
            ApexPages.addMessage(msg);
        }
        System.debug('******** Returning PageRef on insertContacts');
        return pageRef;

    }


    Integer b = 0;
    public void getUpdates(List <Wrapper> reordered) {
        b += b;
        System.debug('b' + b);
        ContactUpdates.clear();
        System.debug('EnterGetUpdates');
        for (Wrapper c : reordered) {

            // if(!updatedAlready.containsKey(c.aContact.id)){


            Contact CG = new Contact();
            CG.Id = c.aContact.ID;
            CG.Email = c.aContact.Email;
            CG.mobilePhone = c.aContact.MobilePhone;
            CG.npo02__Household__c = c.aContact.npo02__Household__c;
            CG.MailingPostalCode = c.aContact.MailingPostalCode;
            CG.Birthdate = c.aContact.Birthdate;
            CG.Family__Primary_Language__c = c.aContact.Family__Primary_language__c;

            ContactUpdates.add(CG);

        }

        System.debug('ContactUpdates from getUpdates= ' + ContactUpdates.size());
        Try {
            update ContactUpdates;

        } catch (DMLException e) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING,
                    'contact updates failed' + e);
            ApexPages.addMessage(msg);


        }
        System.debug('return from contactUpdates');
       // return reorderedContacts;
    }

    /***
* DoSomethingOne - do something with one selected Contact

    public PageReference DoSomethingOne() {
        system.debug('SelectedOneContact: ' + SelectedOneContact);
        return null;
    } ***/

    /***
* DoSomethingMany - do something with many selected Contacts

public void DoSomethingMany() {
if (ContactSelectedCount>25) {
System.debug('Throw Error here- ContactSelectedCount toomany');
} Else{
System.debug('submitting from doSomethingMany');
Submit();
}
//  return ;
} ***/

    public List<SelectOption> getItems() {

        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', ''));
        options.add(new SelectOption('Family Attendee', 'Family Attendee'));
        options.add(new SelectOption('Child Attendee', 'Child Attendee'));
        options.add(new SelectOption('Professional Attendee', 'Professional Attendee'));
        options.add(new SelectOption('Waitlist Adult', 'Waitlist Adult'));
        options.add(new SelectOption('Waitlist Child', 'Waitlist Child'));
        return options;
    }

}