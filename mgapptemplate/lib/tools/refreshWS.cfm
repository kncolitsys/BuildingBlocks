 <H2>Webservices in cache:</H2>

 <cfobject action="CREATE" type="JAVA" class="coldfusion.server.ServiceFactory" name="factory">
 <cfset xmlRpc = factory.getXMLRPCService()>
 <cfset webServices = xmlRpc.mappings>

 <cfparam name="url.del" default="false">
 <cfparam name="url.refresh" default="false">
 <cfoutput>
 <cfif url.del>
		<cfloop item="webService" collection="#webServices#">
				<cfset xmlRpc.unregisterWebService(webService)>
		</cfloop>
		<cflocation url="#cgi.script_name#">
 </cfif>
 <cfif url.refresh>
		<cfloop item="webService" collection="#webServices#">
				<cfset xmlRpc.refreshWebService(webService)>
		</cfloop>
		<cflocation url="#cgi.script_name#">
 </cfif>

 <cfloop item="webService" collection="#webServices#">
		- #webService#<BR>
	<cfflush>
 </cfloop>
<BR>
 [<A HREF="#cgi.script_name#?del=1">KILL ALL</A>]
 <BR>
 [<A HREF="#cgi.script_name#?refresh=1">REFRESH ALL</A>]
 </cfoutput>
 <HR>