<cfif isdefined("url.id")>
	<cfquery name="qcrud" dbtype="query">
		SELECT *
		from session.qcruds
		where id = '#url.id#'
	</cfquery>
	<cfset idvalue = qcrud.id />
<cfelse>
	<cfset idvalue = 0 />
	<cfset qcrud = QueryNew("id,object,pk,listby,webservicepath,tablename,datasource") />
</cfif>
<cfoutput>
<h1>Data Access Page (CRUD)</h1>
<table>
<form action="savecrud.cfm" method="post">
	<input type="hidden" name="id" value="#idvalue#" />
<tr>
	<td><strong>Object(Controller Name/Table Name)</strong></td>
	<td><input type="text" name="object" value="#qcrud.object#" /></td>
</tr>
<tr>
	<td><strong>Table's Primary Key</strong></td>
	<td><input type="text" name="pk" value="#qcrud.pk#" /></td>
</tr>
<tr>
	<td><strong>Table's field to List By for the list event</strong></td>
	<td><input type="text" name="listby" value="#qcrud.listby#" /></td>
</tr>
<tr>
	<td><strong>Dot Notation Path to the webservice file</strong></td>
	<td><input type="text" name="webservicepath" value="#qcrud.webservicepath#" /></td>
</tr>
<tr>
	<td><strong>Table Name in the Database</strong></td>
	<td><input type="text" name="tablename" value="#qcrud.tablename#" /></td>
</tr>
<tr>
	<td><strong>Datasource name in CF Admin</strong></td>
	<td><input type="text" name="datasource" value="#qcrud.datasource#" /></td>
</tr>
<tr>
	<td></td>
	<td><input type="submit" value="Save"/></td>
</tr>
</form>
</table>
</cfoutput>