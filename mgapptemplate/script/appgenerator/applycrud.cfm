<cfif isdefined("url.id")>
	<cfquery name="qcrud" dbtype="query">
		SELECT *
		from session.qcruds
		where id = '#url.id#'
	</cfquery>
<cfelse>
	Error, no id passed in. <cfabort>
</cfif>
<cfoutput>
<cfset scriptname = replace(getdirectoryfrompath(cgi.SCRIPT_NAME), "/", ".", "ALL") />
<cfset scriptname = mid(scriptname,2, len(scriptname))/>


<cfset crud = createobject("component", "#scriptname#.crud").init("#qcrud.object#", "#qcrud.pk#","#qcrud.listby#","#qcrud.webservicepath#","#qcrud.tablename#","#qcrud.datasource#") />
<cfset crud.applychanges() />
</cfoutput>
<cflocation url="saveapplication.cfm">