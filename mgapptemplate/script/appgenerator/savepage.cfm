<cfif form.id eq 0>
	save
	<cfquery name="qmax" dbtype="query">
		SELECT ID
		from session.qpages
		order by id desc
	</cfquery>
	<cfif qmax.id eq ""><cfset nextkey = 1/><cfelse><cfset nextkey = qmax.id + 1/></cfif>
	<cfdump var="#qmax#">
	<cfset QueryAddRow(session.qpages) />
	<cfset QuerySetCell(session.qpages, "id", "#nextkey#") />
	<cfset QuerySetCell(session.qpages, "object", form.object) />
	<cfset QuerySetCell(session.qpages, "event", form.event) />
<cfelse>
	update
	<cfquery name="session.qpages" dbtype="query">
		select 	id,object,event
		from  	session.qpages
		WHERE 	not id =  '#form.id#'
		union 
		select 	'#form.id#' as id,
				'#form.object#' as object, 
				'#form.event#' as event
		from 	session.qpages
		where 	id = '#form.id#'
	</cfquery>
</cfif>
<cflocation url="saveapplication.cfm"/>
