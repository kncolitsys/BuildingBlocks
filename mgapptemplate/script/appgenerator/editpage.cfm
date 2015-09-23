<style>
	.tableheader
	{
		font-weight:bold;
		text-decoration:underline;
	}
	img{
	border:0px
	}
</style>

<cfif isdefined("url.id")>
	<cfquery name="qpage" dbtype="query">
		SELECT *
		from session.qpages
		where id = '#url.id#'
	</cfquery>
	<cfset idvalue = qpage.id />
<cfelse>
	<cfset idvalue = 0 />
	<cfset qpage = QueryNew("id,object,event") />
</cfif>
<cfoutput>
<a href="index.cfm">Back to the main page</a>
<h1>Edit Page</h1>
<br />

<table>
<form action="savepage.cfm" method="post">
	<input type="hidden" name="id" value="#idvalue#" />
	<tr>
		<td><strong>Object</strong><br />
			<em>(Controller Name/Table Name)</em>
		</td>
		<td><input type="text" name="object" value="#qpage.object#" /></td>
	</tr>
	<tr>
		<td><strong>Event Name</strong><br />
		<em>(Think Action like showSplash, it will be in the URL)</em></td>
		<td><input type="text" name="event" value="#qpage.event#" /></td>
	</tr>
	<tr>
		<td></td>
		<td><input type="submit" value="Save"/></td>
	</tr>
</form>
<cfif idvalue neq "0">
	<cfif fileexists( expandpath('../../views/#qpage.object#/dsp#qpage.event#.cfm') )>
		<cffile action="read" file="#expandpath('../../views/#qpage.object#/dsp#qpage.event#.cfm')#" variable="filecontents"/>
	
		<cfloop query="session.qcruds">
			<cfif not find("cfdiv id=""#session.qcruds.object#listdiv""",filecontents)>
				<a href="applycrudtopage.cfm?page_id=#idvalue#&crud_id=#session.qcruds.id#"><img src="images/add.png" />click here to add CRUD events for #object#</a><br />
			<cfelse>
				* Has CRUD events for #object#<br />
			</cfif>
		</cfloop>
	</cfif>
<cfelse>
	* Save and then Apply changes to be able to add CRUD events to this page.
</cfif>
</cfoutput>