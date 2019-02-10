@istest
public class InteractionClone_Test {
    
    static private Integer numAccts = 2;
    static private Integer numContactsPerAcct = 2;
    static date beginDate = date.newInstance(2016, 7, 1);
    static date endDate = date.newInstance(2016, 12, 31);  
    Static  DateTime myDateC = DateTime.newInstance(2014, 9, 30, 8,3, 5);
    
    static testmethod void CloneTest() {
        RecordType rt1 = [Select Id, Name from RecordType where Name = 'Program Campaign' limit 1];
        System.debug(rt1);
        RecordType rt2 = [Select Id, Name from RecordType where Name = 'Default' limit 1];
        /*   Map <Integer, String> esMap =  new Map <Integer, String>{0 =>  'ES3' , 1 =>'ES1', 2 => 'ES2', 
3 =>'ES3', 4 => 'ES1', 5 => 'ES2', 
6 =>'ES3', 7 =>'ES2', 8 => 'ES1', 
9 => 'ES3', 10 =>'ES2',11 =>'ES1'}; */
        
        
        
        npo02__Household__c a = new npo02__Household__c(Name='House-',
                                                        npo02__MailingPostalCode__c ='94110');
        
        insert a;
        
        
        Contact con = (new Contact(firstname='Adult' ,
                                   lastname='Family' ,
                                   RecordTypeID ='012G0000000qhDM',
                                   Family__Primary_Language__c = 'Spanish',
                                   Family__Gender__c = 'Female',
                                   Underserved__c= TRUE,
                                   Low_Income__c= TRUE,
                                   Income__c = 'Homeless',
                                   Housing_Status__c ='Vehicle',
                                   MailingPostalCode = '94124',
                                   lep__c = 'Declined',
                                   Incarcerated_youth__c = True,
                                   
                                   npo02__Household__c=a.Id));
        
        insert con;
        
        
        
        contact chD= (new Contact(firstname='Kid',
                                  lastname='Family-',
                                  Birthdate = beginDate,
                                  RecordTypeID ='012G0000000qhDN',
                                  Family__Primary_Language__c = 'English',
                                  Family__Ethnicity__c ='Hispanic or Latino',
                                  //Ethnicity_Hispanic_Latino_Other__c = 'Central American',
                                  Hispanic_Latino_please_specify__c = 'Central American',
                                  Family__Race__c = 'Asian - Chinese;)',
                                  Race_Other__c = '',
                                  Family__Gender__c = 'Male',
                                  School_Type__c ='Does not apply',
                                  npo02__Household__c=a.Id));
        
        
        Insert chD;
        
        
        
        
        Datetime myDateTime2 = Datetime.newInstance(2016,9, 30);
        
        Case cas =(new Case(ContactId = con.Id,
                            Call_Type__c = 'Contact',
                            Origin = 'In-person',
                            Status = 'Closed',
                            Start_time__c = myDateTime2,
                            Add_5_Mins_to_Start_Time_For_End_Time__c =5,
                            //End_time__c=myDateTime.addDays(j+81),
                            Family__Child__c = chD.ID,
                            Family__Household__c = a.id,
                            RecordTypeId = '012G0000000qhDK'));
        
        
        insert cas;
        
        
        
        
        
        CreateIssue__c ci = new CreateIssue__c();
        ci.Name = 'Default';
        ci.NewIssueURL_1__c = '/a0p/e?&Name=New&retURL=/apex/ManageIssues?Id={!interaction.id}&saveURL=/apex/ManageIssues?Id={!interaction.id}&CF00NG000000Az3xN_lkid=0031100000AnhTa&CF00NG000000Az3xN={!interaction.contactname}&CF00NG000000Ax28T=';
        ci.NewIssueURL_2__c = '{!interaction.childcontact}&CF00NG000000Ax28T_lkid={!interaction.Family__Child__c}&CF00NG000000AyxaG={!interaction.CaseNumber}&CF00NG000000AyxaG_lkid={!interaction.id}&00NG000000Ax23c=New';
        insert ci;
        
        
        
        
        List<Issue__c> Issues = new List<Issue__c>();  
        
        RecordType cntChildRType = [select Id from RecordType where Name = 'Child/Person with Disability' and SobjectType = 'Contact' LIMIT 1];
        RecordType cntAdultRType = [select Id from RecordType where Name = 'Adult' and SobjectType = 'Contact' LIMIT 1];
        
       
        
      
        
        Issue__c issue1 = new Issue__c(Type_of_Issue__c = 'Assessment', Status__c = 'Pending', Issue_Contact__c = con.Id, Interaction_Log__c = cas.Id );
        Issue__c issue2 = new Issue__c(Type_of_Issue__c = 'Behavior', Status__c = 'New', Issue_Contact__c = con.Id, Interaction_Log__c = cas.Id);
        Issue__c issue3 = new Issue__c(Type_of_Issue__c = 'Assessment', Status__c = 'New', Issue_Contact__c = con.Id, Interaction_Log__c = cas.Id);
        
        Issues.add(issue1);
        Issues.add(issue2);
        Issues.add(issue3);
        insert Issues;
        
        
        //Go to Page
        
        
        
        Test.startTest();
        PageReference tpageRef = Page.InteractionCloneVF;
        Test.setCurrentPage(tpageRef);
        tpageRef.getParameters().put('Id', String.valueOf(cas.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(cas);
        //Set Parameters that would be passed in 
        //ApexPages.currentPage().getParameters().get('Id');
        //ApexPages.currentPage().getParameters().put('childobjecttypes', 'Contact');
        
        
        // Instantiate a new controller with all parameters in place
        InteractionClone pcp = new InteractionClone(sc);
        
        //Simulate intial action call on page
        //pcp.initialiseObjectsForCloning();
        
        //Simulate Click Button
        pcp.doClone();
        pcp.save(); 
        test.stopTest();
        //Check there are now two accounts
        /*Account [] testresults = [Select Id, Name from Account WHERE NAME = 'Test A Original' ORDER BY CREATEDDATE ASC];
system.assertequals(2,testresults.size());

//Check there are now two contacts
Contact [] testcresults = [Select Id, LastName, AccountId from CONTACT WHERE AccountId IN :testresults ORDER BY CREATEDDATE ASC];
system.assertequals(2,testcresults.size());

//Confirm Contacts attached to different accounts
system.assertequals(testresults[0].Id, testcresults[0].AccountId);
system.assertequals(testresults[1].Id, testcresults[1].AccountId);*/
    }
}