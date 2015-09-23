function donothing()
{
	//do nothing
}

var errorhandler = function(errorCode,errorMessage)

{
	// called if an error happens
	alert("[There Was An Error]" + "\n\n" + "Error Code: " + errorCode + "\n\n" + "Error Message: " + errorMessage);
} 

function saveForm(formname, donefunction) 
{
	var valuelist 	= 	parseform(formname);
	var url			=	"index.cfm?"  + valuelist+ Math.random();
	//alert("form="+formname+" and url="+url);
	ajaxsave( url, donefunction );
} 

function ajaxsave(url,donefunction)
{
	xmlHttp = GetXmlHttpObject();
	if (xmlHttp==null) 
	{
	  alert("Your browser does not support AJAX! - You can not use this feature with this internet browser.");
	  return;
	} 
	xmlHttp.onreadystatechange = function() {
												stateChanged(donefunction);
											}
	xmlHttp.open("POST", url ,true);
	xmlHttp.setRequestHeader( 'Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8' );
	xmlHttp.setRequestHeader( 'Content-Length', url.length );
	xmlHttp.send( url );
}

function getForm(name)
{
	var theform = 0;
	for (var f = 0; f < document.forms.length; f++) 
	{
		if(document.forms[f].name == name)
		{
			theform = document.forms[f];
		}  
	}
	if(theform == 0)
	{
		alert('Error: Could not find form '+ name +' to submit');
	}
	return theform;
}

/* Function to parse through and create a string from a form of all form values */
function parseform(name) 
{
	var getstr = "";
	var theform = getForm(name);

	for(i=0; i<theform.elements.length; i++)
	{
		if(theform.elements[i].type == "checkbox") 
		{
			getstr += theform.elements[i].name + '=' + theform.elements[i].checked + '&';
		}
		else 
		{
			getstr += theform.elements[i].name + '=' + encodeURIComponent(theform.elements[i].value) + '&';
		}
	}
	/* finish up the url string so anything further appended is correct */
	getstr += '1=1';
	return getstr;
}

function stateChanged(donefunction)  
{ 
	if(!donefunction.search(/\(/))
	{
		donefunction = 	donefunction + '()';
	}
	if (xmlHttp.readyState==4) 
	{ 
	  if (xmlHttp.status == 200) 
	  {
		if(xmlHttp.responseText.search(/Error/)>0) 
		{ 	
			alert("There was an error.  Please email the error to Help Desk.");
			eval(donefunction);
		} 
		else 
		{
		}
			eval(donefunction);
	  } 
	  else 
	  {
		alert('There was an error.  Please email Help Desk.');// fall on our sword
		eval(donefunction);
	  }
	}
}


function GetXmlHttpObject() {
var xmlHttp=null;
try {
// Firefox, Opera 8.0+, Safari
  xmlHttp=new XMLHttpRequest();
}

catch (e) {
// Internet Explorer
  try {
	xmlHttp=new ActiveXObject("Msxml2.XMLHTTP");
  }
  
  catch (e)  {
	xmlHttp=new ActiveXObject("Microsoft.XMLHTTP");
  }
}

return xmlHttp;
}    


function changeSelectValue(which, whichvalue)
{
	var whichselect=document.getElementById(which);
	for (i=0; i<whichselect.options.length; i++)
	{
		if(whichselect.options[i].value == whichvalue)
		{
			whichselect.options[i].selected	= true;		
		}
		else
		{
			whichselect.options[i].selected	= false;		
		}
	}
}

function hide(which)
{
	document.getElementById(which).display='none';	
}