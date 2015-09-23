<cfquery name="session.qpages" dbtype="query">
	select 	id,object,pk,listby,webservicepath,tablename,datasource
	from  	session.qcruds
	WHERE 	not id =  '#url.id#'
</cfquery>
<cflocation url="saveapplication.cfm"/>
