<cfif ((not isdefined("session.qcruds") or not isdefined("session.qpages")) and fileexists( expandpath('../../config/application.xml') )) or isdefined("url.reinit")>
	<cflocation url="loadapplication.cfm"/>
</cfif>
<cfif not isdefined("session.qcruds") or not isdefined("session.qpages")>
	<cfset session.qcruds = QueryNew("id,object,pk,listby,webservicepath,tablename,datasource","varchar,varchar,varchar,varchar,varchar,varchar,varchar") />
	<cfset session.qpages = QueryNew("id,object,event","varchar,varchar,varchar") />
</cfif>
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
<cfoutput>
	<h1>Enterprise Application Blocks (Model-Glue Application)</h1>
	<a href="../../index.cfm"><img src="images/arrow_left.png" /> Back to the Application Root</a><br />
	<a href="update.cfm"><img src="images/arrow_refresh.png" /> Update the EAB code</a><br />
	<cfset scriptname = replace(getdirectoryfrompath(cgi.SCRIPT_NAME), "/", ".", "ALL") />
	<cfset scriptname = mid(scriptname,2, len(scriptname))/>
	<br />
	<br />
	<fieldset>
	<legend>Data Access Pages (CRUD) <a href="editcrud.cfm" title="Add a new set of CRUD pages"><img src="images/add.png" /></a></legend>
	<div>
		<em>In order to keep the data access pages clean, we want to make one set of pages defined around an object(a table in the database).  <br />
		For each entry in Data Access Pages there will be an event created for List, Add, Edit, Save, and Delete.  <br />
		The webservice endpoint must implement get (returns a query), delete, list
		The respective controller will be made to handle this, and in coldspring a definition for a formbean will be made and also a bean that will act as the proxy to the webservice.<br />
		Two views will be created, a form one and a list one.<br />
		Then after creating the CRUD page you can include it in the regular pages below via AJAX, like cfdiv, cflayoutarea, etc.
		</em>
	</div>
	<br />
	<table>
		<tr>
			<td class="tableheader">Action</td>
			<td class="tableheader">Object(Controller Name/Table Name)</td>
			<td class="tableheader">Table's Primary Key</td>
			<td class="tableheader">Table's field to List By for the list event</td>
			<td class="tableheader">Dot Notation Path to the webservice endpoint</td>
			<td class="tableheader">Table Name in the Database</td>
			<td class="tableheader">Datasource name in CF Admin</td>
			<td class="tableheader">Changes Applied Yet?</td>
		</tr>
		<cfloop query="session.qcruds">
			<cfset crud = createobject("component", "#scriptname#.crud").init("#object#", "#pk#","#listby#","#webservicepath#","#tablename#","#datasource#") />
			<tr>
				<td><a href="../../index.cfm?event=list#object#s&#listby#=1" title="Go to event" target="_blank"><img src="images/arrow_left.png" /></a> <a href="editcrud.cfm?id=#id#" title="Edit settings"><img src="images/application_edit.png"/></a> <a onclick="if(confirm('Are you sure you want to delete this page?  No code will be affected.'))return true; return false;" href="deletecrud.cfm?id=#id#" title="Delete this entry"><img src="images/delete.png"/></a></td>
				<td>#object#</td>
				<td>#pk#</td>
				<td>#listby#</td>
				<td>#webservicepath#</td>
				<td>#tablename#</td>
				<td>#datasource#</td>
				<td>
					<cfif crud.changestoapply() neq "">
						Not applied yet - <a href="applycrud.cfm?id=#id#">Click here to apply</a>
						<cfelse>
						Changes already applied.
					</cfif>
				</td>
			</tr>
		</cfloop>
		<cfif session.qcruds.recordcount eq 0>
			<tr>
				<td colspan="5">None - Click the green plus to add Data Access Pages.</td>
			</tr>
		</cfif>
	</table>
	</fieldset>
	<br />
	<br />
	<fieldset>
	<legend>Pages <a href="editpage.cfm" title="Add new page"><img src="images/add.png" /></a></legend>
	<div>
		<em>
			These are regular pages, the bare amount needed to get a page to come up in Model Glue.  <br />
			For each page the ModelGlue.xml definition is made, the controller function is added, and the view is created.
		</em>
	</div>
	<br />
	<table>
		<tr>
			<td class="tableheader">Action</td>
			<td class="tableheader">Object(Controller Name/Table Name)</td>
			<td class="tableheader">Event Name(Think Action like showSplash, it will be in the URL)</td>
			<td class="tableheader">Attached Data Access Pages(add CRUD by editing the page)</td>
			<td class="tableheader">Changes Applied Yet?</td>
		</tr>
		<cfloop query="session.qpages">
			<cfset page = createobject("component", "#scriptname#.page").init("#object#", "#event#") />
			<tr>
				<td><a href="../../index.cfm?event=#event#" target="_blank" title="Go to the event"><img src="images/arrow_left.png" /></a> <a href="editpage.cfm?id=#id#" title="Edit settings"><img src="images/application_edit.png"/></a> <a title="Delete entry" onclick="if(confirm('Are you sure you want to delete this page?  No code will be affected.'))return true; return false;" href="deletepage.cfm?id=#id#"><img src="images/delete.png"/></a></td>
				<td>#object#</td>
				<td>#event#</td>
				<td>
					<cfif fileexists( expandpath('../../views/#session.qpages.object#/dsp#session.qpages.event#.cfm') )>
						<cffile action="read" file="#expandpath('../../views/#session.qpages.object#/dsp#session.qpages.event#.cfm')#" variable="filecontents"/>
						<cfloop query="session.qcruds">
							<cfif not find("cfdiv id=""#session.qcruds.object#listdiv""",filecontents)>
								<cfelse>
								* Has CRUD events for #object#<br />
							</cfif>
						</cfloop>
					</cfif>
				</td>
				<td>
					<cfif page.changestoapply() neq "">
						Not applied yet - <a href="applypage.cfm?id=#id#">Click here to apply</a>
						<cfelse>
						Changes already applied.
					</cfif>
				</td>
			</tr>
		</cfloop>
		<cfif session.qpages.recordcount eq 0>
			<tr>
				<td colspan="5">None - Click the green plus to add a page.</td>
			</tr>
		</cfif>
	</table>
	</fieldset>
</cfoutput>