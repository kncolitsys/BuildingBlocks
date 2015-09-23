<cfcomponent>
	<cfset This.name = "modelglueapplicationtemplate">
	<cfset This.clientmanagement="Yes">
	<cfset This.sessionmanagement="Yes">
	<cfset This.setclientcookies="Yes">
	<cfset This.sessiontimeout="#CreateTimeSpan(0,0,45,0)#">
	
	<cffunction name="onError" output="true">
		<cfargument name="exception" required=true/>
		<cfargument name="eventName" type="String" required=true/>
	</cffunction>	
	
	
	<cffunction name="onRequestStart">
	</cffunction>

</cfcomponent>
