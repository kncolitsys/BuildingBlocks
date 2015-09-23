<cfif isdefined("url.id")>
	<cfquery name="qpage" dbtype="query">
		SELECT *
		from session.qpages
		where id = '#url.id#'
	</cfquery>
	<cfset idvalue = qpage.id />
<cfelse>
	Error, no id passed in. <cfabort>
</cfif>
<cfoutput>
<cfset scriptname = replace(getdirectoryfrompath(cgi.SCRIPT_NAME), "/", ".", "ALL") />
<cfset scriptname = mid(scriptname,2, len(scriptname))/>

<cfset page = createobject("component", "#scriptname#.page").init("#qpage.object#", "#qpage.event#") />
<cfset page.applychanges() />
</cfoutput>
<cflocation url="saveapplication.cfm">