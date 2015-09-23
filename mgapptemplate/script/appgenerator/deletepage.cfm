<cfquery name="session.qpages" dbtype="query">
	select 	id,object,event
	from  	session.qpages
	WHERE 	not id =  '#url.id#'
</cfquery>
<cflocation url="saveapplication.cfm"/>
