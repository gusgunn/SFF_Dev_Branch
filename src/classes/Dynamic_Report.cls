public class Dynamic_Report {


    public list<Account> accs1 {set;get;}
    public  integer rows       {set;get;}
    public string selected     {set;get;}
    
    Public Dynamic_Report(){
        accs1=[select id,name,industry from account];
    }
    Public Void setLimit(){
        accs1=[select id,name,industry from account limit 10];  
    }//Dymamic Query
    public Void dynamicSetLimit(){
        accs1=[select id,name,industry from account limit :rows];
    }
    public void dynamicQuery(){
        if(selected!='none'){
        string query = 'select id, name,phone,Industry from Account limit ' +selected;
         accs1=Database.query(query);
        }else{
            accs1=new list<Account>();
        }
    }
}