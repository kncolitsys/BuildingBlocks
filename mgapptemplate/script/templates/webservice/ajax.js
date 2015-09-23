function add%objectname%(value)
{
	url="index.cfm?event=add%objectname%&%listbytablekey%="+value;
	ColdFusion.navigate(url,'%objectname%div', donothing, errorhandler);	
	ColdFusion.Window.show('%objectname%div');
}
function edit%objectname%(id)
{
	url="index.cfm?event=edit%objectname%&id="+id;
	ColdFusion.navigate(url,'%objectname%div', donothing, errorhandler);	
	ColdFusion.Window.show('%objectname%div');
}
function save%objectname%(id)
{
	ColdFusion.navigate('index.cfm','%objectname%listdiv', donothing, errorhandler, 'post', '%objectname%form');
	ColdFusion.Window.hide('%objectname%div');
}
function delete%objectname%(id)
{
	if(confirm('Are you sure you want to delete this?'))
	{
		url="index.cfm?event=delete%objectname%&id="+id;
		ColdFusion.navigate(url,'%objectname%listdiv', donothing, errorhandler);		
		ColdFusion.Window.hide('%objectname%div');
	}
}
