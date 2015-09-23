<cfif form.id eq 0>
	save
	<cfquery name="qmax" dbtype="query">
		SELECT ID
		from session.qcruds
		order by id desc
	</cfquery>
	<cfif qmax.id eq ""><cfset nextkey = 1/><cfelse><cfset nextkey = qmax.id + 1/></cfif>
	<cfset QueryAddRow(session.qcruds) />
	<cfset QuerySetCell(session.qcruds, "id", "#nextkey#") />
	<cfset QuerySetCell(session.qcruds, "object", form.object) />
	<cfset QuerySetCell(session.qcruds, "pk", form.pk) />
	<cfset QuerySetCell(session.qcruds, "listby", form.listby) />
	<cfset QuerySetCell(session.qcruds, "webservicepath", form.webservicepath) />
	<cfset QuerySetCell(session.qcruds, "tablename", form.tablename) />
	<cfset QuerySetCell(session.qcruds, "datasource", form.datasource) />
<cfelse>
	update
	<cfquery name="session.qcruds" dbtype="query">
		select 	id,object,pk,listby,webservicepath,tablename,datasource
		from  	session.qcruds
		WHERE 	not id =  '#form.id#'
		union 
		select 	'#form.id#' as id,
				'#form.object#' as object, 
				'#form.pk#' as pk,
				'#form.listby#' as listby,
				'#form.webservicepath#' as webservicepath,
				'#form.tablename#' as tablename,
				'#form.datasource#' as datasource
		from 	session.qcruds
		where 	id = '#form.id#'
	</cfquery>
</cfif>
<cflocation url="saveapplication.cfm"/>
