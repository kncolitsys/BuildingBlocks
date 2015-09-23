<cfcomponent>
	<cffunction name="introspectMetaData" returntype="any" access="public">
		<cfargument name="thebean">
		<cfset var aboutcfc=structNew() />
		<cfset var thelocalbean = arguments.thebean />
		<cfset aboutcfc = GetMetaData(thelocalbean) />
		<cftry>
			<cfset aboutcfc.functions = thebean.getFields() />
			<cfcatch type="any">
			</cfcatch>		
		</cftry>
		<cfreturn aboutcfc/>
	</cffunction>
</cfcomponent>