<cfcomponent>
	<cfset This.name = "#expandpath('.')#">
	<cfset This.clientmanagement="Yes">
	<cfset This.sessionmanagement="Yes">
	<cfset This.setclientcookies="Yes">
	<cfset This.sessiontimeout="#CreateTimeSpan(0,0,45,0)#">
	
	<cffunction name="onRequestStart">

	</cffunction>

</cfcomponent>

